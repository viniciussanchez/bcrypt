program Samples;

uses
  Vcl.Forms,
  Samples.Main in 'src\Samples.Main.pas' {FrmSamples},
  BCrypt.Core in '..\src\BCrypt.Core.pas',
  BCrypt.Intf in '..\src\BCrypt.Intf.pas',
  BCrypt.Types in '..\src\BCrypt.Types.pas',
  BCrypt.Consts in '..\src\BCrypt.Consts.pas',
  BCrypt in '..\src\BCrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmSamples, FrmSamples);
  Application.Run;
end.
