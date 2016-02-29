program Project1;

uses
  Vcl.Forms,
  EAN in 'EAN.pas' {Form1},
  CplxMtrxI in 'CplxMtrxI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
