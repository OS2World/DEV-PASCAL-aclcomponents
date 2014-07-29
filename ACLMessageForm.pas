unit ACLMessageForm;

interface

Uses
{$ifdef os2}
  CustomMemo,
{$endif}
  Classes, Forms, Graphics, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

Type
  TListHelpCallback=procedure( ListObjectRef: TObject );

  TMessageIconType = ( mitInfo, mitQuestion );

  TMessageForm = Class (TDialog)
    OKButton: TButton;
    Image: TImage;
    MessageMemo: TCustomMemo;
    CancelButton: TButton;
    HelpButton: TButton;
    ListBox: TListBox;
    Procedure HelpButtonOnClick (Sender: TObject);
    Procedure SetupShow; override;
    Destructor Destroy; override;

  public
    TheText: PChar; // pointer to zero-terminated text to put in message memo
    ShowList: boolean;
    ShowCancel: boolean;
    UseYesNo: boolean;

    IconType: TMessageIconType;

    ShowHelp: boolean;
    HelpCallback: TListHelpCallback;

    Procedure SetupComponent; Override;

  protected
    InfoBitmap: TBitmap;
    QuestionBitmap: TBitmap;
  End;

Implementation

Uses
  SysUtils;

{$R DialogIcons}

Procedure TMessageForm.SetupComponent;
begin
  Inherited SetupComponent;
  Width:= 375;
  Height:= 300;

  OKButton:= InsertButton( self, 0, 5, 80, 30, '~OK', '' );
  OKButton.ModalResult:= mrOK;
  CancelButton:= InsertButton( self, 0, 5, 80, 30, '~Cancel', '' );
  CancelButton.ModalResult:= mrCancel;
  HelpButton:= InsertButton( self, 0, 5, 80, 30, '~Help', '' );
  HelpButton.OnClick:= HelpButtonOnClick;

  Image:= TImage.Create( self );
  Image.Parent:= Self;
  Image.Left:= 0;
  Image.Bottom:= 225;
  Image.Width:= 32;
  Image.Height:= 32;

  MessageMemo:= TCustomMemo.Create( self );
  MessageMemo.Parent:= Self;
  MessageMemo.Left:= 35;
  MessageMemo.Bottom:= 160;
  MessageMemo.Width:= 315;
  MessageMemo.Height:= 105;
  MessageMemo.ParentColor:= true;
  MessageMemo.BorderStyle:= bsNone;
  MessageMemo.ReadOnly:= true;

  ListBox:= InsertListBox( self, 35, 40, 285, 110, '' );

  InfoBitmap:= TBitmap.Create;
  InfoBitmap.LoadFromResourceName( 'InfoBitmap' );

  QuestionBitmap:= TBitmap.Create;
  QuestionBitmap.LoadFromResourceName( 'QuestionBitmap' );
end;

Procedure TMessageForm.HelpButtonOnClick (Sender: TObject);
Var
  ListObject: TObject;
  Index: longint;
Begin
  Index:= ListBox.ItemIndex;
  if Index=-1 then
    HelpCallback( nil )
  else
  begin
    ListObject:= ListBox.Items.Objects[ Index ];
    HelpCallback( ListObject );
  end;
End;

destructor TMessageForm.Destroy;
Begin
  InfoBitmap.Destroy;
  QuestionBitmap.Destroy;
  Inherited Destroy;
End;

Procedure TMessageForm.SetupShow;
Var
  TextHeight: longint;
  ImageHeight: longint;
  MessageHeight: longint;
  TotalButtonWidth: longint;
  X: longint;
Begin
  Inherited SetupShow;

  MessageMemo.Lines.SetText( TheText );

  TextHeight:= MessageMemo.TotalHeight+10;
  ImageHeight:= Image.Height;

  MessageHeight:= TextHeight;
  if ImageHeight>TextHeight then
    MessageHeight:= ImageHeight;

  MessageMemo.Height:= MessageHeight;

  if ShowList then
  begin
    ClientHeight:= OKButton.Height+10+ListBox.Height+10+MessageHeight+10;
    ListBox.Show;
  end
  else
  begin
    ClientHeight:= OKButton.Height+10+MessageHeight+10;
    ListBox.Hide;
  end;

  MessageMemo.Bottom:= ClientHeight - 10 - MessageHeight;
  Image.Bottom:= ClientHeight - 10 - Image.Height;

  TotalButtonWidth:= OKButton.Width;
  if ShowHelp then
    inc( TotalButtonWidth, HelpButton.Width+5 );
  if ShowCancel then
    inc( TotalButtonWidth, CancelButton.Width+5 );
  X:= ClientWidth div 2 - TotalButtonWidth div 2;

  HelpButton.Left:= X;
  if ShowHelp then
    inc( X, HelpButton.Width+5 );

  OKButton.Left:= X;
  inc( X, OKButton.Width+5 );

  CancelButton.Left:= X;

  CancelButton.Visible:= ShowCancel;
  if ShowCancel then
    CancelButton.Cancel:= true
  else
    OKButton.Cancel:= true; // so escape will finish the dialog

  if UseYesNo then
  begin
    OKButton.Caption:= '~Yes';
    CancelButton.Caption:= '~No';
  end
  else
  begin
    OKButton.Caption:= '~OK';
    CancelButton.Caption:= '~Cancel';
  end;

  HelpButton.Visible:= ShowHelp;

  case IconType of
  mitInfo:
    Image.Bitmap:= InfoBitmap;
  mitQuestion:
    Image.Bitmap:= QuestionBitmap;
  end;

  OKButton.Focus;

End;

Initialization
  RegisterClasses ([ TButton, TImage,
    TMessageForm, TCustomMemo, TListBox]);

end.
