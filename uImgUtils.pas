unit uImgUtils;

interface

uses
 Types, Windows, Graphics, ImagingClasses, ImagingTypes, Imaging, ImagingComponents,
 ImagingCanvases, ImagingUtility, SysUtils, JclMiscel, gnugettext;

procedure DisplayTransparentImage(DstCanvas: TCanvas; const DstRect: TRect; Image: TBaseImage; Filter: TResizeFilter=rfNearest);
function CenterRect(InnerRect, OuterRect: TRect): TRect;
function RectWidth(ARect: TRect): Integer;
function RectHeight(ARect: TRect): Integer;
function LoadImageFromDisk(fName:TFileName;FixColors:boolean):TSingleImage;
procedure OptimizeImg(fName: TFileName);

implementation

procedure DisplayTransparentImage(DstCanvas: TCanvas; const DstRect: TRect; Image: TBaseImage; Filter: TResizeFilter=rfNearest);
var
 Background:TBitmap;
 BackImage,BackImage2:TSingleImage;
 Canvas,BackCanvas:TImagingCanvas;
 R:TRect;
begin
 if DstRect.Right-DstRect.Left=0 then Exit;
 if DstRect.Bottom-DstRect.Top=0 then Exit;
 Background:=TBitmap.Create;
 with Background do begin
  PixelFormat:=pf24bit;
  Transparent:=false;
  Width:=DstRect.Right-DstRect.Left;
  Height:=DstRect.Bottom-DstRect.Top;
  Canvas.Brush.Color:=clRed;
  Canvas.Brush.Style:=bsSolid;
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.CopyRect(Canvas.ClipRect,DstCanvas,DstRect);
 end;
 BackImage:=TSingleImage.CreateFromParams(DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,ifA8R8G8B8);
 BackImage2:=TSingleImage.CreateFromParams(DstRect.Right-DstRect.Left,DstRect.Bottom-DstRect.Top,ifR8G8B8);
 ConvertBitmapToImage(Background,BackImage2);
 BackImage2.Format:=ifR8G8B8;
 BackCanvas:=TImagingCanvas.CreateForImage(BackImage);
 Canvas:=TImagingCanvas.CreateForImage(BackImage2);
 Canvas.DrawAlpha(BackImage2.BoundsRect,BackCanvas,0,0);
 BackImage.Format:=ifA8R8G8B8;
 FreeAndNil(Canvas);
 FreeAndNil(BackImage2);
 R:=ScaleRectToRect(Image.BoundsRect,BackImage.BoundsRect);
 Image.Format:=ifA8R8G8B8;
 Canvas:=TImagingCanvas.CreateForImage(Image);
 Canvas.StretchDrawAlpha(Image.BoundsRect, BackCanvas, R, Filter);
 DisplayImage(DstCanvas, DstRect, BackImage);
 FreeAndNil(Canvas);
 FreeAndNil(BackCanvas);
 FreeAndNil(BackImage);
 FreeAndNil(Background);
end;

function CenterRect(InnerRect, OuterRect: TRect): TRect;
begin
  OffsetRect(InnerRect, -InnerRect.Left + OuterRect.Left + (RectWidth(OuterRect) - RectWidth(InnerRect)) div 2,
    -InnerRect.Top + OuterRect.Top + (RectHeight(OuterRect) - RectHeight(InnerRect)) div 2);
  Result := InnerRect;
end;

function RectHeight(ARect: TRect): Integer;
begin
 Result := ARect.Bottom - ARect.Top;
end;

function RectWidth(ARect: TRect): Integer;
begin
 Result := ARect.Right - ARect.Left;
end;

function LoadImageFromDisk(fName:TFileName;FixColors:boolean):TSingleImage;
begin
 Result:=TSingleImage.CreateFromFile(fName);
 Result.SwapChannels(ChannelRed,ChannelBlue);
end;

procedure OptimizeImg(fName: TFileName);
var
 path,name,tmpcDir,outStr:string;
 exCode:Cardinal;
 appd:string;
begin
 path:=ExtractFilePath(fName);
 name:=ExtractFileName(fName);
 tmpcDir:=GetCurrentDir;
 SetCurrentDir(path);
 appd:=ExtractFilePath(ParamStr(0));
// ExtractPNGout(path);
// exCode:=WinExec32AndRedirectOutput('pngout.exe /y /d0 '+name,outStr);
 //Now try PngOptimizerCL.exe
 exCode:=WinExec32AndRedirectOutput(appd+'PngOptimizerCL.exe -file:"'+name+'"',outStr);
 if exCode<>1 then begin
  MessageBox(0, PAnsiChar(AnsiString(_('Error while optimizing image!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr)), PChar(AnsiString(_('Error!'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
 exCode:=WinExec32AndRedirectOutput(appd+'optipng.exe -o7 -i0 '+name,outStr);
 if exCode<>0 then begin
  MessageBox(0, PAnsiChar(AnsiString(_('Error while optimizing image!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr)), PChar(AnsiString(_('Error!'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
// WinExec32AndWait('pngout.exe /y /d0 /q '+name,SW_HIDE);
// DeleteFile('pngout.exe');
 SetCurrentDir(tmpcDir);
end;

end.
