unit uByteUtils;

interface

uses
 windows,SysUtils,zlibex123;

type
  TByteArray=packed array of byte;

function GetWORD(const fw:TByteArray; const addr:Cardinal):DWORD;overload;
function GetWORD(const P:PByte; const addr:Cardinal):DWORD;overload;
function GetDWORD(const P:PByte; const addr:Cardinal):DWORD;overload;
function Get3Bytes(const fw:TByteArray; const addr:Cardinal):LongInt;overload;
function Get3Bytes(const P:PByte; const addr:Cardinal):LongInt;overload;
function GetByte(const P:PByte; const addr:Cardinal):Byte;
function DecompressImg(const P:PByte; const addr:Cardinal; const BufLen:Cardinal; out len:LongInt; const stOffset:Integer=12):string;
procedure SetByte(const P:PByte; const addr:Cardinal; const val:byte);

implementation

function GetWORD(const fw: TByteArray;
  const addr: Cardinal): DWORD;
var
 byte1,byte2:string;
begin
 byte1:=IntToHex(fw[addr],2);
 byte2:=IntToHex(fw[addr+1],2);
 Result:=StrToInt('$'+byte2+byte1);
end;

function GetWORD(const P: PByte; const addr: Cardinal): DWORD;
var
 b1:Byte;
 pn:PByte;
 byte1,byte2:string;
begin
 pn:=Pointer(Cardinal(P)+addr);
 b1:=pn^;
 byte1:=IntToHex(b1,2);
 pn:=Pointer(Cardinal(P)+addr+1);
 b1:=pn^;
 byte2:=IntToHex(b1,2);
 Result:=StrToInt('$'+byte2+byte1);
end;

function GetDWORD(const P: PByte; const addr: Cardinal): DWORD;
var
 pn:PDWORD;
begin
 pn:=Pointer(Cardinal(P)+addr);
 Result:=pn^;
end;

function Get3Bytes(const fw: TByteArray;
  const addr: Cardinal): LongInt;
var
 byte1,byte2,byte3:string;
begin
 byte1:=IntToHex(fw[addr],2);
 byte2:=IntToHex(fw[addr+1],2);
 byte3:=IntToHex(fw[addr+2],2);
 Result:=StrToInt('$'+byte3+byte2+byte1);
end;

function Get3Bytes(const P: PByte; const addr: Cardinal): LongInt;
var
 b1:Byte;
 pn:PByte;
 byte1,byte2,byte3:string;
begin
 pn:=Pointer(Cardinal(P)+addr);
 b1:=pn^;
 byte1:=IntToHex(b1,2);
 pn:=Pointer(Cardinal(P)+addr+1);
 b1:=pn^;
 byte2:=IntToHex(b1,2);
 pn:=Pointer(Cardinal(P)+addr+2);
 b1:=pn^;
 byte3:=IntToHex(b1,2);
 Result:=StrToInt('$'+byte3+byte2+byte1);
end;

function GetByte(const P: PByte; const addr: Cardinal): Byte;
var
 pn:PByte;
begin
 pn:=Pointer(Cardinal(P)+addr);
 Result:=pn^;
end;

procedure SetByte(const P:PByte; const addr:Cardinal; const val:byte);
var
 pn:PByte;
begin
 pn:=Pointer(Cardinal(P)+addr);
 pn^:=val;
end;

function DecompressImg(const P:PByte; const addr:Cardinal; const BufLen:Cardinal; out len:LongInt; const stOffset:Integer=12):string;
var
 P2:PByte;
begin
 P2:=P;
 inc(P2,addr+stOffset);
 Result:=ZMyDecompressBufToStr(P2,BufLen,len);
end;

end.
