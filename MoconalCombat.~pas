unit MoconalCombat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, ExtCtrls, MMSystem, StdCtrls, Buttons, Contnrs, VsyakijMusorUnit,
  MainUnit, TBattleMokonaUnit, PNGImage,
  ComCtrls;


type

  TForm1 = class(TMokonalForm)
    ServerSocket1: TServerSocket;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    P2Health: TLabel;
    Label20: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
  protected
    Procedure Provzaimodejstvovatj;
  public
    Floor: TGameElement;
    Platforma: TMovingGameElement;
    Camera: TCamera;
    Function Soprikasayutsya(C1,C2: TGameElement): boolean;
    Procedure Free(arg:integer); override;
    { Public declarations }
  end;

var
  tt: integer;

  IsServer: boolean;
  RunPressed: boolean;

  Form1: TForm1;
  Player: array [1..2] of TBattleMokona;
  kbrdblocked: boolean;

  kostil: boolean;

  counter: integer;
  jumpcounter: integer;
  MouseFloor: TMovingGameElement;
  initialized: boolean;

  curelement: TGameElement;

  Floor2: TGameElement;
implementation

{$R *.dfm}

Function TForm1.Soprikasayutsya(C1,C2: TGameElement): boolean;
var rect1,rect2: TRect;
Begin
   Rect1:=rect(c1.Left+c1.DeltaX+1, c1.Top+c1.DeltaY+10, c1.Left+c1.Width-c1.DeltaX-1, c1.Top+c1.Height);
   Rect2:=rect(c2.Left+c2.DeltaX+1, c2.Top+c2.DeltaY+10, c2.Left+c2.Width-c2.DeltaX-1, c2.Top+c2.Height);
   if c1 is TBattleMokona then
      if (c1 as TBattleMokona).IsDying then begin
         result:=false;
         exit;
      end;
   if c2 is TBattleMokona then
      if (c2 as TBattleMokona).IsDying then begin
         result:=false;
         exit;
      end;
    result:=IsRectInRect(Rect1, Rect2);
End;


procedure TForm1.FormCreate(Sender: TObject);
begin
   FIRSTHPBAR_CREATED:=false;
   Initialized:=false;
   WinWidth:=Screen.Width;
   WinHeight:=Screen.Height;
   RADIUS:= 50;
   FLOORPOS:= WINHEIGHT - WINHEIGHT div 7;
   STARTY:= FLOORPOS - RADIUS*2 + RADIUS div 7;
   STARTX_White:= WINWIDTH div 4 - RADIUS;
   STARTX_BLACK:= WINWIDTH - WINWIDTH div 4 - RADIUS;

   Self.Width:= WINWIDTH;
   Self.Height:= WINHEIGHT;
   Self.Left:= WINRIGHT;
   Self.Top:= WINTOP;

   runpressed:=false;
   isserver:=true;
   kostil:=true;

   VseComponenti:= TGameElementList.Create;
   VseComponenti.OwnsObjects:=false;
   LiveComponenti:= TGameElementList.Create;
   Camera:= TCamera.Create(Self);
   Camera.x:=WinWidth div 2;
   Camera.y:=WinHeight div 2;

   Floor:=TGameElement.Create(self);
   Floor.Width:=600;
   Floor2:=TGameElement.create(self);
   Floor2.Width:=600;
   Floor2.Left:=WinWidth-600;
   MouseFloor:=TMovingGameElement.Create(self);
   MouseFloor.Width:=0;

   Platforma:=TMovingGameElement.create(self);
   Platforma.ConstVx:=3;
   Platforma.Top:=FloorPos-200;

   Player[1]:= TBattleMokona.Create(self);
   Player[1].MokonaN:=1;
   Player[1].OnWhatStands:=Floor;
   Player[1].Left:=STARTX_White;
   Player[2]:= TBattleMokona.Create(self);
   Player[2].MokonaN:=2;
   Player[2].OnWhatStands:=Floor;
   Player[2].Left:=STARTX_Black;

   With Player[1] do begin
      left:= STARTX_White;
      dir:=1;
      brush.Color:=16*16*16*16*16*16-1;
   end;
   With Player[2] do begin
      left:= STARTX_Black;
      dir:=-1;
      brush.Color:=0;
   end;
   Initialized:=true;
end;

Procedure TForm1.Provzaimodejstvovatj;
var i1,i2,n1,ncount: integer;
    Booli: array [1..255] of boolean;
    obyekt,ObSubyekt: TGameElement;
    Subyekt,SubObyekt: TPhisics;
    //MokoByekt,MosuByekt: TBattleMokona;
    sub: real;
    way: shortint;
Begin
   for i1:=0 to VseComponenti.count-1 do Booli[i1]:=false;
      For i1:=0 to LiveComponenti.count-1 do begin
         if LiveComponenti[i1] is TPhisics then Subyekt:=(LiveComponenti[i1] as TPhisics) else continue;
         Label20.Caption:=IntToStr(VseComponenti.count);
         For i2:=0 to VseComponenti.count-1 do begin
            Obyekt:=(VseComponenti[i2] as TGameElement);
            if Subyekt=Obyekt then begin
               Booli[VseComponenti.IndexOf(Obyekt)]:=true;
               continue;
            end;
            if not Soprikasayutsya(Subyekt,Obyekt) then continue;
            if Booli[VseComponenti.IndexOf(Obyekt)] then continue;

            // Отсюда начинаем, что произойдёт от их взаимодействия

            SubObyekt:=Subyekt;
            ObSubyekt:=Obyekt;
            ncount:=1;
            if ObSubyekt is TPhisics then ncount:=2;
            for n1:=1 to ncount do begin
               with SubObyekt do begin
                  if SubObyekt.VisheCem(ObSubyekt) then begin
                     sub:=SubObyekt.VY;
                     SubObyekt.Vy:=ObSubyekt.Vy*0.5 - SubObyekt.Vy*0.5;
                     ObSubyekt.VY:=sub*0.5 - ObSubyekt.VY*0.5;
                     If ObSubyekt is TBattleMokona then with (ObSubyekt as TBattleMokona) do begin
                        Health:=Health-round(sqrt(sqr(Subyekt.VX)+sqr(Subyekt.VY)));
                        If abs(SubObyekt.Vy)<2 then
                           if Health>0 then SubObyekt.OnWhatStands:=ObSubyekt;
                     end else begin
                        SubObyekt.OnWhatStands:=ObSubyekt;
                     end;
                  end else begin
                     way:=Subyekt.Left-Obyekt.Left;
                     if way<>0 then way:=way div abs(way);
                     sub:=abs(Subyekt.VX-Obyekt.VX);
                     Subyekt.VX:=Subyekt.VX+way*(sub)*0.5;
                     Obyekt.VX:=Obyekt.Vx-way*sub*0.5;

                     if obyekt<>nil then if Obyekt.VisheCem(subyekt) then subyekt.VY:=5;
                  end;
               end;
               if ncount>=2 then SubObyekt:=(Obyekt as TPhisics);
               ObSubyekt:=Subyekt;
            end;

         end;
      end;

End;



procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
begin
   if key=VK_SPace then begin
      label5.Caption:='asfsa';
      for i:=1 to 2 do if player[i]=nil then begin
         Player[i]:= TBattleMokona.Create(self);
         Player[i].MokonaN:=i;
         Player[i].Top:=-radius*2;
         Player[i].IsFalling:=true;
         Player[i].Left:=i*WinWidth div 2-winwidth div 4;
      end;
   end;
   if kbrdblocked then exit;
   if Key in [VK_RIGHT, VK_LEFT] then begin
      if runpressed then exit;
      runpressed:=true;
   end;
   if Player[1]<>nil then Player[1].LeadMokona(Key);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if player[1]=nil then exit;
   if Key in [VK_RIGHT, VK_LEFT] then begin
     RunPressed:=false;
     player[1].isspeeding:=false;
   end;
end;
procedure TForm1.Timer1Timer(Sender: TObject);
var cm: integer;
    i1,i2: integer;
    CurLiver: TGameElement;

    LC: integer;
    p: tpoint;
begin
 if tt>4000000 then tt:=0;
 inc(tt);
 if tt mod 10=0 then begin
    if floor.width>20 then floor.Width:=floor.width-1;
    if floor2.Left<winwidth-20 then floor2.left:=floor2.left+1;
 end;
 label5.Caption:=inttostr(tt);
 GetCursorPos(P);
 MouseFloor.Left:=P.X;
 MouseFloor.Top:=P.y-30;
 LiveComponenti.CurComponent:=(LiveComponenti.first as TGameElement);
 with LiveComponenti do
 while curComponent<>nil do begin
   if CurComponent is TBattleMokona then begin
    cm:=(CurComponent as TBattleMokona).MokonaN;
    with Player[cm] do begin
      if ((not IsFalling) and (not IsSpeeding))
        then if pic<>2 then pic:=2;

      // Смена картинок бега
      if not IsFalling then begin
        if vx=0 then counter:=0;
        inc(counter);
        if counter = 4360033 then counter:=0;
        if counter*abs(round(vx))>=cisloG*Radius div 175 then BEGIN
           ChangePic; counter:=0;
        end;
      end else if pic<>12 then pic:=12;

    end;
   end; // If curComponent is tbattlemokona
   Provzaimodejstvovatj;
   if CurComponent is TMovingGameElement then with CurComponent as TMovingGameElement  do begin
      renewstate;
      if CurComponent = nil then break;
   end;
  with LiveComponenti do if curComponent<>last then CurComponent :=(LiveComponenti[IndexOf(CurComponent)+1] as TGameElement)
                         else break;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   VseComponenti.OwnsObjects:=true;
   VseComponenti.Clear;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   Label2.Visible:=false;
   Label3.Font.Color:=16*16*16*16-16*16;
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   Label2.Visible:=true;
   Label2.Caption:='Dis';
   Label3.Font.Color:=16*16*16*16-1;
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var s: word;
    sub: string[30];
begin
   if player[2] = nil then exit;
   sub:=Socket.ReceiveText;
   s:= strtoint(Sub);
   if not player[2].IsUnderControll then exit;
      if s in [VK_LEFT, VK_RIGHT, VK_UP, VK_SPACE] then Player[2].LeadMokona(S);
   if s=VK_RELEASE then begin
        label5.Caption:='Release';
        with Player[2] do begin
        isspeeding:=false;
	 end;
   end;
end;

Procedure TForm1.Free(arg: integer);
Begin
   Player[arg]:=nil;
End;

end.

