program MokonaBattleServerUnit;

uses
  Forms,
  MoconalCombat in 'MoconalCombat.pas' {Form1},
  VsyakijMusorUnit in 'VsyakijMusorUnit.pas',
  TBattleMokonaUnit in 'TBattleMokonaUnit.pas',
  MainUnit in 'MainUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
