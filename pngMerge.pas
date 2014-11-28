unit pngMerge;

interface

uses windows, types, pngimage, graphics;

procedure OverlayPNG(SourcePNG, OverlayPNG: TPNGObject; OverlayPosition: TPoint; OverlayOpacity: Byte; out Dest: TPNGObject);

implementation

procedure OverlayPNG(SourcePNG, OverlayPNG: TPNGObject; OverlayPosition: TPoint; OverlayOpacity: Byte; out Dest: TPNGObject);

  function CreatePNG(Width, Height: Integer): TPNGObject;
  var
     Bitmap: TBitmap;
  begin
  //Just create an empty PNG object (always RGBA)
  Result := TPNGObject.Create;
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Width;
    Bitmap.Height := Height;
    Bitmap.PixelFormat := pf24bit;
    Result.Assign(Bitmap);
    Result.CreateAlpha;
  finally
    Bitmap.Free;
   end;
  end;
 
  function CombineColors(Source, Overlay: TColor; Alpha, Opacity: Byte): TColor;
  var
     TotalOpacity: Integer;
  begin
  //If complete opacity, return the overlay color; if complete transparency, return source color
  if Opacity = 255
  then Result := Overlay
  else if Opacity = 0
  then Result := Source
  else begin
       //If source and overlay alphas are both zero, returned color doesn't matter
       TotalOpacity := Alpha + Opacity;
       if TotalOpacity = 0
       then Result := clBlack
       else begin
            //Combine the two color by sort of interpolating between their alpha values
            Result := RGB(
               ((Source and $FF)        * Alpha + (Overlay and $FF)        * Opacity) div TotalOpacity,
               ((Source shr 8 and $FF)  * Alpha + (Overlay shr 8 and $FF)  * Opacity) div TotalOpacity,
               ((Source shr 16 and $FF) * Alpha + (Overlay shr 16 and $FF) * Opacity) div TotalOpacity);
            end;
       end;
  end;
 
  //You might wanna define these two small functions as inline if you have Delphi 2005 or higher.
 
  function AlphaWithOpacity(Alpha, Opacity: Byte): Byte;
  begin
  //Combine an alpha value with an opacity
  Result := 255 - (255 - Alpha) * Opacity div 255;
  end;
 
  function CombineAlphas(Source, Overlay: Byte): Byte;
  begin
  //Overlay one alpha over another
  Result := Source + (255 - Source) * Overlay div 255;
  end;
 
var
   SourceX, SourceY, OverlayX, OverlayY: Integer;
   SourceHasAlpha, OverlayHasAlpha, InOverlayY: Boolean;
   SourceTransColor, SourceColor, OverlayTransColor, OverlayColor: TColor;
   SourceAlphaLine, OverlayAlphaLine, DestAlphaLine: PByteArray;
   SourceAlpha, OverlayAlpha: Byte;
begin
//Initialize some variables
SourceHasAlpha := SourcePNG.Header.ColorType in [COLOR_GRAYSCALEALPHA, COLOR_RGBALPHA];
OverlayHasAlpha := SourcePNG.Header.ColorType in [COLOR_GRAYSCALEALPHA, COLOR_RGBALPHA];
OverlayY := 0;
 
//Determine transparency colors, if no alpha channel
if SourcePNG.TransparencyMode = ptmBit
then SourceTransColor := SourcePNG.TransparentColor
else SourceTransColor := clNone;
if OverlayPNG.TransparencyMode = ptmBit
then OverlayTransColor := OverlayPNG.TransparentColor
else OverlayTransColor := clNone;
 
//Create destination PNG (always RGBA)
Dest := CreatePNG(SourcePNG.Width, SourcePNG.Height);
 
for SourceY := 0 to SourcePNG.Height - 1
do begin
   //If the source has an alpha channel, get its scanline
   if SourceHasAlpha
   then SourceAlphaLine := PByteArray(SourcePNG.AlphaScanline[SourceY])
   else SourceAlphaLine := nil;

   //Determine position in overlay image, and its alpha scanline
   InOverlayY := (SourceY >= OverlayPosition.Y) and (SourceY <= OverlayPosition.Y + OverlayPNG.Height);
   if InOverlayY
   then begin
        OverlayY := SourceY - OverlayPosition.Y;
        if OverlayHasAlpha
        then OverlayAlphaLine := PByteArray(OverlayPNG.AlphaScanline[OverlayY])
        else OverlayAlphaLine := nil;
        end;
 
   //Get destination alpha scanline, which should always be there
   DestAlphaLine := PByteArray(Dest.AlphaScanLine[SourceY]);
 
   for SourceX := 0 to SourcePNG.Width - 1
   do begin
      //Get color and alpha from source image at current position
      SourceColor := ColorToRGB(SourcePNG.Pixels[SourceX, SourceY]);
      if SourceHasAlpha
      then SourceAlpha := SourceAlphaLine[SourceX]
      else SourceAlpha := Integer((SourceTransColor = clNone) or (SourceColor <> SourceTransColor)) * 255;
 
      if InOverlayY and (SourceX >= OverlayPosition.X) and (SourceX <= OverlayPosition.X + OverlayPNG.Width)
      then begin
           OverlayX := SourceX - OverlayPosition.X;
 
           //Get color and alpha from overlay image at current position
           OverlayColor := ColorToRGB(OverlayPNG.Pixels[OverlayX, OverlayY]);
           if OverlayHasAlpha
           then OverlayAlpha := AlphaWithOpacity(OverlayAlphaLine[OverlayX], OverlayOpacity)
           else OverlayAlpha := AlphaWithOpacity(Integer((OverlayTransColor = clNone) or (OverlayColor <> OverlayTransColor)) * 255, OverlayOpacity);
 
           //Combine colors and alphas from both images into destination image
           Dest.Pixels[SourceX, SourceY] := CombineColors(SourceColor, OverlayColor, SourceAlpha, OverlayAlpha);
           DestAlphaLine[SourceX] := CombineAlphas(SourceAlpha, OverlayAlpha);
           end
      else begin
           //We're not yet in the overlay image, just copy source color and alpha to destination
           Dest.Pixels[SourceX, SourceY] := SourceColor;
           DestAlphaLine[SourceX] := SourceAlpha;
           end;
      end;
   end;
end;

end.
