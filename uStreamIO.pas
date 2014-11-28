unit uStreamIO;

interface

uses SysUtils, Classes, Forms;

type
  TByteArray=array of byte;

procedure WriteBlock(const f:file;const intValue:LongInt);overload;
procedure WriteBlock(const f:file;const strValue:string);overload;
procedure WriteMemToFile(const f:file; const fw: TByteArray);

procedure sWriteBlock(const f:TStream;const intValue:LongInt);overload;
procedure sWriteBlock(const f:TStream;const strValue:string);overload;
procedure sWriteMemToFile(const f:TStream; const fw: TByteArray);
function sReadBlock(const ms:TStream):string;

implementation

procedure WriteMemToFile(const f:file; const fw: TByteArray);
var
 Buf:array[0..64767] of byte;
 i,j:LongInt;
begin
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
end;

procedure WriteBlock(const f:file;const intValue:LongInt);
var
 tmpStr:string;
begin
 tmpStr:=IntToStr(intValue);
 WriteBlock(f,tmpStr);
end;

procedure WriteBlock(const f:file;const strValue:string);
var
 Buf:TByteArray;
 i:integer;
 len:LongInt;
 BlockLen:string[10];
begin
 len:=Length(strValue);
 BlockLen:='          ';
 BlockLen:=IntToStr(len);
 SetLength(Buf,len+10);
 for i:=0 to 9 do
  Buf[i]:=ord(BlockLen[i]);
 for i:=0 to len-1 do
  Buf[i+10]:=ord(strValue[i+1]);
 WriteMemToFile(f,Buf);
end;

procedure sWriteMemToFile(const f:TStream; const fw: TByteArray);
var
 Buf:array[0..64767] of byte;
 i,j:LongInt;
begin
 i:=0;
 while i<(Length(fw)-sizeof(Buf)) do begin
  for j:=0 to sizeof(Buf)-1 do begin
   Buf[j]:=fw[i+j];
  end;
  f.WriteBuffer(Buf,sizeof(Buf));
  i:=i+sizeof(Buf);
 end;
 for j:=0 to Length(fw)-i-1 do begin
  Buf[j]:=fw[i+j];
 end;
 f.WriteBuffer(Buf,Length(fw)-i);
end;

procedure sWriteBlock(const f:TStream;const intValue:LongInt);
var
 tmpStr:string;
begin
 tmpStr:=IntToStr(intValue);
 sWriteBlock(f,tmpStr);
end;

procedure sWriteBlock(const f:TStream;const strValue:string);
var
 Buf:TByteArray;
 i:integer;
 len:LongInt;
 BlockLen:string[10];
begin
 len:=Length(strValue);
 BlockLen:='          ';
 BlockLen:=IntToStr(len);
 SetLength(Buf,len+10);
 for i:=0 to 9 do
  Buf[i]:=ord(BlockLen[i]);
 for i:=0 to len-1 do
  Buf[i+10]:=ord(strValue[i+1]);
 sWriteMemToFile(f,Buf);
end;

function sReadBlock(const ms:TStream):string;
var
 BlockLen:string[10];
 tmpStr:string;
 Len:integer;
 strStr:TStringStream;
begin
 ms.Read(BlockLen,10);
 Len:=StrToInt(BlockLen);
 tmpStr:='';
 Application.ProcessMessages;
 strStr:=TStringStream.Create('');
 strStr.CopyFrom(ms,Len);
 Result:=strStr.DataString;
 strStr.Free;
end;

end.
