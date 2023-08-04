unit uHelpers.RequestPermissions;

interface

uses
  System.SysUtils,
  FMX.Forms,
  FMX.Types,
  System.Types,
  System.Permissions,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  FMX.Dialogs;

type
  TRequestPermissions = class
  public
    class procedure CAMERA(AMessage: string; AFrom: TForm; AProc: TProc);
    class procedure READ_WRITE_EXTERNAL_STORAGE(AMessage: string; AFrom: TForm; AProc: TProc);
  end;

implementation

class procedure TRequestPermissions.CAMERA(AMessage: string; AFrom: TForm; AProc: TProc);
begin
  PermissionsService.RequestPermissions
    ([JStringToString(TJManifest_permission.JavaClass.CAMERA)],
    procedure(const APermissions: TClassicStringDynArray;
      const AGrantResults: TClassicPermissionStatusDynArray)
    begin
      if (AGrantResults[0] = TPermissionStatus.Granted) then
      begin
        AProc;
      end
      else
      begin
        //THelpsAll.ToastMessage(Frm,ToastMsg,TAlignLayout.Bottom, $FFFA7D7D);
      end;
    end);
end;

class procedure TRequestPermissions.READ_WRITE_EXTERNAL_STORAGE(AMessage: string; AFrom: TForm; AProc: TProc);
begin
  PermissionsService.RequestPermissions
    ([JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
    JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
    procedure(const APermissions: TClassicStringDynArray;
      const AGrantResults: TClassicPermissionStatusDynArray)
    begin
      if (Length(AGrantResults) = 2) and
        (AGrantResults[0] = TPermissionStatus.Granted) and
        (AGrantResults[1] = TPermissionStatus.Granted) then
      begin
        AProc;
      end
      else
      begin
        //THelpsAll.ToastMessage(Frm,ToastMsg,TAlignLayout.Bottom, $FFFA7D7D);
      end;
    end);
end;

end.

