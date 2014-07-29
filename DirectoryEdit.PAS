Unit DirectoryEdit;
// An edit box that will act as a directory
// changer, with tab completion and enter
// selecting a dir.
Interface

Uses
  Classes, Forms, StdCtrls, SysUtils;

Type
  TNotifyDirChange = procedure( NewDir: string ) of object;

  TDirectoryEdit=Class(TEdit)
  Protected
    FCompletionIndex: longint;
    FCompletionStartPath: string;
    FOnChangeDir: TNotifyDirChange;
    FCompletionSearch: TSearchRec;
    Procedure SetupComponent; Override;
    Procedure ScanEvent( Var KeyCode: TKeyCode;
                         RepeatCount: Byte ); override;
    Procedure CharEvent( Var Key: Char;
                         RepeatCount: Byte ); override;
  Public
    Destructor Destroy; Override;
  Published
    property OnChangeDirectory: TNotifyDirChange read FOnChangeDir write FOnChangeDir;
  End;

// Function returns true if directory Dir exists
Function DirectoryExists( Dir: string ): boolean;

Exports
  TDirectoryEdit,'User','diredit.bmp';

Implementation

Uses
  PMWIN, BseDos;

Function DirectoryExists( Dir: string ):boolean;
Var
  SearchRec: TSearchRec;
  rc: longint;
  DriveMap: LongWord;
  ActualDrive: LongWord;
  Drive: Char;
  DriveNum: longword;
  DriveBit: longword;
Begin
  Result:= false;
  if Dir = '' then
  begin
    Result:= true;
    exit;
  end;
  // remove slash off end if present
  if Dir[ length( dir ) ] in ['\','/'] then
    Delete( Dir, length( Dir ), 1 );

  if length( Dir ) = 2 then
    if Dir[ 2 ] = ':' then
    begin
      // a drive only has been specified, see if it exists
      Drive:= UpCase( Dir[ 1 ] );
      if ( Drive < 'A' ) or ( Drive > 'Z' ) then
        exit;
      DosQueryCurrentDisk( ActualDrive, DriveMap );
      DriveNum:= Ord( Drive ) - Ord( 'A' ) + 1; // A -> 1, B -> 2...
      DriveBit:= 1 shl (DriveNum-1); // 2^DriveNum
      if ( DriveMap and ( DriveBit ) > 0 ) then
        // Yes drive exists
        Result:= true;
      exit;
    end;

  rc:= FindFirst( Dir, faAnyFile, SearchRec );
  if rc = 0 then
    if ( SearchRec.Attr and faDirectory )>0 then
      Result:= true;
  FindClose( SearchRec );
End;

Procedure TDirectoryEdit.SetupComponent;
Begin
  Inherited SetupComponent;
  FCompletionIndex:= 0;
  Name:= 'DirectoryEdit';
End;

Destructor TDirectoryEdit.Destroy;
Begin
  Inherited Destroy;
End;

Procedure TDirectoryEdit.ScanEvent( Var KeyCode: TKeyCode;
                                    RepeatCount: Byte );
Var
  Entry: string;
  rc: longint;
  Dir: string;
Begin
  if KeyCode = kbTab then
  begin
    KeyCode:= kbNull;
    // want to use tab for completion
    if FCompletionIndex = 0 then
    begin
      Entry:= Text;
      Dir:= ExtractFilePath( Entry );
      // starting a completion sequence.
      rc:= FindFirst( Entry+'*',
                      faDirectory,
                      FCompletionSearch );
      FCompletionStartPath:= Dir;
    end
    else
    begin
      // tab repeated; continuing
      rc:= FindNext( FCompletionSearch );
    end;
    while     ( rc = 0 )
          and ( ( FCompletionSearch.Attr and faDirectory ) = 0 )
           or ( FCompletionSearch.Name='.' )
           or ( FCompletionSearch.Name='..' ) do
      rc:= FindNext( FCompletionSearch );

    if rc = 0 then
    begin
      // found summat
      Text:= FCompletionStartPath + FCompletionSearch.Name+'\';
    end
    else
    begin
      // nothing more
      Beep( 1000, 50 );
    end;
    inc( FCompletionIndex );
  end
  else
  begin
    // not a tab
    if FCompletionIndex > 0 then
      FindClose( FCompletionSearch );
    FCompletionIndex:= 0;
    if KeyCode =  kb_VK + VK_NEWLINE then
    begin
      KeyCode:= kbNull;
      // enter key pressed - change dir
      if DirectoryExists( Text ) then
      begin
        if FOnChangeDir <> nil then
           FOnChangeDir( Text )
      end
      else
        Beep( 1000, 50 );
    end
    else if KeyCode = kbCtrlTab then
    begin
       // fake a normal focus shift
       KeyCode:= kbTab;
       Parent.ScanEvent( KeyCode, 1 );
       KeyCode:= kbNull;
    end;
  end;
End;

Procedure TDirectoryEdit.CharEvent( Var Key: Char;
                                    RepeatCount: Byte );
Begin
  if FCompletionIndex > 0 then
    FindClose( FCompletionSearch );
  FCompletionIndex:= 0;
End;

Initialization
  {Register classes}
  RegisterClasses([TDirectoryEdit]);
End.

