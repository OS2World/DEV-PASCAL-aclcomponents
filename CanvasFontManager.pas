Unit CanvasFontManager;

Interface

Uses
  Classes,Forms, PMWIN, Graphics;

Const
  // This defines the fraction of a pixel that
  // font character widths will be given in
  FontWidthPrecisionFactor = 256;

Type
  // a user-oriented specification of a font;
  // does not include OS/2 API data
  TFontSpec= record
    FaceName: string[ 64 ];
    PointSize: integer;
    Attributes: TFontAttributes; // set of faBold, faItalic etc
    Color: TColor;
  end;

  // NOTE: Char widths are in 1/FontWidthPrecisionFactor units
  TCharWidthArray = array[ #0..#255 ] of longint;

  // Used internally for storing full info on font
  TCustomFont= Class( TComponent )
    FaceName: string;
    FontInfo: FONTMETRICS;
    FontType: TFontType;
    PointSize: integer; // only relevant to outline fonts
    CanvasLogicalFontID: integer;
    Attributes: TFontAttributes;

    CharWidthsFetched: boolean;
    CharWidths: TCharWidthArray;
  end;

  TFontFace = class
    Name: string;
    FontType: TFontType;
    Sizes: TList; // relevant for bitmap fonts only
    constructor Create;
    destructor Destroy; override;
  end;

  TCanvasFontManager = class
  protected
    FCanvas: TCanvas;
    FLogicalFontCount: integer;
    FFonts: TList;
    FCurrentFontSpec: TFontSpec;
    FCurrentFont: TCustomFont;

  protected
    function GetFont( Facename: string;
                      PointSize: integer;
                      Attributes: TFontAttributes ): TCustomFont;

    procedure RegisterFont( Font: TCustomFont );
    procedure SelectFont( Font: TCustomFont;
                          Scale: longint );

    // Retrieve character widths for current font
    procedure FetchCharWidths;
  public
    Constructor Create( Canvas: TCanvas );
    destructor Destroy; override;

    // Useful functions:

    // Set the font for the associated canvas.
    procedure SetFont( const FontSpec: TFontSpec );

    // Retrieve the width of the given char, in the current font
    function CharWidth( const C: Char ): longint;

    function CharHeight: longint;
    function CharDescender: longint;

    procedure DrawString( Var Point: TPoint;
                          const Length: longint;
                          const S: PChar );

  end;

// Convert a Sibyl font to a FontSpec (Color is left the same)
procedure SibylFontToFontSpec( Font: TFont; Var FontSpec: TFontSpec );

  // Thoughts on how it works....

  // SelectFont looks for an existing logical font that
  // matches the request. If found selects that logical font
  // onto the canvas.

  // If not found it creates a logical font and selects that onto
  // the canvas.

  // For bitmap fonts the logical font definition includes pointsize
  // For outline fonts the defn is only face+attr; in this case
  // selectfont also ses the 'CharBox' according to the point size.
Implementation

uses
  PMWin, PMGpi, OS2Def, PmDev, SysUtils;


Imports
  Function GpiQueryCharStringPosAt( PS: Hps;
                              StartPoint: PPointL;
                              Options: ULONG;
                              Count: LONG;
                              TheString: PChar;
                              IncrementsArray: PLONG;
                              CharacterPoints: PPointL ): BOOL;
    ApiEntry; 'PMGPI' Index 585;
  Function GpiQueryCharStringPos( PS: Hps;
                              Options: ULONG;
                              Count: LONG;
                              TheString: PChar;
                              IncrementsArray: PLONG;
                              CharacterPoints: PPointL ): BOOL;
    ApiEntry; 'PMGPI' Index 584;
end;

Type
  // A little pretend window to send font name.size
  // and get definite font info back. (See .CreateFont)
  TFontWindow = class( TControl )
  public
    procedure CreateWnd; override;
    property OwnerDraw;
    Function SetPPFontNameSize( Const FNS: String ): Boolean;
  end;

var
  Fonts: TList = nil; // of TFontface
  FontWindow: TFontWindow;

constructor TFontface.Create;
begin
  Sizes:= TList.Create;
end;

destructor TFontface.Destroy;
begin
  Sizes.Destroy;
end;

procedure TFontWindow.CreateWnd;
begin
  inherited CreateWnd;
end;

procedure SibylFontToFontSpec( Font: TFont; Var FontSpec: TFontSpec );
begin
  FontSpec.FaceName:= Font.FaceName;
  FontSpec.PointSize:= Font.PointSize;
  FontSpec.Attributes:= Font.Attributes;
end;

Function TFontWindow.SetPPFontNameSize( Const FNS: String ): Boolean;
Var
  CS: Cstring;
Begin
  CS:= FNS;

  Result := WinSetPresParam( Handle,
                             PP_FONTNAMESIZE,
                             Length( CS ) + 1,
                             CS );
End;

function FindFaceName( Name: string ): TFontFace;
Var
  FontIndex:LongInt;
  AFont:TFontFace;
  AFontName: string;
begin
  Result:= nil;
  Name:= UpperCase( Name );
  for FontIndex:= 0 to Fonts.Count - 1 do
  begin
    AFont:= Fonts[ FontIndex ];
    AFontName:= UpperCase( AFont.Name );

    if AFontName = Name then
    begin
      Result:= AFont;
      break;
    end;
  end;
end;

procedure GetFontList;
Var
  Count: LongInt;
  aPS: HPS;
  T: LongInt;
  Font: TCustomFont;
  Face: TFontFace;
Type
  PMyFontMetrics = ^TMyFontMetrics;
  TMyFontMetrics = Array[ 0..1 ] Of FONTMETRICS;
Var
  pfm: PMyFontMetrics;
Begin
  Fonts:= TList.Create;

  aPS:= WinGetPS( HWND_DESKTOP );
  Count:= 0;
  // Get font count
  Count:= GpiQueryFonts( aPS,
                         QF_PUBLIC,
                         Nil,
                         Count,
                         0,
                         Nil );
  If Count>0 Then
  Begin
    GetMem( pfm, Count * SizeOf( FONTMETRICS ) );
    GpiQueryFonts( aPS,
                   QF_PUBLIC,
                   Nil,
                   Count,
                   SizeOf(FONTMETRICS),
                   pfm^[ 0 ] );

    For T:= 0 To Count-1 Do
    Begin
      Font:= TCustomFont.Create( Screen );
      Font.FontInfo:= pfm^[ T ];
      Face:= FindFaceName( Font.FontInfo.szFaceName );

      // See what type it is. Actually this is not very
      // useful as various substitutions are normally made.
      If Font.FontInfo.fsDefn And FM_DEFN_OUTLINE <> 0 Then
        Font.FontType:= ftOutline
      else
        Font.FontType:= ftBitmap;

      if Face = nil then
      begin
        Face:= TFontFace.Create;
        Face.FontType:= Font.FontType;
        Face.Name:= Font.FontInfo.szFaceName;
        Fonts.Add( Face );
      end;
      Face.Sizes.Add( Font );
    End;
  End;
  FreeMem( pfm, Count * SizeOf( FONTMETRICS ) );
  WinReleasePS( aPS );

  FontWindow.Create( Nil );
  FontWindow.OwnerDraw:= True;
  FontWindow.CreateWnd;
end;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
  Result:= FontName;
  If faItalic in Attrs Then
    Result:= Result + '.Italic';
  If faBold in Attrs Then
    Result:= Result + '.Bold';
  If faOutline in Attrs Then
    Result:= Result + '.Outline';
  If faStrikeOut in Attrs Then
    Result:= Result + '.Strikeout';
  If faUnderScore in Attrs Then
    Result:= Result + '.Underscore';
End;

function CreateFontBasic( FaceName: string;
                          PointSize: integer ): TCustomFont;
var
  PPString: string;
  PresSpace: HPS;
begin
  Result:= TCustomFont.Create( nil );

  if FindFaceName( UpperCase( FaceName ) ) = nil then
    exit;

  Result.PointSize:= PointSize; // will use later if the result was an outline font...
  Result.FaceName:= FaceName;

  // OK now we have found the font face...
  PPString:= IntToStr( PointSize) + '.' + FaceName;

  PPString:= ModifyFontName( PPString, [] );
  If Not FontWindow.SetPPFontNameSize( PPString ) Then
    // Gurk!
    Exit;

  PresSpace:= WinGetPS( FontWindow.Handle );
  If Not GpiQueryFontMetrics( PresSpace,
                              SizeOf( FONTMETRICS ),
                              Result.FontInfo ) Then
  begin
    // Clurkle!?
    WinReleasePS( PresSpace );
    Exit;
  end;
  WinReleasePS( PresSpace );
end;

function CreateFont( FaceName: string;
                     PointSize: integer;
                     Attributes: TFontAttributes ): TCustomFont;
var
  Face: TFontFace;
  PPString: string;
  PresSpace: HPS;
  RemoveBoldFromSelection: boolean;
  RemoveItalicFromSelection: boolean;
  UseFaceName: string;
  UseAttributes: TFontAttributes;
  DontUseStyle: boolean;
  BaseFont: TCustomFont;
  BaseFontIsBitmapFont: Boolean;
begin
  Face:= nil;
  RemoveBoldFromSelection:= false;
  RemoveItalicFromSelection:= false;

  UseAttributes:= Attributes;

  if Attributes <> [] then
  begin
    // First see if the base font (without attributes)
    // would be a bitmap font...
    BaseFont:= CreateFontBasic( FaceName, PointSize );
    if BaseFont = nil then
    begin
      Result:= nil;
      exit;
    end;
    BaseFontIsBitmapFont:= BaseFont.FontInfo.fsDefn And FM_DEFN_OUTLINE = 0;
    BaseFont.Destroy;

    DontUseStyle:= true;

    If not BaseFontIsBitmapFont Then
    begin
      // Result is an outline font so look for specific bold/italic fonts
      DontUseStyle:= false;
      if ( faBold in Attributes )
         and ( faItalic in Attributes ) then
      begin
        Face:= FindFaceName( UpperCase( FaceName ) + ' BOLD ITALIC' );
        if Face <> nil then
        begin
          Exclude( UseAttributes, faBold );
          Exclude( UseAttributes, faItalic );
          RemoveBoldFromSelection:= true;
          RemoveItalicFromSelection:= true;
        end;
      end;

      if Face = nil then
        if faBold in Attributes then
        begin
          Face:= FindFaceName( UpperCase( FaceName ) + ' BOLD' );
          if Face <> nil then
          begin
            Exclude( UseAttributes, faBold );
            RemoveBoldFromSelection:= true;
          end;
        end;

      if Face = nil then
        if faItalic in Attributes then
        begin
          Face:= FindFaceName( UpperCase( FaceName ) + ' ITALIC' );
          if Face <> nil then
          begin
            Exclude( UseAttributes, faItalic );
            RemoveItalicFromSelection:= true;
          end;
        end;
    end;
  end;

  UseFaceName:= FaceName;
  if Face<>nil then
    UseFaceName:= Face.Name;

  if Face = nil then
    Face:= FindFaceName( UpperCase( FaceName ) );

  if Face = nil then
  begin
    Result:= nil;
    // Could not find the specified font name. Bummer.
    exit;
  end;

  Result:= TCustomFont.Create( nil );

  Result.PointSize:= PointSize; // will use later if the result was an outline font...
  Result.FaceName:= FaceName;
  Result.Attributes:= Attributes;

  // OK now we have found the font face...

  // See what kinda font we gonna get...

  // (Hack from Sibyl code - we don't know WTF the algorithm is
  // for selecting between outline/bitmap and doing substitutions
  // so send it to a dummy window and find out the resulting details
  PPString:= IntToStr( PointSize) + '.' + UseFaceName;

  if not DontUseStyle then
    PPString:= ModifyFontName( PPString, UseAttributes );
  If Not FontWindow.SetPPFontNameSize( PPString ) Then
    // Gurk!
    Exit;

  PresSpace:= WinGetPS( FontWindow.Handle );
  If Not GpiQueryFontMetrics( PresSpace,
                              SizeOf( FONTMETRICS ),
                              Result.FontInfo ) Then
  begin
    // Clurkle!?
    WinReleasePS( PresSpace );
    Exit;
  end;
  WinReleasePS( PresSpace );

  // Set style flags
  with Result.FontInfo do
  begin
    // For some reason, the results from the above say that the
    // 'selection' flags for bold/italic are on even if we explicitly
    // asked for a bold and/or italic font. So now we have to remove em!
    if RemoveBoldFromSelection then
      fsSelection:= fsSelection and not fm_SEL_BOLD;

    if RemoveItalicFromSelection then
      fsSelection:= fsSelection and not fm_SEL_ITALIC;


    If faBold in UseAttributes Then
      fsSelection:= FsseleCtioN or fm_SEL_BOLD;
    If faItalic in UseAttributes Then
      fsSelection:= fSselEctIoN or FM_SEL_ITALIC;
    If faUnderScore in UseAttributes Then
      fsSelection:= fsSelection Or FM_SEl_UNdeRSCORe;
    If faStrikeOut in UseAttributes Then
      fsSelection:= fsSelection Or FM_SEl_STriKEOUT;
    If faOutline in UseAttributes Then
      fsSelection:= fsSelection Or FM_SEl_OUtlINE;
  end;

  // We may actually get a bitmap OR an outline font back
  If Result.FontInfo.fsDefn And FM_DEFN_OUTLINE<>0 Then
    Result.FontType:= FtOutline
  else
    Result.FontType:= ftBitmap;

  Result.CharWidthsFetched:= false;
end;

procedure TCanvasFontManager.RegisterFont( Font: TCustomFont );
var
  fa: FATTRS;
begin
  inc( FLogicalFontCount );

  // Initialise GPI font attributes
  FillChar( fa, SizeOf( FATTRS ), 0 );
  fa.usRecordLength:= SizeOf( FATTRS );

  // Copy facename and 'simulation' attributes from what we obtained
  // earlier
  fa.szFaceName:= Font.FontInfo.szFaceName;
  fa.fsSelection:= Font.FontInfo.fsSelection;

  fa.lMatch:=0; // please Mr GPI be helpful and do clever stuff for us, we are ignorant

  fa.idRegistry:= Font.FontInfo.idRegistry; // ? whatever
  fa.usCodePage:=0; // use current codepage

  // If a bitmap font, then copy char cell width/height from the (valid) one we
  // found earlier in GetFont;
  // for outline set them to zero as they are unused
  fa.lMaxbaseLineExt:= Font.FontInfo.lMaxbaselineExt;
  If Font.FontType = ftOutline Then
    fa.lMaxbaseLineExt:= 0;
  fa.lAveCharWidth:= Font.FontInfo.lAveCharWidth;
  If Font.FontType = ftOutline Then
    fa.lAveCharWidth:= 0;

  fa.fsType:=0;

  fa.fsFontUse:=0;

  If Font.FontType = ftOutline Then
    fa.fsFontUse:= FATTR_FONTUSE_OUTLINE Or FATTR_FONTUSE_TRANSFORMABLE;

  Font.CanvasLogicalFontID:= FLogicalFontCount ;
  GpiCreateLogFont( FCanvas.Handle,
                    nil,
                    Font.CanvasLogicalFontID, // create logical font
                    fa );
end;

procedure TCanvasFontManager.SelectFont( Font: TCustomFont;
                                         Scale: longint );
var
  aHDC: HDC;
  xRes, yRes: LongInt;
  aSizeF: SIZEF;
begin
  // Select the logical font
  GpiSetCharSet( FCanvas.Handle, Font.CanvasLogicalFontID );
  if Font.FontType = ftOutline then
  begin
    // For outline fonts, also set character Box
    aHDC:= GpiQueryDevice( FCanvas.Handle );
    DevQueryCaps( aHDC,
                  CAPS_HORIZONTAL_FONT_RES,
                  1,
                  xRes );
    DevQueryCaps( aHDC,
                  CAPS_VERTICAL_FONT_RES,
                  1,
                  yRes );

    aSizeF.CX:= 65536 * xRes* Font.PointSize Div 72 * Scale;
    aSizeF.CY:= 65536 * yRes* Font.PointSize Div 72 * Scale;

    GpiSetCharBox( FCanvas.Handle, aSizeF );
  end;
end;

constructor TCanvasFontManager.Create( Canvas: TCanvas );
begin
  inherited Create;

  if Fonts = nil then
    GetFontList;

  FCanvas:= Canvas;
  FLogicalFontCount:= 0;
  FFonts:= TList.Create;
  FCurrentFontSpec.FaceName:= 'notafont';
  FCurrentFont:= nil;
end;

destructor TCanvasFontManager.Destroy;
var
  i: integer;
  Font: TCustomFont;
begin
  for i:= 1 to FLogicalFontCount -1 do
    GpiDeleteSetID( FCanvas.Handle, i );

  for i:= 0 to FFonts.Count - 1 do
  begin
    Font:= FFonts[ i ];
    Font.Destroy;
  end;
  FFonts.Destroy;
  inherited Destroy;
end;

function TCanvasFontManager.GetFont( Facename: string;
                                     PointSize: integer;
                                     Attributes: TFontAttributes ): TCustomFont;
var
  AFont: TCustomFont;
  FontIndex: integer;
begin
  for FontIndex:= 0 to FFonts.Count - 1 do
  begin
    AFont:= FFonts[ FontIndex ];
    if AFont.PointSize = PointSize then
      if AFont.Attributes = Attributes then
        // search name last since it's the slowest thing
        if AFont.FaceName = FaceName then
        begin
          // Found a logical font already created
          Result:= AFont;
          exit;
        end;
  end;
  // Need to create new logical font
  Result:= CreateFont( FaceName, PointSize, Attributes );
  RegisterFont( Result );
  FFonts.Add( Result );
end;

procedure TCanvasFontManager.SetFont( const FontSpec: TFontSpec );
var
  Font: TCustomFont;
begin
  if FCurrentFontSpec = FontSpec then
    // same font
    exit;

  Font:= GetFont( FontSpec.FaceName, FontSpec.PointSize, FontSpec.Attributes );
  SelectFont( Font, 1 );
  FCanvas.Pen.Color:= FontSpec.Color;
  FCurrentFontSpec:= FontSpec;
  FCurrentFont:= Font;

end;

procedure TCanvasFontManager.FetchCharWidths;
var
  TheChar: Char;
begin
  // Retrieve all character widths
  if FCurrentFont.FontType = ftOutline then
  begin
    SelectFont( FCurrentFont, FontWidthPrecisionFactor );
  end;
  GpiQueryWidthTable( FCanvas.Handle,
                      0, 256,
                      FCurrentFont.CharWidths[ #0 ] );
  if FCurrentFont.FontType = ftOutline then
  begin
    SelectFont( FCurrentFont, 1 );
  end
  else
  begin
    // For bitmap fonts, multiply by 256 manually
    for TheChar := #0 to #255 do
    begin
      FCurrentFont.CharWidths[ TheChar ] :=
        FCurrentFont.CharWidths[ TheChar ]
        * FontWidthPrecisionFactor;
    end;
  end;
  FCurrentFont.CharWidthsFetched:= true;
end;

function TCanvasFontManager.CharWidth( const C: Char ): longint;
begin
  if FCurrentFont = nil then
    raise( Exception.Create( 'No font selected before calling CharWidth!' ) );

  if not FCurrentFont.CharWidthsFetched then
    FetchCharWidths;

  Result:= FCurrentFont.CharWidths[ C ];
end;

function TCanvasFontManager.CharHeight;
var
  fm: FONTMETRICS;
begin
  GpiQueryFontMetrics( FCanvas.Handle,
                       sizeof( fm ),
                       fm );
  Result:= fm.lMaxBaseLineExt;
end;

function TCanvasFontManager.CharDescender;
var
  fm: FONTMETRICS;
begin
  GpiQueryFontMetrics( FCanvas.Handle,
                       sizeof( fm ),
                       fm );
  Result:= fm.lMaxDescender;
end;

procedure TCanvasFontManager.DrawString( Var Point: TPoint;
                                         const Length: longint;
                                         const S: PChar );
begin
  GpiCharStringAt( FCanvas.Handle,
                   Point,
                   Length,
                   S^ );
  Point:= FCanvas.PenPos;
end;

end.