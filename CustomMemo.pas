Unit CustomMemo;

Interface

Uses
  Classes, Forms, StdCtrls;

{Declare new class}
Type
  TCustomMemo=Class(TMemo)
  Protected
  Public
    Procedure AddSelectedLine( NewText: string );
    Procedure AddText( NewText: PChar );
    // If it can be found, make the given text the
    // top of the window. Returns true if it was found
    Function JumpToText( Text: string ): boolean;
    // Returns contents as Ansi String
    Function Text: AnsiString;
    // Returns total height of all text. Does not include borders at this time :-(
    Function TotalHeight: longint;
  End;

{Define components to export}
{You may define a page of the component palette and a component bitmap file}
Exports
  TCustomMemo,'User','CustomMemo.bmp';

Implementation

Uses
  PMWin, DIalogs, SysUtils, Os2Def;

Procedure TCustomMemo.AddText( NewText: PChar );
Var
  addPoint: longint;
Begin
  // Set to LF-only format
  WinSendMsg( Handle, MLM_FORMAT, MLFIE_CFTEXT, 0);

  addPoint:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );

  // add text
  WinSendMsg( Handle, MLM_SETIMPORTEXPORT, LongWord( NewText ), strlen( NewText ) );
  WinSendMsg( Handle, MLM_IMPORT, LongWord( @addPoint ), strlen( NewText ) );
End;

Procedure TCustomMemo.AddSelectedLine( NewText: string );
Var
  currentLength: longint;
  startOfLine: longint;
  endOfLine: longint;
  lineLength: longint;
  rc: longint;
  csText: cstring;
  addPoint: longint;
  line: longint;
Begin
  // Set to LF-only format
  WinSendMsg( Handle, MLM_FORMAT, MLFIE_NOTRANS, 0 ); {LF!}

  // If the last line is actually empty, we don't need
  // to add a new line character.
  currentLength:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );
  line:=WinSendMsg( Handle, MLM_LINEFROMCHAR, currentLength, 0 );
  startOfLine:=WinSendMsg( Handle, MLM_CHARFROMLINE, currentLength, 0 );
  lineLength:= WinSendMsg( Handle, MLM_QUERYLINELENGTH, startOfLine,0);

  if lineLength>0 then
  begin
    // Find end of text
    addPoint:= currentLength;

    // Add a new line
    csText:=#10;
    WinSendMsg( Handle, MLM_SETIMPORTEXPORT, LongWord(@csText), 255 );
    WinSendMsg( Handle, MLM_IMPORT, LongWord( @addPoint ), Length(csText) );

    // find start of new line
    startOfLine:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );
  end;

  addPoint:=startOfLine;

  // add text
  csText:=NewText;
  WinSendMsg( Handle, MLM_SETIMPORTEXPORT, LongWord(@csText), 255 );
  WinSendMsg( Handle, MLM_IMPORT, LongWord( @addPoint ), Length(csText) );

  // find the end of the new line
  endOfLine:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );

  // get focus, otherwise selection won't happen
  Focus;
  rc:=WinSendMsg( Handle, MLM_SETSEL, startOfLine, endOfLine  );
End;

// If it can be found, make the given text the
// top of the window
Function TCustomMemo.JumpToText( Text: string ): boolean;
Var
  SearchData: MLE_SearchData;
  rc: longint;
  csText: cstring;
  line: longint;
  newTopChar: longint;
Begin
  Result:=false;
  // Search all text
  SearchData.iptStart:=0;
  SearchData.iptStop:=-1;

  csText:=Text;
  SearchData.pchFind:=@csText;

  rc:=WinSendMsg( Handle, MLM_SEARCH, 0, LongWord( @SearchData ) );
  if rc=0 then
    exit;
  // find which line the text is on:
  line:=WinSendMsg( Handle, MLM_LINEFROMCHAR, SearchData.iptStart, 0 );
  // find the start of the line
  newTopChar:=WinSendMsg( Handle, MLM_CHARFROMLINE, line, 0 );
  // set it as the first char in the memo
  WinSendMsg( Handle, MLM_SETFIRSTCHAR, newTopChar, 0 );
  Result:=true;
End;

// Returns contents as Ansi String
Function TCustomMemo.Text: AnsiString;
Var
  pc: PChar;
Begin
  pc:=Lines.GetText;
  Result:=AnsiString( pc );
  StrDispose( pc );
End;

// Returns total height of all text
Function TCustomMemo.TotalHeight: longint;
Var
  currentLength: longint;
  line: longint;
Begin
  // Set to LF-only format
  WinSendMsg( Handle, MLM_FORMAT, MLFIE_NOTRANS, 0 ); {LF!}

  currentLength:=WinSendMsg( Handle, MLM_QUERYTEXTLENGTH, 0, 0 );
  line:= WinSendMsg( Handle, MLM_LINEFROMCHAR, currentLength, 0 );

  Result:= ( line+1 )* Font.Height;
end;

Initialization
  {Register classes}
  RegisterClasses([TCustomMemo]);
End.

