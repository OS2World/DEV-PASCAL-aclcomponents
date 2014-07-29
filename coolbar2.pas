// Enhanced version of TCoolBar from Sibyl samples
// - Bitmap for first button draws correctly
// - Draws a border line underneath
// - Buttons look better (have black frame, when pressed look sunken, background moves)
// - Button text highlights under mouse (HotColor property)
// - bitmap does not overwrite border of button
// (C) 1998 SpeedSoft

Unit coolbar2;

Interface

Uses Classes,Forms,Graphics,Buttons,StdCtrls,ComCtrls,Dialogs, Messages;

Type
    TCoolSection2=Class(THeaderSection)
      Private
         FImage:LongInt;
         FHotImage:LongInt;
         FDisabledImage:LongInt;
         FDisabled:Boolean;
      Private
         Procedure SetDisabled(NewValue:Boolean);
         Procedure SetImage(NewValue:LongInt);
         Procedure SetHotImage(NewValue:LongInt);
         Procedure SetDisabledImage(NewValue:LongInt);
      Public
         Constructor Create(ACollection:TCollection);Override;
         Procedure Assign(Source:TCollectionItem);Override;
      Public
         Property Disabled:Boolean read FDisabled write SetDisabled;
         Property Image:LongInt read FImage write SetImage;
         Property HotImage:LongInt read FHotImage write SetHotImage;
         Property DisabledImage:LongInt read FDisabledImage write SetDisabledImage;
    End;

    TCoolSections2=Class(THeaderSections)
      Protected
         Function GetSection( Index: longint ): TCoolSection2;
      Public
         Procedure SetupComponent;Override;
         Property Items[ Index: Longint ]: TCoolSection2 read GetSection; default;
    End;

    TDrawCoolSectionEvent=Procedure(HeaderControl:THeaderControl;Section:TCoolSection2;
                                    Const rc:TRect;Pressed,Hot,Enabled:Boolean) Of Object;

    TCoolBar2=Class(THeaderControl)
      Private
         FBackgroundBitmap:TBitmap;
         FActiveSection:TCoolSection2;
         FImages:TImageList;
         FFlat:Boolean;
         FBackgroundOffset:LongWord;
         FMouseTimer:TTimer;
         FOnDrawSection:TDrawCoolSectionEvent;
         FHotColor: TColor;
      Private
         Procedure EvFMouseTimer(Sender:TObject);
         Procedure SetBackgroundBitmap(NewValue:TBitmap);
         Procedure UpdateHeader(Header:THeaderSection);Override;
         Procedure SetImages(NewValue:TImageList);
         Procedure SetFlat(NewValue:Boolean);
         Procedure SetBackgroundOffset(NewValue:LongWord);
         Function GetSections:TCoolSections2;
         Procedure SetSections(NewValue:TCoolSections2);
      Protected
         Procedure DrawSection(Section:TCoolSection2;Const rc:TRect;Pressed,Hot,Enabled:Boolean);Virtual;
         Procedure MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure MouseMove(ShiftState:TShiftState;X,Y:LongInt);Override;
         Procedure Notification( AComponent: TComponent;
                                 Operation:TOperation ); Override;
         Procedure DrawBackground( rec: TRect;
                                   XOffset, YOffset: longint );
      Public
         Procedure SetupComponent;Override;
         Procedure Redraw(Const rec:TRect);Override;
         Procedure ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);Override;
         Function WriteSCUResource(Stream:TResourceStream):Boolean;Override;
      Published
         Property BackgroundBitmap:TBitmap read FBackgroundBitmap write SetBackgroundBitmap;
         Property BackgroundOffset:LongWord read FBackgroundOffset write SetBackgroundOffset;
         Property Images:TImageList read FImages write SetImages;
         Property Flat:Boolean read FFlat write SetFlat;
         Property Sections:TCoolSections2 Read GetSections Write SetSections;
         Property HotColor: TColor read FHotColor write FHotColor;
      Published
         Property OnDrawSection:TDrawCoolSectionEvent Read FOnDrawSection Write FOnDrawSection;
    End;

Implementation

// default bitmap from resource file
// {$R CoolBar2}

exports
  TCoolBar2, 'User', 'Coolbar2.bmp';
{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCoolSection2 Class Implementation                           บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Constructor TCoolSection2.Create(ACollection:TCollection);
Begin
     Inherited Create(ACollection);
     FImage:=-1;
     FHotImage:=-1;
     FDisabledImage:=-1;
     AllowSize:= false;
     Width:= 60;
     Alignment:= taCenter;
End;

Procedure TCoolSection2.Assign(Source:TCollectionItem);
Begin
     Inherited Assign(Source);
     If Source Is TCoolSection2 Then
       If Source<>Self Then
     Begin
          FImage:=TCoolSection2(Source).Image;
          FHotImage:=TCoolSection2(Source).HotImage;
          FDisabledImage:=TCoolSection2(Source).DisabledImage;
          FDisabled:=TCoolSection2(Source).Disabled;
     End;
End;

Procedure TCoolSection2.SetDisabled(NewValue:Boolean);
Begin
     If NewValue=FDisabled Then exit;
     FDisabled:=NewValue;
     Changed(False);
End;

Procedure TCoolSection2.SetImage(NewValue:LongInt);
Begin
     If NewValue=FImage Then exit;
     FImage:=NewValue;
     Changed(False);
End;

Procedure TCoolSection2.SetHotImage(NewValue:LongInt);
Begin
     If NewValue=FHotImage Then exit;
     FHotImage:=NewValue;
     Changed(False);
End;

Procedure TCoolSection2.SetDisabledImage(NewValue:LongInt);
Begin
     If NewValue=FDisabledImage Then exit;
     FDisabledImage:=NewValue;
     Changed(False);
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCoolSections2 Class Implementation                          บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCoolSections2.SetupComponent;
Begin
    Inherited SetupComponent;
    Name:='CoolSections';
    ItemClass:=TCoolSection2;
End;

Function TCoolSections2.GetSection( Index: longint ): TCoolSection2;
begin
  Result:= ( inherited Items[ Index ] ) as TCoolSection2;
end;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Speed-Pascal/2 Version 2.0                                                บ
บ                                                                           บ
บ Speed-Pascal Component Classes (SPCC)                                     บ
บ                                                                           บ
บ This section: TCoolBar2 Class Implementation                               บ
บ                                                                           บ
บ (C) 1995,97 SpeedSoft. All rights reserved. Disclosure probibited !       บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Procedure TCoolBar2.SetupComponent;
Begin
     Inherited SetupComponent;

     FBackgroundBitmap := nil;
//     FBackgroundBitmap.Create;
//     FBackgroundBitmap.LoadFromResourceName('Cool');
     FFlat:=True;
     FMouseTimer.Create(Self);
     Include(FMouseTimer.ComponentState, csDetail);
     FMouseTimer.Interval := 50;
     FMouseTimer.OnTimer := EvFMouseTimer;
     Name:='CoolBar';
     SectionsClass:=TCoolSections2;
     FHotColor:= clBlue;
End;

Procedure TCoolBar2.SetFlat(NewValue:Boolean);
Begin
     If NewValue=FFlat Then exit;
     FFlat:=NewValue;
     Invalidate;
End;

Function TCoolBar2.GetSections:TCoolSections2;
Begin
     Result:=TCoolSections2(Inherited Sections);
End;

Procedure TCoolBar2.SetSections(NewValue:TCoolSections2);
Begin
     Inherited Sections:=NewValue;
End;


Procedure TCoolBar2.SetImages(NewValue:TImageList);
Begin
     If NewValue = FImages Then
       exit;
     If FImages<>Nil Then
       FImages.Notification( Self, opRemove );
     FImages:= NewValue;
     If FImages <> Nil Then
       FImages.FreeNotification( Self );
     Invalidate;
End;

Procedure TCoolBar2.Notification( AComponent: TComponent;
                                  Operation: TOperation );
Begin
     Inherited Notification( AComponent, Operation );

     If Operation = opRemove Then
       If AComponent = FImages Then
         FImages := Nil;
End;


Procedure TCoolBar2.SetBackgroundBitmap(NewValue:TBitmap);
Begin
     If NewValue=FBackgroundBitmap Then exit;
     If FBackgroundBitmap<>Nil Then FBackgroundBitmap.Destroy;
     If NewValue<>Nil Then FBackgroundBitmap:=NewValue.Copy
     Else FBackgroundBitmap:=Nil;
     Invalidate;
End;

Procedure TCoolBar2.SetBackgroundOffset(NewValue:LongWord);
Begin
     If NewValue=FBackgroundOffset Then exit;
     FBackgroundOffset:=NewValue;
     Invalidate;
End;

Procedure TCoolBar2.DrawSection(Section:TCoolSection2;Const rc:TRect;Pressed,Hot,Enabled:Boolean);
Var
   Align:TAlignment;
   S:String;
   CX,CY,CX1,CY1,H,X,Y:LongInt;
   rec,bmprec:TRect;
   PointsArray:Array[0..5] Of TPoint;
   offs:LongInt;
   FBitmap,FMask:TBitmap;
   bevelrc: TRect;
   bgrc: TRect;

   Procedure DrawMasked(Bitmap,Mask:TBitmap;X,Y:LongInt);
   Var Source,Dest:TRect;
   Begin
        If Bitmap=Nil Then exit;
        Source.Left:=0;
        Source.Bottom:=0;
        Dest.Left:=X;
        Dest.Bottom:=Y;

        If Mask<>Nil Then
        Begin
             Source.Right:=Mask.Width;
             Source.Top:=Mask.Height;
             Dest.Top:=Dest.Bottom+Mask.Height;
             Dest.Right:=Dest.Left+Mask.Width;
             Mask.Canvas.BitBlt(Canvas,Dest,Source,cmSrcAnd,bitfIgnore);
        End;

        Source.Right:=Bitmap.Width;
        Source.Top:=Bitmap.Height;
        Dest.Top:=Dest.Bottom+Bitmap.Height;
        Dest.Right:=Dest.Left+Bitmap.Width;
        If Mask<>Nil Then
          Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcPaint,bitfIgnore)
        Else
          Bitmap.Canvas.BitBlt(Canvas,Dest,Source,cmSrcCopy,bitfIgnore);

//        Canvas.ExcludeClipRect(Dest);
   End;

Begin
     Align:=section.Alignment;
     S:=section.Text;

     If S='' Then
     Begin
          CX:=0;
          CY:=0;
     End
     Else Canvas.GetTextExtent(S,CX,CY);

     FBitmap:=Nil;
     FMask:=Nil;
     If FImages<>Nil Then If FImages.Count>0 Then
     Begin
          If not Enabled Then
          Begin
              If Section.DisabledImage>=0 Then
              begin
                If FImages.Count>Section.DisabledImage Then
                Begin
                     FBitmap.Create;
                     FImages.GetBitmap(Section.DisabledImage,FBitmap);
                     FMask.Create;
                     FImages.GetMask(Section.DisabledImage,FMask);
                End;
              end
              else
              begin
                     FBitmap.Create;
                     FImages.GetBitmap(Section.Image,FBitmap);
                     FMask.Create;
                     FImages.GetMask(Section.Image,FMask);
                     Y:= 0;
                     while Y < FMask.Height do
                     begin
                       X:= 0;
                       if ( Y mod 2 ) = 1 then
                         X:= 1;
                       while X < FMask.Width do
                       begin
                         FMask.Canvas.Pixels[ X, Y ]:= clBlack;
                         FBitmap.Canvas.Pixels[ X, Y ]:= clBlack;
                         inc( X, 2 );
                       end;
                       inc( Y, 1 );
                     end;
              end;
          End
          Else If Hot Then
          Begin
              If Section.HotImage>=0 Then
              If FImages.Count>Section.HotImage Then
              Begin
                   FBitmap.Create;
                   FImages.GetBitmap(Section.HotImage,FBitmap);
                   FMask.Create;
                   FImages.GetMask(Section.HotImage,FMask);
              End;
          End;

          If FBitmap<>Nil Then If FBitmap.Empty Then
          Begin
               FBitmap.Destroy;
               FBitmap:=Nil;
          End;

          If FMask<>Nil Then If FMask.Empty Then
          Begin
               FMask.Destroy;
               FMask:=Nil;
          End;

          If FBitmap=Nil Then
          Begin
               If Section.Image>=0 Then
               If FImages.Count>Section.Image Then
               Begin
                    FBitmap.Create;
                    FImages.GetBitmap(Section.Image,FBitmap);
                    FMask.Create;
                    FImages.GetMask(Section.Image,FMask);
               End;
          End;

          If FBitmap<>Nil Then If FBitmap.Empty Then
          Begin
               FBitmap.Destroy;
               FBitmap:=Nil;
          End;

          If FMask<>Nil Then If FMask.Empty Then
          Begin
               FMask.Destroy;
               FMask:=Nil;
          End;
     End;

     CX1:=CX;
     CY1:=CY;

     If FBitmap<>Nil Then
     Begin
          If Align=taCenter Then inc(CY1,FBitmap.Height+3)
          Else inc(CX1,FBitmap.Width+3);
     End;

     Case Align Of
        taLeftJustify:
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX1) Div 2);
        End;
        taRightJustify:
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX1) Div 2);
             If FBitmap<>Nil Then inc(rec.Left,FBitmap.Width);
        End
        Else //taCenter
        Begin
             H:=rc.Right-rc.Left;
             rec.Left:=rc.Left+((H-CX) Div 2);
        End;
     End; //Case

     If rec.Left<rc.Left+3 Then rec.Left:=rc.Left+3;

     H:=rc.Top-rc.Bottom;
     rec.Bottom:=rc.Bottom+((H-CY1) Div 2);
     If rec.Bottom<rc.Bottom+3 Then rec.Bottom:=rc.Bottom+3;
     rec.Right:=rec.Left+CX-1;
     rec.Top:=rec.Bottom+CY-1;

     // Draw background
     bgrc:= rc;
     If ((not Flat)Or(Hot And Enabled)) Then
       InflateRect( bgrc,
                    - ( 1 + BevelWidth ),
                    - ( 1 + BevelWidth ) );

     if Pressed then
       DrawBackground( bgrc, 1, -1 )
     else
       DrawBackground( bgrc, 0, 0 );

     //Draw Bitmap
     If FBitmap<>Nil Then
     Begin
        H:=rc.Top-rc.Bottom;
        Y:=rc.Bottom+((H-CY1) Div 2);
        If Y<rc.Bottom+3 Then Y:=rc.Bottom+3;

        Canvas.Pen.Color:= clBlack;
        Case Align Of
            taLeftJustify:
            Begin
                 DrawMasked(FBitmap,FMask,rec.Right+3,Y);
            End;
            taRightJustify:
            Begin
                 DrawMasked(FBitmap,FMask,rec.Left-3-FBitmap.Width,Y);
            End;
            Else //taCenter
            Begin
                 H:=rc.Right-rc.Left;
                 X:=rc.Left+((H-FBitmap.Width) Div 2);
                 If X<rc.Left+3 Then X:=rc.Left+3;
                 if Pressed then
                 begin
                   inc( X );
                   dec( Y );
                 end;
                 DrawMasked(FBitmap,FMask,X,Y+CY+3);
            End;
         End; //Case

         FBitmap.Destroy;
         If FMask<>Nil Then FMask.Destroy;
     End;

     If S<>'' Then
     Begin
        Canvas.Brush.Mode:=bmTransparent;
        If not Enabled Then
          Canvas.Pen.Color:=clDkGray
        Else if Hot then
          Canvas.Pen.Color:= FHotColor
        else
          Canvas.Pen.Color:=PenColor;

        if Pressed then
          Canvas.TextOut(rec.Left+1,rec.Bottom-1,S)
        else
          Canvas.TextOut(rec.Left,rec.Bottom,S);
        Canvas.Brush.Mode:=bmOpaque;

//        Canvas.ExcludeClipRect(rec);
     End;

     If ((not Flat)Or(Hot And Enabled)) Then
     Begin
        // draw button outline
         Canvas.Pen.Color:= clBlack;
         Canvas.Rectangle( rc );
         bevelrc:= rc;
         InflateRect( bevelrc, -1, -1 );
         If BevelWidth > 1 Then
         Begin
              offs := BevelWidth-1;
              PointsArray[0] := Point(bevelrc.Left,bevelrc.Bottom);
              PointsArray[1] := Point(bevelrc.Left+offs,bevelrc.Bottom+offs);
              PointsArray[2] := Point(bevelrc.Left+offs,bevelrc.Top-offs);
              PointsArray[3] := Point(bevelrc.Right-offs,bevelrc.Top-offs);
              PointsArray[4] := Point(bevelrc.Right,bevelrc.Top);
              PointsArray[5] := Point(bevelrc.Left,bevelrc.Top);
              if Pressed then
                Canvas.Pen.color := clDkGray
              else
                Canvas.Pen.color := clWhite;
              Canvas.Polygon(PointsArray);
              PointsArray[2] := Point(bevelrc.Right-offs,bevelrc.Bottom+offs);
              PointsArray[3] := Point(bevelrc.Right-offs,bevelrc.Top-offs);
              PointsArray[4] := Point(bevelrc.Right,bevelrc.Top);
              PointsArray[5] := Point(bevelrc.Right,bevelrc.Bottom);
              if Pressed then
                Canvas.Pen.color := clWhite
              else
                Canvas.Pen.color := clDkGray;
              Canvas.Polygon(PointsArray);
              Canvas.Pen.color:=PenColor;
         End
         Else
           if Pressed then
             Canvas.ShadowedBorder(bevelrc,clDkGray,clWhite)
           else
             Canvas.ShadowedBorder(bevelrc,clWhite,clDkGray);
     End;
End;

Type
    PHeaderItem=^THeaderItem;
    THeaderItem=Record
        Image:LongInt;
        HotImage:LongInt;
        DisabledImage:LongInt;
        Disabled:Boolean;
    End;

Const rnCoolHeaders='rnCoolHeaders';

Procedure TCoolBar2.ReadSCUResource(Const ResName:TResourceName;Var Data;DataLen:LongInt);
Var
   Count:^LongInt;
   Items:PHeaderItem;
   section:TCoolSection2;
   T:LongInt;
   ps:^String;
Begin
     If ResName = rnCoolHeaders Then
     Begin
          Count:=@Data;
          Items:=@Data;
          Inc(Items,4);
          For T:=1 To Count^ Do
          Begin
               Section:=TCoolSection2(Sections[t-1]);
               section.Image:=Items^.Image;
               section.HotImage:=Items^.HotImage;
               section.DisabledImage:=Items^.DisabledImage;
               section.Disabled:=Items^.Disabled;
               Inc(Items,SizeOf(THeaderItem));
          End;
     End
     Else Inherited ReadSCUResource(ResName,Data,DataLen);
End;


Function TCoolBar2.WriteSCUResource(Stream:TResourceStream):Boolean;
Var MemStream:TMemoryStream;
    T:LongInt;
    Item:THeaderItem;
    section:TCoolSection2;
    S:String;
Begin
     Result := Inherited WriteSCUResource(Stream);
     If Not Result Then Exit;

     If Sections<>Nil Then If Sections.Count>0 Then
     Begin
          MemStream.Create;
          T:=Sections.Count;
          MemStream.Write(T,4);
          For T:=0 To Sections.Count-1 Do
          Begin
               section:=TCoolSection2(Sections[T]);
               Item.Image:=section.Image;
               Item.HotImage:=section.HotImage;
               Item.DisabledImage:=section.DisabledImage;
               Item.Disabled:=section.Disabled;
               MemStream.Write(Item,SizeOf(THeaderItem));
          End;

          Result:=Stream.NewResourceEntry(rnCoolHeaders,MemStream.Memory^,MemStream.Size);
          MemStream.Destroy;
     End;
End;

Procedure TCoolbar2.DrawBackground( rec: TRect;
                                    XOffset, YOffset: longint );
var
  X: longint;
  Y: longint;
  DrawRect: TRect;
  SourceRect: TRect;
  BlockWidth: longint;
  BlockHeight: longint;
  BitmapX: longint;
  BitmapY: longint;
begin
  If FBackgroundBitmap=Nil Then
  begin
    Canvas.FillRect( rec, Color );
    exit;
  end;

  Y:= rec.Bottom;
  While Y<=rec.Top Do
  Begin
    BitmapY:= ( Y - YOffset ) mod FBackGroundBitmap.Height;
    if BitmapY < 0 then
      BitmapY:= FBackGroundBitmap.Height + BitmapY;

    BlockHeight:= FBackgroundBitmap.Height - BitmapY;
    if Y + BlockHeight > rec.Top then
      BlockHeight:= rec.Top - Y + 1;

    X:= rec.Left;
    While X<=rec.Right Do
    Begin
      BitmapX:= ( X - XOffset ) mod FBackgroundBitmap.Width;
      if BitmapX < 0 then
        BitmapX:= FBackgroundBitmap.Width + BitmapX;

      BlockWidth:= FBackgroundBitmap.Width - BitmapX;
      if X + BlockWidth > rec.Right then
        BlockWidth:= rec.Right - X + 1;

      DrawRect.Left:= X;
      DrawRect.Right:= X + BlockWidth;
      DrawRect.Bottom:= Y;
      DrawRect.Top:= Y + BlockHeight;

      SourceRect.Left:= BitmapX;
      SourceRect.Right:= BitmapX + BlockWidth;
      SourceRect.Bottom:= BitmapY;
      SourceRect.Top:= BitmapY + BlockHeight;

      FBackgroundBitmap.PartialDraw( Canvas,
                                     SourceRect,
                                     DrawRect );
      inc( X, BlockWidth );
    End;
    inc( Y, BlockHeight );
  End;
end;

Procedure TCoolBar2.Redraw(Const rec:TRect);
Var X,Y:LongInt;
    rc,rc2,Src:TRect;
    FSections:TCoolSections2;
    Section:TCoolSection2;
    IsPressed:Boolean;
    t,W:LongInt;
Begin
    Canvas.ClipRect:=rec;

    Canvas.Pen.Color:= clDkGray;
    Canvas.Line( 0, 0, Width -1, 0 );
//    Canvas.Pen.Color:= cl3dLight;
//    Canvas.Line( 0, 0, Width -1, 0 );

    FSections:=TCoolSections2(Sections);
    rc:=ClientRect;
    Inc(rc.Bottom,1);
    For T:=0 To FSections.Count-1 Do
    Begin
          Section:=TCoolSection2(FSections[T]);
          rc.Right:=rc.Left+section.Width;
          If rc.Right>Width-1 Then rc.Right:=Width-1;

          IsPressed:=Section=ClickSection;

          rc2:=Forms.IntersectRect(rc,rec);
          If Not Forms.IsRectEmpty(rc2) Then
          Begin
               Canvas.ClipRect:=rc2;

               If ( Section.Style=hsOwnerDraw )
                  and ( OnDrawSection<>Nil ) Then
                 OnDrawSection(Self,section,rc,IsPressed,Section=FActiveSection,Section.Disabled=False)
               Else
                 DrawSection(section,rc,IsPressed,Section=FActiveSection,Section.Disabled=False);
          End;

          // draw space between this button and next
          rc2:= rc;
          rc2.Left:= rc.Right + 1;
          rc2.Right:= rc2.Left + Spacing - 1;
          rc2:=Forms.IntersectRect(rc2,rec);

          If Not Forms.IsRectEmpty(rc2) Then
          Begin
            Canvas.ClipRect:=rc2;
            DrawBackGround( rc2, 0, 0 );
          end;

          Inc(rc.Left,Section.Width+Spacing+1);
     End;

     rc.Right:= Width-1;
     rc2:=Forms.IntersectRect(rc,rec);
     If Not Forms.IsRectEmpty(rc2) Then
     Begin
       inc(rc2.Right);
       Canvas.ClipRect:=rc2;
       DrawBackground( rc, 0, 0 );
     end;
     Canvas.DeleteClipRegion;
End;

Procedure TCoolBar2.MouseDown(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var T:LongInt;
    section:TCoolSection2;
    FSections:TCoolSections2;
Begin
     TControl.MouseDown(Button,ShiftState,X,Y);

     If Button <> mbLeft Then Exit;

     FSections:=TCoolSections2(Sections);
     For T:=0 To FSections.Count-1 Do
     Begin
          section:=TCoolSection2(FSections[T]);
          If ((section.AllowSize)And(X>section.Right-2)And(X<section.Right+2)) Then
          Begin
               Inherited MouseDown(Button,ShiftState,X,Y);
               exit;
          End;
     End;

     If Designed Then Exit;

     //Test Press
     Section:=TCoolSection2(GetMouseHeader(X,Y));
     If Section<>Nil Then If section.AllowClick Then If not Section.Disabled Then
       Inherited MouseDown(Button,ShiftState,X,Y);
End;

Procedure TCoolBar2.MouseDblClick(Button:TMouseButton;ShiftState:TShiftState;X,Y:LongInt);
Var section:TCoolSection2;
Begin
     If Button=mbLeft Then
     Begin
          Section:=TCoolSection2(GetMouseHeader(X,Y));
          If Section<>Nil Then If section.AllowClick Then If not Section.Disabled Then
            Inherited MouseDblClick(Button,ShiftState,X,Y);
     End
     Else Inherited MouseDblClick(Button,ShiftState,X,Y);
End;

Procedure TCoolBar2.UpdateHeader(Header:THeaderSection);
Var T:LongInt;
    rc:TRect;
    FSections:TCoolSections2;
Begin
     //Get Rectangle For the Panel
     rc:=ClientRect;
     FSections:=TCoolSections2(Sections);
     For T:=0 To FSections.Count-1 Do
     Begin
          If FSections[T]=Header Then break
          Else Inc(rc.Left,FSections[T].Width+Spacing+1);
     End;

     rc.Right:=rc.Left+Header.Width+1;
     If not Flat Then InflateRect(rc,-BevelWidth*2,-BevelWidth*2);
     InvalidateRect(rc);
     Update;
End;


Procedure TCoolBar2.MouseMove(ShiftState:TShiftState;X,Y:LongInt);
Var
    Section,OldActiveSection:TCoolSection2;
Begin
     FMouseTimer.Stop;

     OldActiveSection:=FActiveSection;
     Section:=TCoolSection2(GetMouseHeader(X,Y));
     If ((Section=Nil)Or(not Section.Disabled)) Then FActiveSection:=Section;

     Inherited MouseMove(ShiftState,X,Y);

     If FActiveSection<>OldActiveSection Then
     Begin
          If OldActiveSection<>Nil Then UpdateHeader(OldActiveSection);
          If FActiveSection<>Nil Then UpdateHeader(FActiveSection);
     End;

     If FFlat Then FMouseTimer.Start;
End;


Procedure TCoolBar2.EvFMouseTimer(Sender:TObject);
Var
  AControl:TControl;
  OldActiveSection:TCoolSection2;
Begin
  FMouseTimer.Stop;

  AControl := Screen.GetControlFromPoint(Screen.MousePos);

  If AControl <> Self Then
  Begin
    OldActiveSection:=FActiveSection;
    FActiveSection := Nil;
    If OldActiveSection<>Nil Then UpdateHeader(OldActiveSection);
  End
  Else FMouseTimer.Start;
End;

{
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ                                                                           บ
บ Sibyl Version 2.0                                                         บ
บ                                                                           บ
บ This section: TCoolSectionsPropertyEditor Class implementation            บ
บ                                                                           บ
บ                                                                           บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
}

Type
    TCoolSectionsPropertyEditor=Class(TClassPropertyEditor)
      Public
         Function Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;Override;
    End;

    TCoolSectionsPropEditDialog=Class(TDialog)
      Private
         FSections:TCoolSections2;
         FListBox:TListBox;
         FText:TEdit;
         FWidth:TEdit;
         FMinWidth,FMaxWidth:TEdit;
         FImage,FHotImage,FDisabledImage:TEdit;
         FStyle:TComboBox;
         FAlignment:TComboBox;
         FCurrentSection:TCoolSection2;
         FCurrentIndex:LongInt;
         FAllowClick:TCheckBox;
         FAllowSize:TCheckBox;
         FDisabled:TCheckBox;
      Protected
         Procedure SetupComponent;Override;
         Procedure NewClicked(Sender:TObject);
         Procedure DeleteClicked(Sender:TObject);
         Procedure UpdateClicked(Sender:TObject);
         Procedure ListItemFocus(Sender:TObject;Index:LongInt);
         Procedure StoreItem;
         Procedure TextChange(Sender:TObject);
         Procedure WidthChange(Sender:TObject);
         Procedure MinWidthChange(Sender:TObject);
         Procedure MaxWidthChange(Sender:TObject);
         Procedure ImageChange(Sender:TObject);
         Procedure HotImageChange(Sender:TObject);
         Procedure DisabledClick(Sender:TObject);
         Procedure DisabledImageChange(Sender:TObject);
         Procedure StyleSelect(Sender:TObject;Index:LongInt);
         Procedure AlignmentSelect(Sender:TObject;Index:LongInt);
    End;


{$HINTS OFF}
Procedure TCoolSectionsPropEditDialog.TextChange(Sender:TObject);
Begin
     If FCurrentSection=Nil Then exit;
     FCurrentSection.Text:=FText.Text;
End;

Procedure TCoolSectionsPropEditDialog.WidthChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If FCurrentSection=Nil Then exit;
     VAL(FWidth.Text,i,c);
     If c<>0 Then exit;
     FCurrentSection.Width:=i;
End;

Procedure TCoolSectionsPropEditDialog.MinWidthChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If FCurrentSection=Nil Then exit;
     VAL(FMinWidth.Text,i,c);
     If c<>0 Then exit;
     FCurrentSection.MinWidth:=i;
End;

Procedure TCoolSectionsPropEditDialog.MaxWidthChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If FCurrentSection=Nil Then exit;
     VAL(FMaxWidth.Text,i,c);
     If c<>0 Then exit;
     FCurrentSection.MaxWidth:=i;
End;

Procedure TCoolSectionsPropEditDialog.DisabledClick(Sender:TObject);
Begin
     If FCurrentSection=Nil Then exit;
     FCurrentSection.Disabled:=FDisabled.Checked;
End;

Procedure TCoolSectionsPropEditDialog.ImageChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If FCurrentSection=Nil Then exit;
     VAL(FImage.Text,i,c);
     If c<>0 Then exit;
     FCurrentSection.Image:=i;
End;

Procedure TCoolSectionsPropEditDialog.HotImageChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If FCurrentSection=Nil Then exit;
     VAL(FHotImage.Text,i,c);
     If c<>0 Then exit;
     FCurrentSection.HotImage:=i;
End;

Procedure TCoolSectionsPropEditDialog.DisabledImageChange(Sender:TObject);
Var i:LongInt;
    c:Integer;
Begin
     If FCurrentSection=Nil Then exit;
     VAL(FDisabledImage.Text,i,c);
     If c<>0 Then exit;
     FCurrentSection.DisabledImage:=i;
End;


Procedure TCoolSectionsPropEditDialog.StyleSelect(Sender:TObject;Index:LongInt);
Begin
     If FCurrentSection=Nil Then exit;
     If FStyle.Text='OwnerDraw' Then FCurrentSection.Style:=hsOwnerDraw
     Else FCurrentSection.Style:=hsText;
End;

Procedure TCoolSectionsPropEditDialog.AlignmentSelect(Sender:TObject;Index:LongInt);
Begin
     If FCurrentSection=Nil Then exit;
     If FAlignment.Text='Center' Then FCurrentSection.Alignment:=taCenter
     Else If FAlignment.Text='Right justify' Then FCurrentSection.Alignment:=taRightJustify
     Else FCurrentSection.Alignment:=taLeftJustify;
End;

Procedure TCoolSectionsPropEditDialog.UpdateClicked(Sender:TObject);
Begin
     StoreItem;
     FSections.Update(Nil);
End;

Procedure TCoolSectionsPropEditDialog.NewClicked(Sender:TObject);
Var Section:THeaderSection;
Begin
     Section:=FSections.Add;
     If Section.Text='' Then FListBox.Items.Add(tostr(Section.Index)+' - (Untitled)')
     Else FListBox.Items.Add(tostr(Section.Index)+' - '+Section.Text);
     FListBox.ItemIndex:=Section.Index;
     FSections.Update(Nil);
     FText.SetFocus;
End;

Procedure TCoolSectionsPropEditDialog.DeleteClicked(Sender:TObject);
Var Section:THeaderSection;
    Index:LongInt;
Begin
     Index:=FListBox.ItemIndex;
     If Index<0 Then exit;
     FListBox.Items.Delete(Index);
     Section:=FSections[Index];
     Section.Destroy;
     FCurrentSection:=Nil;
     FCurrentIndex:=-1;
     If FListBox.Items.Count>0 Then FListBox.ItemIndex:=0;
End;
{$HINTS ON}

Procedure TCoolSectionsPropEditDialog.StoreItem;
Var c:Integer;
    i:LongInt;
Begin
     If FCurrentSection<>Nil Then //store values
     Begin
          FCurrentSection.Text:=FText.Text;
          If FText.Text='' Then FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - (Untitled)'
          Else FListBox.Items[FCurrentIndex]:=tostr(FCurrentIndex)+' - '+FText.Text;

          VAL(FWidth.Text,i,c);
          If c<>0 Then i:=100;
          FCurrentSection.Width:=i;

          VAL(FMinWidth.Text,i,c);
          If c<>0 Then i:=0;
          FCurrentSection.MinWidth:=i;

          VAL(FMaxWidth.Text,i,c);
          If c<>0 Then i:=10000;
          FCurrentSection.MaxWidth:=i;

          VAL(FImage.Text,i,c);
          If c<>0 Then i:=10000;
          FCurrentSection.Image:=i;

          VAL(FHotImage.Text,i,c);
          If c<>0 Then i:=10000;
          FCurrentSection.HotImage:=i;

          VAL(FDisabledImage.Text,i,c);
          If c<>0 Then i:=10000;
          FCurrentSection.DisabledImage:=i;

          FCurrentSection.Disabled:=FDisabled.Checked;

          If FStyle.Text='OwnerDraw' Then FCurrentSection.Style:=hsOwnerDraw
          Else FCurrentSection.Style:=hsText;

          If FAlignment.Text='Center' Then FCurrentSection.Alignment:=taCenter
          Else If FAlignment.Text='Right justify' Then FCurrentSection.Alignment:=taRightJustify
          Else FCurrentSection.Alignment:=taLeftJustify;

          FCurrentSection.AllowClick:=FAllowClick.Checked;
          FCurrentSection.AllowSize:=FAllowSize.Checked;
     End;
End;

Procedure TCoolSectionsPropEditDialog.ListItemFocus(Sender:TObject;Index:LongInt);
Begin
     StoreItem;

     FCurrentSection:=TCoolSection2(FSections[Index]);
     FCurrentIndex:=Index;
     FText.Text:=FCurrentSection.Text;
     FWidth.Text:=tostr(FCurrentSection.Width);
     FMinWidth.Text:=tostr(FCurrentSection.MinWidth);
     FMaxWidth.Text:=tostr(FCurrentSection.MaxWidth);
     FImage.Text:=tostr(FCurrentSection.Image);
     FHotImage.Text:=tostr(FCurrentSection.HotImage);
     FDisabledImage.Text:=tostr(FCurrentSection.DisabledImage);
     FDisabled.Checked:=FCurrentSection.Disabled;
     If FCurrentSection.Style=hsText Then FStyle.Text:='Text'
     Else FStyle.Text:='OwnerDraw';

     Case FCurrentSection.Alignment Of
        taRightJustify:FAlignment.Text:='Right justify';
        taCenter:FAlignment.Text:='Center';
        Else FAlignment.Text:='Left justify';
     End;

     FAllowClick.Checked:=FCurrentSection.AllowClick;
     FAllowSize.Checked:=FCurrentSection.AllowSize;
End;

Procedure TCoolSectionsPropEditDialog.SetupComponent;
Var Button:TButton;
    ComboBox:TComboBox;
Begin
     Inherited SetupComponent;

     Caption:='CoolBar sections editor';
     Width:=445;
     Height:=380;

     InsertGroupBox(Self,10,50,180,290,'Sections');
     FListBox:=InsertListBox(Self,20,100,160,220,'');
     FListBox.OnItemFocus:=ListItemFocus;

     Button:=InsertButton(Self,20,60,70,30,'New','New Section');
     Button.OnClick:=NewClicked;
     Button:=InsertButton(Self,100,60,70,30,'Delete','Delete Section');
     Button.OnClick:=DeleteClicked;

     InsertGroupBox(Self,200,50,230,290,'Section Properties');

     InsertLabel(Self,210,290,50,20,'Text');
     FText:=InsertEdit(Self,280,295,140,20,'','');
     FText.OnChange:=TextChange;

     InsertLabel(Self,210,260,100,20,'Width');
     FWidth:=InsertEdit(Self,280,265,140,20,'','');
     FWidth.OnChange:=WidthChange;
     FWidth.NumbersOnly:=TRUE;

     InsertLabel(Self,210,230,60,20,'Min/Max');
     FMinWidth:=InsertEdit(Self,280,235,65,20,'','');
     FMinWidth.OnChange:=MinWidthChange;
     FMinWidth.NumbersOnly:=TRUE;
     FMaxWidth:=InsertEdit(Self,355,235,65,20,'','');
     FMaxWidth.OnChange:=MaxWidthChange;
     FMaxWidth.NumbersOnly:=TRUE;

     InsertLabel(Self,210,200,100,20,'Style');
     FStyle:=InsertComboBox(Self,280,205,140,20,csDropDownList);
     FStyle.Items.Add('Text');
     FStyle.Items.Add('OwnerDraw');
     FStyle.OnItemSelect:=StyleSelect;

     InsertLabel(Self,210,170,100,20,'Alignment');
     FAlignment:=InsertComboBox(Self,280,175,140,20,csDropDownList);
     FAlignment.Items.Add('Left justify');
     FAlignment.Items.Add('Right justify');
     FAlignment.Items.Add('Center');
     FAlignment.OnItemSelect:=AlignmentSelect;

     FAllowClick:=InsertCheckBox(Self,210,135,100,20,'Allow Click','');
     FAllowSize:=InsertCheckBox(Self,210,115,100,20,'Allow Size','');
     FDisabled:=InsertCheckBox(Self,210,95,100,20,'Disabled','');
     FDisabled.OnClick:=DisabledClick;

     InsertLabel(Self,300,133,100,20,'Image');
     FImage:=InsertEdit(Self,400,138,20,20,'','');
     FImage.OnChange:=ImageChange;
     FImage.NumbersOnly:=TRUE;

     InsertLabel(Self,300,113,100,20,'HotImage');
     FHotImage:=InsertEdit(Self,400,118,20,20,'','');
     FHotImage.OnChange:=HotImageChange;
     FHotImage.NumbersOnly:=TRUE;

     InsertLabel(Self,300,93,100,20,'DisabledImage');
     FDisabledImage:=InsertEdit(Self,400,98,20,20,'','');
     FDisabledImage.OnChange:=DisabledImageChange;
     FDisabledImage.NumbersOnly:=TRUE;

     Button:=InsertButton(Self,210,60,200,30,'Update','Update Section');
     Button.OnClick:=UpdateClicked;

     InsertBitBtn(Self,10,10,90,30,bkOk,'~Ok','Click here to accept');
     InsertBitBtn(Self,110,10,90,30,bkCancel,'~Cancel','Click here to cancel');
     InsertBitBtn(Self,210,10,90,30,bkHelp,'~Help','Click here to get help');
End;

Function TCoolSectionsPropertyEditor.Execute(Var ClassToEdit:TObject):TClassPropertyEditorReturn;
Var  HeaderSections:TCoolSections2;
     FDialog:TCoolSectionsPropEditDialog;
     SaveHeaders:TCoolSections2;
     Section:TCoolSection2;
     t:LongInt;
Begin
     HeaderSections:=TCoolSections2(ClassToEdit);
     If HeaderSections.HeaderControl=Nil Then
     Begin
          result:=peNoEditor;
          exit;
     End;

     SaveHeaders.Create(Nil);
     SaveHeaders.Assign(HeaderSections);

     FDialog.Create(Nil);
     FDialog.FSections:=HeaderSections;

     For t:=0 TO HeaderSections.Count-1 Do
     Begin
          Section:=TCoolSection2(HeaderSections[t]);
          If Section.Text='' Then FDialog.FListBox.Items.Add(tostr(t)+' - (Untitled)')
          Else FDialog.FListBox.Items.Add(tostr(t)+' - '+Section.Text);
     End;
     If FDialog.FListBox.Items.Count>0 Then FDialog.FListBox.ItemIndex:=0;

     FDialog.ShowModal;

     //Modify ClassToEdit here
     result:=peCancel;
     Case FDialog.ModalResult Of
        cmOk:
        Begin
             FDialog.StoreItem;
             result:=peOk;
        End;
        Else
        Begin
             HeaderSections.Assign(SaveHeaders);
             result:=peCancel;
        End;
     End; {Case}

     SaveHeaders.Destroy;
     FDialog.Destroy;
End;

Initialization
   RegisterClasses([TCoolBar2]);
   //Register property editor
   AddClassPropertyEditor(TCoolSections2,TCoolSectionsPropertyEditor);
End.
