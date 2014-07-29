Unit CustomFontDialog;

Interface

Uses
  Classes, Forms, Dialogs, StdCtrls, Buttons, Graphics;

Type

    TCustomFontDialog=Class(TDialog)
      Private
         FNameCombo:TComboBox;
         FSizeCombo:TComboBox;
         FExampleText:TButton;
         FItalicCheck:TCheckBox;
         FBoldCheck:TCheckBox;
         FOutlineCheck:TCheckBox;
         FUnderscoreCheck:TCheckBox;
         FStrikeOutCheck:TCheckBox;
         FOkBtn:TBitBtn;
         FCancelBtn:TBitBtn;
         Function GetFontName:String;
         Procedure SetFontName(Value:String);
         Function GetFaceName:String;
         Procedure SetFaceName(Value:String);
         Function GetPointSize:LongInt;
         Procedure SetPointSize(Value:LongInt);
         Procedure SetTheFont;
         Procedure InsertSizes(Var TheFont:TFont);
         Procedure EvComboSelect(Sender:TObject;Index:LongInt);
         Procedure EvComboSizeSelect(Sender:TObject;Index:LongInt);
         Function GetEditFont:TFont;
         Procedure SetEditFont(NewFont:TFont);
         Function GetAttributes:TFontAttributes;
         Procedure SetAttributes(NewValue:TFontAttributes);
         Procedure StyleChanged(Sender:TObject);
      Protected
         Procedure SetupComponent;Override;
         Procedure SetupShow;Override;
      Public
         Property FaceName:String Read GetFaceName Write SetFaceName;
         Property PointSize:LongInt Read GetPointSize Write SetPointSize;
      Published
         Property FontName:String Read GetFontName Write SetFontName;
         Property EditFont:TFont Read GetEditFont Write SetEditFont;
         Property Attributes:TFontAttributes Read GetAttributes Write SetAttributes;
    End;

Exports
  TCustomFontDialog,'User','CustomFontDialog.bmp';

Implementation

uses
  SysUtils, PmWin;

Procedure TCustomFontDialog.SetupComponent;
Var  T:LongInt;
     aFont:TFont;
     group:TGroupBox;
Begin
     Inherited SetupComponent;

     Caption:=LoadNLSStr(SSelectAFont);
     Width:=355;
     Height:=380;
     color:=clLtGray;

//     group:=InsertGroupBox(Self,5,5,280,Height-40,'');
//     group.ZOrder:=zoBottom;

     InsertLabel(Self,10,270,80,20,LoadNLSStr(SName)+':');
     FNameCombo:=InsertComboBox(Self,10, 150,260,120,csDropDownList);
     FNameCombo.sorted := True;
     FNameCombo.Duplicates:=False;
     FNameCombo.OnItemSelect:=EvComboSelect;

     InsertLabel(Self,280,270,50,20,LoadNLSStr(SSize)+':');
     FSizeCombo:=InsertComboBox(Self,280,250-100,60,120,csDropDown);
     FSizeCombo.OnItemSelect:=EvComboSizeSelect;
     FSizeCombo.Duplicates:=False;

     group:=InsertGroupBox(Self,12,150,110,90,LoadNLSStr(SStyle));
     group.ZOrder:=zoTop;
     FItalicCheck:=InsertCheckBox(Self,20,200,95,20,LoadNLSStr(SItalic),'');
     FItalicCheck.OnClick:=StyleChanged;
     FBoldCheck:=InsertCheckBox(Self,20,180,95,20,LoadNLSStr(SBold),'');
     FBoldCheck.OnClick:=StyleChanged;

     group:=InsertGroupBox(Self,127,150,150,90,LoadNLSStr(SEmphasis));
     group.ZOrder:=zoTop;
     FOutlineCheck:=InsertCheckBox(Self,135,200,135,20,LoadNLSStr(SOutline),'');
     FOutlineCheck.OnClick:=StyleChanged;
     FStrikeOutCheck:=InsertCheckBox(Self,135,180,135,20,LoadNLSStr(SStrikeout),'');
     FStrikeOutCheck.OnClick:=StyleChanged;
     FUnderscoreCheck:=InsertCheckBox(Self,135,160,135,20,LoadNLSStr(SUnderscore),'');
     FUnderscoreCheck.OnClick:=StyleChanged;

     FExampleText:=InsertButton(Self,10,50,330,90,LoadNLSStr(SExampleText),'');
     FExampleText.OnClick:=StyleChanged;

     For T:=0 To Screen.FontCount-1 Do
     Begin
          aFont:=Screen.Fonts[T];
          FNameCombo.Items.Add(aFont.FaceName);
     End;
     FNameCombo.Items.Add('System Default Font');

     FOkBtn := InsertBitBtn(Self,150,10,90,30,bkOk,LoadNLSStr(SOkButton),LoadNLSStr(SClickHereToAccept));
     FCancelBtn := InsertBitBtn(Self,250,10,90,30,bkCancel,LoadNLSStr(SCancelButton),LoadNLSStr(SClickHereToCancel));
     InsertBitBtn(Self,10,10,90,30,bkHelp,LoadNLSStr(SHelpButton),LoadNLSStr(SClickHereToGetHelp));

     SetFontName('');  {Init}
End;


Procedure TCustomFontDialog.SetupShow;
Begin
     SetTheFont;

     Inherited SetupShow;

     FNameCombo.Focus;
     FOkBtn.Default := True;
End;

Function ModifyFontName(FontName:String;Const Attrs:TFontAttributes):String;
Begin
     Result:=FontName;
     UpcaseStr(FontName);
     If Attrs*[faItalic]<>[] Then If Pos(' ITALIC',FontName)=0 Then Result:=Result+'.Italic';
     If Attrs*[faBold]<>[] Then If Pos(' BOLD',FontName)=0 Then Result:=Result+'.Bold';
     If Attrs*[faOutline]<>[] Then Result:=Result+'.Outline';
     If Attrs*[faStrikeOut]<>[] Then Result:=Result+'.Strikeout';
     If Attrs*[faUnderScore]<>[] Then Result:=Result+'.Underscore';
End;

Function TCustomFontDialog.GetAttributes:TFontAttributes;
Var S:String;
Begin
     Result:=[];

     S:=FNameCombo.Caption;
     UpcaseStr(S);
     If FItalicCheck.Checked Then
       If Pos(' ITALIC',S)=0 Then Result:=Result+[faItalic];
     If FBoldCheck.Checked Then
       If Pos(' BOLD',S)=0 Then Result:=Result+[faBold];
     If FOutlineCheck.Checked Then Result:=Result+[faOutline];
     If FStrikeOutCheck.Checked Then Result:=Result+[faStrikeOut];
     If FUnderscoreCheck.Checked Then Result:=Result+[faUnderScore];
End;

Procedure TCustomFontDialog.SetAttributes(NewValue:TFontAttributes);
Var S:String;
Begin
     S:=FNameCombo.Caption;
     S:=ModifyFontName(S,NewValue);
     If PointSize<>0 Then FontName:=tostr(PointSize)+'.'+s
     Else FontName:=S;
End;

Function TCustomFontDialog.GetFaceName:String;
Begin
     Result:=FNameCombo.Caption;
     Result:=ModifyFontName(Result,Attributes);
End;

Procedure TCustomFontDialog.SetFaceName(Value:String);
Var S:String;
Begin
     S:=Value;
     UpcaseStr(S);
     FBoldCheck.Checked:=FBoldCheck.Checked Or(Pos(' BOLD',S)<>0);
     FItalicCheck.Checked:=FItalicCheck.Checked Or(Pos(' ITALIC',S)<>0);
     Value:=ModifyFontName(Value,Attributes);
     If PointSize<>0 Then FontName:=tostr(PointSize)+'.'+Value
     Else FontName:=Value;
End;


Function TCustomFontDialog.GetPointSize:LongInt;
Var S:String;
    C:Integer;
Begin
     If FNameCombo.Caption='System Default Font' Then Result:=Screen.DefaultFont.PointSize
     Else
     Begin
         S:=FSizeCombo.Caption;
         Val(S,Result,C);
         If C<>0 Then Result:=0;
     End;
End;


Procedure TCustomFontDialog.SetPointSize(Value:LongInt);
Begin
     If Value=0 Then Value:=8;
     FontName:=tostr(Value)+'.'+FaceName;
End;


Function TCustomFontDialog.GetEditFont:TFont;
Begin
     Result:=Screen.GetFontFromPointSize(FaceName,PointSize);
End;

Procedure TCustomFontDialog.SetEditFont(NewFont:TFont);
Var S:String;
    Attrs:TFontAttributes;
Begin
     If NewFont=Nil Then NewFont:=Screen.DefaultFont;

     If NewFont.IsDefault Then
     Begin
          S:=tostr(Screen.DefaultFont.PointSize)+'.'+'System Default Font';;
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=False;
          FontName:=S;
     End
     Else
     Begin
          S:=NewFont.FaceName;
          UpcaseStr(S);
          Attrs:=NewFont.Attributes;
          FBoldCheck.Checked:=(Pos(' BOLD',S)<>0)Or(Attrs*[faBold]<>[]);
          FItalicCheck.Checked:=(Pos(' ITALIC',S)<>0)Or(Attrs*[faItalic]<>[]);
          S:=NewFont.FaceName;
          S:=ModifyFontName(S,NewFont.Attributes);
          If NewFont.PointSize<>0 Then FontName:=tostr(NewFont.PointSize)+'.'+s
          Else FontName:=S;
     End;
End;

{$HINTS OFF}
Procedure TCustomFontDialog.StyleChanged(Sender:TObject);
Begin
     If Handle<>0 Then SetTheFont;
End;
{$HINTS ON}

Function TCustomFontDialog.GetFontName:String;
Begin
     Result := tostr(PointSize) + '.' + FaceName;
End;


Procedure TCustomFontDialog.SetFontName(Value:String);
Var  S,s1:String;
     DefPointSize,T:LongInt;
     B:Byte;
     C:Integer;
     Attrs:TFontAttributes;
Label L;
Begin
     If Value = '' Then Value := '8.Helv';
     B := Pos('.',Value);
     If B <> 0 Then
     Begin
          S := Copy(Value,1,B-1);
          Delete(Value,1,B);
          If Value='' Then Value:='Helv';
          Val(S,DefPointSize,C);
          If C <> 0 Then DefPointSize := 8;
     End
     Else DefPointSize := 8;

     Attrs:=[];
     S:=Value;
     UpcaseStr(S);
L:
     For T:=Length(S) DownTo 1 Do
     Begin
          If S[T]='.' Then
          Begin
               s1:=Copy(S,T+1,255);
               If ((s1='BOLD')Or(s1='ITALIC')Or(s1='UNDERSCORE')Or(s1='STRIKEOUT')Or
                   (s1='OUTLINE')) Then
               Begin
                    S[0]:=Chr(T-1);
                    Value[0]:=Chr(T-1);

                    If s1='BOLD' Then Attrs:=Attrs+[faBold]
                    Else If s1='ITALIC' Then Attrs:=Attrs+[faItalic]
                    Else If s1='UNDERSCORE' Then Attrs:=Attrs+[faUnderScore]
                    Else If s1='STRIKEOUT' Then Attrs:=Attrs+[faStrikeOut]
                    Else If s1='OUTLINE' Then Attrs:=Attrs+[faOutline];
               End;
          End;
     End;

     If Value='System Default Font' Then
     Begin
          FNameCombo.Caption := Value;
          FSizeCombo.Caption := tostr(Screen.DefaultFont.PointSize);
     End
     Else
     Begin
          For T := 0 To Screen.FontCount-1 Do If Screen.Fonts[T].FaceName = Value Then
          Begin
               FNameCombo.Caption := Value;
               FSizeCombo.Caption := tostr(DefPointSize);
               break;
          End;
     End;

     UpcaseStr(Value);
     FItalicCheck.Checked:=((Attrs*[faItalic]<>[])Or(Pos(' ITALIC',Value)<>0));
     FBoldCheck.Checked:=((Attrs*[faBold]<>[])Or(Pos(' BOLD',Value)<>0));

     FOutlineCheck.Checked:=Attrs*[faOutline]<>[];
     FUnderscoreCheck.Checked:=Attrs*[faUnderScore]<>[];
     FStrikeOutCheck.Checked:=Attrs*[faStrikeOut]<>[];

     If Handle<>0 Then SetTheFont;
End;


Procedure TCustomFontDialog.SetTheFont;
{$IFDEF OS2}
Var  C:cstring;
{$ENDIF}
Var  Font:TFont;
     IsDefault:Boolean;
     S,Value:String;
     T:LongInt;
     B:Byte;
Label L;
Begin
     IsDefault:=False;
     S:=FNameCombo.Caption;
     If S='System Default Font' Then
     Begin
          FSizeCombo.Caption:=tostr(Screen.DefaultFont.PointSize);
          FSizeCombo.Enabled:=False;
          IsDefault:=True;
     End
     Else FSizeCombo.Enabled:=True;

     For T:=0 To Screen.FontCount-1 Do
     Begin
          Font:=Screen.Fonts[T];
          If Font.FaceName=S Then
          Begin
               If Font.FontType=ftBitmap Then
               Begin
                    FOutlineCheck.Checked:=False;
                    FOutlineCheck.Enabled:=False;
               End
               Else FOutlineCheck.Enabled:=Not IsDefault;
               Goto L;
          End;
     End;

     FOutlineCheck.Enabled:=Not IsDefault;
L:
     Value:=FNameCombo.Caption;
     UpcaseStr(Value);

     If Pos(' ITALIC',Value)<>0 Then
     Begin
          If Not FItalicCheck.Checked Then
          Begin
               B:=Pos(' ITALIC',Value);
               S:=FNameCombo.Caption;
               Delete(S,B,7);
               FNameCombo.Caption:=S;
          End;
          FItalicCheck.Enabled:=True;
     End
     Else FItalicCheck.Enabled:=Not IsDefault;

     If Pos(' BOLD',Value)<>0 Then
     Begin
          If Not FBoldCheck.Checked Then
          Begin
               B:=Pos(' BOLD',Value);
               S:=FNameCombo.Caption;
               Delete(S,B,5);
               FNameCombo.Caption:=S;
          End;
          FBoldCheck.Enabled:=True;
     End
     Else FBoldCheck.Enabled:=Not IsDefault;

     Value:=FNameCombo.Caption;
     UpcaseStr(Value);
     FItalicCheck.Checked:=FItalicCheck.Checked Or (Pos(' ITALIC',Value)<>0);
     FBoldCheck.Checked:=FBoldCheck.Checked Or (Pos(' BOLD',Value)<>0);

     FStrikeOutCheck.Enabled:=Not IsDefault;
     FUnderscoreCheck.Enabled:=Not IsDefault;

     Font:=Screen.GetFontFromPointSize(FaceName,PointSize);
     InsertSizes(Font);
     If Font<>Nil Then
     Begin
          Font:=Screen.CreateCompatibleFont(Font);
          Font.AutoDestroy:=True;
          FExampleText.Font:=Font;
          FNameCombo.Caption:=FExampleText.Font.FaceName;
          FSizeCombo.Caption:=tostr(FExampleText.Font.PointSize);
     End
     Else
     Begin
          {$IFDEF OS2}
          C := FontName;
          WinSetPresParam(FExampleText.Handle,PP_FONTNAMESIZE,Length(C)+1,C);
          {$ENDIF}
     End;
End;

Procedure TCustomFontDialog.InsertSizes(Var TheFont:TFont);
Var  C,c1,c2,T,t1:LongInt;
     OldCaption:String;
     cc:Integer;
     CaptionUpdated:Boolean;
     OldFont:TFont;
Label weiter,found,TryThis;
{$IFDEF WIN32,LINUX}
Label defSize;
{$ENDIF}
Begin
     OldCaption:=FSizeCombo.Caption;

     FSizeCombo.BeginUpdate;
     FSizeCombo.Clear;

     {$IFDEF WIN32,LINUX}
     goto defSize;
     {$ENDIF}

     If TheFont=Nil Then
     Begin
{$IFDEF WIN32,LINUX}
defsize:
{$ENDIF}
          C:=4;
          While C<48 Do
          Begin
               FSizeCombo.Items.Add(tostr(C));
               Inc(C,2);
          End;
     End
     Else
     Begin
          If TheFont.MinimumPointSize=TheFont.MaximumPointSize Then
          Begin
               CaptionUpdated:=False;
TryThis:
               For T:=0 To Screen.FontCount-1 Do
               Begin
                    If Screen.Fonts[T].FaceName=FNameCombo.Caption Then
                    Begin
                         c2:=Screen.Fonts[T].MinimumPointSize;
                         If c2<4 Then c2:=4;

                         While ((c2<48)And(c2<=Screen.Fonts[T].MaximumPointSize)) Do
                         Begin
                              C:=c2;

                              For t1:=0 To FSizeCombo.Items.Count-1 Do
                              Begin
                                   Val(FSizeCombo.Items[t1],c1,cc);
                                   If cc=0 Then
                                   Begin
                                       If c1<4 Then c1:=4;
                                       If c1=C Then Goto weiter;
                                       If c1>C Then
                                       Begin
                                           Goto found;
                                       End;
                                   End;
                              End;
                              t1:=FSizeCombo.Items.Count;
found:
                              FSizeCombo.Items.Insert(t1,tostr(C));
weiter:
                              If c2 And 1<>0 Then Inc(c2)
                              Else Inc(c2,2);
                         End; //While
                    End;
               End;

               If ((Not CaptionUpdated)And(FSizeCombo.Items.IndexOf(OldCaption)<0)) Then
               Begin
                    If ((TheFont.NominalPointSize<>0)And
                        (FSizeCombo.Items.IndexOf(tostr(TheFont.NominalPointSize))>=0)) Then
                      OldCaption:=tostr(TheFont.NominalPointSize)
                    Else If FSizeCombo.Items.Count>0 Then
                      OldCaption:=FSizeCombo.Items[0];
               End;
          End
          Else
          Begin
               C:=TheFont.MinimumPointSize;
               If C<4 Then C:=4;

               While ((C<48)And(C<=TheFont.MaximumPointSize)) Do
               Begin
                    FSizeCombo.Items.Add(tostr(C));
                    If C And 1<>0 Then Inc(C)
                    Else Inc(C,2);
               End;

               Val(OldCaption,c1,cc);
               If cc=0 Then
               Begin
                    If ((c1<TheFont.MinimumPointSize)Or(c1>TheFont.MaximumPointSize)) Then
                    Begin
                         If TheFont.NominalPointSize<>0 Then
                           OldCaption:=tostr(TheFont.NominalPointSize)
                         Else If FSizeCombo.Items.Count>0 Then
                           OldCaption:=FSizeCombo.Items[0];
                    End;
               End;
               CaptionUpdated:=True;
               Goto TryThis;
          End;
     End;

     FSizeCombo.Caption := OldCaption;
     FSizeCombo.EndUpdate;
     //recreate Font In Case that Size changed
     OldFont:=TheFont;
     TheFont:=Screen.GetFontFromPointSize(FaceName,PointSize);
     If TheFont=Nil Then TheFont:=OldFont;
End;


{$HINTS OFF}
Procedure TCustomFontDialog.EvComboSelect(Sender:TObject;Index:LongInt);
Var S:String;
Begin
     S:=FNameCombo.Text;
     UpcaseStr(S);
     If Pos(' BOLD',S)<>0 Then
     Begin
          If Pos(' ITALIC',S)<>0 Then
          Begin
               FBoldCheck.Checked:=True;
               FItalicCheck.Checked:=True;
          End
          Else
          Begin
               FBoldCheck.Checked:=True;
               FItalicCheck.Checked:=False;
          End;
     End
     Else If Pos(' ITALIC',S)<>0 Then
     Begin
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=True;
     End
     Else
     Begin
          FBoldCheck.Checked:=False;
          FItalicCheck.Checked:=False;
     End;

     SetTheFont;
End;


Procedure TCustomFontDialog.EvComboSizeSelect(Sender:TObject;Index:LongInt);
Begin
     SetTheFont;
End;

Initialization
  {Register classes}
  RegisterClasses([TCustomFontDialog]);
End.

