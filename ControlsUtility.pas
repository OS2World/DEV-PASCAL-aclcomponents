unit ControlsUtility;

interface

uses
  Classes, StdCtrls,
{$ifdef win32}
  checklst, ComCtrls, Windows, Messages, Graphics;
{$else}
  CustomCheckListBox;
{$endif}

// Checklistbox utility functions
{$ifdef win32}
Procedure GetCheckedItems( CheckListBox: TCheckListBox;
                           Items: TStrings );
Procedure AddCheckedItems( CheckListBox: TCheckListBox;
                           Items: TStrings );
Procedure AddCheckListItemObject( CheckListBox: TCheckListBox;
                                  Text: String;
                                  TheObject: TObject;
                                  Checked: boolean );
Procedure SetAllCheckListItems( CheckListBox: TCheckListBox;
                                Value: boolean );
Procedure CheckAllItems( CheckListBox: TCheckListBox );
Function CheckListItemCount( CheckListBox: TCheckListBox ): integer;
Function CheckListObject( CheckListBox: TCheckListBox;
                          Index: integer ): TObject;
Function SelectedCheckListObject( CheckListBox: TCheckListBox ): TObject;
Function SelectedCheckListItem( CheckListBox: TCheckListBox ): string;
Function CheckedCount( CheckListBox: TCheckListBox ): integer;

Type
  TListBoxType = TCustomListBox;
  
{$else}
Procedure GetCheckedItems( CheckListBox: TCustomCheckListBox;
                           Items: TStrings );
Procedure AddCheckedItems( CheckListBox: TCustomCheckListBox;
                           Items: TStrings );
Procedure AddCheckListItemObject( CheckListBox: TCustomCheckListBox;
                                  Text: String;
                                  TheObject: TObject;
                                  Checked: boolean );
Procedure SetAllCheckListItems( CheckListBox: TCustomCheckListBox;
                                Value: boolean );
Function CheckListItemCount( CheckListBox: TCustomCheckListBox ): integer;
Function CheckListObject( CheckListBox: TCustomCheckListBox;
                          Index: integer ): TObject;
Function SelectedCheckListObject( CheckListBox: TCustomCheckListBox ): TObject;
Function SelectedCheckListItem( CheckListBox: TCustomCheckListBox ): string;
Function CheckedCount( CheckListBox: TCustomCheckListBox ): integer;

Type
  TListBoxType = TListBox;

{$endif}

// Listbox utility functions
Function SelectedObject( ListBox: TListBoxType ): TObject;
Function SelectedItem( ListBox: TListBoxType ): string;
Procedure GetSelectedItems( ListBox: TListBoxType;
                            Dest: TStrings );

{$ifdef win32}
Procedure AddBoldedLine( RichEdit: TRichEdit;
                         BoldPart: string;
                         NormalPart: string );
{$endif}
                            
implementation

{$ifdef win32}
Procedure AddCheckedItems( CheckListBox: TCheckListBox;
                           Items: TStrings );
var
  i: integer;
begin
  for i:= 0 to CheckListBox.Items.Count - 1 do
    if CheckListBox.Checked[ i ] then
      Items.AddObject( CheckListBox.Items[ i ],
                       CheckListBox.Items.Objects[ i ] );
end;

Procedure GetCheckedItems( CheckListBox: TCheckListBox;
                           Items: TStrings );
begin
  Items.Clear;
  AddCheckedItems( CheckListBox, Items );
end;

Procedure AddCheckListItemObject( CheckListBox: TCheckListBox;
                                  Text: String;
                                  TheObject: TObject;
                                  Checked: boolean );
var
  AddPosition: integer;
begin
  AddPosition:= CheckListBox.Items.AddObject( Text, TheObject );
  CheckListBox.Checked[ AddPosition ]:= Checked;
end;

Procedure SetAllCheckListItems( CheckListBox: TCheckListBox;
                                Value: boolean );
var
  i: integer;
begin
  CheckListBox.BeginUpdate;
  for i:= 0 to CheckListBox.Items.Count - 1 do
    CheckListBox.Checked[ i ] := Value;
  CheckListBox.EndUpdate;
end;

Function CheckListItemCount( CheckListBox: TCheckListBox ): integer;
begin
  Result:= CheckListBox.Items.Count;
end;

Function CheckListObject( CheckListBox: TCheckListBox;
                          Index: integer ): TObject;
begin
  Result:= CheckListBox.Items.Objects[ Index ];
end;

Function SelectedCheckListObject( CheckListBox: TCheckListBox ): TObject;
begin
  if CheckListBox.ItemIndex <> -1 then
    Result:= CheckListBox.Items.Objects[ CheckListBox.ItemIndex ]
  else
    Result:= nil;
end;

Function SelectedCheckListItem( CheckListBox: TCheckListBox ): string;
begin
  if CheckListBox.ItemIndex <> -1 then
    Result:= CheckListBox.Items[ CheckListBox.ItemIndex ]
  else
    Result:= '';
end;

Function CheckedCount( CheckListBox: TCheckListBox ): integer;
var
  i: integer;
begin
  Result:= 0;
  for i:= 0 to CheckListBox.Items.Count - 1 do
    if CheckListBox.Checked[ i ] then
      inc( Result );
end;

{$else}
Procedure AddCheckedItems( CheckListBox: TCustomCheckListBox;
                           Items: TStrings );
begin
  CheckListBox.AddCheckedItems( Items );
end;

Procedure GetCheckedItems( CheckListBox: TCustomCheckListBox;
                           Items: TStrings );
begin
  Items.Clear;
  AddCheckedItems( CheckListBox, Items );
end;

Procedure AddCheckListItemObject( CheckListBox: TCustomCheckListBox;
                                  Text: String;
                                  TheObject: TObject;
                                  Checked: boolean );
begin
  CheckListBox.AddItemObject( Text, TheObject, Checked );
end;

Procedure SetAllCheckListItems( CheckListBox: TCustomCheckListBox;
                                Value: boolean );
var
  i: integer;
begin
  CheckListBox.BeginUpdate;
  for i:= 0 to CheckListBox.Items.Count - 1 do
    CheckListBox.Checked[ i ] := Value;
  CheckListBox.EndUpdate;
end;

Function CheckListItemCount( CheckListBox: TCustomCheckListBox ): integer;
begin
  Result:= CheckListBox.ItemCount;
end;

Function CheckListObject( CheckListBox: TCustomCheckListBox;
                          Index: integer ): TObject;
begin
  Result:= CheckListBox.Objects[ Index ];
end;

Function SelectedCheckListObject( CheckListBox: TCustomCheckListBox ): TObject;
begin
  Result:= CheckListBox.SelectedObject;
end;

Function SelectedCheckListItem( CheckListBox: TCustomCheckListBox ): string;
begin
  Result:= CheckListBox.SelectedString;
end;

Function CheckedCount( CheckListBox: TCustomCheckListBox ): integer;
begin
  Result:= CheckListBox.CheckedCount;
end;

{$endif}


Function SelectedObject( ListBox: TListBoxType ): TObject;
begin
  if ( ListBox.ItemIndex >= 0 )
     and ( ListBox.ItemIndex < ListBox.Items.Count ) then
    Result:= ListBox.Items.Objects[ ListBox.ItemIndex ]
  else
    Result:= nil;
end;

Function SelectedItem( ListBox: TListBoxType ): string;
begin
  if ( ListBox.ItemIndex >= 0 )
     and ( ListBox.ItemIndex < ListBox.Items.Count ) then
    Result:= ListBox.Items[ ListBox.ItemIndex ]
  else
    Result:= '';
end;

Procedure GetSelectedItems( ListBox: TListBoxType;
                            Dest: TStrings );
var
  i: integer;
begin
  for i:= 0 to ListBox.Items.Count - 1 do
    if ListBox.Selected[ i ] then
      Dest.AddObject( ListBox.Items[ i ],
                      ListBox.Items.Objects[ i ] );
end;

{$ifdef win32}
const
  EndLineStr = #13 +#10;
  
Procedure AddBoldedLine( RichEdit: TRichEdit;
                         BoldPart: string;
                         NormalPart: string );
var
  LineStart: integer;
  Dummy: integer;
begin
  with RichEdit do
  begin
    SendMessage( Handle,
                 EM_GETSEL,
                 Longint( Addr( LineStart ) ),
                 Longint( Addr( Dummy ) ) );

    SendMessage( Handle,
                 EM_REPLACESEL,
                 0,
                 Longint(PChar( BoldPart)));

    SelStart:= LineStart;
    SelLength:= Length( BoldPart );
    SelAttributes.Style:= [ fsBold ];

    SelStart:= LineStart + Length( BoldPart );
    SelLength:= 0;
    SendMessage( Handle,
                 EM_REPLACESEL,
                 0,
                 Longint(PChar( NormalPart)));
    SelStart:= LineStart + Length( BoldPart );
    SelLength:= Length( NormalPart );
    SelAttributes.Style:= [];
    SelStart:= LineStart + Length( BoldPart )
               + Length( NormalPart );
    SelLength:= 0;
    SendMessage( Handle,
                 EM_REPLACESEL,
                 0,
                 Longint(PChar( EndLineStr )));

  end;

end;
{$endif}

end.
