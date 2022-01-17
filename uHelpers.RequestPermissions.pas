unit uHelpers.RequestPermissions;

interface

Uses
  System.SysUtils,
  FMX.Forms,
  FMX.Types
  {$IFDEF ANDROID}
  ,System.Permissions,
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes
  {$ENDIF}
  ;
type

  TRequestPermissions = class

  private

  public
  {$IFDEF ANDROID}
  Class Procedure READ_PHONE_NUMBERS(ToastMsg: string; Frm: TForm; Proc: TProc);
  Class Procedure  CAMERA(ToastMsg: string; Frm: TForm; Proc: TProc);
  Class Procedure  READ_WRITE_EXTERNAL_STORAGE(ToastMsg: string; Frm: TForm; Proc: TProc);

  {$ENDIF}
end;

implementation


  {$IFDEF ANDROID}
Class Procedure  TRequestPermissions.READ_PHONE_NUMBERS(ToastMsg: string; Frm: TForm; Proc:TProc);
Begin
  PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.READ_PHONE_NUMBERS)],
  procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
  begin

    if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
    Begin
      Proc;
    end
    Else
    begin
     if ToastMsg <> EmptyStr then
      Begin
      //THelpsAll.ToastMessage(Frm,ToastMsg,TAlignLayout.Bottom, $FFFA7D7D);
      End;
    end;

  end);

end;


Class Procedure TRequestPermissions.CAMERA(ToastMsg: string; Frm: TForm; Proc: TProc);
Begin

   PermissionsService.RequestPermissions ([JStringToString(TJManifest_permission.JavaClass.CAMERA)],
    procedure(const APermissions: TArray<string>;const AGrantResults: TArray<TPermissionStatus>)
    begin

      if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
      begin
       Proc;
      end
      else
      Begin
        if ToastMsg <> EmptyStr then
        Begin
       // THelpsAll.ToastMessage(Frm,ToastMsg,TAlignLayout.Bottom, $FFFA7D7D);
        End;
      End;

    end);

end;

Class Procedure TRequestPermissions.READ_WRITE_EXTERNAL_STORAGE(ToastMsg: string; Frm: TForm; Proc: TProc);
Begin

   PermissionsService.RequestPermissions ([JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
    procedure(const APermissions: TArray<string>;const AGrantResults: TArray<TPermissionStatus>)
    begin
      PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE)],nil);
      if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
      begin
        Proc;
      end
      else
      Begin
        if ToastMsg <> EmptyStr then
        Begin
       // THelpsAll.ToastMessage(Frm,ToastMsg,TAlignLayout.Bottom, $FFFA7D7D);
        End;
      End;

    end);

end;


{$ENDIF}

end.
