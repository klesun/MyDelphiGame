unit TBattleMokonaUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, ExtCtrls, MMSystem, StdCtrls, Buttons, Contnrs, VsyakijMusorUnit,
  MainUnit;

const GG = 1;

Type
TBattleMokona = class(TPhisics)
  private
    MokonasHealth: integer;
    HealthBar: THealthBar;
    DirectionOfMokonasView: shortint;
    curpic: byte;
    VseBooli: byte;
    MyVx,MyVy: real;
  protected
    RunPictures: array [1..RUNPICCOUNT] of TBitmap;

    procedure SetVx(arg: real); override;
    procedure SetVy(arg: real); override;
    function GetVx: real; override;
    function GetVy: real; override;

    Function GetIsSpeeding: boolean;
    Function GetIsFalling: boolean;
    Function GetIsJumping: boolean;
    Function GetIsDying: boolean;
    Function GetIsStanding: boolean;
    Function GetIsUnderControll: boolean;

    procedure SetDir(arg: shortint);
    procedure SetPic(arg: byte);
    procedure SetHealth(arg: integer);

    Procedure SetIsSpeeding(arg: boolean);
    Procedure SetIsFalling(arg: boolean);
    Procedure SetIsJumping(arg: boolean);
    Procedure SetIsDying(arg: boolean);
    Procedure SetIsStanding(arg: boolean);
    Procedure SetIsUnderControll(arg: boolean);

    Function GetVseBooli(arg: byte): boolean;
    Procedure SetVseBooli(value: boolean; arg: byte);

    Procedure BorderDefense; override;
    procedure PutOn(where: TGameElement); override;
  public
    g: real;
    MokonaN: byte;
    LastHited: TGameElement;
    constructor create(Owner: TComponent); override;
    destructor destroy; override; 
    Procedure ChangePic;
    Procedure Pounch;
    Procedure LeadMokona(arg: word);
    Procedure DoMokona(subdir: shortint);
    Procedure FreeStates;
    Procedure RenewState; override;
  published
    property vx: real read GetVX write SetVx;
    property vy: real read GetVy write SetVy;

    property health: integer read MokonasHealth write SetHealth;
    property pic: byte read CurPic write SetPic;
    property dir: shortint read DirectionOfMokonasView write SetDir;

    property IsSpeeding: boolean read GetIsSpeeding write SetIsSpeeding;
    property IsFalling: boolean read GetIsFalling write SetIsFalling;
    property IsDying: boolean read GetIsDying write SetIsDying;
    property IsStanding: boolean read GetIsStanding write SetIsStanding;
    property IsUnderControll: boolean read GetIsUnderControll write SetIsUnderControll;
  end;

implementation

var kostil:boolean;


Constructor TBattleMokona.create(Owner: TComponent);
var i: integer;
Begin
   inherited create(Owner);

   HealthBar:=THealthBar.Create(self);
   Health:=100;
   for i:=1 to RUNPICCOUNT do begin
     RunPictures[i]:=TBitmap.Create;
     RunPictures[i].LoadFromFile('Files\MokonaImages\a'+IntToStr(i)+'.bmp');
     RunPictures[i].Canvas.StretchDraw(Rect(0,0,Radius*2,Radius*2), RunPictures[i] );
     RunPictures[i].Width:=Radius*2;
     RunPictures[i].Height:=Radius*2;
   end;
   Picture.Bitmap:=RunPictures[2];
   Transparent:=true;
   MyCurrentFloor:=nil;

   vx:=0;
   vy:=0;
   top:= STARTY;

   IsStanding:=false;
   IsSpeeding:=false;
   IsFalling:=false;

   IsDying:=false;
   IsUnderControll:=true;

   Width:=radius*2;
   Height:=radius*2;

   DeltaX:=Width div 3;
   DeltaY:=Height * 5 div 14;

   DirectionOfMokonasView:=1;
end;


Procedure TBattleMokona.DoMokona(subdir: shortint);
begin
  dir:=subdir;
  IsSpeeding:= true;
end;

Procedure TBattleMokona.FreeStates;
Begin
   VseBooli:=0;
End;


Procedure TBattleMokona.BorderDefense;
Begin
      if (Left>=(Owner as TControl).Width-Width)
      or (Left<=0)
      then begin
         if Left>=(Owner as TControl).Width-Width then
            VX:=-abs(vx);
         if Left<=0 then
            VX:=abs(VX);

      end;
End;


Procedure TBattleMokona.RenewState;
var edgeL,edgeR: integer;
Begin
   inherited RenewState;
   vy:=vy+g;
   Left:=Left+round(Vx);
   Top:=Top+round(Vy);
   If IsStanding then begin
      if OnWhatStands is TMovingGameElement then begin
         Left:=Left-LastBoundX+OnWhatStands.Left;
         Top:=Top-LastBoundY+OnWhatStands.Top;
         LastBoundX:=OnWhatStands.Left;
         LastBoundY:=OnWhatStands.Top;
      end;
      edgeL:=OnWhatStands.Left;
      edgeR:=OnWhatStands.Left+OnWhatStands.Width;
      if OnWhatStands is TBattleMokona then begin
         edgeL:=edgeL+OnWhatStands.DeltaX;
         edgeR:=edgeR-OnWhatStands.DeltaX;
      end;
      If (Left+Width-DeltaX<edgeL) or (Left+DeltaX>EdgeR) then begin
         IsFalling:=True;
      end;
   end else begin   // IsFalling

   end;
   // ���������
   if (IsSpeeding) then
     if (vx<MAX_VX) and (vx>-MAX_VX) then vx:=vx+SHAG*dir;
   // ����������
   if not IsFalling then begin
      if abs(vx)>MAX_VX then (if vx>0 then Vx:=MAX_VX else Vx:=-Max_VX);
      if vx>0.5 then vx:=vx-BERZESSPEKS;
      if vx<-0.5 then vx:=vx+BERZESSPEKS;
   end;
   // �������������� ���������� ��������
   if vy<-Max_Vy then vy:=-Max_Vy;
   if vy>Max_Vy then vy:=max_vy;
   if vx>Max_Vx then vx:=Max_vx;
   if vx<-Max_Vx then vx:=-Max_vx;

   if not IsSpeeding then if (vx<=0.5) and (vx>=-0.5) then vx:=0;
   if Top>WinHeight
      then Destroy else
   If IsDying then if (Top<0-Height) then Destroy;
End;

Procedure TBattleMokona.LeadMokona(arg: word);
var subdir: shortint;
Begin
   if IsUnderControll = false then exit;
   if arg in [vk_right, VK_LEFT] then begin
     subdir:=1;
     case Arg of
        VK_Right: subdir:=1;
        VK_Left: subdir:=-1;
     end;
     DoMokona(subdir);
   end else
   if arg = VK_UP then if IsStanding then begin
      IsFalling:=true;
      vy:=-JUMP_STRENGTH;
   end;
End;

procedure TBattleMokona.Pounch;
Begin

end;

procedure TBattleMokona.SetDir(arg: shortint);
var i: integer;
Begin
   If DirectionOfMokonasView=arg then exit;
    for i:=1 to RUNPICCOUNT DO With RunPictures[i] do begin
      Canvas.StretchDraw(Rect(Point(Radius*2,0),Point(0,Radius*2)), RunPictures[i] );
    end;
   DirectionOfMokonasView:=arg;
end;

Procedure TBattleMokona.SetPic(arg: byte);
Begin
   Picture.BitMap:=RunPictures[arg];
   CurPic:=arg;
End;

Procedure TBattleMokona.SetHealth(arg: integer);
Begin
   MokonasHealth:=arg;
   HealthBar.UpdateValue(arg);
   If MokonasHealth<1
     then IsDying:=true;
end;

Procedure TBattleMokona.ChangePic;
Begin
   if   Pic=RUNPICCOUNT then pic:=2 else
   if   Pic=RUNPICCOUNT-1 then Pic:=1
   else Pic:=Pic+1;
end;

Destructor TBattleMokona.destroy;
var i: integer;
Begin
   HealthBar.Destroy;
   for i:=1 to RUNPICCOUNT do
     RunPictures[i].Destroy;
   with (Owner as TMokonalForm) do begin
      with LiveComponenti do
      If LiveComponenti.CurComponent = self
      then if self<>LiveComponenti.Last
           then LiveComponenti.CurComponent:=LiveComponenti[IndexOf(self)+1]
           else LiveComponenti.CurComponent:=nil;
      with vseComponenti do
      If vseComponenti.CurComponent = self
      then if self<>VseComponenti.Last
           then vseComponenti.CurComponent:=vseComponenti[IndexOf(self)+1]
           else VseComponenti.CurComponent:=nil;
      LiveComponenti.Remove(self);
      VseComponenti.Remove(self);
   end;
   (owner as TMokonalForm).Free(MokonaN);
   inherited destroy;
End;

Function TBattleMokona.GetVseBooli(arg: byte): boolean;
Begin
   result:=(power(2,arg) and VseBooli = power(2,arg));
End;

Procedure TBattleMokona.SetVseBooli(value: boolean; arg: byte);
Begin
   if value = true then VseBooli:=VseBooli or power(2,arg)
   else VseBooli:=VseBooli xor power(2,arg);
End;


Function TBattleMokona.GetIsSpeeding: boolean;
var Indexator: byte;
Begin
   indexator:=power(2,0);
   if (indexator and VseBooli = indexator) then result:=true else result:=false;
End;

Function TBattleMokona.GetIsFalling: boolean;
var Indexator: byte;
Begin
   indexator:=power(2,1);
   if indexator and VseBooli = indexator then result:=true else result:=false;
End;

Function TBattleMokona.GetIsJumping: boolean; 
var Indexator: byte;
Begin
   indexator:=power(2,4);
   if indexator and VseBooli = indexator then result:=true else result:=false;
End;

Function TBattleMokona.GetIsDying: boolean; 
var Indexator: byte;
Begin
   indexator:=power(2,5);
   if indexator and VseBooli = indexator then result:=true else result:=false;
End;

Function TBattleMokona.GetIsUnderControll: boolean;
var Indexator: byte;
Begin
   indexator:=power(2,6);
   if indexator and VseBooli = indexator then result:=true else result:=false;
End;

Function TBattleMokona.GetIsStanding: boolean;
var Indexator: byte;
Begin
   indexator:=power(2,7);
   if indexator and VseBooli = indexator then result:=true else result:=false;
End;

Procedure TBattleMokona.SetIsSpeeding(arg: boolean);
var indexator: byte;
Begin
   if arg=true then begin
   end;
   indexator:=0;
   if arg = true then VseBooli:=VseBooli or power(2,indexator)
   else VseBooli:=VseBooli and not(power(2,indexator));
End;

Procedure TBattleMokona.SetIsFalling(arg: boolean);
var indexator: byte;
Begin
   if arg=true then begin
      MyCurrentFloor:=nil;
      IsStanding:=False;
      g:=GG;
   end;
   indexator:=1;
   if arg = true then VseBooli:=VseBooli or power(2,indexator)
   else VseBooli:=VseBooli and not(power(2,indexator));
End;

Procedure TBattleMokona.SetIsJumping(arg: boolean);
var indexator: byte;
Begin
   if arg=true then IsStanding:=false;
   indexator:=4;
   if arg = true then VseBooli:=VseBooli or power(2,indexator)
   else VseBooli:=VseBooli and not(power(2,indexator));
End;

Procedure TBattleMokona.SetIsDying(arg: boolean);
var indexator: byte;
Begin
   if arg=true then begin
      FreeStates;
      IsUnderControll:=false;
      Vx:=0;
      Vy:=0;
      ConstVy:=-10;
   end;
   indexator:=5;
   if arg = true then VseBooli:=VseBooli or power(2,indexator)
   else VseBooli:=VseBooli and not(power(2,indexator));
End;

Procedure TBattleMokona.SetIsUnderControll(arg: boolean);
var indexator: byte;
Begin
   indexator:=6;
   if arg = true then VseBooli:=VseBooli or power(2,indexator)
   else VseBooli:=VseBooli and not(power(2,indexator));
End;

Procedure TBattleMokona.SetIsStanding(arg: boolean);
var indexator: byte;
Begin
   if arg=true then begin
      vy:=0;
      g:=0;
      IsFalling:=false;
   end;
   indexator:=7;
   if arg = true then VseBooli:=VseBooli or power(2,indexator)
   else VseBooli:=VseBooli and not(power(2,indexator));
End;

procedure TBattleMokona.SetVx(arg: real);
begin
   MyVx:=arg;
   if MyVx>Max_Vx then MyVx:=Max_Vx;
   if MyVx<-Max_Vx then MyVx:=-Max_Vx;
end;

procedure TBattleMokona.SetVy(arg: real);
begin
   if arg<>0 then IsFalling:=true;
   if arg=0 then if g=0 then IsFalling:=false;
   MyVy:=arg;
   if MyVy>Max_Vy then MyVy:=Max_Vy;
   if MyVy<-Max_Vy then MyVy:=-Max_Vy;
end;

function TBattleMokona.GetVx: real;
Begin
   result:= MyVx;
End;

function TBattleMokona.GetVy: real; 
Begin
   result:= MyVy;
End;

Procedure TBattleMokona.PutOn(where: TGameElement);
Begin
   inherited PutOn(where);
   isstanding:=true;
end;

end.
