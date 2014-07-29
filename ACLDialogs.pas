Unit ACLDialogs;
// A variety of useful message box functions, including displaying
// lists. They all allow specification of a caption.

 Interface

Uses
{$ifdef os2}
  ACLMessageForm,
{$else}
  MessageFormWin, Controls,
{$endif}
  Classes;

// Shows a message box
Procedure DoMessageDlg( Caption: String;
                        Message: string );

// Shows a long message box
Procedure DoLongMessageDlg( Caption: String;
                            Message: PChar );

// Shows a dialog with OK and cancel buttons
// Returns true if OK pressed
Function DoConfirmDlg( Caption: string;
                       Message: string ): boolean;

// Returns true if confirmation given.
Function DoConfirmListDlg( Caption: string;
                           Message: string;
                           List: TStrings ): boolean;

// Shows a message containing a list
Procedure DoMessageListDlg( Caption: string;
                            Message: string;
                            List: TStrings );

// Returns true if yes is clicked
Function DoYesNoListDlg( Caption: string;
                         Message: string;
                         List: TStrings ): boolean;

// Returns true if yes is clicked
Function DoYesNoDlg( Caption: string;
                     Message: string ): boolean;

// Shows a message containing a list
// with a help callback for items in the list
Procedure DoMessageListHelpDlg( Caption: string;
                                Message: string;
                                List: TStrings;
                                ListHelpCallback: TListHelpCallback );

Implementation

uses
  ACLPCharUtility,
  SysUtils;
// -------------------------------------------------

Procedure DoMessageListDlg( Caption: string;
                            Message: string;
                            List: TStrings );
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:= Caption;
  PMessage:= StrDupPas( Message );

  TheDialog.TheText:= PMessage;
  TheDialog.ShowList:= true;
  TheDialog.ShowCancel:= false;
  TheDialog.IconType:= mitInfo;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= false;

  TheDialog.ListBox.Items.Assign( List );
  TheDialog.ShowModal;

  StrDispose( PMessage );
  TheDialog.Destroy;
End;

Procedure DoMessageListHelpDlg( Caption: string;
                                Message: string;
                                List: TStrings;
                                ListHelpCallback: TListHelpCallback );
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:=Caption;
  PMessage:= strduppas( Message );

  TheDialog.TheText:= PMessage;
  TheDialog.ShowList:= true;
  TheDialog.ShowCancel:= false;
  TheDialog.IconType:= mitInfo;
  TheDialog.ShowHelp:= true;
  TheDialog.HelpCallback:= ListHelpCallback;
  TheDialog.UseYesNo:= false;

  TheDialog.ListBox.Items.Assign( List );
  TheDialog.ShowModal;

  StrDispose( PMessage );
  TheDialog.Destroy;
End;

Function DoConfirmListDlg( Caption: string;
                           Message: string;
                           List: TStrings ): boolean;
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:=Caption;
  PMessage:= strduppas( Message );

  TheDialog.TheText:= PMessage;
  TheDialog.ShowList:= true;
  TheDialog.ShowCancel:= true;
  TheDialog.IconType:= mitQuestion;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= false;

  TheDialog.ListBox.Items.Assign( List );
  Result:= ( TheDialog.ShowModal = mrOK );

  StrDispose( PMessage );
  TheDialog.Destroy;
End;

Function DoConfirmDlg( Caption: string;
                       Message: string ): boolean;
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:=Caption;
  PMessage:= strduppas( Message );
  TheDialog.TheText:= PMessage;

  TheDialog.ShowList:= false;
  TheDialog.ShowCancel:= true;
  TheDialog.IconType:= mitQuestion;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= false;

  Result:= ( TheDialog.ShowModal = mrOK );

  StrDispose( PMessage );
  TheDialog.Destroy;
End;

Procedure DoLongMessageDlg( Caption: String;
                            Message: PChar );
Var
  TheDialog: TMessageForm;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:=Caption;
  TheDialog.TheText:= Message;

  TheDialog.ShowList:= false;
  TheDialog.ShowCancel:= false;
  TheDialog.IconType:= mitInfo;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= false;

  TheDialog.ShowModal;
  TheDialog.Destroy;
End;

Procedure DoMessageDlg( Caption: String;
                        Message: string );
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:=Caption;
  PMessage:= strduppas( Message );
  TheDialog.TheText:= PMessage;

  TheDialog.ShowList:= false;
  TheDialog.ShowCancel:= false;
  TheDialog.IconType:= mitInfo;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= false;

  TheDialog.ShowModal;
  TheDialog.Destroy;
  StrDispose( PMessage );
End;

Function DoYesNoListDlg( Caption: string;
                         Message: string;
                         List: TStrings ): boolean;
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:=Caption;
  PMessage:= strduppas( Message );
  TheDialog.TheText:= PMessage;

  TheDialog.ShowList:= true;
  TheDialog.ShowCancel:= true;
  TheDialog.IconType:= mitQuestion;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= true;
  TheDialog.ListBox.Items.Assign( List );

  Result:= ( TheDialog.ShowModal = mrOK );

  StrDispose( PMessage );
  TheDialog.Destroy;
End;

Function DoYesNoDlg( Caption: string;
                     Message: string ): boolean;
Var
  TheDialog: TMessageForm;
  PMessage: PChar;
Begin
  TheDialog:= TMessageForm.Create( nil );
  TheDialog.Caption:= Caption;
  PMessage:= strduppas( Message );
  TheDialog.TheText:= PMessage;

  TheDialog.ShowList:= false;
  TheDialog.ShowCancel:= true;
  TheDialog.IconType:= mitQuestion;
  TheDialog.ShowHelp:= false;
  TheDialog.UseYesNo:= true;

  Result:= ( TheDialog.ShowModal = mrOK );

  StrDispose( PMessage );
  TheDialog.Destroy;
End;

End.
