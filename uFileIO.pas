unit uFileIO;

interface

uses uTypes, SysUtils, Windows, gnugettext, Classes, Math;

{.$DEFINE USEdb3150}

type
 TPlatformVersion=(unknown,db2010,db2020,db3150);

var
 FRealData:PByte;
 FData:PByte;
 CXCOffset:integer;
 iFileLen:integer;
 imgbase:DWORD=$44140000;
 platform_version:TPlatformVersion;
 loadedBABE:boolean;

function LoadFW(Log:TStrings;fName:TFileName;prProc:TProgressProc):TResData;
function GenTempFileName: TFileName;
function ReadFileToMem(fName: string;prProc:TProgressProc):TmByteArray;
procedure WriteMemToFile(const fName:string; const fw: TmByteArray);

implementation

type
 TBABEHDR = record
  babefile: WORD; (*0x0 *)
  x: BYTE; (*0x2 *)
  headerver: BYTE; (*0x3 *)
  colorfile: DWORD; (*0x4 *)
  platformfile: DWORD; (*0x8 *)
  bootrom: DWORD; (*0xc *)
  cidfile: DWORD; (*0x10 *)
  x2: DWORD; (*0x14 *)
  x3: array [0..Pred(9)] of DWORD; (*0x18 *)
  certplace: array [0..Pred(488)] of BYTE; (*0x3C *)
  prologuestart: DWORD; (*0x224 *)
  prologuesize1: DWORD; (*0x228 *)
  prologuesize2: DWORD; (*0x22C *)
  x4: array [0..Pred(4)] of DWORD; (*0x230 *)
  hash: array [0..Pred(128)] of BYTE; (*0x240 *)
  x5: array [0..Pred(5)] of DWORD; (*0x2C0 *)
  x6: DWORD; (*0x2D4 *)
  x7: array [0..Pred(3)] of DWORD; (*0x2D8 *)
  payloadstart: DWORD; (*0x2E4 *)
  numblocks: DWORD; (*0x2E8 *)
  payloadsize2: DWORD; (*0x2EC *)
  x8: array [0..Pred(4)] of DWORD; (*0x2F0 *)
  hash2: array [0..Pred(128)] of BYTE; (*0x300 *)
end;

var
 hRAWFile:Integer;
 hMemFile:THandle;

function LoadFW(Log:TStrings;fName:TFileName;prProc:TProgressProc):TResData;
var
 FmbnData:PByte;
 FmbnByte:PByte;
 Dst:PByte;
 babeHdr:TBABEHDR;
 i:Integer;
 newSize:DWORD;
 BlockAddr,BlockLen,LastBlockAddr,LastBlockLen:DWORD;
 //
 percent,oldpercent:integer;
{$IFDEF USEdb3150}
 //
 FmbnTempByte:PByte;
 DB3150Offset:DWORD;
 is_db3150:boolean;
 mbnFileSize:Int64;
{$ENDIF}
 //CXC
 tmpWindow:PAnsiChar;
 sigLen:integer;
begin
 platform_version:=unknown;
 if FRealData<>nil then begin
  if loadedBABE then
   FreeMem(FRealData)
  else
   UnmapViewOfFile(FRealData);
  FRealData:=nil;
 end;
 loadedBABE:=false;
 hRAWFile:=FileOpen(fName,fmOpenRead or fmShareDenyWrite);
 if hRAWFile<=0 then
  raise Exception.Create(_('Failed to open RAW file'));
 iFileLen:=GetFileSize(hRAWFile,nil);
 hMemFile:=CreateFileMapping(hRAWFile,nil,PAGE_READONLY,0,0,nil);
 if hMemFile=0 then
  raise Exception.Create(_('Failed to open RAW file'));
 CloseHandle(hRAWFile);
 CXCOffset:=0;
 if ExtractFileExt(AnsiUpperCaseFileName(fName))='.MBN' then begin
  prProc(_('Loading BABE...'),0);
  Log.Add('--------------- Trying to open BABE... ---------------');
{$IFDEF USEdb3150}
  mbnFileSize:=GetFileSize(hMemFile,nil);
{$ENDIF}
  FmbnData:=MapViewOfFile(hMemFile,FILE_MAP_READ,0,0,0);
  if FmbnData=nil then
   raise Exception.Create(_('Cannot read MBN file'));
  FmbnByte:=FmbnData;
{$IFDEF USEdb3150}
  //DB3150
  is_db3150:=false;
  FmbnTempByte:=FmbnByte;
  inc(FmbnTempByte,$50);
  DB3150Offset:=PDWord(FmbnTempByte)^;
  if DB3150Offset<>$FFFFFFFF then begin
   if (DB3150Offset mod 8)<>0 then
    DB3150Offset:=DB3150Offset+(DB3150Offset mod 8);
   Log.Add(Format('Found db3150, offset: $%s',[IntToHex(DB3150Offset,6)]));
   is_db3150:=true;
   platform_version:=db3150;
   inc(FmbnData,DB3150Offset);
  end;
  //End
{$ENDIF}
  babeHdr.babefile:=PWord(FmbnByte)^;
{$IFDEF USEdb3150}
  if not is_db3150 then begin
{$ENDIF}
  with babeHdr do begin
   babefile:=PWord(FmbnByte)^;
   inc(FmbnByte,sizeof(babefile));
   x:=FmbnByte^;
   inc(FmbnByte,sizeof(x));
   headerver:=FmbnByte^;
   inc(FmbnByte,sizeof(headerver));
   colorfile:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(colorfile));
   platformfile:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(platformfile));
   bootrom:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(bootrom));
   cidfile:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(cidfile));
   x2:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(x2));
   for i:=0 to Pred(9) do begin
    x3[i]:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(x3[i]));
   end;
   for i:=0 to Pred(488) do begin
    certplace[i]:=FmbnByte^;
    inc(FmbnByte,sizeof(certplace[i]));
   end;
   prologuestart:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(prologuestart));
   prologuesize1:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(prologuesize1));
   prologuesize2:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(prologuesize2));
   for i:=0 to Pred(4) do begin
    x4[i]:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(x4[i]));
   end;
   for i:=0 to Pred(128) do begin
    hash[i]:=FmbnByte^;
    inc(FmbnByte,sizeof(hash[i]));
   end;
   for i:=0 to Pred(5) do begin
    x5[i]:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(x5[i]));
   end;
   x6:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(x6));
   for i:=0 to Pred(3) do begin
    x7[i]:=PDword(FmbnByte)^;
    inc(FmbnByte,sizeof(x7[i]));
   end;
   payloadstart:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(payloadstart));
   numblocks:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(numblocks));
   payloadsize2:=PDWord(FmbnByte)^;
   inc(FmbnByte,sizeof(payloadsize2));
   for i:=0 to Pred(4) do begin
    x8[i]:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(x8[i]));
   end;
   for i:=0 to Pred(128) do begin
    hash2[i]:=FmbnByte^;
    inc(FmbnByte,1);
   end;
  end;
  Log.Add(Format('Opened as BABE, '+
        'version: %d; '+
        'CID: %d; '+
        'numblocks: %d;',
        [babeHdr.headerver,
        babeHdr.cidfile,
        babeHdr.numblocks]));
  loadedBABE:=true;
{$IFDEF USEdb3150}
  end;
{$ENDIF}
  FmbnByte:=nil;
  if babeHdr.babefile<>$BEBA then begin
   UnmapViewOfFile(FmbnData);
   FmbnData:=nil;
   raise Exception.Create(_('It''s not a BABE file or it is corrupted, cannot open!'));
   Exit;
  end;
{$IFDEF USEdb3150}
  if is_db3150 then begin
   newSize:=0;
   i:=DB3150Offset;
   imgbase:=0;
   FmbnByte:=FmbnData;
   while i<mbnFileSize do begin
    BlockAddr:=PDWord(FmbnByte)^;
    if imgbase=0 then imgbase:=BlockAddr;
    inc(FmbnByte,sizeof(BlockAddr));
    BlockLen:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(BlockLen));
    newSize:=newSize+BlockLen;
    ReallocMem(FRealData,newSize);
    if BlockAddr=0 then break;
    Dst:=PByte(DWORD(FRealData)+BlockAddr-imgbase);
    CopyMemory(Dst,FmbnByte,BlockLen);
    inc(FmbnByte,BlockLen);
    i:=i+Int64(BlockLen);
   end;
   imgbase:=$10000000;
   iFileLen:=newSize;
  end else
{$ENDIF}
  if (babeHdr.headerver = 3) or (babeHdr.headerver = 4) then begin
   FmbnByte:=FmbnData;
   if babeHdr.headerver = 3 then
    inc(FmbnByte,babeHdr.numblocks+$380)
   else
    inc(FmbnByte,babeHdr.numblocks*20+$380);
   FRealData:=nil;
   newSize:=0;
   LastBlockLen:=0;
   LastBlockAddr:=0;
   imgbase:=PDWord(FmbnByte)^;
   Log.Add('Image base: $'+IntToHex(imgbase,8));
   oldpercent:=0;
   for i:=0 to babeHdr.numblocks-1 do begin
    percent:=Round(i/babeHdr.numblocks*100);
    if (percent-oldpercent)>5 then begin
     oldpercent:=percent;
     prProc(_('Loading BABE...'),percent);
    end;
    BlockAddr:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(BlockAddr));
    BlockLen:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(BlockLen));
//    Log.Add(Format('Block %d at %s, length %s',[i,IntToHex(BlockAddr,8),IntToHex(BlockLen,2)]));
    if i>0 then begin
     if LastBlockAddr+LastBlockLen<>BlockAddr then
      newSize:=newSize+(BlockAddr-(LastBlockAddr+LastBlockLen));
    end;
    newSize:=newSize+BlockLen;
    LastBlockAddr:=BlockAddr;
    LastBlockLen:=BlockLen;
    ReallocMem(FRealData,newSize);
    Dst:=PByte(DWORD(FRealData)+BlockAddr-imgbase);
    CopyMemory(Dst,FmbnByte,BlockLen);
    inc(FmbnByte,BlockLen);
   end;
   iFileLen:=newSize;
   FData:=FRealData;
  end else begin
   UnmapViewOfFile(FmbnData);
   FmbnData:=nil;
   raise Exception.Create(Format(_('Not supported BABE version: %d'),[babeHdr.headerver]));
   Exit;
  end;
  UnmapViewOfFile(FmbnData);
  Log.Add('----------------------- Ok ---------------------------');
 end else if ExtractFileExt(AnsiUpperCaseFileName(fName))='.CXC' then begin
  prProc(_('Loading CXC...'),0);
  Log.Add('--------------- Trying to open CXC... ----------------');
  FRealData:=MapViewOfFile(hMemFile,FILE_MAP_READ,0,0,0);
  if FRealData=nil then
   raise Exception.Create(_('Cannot read CXC file'));

  tmpWindow:='App CXC';
  sigLen:=Length(tmpWindow);
  for i:=0 to iFileLen-1-sigLen-5 do begin
   if CompareMem(tmpWindow,Pointer(Integer(FRealData)+i),sigLen) then begin
    CXCOffset:=i;
    break;
   end;
  end;
  if CXCOffset=0 then
   Log.Add('WARNING!!! Looks like this CXC has no firmware data!!!');
  for i:=CXCOffset to iFileLen-4 do begin
   if (PByte(Integer(FRealData)+i+1)^=$F0) and
      (PByte(Integer(FRealData)+i+2)^=$9F) and
      (PByte(Integer(FRealData)+i+3)^=$E5) and
      (PByte(Integer(FRealData)+i+5)^=$F0) and
      (PByte(Integer(FRealData)+i+6)^=$9F) and
      (PByte(Integer(FRealData)+i+7)^=$E5) and
      (PByte(Integer(FRealData)+i+9)^=$F0) and
      (PByte(Integer(FRealData)+i+10)^=$9F) and
      (PByte(Integer(FRealData)+i+11)^=$E5) then begin
    CXCOffset:=i;
    break;
   end;
  end;
  Log.Add(Format('Data offset: $%s',[IntToHex(CXCOffset,6)]));
  imgbase:=PDWord(Integer(FRealData)+CXCOffset+8+PByte(Integer(FRealData)+CXCOffset)^)^;
  imgbase:=StrToInt('$'+Copy(IntToHex(imgbase,10),1,8)+'00');
  Log.Add(Format('Loading base: $%s',[IntToHex(imgbase,6)]));
  FData:=FRealData;
  iFileLen:=iFileLen-CXCOffset;
  inc(FData,CXCOffset);
  platform_version:=db3150;
  Log.Add('----------------------- Ok ---------------------------');
 end else begin
  imgbase:=$44140000;
  FRealData:=MapViewOfFile(hMemFile,FILE_MAP_READ,0,0,0);
  if FRealData=nil then
   raise Exception.Create(_('Cannot read RAW file'));
  FData:=FRealData;
 end;
 CloseHandle(hMemFile);
 Result.PByteRes:=FRealData;
 Result.iRes:=iFileLen;
end;

function GenTempFileName: TFileName;
var
 Buf:PAnsiChar;
 tmpPath:string;
begin
 Randomize;
 Buf:=StrAlloc(255);
 GetTempPath(255,Buf);
 tmpPath:=Buf;
 StrDispose(Buf);
 Buf:=StrAlloc(255);
 GetTempFileName(PAnsiChar(tmpPath),'mag',RandomRange(0,MaxInt),Buf);
 tmpPath:=Buf;
 Result:=ChangeFileExt(tmpPath,'.png');
end;

function ReadFileToMem(fName: string;prProc:TProgressProc):TmByteArray;
var
 f:file;
 NumRead,Len,i,idx:Integer;
 Buf:array[0..64767] of byte;
 percent,oldPosition:Integer;
begin
 prProc(_('Loading file...'),0);
 AssignFile(f,fName);
 FileMode:=0;
 Reset(f,1);
 Len:=FileSize(f);
 SetLength(Result,Len);
 idx:=0;
 oldPosition:=0;
 FillChar(Buf,sizeof(buf),0);
 repeat
  BlockRead(f,Buf,sizeof(Buf),NumRead);
  for i:=idx to idx+NumRead-1 do begin
   Result[i]:=Buf[i-idx];
  end;
  idx:=idx+NumRead;
  percent:=Round((idx/Len)*100);
  if oldPosition<>percent then begin
   prProc(_('Reading file...'),percent);
   oldPosition:=percent;
  end;
 until (NumRead=0);
 CloseFile(f);
 prProc(_('Reading file...'),100);
end;

procedure WriteMemToFile(const fName:string; const fw: TmByteArray);
var
 Buf:array[0..64767] of byte;
 i,j:LongInt;
 f:file;
begin
 AssignFile(f,fName);
 FileMode:=2;
 Rewrite(f,1);
 i:=0;
 while i<(Length(fw)-sizeof(Buf)) do begin
  for j:=0 to sizeof(Buf)-1 do begin
   Buf[j]:=fw[i+j];
  end;
  BlockWrite(f,Buf,sizeof(Buf));
  i:=i+sizeof(Buf);
 end;
 for j:=0 to Length(fw)-i-1 do begin
  Buf[j]:=fw[i+j];
 end;
 BlockWrite(f,Buf,Length(fw)-i);
 CloseFile(f);
end;

end.
