unit uHelpers.JavaTypes;

interface

uses
  FMX.Graphics,
  System.SysUtils,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  System.Messaging,
  Androidapi.JNI.App,
  FMX.Surfaces,
  FMX.Helpers.Android;

type
  THelpsJavaTypes = class
  private
    class var MessageSubscriptionID: Integer;
    class var BitmapResult: TBitmap;
    class var ProcFinishHandle: TProc;
    class procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);
  public
    class procedure GetImgToIntent(TImage: TBitmap; ProcFinish: TProc);
  end;

implementation

const
  REQUEST_CODE_VALUE: Integer = 2345;

class procedure THelpsJavaTypes.GetImgToIntent(TImage: TBitmap; ProcFinish: TProc);
var
  Intent: JIntent;
begin
  BitmapResult := TImage;
  ProcFinishHandle := ProcFinish;
  MessageSubscriptionID := TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, HandleActivityMessage);
  Intent := TJIntent.JavaClass.init;
  Intent.setType(StringToJString('image/*'));
  Intent.setAction(TJIntent.JavaClass.ACTION_GET_CONTENT);
  Intent.setPackage(StringToJString('com.google.android.apps.photos'));
  TAndroidHelper.Activity.startActivityForResult(Intent, REQUEST_CODE_VALUE);
  { Nos casos a seguir, selecione no aplicativo que lida com fotos Intent.setAction(TJIntent.JavaClass.ACTION_PICK);}
end;

class procedure THelpsJavaTypes.HandleActivityMessage(const Sender: TObject; const M: TMessage);
var
  RequestCode, ResultCode: Integer;
  Data: JIntent;
  InputStream: JInputStream;
  JavaBitmap: JBitmap;
  BitmapSurface: TBitmapSurface;
begin
  try
    if M is TMessageResultNotification then
    begin
      RequestCode := TMessageResultNotification(M).RequestCode;
      ResultCode := TMessageResultNotification(M).ResultCode;
      Data := TMessageResultNotification(M).Value;

      // Liberar manipulador de mensagem
      TMessageManager.DefaultManager.Unsubscribe(
        TMessageResultNotification, MessageSubscriptionID);

      // Com o código de solicitação passado / Se o código de solicitação de retorno corresponder
      if RequestCode = REQUEST_CODE_VALUE then
      begin
        if ResultCode = TJActivity.JavaClass.RESULT_OK then
        begin
          if Assigned(Data) then
          begin
            InputStream := TAndroidHelper.Activity.getContentResolver.openInputStream(Data.getData);
            // Converter para formato Java Bitmap
            JavaBitmap := TJBitmapFactory.JavaClass.decodeStream(InputStream);
            // Converter do formato Java Bitmap para BitmapSurface
            BitmapSurface := TBitmapSurface.Create;
            JBitmapToSurface(JavaBitmap, BitmapSurface);
            //Image1.Bitmap.Assign(BitmapSurface);
            BitmapResult.Assign(BitmapSurface);
            ProcFinishHandle;
          end;
        end;
      end;
    end;
  except
    //as vezes quando a imagem esta danificada o aplicativo
    //não consegue processar e fecha, esse try e exatamente para isso
    //se a img estiver imperfeita cai aqui.
  end;
end;

end.

