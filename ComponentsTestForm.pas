Unit ComponentsTestForm;

Interface

Uses                  
  Classes, Forms, Graphics, RichTextView, Buttons, TabCtrls, ComCtrls,
  Outline2, ExtCtrls,
  ACLDialogs, ColorWheel,
  CustomCheckListBox, CustomDirOutline,
  CustomListBox, CustomMemo,
  CustomOutline,
  DirectoryEdit,
  Coolbar2, SplitBar,
  ControlsUtility, FileCtrl, StdCtrls, CustomFileControls,
  CustomFontDialog,
  MultiColumnListBox, CoolBar, Test, HT; // menus for SPCC v2.5+

type
  TScanParameters = class
    Path: string;
  end;

  TComponentsTestForm = Class (TForm)
    TabbedNotebook1: TTabbedNotebook;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu5: TMainMenu;
    ImageList2: TImageList;
    Button7: TButton;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    Button6: TButton;
    RadioGroup1: TRadioGroup;
    Button3: TButton;
    Button8: TButton;
    FileListBox1: TCustomFilelistBox;
    DriveComboBox2: TCustomDriveComboBox;
    DirectoryListBox1: TCustomDirectoryListBox;
    Button4: TButton;
    Button5: TButton;
    RT: TRichTextView;
    Button2: TButton;
    Button1: TButton;
    AnOutline: TOutline2;
//    AnOutline: TOutline2;
    Procedure Button7OnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: LongInt; Y: LongInt);
    Procedure Button6OnClick (Sender: TObject);
    Procedure CoolBar1OnSectionClick (HeaderControl: THeaderControl;
      section: THeaderSection);
    Procedure Button8OnClick (Sender: TObject);
    Procedure Button7OnClick (Sender: TObject);
    Procedure Button5OnClick (Sender: TObject);
    Procedure Button4OnClick (Sender: TObject);
    Procedure Button3OnClick (Sender: TObject);
    Procedure RTOnClickLink (Sender: TRichTextView; Link: String);
    Procedure RTOnOverLink (Sender: TRichTextView; Link: String);
    Procedure RichTextView1OnOverLink (Sender: TRichTextView; Link: String);
    Procedure Button2OnClick (Sender: TObject);
    Procedure TabbedNotebook1OnSetupShow (Sender: TObject);
    Procedure MainFormOnCreate (Sender: TObject);
    Procedure RTOnSetupShow (Sender: TObject);
    Procedure MainFormOnShow (Sender: TObject);
    Procedure Button1OnClick (Sender: TObject);
  Protected
    procedure OnOutlineEvent( Node: TNode );
  End;

Var
  ComponentsTestForm: TComponentsTestForm;

Implementation

uses
  Dialogs, SysUtils, ControlScrolling;

Procedure TComponentsTestForm.Button7OnMouseDown (Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X: LongInt; Y: LongInt);
Begin

End;

Procedure TComponentsTestForm.Button6OnClick (Sender: TObject);
var
  s: tstringlist;
  i: longint;
Begin
  ListBox1.Sorted := not ListBox1.Sorted;
  s:= tstringlist.create;
  s.addObject( '5', pointer( 5 ) );
  s.addObject( '4', pointer( 4 ) );
  ListBox1.Items.AddStrings( s );
  s.destroy;
  for i:= 0 to ListBox1.Items.Count -1 do
  begin
    assert( StrToInt( ListBox1.Items[ i ] )
            = longint( ListBox1.Items.Objects[ i ] ) );
  end;
End;

Procedure TComponentsTestForm.CoolBar1OnSectionClick (HeaderControl: THeaderControl; section: THeaderSection);
Begin

End;

Procedure TComponentsTestForm.Button8OnClick (Sender: TObject);
Begin
//  DirectoryListBox1.Directory:= DriveComboBox3.Drive + ':\';
End;

Procedure TComponentsTestForm.Button7OnClick (Sender: TObject);
Begin
End;


Procedure TComponentsTestForm.Button5OnClick (Sender: TObject);
Begin
  AnOutline.GotoNextNodeDown;
End;

Procedure TComponentsTestForm.Button4OnClick (Sender: TObject);
Begin
  AnOutline.GotoNextNodeUp;
End;

Procedure TComponentsTestForm.Button3OnClick (Sender: TObject);
var
  M1, M2, M3: longword;
Begin
  M1:= MemAvail;
  AnOutline.Clear;
  StatusBar.SimpleText:= 'Mem freed from outline: ' + IntToStr( MemAvail - M1  );
End;

Procedure TComponentsTestForm.RTOnClickLink (Sender: TRichTextView;
  Link: String);
Begin
  ShowMessage( 'You clicked: ' + Link );
End;

Procedure TComponentsTestForm.RTOnOverLink (Sender: TRichTextView;
  Link: String);
Begin
  StatusBar.SimpleText:= 'Link to: ' + Link;
  StatusBar.Refresh;
End;

Procedure TComponentsTestForm.RichTextView1OnOverLink (Sender: TRichTextView;
  Link: String);
Begin

End;

Procedure TComponentsTestForm.Button2OnClick (Sender: TObject);
Begin
  DoConfirmDlg( 'Test', 'THis is the prompt you should be seeing' );
End;

Procedure TComponentsTestForm.TabbedNotebook1OnSetupShow (Sender: TObject);
Begin
End;

Procedure TComponentsTestForm.MainFormOnCreate (Sender: TObject);
var
  DirList: TCustomDirectoryListBox;
  DriveCombobox: TCustomDriveComboBox;
  ca: array[ 0..50000 ] of char;
Begin
  ListBox1.Items.addObject( '9', pointer( 9 ) );
  ListBox1.Items.addObject( '2', pointer( 2 ) );
  ListBox1.Items.addObject( '1', pointer( 1 ) );
  ListBox1.Sorted := true;

  DirList:= TCustomDirectoryListBox.Create( self );
  DirList.Parent:= TabbedNotebook1.Pages.Pages[ 5 ];
//  DirList.ALign:= alClient;
  DirList.ItemHeight:= 18;
  DirList.Color:= $ffe0ff;
  DriveCombobox:= TCustomDriveComboBox.Create( self );
  DriveCombobox.Parent:= self;
  //  DirList.PictureClosed:= nil;
//  DirList.PictureOpen:= nil;

  DirList.Destroy;

  RadioGRoup1.ItemIndex := 3;

//  RT.Images:= nil;
//  ImageList2.Destroy;
  TabbedNotebook1.yStretch:= ysFrame;
  StatusBar.SimpleText:= 'OK';
End;

Procedure TComponentsTestForm.RTOnSetupShow (Sender: TObject);
Begin

End;

Procedure TComponentsTestForm.MainFormOnShow (Sender: TObject);
var
  Node, Node2: TNode;
  i,j: integer;
  M1: longint;


  MLB: TMultiColumnListBox;
  Stream:TResourceStream;
Begin
  RT:= TRichTextView.Create( self );
  RT.Parent:= TabbedNotebook1.Pages.Pages[ 1 ];
  RT.BasicLeftMargin := 20;
  RT.BasicRightMargin := 0;
  RT.Align:= alClient;
  RT.BorderStyle := bsNone;
  RT.NormalFont := Screen.GetFontFromPointSize( 'Times New Roman', 10 );
  RT.FixedFont := Screen.GetFontFromPointSize( 'Courier New', 10 );
  RT.AddParagraph( '<center><h1>Big Centred heading by << Jiggolo >>' );

  RT.AddParagraph( 'Centred text' );
  RT.AddParagraph( '' );
  RT.AddParagraph( '<defaultalign><h2>Left subheading</h> some more text' );
  RT.AddParagraph( 'Some <image 0>' );
  RT.AddParagraph( 'This is the text for this subheading, what it''s about I cannot tell' );
  RT.AddParagraph( '' );
  RT.AddParagraph( 'In <tt>theory</tt> this is a <red><u><link cake>hyperlink</link><black></u>' );
  RT.AddParagraph( '<right>A right aligned part.<left>' );
 RT.AddParagraph( 'Here we </link><black></u>are back left aligned again, which is pretty standard I guess.' );
 RT.AddParagraph( 'Currently, the problems are that a) scrolling seems to ignore alignment '
                  + 'and b) finding point is not right for centred stuff' );
 RT.AddParagraph( 'Well, the scrolling problems are fixed. Also changed around the way of drawing.' );
 RT.AddParagraph( 'Simpler, which is good. But now there are mysterious memory problems!' );

 RT.AddParagraph( '<margin 20>This part has a margin' );

  RT.Images:= Imagelist2;
  RT.TopCharIndex := 50;
  RT.Color := clRed;

  AnOutline:= TOutline2.Create( self );
  AnOutline.Parent:= TabbedNotebook1.Pages.Pages[ 2 ];
  AnOutline.Align:= alClient;
  AnOutline.Width:= 200;
//  AnOutline.Height:= 180;
  AnOutline.LineHeight:= 16;
//  AnOutline.PlusMinusWidth:= 11;
//  AnOutline.PlusMinusHeight:= 11;

  AnOutline.SelectLine:= false;
  AnOutline.PlusMinusStyle:= pm3d;

  AnOutline.OnItemDblClick:= OnOutlineEvent;
  AnOutline.PenColor:= clBlue;

  M1:= MemAvail;

  AnOutline.BeginUpdate;

  Node:= AnOutline.AddChild( 'Seven', nil );
  Node:= Node.AddChild( 'Biscuit', nil );
  Node.AddChild( 'Afghan', nil );
  node2:= Node.AddChild( 'Toffee pop', nil );
  node2.AddChild( 'Supreme toffee pop', nil );
  node2.AddChild( 'Budget toffee pop', nil );
  node2.AddChild( 'Mysterious toffee pop', nil );
  node2.AddChild( 'Cheese flavoured toffee pop', nil );
  node2.Expand;

//  AnOutline.SelectedNode:= node2;

  Node.AddChild( 'Cheese', nil );
  Node.AddChild( 'Cake', nil );

  for i:= 0 to 20 do
  begin
    Node2:= AnOutline.AddChild( 'Item ' + IntToStr( i ) + ' This is a big cheese', nil );
    for j:= 0 to 20 do
      Node2.AddChild( 'Item ' + IntToStr( j ) + 'this is a giant sausage', nil );
  end;
  AnOutline.EndUpdate;
  StatusBar.SimpleText:= 'Mem used loading outline: ' + IntToStr( M1 - MemAvail );


  MLB:= TMultiColumnListBox.Create( self );

  MLB.Parent:= TabbedNotebook1.Pages.Pages[ 5 ];
  MLB.ALign:= alClient;
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.Items.Add( 'CHeese' + #9 + 'Cake' + #9 + 'Sausage' + #9 + '_1' );
  MLB.ImageList:= ImageList1;

End;

Procedure TComponentsTestForm.Button1OnClick (Sender: TObject);
var
  TheList: TStringList;
Begin
  TheList:= TStringList.Create;
  TheList.Add( 'List item 1' );
  TheList.Add( 'LIst item 2' );
  DoConfirmListDlg( 'Test',
                    'THis is the message. In theory it can be quite long and the dialog '
                    + 'should autosize to fit it best.',
                    TheList );
  TheList.Destroy;

End;

procedure TComponentsTestForm.OnOutlineEvent( Node: TNode );
begin
  ShowMessage( 'Node string: ' + Node.Text );
end;

Initialization
  RegisterClasses ([TComponentsTestForm, TTabbedNotebook, TStatusBar
   , TImageList, TOutline2, TMainMenu, TButton, TRichTextView,
    TCustomDriveComboBox,
    TCustomDirectoryListBox, TCustomFilelistBox, TListBox, TRadioGroup
   , TEdit, TSpeedButton]);
End.
