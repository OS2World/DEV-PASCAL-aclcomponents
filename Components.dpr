program Components;

uses
  Forms,
  CustomFilelistBoxWin in 'CustomFilelistBoxWin.pas',
  CustomDirOutlineWin in 'CustomDirOutlineWin.pas',
  ColorWheelWin in 'ColorWheelWin.pas',
  ColorMapping in 'ColorMapping.pas',
  SmartListBoxWin in 'SmartListBoxWin.pas',
  ComponentsTestFormWin in 'ComponentsTestFormWin.pas' {MainForm},
  ACLDialogs in 'ACLDialogs.pas',
  MessageFormWin in 'MessageFormWin.PAS' {MessageForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMessageForm, MessageForm);
  Application.Run;
end.
