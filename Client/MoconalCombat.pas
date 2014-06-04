unit MoconalCombat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, ExtCtrls, MMSystem, StdCtrls, Buttons, Contnrs,
  ComCtrls;

const VK_Release = 999;

type

  TForm2 = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Constructor Create(owner: TComponent); override;
    Destructor Destroy; override;
    procedure ClosePlease;
    { Public declarations }
  end;

  TForm1 = class(TForm)
    Timer1: TTimer;
    ClientSocket1: TClientSocket;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  public
    Form2: TForm2;
    { Public declarations }
  end;

var
  Form1: TForm1;
  WinWidth,WinHeight: integer;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
   WinWidth:=Screen.Width;
   WinHeight:=Screen.Height;

   Self.Width:= WINWIDTH;
   Self.Height:= WINHEIGHT;
   Self.Left:=0;
   Self.Top:=0;

   Form2:=TForm2.Create(self);
   Form2.Parent:=self.parent;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key in [VK_RIGHT, VK_LEFT, VK_UP] then
      ClientSocket1.Socket.SendText(IntToStr(Key));
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key in [VK_RIGHT, VK_LEFT] then
        ClientSocket1.Socket.SendText(IntToStr(VK_RELEASE));
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   Label2.Visible:=false;
   Label3.Font.Color:=16*16*16*16-16*16;
   Form2.closeplease;
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
begin
   s:= strtoint(Socket.ReceiveText);
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
   //exit;
   Form1.ClientSocket1.Address:=Edit1.Text;
   Form1.ClientSocket1.Open;
   Form1.Label2.Caption:='is';
   Form1.Label3.Caption:='you';
   close;
end;

Procedure TForm2.ClosePlease;
Begin
   close;
End;

constructor TForm2.Create(owner: TComponent);
Begin
   inherited create(owner);
   visible:=true;
   width:=400;
   height:=100;
   left:=0;
   top:=0;
   Edit1:= TEdit.Create(Self);
   Edit1.parent:=self;
   Edit1.Width:=200;
   Edit1.Text:='192.168.0.222';

end;

Destructor TForm2.Destroy;
Begin
   Edit1.Destroy;
   BitBtn1.Destroy;
   inherited Destroy;
end;

end.

