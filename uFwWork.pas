unit uFwWork;

interface

uses Windows, uTypes, uFileIO, SysUtils, gnugettext, uByteUtils, Classes,
     JclContainerIntf, JclHashMaps, Forms, Graphics,
     Imaging, ImagingClasses,ImagingTypes, ImagingCanvases, ImagingComponents,
     JclCompression,
     pngimage, AcedContainers, AcedAlgorithm;

function LoadImageTables(Data:PByte;Log:TStrings;prProc:TProgressProc;altMethod:boolean=false):TImgTables;
function ReadImgTable(Log:TStrings;Sig:string;Data:PByte;table_offset:integer=-1):TImgTable;
procedure LoadNames(imTables:TImgTables;Log:TStrings;prProc:TProgressProc);
function GetImgFromArray(Data:PByte;var arr:TImgTable;Index:Integer):TSingleImage;
function GetImageDataAsPNG(img:TSingleImage;prProc:TProgressProc):TmByteArray;
function GetImageDataAsPKI(img:TSingleImage;prProc:TProgressProc):TmByteArray;
function GetImageDataAsBMP(img:TSingleImage;prProc:TProgressProc):TmByteArray;
function GetImageDataAsRLE(img:TSingleImage;prProc:TProgressProc):TmByteArray;
function GetImageDataAsNotRLE(img:TSingleImage;prProc:TProgressProc):TmByteArray;
procedure SetRAWData(var fim:TfwImg;const Buf:TmByteArray;picbase:integer);
function GetFreeBlocks(imTable,imReplTable:TImgTable):TFreeBlocks;
function PlaceImages(imTable,imReplTable:TImgTable;prProc:TProgressProc;imtIndex:integer;oldFw,newFw:PByte):PByte;
function GenerateVKP(const fwSrc, fwMod: PByte; iLen: Cardinal; imTables:TImgTables; prProc:TProgressProc): TStringList;
function CreatePatchedFW(imTables,imReplTables:TImgTables;SetProgress:TProgressProc):PByte;
function ApplyVKPToFw(imTables,imReplTables:TImgTables;patchLines:TStringList;var changedOffsets:TIntegerArray;SetProgress:TProgressProc):PByte;
procedure SortFeeBlocksByLength(var Blocks:TFreeBlocks);
procedure SortFeeBlocksByOffset(var Blocks:TFreeBlocks);
function GetRAWData(const P:PByte; imTable:TImgTable; const img:TfwImg):TmByteArray;
function CompareImageTables(oldTables,newTables:TImgTables;FpatchedData:PByte; deletedImg:TSingleImage;prProc:TProgressProc):TImgTables;
procedure GetUsedColors(const img:TSingleImage;var ColorsArray:TColorArray;var TranspArray:TmByteArray);

implementation

uses uImgUtils;

function IntToBin( Int: Integer ): String;
var
  i, j: Integer;
begin
  Result := '';
  i := 0;
  j := 1;
  while i = 0 do
    if( ( Int Mod (j*2) ) = Int )
      then i := j
      else j := j * 2;
  while i > 0 do
  begin
    if( ( Int div i ) > 0 ) then
    begin
      Int := Int - i;
      Result := Result + '1';
    end
    else Result := Result + '0';
    i := Trunc( i * 0.5 );
  end;
end;

function BinToInt( Binary: String ):Integer;
var
  i, j: Integer;
begin
  Result := 0;
  j := 1;
  for i := Length( Binary ) downTo 1 do
  begin
    Result := Result + StrToInt( Binary[i] ) * j;
    j := j*2;
  end;
end;

function FindInColorArray(SrcArray:TColorArray; val:TColor):integer;
var
 i:integer;
begin
 Result:=0;
 for i:=0 to Length(SrcArray)-1 do begin
  if SrcArray[i]=val then begin
   Result:=i;
   break;
  end;
 end;
end;

function FindInByteArray(SrcArray:TmByteArray; val:integer):integer;
var
 i:integer;
begin
 Result:=0;
 for i:=0 to Length(SrcArray)-1 do begin
  if SrcArray[i]=val then begin
   Result:=i;
   break;
  end;
 end;
end;

function ReadImgTable(Log:TStrings;Sig:string;Data:PByte;table_offset:integer=-1):TImgTable;
var
 i:integer;
 tmpWindow:PAnsiChar;
 StartAddress:Integer;
 sigLen:integer;
begin
 //If offset is not given, search by signature
 if table_offset=-1 then begin
  tmpWindow:=PAnsiChar(Sig);
  Result.tableStart:=0;
  sigLen:=Length(tmpWindow);
  for i:=0 to iFileLen-1-sigLen-5 do begin
   if CompareMem(tmpWindow,Pointer(Integer(Data)+i),sigLen) then begin
    Result.tableStart:=i-12;
    break;
   end;
  end;
  if Result.tableStart=0 then
   raise Exception.Create(_('Firmware does not contain requested image table!'));
 end else begin
  Result.tableStart:=table_offset;
 end;
 Result.pheader:=GetWORD(Data,Result.tableStart+$34);
 Result.numIcons:=Result.pheader;
 Result.offset:=GetWORD(Data,Result.tableStart+$34+$10);
 Result.picbase:=Result.tableStart+Result.offset;
 Result.names:=Result.tableStart+$34+$10+4;
 Result.offsettable:=Result.names+Result.numIcons*2;
 Result.table_size:=GetWORD(Data,Result.tableStart+4);

 if Log<>nil then
  Log.Add(Format('table start: %s; '+
                        'pheader: %s; '+
                        'images count: %s; '+
                        'offset: %s; '+
                        'picbase: %s; '+
                        'names start: %s; '+
                        'offset table: %s; '+
                        'table size: %s; ',
                  [IntToHex(Result.tableStart,8),
                  IntToHex(Result.pheader,8),
                  IntToStr(Result.numIcons),
                  IntToHex(Result.offset,8),
                  IntToHex(Result.picbase,8),
                  IntToHex(Result.names,8),
                  IntToHex(Result.offsettable,8),
                  IntToHex(Result.table_size,8)]));

  SetLength(Result.Images,Result.numIcons);
  for i:=0 to Result.numIcons-1 do begin
   StartAddress:=Get3Bytes(Data,Result.offsettable+i*3);
   Result.Images[i].StartOffset:=StartAddress;
   Result.Images[i].orig_offset:=StartAddress;
   StartAddress:=StartAddress+Result.picbase;
   Result.Images[i].imType:=imUNK;
    if (GetByte(Data,StartAddress)=$AA) then begin
    if (GetByte(Data,StartAddress+5)=$00) and
       (GetByte(Data,StartAddress+6)=$00) then begin
          Result.Images[i].imType:=imUNK;
          if GetByte(Data,StartAddress+11)=$5A then begin
           Result.Images[i].imType:=imPKI;
           if platform_version=unknown then
            platform_version:=db2020;
          end;
          if GetByte(Data,StartAddress+11)=$89 then begin
           Result.Images[i].imType:=imPNG;
           if platform_version=unknown then
            platform_version:=db2020;
          end;
    end;
   end;
   if Result.Images[i].imType=imUNK then begin
    if GetByte(Data,StartAddress)=$0 then begin
     Result.Images[i].imType:=imBWI;
    end else if GetByte(Data,StartAddress)=$0F then begin
     //db2010 BMP
     Result.Images[i].imType:=imBMP;
     if platform_version=unknown then
      platform_version:=db2010;
    end else if GetByte(Data,StartAddress)=$FF then begin
     //db2010 FF
     Result.Images[i].imType:=imUNK;
     if platform_version=unknown then
      platform_version:=db2010;
    end else begin
     //db2010 RLE
     Result.Images[i].imType:=imColor;
     if platform_version=unknown then
      platform_version:=db2010;
    end;
   end;
   Result.Images[i].name:=IntToHex(GetWORD(Data,Result.names+i*2),2);
   Result.Images[i].Space:=-1;
   Result.Images[i].Used:=-1;
   Result.Images[i].Image:=nil;
   Result.Images[i].deleted:=false;
   Result.Images[i].replaced:=false;
   Result.Images[i].DisplayName:=Result.Images[i].name;
  end;
end;

function CheckIfOffsetIsPIT(var c_offset:integer):TPit;
var
 tbl_adress:DWORD;
 imt:TImgTable;
 pit:array of DWORD;
 i,j:integer;
 img:TSingleImage;
begin
 Result.StartAddress:=c_offset;
 //Now check if offset if PIT
 SetLength(pit,0);
 SetLength(Result.imTables,0);
 //Read PIT and check if offsets are links to image tables
 while true do begin
  SetLength(pit,Length(pit)+1);
  SetLength(Result.imTables,Length(Result.imTables)+1);
  tbl_adress:=GetDWORD(FData,c_offset);
  if tbl_adress=6 then begin
   //End of PIT
   break;
  end;
  if tbl_adress<imgbase then begin
   if Length(pit)=0 then begin
    Result.StartAddress:=-1;
    Exit;
   end else break;
  end;
  pit[Length(pit)-1]:=tbl_adress-imgbase;
  try
   {$R+}
   imt:=ReadImgTable(nil,'',FData,pit[Length(pit)-1]);
   {$R-}
   if imt.pheader=0 then begin
    Result.StartAddress:=-1;
    Exit;
   end;
  except
   Result.StartAddress:=-1;
   Exit;
  end;
  Result.imTables[Length(Result.imTables)-1]:=imt;
  inc(c_offset,4);
  if not ((GetDWORD(FData,c_offset)=0) and (GetDWORD(FData,c_offset)=0)) then break;
  inc(c_offset,8);
  //Assume PIT should be less than 50 items
  if Length(pit)>20 then begin
   Result.StartAddress:=-1;
   Exit;
  end;
 end;
 //If last imt is empty, delete it
 if Length(pit)>0 then begin
  if Length(Result.imTables[Length(Result.imTables)-1].Images)=0 then begin
   SetLength(pit,Length(pit)-1);
   SetLength(Result.imTables,Length(Result.imTables)-1);
  end;
 end;
 if Length(pit)=0 then begin
  Result.StartAddress:=-1;
  Exit;
 end;
 //Validate image tables
 for i:=0 to Length(Result.imTables)-1 do begin
  imt:=Result.imTables[i];
  if Length(imt.Images)<10 then begin
   Result.StartAddress:=-1;
   Exit;
  end;
 end;
 //Assume there should not be db2010 images on newer platforms
 if platform_version<>db2010 then begin
  for i:=0 to Length(Result.imTables)-1 do begin
   imt:=Result.imTables[i];
   for j:=0 to Length(imt.Images)-1 do begin
    if imt.Images[j].imType=imColor then begin
     Result.StartAddress:=-1;
     Exit;
    end;
   end;
  end;
 end;
 for i:=0 to Length(Result.imTables)-1 do begin
  imt:=Result.imTables[i];
  for j:=0 to Length(imt.Images)-1 do begin
   if imt.Images[j].imType=imColor then begin
    try
     img:=GetImgFromArray(FData,imt,j);
     img.Free;
    except
     Result.StartAddress:=-1;
     Exit;
    end;
   end;
  end;
 end;
end;

function FindPIT(Data:PByte;prProc:TProgressProc):TPit;
var
 Finded:boolean;
 c_offset,percent,old_percent:integer;
begin
 Result.StartAddress:=-1;
 c_offset:=0;
 old_percent:=0;
 Finded:=false;

 while (not Finded) and ((c_offset+40)<iFileLen) do begin
  //Update progress
  percent:=Round(c_offset/iFileLen*100);
  if (percent-old_percent)>5 then begin
   old_percent:=percent;
   prProc(_('Searching for PIT...'),percent);
  end;
  if (GetDWORD(FData,c_offset)>imgbase) and
     (GetByte(FData,c_offset+5)=0) and
     (GetByte(FData,c_offset+6)=0) and
     (GetByte(FData,c_offset+7)=0) and
     (GetByte(FData,c_offset+8)=0) and
     (GetByte(FData,c_offset+9)=0) and
     (GetByte(FData,c_offset+10)=0) and
     (GetByte(FData,c_offset+11)=0) and
     (GetDWORD(FData,c_offset+12)>imgbase) and
     (GetByte(FData,c_offset+17)=0) and
     (GetByte(FData,c_offset+18)=0) and
     (GetByte(FData,c_offset+19)=0) and
     (GetByte(FData,c_offset+20)=0) and
     (GetByte(FData,c_offset+21)=0) and
     (GetByte(FData,c_offset+22)=0) then begin
      //Some table... interesting
      Result:=CheckIfOffsetIsPIT(c_offset);
      if Result.StartAddress>0 then
       Finded:=true;
  end;
  c_offset:=c_offset+1;
 end;
 prProc(_('Searching for PIT...'),100);
end;

function LoadImageTables(Data:PByte;Log:TStrings;prProc:TProgressProc;altMethod:boolean=false):TImgTables;
var
 imt:TImgTable;
 PIT:TPit;
begin
 if altMethod then begin
  PIT:=FindPIT(Data,prProc);
  if PIT.StartAddress<0 then Exit;
  Result:=PIT.imTables;
  Exit;
 end;
 try
  imt:=ReadImgTable(Log,'ICON_16BIT_V2',Data);
  SetLength(Result,Length(Result)+1);
  Result[Length(Result)-1]:=imt;
 except
 end;
 try
  imt:=ReadImgTable(Log,'ICON_2BIT_V2_2NDLCD',Data);
  SetLength(Result,Length(Result)+1);
  Result[Length(Result)-1]:=imt;
 except
 end;
 try
  imt:=ReadImgTable(Log,'ICON_16BIT_SYMBOLS_V2',Data);
  SetLength(Result,Length(Result)+1);
  Result[Length(Result)-1]:=imt;
 except
 end;
end;

function HashOfString(const str: string): integer;
var
 s:string;
 curChar:integer;
 i:integer;
 temp:integer;
begin
 Result:=0;
 s:=Trim(str);
 if Length(s)<1 then Exit;
 for i:=1 to Length(s) do begin
  curChar:=ord(s[i]);
  if (curchar=ord('_')) then curchar:=$24
   else
  if (curchar>=ord('A')) and (curchar<ord('[')) then curchar:=curchar+$C9  //0x0A..0x23
   else
  if (curchar>=ord('0')) and (curchar<ord(':')) then curchar:=curchar+$D0  //0x00..0x09
   else
  if (curchar>=ord('a')) and (curchar<ord('{')) then curchar:=curchar+$C4  //0x25..0x3E
   else curchar:=$3F;
  curChar:=curChar and $3F;
  curChar:=curChar or (Result shl 6);
  temp:=Result shr $12;
  Result:=$3F and temp xor curChar;
 end;
 Result:=Result and $FFFFFF;
end;

procedure LoadNames(imTables:TImgTables;Log:TStrings;prProc:TProgressProc);
var
 c_offset:Integer;
 Finded:boolean;
 Hash:IJclStrStrMap;
 namesTable:TStringList;
 imNames:IJclStrStrMap;
 hv,ic_id:DWORD;
 i,j,k,z:integer;
 //
 percent,old_percent:integer;
 f:System.text;
 s:string;
begin
 Log.Add('Building names table...');
 Log[Log.Count-1]:=Log[Log.Count-1]+' ok';
 //Load table
 Log.Add('Loading names file...');
 namesTable:=TStringList.Create;
 for z:=0 to Length(imTables)-1 do begin
  for i:=0 to Length(imTables[z].Images)-1 do begin
   namesTable.Add(imTables[z].Images[i].name);
  end;
 end;
 Hash:=TJclStrStrHashMap.Create(10);
 AssignFile(f,ExtractFilePath(ParamStr(0))+'names.txt');
 Reset(f);
 while not eof(f) do begin
  ReadLn(f,s);
  s:=Trim(AnsiUpperCase(s));
  Hash.PutValue(IntToHex(HashOfString(s),6),s);
 end;
 CloseFile(f);
 Log[Log.Count-1]:=Log[Log.Count-1]+' ok';
 //Let's try to find names table
 Log.Add(_('Searching for names table...'));
 prProc(_('Searching for names table...'),0);
 old_percent:=0;
 Finded:=false;
 c_offset:=0;
 while (not Finded) and ((c_offset+40)<iFileLen) do begin
  //Update progress
  percent:=Round(c_offset/iFileLen*100);
  if (percent-old_percent)>5 then begin
   old_percent:=percent;
   prProc(_('Searching for names table...'),percent);
  end;
  if (GetByte(FData,c_offset)<>0) and
     (GetByte(FData,c_offset+1)<>0) and
     (GetByte(FData,c_offset+2)=0) and
     (GetByte(FData,c_offset+3)=0) and
     (GetByte(FData,c_offset+4)<>0) and
     (GetByte(FData,c_offset+5)<>0) and
     (GetByte(FData,c_offset+6)=0) and
     (GetByte(FData,c_offset+7)=0) and
     (GetByte(FData,c_offset+8)<>0) and
     (GetByte(FData,c_offset+9)<>0) and
     (GetByte(FData,c_offset+10)=0) and
     (GetByte(FData,c_offset+11)=0) and
     (GetByte(FData,c_offset+12)<>0) and
     (GetByte(FData,c_offset+13)<>0) and
     (GetByte(FData,c_offset+14)=0) and
     (GetByte(FData,c_offset+15)=0) and
     (GetByte(FData,c_offset+16)<>0) and
     (GetByte(FData,c_offset+17)<>0) and
     (GetByte(FData,c_offset+18)=0) and
     (GetByte(FData,c_offset+19)=0) and
     (GetByte(FData,c_offset+20)<>0) and
     (GetByte(FData,c_offset+21)<>0) and
     (GetByte(FData,c_offset+22)=0) and
     (GetByte(FData,c_offset+23)=0) and
     (GetByte(FData,c_offset+24)<>0) and
     (GetByte(FData,c_offset+25)<>0) and
     (GetByte(FData,c_offset+26)=0) and
     (GetByte(FData,c_offset+27)=0) and
     (GetByte(FData,c_offset+28)<>0) and
     (GetByte(FData,c_offset+29)<>0) then begin
   //Some table... interesting
   //Check three icons
   hv:=GetDWORD(FData,c_offset);
   if not Hash.ContainsKey(IntToHex(hv,6)) then begin
    c_offset:=c_offset+1;
    continue;
   end;
   ic_id:=GetDWORD(FData,c_offset+4);
   if namesTable.IndexOf(IntToHex(ic_id,4))<0 then begin
    c_offset:=c_offset+1;
    continue;
   end;
   //Second
   hv:=GetDWORD(FData,c_offset+8);
   if not Hash.ContainsKey(IntToHex(hv,6)) then begin
    c_offset:=c_offset+1;
    continue;
   end;
   ic_id:=GetDWORD(FData,c_offset+12);
   if namesTable.IndexOf(IntToHex(ic_id,4))<0 then begin
    c_offset:=c_offset+1;
    continue;
   end;
{   //Third
   hv:=GetDWORD(FData,c_offset+16);
   if not Hash.ContainsKey(IntToHex(hv,6)) then begin
    c_offset:=c_offset+1;
    continue;
   end;
   ic_id:=GetDWORD(FData,c_offset+20);
   if namesTable.IndexOf(IntToHex(ic_id,4))<0 then begin
    c_offset:=c_offset+1;
    continue;
   end;}
   Log[Log.Count-1]:=Log[Log.Count-1]+' ok';
   Log.Add(Format('Offset: $%s',[IntToHex(c_offset,6)]));
   Finded:=true;
  end else begin
   c_offset:=c_offset+1;
  end;
 end;
 if not Finded then begin
  Log[Log.Count-1]:=Log[Log.Count-1]+' failed!';
  Exit;
 end;
 prProc(_('Processing image names...'),0);
 imNames:=TJclStrStrHashMap.Create(10);
 while Finded do begin
  hv:=GetDWORD(FData,c_offset);
  ic_id:=GetDWORD(FData,c_offset+4);
  if Hash.ContainsKey(IntToHex(hv,6)) then begin
   imNames.PutValue(IntToHex(ic_id,4),Hash.Items[IntToHex(hv,6)]);
  end;
  c_offset:=c_offset+8;
  if (GetByte(FData,c_offset+3)=0) and
     (GetByte(FData,c_offset+6)=0) and
     (GetByte(FData,c_offset+7)=0) then
  else
   Finded:=false;
 end;
 j:=0;k:=0;
 for z:=0 to Length(imTables)-1 do begin
  for i:=0 to Length(imTables[z].Images)-1 do begin
   if imNames.ContainsKey(imTables[z].Images[i].name) then begin
    imTables[z].Images[i].DisplayName:=imNames.Items[imTables[z].Images[i].name]+' ('+imTables[z].Images[i].name+')';
    j:=j+1;
   end else begin
    k:=k+1;
   end;
  end;
 end;
 FreeAndNil(namesTable);
 Log.Add(Format('Loaded %d icon names, not found %d names',[j,k]));
end;

procedure SetImgParamsFromHeader(const P:PByte;const imTable:TImgTable;var imrec:TfwImg);
begin
 imrec.im_width:=GetWORD(P,imrec.StartOffset+imTable.picbase+1);
 imrec.im_height:=GetWORD(P,imrec.StartOffset+imTable.picbase+3);
 imrec.im_width_space:=GetWORD(P,imrec.StartOffset+imTable.picbase+7);
 imrec.im_height_space:=GetWORD(P,imrec.StartOffset+imTable.picbase+9);
end;

{function LoadPacked(const fStream:TStream; const im_width,im_height: Integer):TPNGObject;overload;
var
 x,y:Integer;
 rgba: byte;
 hex:string;
 im:TPNGObject;
 rgbLine:TRGBLine;
 porgbLine:pRGBLine;
 rgbTripple:TRGBTriple;
 aScanLine:pngimage.TByteArray;
begin
 hex:='';
 x:=0;
 y:=0;
 fStream.Seek(0,soFromBeginning);
 im:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,im_width,im_height);
 while (y<(im_height)) do begin
  fStream.Read(rgba,1);
  hex:=hex+inttohex(rgba,2);
  if length(hex)=8 then begin
   rgbTripple.rgbtBlue:=strtoint('$'+Copy(hex,1,2));
   rgbTripple.rgbtGreen:=strtoint('$'+Copy(hex,3,2));
   rgbTripple.rgbtRed:=strtoint('$'+Copy(hex,5,2));
   aScanLine[x]:=StrToInt('$'+Copy(hex,7,2));
   rgbLine[x]:=rgbTripple;
   porgbLine:=@rgbLine;
   hex:='';
   x:=x+1;
   if x>=im_width then begin
    CopyMemory(im.Scanline[y],porgbLine,im_width*3);;
    CopyMemory(im.AlphaScanline[y],@aScanLine,im_width);;
    x:=0;
    y:=y+1;
   end;
  end;
 end;
 Result:=im;
end;}

function LoadPacked(const fStream:TStream; const im_width,im_height: Integer):TSingleImage;overload;
var
 im:TSingleImage;
 fs:TMemoryStream;
begin
 fStream.Seek(0,soFromBeginning);
 fs:=TMemoryStream.Create;
 fs.CopyFrom(fStream,fStream.Size);
 im:=TSingleImage.CreateFromParams(im_width,im_height,ifA8R8G8B8);
 CopyMemory(im.Bits,fs.Memory,fs.Size);
 FreeAndNil(fs);
 Result:=im;
end;

{function LoadBWI(const P:PByte; imAddr:dword; var img:TfwImg):TPNGObject;
var
 xsz,ysz : byte;
 n:word;
 b:byte;
 x,y:byte;
 adr:dword;
begin
 x:=0;
 y:=0;
 b:=0;
 adr:=imAddr;
 xsz:=GetByte(P,adr+1); // берём размеры из хедэра
 ysz:=GetByte(P,adr+2);
 img.im_width:=xsz;
 img.im_height:=ysz;
 if ysz=0 then ysz:=1;
 Result:=TPngImage.CreateBlank(COLOR_RGB,8,xsz,ysz);
 adr:=adr+6; // скипаем остальные запчасти хедэра
 inc (adr);
 n:=0;
 img.Space:=0;
 repeat // разматываем....
  if (n and 7)=0 then  begin
   b:=GetByte(P,adr);
   adr:=adr+1;
   img.Space:=img.Space+1;
  end;
  n:=n+1;
  if (b and 1)=1 then
   Result.Canvas.Pixels[x,y]:=0
  else
   Result.Canvas.Pixels[x,y]:=$FFFFFF;
  b:=b shr 1;
  x:=x+1;
  if x=xsz then begin
   x:=0;
   y:=y+1;
  end;
 until((n>xsz*ysz));
 img.Used:=img.Space;
end;}

function LoadBWI(const P:PByte; imAddr:dword; var img:TfwImg):TSingleImage;
var
 xsz,ysz : byte;
 n:word;
 b:byte;
 x,y:byte;
 adr:dword;
 Canvas:TImagingCanvas;
begin
 x:=0;
 y:=0;
 b:=0;
 adr:=imAddr;
 xsz:=GetByte(P,adr+1); // берём размеры из хедэра
 ysz:=GetByte(P,adr+2);
 img.im_height_space:=GetByte(P,adr+4);
 img.im_width_space:=GetByte(P,adr+5);
 img.im_width:=xsz;
 img.im_height:=ysz;
 if ysz=0 then ysz:=1;
 if xsz=0 then xsz:=1;
 Result:=TSingleImage.CreateFromParams(xsz,ysz,ifA8R8G8B8);
 Canvas:=TImagingCanvas.CreateForImage(Result);
 adr:=adr+6; // скипаем остальные запчасти хедэра
 inc (adr);
 n:=0;
 img.Space:=6; //header size
 repeat // разматываем....
  if (n and 7)=0 then  begin
   b:=GetByte(P,adr);
   adr:=adr+1;
  end;
  n:=n+1;
  if (b and 1)=1 then
   Canvas.Pixels32[x,y]:=$FF000000
  else
   Canvas.Pixels32[x,y]:=$00FFFFFF;
  b:=b shr 1;
  x:=x+1;
  if x=xsz then begin
   x:=0;
   y:=y+1;
  end;
 until((n>xsz*ysz));
 // Now add image size
 img.Space:=img.Space+Trunc(xsz*ysz/8);
 if Trunc(xsz*ysz/8)<(xsz*ysz/8) then
  img.Space:=img.Space+1;
 img.Used:=img.Space;
 // Free canvas
 FreeAndNil(Canvas);
end;

function SwapRGBtpBGR(color: TColor): TColor;
var
 crgb:Integer;
begin
 crgb:=ColorToRGB(color);
 Result:=RGB(GetBValue(crgb),GetGValue(crgb),GetRValue(crgb));
end;

function GetRLEDATA(const P:PByte; imAddr:dword):dword;
var
  pal_sz : word;
  RLE_DATA : dword;
begin
  RLE_DATA:=imAddr;
  if (GetByte(P,imAddr) and $0F)=$0E then
  begin

    pal_sz:=GetByte(P,imAddr+12)+1;

    RLE_DATA:=imAddr+13;
    RLE_DATA:=RLE_DATA+(pal_sz*3);
    if (GetByte(P,imAddr) and $F0)<>0 then
      RLE_DATA:=RLE_DATA+GetByte(P,imAddr+13)+2;
  end;
  result:=RLE_DATA;
end;

function UnRLE(const P:PByte; imAddr:dword; var img:TfwImg):TSingleImage;
var
 xsz,ysz : integer;
 pal_sz:byte;
 n:word;
 b:byte;
 x,y:byte;
 Canvas:TImagingCanvas;
 pfp:TColorFPRec;
 i,j:dword;
 rle_step:byte; //RLE block sz
 bp:byte; //Bit per palette
 transp:byte; //Bit per transparent
 bt:byte; //Total bpp
 bright : array[0..255] of byte;
 eqarray : array[0..255] of boolean;
 pallete : array[0..255] of LongInt;
// buff : array[0..131072] of byte;
 buff: array of byte;
 fbuf : array[0..131072] of boolean;
 im:dword;
 br_sz : byte; //Brighteness table size
 pbuff:integer;
 fl:boolean;
 cnt:integer;
 msk:byte;
 dwb:dword;
 eq,pint:integer;
 Color:TColor;
 im_buf_sz:integer;
begin
 xsz:=GetWORD(P,imAddr+1);
 ysz:=GetWORD(P,imAddr+3);
 //Limit image size to 640x480
 if (xsz>640) or (ysz>480) then
  raise Exception.Create('Too large image!');
 img.im_width:=xsz;
 img.im_height:=ysz;
 img.im_width_space:=GetWORD(P,imAddr+7);
 img.im_height_space:=GetWORD(P,imAddr+9);

 pal_sz:=GetByte(P,imAddr+12);  //кол-во цветов в палитре

// if (pal_sz<1) then
//  raise Exception.Create('Number of colors should be in the range of 1..256');

 Result:=TSingleImage.CreateFromParams(xsz,ysz,ifA8R8G8B8);
 Canvas:=TImagingCanvas.CreateForImage(Result);

 bp:=(GetByte(P,imAddr+11) and $0f) ;
 transp:=GetByte(P,imAddr) shr 4;
 bt:=bp+transp;
 rle_step := GetByte(P,imAddr+11) shr 4;

{ form1.Memo6.Lines.Add('RLE block sz : 0x'+inttohex(rle_step,2));
 form1.Memo6.Lines.Add('Bit per palette : 0x'+inttohex((getbyte(adr+11) and $0f),2));
 form1.Memo6.Lines.Add('Bit per transparrent : 0x'+inttohex(transp,2));
 form1.Memo6.Lines.Add('Total bit per pixel : 0x'+inttohex(bt,2));
 form1.Memo6.Lines.Add('');}

 //прочистили табличку прозрачности(??)
 for i:=0 to GetByte(P,imAddr+13) do begin
  bright[i]:=0;
  eqarray[i]:=false;
 end;

 //вычисляем начало таблички прозрачности(??)
 im:=14+imAddr;
 if (GetByte(P,imAddr) and $f0)=0 then dec(im);
 im:=im+(GetByte(P,imAddr+12)+1)*3;

 //form1.Memo6.Lines.Add('Bright table sz :'+inttohex(getbyte(adr+13),2));
 //если она есть, забираем к себе. иначе - все видимые
 if (GetByte(P,imAddr) and $f0)<>0 then begin
  br_sz:=GetByte(P,imAddr+13);
  for i:=0 to GetByte(P,imAddr+13) do begin
   bright[i]:=GetByte(P,im+i);
   //form1.Memo4.Lines.Add(inttohex(bright[i],2));
  end;
 end else begin
  bright[0]:=255;
  br_sz:=0;
 end;

 //вычисляем начало палитры
 im:=14+imAddr;
 if (GetByte(P,imAddr) and $f0)=0 then dec(im);

 //form1.Memo6.Lines.Add('Palette sz:'+inttohex(n,2));
 //забираем к себе
 for i:=0 to pal_sz do begin
  pallete[i]:=Get3Bytes(P,im+i*3);
  //form1.Memo4.Lines.Add(inttohex(pallete[i],6));
 end;

 //form1.Memo6.Lines.add('Palette : '+inttohex(n,2)+' colors');

 //вычисляем начало данных
 im:=GetRLEDATA(P,imAddr);

 //Header + pallete + transp. table sz
 img.Space:=im-imAddr-1;

 pbuff:=0;
 im_buf_sz:=trunc((ysz*xsz*bt)/8);

 if trunc((ysz*xsz*bt)/8)<((ysz*xsz*bt)/8) then
  inc(im_buf_sz);

 while (pbuff<im_buf_sz) do begin
  b:=GetByte(P,im);
  img.Space:=img.Space+1;
  im:=im+1;
  fl:=false;

  if (b < 128) then begin
   cnt:=(b+1)*rle_step;
   while (cnt>0) do begin
    b:=GetByte(P,im);
    img.Space:=img.Space+1;
    SetLength(buff,pbuff+1);
    buff[pbuff]:=b;
    fbuf[pbuff]:=fl;
    inc(pbuff);
    inc(im);
    dec(cnt);
   end;
  end else begin
   cnt:=($101-b);
   if (cnt>64) then fl:=true;
   b:=GetByte(P,im);
   img.Space:=img.Space+rle_step;
   inc(im,rle_step);
   while (cnt>0) do begin
    SetLength(buff,pbuff+1);
    buff[pbuff]:=b;
    fbuf[pbuff]:=fl;
    inc(pbuff);
    if (rle_step=2) then begin
     SetLength(buff,pbuff+1);
     buff[pbuff]:=GetByte(P,im-1);
     fbuf[pbuff]:=fl;
     inc(pbuff);
    end;
    dec(cnt);
   end;
  end;
 end;

 // Save image size
// img.Space:=img.Space+Trunc(xsz*ysz*bt/8);
// if Trunc(xsz*ysz*bt/8)<(xsz*ysz*bt/8) then
//  img.Space:=img.Space+1;
 img.Used:=img.Space;

 msk:=(1 shl transp)-1;
 //form1.Memo4.Lines.Add(inttohex(msk,2));
 cnt:=0;
 j:=0;
 dwb:=0;
 for y:=0 to ysz-1 do begin
  for x:=0 to xsz -1 do begin
   im:=0;
   n:=bt;
   pint:=(cnt*bt) shr 3;
   b:=(not(cnt*bt)) and 7;
   while(n<>0) do begin
    im:=im shl 1;
    if (buff[pint] and (1 shl b))<>0 then im:=im or 1;
    if (b<>0) then
     dec(b)
    else begin
     b:=7;
     inc(pint);
    end;
    dec(n);
   end;

   if (((im and msk)=(im shr transp)) and (eqarray[im shr transp]=false)) then begin
    eqarray[im shr transp]:=true;
   end;
   if (((im and msk)>j)) then
     j:= im and msk;
   if (((im shr (transp))>dwb)) then
     dwb:= im shr (transp);
   Canvas.Pixels32[x,y]:=LongWord(StrToInt('$'+IntToHex(bright[(im and msk)],2)+IntToHex(pallete[im shr transp],6)));
   inc (cnt);
  end;
 end;

{  form1.Memo6.Lines.Add('Max Used Transp. : '+inttohex(j,2));
  form1.Memo6.Lines.Add('Max Used Pal : '+inttohex(dwb,2));
  form1.Memo6.Lines.Add('equials : '+inttohex(eq,2));
  Form1.Image1.Picture.Bitmap.Assign(png);}
 img.bp:=bp;
 img.bt:=bt;
 img.transp:=transp;
 img.pal_sz:=pal_sz;
 img.transp_sz:=br_sz;
end;

function UnPackNotRLE(const P:PByte; imAddr:dword; var img:TfwImg):TSingleImage;
var
 bt, transp: byte;
 xsz, ysz: word;
 n: byte;
 i: word;
 b: byte;
 x, y: word;
 cnt: integer;
 im: dword;
 buf: array[0..131072] of byte;
 bright: array[0..255] of byte;
 eqarray: array[0..255] of boolean;
 pallete : array[0..255] of LongInt;
 pbuff, pint: integer;
 msk: byte;
 s: string;
 br_sz: byte;
 Canvas:TImagingCanvas;
begin
 //
 for i:=0 to 255 do begin
  bright[i]:=0;
  pallete[i]:=0;
 end;
 //
 xsz := GetWORD(P,imAddr + 1);
 ysz := GetWORD(P,imAddr + 3);
 //Limit image size to 640x480
 if (xsz>640) or (ysz>480) then
  raise Exception.Create('Too large image!');

 img.im_width:=xsz;
 img.im_height:=ysz;
 img.im_width_space:=GetWORD(P,imAddr+7);
 img.im_height_space:=GetWORD(P,imAddr+9);
 n := GetByte(P,imAddr + 11);  //кол-во цветов в палитре

// if (n<1) then
//  raise Exception.Create('Number of colors should be in the range of 1..256');

 Result:=TSingleImage.CreateFromParams(xsz,ysz,ifA8R8G8B8);
 Canvas:=TImagingCanvas.CreateForImage(Result);

 bt := (GetByte(P,imAddr) and $0f);
 transp := GetByte(P,imAddr) shr 4;
 bt := bt + transp;

 //прочистили табличку прозрачности(??)
 for i := 0 to GetByte(P,imAddr + 13) do begin
  bright[i] := 0;
  eqarray[i] := false;
 end;

 //вычисляем начало таблички прозрачности(??)
 im := 13 + imAddr;
 if (GetByte(P,imAddr) and $f0) = 0 then begin
  dec(im)
 end;
 im := im + (GetByte(P,imAddr + 11) + 1) * 3;

 // form1.Memo6.Lines.Add('Bright table sz :' + inttohex(getbyte(adr + 13), 2));
 //если она есть, забираем к себе. иначе - все видимые
 if (GetByte(P,imAddr) and $f0) <> 0 then begin
  br_sz := GetByte(P,imAddr + 12);
  for i := 0 to GetByte(P,imAddr + 12) do begin
   bright[i] := GetByte(P,im + i);
  end;
 end else begin
  bright[0] := 255;
  br_sz := 0;
 end;

 //вычисляем начало палитры
 im := 13 + imAddr;
 if (GetByte(P,imAddr) and $f0) = 0 then begin
  dec(im)
 end;

 // form1.Memo6.Lines.Add('Palette sz:' + inttohex(n, 2));
 //забираем к себе
 for i := 0 to n do begin
  pallete[i] := Get3Bytes(P,im + i * 3);
 end;

 //form1.Memo6.Lines.add('Palette : '+inttohex(n,2)+' colors');

 //вычисляем начало данных
 im := imAddr + ((n + 1) * 3) + (br_sz + 1) + 13;
 if (br_sz = 0) then begin
  dec(im, 2)
 end;

 //Header size
 img.Used:=im-imAddr-1;

 //Add image size
 img.Used:=img.Used+Trunc(xsz*ysz*bt/8);
 if Trunc(xsz*ysz*bt/8)<(xsz*ysz*bt/8) then
  inc(img.Used);
 img.Space:=img.Used;

 pbuff := 0;
 while (pbuff <= trunc((ysz * xsz * bt) / 8) + 1) do begin
  buf[pbuff] := GetByte(P,im);
  inc(pbuff);
  inc(im);
 end;

 msk := Byte((1 shl transp) - 1);
 //form1.Memo4.Lines.Add(inttohex(msk,2));
 cnt := 0;
 s := '';
 for y := 0 to ysz - 1 do begin
  for x := 0 to xsz - 1 do begin
   im := 0;
   n  := bt;
   pint  := (cnt * bt) shr 3;
   b  := (not (cnt * bt)) and 7;
   while (n <> 0) do begin
    im := im shl 1;
    if (buf[pint] and (1 shl b)) <> 0 then begin
     im := im or 1
    end;
    if (b <> 0) then begin
     dec(b)
    end else begin
     b := 7;
     inc(pint);
    end;
    dec(n);
   end;
   Canvas.Pixels32[x,y]:=LongWord(StrToInt('$'+IntToHex(bright[Byte(im and msk)],2)+IntToHex(pallete[Byte(im shr transp)],6)));
   inc(cnt);
  end;
 end;
{ form1.Memo6.Lines.Add('Max Used Transp. : ' + inttohex(j, 2));
 form1.Memo6.Lines.Add('Max Used Pal : ' + inttohex(dwb, 2));
 form1.Memo6.Lines.Add('equials : ' + inttohex(eq, 2));
 Form1.Image1.Picture.Bitmap.Assign(png);}
 FreeAndNil(Canvas);
 //
 img.bt:=(GetByte(P,imAddr) and $0f);
 img.bp:=bt;
 img.transp:=transp;
 img.pal_sz:=GetByte(P,imAddr + 11);
 img.transp_sz:=GetByte(P,imAddr + 12);
end;

function LoadBMP(const P:PByte; imAddr:dword; var img:TfwImg):TSingleImage;
var
 xsz, ysz: word;
begin
 //Image size
 xsz := getword(P,imAddr + 1);
 ysz := getword(P,imAddr + 3);
 //Limit image size to 640x480
 if (xsz>640) or (ysz>480) then
  raise Exception.Create('Too large image!');
 img.im_width:=xsz;
 img.im_height:=ysz;
 img.im_width_space:=GetWORD(P,imAddr+7);
 img.im_height_space:=GetWORD(P,imAddr+9);
 img.Used:=10+xsz*ysz*3; //Header size + data size
 img.Space:=img.Used;
 Result:=TSingleImage.CreateFromParams(xsz,ysz,ifR8G8B8);
 CopyMemory(Result.Bits,Pointer(DWORD(P)+imAddr+11),xsz*ysz*3);
end;

function LoadColor(const P:PByte; imAddr:dword; var img:TfwImg):TSingleImage;
begin
 if ((GetByte(P,imAddr) and $0F)=$0E) then
  Result:=UnRLE(P,imAddr,img)
 else
  Result:=UnPackNotRLE(P,imAddr,img);
end;

{procedure CopyAlpha(var src, dst: TPNGObject);
var
 i,j:Integer;
begin
 if src.Width<>dst.Width then Exit;
 if src.Height<>dst.Height then Exit;
 if not ((src.Header.ColorType=COLOR_RGBALPHA) or (src.Header.ColorType=COLOR_GRAYSCALEALPHA)) then Exit;
 if not ((dst.Header.ColorType=COLOR_RGBALPHA) or (dst.Header.ColorType=COLOR_GRAYSCALEALPHA)) then Exit;
 for i:=0 to src.Height-1 do begin
  for j:=0 to src.Width-1 do begin
   (dst.AlphaScanline[i])^[j]:=(src.AlphaScanline[i])^[j];
  end;
 end;
end;}

{function FixImageColors(img: TPNGObject): TPNGObject;
var
 i,j:Integer;
 im:TPNGObject;
begin
 im:=TPNGObject.CreateBlank(COLOR_RGB,8,img.Width,img.Height);
 im.CompressionLevel:=9;
 im.Filters:=[pfSub,pfUp,pfAverage,pfPaeth,pfNone];
 for i:=0 to im.Width-1 do begin
  for j:=0 to im.Height-1 do begin
   im.Pixels[i,j]:=SwapRGBtpBGR(img.Pixels[i,j]);
  end;
 end;
 im.CreateAlpha;
 CopyAlpha(img,im);
 Result:=TPNGObject.Create;
 Result.Assign(im);
 im.Free;
end;}

{function LoadPNG(const P:PByte; imAddr:dword; var img:TfwImg; const stOffset:Cardinal=12):TPNGObject;
var
 tmpWindow:PChar;
 sigLen:Integer;
 i,Len:Cardinal;
 fs:TStringStream;
 tmpStr:string;
 footer:string;
begin
 footer:=#$49#$45#$4E#$44#$AE#$42#$60#$82;
 tmpWindow:=PAnsiChar(footer);
 sigLen:=Length(footer);
 tmpStr:='';
 Len:=0;
 for i:=imAddr+stOffset to iFileLen-1 do begin
  if CompareMem(tmpWindow,Pointer(Cardinal(P)+i),sigLen) then begin
   Len:=i+Cardinal(Length(footer));
   break;
  end;
 end;
 for i:=imAddr+stOffset to Len-1 do begin
  tmpStr:=tmpStr+chr(PByte(Cardinal(P)+i)^);
 end;
 Len:=Len-stOffset;
 img.Space:=Len-imAddr;
 img.Used:=img.Space;
 fs:=TStringStream.Create(tmpStr);
 Result:=TPNGObject.Create;
 Result.LoadFromStream(fs);
 Result:=FixImageColors(Result);
 img.im_width:=Result.Width;
 img.im_height:=Result.Height;
 fs.Free;
end;}

function LoadPNG(const P:PByte; imAddr:dword; var img:TfwImg; const stOffset:Cardinal=12):TSingleImage;
var
 tmpWindow:PChar;
 sigLen:Integer;
 i,Len:Cardinal;
 fs:TStringStream;
 tmpStr:string;
 footer:string;
 PNGimg:TImagingPNG;
begin
 footer:=#$49#$45#$4E#$44#$AE#$42#$60#$82;
 tmpWindow:=PAnsiChar(footer);
 sigLen:=Length(footer);
 tmpStr:='';
 Len:=0;
 for i:=imAddr+stOffset to iFileLen-1 do begin
  if CompareMem(tmpWindow,Pointer(Cardinal(P)+i),sigLen) then begin
   Len:=i+Cardinal(Length(footer));
   break;
  end;
 end;
 for i:=imAddr+stOffset to Len-1 do begin
  tmpStr:=tmpStr+chr(PByte(Cardinal(P)+i)^);
 end;
// Len:=Len-stOffset;
 Len:=Len-1;
 img.Space:=Len-imAddr;
 img.Used:=img.Space;
 fs:=TStringStream.Create(tmpStr);
 PNGimg:=TImagingPNG.Create;
 PNGimg.LoadFromStream(fs);
 Result:=TSingleImage.Create;
 PNGimg.AssignToImage(Result);
 Result.SwapChannels(ChannelRed,ChannelBlue);
 img.im_width:=Result.Width;
 img.im_height:=Result.Height;
 img.im_width_space:=GetWORD(P,imAddr+7);
 img.im_height_space:=GetWORD(P,imAddr+9);
 FreeAndNil(fs);
end;

{function GetImgFromArray(Data:PByte;var arr:TImgTable;Index:Integer):TPNGObject;
var
 tmpStr:string;
 fs:TStringStream;
 img:TfwImg;
begin
 img:=arr.Images[Index];
 if img.Image=nil then begin
  if img.imType=imPKI then begin
   SetImgParamsFromHeader(Data,arr,img);
   tmpStr:=DecompressImg(Data,img.StartOffset+arr.picbase,iFileLen,img.Space);
   img.Used:=img.Space;
   fs:=TStringStream.Create(tmpStr);
   Result:=LoadPacked(fs,img.im_width,img.im_height);
   arr.Images[Index].Image:=Result;
   fs.Free;
  end else if img.imType=imBWI then begin
   Result:=LoadBWI(Data,img.StartOffset+arr.picbase,img);
   arr.Images[Index].Image:=Result;
  end else if img.imType=imPNG then begin
   Result:=LoadPNG(Data,img.StartOffset+arr.picbase,img);
   arr.Images[Index].Image:=Result;
  end else begin
   Result:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,1,1);
   arr.Images[Index].Image:=Result;
  end;
 end else begin
  Result:=img.Image;
 end;
end;}

function GetImgFromArray(Data:PByte;var arr:TImgTable;Index:Integer):TSingleImage;
var
 tmpStr:string;
 fs:TStringStream;
 img:TfwImg;
begin
 img:=arr.Images[Index];
 if img.Image=nil then begin
  if img.imType=imPKI then begin
   SetImgParamsFromHeader(Data,arr,img);
   tmpStr:=DecompressImg(Data,img.StartOffset+arr.picbase,iFileLen,img.Space);
   img.Space:=img.Space+11;
   img.Used:=img.Space;
   fs:=TStringStream.Create(tmpStr);
   Result:=LoadPacked(fs,img.im_width,img.im_height);
   arr.Images[Index]:=img;
   arr.Images[Index].Image:=Result;
   FreeAndNil(fs);
  end else if img.imType=imBWI then begin
   Result:=LoadBWI(Data,img.StartOffset+arr.picbase,img);
   arr.Images[Index]:=img;
   arr.Images[Index].Image:=Result;
  end else if img.imType=imPNG then begin
   Result:=LoadPNG(Data,img.StartOffset+arr.picbase,img);
   arr.Images[Index]:=img;
   arr.Images[Index].Image:=Result;
  //db2010
  end else if img.imType=imColor then begin
   Result:=LoadColor(Data,img.StartOffset+arr.picbase,img);
   arr.Images[Index]:=img;
   arr.Images[Index].Image:=Result;
  end else if img.imType=imBMP then begin
   Result:=LoadBMP(Data,img.StartOffset+arr.picbase,img);
   arr.Images[Index]:=img;
   arr.Images[Index].Image:=Result;
  end else begin
   Result:=TSingleImage.CreateFromParams(1,1,ifA8R8G8B8);
   arr.Images[Index].Image:=Result;
  end;
 end else begin
  Result:=img.Image;
 end;
end;

function DoZlib(fStream:TStream;strategy:Integer):TMemoryStream;
var
 zStream:TJclZLibCompressStream;
 mOutStream:TMemoryStream;
begin
 mOutStream:=TMemoryStream.Create;
 fStream.Seek(0,soFromBeginning);
 zStream:=TJclZLibCompressStream.Create(mOutStream,9);
 try
  zStream.CopyFrom(fStream,fStream.Size);
 finally
  FreeAndNil(zStream);
 end;
 mOutStream.Seek(0,soFromBeginning);
 Result:=mOutStream;
end;

function Zlib(fStream:TStream):TmByteArray;
var
 mOutStream:TMemoryStream;
 Count:Integer;
 resBuf:TmByteArray;
 def_ms:TMemoryStream;
begin
 def_ms:=DoZlib(fStream,0);
 mOutStream:=def_ms;
 SetLength(resBuf,mOutStream.Size);
 for Count:=0 to mOutStream.Size-1 do begin
  mOutStream.Read(resBuf[Count],1);
 end;
 FreeAndNil(mOutStream);
 Result:=resBuf;
end;

procedure SetStdHeaderParams(var HeadArray:TmByteArray; const im_width,im_height,im_width_place,im_height_place:WORD; const imType:byte);
begin
 //--Type
 HeadArray[0]:=imType;
 //--dimensions
 HeadArray[1]:=im_width and $00FF;
 HeadArray[2]:=im_width shr 8;
 HeadArray[3]:=im_height and $00FF;
 HeadArray[4]:=im_height shr 8;
 HeadArray[5]:=0;
 HeadArray[6]:=0;
 HeadArray[7]:=im_width_place and $00FF;
 HeadArray[8]:=im_width_place shr 8;
 HeadArray[9]:=im_height_place and $00FF;
 HeadArray[10]:=im_height_place shr 8;
end;

function GetImageDataAsPNG(img:TSingleImage;prProc:TProgressProc):TmByteArray;
var
 imgPNG:TImagingPNG;
 tmpStr:string;
begin
 imgPNG:=TImagingPNG.Create;
 imgPNG.AssignFromImage(img);
 tmpStr:=GenTempFileName;
 imgPNG.SaveToFile(tmpStr);
 OptimizeImg(tmpStr);
 Result:=ReadFileToMem(tmpStr,prProc);
 DeleteFile(tmpStr);
 FreeAndNil(imgPNG);
end;

function GetImageDataAsPKI(img:TSingleImage;prProc:TProgressProc):TmByteArray;
var
 tmpImg:TSingleImage;
 ms:TMemoryStream;
begin
 tmpImg:=TSingleImage.Create;
 tmpImg.CreateFromImage(img);
 tmpImg.Format:=ifA8R8G8B8;
 ms:=TMemoryStream.Create;
 ms.SetSize(tmpImg.Size);
 CopyMemory(ms.Memory,tmpImg.Bits,ms.Size);
 FreeAndNil(tmpImg);
 Result:=Zlib(ms);
 FreeAndNil(ms);
end;

function GetImageDataAsBMP(img:TSingleImage;prProc:TProgressProc):TmByteArray;
var
 tmpImg:TSingleImage;
 ms:TMemoryStream;
 i:integer;
begin
 tmpImg:=TSingleImage.Create;
 tmpImg.CreateFromImage(img);
 tmpImg.Format:=ifR8G8B8;
 tmpImg.SwapChannels(ChannelRed,ChannelBlue);
 ms:=TMemoryStream.Create;
 ms.SetSize(tmpImg.Size);
 CopyMemory(ms.Memory,tmpImg.Bits,ms.Size);

 SetLength(Result,ms.Size+11);
 SetStdHeaderParams(Result,tmpImg.Width,tmpImg.Height,tmpImg.Width,tmpImg.Height,$0F);

 FreeAndNil(tmpImg);
 for i:=0 to ms.Size-1 do
  ms.Read(Result[i+11],1);
 FreeAndNil(ms);
end;

procedure GetUsedColors(const img:TSingleImage;var ColorsArray:TColorArray;var TranspArray:TmByteArray);
var
 x,y,i:integer;
 tmpColor32:TColor32Rec;
 tmpColor:TColor;
 HasColor:boolean;
begin
 for y:=0 to img.Height-1 do begin
  for x:=0 to img.Width-1 do begin
   tmpColor32:=GetPixel32(img.ImageDataPointer^,x,y);
   tmpColor:=RGB(tmpColor32.R,tmpColor32.G,tmpColor32.B);
   //Search array if it has current color
   HasColor:=false;
   if Length(ColorsArray)>0 then begin
    for i:=0 to Length(ColorsArray)-1 do begin
     if ColorsArray[i]=tmpColor then begin
      HasColor:=true;
      break;
     end;
    end;
   end;
   if not HasColor then begin
    //Add color to array
    SetLength(ColorsArray,Length(ColorsArray)+1);
    ColorsArray[Length(ColorsArray)-1]:=tmpColor;
   end;
   //Now check transparency
   //Search array if it has current color
   HasColor:=false;
   if Length(TranspArray)>0 then begin
    for i:=0 to Length(TranspArray)-1 do begin
     if TranspArray[i]=tmpColor32.A then begin
      HasColor:=true;
      break;
     end;
    end;
   end;
   if not HasColor then begin
    //Add transparency value to array
    SetLength(TranspArray,Length(TranspArray)+1);
    TranspArray[Length(TranspArray)-1]:=tmpColor32.A;
   end;
  end;
 end;
end;

function GetRLEImgHeader(const ColorsArray:TColorArray; var TranspArray:TmByteArray; const rle_header:boolean; const Width,Height:integer; var transp,bt:byte; const bp:byte):TmByteArray;
var
 rle_step,imType:byte;
 i,cur_idx,tmp_idx:integer;
begin
 SetLength(Result,0);
 //Bits per transparent
 if Length(TranspArray)=0 then
  transp:=0
 else
  transp:=Length(IntToBin(Length(TranspArray)));
 if (transp=1) and (TranspArray[0]=$FF) then begin
  transp:=0;
  SetLength(TranspArray,0);
 end;
 //Calculate bt value
 bt:=bp+transp;
 //Set header array size
 SetLength(Result,13+(Length(ColorsArray)*3)+(Length(TranspArray)));
 if transp=0 then
  SetLength(Result,Length(Result)-1);
 if rle_header then begin
  //Need to add one extra byte to store rle_step and bits per palette value
  SetLength(Result,Length(Result)+1);
 end;

 //Set header
 if rle_header then begin
  //--transp+$E
  imType:=(transp shl 4)+$E;
 end else begin
  //--transp+bp
  imType:=(transp shl 4)+bp;
 end;
 SetStdHeaderParams(Result,Width,Height,Width,Height,imType);
 cur_idx:=11;
 if rle_header then begin
  //TODO: Calculate RLE block size
  rle_step:=1;
  //--RLE block sz and bits per palette
  Result[cur_idx]:=(rle_step shl 4)+bp;
  inc(cur_idx);
 end;
 //--color palette size
 Result[cur_idx]:=Length(ColorsArray)-1; inc(cur_idx);
 if transp<>0 then begin
  //--transparency palette size
  Result[cur_idx]:=Length(TranspArray)-1; inc(cur_idx);
 end;
 //--color palette
 i:=0;
 while i<Length(ColorsArray) do begin
  Result[cur_idx]:=GetRValue(ColorsArray[i]);
  Result[cur_idx+1]:=GetGValue(ColorsArray[i]);
  Result[cur_idx+2]:=GetBValue(ColorsArray[i]);
  cur_idx:=cur_idx+3;
  i:=i+1;
 end;
 if transp<>0 then begin
  //--transparency palette
  tmp_idx:=cur_idx;
  for cur_idx:=tmp_idx to Length(TranspArray)-1+tmp_idx do begin
   Result[cur_idx]:=TranspArray[cur_idx-tmp_idx];
  end;
 end;
 //Header finished!
end;

function GetEncodedImgData(const ColorsArray:TColorArray; const TranspArray:TmByteArray; const srcimg:TSingleImage; const bt,transp:byte;prProc:TProgressProc;const pr_start,pr_can_add:integer;const pr_msg:string):TmByteArray;
var
 BinaryString,tmpBinaryString:string;
 x,y:integer;
 tmpColor32:TColor32Rec;
 tmpColor:TColor;
 ColorIdx,TranspIdx:integer;
 img:TSingleImage;
begin
 //Convert image
 img:=TSingleImage.CreateFromImage(srcimg);
 img.Format:=ifA8R8G8B8;
 //String for image data
 BinaryString:='';
 SetLength(Result,Trunc(img.Height*img.Width*bt/8));
 if Trunc(img.Height*img.Width*bt/8)<(img.Height*img.Width*bt/8) then
  SetLength(Result,Length(Result)+1);
 for y:=0 to img.Height-1 do begin
  for x:=0 to img.Width-1 do begin
   //Get current pixel
   tmpColor32:=GetPixel32(img.ImageDataPointer^,x,y);
   tmpColor:=RGB(tmpColor32.R,tmpColor32.G,tmpColor32.B);
   //Find color in the palette
   ColorIdx:=FindInColorArray(ColorsArray,tmpColor);
   if transp<>0 then begin
    //Find transparency in the palette
    TranspIdx:=FindInByteArray(TranspArray,tmpColor32.A);
    //Construct binary string
    tmpBinaryString:=IntToBin((ColorIdx shl transp)+TranspIdx);
   end else begin
    //Construct binary string
    tmpBinaryString:=IntToBin(ColorIdx);
   end;
   //Add zeroes to needed length
   while Length(tmpBinaryString)<bt do
    tmpBinaryString:='0'+tmpBinaryString;
   //Add constructed string to result string
   BinaryString:=BinaryString+tmpBinaryString;
  end;
  prProc(pr_msg,pr_start+((y*pr_can_add) div img.Height));
 end;
 //Now fill ImageArray with data
 tmpBinaryString:=BinaryString;
 x:=0;
 while Length(tmpBinaryString)>0 do begin
  Result[x]:=BinToInt(Copy(tmpBinaryString,1,8));
  tmpBinaryString:=Copy(tmpBinaryString,9,MaxInt);
  x:=x+1;
 end;
end;

function CompressArrayRLE(const ImageArray:TmByteArray; prProc:TProgressProc):TmByteArray;
var
 i,j:integer;
 //for RLE encoding
 DiffCount,SameCount:byte;
 SrcPos:integer;
begin
 //Now need to compress image data with RLE
 i:=0;
 SrcPos:=0;
 SetLength(Result,0);
 while i<Length(ImageArray) do begin
  SameCount:=1;
  DiffCount:=0;
  // Determine run length
  while i+SameCount<Length(ImageArray) do begin
   // If we reach max run length or byte with different value, we end this run
   if (SameCount=128) or (ImageArray[SrcPos+SameCount]<>ImageArray[SrcPos]) then
    Break;
   inc(SameCount);
  end;
  if SameCount=1 then begin
   //If there are not some bytes with the same value, we compute how many different bytes are there
   while (i+DiffCount+1)<Length(ImageArray) do begin
    // Stop diff byte counting if there two bytes with the same value or DiffCount is too big
    if (DiffCount=127) or (ImageArray[SrcPos+DiffCount+1]=ImageArray[SrcPos+DiffCount]) then
     Break;
    inc(DiffCount);
   end;
   if i+DiffCount+1=Length(ImageArray) then
    inc(DiffCount);
  end;
  //Now store absolute data (direct copy image->file) or
  //store RLE code only (number of repeats + byte to be repeated)
  if DiffCount>0 then begin
   //'Absolute data' count
   SetLength(Result,Length(Result)+1);
   Result[Length(Result)-1]:=DiffCount-1;
   //Now write data
   SetLength(Result,Length(Result)+DiffCount);
   for j:=0 to DiffCount-1 do begin
    Result[Length(Result)-DiffCount+j]:=ImageArray[SrcPos+j];
   end;
   inc(i,DiffCount);
   inc(SrcPos,DiffCount);
  end else begin
   //Save number of repeats and byte that should be repeated
   SetLength(Result,Length(Result)+2);
   Result[Length(Result)-2]:=$101-SameCount;
   Result[Length(Result)-1]:=ImageArray[SrcPos];
   inc(i,SameCount);
   inc(SrcPos,SameCount);
  end;
  prProc(_('Compressing image as RLE...'),70+(i*20) div Length(ImageArray));
 end;
 prProc('',0,Format('Image length:%d; RLE: %d',[Length(ImageArray),Length(Result)]));
end;

function GetImageDataAsRLE(img:TSingleImage;prProc:TProgressProc):TmByteArray;
const
 BufferSize = 8*1024;
 MaxBp = 8;
var
 i,j:integer;
 ColorsArray:TColorArray;
 TranspArray:TmByteArray;
 //for encoding
 bt,bp:byte;
 transp:byte;
 HeaderArray:TmByteArray;
 ImageArray:TmByteArray;
 RleArray:TmByteArray;
 tmp_idx:integer;
 //for determining best bp value
 RleArrays,HeaderArrays:array of TmByteArray;
begin
 prProc(_('Compressing image as RLE...'),0);

 SetLength(ColorsArray,0);
 SetLength(TranspArray,0);
 //Get used colors and transparency levels
 GetUsedColors(img,ColorsArray,TranspArray);

 prProc(_('Compressing image as RLE...'),5);

 //Bits per palette
 bp:=Length(IntToBin(Length(ColorsArray)));

 SetLength(HeaderArrays,MaxBp-bp+1);
 SetLength(RleArrays,MaxBp-bp+1);
 for i:=bp to MaxBp do begin
  //Create image header
  SetLength(HeaderArrays[i-bp],0);
  HeaderArrays[i-bp]:=GetRLEImgHeader(ColorsArray,TranspArray,true,img.Width,img.Height,transp,bt,i);

  prProc(_('Compressing image as RLE...'),10);

  //Now encoding image data
  SetLength(ImageArray,0);
  ImageArray:=GetEncodedImgData(ColorsArray,TranspArray,img,bt,transp,prProc,10,70,_('Compressing image as RLE...'));
  prProc('',0,Format('bp=%d; image length: %d',[i,Length(ImageArray)]));

  //Compressing to RLE
  SetLength(RleArrays[i-bp],0);
  RleArrays[i-bp]:=CompressArrayRLE(ImageArray,prProc);
 end;

 //Select smallest bp
 j:=0;
 for i:=0 to Length(HeaderArrays)-1 do begin
  if (Length(HeaderArrays[i])+Length(RleArrays[i]))<(Length(HeaderArrays[j])+Length(RleArrays[j])) then
   j:=i;
 end;
 prProc('',0,Format('Minimum bits per palette: %d; selected bpp: %d',[bp,bp+j]));
 HeaderArray:=HeaderArrays[j];
 RleArray:=RleArrays[j];
 bp:=bp+j;
 bt:=bp-transp;

 //Make result array
 SetLength(Result,Length(HeaderArray)+Length(RleArray));
 for i:=0 to Length(HeaderArray)-1 do begin
  Result[i]:=HeaderArray[i];
 end;
 tmp_idx:=Length(HeaderArray);
 for i:=0 to Length(RleArray)-1 do begin
  Result[tmp_idx+i]:=RleArray[i];
 end;
 prProc(_('Compressing image as RLE...'),100);
end;

function GetImageDataAsNotRLE(img:TSingleImage;prProc:TProgressProc):TmByteArray;
var
 i:integer;
 ColorsArray:TColorArray;
 TranspArray:TmByteArray;
 //for encoding
 bt,bp,transp:byte;
 tmp_idx:integer;
 HeaderArray:TmByteArray;
 ImageArray:TmByteArray;
begin
 prProc(_('Compressing image as not RLE...'),0);

 SetLength(ColorsArray,0);
 SetLength(TranspArray,0);
 //Get used colors and transparency levels
 GetUsedColors(img,ColorsArray,TranspArray);

 prProc(_('Compressing image as not RLE...'),5);

 //Bits per palette
 bp:=Length(IntToBin(Length(ColorsArray)));

 //Create image header
 HeaderArray:=GetRLEImgHeader(ColorsArray,TranspArray,false,img.Width,img.Height,transp,bt,bp);

 prProc(_('Compressing image as not RLE...'),10);

 //Now encoding image data
 ImageArray:=GetEncodedImgData(ColorsArray,TranspArray,img,bt,transp,prProc,10,85,_('Compressing image as not RLE...'));

 //Make result array
 SetLength(Result,Length(HeaderArray)+Length(ImageArray));
 for i:=0 to Length(HeaderArray)-1 do begin
  Result[i]:=HeaderArray[i];
 end;
 tmp_idx:=Length(HeaderArray);
 for i:=0 to Length(ImageArray)-1 do begin
  Result[tmp_idx+i]:=ImageArray[i];
 end;
 prProc(_('Compressing image as not RLE...'),100);
end;

procedure SetRAWData(var fim:TfwImg;const Buf:TmByteArray;picbase:integer);
var
 i:Integer;
 tmpHex:string;
begin
 if (fim.imType=imColor) or (fim.imType=imBMP) then begin
  SetLength(fim.RAWData,Length(Buf));
  fim.Used:=Length(Buf);
  for i:=0 to Length(Buf)-1 do
   fim.RAWData[i]:=Buf[i];
 end else begin
  SetLength(fim.RAWData,Length(Buf)+12);
  fim.Used:=Length(Buf)+12;
  for i:=0 to 11 do
   fim.RAWData[i]:=GetByte(FData,picbase+fim.orig_offset+i);

  fim.RAWData[0]:=StrToInt('$AA');

  tmpHex:=IntToHex(fim.im_width,4);
  fim.RAWData[2]:=StrToInt('$'+Copy(tmpHex,1,2));
  fim.RAWData[1]:=StrToInt('$'+Copy(tmpHex,3,2));
  fim.RAWData[8]:=StrToInt('$'+Copy(tmpHex,1,2));
  fim.RAWData[7]:=StrToInt('$'+Copy(tmpHex,3,2));
  tmpHex:=IntToHex(fim.im_height,4);
  fim.RAWData[4]:=StrToInt('$'+Copy(tmpHex,1,2));
  fim.RAWData[3]:=StrToInt('$'+Copy(tmpHex,3,2));
  fim.RAWData[10]:=StrToInt('$'+Copy(tmpHex,1,2));
  fim.RAWData[9]:=StrToInt('$'+Copy(tmpHex,3,2));
  // And some zeroes
  fim.RAWData[5]:=0;
  fim.RAWData[6]:=0;

  if fim.imType=imPKI then
   fim.RAWData[11]:=StrToInt('$5A')
  else if fim.imType=imPNG then
   fim.RAWData[11]:=StrToInt('$89');
  for i:=0 to Length(Buf)-1 do
   fim.RAWData[i+12]:=Buf[i];
 end;
end;

procedure SortFeeBlocksByOffset(var Blocks:TFreeBlocks);
var
 i,j:Integer;
 tmpBlock:TFreeBlock;
begin
 for i:=0 to Length(Blocks)-1 do begin
  for j:=i to Length(Blocks)-1 do begin
   if Blocks[i].StartOffset>Blocks[j].StartOffset then begin
    tmpBlock:=Blocks[i];
    Blocks[i]:=Blocks[j];
    Blocks[j]:=tmpBlock;
   end;
  end;
 end;
end;

procedure SortFeeBlocksByLength(var Blocks:TFreeBlocks);
var
 i,j:Integer;
 tmpBlock:TFreeBlock;
begin
 for i:=0 to Length(Blocks)-1 do begin
  for j:=i to Length(Blocks)-1 do begin
   if Blocks[i].Length>Blocks[j].Length then begin
    tmpBlock:=Blocks[i];
    Blocks[i]:=Blocks[j];
    Blocks[j]:=tmpBlock;
   end;
  end;
 end;
end;

procedure DeleteFromArray(var arr:TFreeBlocks; const idx:Integer);overload;
var
 i:Integer;
begin
 for i:=idx to Length(arr)-2 do
  arr[i]:=arr[i+1];
 SetLength(arr,Length(arr)-1);
end;

procedure DeleteFromArray(var arr:TChangesImages; const idx:Integer);overload;
var
 i:Integer;
begin
 for i:=idx to Length(arr)-2 do
  arr[i]:=arr[i+1];
 SetLength(arr,Length(arr)-1);
end;

function CopyByteArray(arr:TmByteArray):TmByteArray;
var
 i:integer;
begin
 SetLength(Result,Length(arr));
 for i:=0 to Length(arr)-1 do begin
  Result[i]:=arr[i];
 end;
end;

function GetFreeBlocks(imTable,imReplTable:TImgTable):TFreeBlocks;
var
 i:integer;
 fwim:TfwImg;
begin
 //Walk through images and add deleted or replaced to array
 for i:=0 to Length(imReplTable.Images)-1 do begin
  fwim:=imReplTable.Images[i];
  if fwim.replaced or fwim.deleted then begin
   SetLength(Result,Length(Result)+1);
//!!!!   Result[Length(Result)-1].StartOffset:=fwim.StartOffset;
   Result[Length(Result)-1].StartOffset:=fwim.orig_offset;
   Result[Length(Result)-1].Length:=imTable.Images[i].Space;
  end;
 end;
 //Sort result array by offset
 SortFeeBlocksByOffset(Result);
 //Check for duplicates
 for i:=Length(Result)-1 downto 1 do begin
  if Result[i].StartOffset=Result[i-1].StartOffset then
   DeleteFromArray(Result,i);
 end;
 //Merge blocks
 for i:=Length(Result)-1 downto 1 do begin
  //Do not know, if it is ok... will try
//  if Result[i].StartOffset=Result[i-1].StartOffset+Result[i-1].Length+1 then begin
  if (Result[i].StartOffset=Result[i-1].StartOffset+Result[i-1].Length+1)
   or (Result[i].StartOffset=Result[i-1].StartOffset+Result[i-1].Length) then begin
   Result[i-1].Length:=Result[i-1].Length+Result[i].Length;
   DeleteFromArray(Result,i);
  end;
 end;
end;

function GetEmptyImg(prProc:TProgressProc):TmByteArray;
var
 im:TSingleImage;
begin
 //Create empty 1x1 image
 im:=TSingleImage.CreateFromParams(1,1,ifA8R8G8B8);

 //Get it as PKI
 Result:=GetImageDataAsPKI(im,prProc);

 //Free image
 FreeAndNil(im);
end;

function CreateChangedImagesArray(imTable,imReplTable:TImgTable;prProc:TProgressProc):TChangesImages;
var
 i:integer;
 fwim:TfwImg;
begin
 SetLength(Result,0);
 for i:=0 to Length(imReplTable.Images)-1 do begin
  fwim:=imReplTable.Images[i];

  //If needed, increase array length and fill common params
  if fwim.deleted or fwim.replaced then begin
   SetLength(Result,Length(Result)+1);
   with Result[Length(Result)-1].fwImg do begin
    name:=fwim.name;
    orig_offset:=fwim.orig_offset;
    StartOffset:=fwim.orig_offset;
    deleted:=fwim.deleted;
    replaced:=fwim.replaced;
    DisplayName:=fwim.DisplayName;
    Image:=nil;
   end;
   SetLength(Result[Length(Result)-1].Indexes,1);
   Result[Length(Result)-1].Indexes[0]:=i;
  end;

  //Actually fill image in array
  if fwim.deleted then begin
   with Result[Length(Result)-1].fwImg do begin
    imType:=imPKI;
    im_width:=1;
    im_height:=1;
    SetRAWData(Result[Length(Result)-1].fwImg,GetEmptyImg(prProc),imTable.picbase);
    Space:=Length(RAWData);
    Used:=Space;
   end;
  end else if fwim.replaced then begin
   with Result[Length(Result)-1].fwImg do begin
    imType:=fwim.imType;
    RAWData:=CopyByteArray(fwim.RAWData);
    Space:=Length(RAWData);
    Used:=Space;
    im_width:=fwim.im_width;
    im_height:=fwim.im_height;
   end;
  end;
 end;
end;

procedure SortImagesArray(var fwimArray:TChangesImages);
var
 i,j:integer;
 fwim:TChangedImage;
begin
 //Sort array by size descending
 for i:=0 to Length(fwimArray)-1 do begin
  for j:=i to Length(fwimArray)-1 do begin
   if fwimArray[i].fwImg.Space<fwimArray[j].fwImg.Space then begin
    fwim:=fwimArray[i];
    fwimArray[i]:=fwimArray[j];
    fwimArray[j]:=fwim;
   end;
  end;
 end;
end;

function FindInArray(arr:TIntegerArray;val:integer):boolean;
var
 i:integer;
begin
 Result:=false;
 for i:=0 to Length(arr)-1 do
  if arr[i]=val then begin
   Result:=true;
   Exit;
  end;
end;

function EqualArrays(arr1,arr2:TmByteArray):boolean;
var
 i:integer;
begin
 Result:=false;

 if Length(arr1)<>Length(arr2) then Exit;

 for i:=0 to Length(arr1)-1 do
  if arr1[i]<>arr2[i] then Exit;

 Result:=true;
end;

procedure SortArray(var arr:TIntegerArray);
var
 i,j:integer;
 tmp:integer;
begin
 //Sort array descending
 for i:=0 to Length(arr)-1 do begin
  for j:=i to Length(arr)-1 do begin
   if arr[i]<arr[j] then begin
    tmp:=arr[i];
    arr[i]:=arr[j];
    arr[j]:=tmp;
   end;
  end;
 end;
end;

function PlaceImages(imTable,imReplTable:TImgTable;prProc:TProgressProc;imtIndex:integer;oldFw,newFw:PByte):PByte;
var
 FreeBlocks:TFreeBlocks;
 ChangedImages:TChangesImages;
 i,j,k,imLen,srcOffset:integer;
 deleteImages:TIntegerArray;
 imgOk:boolean;
 tmpStr,src,dst:string;
begin
 //Get free blocks
 FreeBlocks:=GetFreeBlocks(imTable,imReplTable);

 //Sort them by size accending
 SortFeeBlocksByLength(FreeBlocks);

 //Create array with changed images
 ChangedImages:=CreateChangedImagesArray(imTable,imReplTable,prProc);

 //Check for duplicates (do byte-compare)
 deleteImages:=nil;
 for i:=0 to Length(ChangedImages)-1 do begin
  for j:=i+1 to Length(ChangedImages)-1 do begin
   if i<>j then if EqualArrays(ChangedImages[i].fwImg.RAWData,ChangedImages[j].fwImg.RAWData) then begin
    if FindInArray(deleteImages,j) then continue;
    SetLength(deleteImages,Length(deleteImages)+1);
    deleteImages[Length(deleteImages)-1]:=j;
    for k:=0 to Length(ChangedImages[j].Indexes)-1 do begin
     SetLength(ChangedImages[i].Indexes,Length(ChangedImages[i].Indexes)+1);
     ChangedImages[i].Indexes[Length(ChangedImages[i].Indexes)-1]:=ChangedImages[j].Indexes[k];
    end;
   end;
  end;
 end;
 SortArray(deleteImages);
 for i:=0 to Length(deleteImages)-1 do begin
  DeleteFromArray(ChangedImages,deleteImages[i]);
 end;
 deleteImages:=nil;

 //Sort changed images array by size descending
 SortImagesArray(ChangedImages);

 //Try to place images
 for i:=0 to Length(ChangedImages)-1 do begin

  //Search first block to which image can be placed and place it
  j:=-1;
  imgOk:=false;
  imLen:=Length(ChangedImages[i].fwImg.RAWData);
  while j<Length(FreeBlocks)-1 do begin
   j:=j+1;
   if FreeBlocks[j].Length<imLen then continue;

   //Place image
   ChangedImages[i].fwImg.StartOffset:=FreeBlocks[j].StartOffset;
//   fmMain.meLog.Lines.Add('Image: '+imToPlace[i].name+'; offset: '+IntToHex(imToPlace[i].StartOffset,6)+'; length: '+IntToHex(imToPlace[i].ImgLength,6));

   //Change that block size, if resulting size is zero => delete it from list
   FreeBlocks[j].StartOffset:=FreeBlocks[j].StartOffset+imLen+1;
   FreeBlocks[j].Length:=FreeBlocks[j].Length-(imLen+1);
   if FreeBlocks[j].Length=0 then DeleteFromArray(FreeBlocks,j);
   imgOk:=true;
   break;
  end;
  if not imgOk then
   raise Exception.Create(Format(_('There is no enough free space in table %d, delete some more images or select smaller replacement pictures'),[imtIndex+1]));

  //Again sort blocks by size
  SortFeeBlocksByLength(FreeBlocks);
 end;

 //Write changed images to firmware
 for i:=0 to Length(ChangedImages)-1 do begin
  for j:=0 to Length(ChangedImages[i].fwImg.RAWData)-1 do begin
   SetByte(newFw,ChangedImages[i].fwImg.StartOffset+imTable.picbase+j,ChangedImages[i].fwImg.RAWData[j])
  end;
 end;

 //Update image table in the copy of firmware
 for i:=0 to Length(ChangedImages)-1 do begin
  for j:=0 to Length(ChangedImages[i].Indexes)-1 do begin
   tmpStr:='';
   srcOffset:=ChangedImages[i].Indexes[j];
   src:=IntToHex(Get3Bytes(FData,imTable.offsettable+srcOffset*3),6);
   tmpStr:=tmpStr+Copy(src,5,2)+Copy(src,3,2)+Copy(src,1,2)+' ';
   dst:=IntToHex(ChangedImages[i].fwImg.StartOffset,6);
   tmpStr:=tmpStr+Copy(dst,5,2)+Copy(dst,3,2)+Copy(dst,1,2);
   //oftLines.Add(tmpStr);
   SetByte(newFw,imTable.offsettable+srcOffset*3,StrToInt('$'+Copy(dst,5,2)));
   SetByte(newFw,imTable.offsettable+srcOffset*3+1,StrToInt('$'+Copy(dst,3,2)));
   SetByte(newFw,imTable.offsettable+srcOffset*3+2,StrToInt('$'+Copy(dst,1,2)));
  end;
 end;

 //Return changed fw
 Result:=newFw;
end;

function CreatePatchedFW(imTables,imReplTables:TImgTables;SetProgress:TProgressProc):PByte;
var
 z:integer;
begin
 //Create copy of firmware
 GetMem(Result,iFileLen+100);
 MoveMemory(Result,FData,iFileLen);

 //Place images into firmware
 for z:=0 to Length(imTables)-1 do begin
  Result:=PlaceImages(imTables[z],imReplTables[z],@SetProgress,z,FData,Result);
 end;
end;

function GenerateVKP(const fwSrc, fwMod: PByte;
  iLen: Cardinal; imTables:TImgTables; prProc:TProgressProc): TStringList;
var
 Len,i,j,c:Integer;
 percent,oldPosition:Integer;
 SameByte:boolean;
 tmpResSrc,tmpResDst:string;
 bSrc,bMod:byte;
 curAddr:Integer;
 lastImgIndex,lastImgOffset,lastImgTableIndex:Integer;
begin
 Result:=TStringList.Create;
 prProc(_('Generating patch...'),0);

 //Calc first table start
 curAddr:=imTables[0].offsettable;
 for i:=0 to Length(imTables)-1 do begin
  if curAddr>imTables[i].offsettable then curAddr:=imTables[0].offsettable;
 end;
 c:=0;

 //Calc last image end
 lastImgOffset:=imTables[0].Images[0].orig_offset;
 lastImgIndex:=0;
 lastImgTableIndex:=0;
 for i:=0 to Length(imTables)-1 do begin
  for j:=0 to Length(imTables[i].Images)-1 do begin
   if lastImgOffset<(imTables[i].Images[j].orig_offset) then begin
    lastImgOffset:=imTables[i].Images[j].orig_offset;
    lastImgIndex:=j;
    lastImgTableIndex:=i;
   end;
  end;
 end;
 GetImgFromArray(FData,imTables[lastImgTableIndex],lastImgIndex);
 lastImgOffset:=lastImgOffset+imTables[lastImgTableIndex].Images[lastImgIndex].Used+imTables[lastImgTableIndex].picbase;

 //Make patch data
 oldPosition:=-1;
 Len:=lastImgOffset-curAddr;
 for i:=curAddr to lastImgOffset do begin
  bSrc:=GetByte(fwSrc,i);
  bMod:=GetByte(fwMod,i);
  if bSrc=bMod then SameByte:=true
   else SameByte:=false;
//  if cbExpertMode.Checked then
//   if cbAllGraphicsInVKP.Checked then SameByte:=false;
  if not SameByte then
   c:=c+1;
  if not SameByte then begin
   tmpResSrc:=tmpResSrc+IntToHex(bSrc,2);
   tmpResDst:=tmpResDst+IntToHex(bMod,2);
  end;
  if (not SameByte) and (c>15) then begin
   Result.Add(IntToHex(curAddr-c+1,8)+': '+tmpResSrc+' '+tmpResDst);
   c:=0;
   tmpResSrc:='';
   tmpResDst:='';
  end;
  if (SameByte) then if Length(tmpResSrc)>0 then begin
   Result.Add(IntToHex(curAddr-c,8)+': '+tmpResSrc+' '+tmpResDst);
   c:=0;
   tmpResSrc:='';
   tmpResDst:='';
  end;
  curAddr:=curAddr+1;
  percent:=Round((i/Len)*100);
  if oldPosition<>percent then begin
   prProc(_('Generating patch...'),percent);
   oldPosition:=percent;
  end;
 end;
 prProc(_('Generating patch...'),100);
end;

function ApplyPatchToFw(newFw:PByte;offset:integer;origBytes,changedBytes:string;var changedOffsets:TIntegerArray):PByte;
var
 i:integer;
 newByte:Byte;
begin
 Result:=newFw;

 //Check input data
 if Length(origBytes)<>Length(changedBytes) then
  raise Exception.Create(_('Incorrect patch format: length of original data is different from length of changed data'));
 if Length(origBytes)=0 then Exit;
 if (Length(origBytes) mod 2)<>0 then
  raise Exception.Create(_('Patching by half byte is not supported'));

 //Do patching
 for i:=0 to (Length(origBytes) div 2)-1 do begin
  //Get original data from patch line
  newByte:=StrToInt('$'+Copy(origBytes,i*2+1,2));

  //Check original data
  if GetByte(Result,offset+i)<>newByte then
   raise Exception.Create(_('Original data mismatch! Probably patch is created for different firmware'));

  //Set new data
  newByte:=StrToInt('$'+Copy(changedBytes,i*2+1,2));
  SetByte(Result,offset+i,newByte);

  //Add to array of offsets
  SetLength(changedOffsets,Length(changedOffsets)+1);
  changedOffsets[Length(changedOffsets)-1]:=offset+i;
 end;
end;

function ApplyVKPToFw(imTables,imReplTables:TImgTables;patchLines:TStringList;var changedOffsets:TIntegerArray;SetProgress:TProgressProc):PByte;
var
 i:integer;
 s,tmpStr:string;
 origBytes,changedBytes:string;
 offset,curOffset:integer;
begin
 //Create copy of firmware
 GetMem(Result,iFileLen+100);
 MoveMemory(Result,FData,iFileLen);

 //Try to apply patch
 offset:=0;
 for i:=0 to patchLines.Count-1 do begin
  s:=patchLines[i];
  if Copy(s,1,1)='+' then begin
   //This is an offset line
   s:='$'+Copy(s,2,Length(s));
//   offset:=offset+StrToInt(s);
   offset:=StrToInt(s);
   Continue;
  end else if Copy(s,1,1)='-' then begin
   //This is an offset line
   s:='$'+Copy(s,2,Length(s));
   offset:=offset-StrToInt(s);
   Continue;
  end else begin
   //Try to process it as a patch data

   //First, read offset
   tmpStr:=Copy(s,1,Pos(':',s)-1);
   s:=Copy(s,Pos(':',s)+2,Length(s));
   curOffset:=StrToInt('$'+tmpStr);

   //Second, read original data
   origBytes:=Copy(s,1,Pos(#32,s)-1);

   //And then, read changed data
   changedBytes:=Copy(s,Pos(#32,s)+1,Length(s));

   //Apply this line to fw
   Result:=ApplyPatchToFw(Result,DWORD(offset+curOffset)-imgbase,origBytes,changedBytes,changedOffsets);
  end;
 end;
end;

function GetRAWData(const P:PByte; imTable:TImgTable; const img:TfwImg):TmByteArray;
var
 i:integer;
begin
 SetLength(Result,img.Used+1);
 for i:=0 to img.Used do
  Result[i]:=GetByte(P,imTable.picbase+img.StartOffset+i);
end;

function CompareImageTables(oldTables,
  newTables: TImgTables;FpatchedData:PByte; deletedImg:TSingleImage;prProc:TProgressProc): TImgTables;
var
 z,i,TotalImages,percent,old_percent:integer;
 imold,imnew:TfwImg;
 changed:boolean;
begin
 old_percent:=0;
 SetLength(Result,Length(oldTables));
 for z:=0 to Length(oldTables)-1 do begin

  //Set common image table params
  Result[z].tableStart:=newTables[z].tableStart;
  Result[z].pheader:=newTables[z].pheader;
  Result[z].numIcons:=newTables[z].numIcons;
  Result[z].offset:=newTables[z].offset;
  Result[z].picbase:=newTables[z].picbase;
  Result[z].names:=newTables[z].names;
  Result[z].offsettable:=newTables[z].offsettable;
  SetLength(Result[z].Images,Length(oldTables[z].Images));

  //Now compare images
  TotalImages:=Length(oldTables[z].Images);
  for i:=0 to TotalImages-1 do begin

   //Update progress
   percent:=Round(i/TotalImages*100);
   if (percent-old_percent)>5 then begin
    old_percent:=percent;
    prProc(_('Comparing image table')+': '+IntToStr(i)+'/'+IntToStr(TotalImages)+'...',percent);
   end;

   //Load images
   changed:=false;
   GetImgFromArray(FData,oldTables[z],i);
   GetImgFromArray(FpatchedData,newTables[z],i);
   imold:=oldTables[z].Images[i];
   imnew:=newTables[z].Images[i];

   //Compare images
   if imold.imType<>imnew.imType then
    changed:=true;
   if not changed then if imold.orig_offset<>imnew.orig_offset then
    changed:=true;
   if not changed then if imold.Space<>imnew.Space then
    changed:=true;
   if not changed then if imold.im_width<>imnew.im_width then
    changed:=true;
   if not changed then if imold.im_height<>imnew.im_height then
    changed:=true;
   if not changed then if imold.name<>imnew.name then
    changed:=true;
   //if not changed then if not CompareMem(PByte(Integer(FData)+imold.orig_offset),PByte(Integer(FpatchedData)+imnew.orig_offset),imold.Space) then
   // changed:=true;
   if not changed then begin
    imnew.RAWData:=GetRAWData(FpatchedData,newTables[z],imnew);
    imold.RAWData:=GetRAWData(FData,oldTables[z],imold);
    if not EqualArrays(imnew.RAWData,imold.RAWData) then
     changed:=true;
   end;
   if changed then begin

    //set RAW data for new image
    imnew.RAWData:=GetRAWData(FpatchedData,newTables[z],imnew);

    //set replaced flag
    imnew.replaced:=true;

    //image may be deleted, check it
    if (imnew.Image.Width=1) and (imnew.Image.Height=1) then begin
     if PLongWord(imnew.Image.PixelPointers[0,0])^=
          PLongWord(deletedImg.PixelPointers[0,0])^ then begin

      //it is deleted
      imnew.replaced:=false;
      imnew.deleted:=true;
     end;
    end;
   end;

   //Save image to result array
   imnew.orig_offset:=imold.orig_offset;
   imnew.Space:=imold.Space;
   Result[z].Images[i]:=imnew;
  end;
  prProc(_('Comparing image table')+': '+IntToStr(TotalImages)+'/'+IntToStr(TotalImages)+'...',100);
 end;
end;

end.

