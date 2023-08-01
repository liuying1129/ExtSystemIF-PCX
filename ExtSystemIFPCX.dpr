program ExtSystemIFPCX;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  superobject in 'superobject.pas',
  UfrmRequestInfo in 'UfrmRequestInfo.pas' {frmRequestInfo},
  UfrmLogin in 'UfrmLogin.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
