program CameraManager;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {FrmMain},
  uHelpers.RequestPermissions in 'uHelpers.RequestPermissions.pas',
  uHelpers.JavaTypes in 'uHelpers.JavaTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
