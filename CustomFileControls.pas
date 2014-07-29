Unit CustomFileControls;

// 26/9/0
// Fixed filter combo box for when filter is invalid and results in
// no list entries: crashes because it tries to set item index to 0.
Interface

Uses
  Dos, SysUtils, Classes, Forms, StdCtrls, CustomListBox, Graphics;


Type
    TCustomDirectoryListBox=Class;
    TCustomDriveComboBox=Class;
    TCustomFilterComboBox=Class;

    {ftVolumnID has no effect, but exists For compatibility Of TFileAttr}
    TFileAttr=(ftReadOnly,ftHidden,ftSystem,ftVolumeID,ftDirectory,ftArchive,
         ftNormal);
    TFileType=Set Of TFileAttr;

    TCustomFilelistBox=Class(TCustomListBox)
      Private
         FMask: String;
         FExcludeMask: string;
         FOldMask: String;
         FDirectory: String;
         FOldDirectory: String;
         FFileType: TFileType;
         FOldFileType: TFileType;
         FFileEdit: TEdit;
         FFilterCombo: TCustomFilterComboBox;
         FOnChange: TNotifyEvent;
         FDirList: TCustomDirectoryListBox;
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirectory(NewDir:String);
         Procedure SetFileName(NewFile:String);
         Function GetFileName:String;
         Procedure SetMask(NewMask:String);
         Procedure SetExcludeMask(NewMask:String);
         Procedure SetFileType(Attr:TFileType);
         Procedure SetFileEdit(NewEdit:TEdit);
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemFocus(Index:LongInt);Override;
         Procedure Change;Virtual;
         Property Duplicates;
         Property Sorted;
         Procedure SetupShow;Override;
      Public
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property FileName:String Read GetFileName Write SetFileName;
         Property Directory:String Read FDirectory Write SetDirectory;
         Property Drive:Char Read GetDrive Write SetDrive;
         Procedure Reload;
      Published
         Property FileEdit:TEdit Read FFileEdit Write SetFileEdit;
         Property FileType:TFileType Read FFileType Write SetFileType;
         Property Mask:String Read fMask Write SetMask;
         Property ExcludeMask:String Read fExcludeMask Write SetExcludeMask;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
    End;

    TCustomDirectoryListBox=Class(TListBox)
      Private
         FPictureOpen: TBitmap;
         FPictureClosed: TBitmap;
         FPictureOpenMask: TBitmap;
         FPictureClosedMask: TBitmap;
         FDirectory: String;
         FDirLabel: TLabel;
         FFileList: TCustomFileListBox;
         FOnChange: TNotifyEvent;
         FDriveCombo: TCustomDriveComboBox;
         Procedure SetDirectory(NewDir:String);
         Function GetDrive:Char;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirLabel(ALabel:TLabel);
         Procedure SetFilelistBox(AFileList:TCustomFileListBox);
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Procedure DrawOpenFolder( Var X: longint; Y: LongInt );
         Procedure DrawClosedFolder( Var X: longint; Y: LongInt );
         Procedure MeasureItem(Index:LongInt;Var Width,Height:LongInt);Override;
         Procedure DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);Override;
         Procedure SetupShow;Override;

         Procedure SetPictureOpen(NewBitmap:TBitmap);
         Procedure SetPictureClosed(NewBitmap:TBitmap);

         Property Duplicates;
         Property ExtendedSelect;
         Property MultiSelect;
         Property Sorted;
         Property Style;
         Property OnDrawItem;
         Property OnMeasureItem;
         Property Items;

      Public
         Destructor Destroy; Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Directory:String Read FDirectory Write SetDirectory;
         Property Drive:Char Read GetDrive Write SetDrive;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DirLabel:TLabel Read FDirLabel Write SetDirLabel;
         Property DragCursor;
         Property DragMode;
         Property Enabled;
         Property FileList:TCustomFileListBox Read FFileList Write SetFilelistBox;
         Property Font;
         Property HorzScroll;
         Property IntegralHeight;
         Property ItemHeight;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowDragRects;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property PictureClosed:TBitmap Read FPictureClosed Write SetPictureClosed;
         Property PictureOpen:TBitmap Read FPictureOpen Write SetPictureOpen;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;

    {$HINTS OFF}
    TCustomDriveComboBox=Class(TComboBox)
      Private
         FDrive:Char;
         FDirList:TCustomDirectoryListBox;
         FOnChange:TNotifyEvent;
         Procedure SetDrive(NewDrive:Char);
         Procedure SetDirListBox(ADirList:TCustomDirectoryListBox);
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Property Duplicates;
         Property MaxLength;
         Property SelLength;
         Property SelStart;
         Property SelText;
         Property Sorted;
         Property Style;
         Property TextExtension;
      Public
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Drive:Char Read FDrive Write SetDrive;
         Property Items;
         Property Text;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DirList:TCustomDirectoryListBox Read FDirList Write SetDirListBox;
         Property DragCursor;
         Property DragMode;
         Property DropDownCount;
         Property Enabled;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDropDown;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;
    {$HINTS ON}


    {$HINTS OFF}
    TCustomFilterComboBox=Class(TComboBox)
      Private
         FFilter:String;
         FFileList:TCustomFilelistBox;
         FMaskList:TStringList;
         FOnChange:TNotifyEvent;
         Procedure SetFilter(NewFilter:String);
         Procedure SetFilelistBox(AFileList:TCustomFilelistBox);
         Function GetMask:String;
         Procedure BuildList;
      Protected
         Procedure SetupComponent;Override;
         Procedure Notification(AComponent:TComponent;Operation:TOperation);Override;
         Procedure SetupShow;Override;
         Procedure ItemSelect(Index:LongInt);Override;
         Procedure Change;Virtual;
         Property Duplicates;
         Property Mask:String Read GetMask;
         Property MaxLength;
         Property SelLength;
         Property SelStart;
         Property SelText;
         Property Sorted;
         Property Style;
         Property TextExtension;
      Public
         Destructor Destroy;Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
         Property Items;
         Property Text;
         Property XAlign;
         Property XStretch;
         Property YAlign;
         Property YStretch;
      Published
         Property Align;
         Property Color;
         Property PenColor;
         Property DragCursor;
         Property DragMode;
         Property DropDownCount;
         Property Enabled;
         Property FileList:TCustomFilelistBox Read FFileList Write SetFilelistBox;
         Property Filter:String Read FFilter Write SetFilter;
         Property Font;
         Property ParentColor;
         Property ParentPenColor;
         Property ParentFont;
         Property ParentShowHint;
         Property ShowHint;
         Property TabOrder;
         Property TabStop;
         Property Visible;
         Property ZOrder;

         Property OnCanDrag;
         Property OnChange:TNotifyEvent Read FOnChange Write FOnChange;
         Property OnDragDrop;
         Property OnDragOver;
         Property OnDropDown;
         Property OnEndDrag;
         Property OnEnter;
         Property OnExit;
         Property OnFontChange;
         Property OnKeyPress;
         Property OnMouseClick;
         Property OnMouseDblClick;
         Property OnMouseDown;
         Property OnMouseMove;
         Property OnMouseUp;
         Property OnScan;
         Property OnSetupShow;
         Property OnStartDrag;
    End;
    {$HINTS ON}



Function InsertCustomFilelistBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilelistBox;
Function InsertCustomDirectoryListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDirectoryListBox;
Function InsertCustomDriveComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDriveComboBox;
Function InsertFilterComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilterComboBox;

Exports
  TCustomFileListBox, 'User', 'CustomFileListBox.bmp',
  TCustomDirectoryListBox, 'User', 'CustomDirectoryListBox.bmp';

Exports
  TCustomDriveComboBox, 'User', 'CustomDriveComboBox.bmp';

Exports
  TCustomFilterComboBox, 'User', 'CustomFilterComboBox.bmp';

Implementation

{$IFDEF OS2}
Uses
  BseDos,
{$ENDIF}

{$IFDEF Win95}
  WinBase,
{$ENDIF}
  ACLStringUtility, ACLUtility, ACLFileUtility, BitmapUtility;


{$R FileImages}

Function InsertCustomFilelistBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilelistBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertCustomDirectoryListBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDirectoryListBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertCustomDriveComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomDriveComboBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;


Function InsertFilterComboBox(parent:TControl;Left,Bottom,Width,Height:LongInt):TCustomFilterComboBox;
Begin
     Result.Create(parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.parent := parent;
End;

// ---------------------------------------------------------------------
// TCustomFilelistBox
// ---------------------------------------------------------------------

Procedure TCustomFilelistBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FileListBox';
     Sorted := True;
     FFileType := [ftNormal];
     Mask := '';
     Directory := '';
     ExcludeMask:='';
End;


Procedure TCustomFilelistBox.ItemFocus(Index:LongInt);
Begin
     Inherited ItemFocus(Index);

     Change;
End;


Procedure TCustomFilelistBox.BuildList;
{$IFDEF OS2}
Const AttrSet:Array[TFileAttr] Of Word = (faReadOnly,faHidden,faSysFile,0,faDirectory,faArchive,0);
{$ENDIF}
{$IFDEF WIN32}
Const AttrSet:Array[TFileAttr] Of Word = (faReadOnly,faHidden,faSysFile,0,faDirectory,faArchive,faArchive);
{$ENDIF}
Var  Search:TSearchRec;
     Status:Integer;
     Attr:Word;
     AttrIndex:TFileAttr;
     S,s1:String;
     ExcludeList:TStringList;
     FindIndex:longint;
     ThisFilter: string;
     NextFilter: integer;
Begin
     FOldDirectory:=FDirectory;
     FOldMask:=FMask;
     FOldFileType:=FFileType;

     BeginUpdate;
     Clear;

     Attr := 0;
     For AttrIndex := Low(TFileAttr) To High(TFileAttr) Do
     Begin
          If FFileType * [AttrIndex] <> []
          Then Attr := Attr Or AttrSet[AttrIndex];
     End;

     // First make a list of files to exclude...
     ExcludeList:= TStringList.Create;
     ExcludeList.Sorted:= true;
     S:=fExcludeMask;
     While S<>'' Do
     Begin
          NextFilter:=Pos(';',S);
          If NextFilter<>0 Then
          Begin
            ThisFilter:=Copy( S, 1, NextFilter-1 );
            Delete( S, 1, NextFilter );
          End
          Else
          Begin
            ThisFilter:=S;
            S:='';
          End;

          Status := FindFirst(FDirectory + '\' + ThisFilter, Attr,Search);
          While Status = 0 Do
          Begin
               ExcludeList.Add( Search.Name );
               Status := FindNext(Search);
          End;
     End;

     // Now search for files to include...
     S:=fMask;
     While S<>'' Do
     Begin
          If Pos(';',S)<>0 Then
          Begin
               s1:=S;
               Delete(s1,1,Pos(';',S));
               SetLength(S,Pos(';',S)-1);
          End
          Else s1:='';

          Status := FindFirst(FDirectory + '\' + S, Attr,Search);
          While Status = 0 Do
          Begin
               if not ExcludeList.Find( Search.Name,
                                        FindIndex ) then
               begin
                    If Search.Attr And faDirectory = faDirectory Then
                    Begin
                         Items.Add('['+ Search.Name +']');
                    End
                    Else
                    Begin
                         Items.Add(Search.Name);
                    End;
               end;
               Status := FindNext(Search);
          End;
          S:=s1;
     End;

     ExcludeList.Destroy;
     EndUpdate;
End;


Function TCustomFilelistBox.GetDrive:Char;
Begin
     Result := FDirectory[1];
End;


Procedure TCustomFilelistBox.SetDrive(NewDrive:Char);
Var  NewDir:String;
Begin
     If UpCase(NewDrive) <> UpCase(Drive) Then
     Begin
          {Change To Current Directory At NewDrive}
          {$I-}
          GetDir(Ord(UpCase(NewDrive))-Ord('A')+1, NewDir);
          {$I+}
          If IOResult = 0 Then SetDirectory(NewDir);
     End;
End;

Procedure TCustomFilelistBox.SetDirectory(NewDir:String);
Var s:String;
Begin
     If NewDir = '' Then
     Begin
          {$I+}
          GetDir(0,NewDir);
          {$I-}
     End;

     If Pos(':',NewDir)<>2 Then
     Begin
          {$I+}
          GetDir(Ord(UpCase(Drive))-Ord('A')+1,s);
          {$I-}
          If (s[length(s)])='\' Then dec(s[0]);
          If not (NewDir[1] In ['/','\']) Then s:=s+'\';
          NewDir:=s+NewDir;
     End;

     If NewDir[Length(NewDir)] = '\' Then SetLength(NewDir,Length(NewDir)-1);
     If FDirectory=NewDir Then exit;
     FDirectory := NewDir;

     If Handle<>0 Then BuildList;
     Change;
     If FDirList <> Nil Then
     Begin
          If uppercase(FDirList.Directory) <> uppercase(Directory)
          Then FDirList.Directory := Directory;
     End;

End;


Procedure TCustomFilelistBox.SetFileName(NewFile:String);
Var Dir,Name,Ext:String;
Begin
     If GetFileName <> NewFile Then
     Begin
          FSplit(NewFile,Dir,Name,Ext);
          If Dir='' Then
          Begin
              ItemIndex := Items.IndexOf(NewFile);
              Change;
          End
          Else
          Begin
              SetDirectory(Dir);
              SetFileName(Name+Ext);
          End;
     End;
End;


Function TCustomFilelistBox.GetFileName:String;
Var  idx:LongInt;
     s:String;
Begin
     idx := ItemIndex;
     If (idx < 0) Or (idx >= Items.Count) Then Result := ''
     Else Result := Items[idx];
     s:=Directory;
     If s[Length(s)] In ['\','/'] Then dec(s[0]);
     If s<>'' Then If Result<>'' Then Result:=s+'\'+Result;
End;


Procedure TCustomFilelistBox.SetMask(NewMask:String);
Begin
     If NewMask <> '' Then
     Begin
          If FMask=NewMask Then exit;
          FMask := NewMask
     End
     Else
     Begin
          If FMask='*' Then exit;
          FMask := '*';
     End;

     If Handle<>0 Then BuildList;
     Change;
End;

Procedure TCustomFilelistBox.SetExcludeMask(NewMask:String);
Begin
     If FExcludeMask=NewMask Then
       exit;
     FExcludeMask := NewMask;
     If Handle<>0 Then BuildList;
     Change;
End;

Procedure TCustomFilelistBox.SetFileEdit(NewEdit:TEdit);
Begin
     FFileEdit := NewEdit;
     If FFileEdit <> Nil Then
     Begin
          FFileEdit.FreeNotification(Self);
          If FileName <> '' Then FFileEdit.Caption := FileName
          Else FFileEdit.Caption := Mask;
     End;
End;


Procedure TCustomFilelistBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFileEdit Then FFileEdit := Nil;
End;


Procedure TCustomFilelistBox.SetFileType(Attr:TFileType);
Begin
     If FFileType <> Attr Then
     Begin
          FFileType := Attr;
          If Handle<>0 Then BuildList;
          Change;
     End;
End;


Procedure TCustomFilelistBox.Change;
Begin
     If FFileEdit <> Nil Then
     Begin
          If FileName <> '' Then FFileEdit.Caption := FileName
          Else FFileEdit.Caption := Mask;

          FFileEdit.SelectAll;
     End;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Function TCustomFilelistBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

Procedure TCustomFilelistBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;

Procedure TCustomFilelistBox.Reload;
Begin
     StartUpdate;
     If Handle<>0 Then BuildList;
     CompleteUpdate;
End;

// ---------------------------------------------------------------------
// CustomDirectoryListBox
// ---------------------------------------------------------------------

const
  dfSubDir = 256;

Procedure TCustomDirectoryListBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'DirectoryListBox';

     Directory := '';

     Style:=lbOwnerDrawFixed;

     FDriveCombo:= nil;

     FPictureOpen:= TBitmap.Create;
     FPictureOpen.LoadFromResourceName( 'FolderOpen' );
     CreateMaskedBitmap( FPictureOpen, FPictureOpenMask );

     FPictureClosed:= TBitmap.Create;
     FPictureClosed.LoadFromResourceName( 'FolderClosed' );
     CreateMaskedBitmap( FPictureClosed, FPictureClosedMask );
End;

Destructor TCustomDirectoryListBox.Destroy;
begin
  FPictureOpen.Free;
  FPictureClosed.Free;
  inherited Destroy;
end;

Procedure TCustomDirectoryListBox.MeasureItem(Index:LongInt;Var Width,Height:LongInt);
Begin
   Inherited MeasureItem(Index,Width,Height);
   If Height<15 Then Height:=15;
End;

Procedure TCustomDirectoryListBox.DrawItem(Index:LongInt;rec:TRect;State:TOwnerDrawState);
Var
  X,Y,Y1,CX,CY,cx1,cy1:LongInt;
  S: String;
  Data: longint;
  IndentLevel: longint;
Begin
  If State * [odSelected] <> [] Then
  Begin
    Canvas.Pen.color := clHighlightText;
    Canvas.Brush.color := clHighlight;
  End
  Else
  Begin
    Canvas.Pen.color := PenColor;
    Canvas.Brush.color := color;
  End;
  dec( rec.top ); // minor adjustments since we seem to get a slightly
  inc( rec.left ); // incorrect area to draw on...
  Canvas.FillRect(rec,Canvas.Brush.color);

  X := rec.Left + 1;
  Y := rec.Bottom + 1;
  CX := rec.Right - X;
  CY := rec.Top - Y;

  S := Items[ Index ];
  Data:= longint( Items.Objects[ Index ] );
  IndentLevel:= Data and 255;

  inc( X, IndentLevel * 5 );

  Y1:=Y+((CY-13) Div 2);
  If Y1 < rec.Bottom+1 Then
    Y1 := rec.Bottom+1;
  inc(Y1);

  if ( Data and dfSubDir ) = 0 Then
    DrawOpenFolder(X,Y1)
  Else
    DrawClosedFolder(X,Y1);

  inc( X, 5 );

  Canvas.GetTextExtent(S,cx1,cy1);
  Y := Y + ((CY - cy1) Div 2);
  If Y < rec.Bottom Then Y := rec.Bottom;
  Canvas.Brush.Mode := bmTransparent;
  Canvas.TextOut(X,Y,S);
  Canvas.Brush.Mode := bmOpaque;
End;

Procedure TCustomDirectoryListBox.DrawOpenFolder( Var X: longint; Y: LongInt );
Var
  SaveBrushColor,SavePenColor:TColor;
Begin
  SaveBrushColor:=Canvas.Brush.Color;
  SavePenColor:=Canvas.Pen.Color;

  DrawMaskedBitmap( FPictureOpen,
                    FPictureOpenMask,
                    Canvas,
                    X, Y );

  if FPictureOpen <> nil then
    inc( X, FPictureOpen.Width );

  Canvas.Brush.Color:=SaveBrushColor;
  Canvas.Pen.Color:=SavePenColor;
End;

Procedure TCustomDirectoryListBox.DrawClosedFolder( Var X: longint; Y: LongInt );
Var
  SaveBrushColor,SavePenColor:TColor;
Begin
  SaveBrushColor:=Canvas.Brush.Color;
  SavePenColor:=Canvas.Pen.Color;

  DrawMaskedBitmap( FPictureClosed,
                    FPictureClosedMask,
                    Canvas,
                    X, Y );

  if FPictureClosed <> nil then
    inc( X, FPictureClosed.Width );

  Canvas.Brush.Color:=SaveBrushColor;
  Canvas.Pen.Color:=SavePenColor;
End;

Procedure TCustomDirectoryListBox.ItemSelect(Index:LongInt);
Var
  S: String;
  Data: longint;
  FullPath: string;
Begin
  If (Index < 0) Or (Index > Items.Count-1) Then Exit;

  FullPath:= Items[ Index ];
  dec( Index );
  while Index >= 0 do
  begin
    S := Items[ Index ];
    Data:= longint( Items.Objects[ Index ] );
    if ( Data and dfSubDir ) = 0 then
      FullPath:= AddSlash( S ) + FullPath;
    dec( Index );
  end;

  Directory:= FullPath;

  Inherited ItemSelect(Index);
End;

Procedure TCustomDirectoryListBox.BuildList;
Var
  S: String;
  Search: TSearchRec;
  Status: Integer;
  Path: string;
  SubDirs: TStringList;
  IndentLevel: longint;
Begin
  BeginUpdate;

  IndentLevel:= 0;

  //Add Drive
  Items.Clear;
  Items.AddObject(Drive+':\', pointer( IndentLevel ) );

  //Add all subdirs
  Path:= Copy( Directory, 4, 255 );
  While Path <> '' Do
  Begin
    inc( IndentLevel );
    S:= ExtractNextValue( Path, '\' );
    Items.AddObject( S, pointer( IndentLevel ) );
  End;

  ItemIndex:= Items.Count - 1;

  inc( IndentLevel );

  SubDirs:= TStringList.Create;
  Status := FindFirst( AddSlash( Directory ) + '*.*', faDirectory, Search);
  While Status = 0 Do
  Begin
    S := Search.Name;
    If Search.Attr And faDirectory = faDirectory Then
    Begin
      {avoid .. In Mainpath}
      If ( S <> '.' )
         and ( S <> '..' ) Then
        SubDirs.AddObject( S, pointer( IndentLevel + dfSubDir ) );
    End;
    Status := FindNext( Search );
  End;
  FindClose( Search );

  SubDirs.Sort;
  Items.AddStrings( SubDirs );
  SubDirs.Destroy;

  EndUpdate;
End;


Procedure TCustomDirectoryListBox.SetDirectory(NewDir:String);
Var
  s: String;
Begin
  If NewDir = '' Then
  Begin
    {$I+}
    GetDir(0,NewDir);
    {$I-}
  End;

  If Pos(':',NewDir)<>2 Then
  Begin
    {$I+}
    GetDir(Ord(UpCase(Drive))-Ord('A')+1,s);
    {$I-}
    S:= RemoveSlash( S );
    s:= AddSlash( S );
    NewDir:=s+NewDir;
  End;

  NewDir:= RemoveSlash( NewDir );
  If FDirectory = NewDir Then
    exit;

  FDirectory := NewDir;

  If Handle<>0 Then
    BuildList;

  If FDriveCombo <> Nil Then
  Begin
    If UpCase( FDriveCombo.Drive ) <> UpCase( Drive ) Then
      FDriveCombo.Drive := Drive;
  End;

  Change;

End;


Procedure TCustomDirectoryListBox.SetDrive(NewDrive:Char);
Var  NewDir:String;
Begin
     If UpCase(NewDrive) <> UpCase(Drive) Then
     Begin
          {Change To Current Directory At NewDrive}
          {$I-}
          GetDir(Ord(UpCase(NewDrive))-Ord('A')+1, NewDir);
          {$I+}
          If IOResult = 0 Then SetDirectory(NewDir);
     End;
End;


Function TCustomDirectoryListBox.GetDrive:Char;
Begin
     Result := FDirectory[1];
End;


Procedure TCustomDirectoryListBox.SetDirLabel(ALabel:TLabel);
Begin
     FDirLabel := ALabel;
     If FDirLabel <> Nil Then
     Begin
          FDirLabel.FreeNotification(Self);
          FDirLabel.Caption := FDirectory;
     End;
End;


Procedure TCustomDirectoryListBox.SetFileListBox(AFileList:TCustomFileListBox);
Begin
     If FFileList <> Nil Then FFileList.FDirList := Nil;
     FFileList := AFileList;
     If FFileList <> Nil Then
     Begin
          FFileList.FDirList := Self;
          FFileList.FreeNotification(Self);
     End;
End;


Procedure TCustomDirectoryListBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
     Begin
          If AComponent = FFileList Then
            FFileList := Nil;
          If AComponent = FDirLabel Then
            FDirLabel := Nil;
     End;
End;


Procedure TCustomDirectoryListBox.Change;
Begin
     If FDirLabel <> Nil Then
       FDirLabel.Caption := FDirectory;
     If FFileList <> Nil Then
       FFileList.Directory := FDirectory;

     If FOnChange <> Nil Then FOnChange(Self);
End;

Function TCustomDirectoryListBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;

Procedure TCustomDirectoryListBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;

Procedure TCustomDirectoryListBox.SetPictureClosed( NewBitmap: TBitmap );
Begin
  StoreBitmap( FPictureClosed, FPictureClosedMask, NewBitmap );
  Invalidate;
End;

Procedure TCustomDirectoryListBox.SetPictureOpen( NewBitmap: TBitmap );
Begin
  StoreBitmap( FPictureOpen, FPictureOpenMask, NewBitmap );
  Invalidate;
End;

// ---------------------------------------------------------------------
// TCustomDriveComboBox
// ---------------------------------------------------------------------

Procedure TCustomDriveComboBox.SetupComponent;
Var  DriveMap:LongWord;
     SDrive:Byte;
     actdir:String;
     {$IFDEF OS2}
     ActualDrive:LongWord;
     {$ENDIF}
Begin
     Inherited SetupComponent;

     Name := 'DriveComboBox';
     Style := csDropDownList;
     sorted := False;

     {Fill Drive Combo}
     {$IFDEF OS2}
     DosQueryCurrentDisk(ActualDrive,DriveMap);
     {$ENDIF}
     {$IFDEF Win95}
     DriveMap := GetLogicalDrives;
     {$ENDIF}
     For SDrive := 0 To 25 Do
     Begin
          If DriveMap And (1 Shl SDrive) <> 0 Then
          Begin
               actdir := Chr(SDrive + 65) + ':';
               Items.Add(actdir);
          End;
     End;

     {$I-}
     GetDir(0,actdir);
     {$I+}
     Drive := actdir[1];
End;


Procedure TCustomDriveComboBox.ItemSelect(Index:LongInt);
Var  S:String;
Begin
     Inherited ItemSelect(Index);

     S := Text;
     If S <> '' Then Drive := S[1];
End;


Procedure TCustomDriveComboBox.Change;
Begin
     If FDirList <> Nil Then FDirList.Drive := FDrive;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TCustomDriveComboBox.SetDrive(NewDrive:Char);
Var S:String;
    T:LongInt;
    C:cstring;
    cc:^cstring;
    {$IFDEF Win95}
    sernum,complen,Flags:LongWord;
    FileSystem,volname:cstring;
    {$ENDIF}
Label L;
Begin
     NewDrive := UpCase(NewDrive);
     If UpCase(FDrive) = NewDrive Then Exit;

     S := Text;
     If NewDrive <> S[1] Then
     Begin
          For T := 0 To Items.Count-1 Do
          Begin
               S := Items.Strings[T];
               If UpCase(S[1]) = NewDrive Then
               Begin
                    Text := S;
                    Goto L;
               End;
          End;
          {Not found In List}
          NewDrive := FDrive;  {Use Current Drive}
     End;
L:
     FDrive := NewDrive;
     If Pos('[',S) = 0 Then
     Begin
          {determine volume id's}
          T := Items.IndexOf(S);
          If T <> -1 Then
          Begin
               FillChar(C,255,0);
               {$IFDEF OS2}
               DosErrorAPI(FERR_DISABLEHARDERR);      {no effect}
               DosQueryFSInfo(Ord(S[1])-64,FSIL_VOLSER,C,255);
               DosErrorAPI(FERR_ENABLEHARDERR);
               cc := @C[5];
               If cc^ <> '' Then S := S +' ['+ cc^ +']';
               {$ENDIF}
               {$IFDEF Win95}
               C := S[1] + ':\';
               volname := '';
               GetVolumeInformation(C,volname,255,sernum,complen,Flags,
                                    FileSystem,255);
               If volname <> '' Then S := S + ' ['+ volname +']';
               {$ENDIF}
               Text := S;
               Items[T] := S;
          End;
     End;

     Change;
End;


Procedure TCustomDriveComboBox.SetDirListBox(ADirList:TCustomDirectoryListBox);
Begin
     If FDirList <> Nil Then FDirList.FDriveCombo := Nil;
     FDirList := ADirList;
     If FDirList <> Nil Then
     Begin
          FDirList.FDriveCombo := Self;
          FDirList.FreeNotification(Self);
     End;
End;


Procedure TCustomDriveComboBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FDirList Then
         FDirList := Nil;
End;


Function TCustomDriveComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;


// ---------------------------------------------------------------------
// TCustomFilterComboBox
// ---------------------------------------------------------------------

Procedure TCustomFilterComboBox.SetupComponent;
Begin
     Inherited SetupComponent;

     Name := 'FilterComboBox';
     Style := csDropDownList;
     sorted := False;

     FFilter := LoadNLSStr(SAllFiles)+' (*.*)|*.*';
     FMaskList.Create;
End;


Procedure TCustomFilterComboBox.SetupShow;
Begin
     Inherited SetupShow;

     BuildList;
End;


Destructor TCustomFilterComboBox.Destroy;
Begin
     FMaskList.Destroy;
     FMaskList := Nil;

     Inherited Destroy;
End;


Procedure TCustomFilterComboBox.ItemSelect(Index:LongInt);
Begin
     Inherited ItemSelect(Index);

     Text := Items[Index];
     Change;
End;


Procedure TCustomFilterComboBox.Change;
Begin
     If FFileList <> Nil Then FFileList.Mask := Mask;

     If FOnChange <> Nil Then FOnChange(Self);
End;


Procedure TCustomFilterComboBox.BuildList;
Var  AMask,AFilter:String;
     S:String;
     P:Integer;
Begin
     BeginUpdate;
     Clear;
     FMaskList.Clear;

     S := FFilter;
     P := Pos('|',S);
     While P > 0 Do
     Begin
          AFilter := Copy(S,1,P-1);
          Delete(S,1,P);
          P := Pos('|',S);
          If P > 0 Then
          Begin
               AMask := Copy(S,1,P-1);
               Delete(S,1,P);
          End
          Else
          Begin
               AMask := S;
               S := '';
          End;
          Items.Add(AFilter);
          FMaskList.Add(AMask);
          P := Pos('|',S);
     End;
     EndUpdate;
     if Items.Count > 0 then
       ItemIndex := 0;
End;


Procedure TCustomFilterComboBox.SetFilter(NewFilter:String);
Begin
     If FFilter <> NewFilter Then
     Begin
          FFilter := NewFilter;
          BuildList;
          Change;
     End;
End;


Procedure TCustomFilterComboBox.SetFilelistBox(AFileList:TCustomFilelistBox);
Begin
     If FFileList <> Nil Then FFileList.FFilterCombo := Nil;
     FFileList := AFileList;
     If FFileList <> Nil Then
     Begin
          FFileList.FFilterCombo := Self;
          FFileList.FreeNotification(Self);
     End;
End;


Procedure TCustomFilterComboBox.Notification(AComponent:TComponent;Operation:TOperation);
Begin
     Inherited Notification(AComponent,Operation);

     If Operation = opRemove Then
       If AComponent = FFileList Then FFileList := Nil;
End;


Function TCustomFilterComboBox.GetMask:String;
Var  idx:LongInt;
Begin
     idx := ItemIndex;
     If (idx < 0) Or (idx >= FMaskList.Count) Then Result := '*.*'
     Else Result := FMaskList[idx];
End;


Function TCustomFilterComboBox.WriteSCUResource(Stream:TResourceStream):Boolean;
Begin
     {don't Write contents To SCU}
     Result := TControl.WriteSCUResource(Stream);
End;


Begin
End.


