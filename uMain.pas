unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Media, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.ExtCtrls, FMX.Effects, FMX.Ani;

type
  TFrmMain = class(TForm)
    imgCameraView: TImage;
    TabCon: TTabControl;
    TabCamera: TTabItem;
    TabPreviewImage: TTabItem;
    CameraComponent: TCameraComponent;
    Layout1: TLayout;
    Layout2: TLayout;
    ImgCapture: TImage;
    BtnGetFile: TImage;
    BtnToggle: TImage;
    Rectangle1: TRectangle;
    Rectangle3: TRectangle;
    ImageViewer1: TImageViewer;
    ImgPreview: TImage;
    RectCrop: TRectangle;
    Layout3: TLayout;
    ImgZoomOut: TImage;
    Layout4: TLayout;
    ImgZoomIN: TImage;
    BtnBack: TSpeedButton;
    Image10: TImage;
    ShadowEffect2: TShadowEffect;
    TabProfile: TTabItem;
    Layout5: TLayout;
    Rectangle2: TRectangle;
    Circle1: TCircle;
    Text1: TText;
    Layout6: TLayout;
    Text2: TText;
    Text3: TText;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    ShadowEffect5: TShadowEffect;
    Layout7: TLayout;
    Text4: TText;
    GridPanelLayout1: TGridPanelLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    Text8: TText;
    Text9: TText;
    Text10: TText;
    Rectangle8: TRectangle;
    Layout11: TLayout;
    Rectangle9: TRectangle;
    Text11: TText;
    Text12: TText;
    Line1: TLine;
    ShadowEffect3: TShadowEffect;
    Rectangle10: TRectangle;
    BtnRotation: TSpeedButton;
    Image1: TImage;
    ShadowEffect6: TShadowEffect;
    BtnFinish: TSpeedButton;
    ImgFinish: TImage;
    ShadowEffect7: TShadowEffect;
    procedure CameraComponentSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure DisplayCameraPreviewFrame;
    Procedure StartCamera;
    procedure BtnToggleClick(Sender: TObject);
    procedure BtnGetFileClick(Sender: TObject);
    Procedure FinishUpload;
    procedure ImgCaptureClick(Sender: TObject);
    procedure RectCropMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure RectCropMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure RectCropMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ImgZoomINClick(Sender: TObject);
    procedure ImgZoomOutClick(Sender: TObject);
    procedure BtnRotation1Click(Sender: TObject);
    procedure BtnBackClick(Sender: TObject);
    Procedure CropImg(Img: TImage; ImgRes: TCircle);
    procedure Circle1Click(Sender: TObject);
    Procedure PermissionStorage;
    procedure BtnFinishClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  Inaction: Boolean = False;

implementation

{$R *.fmx}

uses uHelpers.RequestPermissions, uHelpers.JavaTypes;

Procedure TFrmMain.CropImg(Img: TImage; ImgRes: TCircle);
var
  LBmp: TBitmap;
  xScale, yScale: extended;
  LRect: TRect;
  OffsetX, OffsetY: extended;
begin

  LBmp := TBitmap.Create;
  try
    xScale := Img.Bitmap.Width / Img.Width;
    yScale := Img.Bitmap.Height / Img.Height;

    if xScale > yScale then
      yScale := xScale
    else
      xScale := yScale;

    LBmp.Width := round(RectCrop.Width * xScale);
    LBmp.Height := round(RectCrop.Height * yScale);
    OffsetX := (Img.Width - Img.Bitmap.Width / xScale) / 2;
    OffsetY := (Img.Height - Img.Bitmap.Height / yScale) / 2;

    LRect.Left := round((RectCrop.Position.X - OffsetX) * xScale);
    LRect.Top := round((RectCrop.Position.Y - OffsetY) * yScale);
    LRect.Width := round(RectCrop.Width * xScale);
    LRect.Height := round(RectCrop.Height * yScale);

    if LRect.Left < 0 then
      LRect.Left := 0;
    if LRect.Top < 0 then
      LRect.Top := 0;
    if LRect.Width < 1 then
      LRect.Width := 1;
    if LRect.Height > (LBmp.Height - 1) then
      LRect.Height := LBmp.Height;

    LBmp.CopyFromBitmap(Img.Bitmap, LRect, 0, 0);
    ImgRes.Fill.Bitmap.Bitmap.Clear(0);
    ImgRes.Fill.Bitmap.Bitmap := LBmp;

  finally
    FreeAndNil(LBmp);
  end;
End;

procedure TFrmMain.BtnFinishClick(Sender: TObject);
begin
  CropImg(ImgPreview, Circle1);
  ImgPreview.Bitmap.Clear(0);
  TabCon.GotoVisibleTab(0);
end;

Procedure TFrmMain.StartCamera;
begin
  TabCon.GotoVisibleTab(1);
  CameraComponent.Active := True;
  CameraComponent.FocusMode := TFocusMode.ContinuousAutoFocus;
end;

Procedure TFrmMain.PermissionStorage;
Begin
{$IFDEF ANDROID}
  TRequestPermissions.READ_WRITE_EXTERNAL_STORAGE('', FrmMain, StartCamera);
{$ENDIF}
end;

procedure TFrmMain.CameraComponentSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, DisplayCameraPreviewFrame);
end;

procedure TFrmMain.Circle1Click(Sender: TObject);
begin
  TRequestPermissions.CAMERA('Unfortunately we cannot carry a camera.', FrmMain,
    PermissionStorage);
end;

procedure TFrmMain.DisplayCameraPreviewFrame;
begin
  CameraComponent.SampleBufferToBitmap(imgCameraView.Bitmap, True);
end;

procedure TFrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Inaction := False;
end;

procedure TFrmMain.ImgCaptureClick(Sender: TObject);
begin
  CameraComponent.SampleBufferToBitmap(ImgPreview.Bitmap, True);
  TabCon.GotoVisibleTab(2);
end;

procedure TFrmMain.ImgZoomINClick(Sender: TObject);
begin
  RectCrop.Height := RectCrop.Height + 25;
  RectCrop.Width := RectCrop.Width + 25;
end;

procedure TFrmMain.ImgZoomOutClick(Sender: TObject);
begin
  RectCrop.Height := RectCrop.Height - 25;
  RectCrop.Width := RectCrop.Width - 25;
end;

procedure TFrmMain.RectCropMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Inaction := True;
end;

procedure TFrmMain.RectCropMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if Inaction then
  begin
    (Sender as TRectangle).Position.X := (Sender as TRectangle).Position.X + X -
      ((Sender as TRectangle).Width / 2);
    (Sender as TRectangle).Position.Y := (Sender as TRectangle).Position.Y + Y -
      ((Sender as TRectangle).Height / 2);
  end;
end;

procedure TFrmMain.RectCropMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Inaction := False;
end;

Procedure TFrmMain.FinishUpload;
begin
  TabCon.ActiveTab := TabPreviewImage;
end;

procedure TFrmMain.BtnBackClick(Sender: TObject);
begin
  TabCon.GotoVisibleTab(1);
end;

procedure TFrmMain.BtnGetFileClick(Sender: TObject);
begin
  THelpsJavaTypes.GetImgToIntent(ImgPreview.Bitmap, FinishUpload);
end;

procedure TFrmMain.BtnRotation1Click(Sender: TObject);
var
  LBmp: TBitmap;

  procedure RotateImage;
  begin
    if Image1.RotationAngle = 360 then
      TAnimator.AnimateFloat(Image1, 'RotationAngle', 0)
    else
      TAnimator.AnimateFloat(Image1, 'RotationAngle',
        Image1.RotationAngle + 90);
  end;

begin
  RotateImage;

  if not Assigned(ImgPreview.Bitmap) then
    Exit;

  ImgPreview.Bitmap.Rotate(90);
end;

procedure TFrmMain.BtnToggleClick(Sender: TObject);
begin
  if TImage(Sender).Tag = 0 then
  begin
    CameraComponent.Kind := TCameraKind.FrontCamera;
    TImage(Sender).Tag := 1;
    Exit;
  end;

  if TImage(Sender).Tag = 1 then
  begin
    CameraComponent.Kind := TCameraKind.BackCamera;
    TImage(Sender).Tag := 0;
    Exit;
  end;
end;

end.
