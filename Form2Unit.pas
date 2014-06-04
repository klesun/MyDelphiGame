unit Form2Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, MoconalCombat;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
   (Parent as TForm1).ClientSocket1.Address:=Edit1.Text;
   (Parent as TForm1).ClientSocket1.Open;
end;

end.
