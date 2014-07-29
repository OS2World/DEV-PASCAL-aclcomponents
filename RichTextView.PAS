Unit RichTextView;

Interface

Uses
  Os2Def,
  Classes, Forms, Messages, Graphics,
  CanvasFontManager; // menus for SPCC 2.5+

{ Note font scheme:
  Tms Rmn 8 as font
          10, 14 and 18 as headings - these are all bitmap fonts(?)
Enhancements
 - Test smooth scrolling on slower systems
 - optimise fontmanager to pre-register facenames
 - horz lines
 - line/para spacing

Remaining keyboard support
 - back/forward word
 - begin/end of line
 - cursor down to go to end of line (this is tricky)

--- Rich Text Viewer  ---

V2.10.9
Allow for basic left/right margin in setting up horz scrollbar.

V2.10.8
Fixed problems when horizontal scrollbar showing - I was setting
a tiny cliprect in DrawBorder for doing the corner block between
scrollbars. This meant the background did not get cleared.

Also use clBtnFace for this corner block, rather than Parent.Color(!)

V2.10.7
Problem 1: Redraw clearing the entire region (not setting cliprect first)
Problem 2: Redraw was copying vertical position from scrollbar. But we
  may be redrawing for a new position before scrollbar is updated
  (ie. during scrolling).
I've reworked scrolling a bit - again.
It hasn't come out very elegant, but at least scrolling does work
with the normal Update method.

V2.10.6
Fixed up a couple of special cases in MouseDown:
correctly handle clicking outside text area (i.e. in border)
and below text (when text height < control height: set the cursor
to the end of text).

V2.10.5
Standardised border, use DrawSystemBorder.
When both scrollbars show, there is now a square between
them as is standard.

V2.10.4
Painful: had to rethink how and when layout is done.
Now it is done primarily on resize. This occurs during
first show.
This fixes problems with initial show in some circumstances,
e.g. on a notebook. At some point I was causing another paint
which was overwriting what had just been done (by the parent
control?).

Also, now will correctly work when TopCharIndex is set before
the control is visible. It's saved in a variable and used on the
first resize to set the initial scrollbar position.

Style.LeftMargin is now in terms of FontWidthPrecisionFactor... this
removes many multiplication (that I had forgotten to code ;-)
This fixes problems with not wrapping properly with margins.

I figured out why the repositioning on resize may not have
*seemed* correct. If you are at the bottom and make the control
wider, it will generally need scrolling; hence, it cannot be
positioned as far down as it was.

V2.10.3
Do layout & refresh when imagelist is set.

V2.10.2
On Resize, attempts to reposition to same point.
Fixed problem showing cursor, highlighting problem
in GetXFromOffset, at end of line.

V2.10.1
Added TopCharIndex property


V2.9.0
Fixed problem of not correctly wrapping outline fonts.
Now, widths are calculated to 1/256th of a pixel. This
is done by making outline fonts 256x bigger (setting the
CharBox to 256x bigger). For bitmap fonts we just work out
the normal pixel measurement and manually x256.

Also modularised a little: all the calculations for
the starting X coord of a line are now in GetStartX.

And the fixed font sets size as well as face name.

V2.8.14
Fixed bug - not allocating memory in copyselectiontoclipboard
(broken since upgrade to Sibyl FP4)

V2.8.13
Fixed notification up for image list. No functional change.

V2.8.12
Stupid - I broke copy and paste...
Forgot to add spaces and line breaks

V2.8.11
Further nitpicking around wrapping when there is only a single image
or character fitting on the line, and when they are the only thing in
the paragraph.

V2.8.10
Escape code << for a literal <
And >> for a literal >.
Had to build up string while drawing line, element
by element.

V2.8.9
Force a repaint after each scroll movement (but not during smooth scroll)
by *posting* a WM_PAINT. Seems that synchronously doing the paint
(ie. SendMsg or WinUpdateWindow) does not work.
This restores the scroll redraw behavior to what it was before
I generalised the scrolling.

V2.8.8
Generalised all the scrolling code and moved to a seperate unit.

V2.8.7
Added "basic" left and right margins (in pixels)

V2.8.6
Fixed a focus problem - in ScanEvent set the keycode to null to
indicate the key has been handled. Otherwise  cursor keys can
cause the control to lose focus.

V2.8.5
Correctly free the FLines memory! Was using Dispose but that doesn't
know the size of the array..
Also mdifed fonthandler to use 64 bytes for font name, not 255.
And reduced initial FLInes allocation to 10.
This reduces inital memory required from @50Kb to @10kB

The link pointer was not being freed when the view was destroyed.
Have changed this to load one global instance.

Destroy the fonts (FFixedFont etc) which are copied at creation.

Destroy the fontmanager if it was created.
SHIT! FontManager was not destroyed the TCustomFont objects it creates!
Now we are losing 0 or a few bytes... sounds alright to me...
Well in fact it loses an increasing amount... supposedly... usually zero
but then it will lose 100 bytes, 112, 128... don't see how this can be
except a bug in sibyl?
Seems to be in CreateDefaultMenu.

OK. It is this: each time a MenuItem is created, it is registered with
Application.NewMenuItem (for purposes of generating a unique command
number?). They are never deleted from this list, just the references
are nulled out when the MenuItem is destroyed.

The perfect fix would be for SPCC to reuse items (for speed, maintain
a list of slots to be reused, this would be quicker than searching the
list of allocated slots for unused ones)

My workaround is simply to disable the default menu. Now memory leaks
are zero for simply creating and deleting a view. Also for adding 3.5k
of text.

V2.8.4
Small change - make sure no code is left to run after calling the
OnClickLink handler, in case that handler deletes the component.

V2.8.3
Fixed: would crash if inserted image tag without any imagelist assigned.
Changed link events to include sender.

V2.8.2
Fixed bug in layout. Noticed it when displaying a single space. Was
not getting char width for spaces that wrapped the line.

V2.8.1
If move while on link, change cursor back to
I-Beam
Implemented control cursor up/down

V2.8.0
Not much functional change, but now the cursor row,
and offset in the row, are stored seperately from
the selectionstart and end. The main benefit of this
is a less confusing way of distinguishing the end
of a wrapped line from the start of the next.

V2.7.10
Fixed a bug in cursor down
View now scrolls when cursor would go off screen :-)
Modularity - it's great - because of all the time spent
earlier getting scrolling, layout etc correct and providing
useful query functions, doing this stuff is *remarkably*
easy...

V2.7.9
Cursor up and down...

V2.7.8
Can now start selection, as well as adjusting existing selection,
with shift cursor left/right (small changes to moveOneCharRight/Left)

V2.7.7
Move a few remaining GpiXXX calls to font manager. This increases
platform independence.
Apart from a few WinXXX calls (notably WinScrollWindow and WinGetTimer)
this makes it pretty much complete.

V2.7.6
Now the cursor height is set according to the current text
height not just the line height.

V2.7.5
Implemented move left one char (cursor left etc)
Also fixed problems with end of line again: this time the GetLineFromIndex
function, now, once it has found the index, if it's at the end of a line and
the next line starts with the same index then it uses the next line.

V2.7.4
Mostly just to prove it could be done, I made the cursor right
function work, including with shift down to preserve selection

V2.7.3
After a huge amount of pissing about, made setting the cursor
to the end of a line work for all (I hope) cases.
The main complicating factor is that, intuitively, we
expect to be able to set the cursor to the end of a line,
even if in fact the line is wrapped. In this case the end
of the previous line is the same point as the start of the new
so simply storing the character index is not enough.

So I added a flag that stores this special case...

V2.7.2
Removed the need for adjustselection by, when a selection start/end
is encountered during drawing, don't just toggle the selection
but actually work out what the next status will be.

V2.7.1
Cursor is now limited to fit on top/bottom line if line is only
partially showing.
Also checks whether X position is in visible range.

V2.7.0
Whacked in a caret (cursor) - mostly goes, needs a few refinements.
Doesn't move round with keyboard yet of course.

V2.6.1
Bug fix for bitmaps being first thing on line and wider than
the page. Would previously not update line height
Also removed some unused variables

V2.6.0
Replace MakeCharTop with MakeCharVisible - makes sure a given
char index is visible. Scrolls if needed.
Added Find method which searches for text
from start or current selection.

V2.5.7
Fixed a bug with selection ending/starting on an empty line
- when drawing the selection would not be checked.
Fixed a bug with timed scrolling - would try to scroll past end of
screen and fail when GetBottomLine said the bottom line was -1 (none)
This occurred because the scrollbar max was not set when the scrollbar
was not required

V2.5.7
Now DrawLine optimises out successive characters into strings
(as it used to, but still with the proper parsing)
This makes it several times faster... I guess there is big
overhead in GpiCharString.. this is especially noticeable with
outline fonts.

V2.5.6
Now inverts bitmaps when selected.
Used a hack to get around Private fields in SPCC bitmap

V2.5.5
Restored findX, so that selection works properly again

V2.5.4
Correct bitmap wrapping;

V2.5.3
Corrected bitmap display; wrapping is still not correct tho

V2.5.2
Corrected a couple more minor issues with wrapping before any words
completed...

V2.5.1
One small change: the font height is always checked at
the end of the line. This seems like reasonable behaviour;
and it simplifies checking for various cases of line ends.

V2.5.0
Substantial restructuring - now the text is parsed
somewhat more formally, so that each distinct piece of the
text is processed as an item, e.g. a character, a bitmap, a style tag
Still some bugs

V2.4.0
Now supports bitmaps
Images are stored in an associated TImageList
Referred to by <image x> where x is the image list index.
Plenty of bugs at this point

V2.3.5
Combined font, alignment and left margin into a Text Draw Style
this simplifies various things. Should have done it a while ago.

V2.3.4
Fixed problem scrolling with selection; I had never implemented
the selection check for when a line is skipped because it is outside
the clip region (doh!)

V2.3.3
Fixed problem with selection, when moving cursor after text
but still within text rect (i.e. when text height < control height)

V2.3.2
Handles cursor/page up/down and home/end

V2.3.1
Can set left margin

V2.3.0
Hotlinks

V2.2.5
Now tag parsing handles arguments <type args>

V2.2.4
Noticed and fixed: inverted colors (when selected)
were just black and white - the oppositeRGB Sibyl function does this!
Created my own InvertRGB

V2.2.3
Fixed problems with centreing etc with small widths; two
problems IIRC:
1) Looking backwards to find char positions is not
   always possible since we may have just started a new block
2) Linewidth was counting final space (when wrapped) so that centering
   was a bit off
Fixing 1 required a complete rewrite of the character width calculations.
Now it does it much more sensibly by simply cacheing all the character widths
(this is handled in the font manager: the interface is just 'how wide is this
character in the current font')
This lead to various simplifications in the layout

V2.2.2
Tidied up FontManager interface and found a few redundancies and mistakes
in the viewer!

V2.2.1
Simplified call to Drawline and tidied a few things up.

V2.2.0
Implemented alignment change during text
Note: if any text is not aligned <align=none> then that text will
push the right margin out for DISPLAY of centred/right aligned text, but
does not affect the right margin for layout. Who cares.
(NB This could be fixed by a two stage layout - first work out how long
the longest line is, then go through and align)
This is really only here for View compatibility which does the same thing

V2.1.0
Horizontal scrolling (smooth) works - 10 minutes!
Also decided to put in the optimisation of checking
if the line is within cliprect before drawing;
it must save some time at least

V2.0.5
Couple of navigation methods

V2.0.4
IMplemented two-speed scrolling when selecting

V2.0.3
Fixed remaining bug with selecting past end of text...
Now to copy for horizontal scrolling

V2.0.2
This fucking rocks!
Has a default menu with select all etc
Fixed problems with copying when selectionstart > selectionend
Focuses again (strangely that's not part of TControl.MouseDown)

V2.0.1
Pure extravagance. Smooth scrolling!
Actually this was good for sorting out issues
around scrolling and redrawing

V2.0.8
Okay... now scrolling selection works also
There is a bug around deselecting...

V2.0.7
Selection is going nicely now, and is reasonably incremental;
only needed lines are redrawn for selection changes.
Have not reimplemented scrolling.

V2.0.6
Wrote Find functions.
Slightly changed selection display. Now does not check selected
for the last +1 char of a line - this results in inverting selected
twice for a wrapped line
Setting selection end now makes sure that if at end of line, is moved
to start of next so will be found during display
(Still dose not check tag)
All this involved various modularisations. Good

V2.0.5
Selection display works now.

V2.0.4
Completed horizontal scroll bar & interactions
This highlighted a problem with determing line width -
was not taking into account the last word.

V2.0.3
Draw as scroll bar tracks...

V2.0.2
Vertical scroll bar is going once again; in fact better
than before, because line up/down (arrow click)
now moves exactly the right amount to make the next line visible

V2.0.1
Fixed the font handling so that if a given facename/size results in a
bitmap font, then bold/italic versions will use simulated bold/italic rather
than searching for specific bold/italic faces. Previously, OS/2 would substitue
an outline font in that case, making the bold/italic version look completely different
to the plain version

V2.0.0
Significant rewrite - now layout is done separately from
drawing and an array of physical lines is kept.
This makes many things nicer to do...
Have not yet got back to same state as before.

V1.1.4
Tidied up selecting where selection start same as end

V1.1.3
OK Keyboard copy works (Ctrl+C and Ctrl+Ins)

V1.1.2
Now can copy data to clipboard (no key link yet)

V1.1.1
MOre optimising (that I thought was already there!)
- now correctly stops as soon as off bottom of control
  when drawing or finding point
Fixed selecting past end of text for all cases ( I think! )

V1.1.0
Now scrolls if you move off the control
while selecting.
}
Type
  TFindOrigin = ( foFromStart, foFromCurrent );

  TTextElementType = ( teText, // a set of characters
                       teWordBreak,
                       teLineBreak, // end of para
                       teTextEnd,
                       teImage,
                       teStyle );

  TTagType = ( ttInvalid,
               ttBold, ttBoldOff,
               ttItalic, ttItalicOff,
               ttUnderline, ttUnderlineOff,
               ttFixedWidthOn, ttFixedWidthOff,
               ttHeading1, ttHeading2, ttHeading3, ttHeadingOff,
               ttRed, ttBlue, ttGreen, ttBlack,
               ttAlignNone,
               ttAlignLeft, ttAlignRight, ttAlignCentre, ttAlignFull,
               ttDefaultAlign,
               ttBeginLink, ttEndLink,
               ttSetLeftMargin,
               ttImage,
               ttEnd );
  TTag = record
    TagType: TTagType;
    Arguments: string;
  end;

  TTextElement = record
    ElementType: TTextElementType;
    Character: Char;
    Tag: TTag;
  end;

  TTextAlignment = ( taNone,
                     taLeft,  // standard "word wrap"
                     taRight,
                     taCentre,
                     taFull );

  TTextDrawStyle = record
    Font: TFontSpec;
    Alignment: TTextAlignment;
    LeftMargin: longint;
  end;

  TLineStart = record
    Text: PChar;
    Length: longint;

    Height: longint;
    Width: longint;

    MaxDescender: longint;

    LinkIndex: longint; // link index at start of line, if any

    Style: TTextDrawStyle;

    Wrapped: boolean;
  end;

  TLinesArray = array[ 0..0 ] of TLineStart;

  TScrollingDirection = ( sdUp, sdDown );

const
  TagStr: array[ ttInvalid .. ttEnd ] of string =
  (
    '', //
    'b',
    '/b',
    'i',
    '/i',
    'u',
    '/u',
    'tt',
    '/tt',
    'h1',
    'h2',
    'h3',
    '/h',
    'red',
    'blue',
    'green',
    'black',
    'unaligned',
    'left',
    'right',
    'center',
    'justify',
    'defaultalign',
    'link',
    '/link',
    'margin',
    'image',
    ''
  );
  liAboveTextArea = -1;
  liBelowTextArea = -2;
  liBelowText = -3;

Type

  TRichTextView = class;

  TLinkEvent = procedure( Sender: TRichTextView; Link: string ) of object;

  TRichTextView=Class(TControl)
  Protected
    FontManager: TCanvasFontManager;

    FHeading1Font: TFont;
    FHeading2Font: TFont;
    FHeading3Font: TFont;

    FFixedFont: TFont;
    FNormalFont: TFont;

    // Properties
    FBorderStyle:TBorderStyle;
    FScrollbarWidth: longint;
    FDefaultAlignment: TTextAlignment;
    FBasicLeftMargin: longint;
    FBasicRightMargin: longint;
    FSmoothScroll: boolean;
    FUseDefaultMenu: boolean;
    FDebug: boolean;

    FOnOverLink: TLinkEvent;
    FOnNotOverLink: TLinkEvent;
    FOnClickLink: TLinkEvent;

    FDefaultMenu: TPopupMenu;
      FSelectAllMI: TMenuItem;
      FCopyMI: TMenuItem;

      FRefreshMI: TMenuItem;

      FWordWrapMI: TMenuItem;
      FSmoothScrollMI: TMenuItem;
      FDebugMI: TMenuItem;

    // Internal layout data
    FNeedVScroll, FNeedHScroll: boolean;
    FLines: ^TLinesArray;
    FAllocatedNumLines: Longint;
    FNumLines: longint;
    FMaxTextWidth: longint;
    FTotalTextHeight: longint;

    FLinks: TStringList;

    // Child controls
    FHScrollbar: TScrollbar;
    FVScrollbar: TScrollbar;

    // Text
    FText: PChar;

    FTopCharIndex: longint; // only applies until following flag set.
    FVerticalPositionInitialised: boolean;

    FCursorRow: longint;
    FCursorOffset: longint;

    FSelectionStart: longint;
    FSelectionEnd: longint;

    // The text cursor
    FCaret: TCaret;

    FImages: TImageList;

    // Selection scrolling
    FScrollTimer: TTimer;
    FOldMousePoint: TPoint;
    FScrollingDirection: TScrollingDirection;

    // Scroll information
    // we use these rather than the scrollbar positions direct,
    // since those are not updated during tracking
    FXScroll: longint;
    FYScroll: longint;

    FLastXScroll: longint;
    FLastYScroll: longint;

    // Link
    FLastLinkOver: string;
    FClickedLink: string;

//    FLinkPointer: TPointer;
    FLinkCursor: TCursor;

    // PM Events
    Procedure SetupShow; override;
    Procedure Resize; override;
    Procedure SetupComponent; Override;

    Procedure Redraw( const rec: TRect ); Override;

    procedure ScanEvent( Var KeyCode: TKeyCode;
                         RepeatCount: Byte ); override;

    Procedure MouseDown( Button: TMouseButton;
                         ShiftState: TShiftState;
                         X, Y: Longint ); override;
    Procedure MouseUp( Button: TMouseButton;
                       ShiftState: TShiftState;
                       X, Y: Longint ); override;

    Procedure MouseMove( ShiftState: TShiftState;
                         X, Y: Longint ); override;

    Procedure Scroll( Sender: TScrollbar;
                      ScrollCode: TScrollCode;
                      Var ScrollPos: Longint ); override;

    Procedure KillFocus; override;
    Procedure SetFocus; override;

    // Scroll functions

    // Scroll display to given positions (does NOT
    // update scrollbars as this may be called during
    // scrolling)
    Procedure DoVerticalScroll( NewY: longint );
    Procedure DoHorizontalScroll( NewX: longint );

    // Set scrollbar position, and update display
    Procedure SetVerticalPosition( NewY: longint );
    Procedure SetHorizontalPosition( NewX: longint );

    procedure OnScrollTimer( Sender: TObject );

    Function GetLineDownPos: longint;
    Function GetLineUpPos: longint;

    // Drawing functions

    Procedure Draw( StartLine, EndLine: longint );
    Procedure DrawBorder;

    Function GetDrawRect: TRect;
    Function GetTextAreaRect: TRect;
    Function GetTextAreaHeight: longint;

    Procedure PerformStyleTag( Tag: TTag;
                               Var Style: TTextDrawStyle );

    // Draw a string at the given location with given color/selected state
    Procedure DrawString( Var X: longint;
                          Y: longint;
                          S: PChar;
                          Len: longint;
                          Selected: Boolean;
                          PenColor: TColor );


    function GetElementWidth( Element: TTextElement ): longint;

    // Draw the specified line at the specified
    // (physical) location
    Procedure DrawLine( Line: TLineStart;
                        Start: TPoint;
                        var Selected: boolean );
    // Queries

    Function GetStartX( Style: TTextDrawStyle;
                        Line: TLineStart ): longint;

    procedure GetFirstVisibleLine( Var LineIndex: longint;
                                   Var Offset: longint );
    procedure GetBottomLine( Var LineIndex: longint;
                             Var PixelsDisplayed: longint );

    Procedure GetXFromOffset( const Offset: longint;
                              const LineIndex: longint;
                              Var X: longint );
    Procedure GetOffsetFromX( const XToFind: longint;
                              const LineIndex: longint;
                              Var Offset: longint;
                              Var Link: string );
    procedure FindPoint( XToFind, YToFind: longint;
                         Var LineIndex: longint;
                         Var Offset: longint;
                         Var Link: string );
    function GetLineFromCharIndex( Index: longint ): longint;
    function GetLinePosition( Line: longint ): longint;

    // Clipboard
    procedure CopyBlockToBuffer( StartP: PChar; EndP: PChar; Buffer: PChar );

    // Layout functions

    Procedure AddLineStart( Const Line: TLineStart );
    Procedure CheckFontHeights( Var Line: TLineStart );
    Procedure Layout;
    Procedure SetupScrollbars;

    Procedure SetupCursor;
    procedure RemoveCursor;

    function IsValidBitmapIndex( Index: longint ): boolean;

    Function ExtractTag( Var TextPointer: PChar ): TTag;
    Function ExtractPreviousTag( Var TextPointer: PChar ): TTag;

    function ExtractNextTextElement( TextPointer: PChar;
                                     Var NextElement: PChar ): TTextElement;
    function ExtractPreviousTextElement( TextPointer: PChar;
                                         Var NextElement: PChar ): TTextElement;

    // property handlers
    procedure SetBorder( BorderStyle: TBorderStyle );
    Procedure SetDefaultAlignment( Alignment: TTextAlignment );
    Procedure SetDebug( Debug: boolean );
    Procedure SetBasicLeftMargin( NewValue: longint );
    Procedure SetBasicRightMargin( NewValue: longint );
    Procedure SetScrollBarWidth( NewValue: longint );

    Procedure SetNormalFont( NewFont: TFont );
    Procedure SetFixedFont( NewFont: TFont );
    Procedure SetHeading1Font( NewFont: TFont );
    Procedure SetHeading2Font( NewFont: TFont );
    Procedure SetHeading3Font( NewFont: TFont );

    function GetCursorIndex: longint;

    Function GetTopCharIndex: longint;
    Procedure SetTopCharIndex( NewValue: longint );
    Function GetTopCharIndexPosition( NewValue: longint ): longint;

    // Update the cursor row/column for the selction start/end
    procedure RefreshCursorPosition;

    procedure SetCursorIndex( Index: longint );
    procedure SetCursorPosition( Offset: longint;
                                 Row: longint;
                                 PreserveSelection: boolean );

    procedure MakeRowVisible( Row: longint );

    // These two methods set selection start and end,
    // and redraw the screen, but do not set up cursor.
    Procedure SetSelectionStartInternal( SelectionStart: longint );
    Procedure SetSelectionEndInternal( SelectionEnd: longint );

    // Property handlers. These are for programmatic access
    // where a complete setup of selection is needed
    Procedure SetSelectionStart( SelectionStart: longint );
    Procedure SetSelectionEnd( SelectionEnd: longint );

    Procedure SetImages( Images: TImageList );
    Procedure Notification( AComponent: TComponent;
                            Operation: TOperation ); override;

    // For the given point in the text, update selected if the point
    // is at start or end of selection
    // Returns true if changed
    function SelectionChange( P: PChar;
                              Var NextSelected: boolean ): boolean;

    Function GetCharIndex( P: PChar ): longint;
    Function GetTextEnd: longint;

    // Default Menu
    Procedure CreateDefaultMenu;
    Procedure SelectAllMIClick( Sender: TObject );
    Procedure CopyMIClick( Sender: TObject );
    Procedure RefreshMIClick( Sender: TObject );
    Procedure WordWrapMIClick( Sender: TObject );
    Procedure SmoothScrollMIClick( Sender: TObject );
    Procedure DebugMIClick( Sender: TObject );
    Procedure DefaultMenuPopup( Sender: TObject );

    // Stream in/out
    Procedure ReadSCUResource( Const ResName: TResourceName;
                               Var Data;
                               DataLen: LongInt ); override;
    Function WriteSCUResource( Stream: TResourceStream ): boolean; override;

  Public
    // Runtime methods

    Procedure AddText( Text: PChar );
    Procedure AddParagraph( Text: PChar );
    Procedure AddSelectedParagraph( Text: PChar );
    Procedure Clear;

    // Insert at current point
    Procedure InsertText( CharIndexToInsertAt: longword;
                          TextToInsert: PChar );

    Destructor Destroy; Override;

    property TextEnd: longint read GetTextEnd;

    // Selection operations
    property SelectionStart: longint read FSelectionStart write SetSelectionStart;
    property SelectionEnd: longint read FSelectionEnd write SetSelectionEnd;

    property CursorIndex: longint read GetCursorIndex;

    Procedure ClearSelection;
    Procedure CopySelectionToClipboard;
    Procedure CopySelectionToBuffer( Buffer: PChar );
    Procedure CopyToBuffer( Buffer: PChar );
    Function SelectionLength: longint;
    Function SelectionSet: boolean;
    Procedure SelectAll;

    property CursorRow: longint read FCursorRow;

    // Navigation
    procedure GoToTop;
    procedure GotoBottom;
    Procedure UpLine;
    Procedure DownLine;
    Procedure UpPage;
    Procedure DownPage;

    Procedure MakeCharVisible( CharIndex: longint );
    Property TopCharIndex: longint read GetTopCharIndex write SetTopCharIndex;

    Procedure CursorLeft( PreserveSelection: boolean );
    Procedure CursorRight( PreserveSelection: boolean );
    Procedure CursorDown( PreserveSelection: boolean );
    Procedure CursorUp( PreserveSelection: boolean );

    // Returns -1 if not found, otherwise char index
    function Find( Origin: TFindOrigin; Text: string ): longword;

    function LinkFromIndex( const CharIndexToFind: longint): string;

  Published
    property Align;
    property Color;
    property ParentColor;
    property ParentFont;
    property ParentPenColor;
    property ParentShowHint;
    property PenColor;
    property PopupMenu;
    property ShowHint;
    Property TabOrder;
    Property TabStop;
    property Visible;
    property ZOrder;

    property DefaultAlignment: TTextAlignment read FDefaultAlignment write SetDefaultAlignment;
    property BasicLeftMargin: longint read FBasicLeftMargin write SetBasicLeftMargin;
    property BasicRightMargin: longint read FBasicRightMargin write SetBasicRightMargin;
    property ScrollBarWidth: longint read FScrollBarWidth write SetScrollBarWidth;
    // Note - all font properties take a copy of the font when set.
    property Heading1Font: TFont read FHeading1Font write SetHeading1Font;
    property Heading2Font: TFont read FHeading2Font write SetHeading2Font;
    property Heading3Font: TFont read FHeading3Font write SetHeading3Font;
    property FixedFont: TFont read FFixedFont write SetFixedFont;
    property NormalFont: TFont read FNormalFont write SetNormalFont;

    property BorderStyle: TBorderStyle read FBorderStyle write SetBorder;

    property SmoothScroll: boolean read FSmoothScroll write FSmoothScroll;
    property UseDefaultMenu: boolean read FUseDefaultMenu write FUseDefaultMenu;
    property Debug: boolean read FDebug write SetDebug;

    property Images: TImageList read FImages write SetImages;

    // ------- EVENTS ----------

    // Called with the name of the link when the mouse first moves over it
    property OnOverLink: TLinkEvent read FOnOverLink write FOnOverLink;

    // Called with the name of the link when the mouse leaves it
    property OnNotOverLink: TLinkEvent read FOnNotOverLink write FOnNotOverLink;

    // Called when the link is clicked.
    property OnClickLink: TLinkEvent read FOnClickLink write FOnClickLink;

    Property OnClick;
    Property OnDblClick;
    Property OnEnter;
    Property OnExit;
    Property OnMouseClick;
    Property OnMouseDblClick;
    Property OnSetupShow;

    Property OnScan;
  Protected
    Property Font;

  End;

Exports
  TRichTextView,'User','RichTextView.bmp';

Implementation

{$R RichTextView}

Uses
  SysUtils, PMWin, BseDos, Dos, ClipBrd,
  Dialogs, ACLPCharUtility,
  ControlScrolling;

Var
  TheLinkCursor: TCursor; //loaded on unit initialisation.
  TheLinkPointer: TPointer; //loaded on unit initialisation.

//Utiltiy functions

function Between( Value, Limit1, Limit2: longint ): boolean;
begin
  if Limit1 < Limit2 then
    Result:= ( Value >= Limit1 ) and ( Value <= Limit2 )
  else
    Result:= ( Value >= Limit2 ) and ( Value <= Limit1 )
end;

// Font read/write from SCU. I have NO IDEA why I have to do this manually. But
// this way works and everything else I tried doesn't
Procedure TRichTextView.ReadSCUResource( Const ResName: TResourceName;
                                         Var Data;
                                         DataLen: LongInt );
Begin
  If ResName = 'Heading1Font' Then
  Begin
    If DataLen <> 0 Then
      FHeading1Font:= ReadSCUFont( Data, DataLen );
  End
  Else If ResName = 'Heading2Font' Then
  Begin
    If DataLen <> 0 Then
      FHeading2Font:= ReadSCUFont( Data, DataLen );
  End
  Else If ResName = 'Heading3Font' Then
  Begin
    If DataLen <> 0 Then
      FHeading3Font:= ReadSCUFont( Data, DataLen );
  End
  Else If ResName = 'FixedFont' Then
  Begin
    If DataLen <> 0 Then
      FFixedFont:= ReadSCUFont( Data, DataLen );
  End
  Else if ResName = 'NormalFont' then
  Begin
    If DataLen <> 0 Then
      FNormalFont:= ReadSCUFont( Data, DataLen );
  End
  Else
    Inherited ReadSCUResource( ResName, Data, DataLen );
End;

Function TRichTextView.WriteSCUResource( Stream: TResourceStream ): boolean;
begin
  Result := Inherited WriteSCUResource( Stream );
  If Not Result Then
    Exit;

  if not ( csDetail in ComponentState ) then
  begin
    If FHeading1Font <> Nil then
      Result := FHeading1Font.WriteSCUResourceName( Stream, 'Heading1Font' );
    If FHeading2Font <> Nil then
      Result := FHeading2Font.WriteSCUResourceName( Stream, 'Heading2Font' );
    If FHeading3Font <> Nil then
      Result := FHeading3Font.WriteSCUResourceName( Stream, 'Heading3Font' );
    If FFixedFont <> Nil then
      Result := FFixedFont.WriteSCUResourceName( Stream, 'FixedFont' );
    If FNormalFont <> Nil then
      Result := FNormalFont.WriteSCUResourceName( Stream, 'NormalFont' );
  end;

end;

Procedure TRichTextView.SetHeading1Font( NewFont: TFont );
begin
  If NewFont=Nil Then
    NewFont:= Screen.DefaultFont;

  FHeading1Font.Destroy;
  FHeading1Font:= Screen.CreateCompatibleFont( NewFont );

  Layout;
  Refresh;
End;

Procedure TRichTextView.SetHeading2Font( NewFont: TFont );
begin
  If NewFont=Nil Then
    NewFont:= Screen.DefaultFont;

  FHeading2Font.Destroy;
  FHeading2Font:= Screen.CreateCompatibleFont( NewFont );

  Layout;
  Refresh;
End;

Procedure TRichTextView.SetHeading3Font( NewFont: TFont );
begin
  If NewFont=Nil Then
    NewFont:= Screen.DefaultFont;

  FHeading3Font.Destroy;
  FHeading3Font:= Screen.CreateCompatibleFont( NewFont );

  Layout;
  Refresh;
End;

Procedure TRichTextView.SetFixedFont( NewFont: TFont );
begin
  If NewFont=Nil Then
    NewFont:= Screen.DefaultFont;

  FFixedFont.Destroy;
  FFixedFont:= Screen.CreateCompatibleFont( NewFont );

  Layout;
  Refresh;
end;

Procedure TRichTextView.SetNormalFont( NewFont: TFont );
begin
  If NewFont=Nil Then
    NewFont:= Screen.DefaultFont;

  FNormalFont.Destroy;
  FNormalFont:= Screen.CreateCompatibleFont( NewFont );

  Layout;
  Refresh;
end;

Procedure TRichTextView.SetSelectionStart( SelectionStart: longint );
begin
  RemoveCursor;
  SetSelectionStartInternal( SelectionStart );
  RefreshCursorPosition;
  SetupCursor;
end;

Procedure TRichTextView.SetSelectionEnd( SelectionEnd: longint );
begin
  RemoveCursor;
  SetSelectionEndInternal( SelectionEnd );
  RefreshCursorPosition;
  SetupCursor;
end;

Procedure TRichTextView.SetSelectionStartInternal( SelectionStart: longint );
begin
  if SelectionStart = FSelectionStart then
    exit;

  if SelectionSet then
    if SelectionStart = -1 then
      // small side effect here - also sets selectionend to -1
      ClearSelection;

  FSelectionStart:= SelectionStart;
  if FSelectionEnd = -1 then
    // still no selection
    exit;
  Refresh;
end;

Procedure TRichTextView.SetSelectionEndInternal( SelectionEnd: longint );
var
  StartRedrawLine: longint;
  EndRedrawLine: longint;
  OldClip: TRect;
begin
  if SelectionEnd = FSelectionEnd then
    exit;

  if FSelectionStart = -1 then
  begin
    FSelectionEnd:= SelectionEnd;
    // still not a valid selection, no need to redraw
    exit;
  end;

  if SelectionEnd = FSelectionStart then
    SelectionEnd:= -1;

  if ( FSelectionEnd = -1 ) then
  begin
    // there is currently no selection,
    // and we are setting one: need to draw it all
    StartRedrawLine:= GetLineFromCharIndex( FSelectionStart );
    EndRedrawLine:= GetLineFromCharIndex( SelectionEnd );
  end
  else
  begin
    // there is already a selection
    if SelectionEnd = -1 then
    begin
      // and we're clearing it
      StartRedrawLine:= GetLineFromCharIndex( FSelectionStart );
      EndRedrawLine:= GetLineFromCharIndex( FSelectionEnd );
    end
    else
    begin
      // and we're setting a new one, so draw from the old end to the new
      StartRedrawLine:= GetLineFromCharIndex( FSelectionEnd );
      EndRedrawLine:= GetLineFromCharIndex( SelectionEnd );
    end;
  end;

  FSelectionEnd:= SelectionEnd;

  OldClip:= Canvas.ClipRect;
  Canvas.ClipRect:= GetTextAreaRect;

  // (re)draw selection
  Draw( StartRedrawLine, EndRedrawLine );
  Canvas.ClipRect:= OldClip;
end;

Procedure TRichTextView.ClearSelection;
var
  OldClip: TRect;
  StartLine: longint;
  EndLine: longint;
begin

  if SelectionSet then
  begin
    OldClip:= Canvas.ClipRect;
    Canvas.ClipRect:= GetTextAreaRect;

    StartLine:= GetLineFromCharIndex( FSelectionStart );
    EndLine:= GetLineFromCharIndex( FSelectionEnd );

    FSelectionEnd:= -1;
    FSelectionStart:= -1;

    // clear display of selection
    Draw( StartLine,
          EndLine );

    Canvas.ClipRect:= OldClip;
 end;

  FSelectionEnd:= -1;
  FSelectionStart:= -1;
end;

Function TRichTextView.GetTextEnd: longint;
begin
  Result:= StrLen( FText );
end;

Procedure TRichTextView.CreateDefaultMenu;
var
  SeparatorMI: TMenuItem;
begin

  FDefaultMenu:= TPopupMenu.Create( self );
  FDefaultMenu.OnPopup:= DefaultMenuPopup;

  FSelectAllMI:= TMenuItem.Create( self );
  FSelectAllMI.Caption:= 'Select &All';
  FSelectAllMI.OnClick:= SelectAllMIClick;
  FDefaultMenu.Items.Add( FSelectAllMI );

  FCopyMI:= TMenuItem.Create( self );
  FCopyMI.Caption:= '&Copy';
  FCopyMI.OnClick:= CopyMIClick;
  FDefaultMenu.Items.Add( FCopyMI );

  SeparatorMI:= TMenuItem.Create( self );
  SeparatorMI.Caption:= '-';
  FDefaultMenu.Items.Add( SeparatorMI );

  FRefreshMI:= TMenuItem.Create( self );
  FRefreshMI.Caption:= '&Refresh';
  FRefreshMI.OnClick:= RefreshMIClick;
  FDefaultMenu.Items.Add( FRefreshMI );

  SeparatorMI:= TMenuItem.Create( self );
  SeparatorMI.Caption:= '-';
  FDefaultMenu.Items.Add( SeparatorMI );

  FSmoothScrollMI:= TMenuItem.Create( self );
  FSmoothScrollMI.Caption:= '&Smooth Scrolling';
  FSmoothScrollMI.OnClick:= SmoothScrollMIClick;
  FDefaultMenu.Items.Add( FSmoothScrollMI );

  FWordWrapMI:= TMenuItem.Create( self );
  FWordWrapMI.Caption:= '&Word Wrap';
  FWordWrapMI.OnClick:= WordWrapMIClick;
  FDefaultMenu.Items.Add( FWordWrapMI );

  FDebugMI:= TMenuItem.Create( self );
  FDebugMI.Caption:= '&Debug';
  FDebugMI.OnClick:= DebugMIClick;
  FDefaultMenu.Items.Add( FDebugMI );
end;

Procedure TRichTextView.SelectAllMIClick( Sender: TObject );
begin
  SelectAll;
end;

Procedure TRichTextView.CopyMIClick( Sender: TObject );
begin
  CopySelectionToClipBoard;
end;

Procedure TRichTextView.RefreshMIClick( Sender: TObject );
begin
  Refresh;
end;

Procedure TRichTextView.WordWrapMIClick( Sender: TObject );
begin
  if DefaultAlignment = taNone then
    DefaultAlignment:= taLeft
  else
    DefaultAlignment:= taNone;
end;

Procedure TRichTextView.SmoothScrollMIClick( Sender: TObject );
begin
  SmoothScroll:= not SmoothScroll;
end;

Procedure TRichTextView.DebugMIClick( Sender: TObject );
begin
  Debug:= not Debug;
end;

Procedure TRichTextView.DefaultMenuPopup( Sender: TObject );
begin
  FWordWrapMI.Checked:= FDefaultAlignment <> taNone;
  FSmoothScrollMI.Checked:= SmoothScroll;
  FDebugMI.Checked:= Debug;
end;

Procedure TRichTextView.SetupComponent;
Begin
  Inherited SetupComponent;

  Name:= 'RichTextView';

  Width:= 100;
  Height:= 100;

  FDefaultAlignment:= taLeft;

  FSmoothScroll:= true;
  FBorderStyle:= bsSingle;
  FScrollbarWidth:= 15;
  FUseDefaultMenu:= true;

  FBasicLeftMargin:= 5;
  FBasicRightMargin:= 5;

  FNormalFont:= Screen.CreateCompatibleFont( Screen.GetFontFromPointSize( 'Helv', 8 ) );
  FFixedFont:= Screen.CreateCompatibleFont( Screen.GetFontFromPointSize( 'Courier', 8 ) );
  FHeading1Font:= Screen.CreateCompatibleFont( Screen.GetFontFromPointSize( 'Helv', 18 ) );
  FHeading2Font:= Screen.CreateCompatibleFont( Screen.GetFontFromPointSize( 'Helv', 12 ) );
  FHeading3Font:= Screen.CreateCompatibleFont( FNormalFont );
  FHeading3Font.Attributes:= [ faBold ];

  Color:= clEntryField;
  ParentPenColor:= true;

  Cursor:= crIBeam;

  Exclude( ComponentState, csAcceptsControls);

  FImages:= nil;

  if not InDesigner then
  begin
    FontManager:= nil;

    FCaret:= TCaret.Create( self );

    FText:= StrAlloc( 100 );
    FText[ 0 ]:= #0;

    FAllocatedNumLines:= 10;
    GetMem( FLines, FAllocatedNumLines * sizeof( TLineStart ) );
    FNumLines:= 0;

    FTopCharIndex := 0;
    FVerticalPositionInitialised := false;

    FLinks:= TStringList.Create;
    FLinks.Duplicates:= dupIgnore;
  end;
End;

Destructor TRichTextView.Destroy;
Begin
  if not InDesigner then
  begin
    RemoveCursor;
    StrDispose( FText );
    FreeMem( Flines, FAllocatedNumLines * sizeof( TLineStart ) );
    FLinks.Destroy;
    if FontManager <> nil then
      FontManager.Destroy;
  end;
  FNormalFont.Destroy;
  FFixedFont.Destroy;
  FHeading1Font.Destroy;
  FHeading2Font.Destroy;
  FHeading3Font.Destroy;
  Inherited Destroy;
End;

Procedure TRichTextView.KillFocus;
begin
  RemoveCursor;
  inherited KillFocus;
end;

Procedure TRichTextView.SetFocus;
begin
  inherited SetFocus;
  SetupCursor;
end;

Procedure TRichTextView.AddLineStart( Const Line: TLineStart );
var
  NewAllocation: longint;
begin
  if FNumLines >= FAllocatedNumLines then
  begin
    // reallocate the array twice the size
    NewAllocation:= FAllocatedNumLines * 2;
    FLines:= ReAllocMem( FLines,
                         FAllocatedNumLines * sizeof( TLineStart ),
                         NewAllocation * sizeof( TLineStart ) );
    FAllocatedNumLines:= NewAllocation;
  end;
  FLines^[ FNumLines ]:= Line;
  inc( FNumLines );
end;

Procedure TRichTextView.SetDefaultAlignment( Alignment: TTextAlignment );
begin
  FDefaultAlignment:= Alignment;
  Layout;
  Refresh;
end;

Procedure TRichTextView.SetDebug( Debug: boolean );
begin
  FDebug:= Debug;
  Refresh;
end;

Procedure TRichTextView.SetBasicLeftMargin( NewValue: longint );
begin
  if NewValue < 0 then
    exit;
  FBasicLeftMargin:= NewValue;
  Layout;
  Refresh;
end;

Procedure TRichTextView.SetBasicRightMargin( NewValue: longint );
begin
  if NewValue < 0 then
    exit;
  FBasicRightMargin:= NewValue;
  Layout;
  Refresh;
end;

Procedure TRichTextView.SetScrollBarWidth( NewValue: longint );
begin
  if NewValue < 0 then
    exit;
  FScrollBarWidth := NewValue;
  Layout;
  Refresh;
end;

Procedure TRichTextView.SetupShow;
begin
  Inherited SetupShow;

  if InDesigner then
    exit;

  FontManager:= TCanvasFontManager.Create( Canvas );

  FLastLinkOver:= '';
  FSelectionStart:= -1;
  FSelectionEnd:= -1;

  if FUseDefaultMenu then
  begin
    CreateDefaultMenu;
    PopupMenu:= FDefaultMenu;
  end;

  FHScrollbar.Create( nil );
  FHScrollbar.Hide;
  InsertControl( FHScrollBar );
  FHScrollbar.Kind:= sbHorizontal;
  Include( FHScrollBar.ComponentState, csDetail);

  FVScrollbar.Create( Nil );
  FVScrollbar.Hide;
  InsertControl( FVScrollBar );
  FVScrollbar.Kind:= sbVertical;
  Include( FVScrollBar.ComponentState, csDetail);

  FScrollTimer:= TTimer.Create( self );
  Include( FScrollTimer.ComponentState, csDetail );
  FScrollTimer.Interval:= 100;
  FScrollTimer.OnTimer:= OnScrollTimer;

  FLinkCursor:= TheLinkCursor;

end;

Procedure TRichTextView.Resize;
begin
  if InDesigner then
    exit;

  if Handle = 0 then
    exit;

  RemoveCursor;

  if FVerticalPositionInitialised then
  begin
    // Preserve current position
    if FNumLines > 0 then
      FTopCharIndex := GetTopCharIndex
    else
      FTopCharIndex := 0;
  end;

  Layout;

  // This is the point at which vertical position
  // is initialised during first window show
  FVScrollBar.Position := GetTopCharIndexPosition( FTopCharIndex );
  FYScroll := FVScrollBar.Position;
  FLastYScroll := FYScroll;
  FVerticalPositionInitialised := true;

  SetupCursor;
end;

Function ParseTag( const Text: string ): TTag;
var
  TagTypeText: string;
  SpacePos: longint;
begin
  with Result do
  begin
    SpacePos:= Pos( ' ', Text );
    if SpacePos <> 0 then
    begin
      Arguments:= trim( Copy( Text, SpacePos + 1, 255 ) );
      TagTypeText:= Copy( Text, 1, SpacePos - 1 );
    end
    else
      TagTypeText:= Text;

    for TagType:= ttInvalid to ttEnd do
    begin
      if CompareText( TagStr[ TagType ], TagTypeText ) = 0 then
        exit;
    end;
    TagType:= ttInvalid;
  end;
end;

var
  TagText: string;
  TagArgText: string;

Function TRichTextView.ExtractTag( Var TextPointer: PChar ): TTag;
var
  CurrentChar: Char;
  TagTooLong: boolean;
begin
//  assert( TextPointer[ 0 ] = '<' );
  TagText:= '';
  TagTooLong:= false;

  repeat
    CurrentChar:= TextPointer[ 0 ];

    if CurrentChar = '>' then
    begin
      // found tag end.
      if TagTooLong then
        Result.TagType:= ttInvalid
      else
        Result:= ParseTag( TagText );
      inc( TextPointer );
      exit;
    end;
    if CurrentChar = #0 then
    begin
      // if we reach here we have reached the end of text
      // during a tag. invalid tag.
      Result.TagType:= ttInvalid;
      exit;
    end;

    if not TagTooLong then
      if Length( TagText ) < 200 then
        TagText:= TagText + CurrentChar
      else
        TagTooLong:= true; // but keep going until the end

    inc( TextPointer );
  until false;

end;

// Expects textpointer is currently pointing at the >
Function TRichTextView.ExtractPreviousTag( Var TextPointer: PChar ): TTag;
var
  CurrentChar: Char;
  TagTooLong: boolean;
begin
  TagText:= '';
  TagTooLong:= false;

  repeat
    dec( TextPointer );
    if TextPointer < FText then
    begin
      // if we reach here we have reached the end of text
      // during a tag. invalid tag.
      Result.TagType:= ttInvalid;
      exit;
    end;
    CurrentChar:= TextPointer^;

    if CurrentChar = '<' then
    begin
      // found tag end.
      if TagTooLong then
        Result.TagType:= ttInvalid
      else
        Result:= ParseTag( TagText );
      exit;
    end;

    if not TagTooLong then
      if Length( TagText ) < 200 then
        TagText:= CurrentChar + TagText
      else
        TagTooLong:= true; // but keep going until the end

  until false;

end;

function TRichTextView.ExtractNextTextElement( TextPointer: PChar;
                                               Var NextElement: PChar ): TTextElement;
var
  TheChar: Char;
  NextChar: char;
begin
  with Result do
  begin
    TheChar:= TextPointer^;
    Character:= TheChar;
    inc( TextPointer );

    case TheChar of
      ' ': // ---- Space (word break) found ----
        ElementType:= teWordBreak;

      #10, #13: // ---- End of line found ----
      begin
        ElementType:= teLineBreak;
        if TheChar = #13 then
        begin
          TheChar:= TextPointer^;
          if TheChar = #10 then
            // skip CR following LF
            inc( TextPointer );
        end;
      end;

      #0: // ---- end of text found ----
        ElementType:= teTextEnd;

      '<': // ---- tag found? ----
      begin
        NextChar:= TextPointer^;
        if NextChar = '<' then
        begin
          // no. just a literal <
          ElementType:= teText;
          inc( TextPointer );
        end
        else
        begin
          Tag:= ExtractTag( TextPointer );
          if Tag.TagType = ttImage then
            ElementType:= teImage
          else
            ElementType:= teStyle;
        end;

      end;

      '>': // check - should be double
      begin
        ElementType:= teText;
        NextChar:= TextPointer^;
        if NextChar = '>' then
          inc( TextPointer );
      end;

      else
        ElementType:= teText;
    end;
  end; // with
  NextElement:= TextPointer;
end;

function TRichTextView.ExtractPreviousTextElement( TextPointer: PChar;
                                                   Var NextElement: PChar ): TTextElement;
var
  TheChar: Char;
  PreviousChar: Char;
  FoundTag: boolean;
begin
  with Result do
  begin
    dec( TextPointer );
    TheChar:= TextPointer^;
    Character:= TheChar;
    if TextPointer < FText then
    begin
      ElementType:= teTextEnd;
      exit;
    end;

    case TheChar of
      ' ': // ---- Space (word break) found ----
        ElementType:= teWordBreak;

      #10, #13: // ---- End of line found ----
      begin
        ElementType:= teLineBreak;
        if TheChar = #10 then
        begin
          dec( TextPointer );
          TheChar:= TextPointer^;
          if TheChar = #13 then
          begin
            // skip CR preceeding LF
          end
          else
            inc( TextPointer );
        end;
      end;

      '>': // ---- tag found ----
      begin
        FoundTag:= true;
        if TextPointer > FText then
        begin
          PreviousChar:= TextPointer^;
          if PreviousChar = '>' then
          begin
            // no. just a literal <
            FoundTag:= false;
            ElementType:= teText;
            dec( TextPointer );
          end
        end;

        if FoundTag then
        begin
          Tag:= ExtractPreviousTag( TextPointer );
          if Tag.TagType = ttImage then
            ElementType:= teImage
          else
            ElementType:= teStyle;
        end;
      end;

      '<': // should be double
      begin
        ElementType:= teText;
        if TextPointer > FText then
        begin
          PreviousChar:= TextPointer^;
          if PreviousChar = '<' then
            dec( TextPointer );
        end;
      end
      else
        ElementType:= teText;
    end;
  end; // with
  NextElement:= TextPointer;
end;

Procedure DoLog( s: string );
var
  f: textfile;
begin
  Assign( f, 'bob.log' );
  if not FileExists( 'bob.log' ) then
    Rewrite( f )
  else
    Append( f );
  WriteLn( f, s );
  Close( f );

end;

Procedure TRichTextView.PerformStyleTag( Tag: TTag;
                                         Var Style: TTextDrawStyle );
begin
  case Tag.TagType of
    ttBold:
      Include( Style.Font.Attributes, faBold );
    ttBoldOff:
      Exclude( Style.Font.Attributes, faBold );
    ttItalic:
      Include( Style.Font.Attributes, faItalic );
    ttItalicOff:
      Exclude( Style.Font.Attributes, faItalic );
    ttUnderline:
      Include( Style.Font.Attributes, faUnderscore );
    ttUnderlineOff:
      Exclude( Style.Font.Attributes, faUnderscore );
    ttFixedWidthOn:
      SibylFontToFontSpec( FixedFont, Style.Font );
    ttFixedWidthOff:
      SibylFontToFontSpec( NormalFont, Style.Font );
    ttHeading1:
      SibylFontToFontSpec( Heading1Font, Style.Font );
    ttHeading2:
      SibylFontToFontSpec( Heading2Font, Style.Font );
    ttHeading3:
      SibylFontToFontSpec( Heading3Font, Style.Font );
    ttHeadingOff:
      SibylFontToFontSpec( NormalFont, Style.Font );
    ttRed:
      Style.Font.Color:= clRed;
    ttBlue:
      Style.Font.Color:= clBlue;
    ttGreen:
      Style.Font.Color:= clGreen;
    ttBlack:
      Style.Font.Color:= clBlack;
    ttAlignNone:
      Style.Alignment:= taNone;
    ttAlignLeft:
      Style.Alignment:= taLeft;
    ttAlignRight:
      Style.Alignment:= taRight;
    ttAlignCentre:
      Style.Alignment:= taCentre;
    ttAlignFull:
      Style.Alignment:= taFull;
    ttDefaultAlign:
      Style.Alignment:= DefaultAlignment;
    ttSetLeftMargin:
      try
        Style.LeftMargin:= StrToInt( Tag.Arguments )
                           * FontManager.CharWidth( ' ' );
      except
        Style.LeftMargin:= 0;
      end;
  end;

  FontManager.SetFont( Style.Font );

end;

// Check the current font specifications and see if the
// give line needs updating for max height/descender
Procedure TRichTextView.CheckFontHeights( Var Line: TLineStart );
var
  FontHeight: longint;
  Descender: longint;
begin
  FontHeight:= FontManager.CharHeight;
  Descender:= FontManager.CharDescender;

  if FontHeight > Line.Height then
    Line.Height:= FontHeight;

  if Descender > Line.MaxDescender then
    Line.MaxDescender:= Descender;
end;

function TRichTextView.IsValidBitmapIndex( Index: longint ): boolean;
begin
  if FImages = nil then
    Result:= false
  else
    Result:= Between( Index, 0, FIMages.Count - 1 );
end;

// Main procedure: reads through the whole text currently stored
// and breaks up into lines - each represented as a TLineStart in
// the array FLines[ 0.. FNumLines ]
Procedure TRichTextView.Layout;
Var
  CurrentLine: TLineStart;

  CurrentLinkIndex: longint;

  WordX: longint; // width of word so far
  P: PChar;
  NextP: PChar;
  NextP2: PChar;

  DrawWidth: longint;

  WordStart: PChar;
  WordStarted: boolean; // if false, just skipping spaces..
  WordStartX: longint; // X position of word start

  LineWordsCompleted: longint; // how many words draw so far this line

  CurrentElement: TTextElement;
  NextElement: TTextElement;

  CurrentCharWidth: longint;

  Style: TTextDrawStyle;

  DisplayedCharsSinceFontChange: boolean;

  BitmapIndex: longint;
  Bitmap: TBitmap;

  OldTopCharIndex: longint;

  // Nested procedure

  Procedure DoLine( EndPoint: PChar;
                    NextLine: PChar;
                    EndX: longint );
  begin
    // check if the max font
    // height needs updating for the last string of the line
    CheckFontHeights( CurrentLine );

    inc( FTotalTextHeight, CurrentLine.Height );

    CurrentLine.Length:= PCharDiff( EndPoint, CurrentLine.Text );

    CurrentLine.Width:= EndX;

    if CurrentLine.Width > FMaxTextWidth then
      FMaxTextWidth:= CurrentLine.Width;

    assert( CurrentLine.Height > 0 ); // we must have set the line height!

    AddLineStart( CurrentLine );
    CurrentLine.Text:= NextLine;
    CurrentLine.Style:= Style;
    CurrentLine.Height:= 0;
    CurrentLine.MaxDescender:= 0;
    CurrentLine.Width:= 0;
    CurrentLine.LinkIndex:= CurrentLinkIndex;
    CurrentLine.Wrapped:= false;

    assert( CurrentLinkIndex >= -1 );
    assert( CurrentLinkIndex < FLinks.Count );

    WordStartX:= Style.LeftMargin;
    // next line

    // reset words completed count
    LineWordsCompleted:= 0;

    WordStarted:= false;
  end;

begin
  if InDesigner then
    exit;
  if Handle = 0 then
    exit;

  Bitmap:= TBitmap.Create;

  FNumLines:= 0;

  DrawWidth:= Width;
  if FBorderStyle = bsSingle then
    dec( DrawWidth, 4 ); // left+right border
  dec( DrawWidth, FScrollBarWidth ); // vert scroll bar always present
  dec( DrawWidth, FBasicRightMargin );
  dec( DrawWidth, FBasicLeftMargin );

  DrawWidth := DrawWidth * FontWidthPrecisionFactor;

  SibylFontToFontSpec( NormalFont, Style.Font );
  Style.Font.Color:= PenColor;
  Style.Alignment:= FDefaultAlignment;
  Style.LeftMargin:= 0;

  FontManager.SetFont( Style.Font );

  CurrentLinkIndex:= -1;

  P:= FText; // P is the current search position
  CurrentLine.Text:= P;
  CurrentLine.Style:= Style;
  CurrentLine.Height:= 0;
  CurrentLine.MaxDescender:= 0;
  CurrentLine.Width:= 0;
  CurrentLine.LinkIndex:= -1;
  CurrentLine.Wrapped:= false;

  FTotalTextHeight:= 0;
  WordStartX:= Style.LeftMargin;
  WordX:= 0;

  LineWordsCompleted:= 0;

  FMaxTextWidth:= DrawWidth;
  FTotalTextHeight:= 0;

  WordStarted:= false;
  DisplayedCharsSinceFontChange:= false;

  repeat
    CurrentElement:= ExtractNextTextElement( P, NextP );
    assert( NextP > P );

    case CurrentElement.ElementType of
      teWordBreak:
      begin
        CurrentCharWidth:= FontManager.CharWidth( ' ' );

        if WordStarted then
        begin
          DisplayedCharsSinceFontChange:= true;
          // remember that we have now completed a word on this line
          inc( LineWordsCompleted );
          WordStarted:= false;

          if Style.Alignment <> taNone then
          begin
            // See if the space char will reach end of line
            if WordStartX + WordX + CurrentCharWidth >= DrawWidth then
            begin
              CurrentLine.Wrapped:= true;
              // yes, it will, so end the line here
              DoLine( P,
                      NextP,
                      WordStartX + WordX );
              WordX:= 0;

              // remember start of next line
              CurrentLine.Text:= NextP;
              P:= NextP;
              continue;
            end;
            // No, space char does not reach eol
          end;

          // Add the word width, and the space width,
          // to get the start of the next word
          inc( WordStartX, WordX + CurrentCharWidth );
          WordX:= 0;

          // remember the start of the next word
          WordStart:= NextP;

          P:= NextP;

          continue;
        end;
        // else - starting spaces - fall through like normal char
      end;

      teLineBreak:
      begin
        DoLine( P, NextP, WordStartX + WordX );

        // remember start of line
        WordStart:= NextP;
        WordX:= 0;

        P:= NextP;

        continue;
      end;

      teTextEnd:
      begin
        // only do another line for #0 if it didn't come straight after an EOL
        if P > CurrentLine.Text then
          DoLine( P, NextP, WordStartX + WordX );

        // end of text, done
        break;
      end;

      teStyle:
      begin
        case CurrentElement.Tag.TagType of
          ttBeginLink:
            CurrentLinkIndex:= FLinks.Add( CurrentElement.Tag.Arguments );

          ttEndLink:
            CurrentLinkIndex:= -1;

          else
            // before processing the tag see if font height needs updating
            if DisplayedCharsSinceFontChange then
              CheckFontHeights( CurrentLine );

            PerformStyleTag( CurrentElement.Tag,
                             Style );

            if not WordStarted
               and ( LineWordsCompleted = 0 ) then
            begin
              // No chars would be displayed yet...
              CurrentLine.Style.LeftMargin:= Style.LeftMargin;
              WordStartX:= Style.LeftMargin;
            end;
            DisplayedCharsSinceFontChange:= false;
        end;

        P:= NextP;

        continue; // continue loop
      end;

      teImage:
      begin
        try
          BitmapIndex:= StrToInt( CurrentElement.Tag.Arguments );
        except
          BitmapIndex:= -1;
        end;
        if IsValidBitmapIndex( BitmapIndex ) then
        begin
          FIMages.GetBitmap( BitmapIndex, Bitmap );

          CurrentCharWidth:= Bitmap.Width * FontWidthPrecisionFactor;

          WordStarted:= true;
        end;

      end;

      teText:
      begin
        // Normal (non-leading-space) character
        CurrentCharWidth:= FontManager.CharWidth( CurrentElement.Character );
        WordStarted:= true;
      end;
    end;

    // if we're still going here we have a normal char
    // (or leading spaces)

    if Style.Alignment = taNone  then
    begin
      // No alignment
      // We don't care about how wide it gets
      inc( WordX, CurrentCharWidth );
      P:= NextP;
      continue;
    end;

    // Calculate position of end of character
    // see if char would exceed width
    if WordStartX + WordX + CurrentCharWidth >= DrawWidth then
    begin
      // reached right hand side before finding end of word
      // wrap to next line.

      if LineWordsCompleted = 0 then
      begin
        // but, the first word did not fit on the line. so draw
        // as much as will fit
        if WordX = 0 then
        begin
          // even the first char doesn't fit,
          // but draw it anyway (otherwise, infinite loop)

          NextElement:= ExtractNextTextElement( NextP, NextP2 );
          if NextElement.ElementType <> teLineBreak then
            // there is still more on the line...
            CurrentLine.Wrapped:= true
          else
            // the line ends after this one char or image, we can skip the line end
            NextP:= NextP2;

          if CurrentElement.ElementType = teImage then
          begin
            // the only thing on the line is the image.
            if Bitmap.Height > CurrentLine.Height then
              CurrentLine.Height:= Bitmap.Height;
            DoLine( P + 1,
                    NextP,
                    WordStartX + WordX + CurrentCharWidth );
            WordStart:= NextP;
          end
          else
          begin
            DoLine( P + 1,
                    P + 1,
                    WordStartX + WordX + CurrentCharWidth );
            WordStart:= P + 1;
          end;
          WordX:= 0;
        end
        else
        begin
          CurrentLine.Wrapped:= true;
          // at least 1 char fits
          // so draw up to, but not including this char
          DoLine( P,
                  P,
                  WordStartX + WordX );
          WordStart:= P;
          WordX:= CurrentCharWidth;
        end;
      end
      else
      begin
        // Normal wrap; at least one word fitted on the line
        CurrentLine.Wrapped:= true;

        // take the width of the last space of the
        // previous word off the line width
        DoLine( WordStart, // current line ends at start of this word
                WordStart, // next line starts at start of this word
                WordStartX - FontManager.CharWidth( ' ' ) );
        if CurrentElement.ElementType = teImage then
          if Bitmap.Height > CurrentLine.Height then
            CurrentLine.Height:= Bitmap.Height;

        // do NOT reset WordX to zero; as we are continuing
        // from partway thru the word on the next line.
        inc( WordX, CurrentCharWidth );
      end;
      WordStarted:= true; // by definition, for wrapping
    end
    else
    begin
      // Character fits.
      inc( WordX, CurrentCharWidth );

      if CurrentElement.ElementType = teImage then
        if Bitmap.Height > CurrentLine.Height then
          CurrentLine.Height:= Bitmap.Height;
    end;

    P:= NextP;

  until false; // loop is exited by finding end of text

  Bitmap.Destroy;

  SetupScrollBars;
End;

procedure TRichTextView.GetFirstVisibleLine( Var LineIndex: longint;
                                             Var Offset: longint );
var
  Y: longint;
begin
  LineIndex:= 0;
  Y:= 0;
  Offset:= 0;

  if FNumLines = 0 then
  begin
    // no line visible.
    LineIndex:= -1;
    exit;
  end;

  while ( Y + FLines[ LineIndex ].Height ) <= FYScroll do
  begin
    inc( Y, FLines[ LineIndex ].Height );
    inc( LineIndex );
    if LineIndex > FNumLines then
    begin
      // no line visible.
      LineIndex:= -1;
      exit;
    end;
  end;

  Offset:= FYScroll - Y ;
end;

procedure TRichTextView.GetBottomLine( Var LineIndex: longint;
                                       Var PixelsDisplayed: longint );
var
  Y: longint;
  Height: longint;
begin
  GetFirstVisibleLine( LineIndex,
                       Y );
  if LineIndex = -1 then
    exit;

  Y:= -Y;
  Height:= GetTextAreaHeight;

  while ( Y + FLines[ LineIndex ].Height ) < Height do
  begin
    inc( Y, FLines[ LineIndex ].Height );
    inc( LineIndex );
    if LineIndex > FNumLines then
    begin
      LineIndex:= -1;
      exit;
    end;
  end;

  PixelsDisplayed:= Height - Y;
end;

Function TRichTextView.GetStartX( Style: TTextDrawStyle;
                                  Line: TLineStart ): longint;
var
  SpaceOnLine: longint;
begin
  case Style.Alignment of
    taRight:
      Result := FMaxTextWidth - Line.Width;
    taCentre:
      begin
        SpaceOnLine := FMaxTextWidth - Line.Width
                    - Style.LeftMargin;
        Result := SpaceOnLine div 2
               + Style.LeftMargin
               + FBasicLeftMargin * FontWidthPrecisionFactor;
      end;
    taLeft, taNone:
      Result := Style.LeftMargin
             + FBasicLeftMargin * FontWidthPrecisionFactor;
  end;
end;

Procedure TRichTextView.GetOffsetFromX( const XToFind: longint;
                                        const LineIndex: longint;
                                        Var Offset: longint;
                                        Var Link: string );
Var
  X: longint;
  P: PChar;
  NextP: PChar;
  EndP: PChar;
  Element: TTextElement;
  StartedDrawing: boolean;
  CurrentLink: string;
  Line: TLineStart;
  Style: TTextDrawStyle;
begin
  Line:= FLines[ LineIndex ];
  P:= Line.Text;
  EndP:= Line.Text + Line.Length;

  Style:= Line.Style;
  FontManager.SetFont( Style.Font );

  StartedDrawing:= false;

  if Line.LinkIndex <> -1 then
    CurrentLink:= FLinks[ Line.LinkIndex ]
  else
    CurrentLink:= '';

  while P < EndP do
  begin
    Element:= ExtractNextTextElement( P, NextP );

    case Element.ElementType of
      teWordBreak,
      teText,
      teImage:
      begin
        if not StartedDrawing then
        begin
          // we haven't yet started drawing:
          // so work out alignment
          X := GetStartX( Style, Line );
          StartedDrawing:= true;
        end;

        // Now find out how wide the thing is
        inc( X, GetElementWidth( Element ) );

        if X div FontWidthPrecisionFactor
           > XToFind then
        begin
          // found
          Offset:= PCharDiff( P, Line.Text );
          Link:= CurrentLink;
          exit;
        end;

      end;

      teStyle:
        case Element.Tag.TagType of
          ttBeginLink:
            CurrentLink:= Element.Tag.Arguments;
          ttEndLink:
            CurrentLink:= '';
          else
            PerformStyleTag( Element.Tag,
                             Style );
        end;
    end;

    P:= NextP;
  end;
  Offset:= Line.Length;
end;

Procedure TRichTextView.GetXFromOffset( const Offset: longint;
                                        const LineIndex: longint;
                                        Var X: longint );
Var
  P: PChar;
  NextP: PChar;
  EndP: PChar;
  Element: TTextElement;
  StartedDrawing: boolean;
  Line: TLineStart;
  Style: TTextDrawStyle;
begin
  Line:= FLines[ LineIndex ];
  P:= Line.Text;
  EndP:= Line.Text + Line.Length;

  Style:= Line.Style;
  FontManager.SetFont( Style.Font );

  StartedDrawing:= false;

  if P = EndP then
    X := GetStartX( Style, Line );

  while P < EndP do
  begin
    Element:= ExtractNextTextElement( P, NextP );

    case Element.ElementType of
      teWordBreak,
      teText,
      teImage:
      begin
        if not StartedDrawing then
        begin
          // we haven't yet started drawing:
          // so work out alignment
          X := GetStartX( Style, Line );
          StartedDrawing:= true;
        end;

        if GetCharIndex( P ) - GetCharIndex( Line.Text ) >= Offset then
        begin
          X := X div FontWidthPrecisionFactor;
          // found
          exit;
        end;

        // Now find out how wide the thing is
        inc( X, GetElementWidth( Element ) );

      end;

      teStyle:
        PerformStyleTag( Element.Tag,
                         Style );
    end;

    P:= NextP;
  end;
  X := X div FontWidthPrecisionFactor;
end;

procedure TRichTextView.FindPoint( XToFind, YToFind: longint;
                                   Var LineIndex: longint;
                                   Var Offset: longint;
                                   Var Link: string );
var
  Y: longint;
  TextHeight: longint;
  LineHeight: longint;
begin
  Offset:= -1;
  Link:= '';

  TextHeight:= GetTextAreaHeight;

  YToFind:= Height - YToFind;

  if FBorderStyle = bsSingle then
  begin
    dec( YToFind, 2 );
    dec( XToFind, 2 );
  end;

  if YToFind < 0 then
  begin
    // above the top
    LineIndex:= liAboveTextArea;
    exit;
  end;

  if YToFind >= TextHeight then
  begin
    // below the bottom
    LineIndex:= liBelowTextArea;
    exit;
  end;

  GetFirstVisibleLine( LineIndex,
                       Y );
  if LineIndex = -1 then
  begin
    LineIndex:= liBelowText;
    exit;
  end;

  Y:= -Y;

  while LineIndex < FNumLines do
  begin
    LineHeight:= FLines[ LineIndex ].Height;
    if YToFind >= Y then
      if YToFind < Y + LineHeight then
      begin
        // found the line
        GetOffsetFromX( XToFind,
                        LineIndex,
                        Offset,
                        Link );
        exit;
      end;
    inc( Y, FLines[ LineIndex ].Height );
    inc( LineIndex );
  end;

  LineIndex:= liBelowText;
  Offset:= -1;
end;

function TRichTextView.GetLineFromCharIndex( Index: longint ): longint;
var
  LineCharIndex: longint;
  LineLength: longint;
begin
  Result:= 0;
  if Index <= 0 then
    exit;

  while Result < FNumLines do
  begin
    LineCharIndex:= GetCharIndex( FLines[ Result ].Text );
    LineLength:= FLines[ Result ].Length;
    if LineCharIndex + LineLength
       >= Index then
    begin
      // found

{      if Result < FNumLines - 1 then
      begin
        // maybe the next line starts with the same position
        // (a wrapped line)
        LineCharIndex:= GetCharIndex( FLines[ Result + 1 ].Text );
        if Index = LineCharIndex then
          // yes it does, so use that instead.
          inc( Result );
        exit;
      end;}

      exit;
    end;
    inc( Result );
  end;
  Result:= FNumLines - 1;
end;

function TRichTextView.GetElementWidth( Element: TTextElement ): longint;
var
  Bitmap: TBItmap;
  BitmapIndex: longint;
begin
  // Now find out how wide the thing is
  case Element.ElementType of
    teImage:
    begin
      try
        BitmapIndex:= StrToInt( Element.Tag.Arguments );
      except
        BitmapIndex:= -1;
      end;
      if IsValidBitmapIndex( BitmapIndex ) then
      begin
        Bitmap:= TBitmap.Create;
        FIMages.GetBitmap( BitmapIndex, Bitmap );
        Result:= Bitmap.Width * FontWidthPrecisionFactor;
        Bitmap.Destroy;
      end;
    end;

    teText, teWordBreak:
      Result:= FontManager.CharWidth( Element.Character );

    else
      Assert( False ); // should never be trying to find the width of a style, etc

  end;
end;

function TRichTextView.SelectionChange( P: PChar;
                                        var NextSelected: boolean ): boolean;
var
  CharIndex: longword;
begin
  Result:= false;
  if not SelectionSet then
    exit;
  CharIndex:= GetCharIndex( P );
  if CharIndex = FSelectionStart then
  begin
    Result:= true;
    if FSelectionStart < FSelectionEnd then
      // reached start of selection
      NextSelected:= true
    else
      // reached end
      NextSelected:= false;
  end
  else if CharIndex = FSelectionEnd then
  begin
    Result:= true;
    if FSelectionStart < FSelectionEnd then
      // reached end of selection
      NextSelected:= false
    else
      // reached start
      NextSelected:= true;
  end;
end;

var
  StringToDraw: PChar =nil;

Procedure TRichTextView.DrawLine( Line: TLineStart;
                                  Start: TPoint;
                                  var Selected: boolean );
var
  X, Y: longint;
  Element: TTextElement;
  StartedDrawing: boolean;
  Style: TTextDrawStyle;
  P: PChar;
  NextP: PChar;
  EndP: PChar;
  Q: PChar;

  BitmapIndex: longint;
  Bitmap: TBitmap;

  TextBlockStart: PChar;

  NextSelected: boolean;

  SelectionStartX: longint;
  SelectionEndX: longint;

  procedure DrawTextBlock;
  var
    PhysX: longint;
  begin
    PhysX := X div FontWidthPrecisionFactor;
    DrawString( PhysX, Y,
//                TextBlockStart, PCharDiff( P, TextBlockStart ),
                StringToDraw, PCharDiff( Q, StringToDraw ),
                Selected,
                Style.Font.Color );
    X := PhysX * FontWidthPrecisionFactor;
    Q:= StringToDraw;
  end;


begin
  P:= Line.Text;
  EndP:= Line.Text + Line.Length;

  SelectionStartX := -1;
  SelectionEndX := -1;

  if P = EndP then
  begin
    // Empty line - just check selection
    if SelectionChange( P, NextSelected ) then
      Selected:= NextSelected;
    exit;
  end;

  if StringToDraw = nil then
    StringToDraw:= StrAlloc( 200 );
  Q:= StringToDraw;

  Bitmap:= TBitmap.Create;
  Style:= Line.Style;
  FontManager.SetFont( Style.Font );
  StartedDrawing:= false;

  TextBlockStart:= P;

  Y:= Start.Y + Line.MaxDescender;

  while P < EndP do
  begin
    Element:= ExtractNextTextElement( P, NextP );

    if SelectionChange( P, NextSelected ) then
    begin
      DrawTextBlock;
      TextBlockStart:= P;
      Selected:= NextSelected;

      if Selected then
        SelectionStartX := X div 256
      else
        SelectionEndX := X div 256;
    end;

    case Element.ElementType of
      teWordBreak,
      teText,
      teImage:
      begin
        if not StartedDrawing then
        begin
          // we haven't yet started drawing:
          // so work out alignment
          X := Start.X * FontWidthPrecisionFactor
            + GetStartX( Style, Line );
          StartedDrawing:= true;
          if Selected then
            SelectionStartX := X div 256;
        end;

        // Now do the drawing
        if Element.ElementType = teImage then
        begin
          DrawTextBlock;
          TextBlockStart:= NextP;

          try
            BitmapIndex:= StrToInt( Element.Tag.Arguments );
          except
            BitmapIndex:= -1;
          end;
          if IsValidBitmapIndex( BitmapIndex ) then
          begin
            FIMages.GetBitmap( BitmapIndex, Bitmap );
{            if Selected then
              Bitmap.DrawInverted( Canvas,
                                   Rect( X, Start.Y,
                                         X + Bitmap.Width - 1,
                                         Bottom + Bitmap.Height - 1 ) )
            else}
              Canvas.Draw( X div FontWidthPrecisionFactor,
                           Start.Y,
                           Bitmap );

            inc( X, Bitmap.Width * FontWidthPrecisionFactor );
          end;
        end
        else
        begin
          // character (or word break)
          // build up the successive characters...
          Q^:= Element.Character;
          inc( Q );
        end;
      end;

      teStyle:
      begin
        DrawTextBlock;
        TextBlockStart:= NextP;
        PerformStyleTag( Element.Tag,
                         Style );
      end;
    end;
    P:= NextP;
  end;

  DrawTextBlock;

  if SelectionChange( EndP, NextSelected ) then
    Selected:= NextSelected;

{  if SelectionStartX <> -1 then
  begin
    if SelectionEndX = -1 then
      SelectionEndX := X div 256;

    Canvas.Pen.Mode := pmNot;
    Canvas.Brush.Style := bsDiagCross;
    Canvas.BeginPath;
    Canvas.MoveTo( SelectionStartX, Bottom );
    Canvas.LineTo( SelectionStartX, Bottom + Line.Height - 1 );
    Canvas.LineTo( SelectionEndX - 1, Bottom + Line.Height - 1 );
    Canvas.LineTo( SelectionEndX - 1, Bottom );
    Canvas.EndPath;
    Canvas.CloseFigure;
    Canvas.FillPath;
    Canvas.Brush.Mode := bmOpaque;
    Canvas.Pen.Mode := pmCopy;
  end;}

  Bitmap.Destroy;
end;

function InvertRGB( Arg: TColor ): TColor;
begin
  Result:= SysColorToRGB( Arg ); // in case it's a system color e.g. button face
  Result:= Result xor $ffffff; // now invert the RGB components
end;

Procedure TRichTextView.DrawString( Var X: longint;
                                    Y: longint;
                                    S: PChar;
                                    Len: longint;
                                    Selected: Boolean;
                                    PenColor: TColor );
var
  Point: TPoint;
begin
  if Len = 0 then
    exit;

  Point.X:= X;
  Point.Y:= Y;
  Canvas.Pen.Mode:= pmCopy;
  if FDebug then
  begin
    // generate a random dark color
    Canvas.Brush.Color:= random( 191 ) * 65536 //r
                         + random( 191 ) * 256 //g
                         + random( 191 );      //b
    Canvas.Pen.Color:= clWhite;
  end
  else if Selected then
  begin
    Canvas.Brush.Color:= InvertRGB( Color );
    Canvas.Pen.Color:= InvertRGB( PenColor );
  end
  else
  begin
    Canvas.Brush.Color:= Color;
    Canvas.Pen.Color:= PenColor;
  end;
  FontManager.DrawString( Point, Len, S );
  X:= Point.X;
end;

Procedure TRichTextView.DrawBorder;
var
  Rect: TRect;
  CornerRect: TRect;
begin
  Rect:= GetDrawRect;
  DrawSystemBorder( Self, Rect, FBorderStyle );
end;

Procedure TRichTextView.Draw( StartLine, EndLine: longint );
Var
  Selected: boolean;
  CurrentLine: TLineStart;
  CurrentLineIndex: longint;

  Temp: longint;

  Y: longint;
  DrawRect: TRect;

  DrawHeight: longint;

  TextLength: longint;

  StartCharIndex: longint;

  BottomOfLine: longint;
begin
  assert( StartLine >= 0 );
  assert( StartLine <= FNumLines );
  assert( EndLine >= 0 );
  assert( EndLine <= FNumLines );

  if StartLine > EndLine then
  begin
    // swap
    Temp:= EndLine;
    EndLine:= StartLine;
    StartLine:= Temp;
  end;

  if FNumLines = 0 then
    // no text to draw
    exit;

  TextLength:= StrLen( FText );

  DrawRect:= GetTextAreaRect;
  DrawHeight:= GetTextAreaHeight;

  GetFirstVisibleLine( CurrentLineIndex,
                       Y );
  if CurrentLineIndex = -1 then
    // no line visible
    exit;

  Y:= DrawRect.Top + Y;

  if StartLine < CurrentLineIndex then
    // no point starting above top line
    StartLine:= CurrentLineIndex;

  Selected:= false;

  StartCharIndex:= GetCharIndex( FLines[ StartLine ].Text );
  if SelectionSet then
    if FSelectionEnd > FSelectionStart then
    begin
      // selection start is before end
      if FSelectionStart < StartCharIndex then
        // selection starts before first line to draw
        if FSelectionEnd >= StartCharIndex then
          // and ends after, so we start selected
          Selected:= true;
    end
    else
    begin
      // selection start is AFTER end, so same test in reverse
      if FSelectionEnd < StartCharIndex then
        if FSelectionStart >= StartCharIndex then
          // and ends after, so we start selected
          Selected:= true;
    end;

  repeat
    CurrentLine:= FLines[ CurrentLineIndex ];
    if ( CurrentLineIndex >= StartLine )
       and ( CurrentLineIndex <= EndLine ) then
    begin
      BottomOfLine:= Y - CurrentLine.Height + 1; // bottom pixel row is top - height + 1
      // see if the line is within the cliprect at all
      if ( BottomOfLine <= Canvas.ClipRect.Top )
         and ( Y > Canvas.ClipRect.Bottom ) then
        // yes - draw it
        DrawLine( CurrentLine,
                  Point( DrawRect.Left - FXScroll,
                         BottomOfLine ),
                  Selected )
      else
        // no - check selection
        if SelectionSet then
        begin
          if Between( FSelectionStart,
                      GetCharIndex( CurrentLine.Text ),
                      GetCharIndex( CurrentLine.Text ) + CurrentLine.Length - 1 ) then
            Selected:= not Selected;
          if Between( FSelectionEnd,
                      GetCharIndex( CurrentLine.Text ),
                      GetCharIndex( CurrentLine.Text ) + CurrentLine.Length - 1 ) then
            Selected:= not Selected;
        end;
    end;
    dec( Y, CurrentLine.Height );

    if Y < 0 then
      // past bottom of control
      break;

    inc( CurrentLineIndex );

    if CurrentLineIndex >= FNumLines then
      // end of text
      break;

  until false;

  Canvas.Pen.Mode:= pmCopy;

End;

Function TRichTextView.GetCharIndex( P: PChar ): longint;
begin
  Result:= PCharDiff( P, FText );
end;

// This gets the area of the control that we can draw on
// (not taken up by scroll bars)
Function TRichTextView.GetDrawRect: TRect;
begin
  Result:= ClientRect;
  if FNeedHScroll then
    inc( Result.Bottom, FScrollbarWidth );
  // always have vscrollbar
  dec( Result.Right, FScrollbarWidth );
end;

// Gets the area that we are drawing text on, which is the
// draw rect minus borders
Function TRichTextView.GetTextAreaRect: TRect;
begin
  Result:= GetDrawRect;
  if FBorderStyle = bsSingle then
  begin
    // top and left borders
    inc( Result.Left, 2 );
    dec( Result.Top, 2 );

    // bottom border
    inc( Result.Bottom, 2 );

    // right border
    dec( Result.Right, 2 );
  end;
end;

Function TRichTextView.GetTextAreaHeight: longint;
var
  TextArea: TRect;
begin
  TextArea:= GetTextAreaRect;
  Result:= TextArea.Top - TextArea.Bottom + 1;
end;

Procedure TRichTextView.Redraw( const rec: TRect );
Var
  CornerRect: TRect;
  OldClip: TRect;
  DrawRect: TRect;
  TextRect: TRect;
  ClipRect: TRect;
begin
  DrawRect:= GetDrawRect;
  OldClip:= Canvas.ClipRect;
  ClipRect := IntersectRect( rec, DrawRect );
  Canvas.ClipRect:= ClipRect;

  TextRect:= GetTextAreaRect;

  DrawBorder;

  Canvas.FillRect( TextRect, Color );

  if InDesigner then
  begin
    Canvas.TextOut( TextRect.Left,
                    TextRect.Top - Canvas.TextHeight( 'H' ),
                    'Rich text will appear here.' );
    Canvas.ClipRect:= OldClip;
    exit;
  end;

  ClipRect := IntersectRect( rec, TextRect );
  Canvas.ClipRect:= ClipRect;

  Draw( 0, FNumLines );

  Canvas.DeleteClipRegion;

  if FNeedHScroll then
  begin
    // blank out corner between scrollbars
    CornerRect.Left:= Width - FScrollBarWidth;
    CornerRect.Bottom:= 0;
    CornerRect.Right:= Width;
    CornerRect.Top:= FScrollBarWidth;
    Canvas.FillRect( CornerRect, clBtnFace );
  end;

  Canvas.ClipRect:= OldClip;
End;

Procedure TRichTextView.SetupScrollbars;
var
  AvailableWidth: longint;
  MaxDisplayWidth: longint;
Begin
  FNeedVScroll:= false;
  FNeedHScroll:= false;

  if FTotalTextHeight > GetTextAreaHeight then
    FNeedVScroll:= true;

  AvailableWidth:= Width;
  if FBorderStyle <> bsNone then
    dec( AvailableWidth, 4 );
  dec( AvailableWidth, FScrollBarWidth ); // always allow space for vscrollbar

  MaxDisplayWidth := FMaxTextWidth div FontWidthPrecisionFactor
                     + FBasicLeftMargin
                     + FBasicRightMargin;
  if MaxDisplayWidth
     > AvailableWidth then
    FNeedHScroll:= true;

  FVScrollbar.Visible:= true;
  FVScrollbar.Enabled:= FNeedVScroll;

  FVScrollbar.Left:= Width - FScrollbarWidth;
  FVScrollbar.Width:= FScrollbarWidth;

  if FNeedHScroll then
  begin
    FVScrollbar.Bottom:= FScrollbarWidth;
    FVScrollbar.Height:= Height - FScrollbarWidth
  end
  else
  begin
    FVScrollbar.Bottom:= 0;
    FVScrollbar.Height:= Height;
  end;

  FVScrollBar.SliderSize:= GetTextAreaHeight;
  FVScrollBar.Min:= 0;

  if FNeedVScroll then
  begin
    FVScrollBar.Max:= FTotalTextHeight - 1;
  end
  else
  begin
    FVScrollBar.Position:= 0;
    FVScrollBar.Max:= 0;
  end;

  FHScrollbar.Visible:= FNeedHScroll;

  FHScrollbar.Left:= 0;
  FHScrollbar.Bottom:= 0;
  FHScrollbar.Height:= FScrollbarWidth;
  FHScrollbar.Width:= Width - FScrollBarWidth;

  FHScrollbar.SliderSize:= AvailableWidth;
  FHScrollbar.Min:= 0;

  if FNeedHScroll then
  begin
    FHScrollbar.Max:= MaxDisplayWidth;
  end
  else
  begin
    FHScrollBar.Position:= 0;
    FHScrollbar.Max:= 0;
  end;

  FHScrollBar.SmallChange:= 15; // pixels
  FHScrollBar.LargeChange:= AvailableWidth div 2;
  FVScrollBar.SmallChange:= 1; // not used (line up/down calculated explicitly)
  FVScrollBar.LargeChange:= GetTextAreaHeight div 2;

  FYScroll := FVScrollBar.Position;
  FLastYScroll := FYScroll;
  FXScroll := FHScrollBar.Position;
  FLastXScroll := FXScroll;
End;

Procedure TRichTextView.SetupCursor;
var
  Line: TLineStart;
  X, Y: longint;
  TextRect: TRect;
  DrawHeight: longint;
  DrawWidth: longint;
  CursorHeight: longint;
  TextHeight: longint;
  LineHeight: longint;
  Descender: longint;
  MaxDescender: longint;
begin
  RemoveCursor;
  if FSelectionStart = -1 then
    exit;

  TextRect:= GetTextAreaRect;
  DrawHeight:= TextRect.Top - TextRect.Bottom;
  DrawWidth:= TextRect.Right - TextRect.Left;

  Line:= FLines[ CursorRow ];
  LineHeight:= Line.Height;

  Y:= DrawHeight - ( GetLinePosition( CursorRow ) - FVScrollbar.Position );
  // Now Y is the top of the line
  if Y < 0 then
    // off bottom
    exit;
  if ( Y - LineHeight ) > DrawHeight then
    // off top
    exit;

  GetXFromOffset( FCursorOffset, CursorRow, X );

  dec( X, FHScrollBar.Position );

  if X < 0 then
    // offscreen to left
    exit;

  if X > DrawWidth then
    // offscreen to right
    exit;

  FCaret:= TCaret.Create( self );

  TextHeight:= FontManager.CharHeight;
  Descender:= FontManager.CharDescender;
  MaxDescender:= FLines[ CursorRow ].MaxDescender;
  CursorHeight:= TextHeight;

  dec( Y, LineHeight - 1 );
  // now Y is the BOTTOM of the line

  // move Y up to the bottom of the cursor;
  // since the current text may be smaller than the highest in the line
  inc( Y, MaxDescender - Descender );

  if Y < 0 then
  begin
    // bottom of line will be below bottom of display.
    dec( CursorHeight, 1 - Y );
    Y:= 0;
  end;

  if Y + CursorHeight - 1 > DrawHeight then
  begin
    // top of cursor will be above top of display
    CursorHeight:= DrawHeight - Y + 1;
  end;

  FCaret.SetSize( 0, CursorHeight );
  FCaret.SetPos( TextRect.Left + X,
                 TextRect.Bottom + Y ) ;
  FCaret.Show;
end;

procedure TRichTextView.RemoveCursor;
begin
  if FCaret <> nil then
  begin
    FCaret.Hide;
    FCaret.Destroy;
    FCaret:=NIL;
  end;
end;

Function TRichTextView.GetLineDownPos: longint;
var
  LastLine: longint;
  PixelsDisplayed: longint;
begin
  GetBottomLine( LastLine,
                 PixelsDisplayed );
  if LastLine <> -1 then
  begin
    // Scroll to make last line fully visible...
    Result:= FVScrollBar.Position
             + FLines[ LastLine ].Height
             - PixelsDisplayed;
    if PixelsDisplayed > FLines[ LastLine ].Height div 2 then
      // more than half line already displayed so
      if LastLine < FNumLines - 1 then
        // AND to make next line fully visible
        inc( Result, FLines[ LastLine + 1 ].Height );
  end;
end;

Function TRichTextView.GetLineUpPos: longint;
var
  FirstLine: longint;
  Offset: longint;
begin
  GetFirstVisibleLine( FirstLine,
                       Offset );
  // we should never have scrolled all lines off the top!!
  assert( FirstLine <> -1 );

  // scroll so that top line is fully visible...
  Result:= FVScrollBar.Position
           - Offset;

  if Offset < FLines[ FirstLine ].Height div 2 then
    // more than half the line was already displayed so
    if FirstLine > 0 then
      // AND to make next line up visible
      dec( Result, FLines[ FirstLine - 1 ].Height );

end;

Function Sign( arg: longint ): longint;
begin
  if arg>0 then
    Result:= 1
  else if arg<0 then
    Result:= -1
  else
    Result:= 0;
end;

Function FSign( arg: double ): double;
begin
  if arg>0 then
    Result:= 1
  else if arg<0 then
    Result:= -1
  else
    Result:= 0;
end;

Procedure ExactDelay( MS: longint );
var
  LastTime: ULONG;
begin
  LastTime:= WinGetCurrentTime( AppHandle );

  while WinGetCurrentTime( AppHandle ) - LastTime < MS do
    ;
end;

Procedure TRichTextView.Scroll( Sender: TScrollbar;
                                ScrollCode: TScrollCode;
                                Var ScrollPos: Longint );

begin
  case ScrollCode of
//    scVertEndScroll,
//    scVertPosition,
    scPageUp,
    scPageDown,
    scVertTrack:
      DoVerticalScroll( ScrollPos );

    // Line up and down positions are calculated for each case
    scLineDown:
    begin
      ScrollPos:= GetLineDownPos;
      DoVerticalScroll( ScrollPos );
    end;

    scLineUp:
    begin
      ScrollPos:= GetLineUpPos;
      DoVerticalScroll( ScrollPos );
    end;

    scHorzPosition,
    scPageRight,
    scPageLeft,
    scHorzTrack,
    scColumnRight,
    scColumnLeft:
    begin
      DoHorizontalScroll( ScrollPos );
    end;
  end;
end;

Procedure TRichTextView.DoVerticalScroll( NewY: longint );

var
  ScrollDistance: longint;
  rect: rectl;
begin
  if not Visible then
    exit;

  FYScroll := NewY;
  ScrollDistance:= FYScroll - FLastYScroll;

  ScrollControlRect( Self,
                     GetTextAreaRect,
                     0,
                     ScrollDistance,
                     Color,
                     FSmoothScroll );

  FLastYScroll:= FYScroll;
  Update;
end;

Procedure TRichTextView.DoHorizontalScroll( NewX: longint );
var
  ScrollDistance: longint;
begin
  if not Visible then
    exit;

  FXScroll := NewX;
  ScrollDistance:= FXScroll - FLastXScroll;

  ScrollControlRect( Self,
                     GetTextAreaRect,
                     - ScrollDistance,
                     0,
                     Color,
                     FSmoothScroll );

  FLastXScroll:= FXScroll;
  Update;
end;

Procedure TRichTextView.SetVerticalPosition( NewY: longint );
begin
  FVScrollbar.Position:= NewY;
  DoVerticalScroll( FVScrollbar.Position );
end;

Procedure TRichTextView.SetHorizontalPosition( NewX: longint );
begin
  FHScrollbar.Position:= NewX;
  DoHorizontalScroll( FHScrollbar.Position );
end;

Procedure TRichTextView.AddParagraph( Text: PChar );
begin
  AddText( Text );
  AddText( #13 );
  AddText( #10 );
  Layout;
end;

Procedure TRichTextView.AddSelectedParagraph( Text: PChar );
begin
  SelectionStart:= GetTextEnd;
  AddText( Text );
  AddText( #13 );
  AddText( #10 );
  Layout;
  Refresh;
  SelectionEnd:= GetTextEnd;
  MakeCharVisible( SelectionStart );
end;

Procedure TRichTextView.AddText( Text: PChar );
begin
  AddAndResize( FText, Text );
  Layout;
  Refresh;
end;

// Insert at current point
Procedure TRichTextView.InsertText( CharIndexToInsertAt: longword;
                                    TextToInsert: PChar );
var
  NewText: PChar;
begin
  if CharIndexToInsertAt < 0 then
    exit;

  NewText:= StrAlloc( StrLen( FText ) + StrLen( TextToInsert ) + 1 );
  StrLCopy( NewText, FText, CharIndexToInsertAt );
  StrCat( NewText, TextToInsert );
  StrCat( NewText, FText + CharIndexToInsertAt );

  Clear;
  AddText( NewText );
  StrDispose( NewText );
end;

Procedure TRichTextView.Clear;
begin
  ClearSelection;
  FText[ 0 ]:= #0;
  FTopCharIndex := 0;
  Layout;
  Refresh;
end;

procedure TRichTextView.SetBorder( BorderStyle: TBorderStyle );
begin
  FBorderStyle:= BorderStyle;
  Refresh;
end;

Procedure TRichTextView.SetImages( Images: TImageList );
begin
  if Images = FImages then
    exit; // no change

  if FImages <> nil then
    // Tell the old imagelist not to inform us any more
    FImages.Notification( Self, opRemove );

  FImages:= Images;
  if FImages <> nil then
    // request notification when other is freed
    FImages.FreeNotification( Self );

  Layout;
  Refresh;
end;

Procedure TRichTextView.Notification( AComponent: TComponent;
                                      Operation: TOperation );
begin
  inherited Notification( AComponent, Operation );
  if AComponent = FImages then
    if Operation = opRemove then
      FImages:= nil;
end;

Procedure TRichTextView.MouseDown( Button: TMouseButton;
                                   ShiftState: TShiftState;
                                   X, Y: Longint );
var
  Line: longint;
  Offset: longint;
  Link: string;
begin
  inherited MouseDown( Button, ShiftState, X, Y );

  Focus;

  if Button <> mbLeft then
    exit;

  FindPoint( X, Y, Line, Offset, Link );
  FClickedLink:= Link;

  case Line of
  liBelowText:
    SetSelectionStart( GetTextEnd );

  liAboveTextArea,
  liBelowTextArea:
    exit;

  else
    RemoveCursor;
    ClearSelection;

    SetCursorPosition( Offset, Line, false );
  end;
  MouseCapture:= true;

end;

Procedure TRichTextView.MouseUp( Button: TMouseButton;
                                 ShiftState: TShiftState;
                                 X, Y: Longint );
begin
  inherited MouseUp( Button, ShiftState, X, Y );

  if Button <> mbLeft then
    exit;

  if FScrollTimer.Running then
    FScrollTimer.Stop;

  MouseCapture:= false;

  SetupCursor;

  if FClickedLink <> '' then
    if Assigned( FOnClickLink ) then
      FOnClickLink( Self, FClickedLink );

end;

Procedure TRichTextView.MouseMove( ShiftState: TShiftState;
                                   X, Y: Longint );
var
  Line: longint;
  Offset: longint;
  Link: string;
begin
  inherited MouseMove( ShiftState, X, Y );

  FindPoint( X, Y, Line, Offset, Link );

  if not MouseCapture then
  begin
    if Link <> FLastLinkOver then
    begin
      if Link <> '' then
      begin
        if Assigned( FOnOverLink ) then
          FOnOverLink( Self, Link )
      end
      else
      begin
        if Assigned( FOnNotOverLink ) then
          FOnNotOverLink( Self, FLastLinkOver );
      end;

      FLastLinkOver:= Link;
    end;

    if Link <> '' then
      Cursor:= FLinkCursor
    else
      Cursor:= crIBeam;
    exit;
  end;

  // We are holding mouse down and draggin to set a selection:

  if Line = liAboveTextArea then
  begin
    // above top
    FOldMousePoint:= Point( X, Y );
    FScrollingDirection:= sdUp;
    if not FScrollTimer.Running then
    begin
      FScrollTimer.Start;
      OnScrollTimer( self );
    end;
    exit;
  end
  else if Line = liBelowTextArea then
  begin
    // below bottom
    FOldMousePoint:= Point( X, Y );
    FScrollingDirection:= sdDown;
    if not FScrollTimer.Running then
    begin
      FScrollTimer.Start;
      OnScrollTimer( self );
    end;
    exit;
  end;

  // Normal selection, cursor within text rect
  if FScrollTimer.Running then
    FScrollTimer.Stop;

  if Line = liBelowText then
    // Within text area but below displayed text
    SetCursorPosition( FLines[ FNumLines - 1 ].Length,
                       FNumLines - 1,
                       true )

  else
  begin
    SetCursorPosition( Offset,
                       Line,
                       true );
  end;

  if SelectionSet then
  begin
    FClickedLink:= ''; // if they move while on a link we don't want to follow it.
    Cursor:= crIBeam;
  end;

end;

procedure TRichTextView.OnScrollTimer( Sender: TObject );
var
  Line, Offset: longint;
  MousePoint: TPoint;
  TextRect: TRect;
begin
  MousePoint:= Screen.MousePos;
  MousePoint:= ScreenToClient( MousePoint );
  TextRect:= GetTextAreaRect;

  if FScrollingDirection = sdDown then
    // scrolling down
    if FVScrollbar.Position = FVScrollbar.Max then
      exit
    else
    begin
      if ( TextRect.Bottom - MousePoint.Y ) < 20 then
        DownLine
      else
        DownPage;

      GetBottomLine( Line, Offset );
      SetSelectionEndInternal( GetCharIndex( Flines[ Line ].Text )
                               + FLines[ Line ].Length );
    end
  else
    // scrolling up
    if FVScrollbar.Position = FVScrollbar.Min then
      exit
    else
    begin
      if ( MousePoint.Y - TextRect.Top ) < 20 then
        UpLine
      else
        UpPage;
      GetFirstVisibleLine( Line, Offset );
      SetSelectionEndInternal( GetCharIndex( FLines[ Line ].Text ) );
    end;

end;

Procedure TRichTextView.UpLine;
begin
  SetVerticalPosition( GetLineUpPos );
end;

Procedure TRichTextView.DownLine;
begin
  SetVerticalPosition( GetLineDownPos );
end;

Procedure TRichTextView.UpPage;
begin
  SetVerticalPosition( FVScrollbar.Position - FVScrollbar.LargeChange );
end;

Procedure TRichTextView.DownPage;
begin
  SetVerticalPosition( FVScrollbar.Position + FVScrollbar.LargeChange );
end;

function TRichTextView.GetCursorIndex: longint;
begin
  Result:= GetCharIndex( FLines[ FCursorRow ].Text ) + FCursorOffset;
end;

procedure TRichTextView.RefreshCursorPosition;
var
  Index: longint;
  Row: longint;
begin
  if SelectionSet then
    Index:= FSelectionEnd
  else
    Index:= FSelectionStart;
  if Index = -1 then
  begin
    RemoveCursor;
    exit;
  end;

  Row:= GetLineFromCharIndex( Index );
  SetCursorPosition( Index - GetCharIndex( FLines[ Row ].Text ),
                     Row,
                     true );
end;

procedure TRichTextView.SetCursorIndex( Index: longint );
var
  Row: longint;
begin
  Row:= GetLineFromCharIndex( Index );
  SetCursorPosition( Index - GetCharIndex( FLines[ Row ].Text ),
                     Row,
                     false );
end;

procedure TRichTextView.SetCursorPosition( Offset: longint;
                                           Row: longint;
                                           PreserveSelection: boolean );
var
  Index: longint;
begin
  RemoveCursor;
  FCursorOffset:= Offset;
  FCursorRow:= Row;
  Index:= GetCharIndex( FLines[ Row ].Text ) + Offset;
  if PreserveSelection then
    SetSelectionEndInternal( Index )
  else
  begin
    SetSelectionEndInternal( -1 );
    SetSelectionStartInternal( Index );
  end;
  MakeRowVisible( FCursorRow );
end;

Procedure TRichTextView.CursorRight( PreserveSelection: boolean );
Var
  P: PChar;
  NextP: PChar;
  Element: TTextElement;
  NewOffset: longint;
  Line: TLineStart;
begin
  P:= FText + CursorIndex;

  Element:= ExtractNextTextElement( P, NextP );
  P:= NextP;
  while Element.ElementType = teStyle do
  begin
    Element:= ExtractNextTextElement( P, NextP );
    P:= NextP;
  end;

//  if Element.ElementType = teTextEnd then
//    exit;

//  SetCursorIndex( GetCharIndex( P ), PreserveSelection );
  Line:= FLines[ CursorRow ];
  NewOffset:= PCharDiff( P, Line.Text );
  if NewOffset < Line.Length then
    SetCursorPosition( NewOffset, FCursorRow, PreserveSelection )
  else if ( NewOffset = Line.Length )
          and not Line.Wrapped then
    SetCursorPosition( NewOffset, FCursorRow, PreserveSelection )
  else
  begin
    if FCursorRow >= FNumLines - 1 then
      exit;
    SetCursorPosition( 0, FCursorRow + 1, PreserveSelection );
  end;
  SetupCursor;
end;

Procedure TRichTextView.CursorLeft( PreserveSelection: boolean );
Var
  P: PChar;
  NextP: PChar;
  Element: TTextElement;
  Line: TLineStart;
  NewOffset: longint;
begin
  P:= FText + CursorIndex;

  Element:= ExtractPreviousTextElement( P, NextP );
  P:= NextP;
  while Element.ElementType = teStyle do
  begin
    Element:= ExtractPreviousTextElement( P, NextP );
    P:= NextP;
  end;

//  if Element.ElementType = teTextEnd then
//    exit;
  Line:= FLines[ CursorRow ];
  NewOffset:= PCharDiff( P, Line.Text );
  if NewOffset >= 0 then
    SetCursorPosition( NewOffset, FCursorRow, PreserveSelection )
  else
  begin
    if FCursorRow <= 0 then
      exit;
    Line:= FLines[ CursorRow - 1 ];
    if Line.Wrapped then
      SetCursorPosition( Line.Length - 1, FCursorRow - 1, PreserveSelection )
    else
      SetCursorPosition( Line.Length, FCursorRow - 1, PreserveSelection )
  end;
  SetupCursor;

end;

Procedure TRichTextView.CursorDown( PreserveSelection: boolean );
var
  X: longint;
  Link: string;
  Offset: longint;
begin
  if CursorRow >= FNumLines - 1 then
    exit;

  GetXFromOffset( FCursorOffset, FCursorRow, X );
  GetOffsetFromX( X,
                  FCursorRow + 1,
                  Offset,
                  Link );

  SetCursorPosition( Offset, FCursorRow + 1, PreserveSelection );
  SetupCursor;
end;

Procedure TRichTextView.CursorUp( PreserveSelection: boolean );
var
  X: longint;
  Link: string;
  Offset: longint;
begin
  if CursorRow <= 0 then
    exit;

  GetXFromOffset( FCursorOffset,
                  FCursorRow,
                  X );
  GetOffsetFromX( X,
                  FCursorRow - 1,
                  Offset,
                  Link );

  SetCursorPosition( Offset, FCursorRow - 1, PreserveSelection );
  SetupCursor;

end;

Procedure TRichTextView.CopySelectionToClipboard;
var
  SelLength: Longint;
  Buffer: PChar;
  rc: APIRET;
begin
  SelLength:= SelectionLength;
  if SelectionLength = 0 then
    exit;

  Buffer:= StrAlloc( SelLength + 1 );

  CopySelectionToBuffer( Buffer );

  if Clipboard.Open( Self.Handle ) then
  begin
    Clipboard.Empty;
    Clipboard.SetTextBuf( Buffer );
    Clipboard.Close;
  end;

  StrDispose( Buffer );
end;

Procedure TRichTextView.CopySelectionToBuffer( Buffer: PChar );
var
  P, EndP: PChar;
  Q: PChar;
begin
  Buffer[ 0 ]:= #0;
  if    ( FSelectionStart = -1 )
     or ( FSelectionEnd = -1 ) then
    exit;
  Q:= Buffer;

  if FSelectionStart < FSelectionEnd then
  begin
    P:= FText + FSelectionStart;
    EndP:= FText + FSelectionEnd;
  end
  else
  begin
    P:= FText + FSelectionEnd;
    EndP:= FText + FSelectionStart;
  end;
  CopyBlockToBuffer( P, EndP, Buffer );
end;

procedure TRichTextView.CopyBlockToBuffer( StartP: PChar; EndP: PChar; Buffer: PChar );
var
  Q: PChar;
  P: PChar;
  NextP: PChar;
  Element: TTextElement;
begin
  P:= StartP;
  Q:= Buffer;
  while P < EndP do
  begin
    Element:= ExtractNextTextElement( P, NextP );
    if Element.ElementType in [ teText, teWordBreak, teLineBreak ] then
    begin
      // copy char
      Q^:= Element.Character;
      inc( Q );
    end;
    P:= NextP;
  end;
end;

Procedure TRichTextView.CopyToBuffer( Buffer: PChar );
begin
  CopyBlockToBuffer( FText, FText + strlen( FText ), Buffer );
end;

Function TRichTextView.SelectionLength: longint;
begin
  Result:= 0;
  if ( FSelectionStart = -1 )
     or ( FSelectionEnd = -1 ) then
    exit;

  Result:= FSelectionEnd - FSelectionStart;
  if Result < 0 then
    Result:= FSelectionStart - FSelectionEnd;
end;

Function TRichTextView.SelectionSet: boolean;
begin
  Result:= ( FSelectionStart <> -1 )
       and ( FSelectionEnd <> - 1 )
       and ( FSelectionStart <> FSelectionEnd );
end;

Procedure TRichTextView.SelectAll;
begin
  ClearSelection;
  SelectionStart:= GetCharIndex( FText );
  SelectionEnd:= GetTextEnd;
end;

procedure TRichTextView.ScanEvent( Var KeyCode: TKeyCode;
                                   RepeatCount: Byte );
begin
  case KeyCode of
    kbCtrlC, kbCtrlIns:
      CopySelectionToClipboard;
    kbCtrlA:
      SelectAll;
    kbCtrlCUp:
      UpLine;
    kbCtrlCDown:
      DownLine;
    kbCUp:
      if FSelectionStart <> -1 then
        CursorUp( false )
      else
        // no cursor - scroll always
        UpLine;
    kbCDown:
      if FSelectionStart <> -1 then
        CursorDown( false )
      else
        // no cursor - scroll always
        DownLine;
    kbShiftCUp:
      if FSelectionStart <> -1 then
        CursorUp( true )
      else
        // no cursor - scroll always
        UpLine;
    kbShiftCDown:
      if FSelectionStart <> -1 then
        CursorDown( true )
      else
        // no cursor - scroll always
        DownLine;
    kbPageUp:
      UpPage;
    kbPageDown:
      DownPage;
    kbHome, kbCtrlHome, kbCtrlPageUp:
      GotoTop;
    kbEnd, kbCtrlEnd, kbCtrlPageDown:
      GotoBottom;
    kbCRight:
      CursorRight( false );
    kbShiftCRight:
      CursorRight( true );
    kbCLeft:
      CursorLeft( false );
    kbShiftCLeft:
      CursorLeft( true );
    else
    begin
      inherited ScanEvent( KeyCode, RepeatCount );
      exit;
    end;
  end;

  KeyCode:= kbNull;

end;

procedure TRichTextView.GoToTop;
begin
  SetVerticalPosition( 0 );
end;

procedure TRichTextView.GotoBottom;
begin
  SetVerticalPosition( FVScrollBar.Max );
end;

function TRichTextView.GetLinePosition( Line: longint ): longint;
begin
  Result:= 0;
  dec( line );
  while line >= 0 do
  begin
    inc( Result, Flines[ Line ].Height );
    dec( line );
  end;
end;

Function TRichTextView.GetTopCharIndex: longint;
var
  LineIndex: longint;
  Y: longint;
begin
  if not FVerticalPositionInitialised then
  begin
    Result := FTopCharIndex;
    exit;
  end;
  GetFirstVisibleLine( LineIndex,
                       Y );
  if LineIndex >= 0 then
    Result := GetCharIndex( FLines[ LineIndex ].Text )
  else
    Result := 0;
end;

Function TRichTextView.GetTopCharIndexPosition( NewTopCharIndex: longint ): longint;
var
  Line: longint;
  Height: longint;
begin
  if NewValue > GetTextEnd then
  begin
    Result := FVScrollBar.Max;
    exit;
  end;
  Line:= GetLineFromCharIndex( NewValue );
  if Line < 0 then
  begin
    Result := FVScrollBar.Position;
    exit;
  end;
  Height := GetLinePosition( Line );
  Result := Height;
end;

Procedure TRichTextView.SetTopCharIndex( NewValue: longint );
var
  OldSmoothScroll: boolean;
  NewPosition: longint;
begin
  if not FVerticalPositionInitialised then
  begin
    if ( NewValue >= 0 )
       and ( NewValue < GetTextEnd ) then
    begin
      FTopCharIndex := NewValue;
    end;
    exit;
  end;
  NewPosition := GetTopCharIndexPosition( NewValue );
  SetVerticalPosition( NewPosition );
end;

procedure TRichTextView.MakeCharVisible( CharIndex: longint );
var
  Line: longint;
begin
  Line:= GetLineFromCharIndex( CharIndex );

  MakeRowVisible( Line );
end;

procedure TRichTextView.MakeRowVisible( Row: longint );
var
  TopLine: longint;
  BottomLine: longint;
  Offset: longint;
  NewPosition: longint;
begin
  GetFirstVisibleLine( TopLine, Offset );
  if ( Row = TopLine )
     and ( Offset = 0 ) then
    exit;

  GetBottomLine( BottomLine, Offset );

  if ( Row = BottomLine )
     and ( Offset >= FLines[ BottomLine ].Height - 1 ) then
    exit;

  if ( Row > TopLine )
     and ( Row < BottomLine ) then
    exit;

  if Row <= TopLine then
  begin
    NewPosition:= GetLinePosition( Row );
  end
  else
  begin
    if ( BottomLine <> -1 )
       and ( Row >= BottomLine ) then
      NewPosition:= GetLinePosition( Row )
                    + FLines[ Row ].Height
                    - GetTextAreaHeight;
  end;

  SetVerticalPosition( NewPosition );
end;

function TRichTextView.Find( Origin: TFindOrigin; Text: string ): longword;
var
  P: PChar;
  CSearchString: array[ 0..255 ] of char;
  SearchLen: integer;
begin
  if ( Origin = foFromCurrent )
     and SelectionSet then
    P:= FText + FSelectionStart + 1
  else
    P:= FText;

  StrPCopy( CSearchString, Text );
  SearchLen:= Length( Text );

  while P^ <> #0 do
  begin
    if P[ 0 ] = '<' then
      // skip tag
      ExtractTag( P )
    else
    begin
      if StrLIComp( P, CSearchString, SearchLen ) = 0 then
      begin
        Result:= GetCharIndex( P );
        MakeCharVisible( Result );
        FSelectionStart:= Result;
        SelectionEnd:= Result + SearchLen;
        exit;
      end;

      inc( P );
    end;
  end;
  Result:= -1;
end;

function TRichTextView.LinkFromIndex( const CharIndexToFind: longint): string;
Var
  P: PChar;
  NextP: PChar;
  EndP: PChar;
  Element: TTextElement;
  LineIndex: longint;
  Line: TLineStart;
begin
  LineIndex:= GetLineFromCharIndex( CharIndexToFind );

  Line:= FLines[ LineIndex ];
  P:= Line.Text;
  EndP:= Line.Text + Line.Length;

  if Line.LinkIndex <> -1 then
    Result:= FLinks[ Line.LinkIndex ]
  else
    Result:= '';

  while P < EndP do
  begin
    if GetCharIndex( P ) >= CharIndexToFind then
      exit;

    Element:= ExtractNextTextElement( P, NextP );

    case Element.ElementType of
      teStyle:
        case Element.Tag.TagType of
          ttBeginLink:
            Result:= Element.Tag.Arguments;
          ttEndLink:
            Result:= '';
        end;
    end;

    P:= NextP;
  end;
end;

Initialization
  {Register classes}
  RegisterClasses([TRichTextView]);

  TheLinkPointer:= TPointer.Create;
  TheLinkPointer.LoadFromResourceName( 'LinkPointer' );
  TheLinkCursor:= Screen.AddCursor( TheLinkPointer.Handle );

End.

