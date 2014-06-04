unit MainUnit;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, ExtCtrls, MMSystem, StdCtrls, Buttons, Contnrs, VsyakijMusorUnit,
  ComCtrls;


var
   WinWidth,WinHeight,
   RADIUS,FLOORPOS,STARTY,STARTX_White,
   STARTX_BLACK: integer;
   FIRSTHPBAR_CREATED:boolean;

const
      VK_RELEASE = 999;

      WINTOP = 0;
      WINRIGHT = 0;

      //GG = 1;

      MAX_VX = 15;
      MAX_Vy = 45;
      SHAG = 2;
      BERZESSPEKS = 1;
      CISLOg = 10;
      KOEF = 0.75;
      RUNPICCOUNT = 12;
      START_SPEED = 1.1;
      JUMP_STRENGTH = 22;


type

  TCamera = class(TComponent)
  private
     XPosOfCam: int64;
     YPosOfCam: integer;
  protected
     procedure SetX(arg: int64);
     procedure SetY(arg: integer);
  public
     BX,BY: integer;
     Function InRange(ThatControl: TControl): boolean;
  published
     property x: int64 read XPosOfCam write SetX;
     property y: integer read YPosOfCam write SetY;
  end;


  THealthBar = class(TProgressBar)
  private
     TextIndicator: TLabel;
  public
     procedure UpdateValue(arg: integer);
     constructor create(Mokona: TImage);
     destructor destroy; override;
  end;

  TGameElement = class(TImage)
  private
  protected
     subpicture: TBitmap;

     Function GetVx: real; virtual;
     Function GetVy: real; virtual;
     Procedure SetVX(arg:real); virtual;
     Procedure SetVY(arg:real); virtual;

  public
     DeltaX, DeltaY: integer;
     Procedure SetHeWiLeTo(he,wi,le,theTop: integer); virtual;
     Procedure SetImage(path: string); virtual;
     constructor create(owner: TComponent); override;
     //function DoesInteract(c: TGameElement): boolean; virtual;
     Function VisheCem(Cto: TGameElement): boolean;
  published

     property VX: real read GetVx write SetVX;
     property VY: real read GetVy write SetVY;
  end;

  TGameElementList = class(TComponentList)
  public
     curComponent: TComponent;
     constructor create;
     procedure HideAllOutOfRange(cam: TCamera);
     procedure UnhideAllInRange(cam: TCamera);
  end;

  TMovingGameElement = class(TGameElement)
  protected
     Procedure BorderDefense; virtual;
  public
     ConstVx,ConstVy: real;
     Constructor Create(owner: TComponent); override;
     Procedure RenewState; virtual;
  end;

    
  TPhisics = class(TMovingGameElement)
  protected
     LastBoundX,LastBoundY: integer;
     MyCurrentFloor: TGameElement;

     procedure PutOn(where: TGameElement); virtual;
  public
     constructor create(owner: TComponent); override;
  published
     property OnWhatStands: TGameElement read MyCurrentFloor write PutOn;
  end;

  TMokonalForm = class(TForm)
  public
     VseComponenti: TGameElementList;
     LiveComponenti: TGameElementList;
     procedure Free(arg: integer); virtual; Abstract;
  end;

Function IsRectInRect(Rect1,Rect2: TRect): boolean;
Procedure ChangePlaces(var arg1,arg2: integer);
Function power(Cto, VKakuju: byte): integer;

implementation


Function power(Cto, VKakuju: byte): integer;
Begin
   If Vkakuju=0 then result:=1 else
   result:=Cto*power(Cto,VKakuju-1);
End;

Procedure ChangePlaces(var arg1,arg2: integer);
var subarg: integer;
Begin
   subarg:=arg1;
   arg1:=arg2;
   arg2:=subarg;
end;



Function IsRectInRect(Rect1,Rect2: TRect): boolean;
Begin
    with Rect1 do begin
       if Left>Right then ChangePlaces(Left,Right);
       if Bottom>Top then ChangePlaces(Bottom,Top);
    end;

    with Rect2 do begin
       if Left>Right then ChangePlaces(Left,Right);
       if Bottom>Top then ChangePlaces(Bottom,Top);
    end;

    if (Rect1.Right>=Rect2.Left)
    and (Rect1.Left<=Rect2.Right)
    and (Rect1.Bottom<=Rect2.Top)
    and (Rect1.Top>=Rect2.Bottom)
    then result:=true
    else result:=false;
End;

constructor THealthBar.create(Mokona: TImage);
Begin
   inherited create(Mokona.Owner);
   parent:=(Mokona.Owner as TForm);
   TextIndicator:=TLabel.Create(Owner);
   TextIndicator.Parent:=(owner as TWinControl);
   Max:=100;
   Min:=0;
   Position:=100;
   self.Width:=WinWidth div 8;
   Top:=10;
   TextIndicator.Caption:='100';
   If FIRSTHPBAR_CREATED then begin
      Left:=10;
   end else begin
      Left:=WinWidth-100-WinWidth div 8;
      FirstHPBar_Created:=true;
   end;
   Height:=WinHeight div 100;
   TextIndicator.Top:=Top+Height+1;
   TextIndicator.Left:=Left;
End;


procedure THealthBar.UpdateValue(arg: integer);
Begin
   Position:=arg;
   TextIndicator.Caption:=IntToStr(Position);
End;

destructor THealthBar.destroy;
Begin
   TextIndicator.Destroy;
   inherited destroy;
End;

Procedure TGameElement.SetHeWiLeTo(he,wi,le,theTop: integer);
Begin
   if (he<>height) or (wi<>width) then begin
      Picture.Bitmap.Width:=wi;
      Picture.Bitmap.Height:=he;
      Picture.Bitmap.Canvas.StretchDraw(Rect(0,0,wi,he-1), SubPicture);
   end;
   left:=le;
   Top:=TheTop;
   height:=he;
   width:=wi;
End;

Procedure TGameElement.SetImage(path: string);
Begin
   SubPicture.LoadFromFile(path);
   Height:=12345;
   Width:=67890;
   SetHeWiLeTo(10,WinWidth,0,FLOORPOS);
End;

constructor tGameElement.create(owner: TComponent);
Begin
   inherited create(owner);
   Parent:= (owner as TWinControl);

   SubPicture:=TBitmap.Create;
   Picture.Bitmap:=TBitmap.Create;
   SetImage('Files\FloorTexture.bmp');

   Visible:= true;
   Transparent:=true;
   DeltaX:=0;
   DeltaY:=10;
   (owner as TMokonalForm).VseComponenti.add(self);
End;

Constructor TMovingGameElement.Create(owner: TComponent);
Begin
   inherited Create(owner);
   SetHeWiLeTo(10,WINWIDTH div 15,20,FLOORPOS-JUMP_STRENGTH);
    (owner as TMokonalForm).LiveComponenti.add(self);
   ConstVx:=0;
   ConstVy:=0;
End;

Procedure TMovingGameElement.BorderDefense;
Begin
      if (Left>=(Owner as TControl).Width-Width)
      or (Left<=0)
      then begin
           ConstVx:=-ConstVx;
      end;
End;

Procedure TMovingGameElement.RenewState;
Begin
   Borderdefense;
   Left:=Left+round(ConstVx);
   Top:=Top+round(ConstVy);
End;

Constructor TGameElementList.Create;
Begin
   ownsObjects:=false;
End;

Procedure TGameElementList.HideAllOutOfRange(cam: TCamera);
var CurControl: TGameElement;
    i: integer;
Begin
   If count=0 then exit;
   CurControl:= First as TGameElement;
   i:=IndexOf(First);
   repeat
      if not Cam.InRange(CurControl) then CurControl.Visible:=false;
      inc(i);
      CurControl:=(Self[i] as TGameElement);
   until CurControl<>(Last as TGameElement);
End;

Procedure TGameElementList.UnHideAllInRange(cam: TCamera);
var CurControl: TGameElement;
    i: integer;
Begin
   If count=0 then exit;
   CurControl:= First as TGameElement;
   i:=IndexOf(First);
   repeat
      if Cam.InRange(CurControl) then CurControl.Visible:=true;
      inc(i);
      CurControl:=(Self[i] as TGameElement);
   until CurControl<>(Last as TGameElement);
End;

Procedure TCamera.SetX(arg: int64);
Begin
   with (Owner as TScrollingWinControl) do begin
      HorzScrollBar.Position:=HorzScrollBar.Position+(arg-XPosOfCam);
      HorzScrollBar.Range:=HorzScrollBar.Range+arg-XPosOfCam;
      XPosOfCam:=arg;
      //VseComponenti.HideAllOutOfRange(Self);
      //VseComponenti.UNHideAllInRange(Self);
   end;
End;

Procedure TCamera.SetY(arg: integer);
Begin
   with (Owner as TScrollingWinControl) do begin
     VertScrollBar.Position:=HorzScrollBar.Position+(arg-YPosOfCam);
     VertScrollBar.Range:=HorzScrollBar.Range+arg-YPosOfCam;
     YPosOfCam:=arg;
   end;
End;

Function TCamera.InRange(ThatControl: TControl): boolean;
Begin
   If (ThatControl is TImage) or (ThatControl is TLabel)
   then with ThatControl do
    result:=(IsRectInRect( Rect(Point(X-BX,Y-BY), Point(X+BX,Y+BY)),
                           Rect(Point(Left,Top), Point(Left+Width,Top+Height)) )  )
   else result:=false;
end;

Procedure TGameElement.SetVX(arg:real);
Begin
// Do nothing
End;

Procedure TGameElement.SetVY(arg:real);
Begin
// Do nothing
End;

Function TGameElement.VisheCem(Cto: TGameElement): boolean;
Begin
   result:=Self.Top+Height<=Cto.Top+Cto.DeltaY+Max_VY;
   if vy<0 then result:=false;
End;

Function TGameElement.GetVx: real;
Begin
   result:=0;
end;

Function TGameElement.GetVy: real; 
Begin
   result:=0;
end;


Procedure TPhisics.PutOn(where: TGameElement);
Begin
   Top:=Where.Top-Height-1+where.DeltaY;
   MyCurrentFloor:=where;
   LastBoundX:=where.Left;
   LastBoundY:=where.Top;
End;

Constructor TPhisics.Create(owner: TComponent);
Begin
   inherited create(owner);
   MyCurrentFloor:=nil;
End;

end.
