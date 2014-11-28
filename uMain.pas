unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sAlphaListBox, ComCtrls, acProgressBar,
  ExtCtrls, sMemo, pngImage, Contnrs, sStatusBar, ExtDlgs, sSkinProvider,
  sSkinManager, sSplitter, sPanel, sLabel, Menus, ShellAPI,
  JvFormPlacement, JvComponentBase, JvAppStorage, JvAppRegistryStorage,
  sCheckBox, sEdit, sSpinEdit, JclMiscel, sComboBox, AbZlTyp, ZlibEx123,
  Buttons, sBitBtn, sHintManager, sBevel, gnugettext, sRadioButton,
  JclCompression, sGroupBox, uStreamIO, JvSearchFiles, languagecodes;

type
  TByteArray=packed array of byte;
  TImgType=(imPNG,imPKI);
  TfwImage=class(TObject)
  private
    fStartAddress:LongInt;
    fEndAddress:LongInt;
    Fim_width:Integer;
    Fim_height:Integer;
    FChanged:boolean;
    FimRealSize:LongInt;
    FimDataSize:LongInt;
    FEmpty:boolean;
    fOffset:LongInt;
    function GetImgLength:LongInt;
  public
    imgType:TImgType;
    property StartAddress: LongInt read fStartAddress write fStartAddress;
    property EndAddress: LongInt read fEndAddress write fEndAddress;
    property ImgLength: LongInt read GetImgLength;
    property Empty: boolean read FEmpty write FEmpty;
    function FindEndAddress(const fw:TByteArray):LongInt;
    function GetPicture(const fw:TByteArray):TPNGObject;
    procedure SaveRAW(const fw:TByteArray;fName:string);
    procedure SetPicture(var fw:TByteArray;const Buffer:TByteArray; const im_width,im_height: integer);
    procedure SaveToFile(const fw:TByteArray;const fName:TFileName; FixColors:boolean=false);
    constructor Create(const fw:TByteArray;const stAddress:LongInt; const len: Integer; imType:TImgType; const offset:LongInt);overload;
    constructor Create();overload;
    procedure CopyFrom(const fwFrom:TByteArray; const fwTo:TByteArray);
    function GetPackedPicture(fw:TByteArray):TByteArray;
    procedure UpdateSize(fw:TByteArray);
    procedure Assign(im:TfwImage);
    function SaveToString:string;
    procedure LoadFromString(Str:string);
  end;
  TimgBounds=class(TObject)
    iStart,iEnd:LongInt;
  end;
  TimgBoundsList=class(TObjectList)
  private
    function GetItem(Index: Integer): TimgBounds;
    procedure SetItem(Index: Integer; const Value: TimgBounds);
  public
    property Items[Index: Integer]: TimgBounds read GetItem write SetItem; default;
  end;
  TAlphaColor=record
    r:integer;
    g:integer;
    b:integer;
    a:integer;
  end;
  TScanlineTypeReturn = (stByteArray, stRGBLine);
  TfmMain = class(TForm)
    OpenDialog1: TOpenDialog;
    sbStatus: TsStatusBar;
    SaveDialog1: TSaveDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    pbProgress: TsProgressBar;
    tmHideProgress: TTimer;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sPanel1: TsPanel;
    btOpenFw: TsBitBtn;
    btReplaceImg: TsBitBtn;
    btSaveImg: TsBitBtn;
    sPanel2: TsPanel;
    lbImages: TsListBox;
    sSplitter1: TsSplitter;
    btMakeVKP: TsBitBtn;
    sPanel3: TsPanel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Z0068535980301: TMenuItem;
    R4284232349151: TMenuItem;
    U7785587523021: TMenuItem;
    sPanel4: TsPanel;
    N2: TMenuItem;
    N3: TMenuItem;
    JvAppRegistryStorage1: TJvAppRegistryStorage;
    JvFormStorage1: TJvFormStorage;
    tmSlideForm: TTimer;
    seThumbHeight: TsSpinEdit;
    cbStretchPreview: TsCheckBox;
    sLabel1: TsLabel;
    N49528031: TMenuItem;
    cbFixColors: TsCheckBox;
    cbSkins: TsComboBox;
    pnAbout: TsPanel;
    lbAbout: TsLabelFX;
    seLoadFrom: TsSpinEdit;
    seLoadTo: TsSpinEdit;
    sLabel2: TsLabel;
    sHintManager1: TsHintManager;
    sLabel4: TsLabel;
    sLabel3: TsLabel;
    sBevel1: TsBevel;
    sBevel2: TsBevel;
    sBevel3: TsBevel;
    cbLanguage: TsComboBox;
    sLabel5: TsLabel;
    Button1: TButton;
    Button2: TButton;
    imArrow: TImage;
    gbOriginal: TsGroupBox;
    imOriginal: TImage;
    gbPreview: TsGroupBox;
    imPreview: TImage;
    btRestoreOriginal: TsBitBtn;
    lbOrigImageInfo: TLabel;
    lbImageInfo: TLabel;
    btSaveOrig: TsBitBtn;
    btSaveRepl: TsBitBtn;
    btOpenOrig: TsBitBtn;
    btOpenRepl: TsBitBtn;
    pnDevControls: TsPanel;
    btTest: TsBitBtn;
    btSaveFw: TsBitBtn;
    btClearFW: TsBitBtn;
    btFreeSpaceLog: TsBitBtn;
    btLoadProject: TsBitBtn;
    btSaveProject: TsBitBtn;
    sBevel4: TsBevel;
    sBevel5: TsBevel;
    sfSearch: TJvSearchFiles;
    btDelImg: TsBitBtn;
    sMemo1: TsMemo;
    procedure btOpenFwClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbImagesClick(Sender: TObject);
    procedure btSaveFwClick(Sender: TObject);
    procedure btReplaceImgClick(Sender: TObject);
    procedure btSaveImgClick(Sender: TObject);
    procedure tmHideProgressTimer(Sender: TObject);
    procedure btMakeVKPClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Z0068535980301Click(Sender: TObject);
    procedure tmSlideFormTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbImagesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure seThumbHeightChange(Sender: TObject);
    procedure cbStretchPreviewClick(Sender: TObject);
    procedure JvFormStorage1AfterRestorePlacement(Sender: TObject);
    procedure JvFormStorage1AfterSavePlacement(Sender: TObject);
    procedure cbSkinsChange(Sender: TObject);
    procedure sSkinManager1AfterChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure JvFormStorage1RestorePlacement(Sender: TObject);
    procedure JvFormStorage1SavePlacement(Sender: TObject);
    procedure cbLanguageChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btRestoreOriginalClick(Sender: TObject);
    procedure btTestClick(Sender: TObject);
    procedure btSaveOrigClick(Sender: TObject);
    procedure btSaveReplClick(Sender: TObject);
    procedure btOpenOrigClick(Sender: TObject);
    procedure btOpenReplClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btClearFWClick(Sender: TObject);
    procedure btFreeSpaceLogClick(Sender: TObject);
    procedure btSaveProjectClick(Sender: TObject);
    procedure btLoadProjectClick(Sender: TObject);
    procedure btDelImgClick(Sender: TObject);
  private
    { Private declarations }
    StartPNGAddreses:TStrings;
    fwImages:TObjectList;
    fwImagesOrig:TObjectList;
    fixedPNGImages:TObjectList;
    fw:TByteArray;
    fwOrig:TByteArray;
    imgOffsets:TStringList;
    function ReadFileToMem(fName:string):TByteArray;
    procedure WriteMemToFile(fName:string;const fw:TByteArray);
//    procedure SearchForPNGs(const fw:TByteArray);
    procedure DisableForm;
    procedure EnableForm;
    procedure ClearForm;
    function GenerateVKP(const fwSrc,fwMod:TByteArray):TStrings;
    function SwapRGBtpBGR(color:TColor):TColor;
    function GenTempFileName:TFileName;
    procedure OptimizeImg(fName:TFileName);
//    procedure ExtractPNGOut(path:string);
//    procedure ExtractApfZapf(path:string);
    procedure CopyAlpha(var src:TPNGObject;var dst:TPNGObject);
    function FixImageColors(img:TPNGObject):TPNGObject;
    procedure FixPNGs;
    procedure ReadImgTable(const fw:TByteArray);
    function GetDWORD(const fw:TByteArray; const addr:Cardinal):DWORD;
    function Get3Bytes(const fw:TByteArray; const addr:Cardinal):LongInt;
    function CreatePatchPreview:TPNGObject;
    procedure DrawPNG(dst:TPNGObject;const src:TPNGObject;Left,Top:integer);
    //
    procedure ConvertToRGBA(fName:TFileName);
  public
    { Public declarations }
  end;

const
  swversion='1.54 (c) 2008 Magister';
  iVersion=154;
  imgbase=$44140000;

var
  fmMain: TfmMain;
  footer:string[8];
  headerPNG:string[16];
  headerGIF:string[6];
  fwFileName:string;
  Stop:boolean=true;
  StopSlide:boolean=false;
  Languages:TStringList;
  FreeBlocks:array of TfwImage;

implementation

uses StrUtils, Math, uWaitForm, DateUtils;

{$R *.dfm}
//{$R pngout.res}
//{$R apfzapf.res}
{$R empty.res}

{Get translation converted to string}
function _(msgid:WideString):AnsiString;overload;
begin
 Result:=gnugettext._(msgid);
end;

function SplitString(str,separator: string): TStringList;
var
 lst:TStringList;
 sPos:integer;
 tStr:string;
begin
 str:=Trim(str);
 lst:=TStringList.Create;
 while Length(Trim(str))>0 do begin
  str:=Trim(str);
  sPos:=Pos(separator,str);
  if sPos<1 then begin
   lst.Add(str);
   str:='';
  end else begin
   tStr:=Copy(str,0,sPos-1);
   lst.Add(tStr);
   str:=Copy(str,sPos+Length(separator),Length(str));
  end;
 end;
 Result:=lst;
end;

function UnZlib(fStream:TStream; out read:LongInt):TByteArray;overload;
var
 mOutStream:TMemoryStream;
 Count:integer;
 resBuf:TByteArray;
 dzStream:TZDecompressionStream;
 Buffer: array [0..1023] of Byte;
begin
 fStream.Seek(0,soFromBeginning);
 mOutStream:=TMemoryStream.Create;
  mOutStream.Clear;
  fStream.Seek(0,soFromBeginning);
  dzStream:=TZDecompressionStream.Create(fStream);
  try
   repeat
    Count := dzStream.Read(Buffer, SizeOf(Buffer));
    mOutStream.Write(Buffer, Count);
   until (Count = 0);
   read:=fStream.Position;
  finally
   dzStream.Free;
  end;
 mOutStream.Seek(0,soFromBeginning);
 SetLength(resBuf,mOutStream.Size);
 for Count:=0 to mOutStream.Size-1 do begin
  mOutStream.Read(resBuf[Count],1);
 end;
 mOutStream.Free;
 Result:=resBuf;
end;

function UnZlib(fw:TByteArray; stAddr:integer; out read:LongInt):string;overload;
var
 P:Pointer;
 P2:Pointer;
 i:LongInt;
 c:char;
begin
 P:=Pointer(LongInt(@fw)+stAddr-1);
 P2:=Pointer(LongInt(@fw)+sizeof(Integer)*3+stAddr);
 i:=LongInt(P)-LongInt(@fw);
 Move(P,c,1);
 Move(P2,c,1);
 fw[i-1]:=ord(c);
 fw[i]:=ord(c);
 fw[i+1]:=ord(c);
 Result:=ZMyDecompressBufToStr(P,Length(fw),read);
end;

function UnZlibBuf(Buf:TByteArray; out read:LongInt):TByteArray;
var
 fStream:TStringStream;
// zStream: TAbZLStreamHelper;
 mOutStream:TMemoryStream;
 Count:integer;
 resBuf:TByteArray;
 ReadWithDzLib:boolean;
 dzStream:TZDecompressionStream;
// FileStreamSize:LongInt;
 Buffer: array [0..1023] of Byte;
begin
 ReadWithDzLib:=true;
 mOutStream:=TMemoryStream.Create;
 fStream:=TStringStream.Create(String(Buf));
 fStream.Seek(0,soFromBeginning);
{ zStream:=TAbZLStreamHelper.Create(fStream);
 try
  try
   zStream.ReadHeader;
   zStream.ExtractItemData(mOutStream);
   zStream.ReadTail;
   read:=fStream.Position;
  except
   ReadWithDzLib:=true;
  end;
 finally
  zStream.Free;
//  fStream.Free;
 end;}
 if ReadWithDzLib then begin
  mOutStream.Clear;
//  fStream:=TStringStream.Create(str);
  fStream.Seek(0,soFromBeginning);
  dzStream:=TZDecompressionStream.Create(fStream);
  try
//   FileStreamSize := 0;
   repeat
    Count := dzStream.Read(Buffer, SizeOf(Buffer));
//    Inc(FileStreamSize, mOutStream.Write(Buffer, Count));
    mOutStream.Write(Buffer, Count);
   until (Count = 0);
   read:=fStream.Position;
  finally
   dzStream.Free;
//   fStream.Free;
  end;
 end;
 mOutStream.Seek(0,soFromBeginning);
 SetLength(resBuf,mOutStream.Size);
 for Count:=0 to mOutStream.Size-1 do begin
  mOutStream.Read(resBuf[Count],1);
 end;
 mOutStream.Free;
 fStream.Free;
 Result:=resBuf;
end;

function DoZlib(fStream:TStream;strategy:integer):TMemoryStream;
//function DoZlib(fStream:TStream;strategy:TZStrategy):TMemoryStream;
var
 zStream:TJclZLibCompressStream;
// zStream:TZCompressionStream;
 mOutStream:TMemoryStream;
begin
 mOutStream:=TMemoryStream.Create;
 fStream.Seek(0,soFromBeginning);
 zStream:=TJclZLibCompressStream.Create(mOutStream,9);
// zStream:=TZCompressionStream.Create(mOutStream,zcMax,15,9,strategy);
{ zStream.MemLevel:=9;
 zStream.WindowBits:=15;
 zStream.CompressionLevel:=9;
 zStream.Strategy:=strategy;}
 try
  zStream.CopyFrom(fStream,fStream.Size);
 finally
  zStream.Free;
 end;
 mOutStream.Seek(0,soFromBeginning);
 Result:=mOutStream;
end;

function Zlib(fStream:TStream):TByteArray;
var
 mOutStream:TMemoryStream;
 Count:integer;
 resBuf:TByteArray;
 def_ms{,filered_ms,huffman_ms,rle_ms}:TMemoryStream;
begin
 def_ms:=DoZlib(fStream,0);
{ filered_ms:=DoZlib(fStream,1);
 huffman_ms:=DoZlib(fStream,2);
 rle_ms:=DoZlib(fStream,3);}
// def_ms:=DoZlib(fStream,zsDefault);
// filered_ms:=DoZlib(fStream,zsFiltered);
// huffman_ms:=DoZlib(fStream,zsHuffman);
// rle_ms:=DoZlib(fStream,zsRLE);
 mOutStream:=def_ms;
{ if filered_ms.Size<mOutStream.Size then begin
  mOutStream.Free;
  mOutStream:=filered_ms;
 end else filered_ms.Free;
 if huffman_ms.Size<mOutStream.Size then begin
  mOutStream.Free;
  mOutStream:=huffman_ms;
 end else huffman_ms.Free;
 if rle_ms.Size<mOutStream.Size then begin
  mOutStream.Free;
  mOutStream:=rle_ms;
 end else rle_ms.Free;}
 SetLength(resBuf,mOutStream.Size);
 for Count:=0 to mOutStream.Size-1 do begin
  mOutStream.Read(resBuf[Count],1);
 end;
 mOutStream.Free;
 Result:=resBuf;
end;

{function Zlib(fStream:TStream):TByteArray;
var
 Buf:TByteArray;
 path,name,tmpcDir,outStr:string;
 exCode:Cardinal;
 fileStream:TFileStream;
 tmpfName:string;
begin
 tmpfName:=fmMain.GenTempFileName;
 fileStream:=TFileStream.Create(tmpfName,fmCreate);
 fileStream.CopyFrom(fStream,fStream.Size);
 fileStream.Free;
 path:=ExtractFilePath(tmpfName);
 name:=ExtractFileName(tmpfName);
 tmpcDir:=GetCurrentDir;
 SetCurrentDir(path);
 fmMain.ExtractApfZapf(path);
 exCode:=WinExec32AndRedirectOutput('apf2zapf.exe '+name,outStr);
 if exCode<>0 then begin
  MessageBox(Application.Handle, PAnsiChar(_('Помилка при стисканні зображення!'+#13+#10+'Код помилки: ')+IntToStr(exCode)+#13+#10+_('Повідомлення: ')+outStr), PChar(_('Помилка!')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
// WinExec32AndWait('pngout.exe /y /d0 /q '+name,SW_HIDE);
 DeleteFile('apf2zapf.exe');
 Buf:=fmMain.ReadFileToMem(tmpfName+'.zapf');
 SetCurrentDir(tmpcDir);
 Result:=Buf;
end;}

function LoadPacked(const fStream:TStream; const im_width,im_height: integer):TPNGObject;
var
 x,y:integer;
// rgba:array[0..3] of byte;
 rgba: byte;
 hex:string;
// FileLength:Integer;
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
end;

procedure DrawPacked(Buf:TByteArray;Canvas:TCanvas;im_width,im_height:integer);
var
 x,y,off:integer;
 r,g,b:integer;
begin
 x:=0;
 y:=0;
 off:=0;
 if (Length(Buf) mod 4)<>0 then
  ShowMessage('Error!'+#10#13+'Length: '+IntToStr(Length(Buf))+#10#13+'Div: '+IntToStr(Length(Buf) div 4));
 while off<Length(Buf)-1 do begin
  b:=Buf[off];
  g:=Buf[off+1];
  r:=Buf[off+2];
  Canvas.Pixels[x,y]:=RGB(r,g,b);
  x:=x+1;
  if x>=im_width then begin
   x:=0;
   y:=y+1;
  end;
  off:=off+4;
 end;
end;

function SavePacked(const img:TPNGObject):TByteArray;
var
 x,y:integer;
 im:TPNGObject;
{ rgbLine:TRGBLine;
 porgbLine:pRGBLine;
 rgbTripple:TRGBTriple;
 aScanLine:pngimage.TByteArray;}
 im_width,im_height:integer;
// fStream:TMemoryStream;
// hex:array[0..3] of byte;
 off:integer;
 col:TColor;
 SaveAlpha:boolean;
begin
// y:=0;
// fStream:=TMemoryStream.Create;
 im_width:=img.Width;
 im_height:=img.Height;
// im:=TPNGObject.CreateBlank(COLOR_RGB,8,im_width,im_height);
// im.CreateAlpha;
// img.Draw(im.Canvas,im.Canvas.ClipRect);
 im:=img;
 SaveAlpha:=true;
 if (im.Header.ColorType<>COLOR_RGBALPHA) and
    (im.Header.ColorType<>COLOR_GRAYSCALEALPHA) then begin
//  MessageBox(Application.Handle,PChar(_('Transparency is supported only for color types "RGBALPHA" and "GRAYSCALEALPHA"'+#10#13+'Image will be saved as non-transparent')),PChar(_('Transparency is not supported')),MB_OK or MB_ICONWARNING or MB_TASKMODAL);
  SaveAlpha:=false;
 end;
{ while (y<(im_height-1)) do begin
  rgbTripple.rgbtRed:=0;
  rgbTripple.rgbtGreen:=0;
  rgbTripple.rgbtBlue:=0;
  FillChar(aScanLine,sizeof(aScanLine),0);
  FillChar(rgbLine,sizeof(rgbLine),0);
  porgbLine:=@rgbLine;
  CopyMemory(porgbLine,im.Scanline[y],im_width*3);
  if (img.Header.ColorType=COLOR_RGBALPHA) or
     (img.Header.ColorType=COLOR_GRAYSCALEALPHA)then
  CopyMemory(@aScanLine,im.AlphaScanline[y],im_width);
  for x:=0 to im_width-1 do begin
   rgbTripple:=rgbLine[x];
   hex[0]:=rgbTripple.rgbtRed;
   hex[1]:=rgbTripple.rgbtGreen;
   hex[2]:=rgbTripple.rgbtBlue;
   hex[3]:=aScanLine[x];
   fStream.Write(hex,4);
  end;
  y:=y+1;
 end;
 SetLength(Result,fStream.Size);
 CopyMemory(Result,fStream.Memory,fStream.Size);}
 off:=0;
 SetLength(Result,im_width*im_height*4);
 for y:=0 to im_height-1 do begin
  for x:=0 to im_width-1 do begin
   col:=im.Pixels[x,y];
   Result[off]:=GetRValue(col);
   Result[off+1]:=GetGValue(col);
   Result[off+2]:=GetBValue(col);
   if SaveAlpha then
    Result[off+3]:=(im.AlphaScanline[y]^)[x]
   else
    Result[off+3]:=255;
   off:=off+4;
  end;
 end;
end;

procedure UnPackBW(const fw:TByteArray; adr : dword);
var
 xsz,ysz : byte;
 n:word;
 b:byte;
 x,y:byte;
begin
 x:=0;
 y:=0;
 b:=0;
 xsz:=fw[adr+1]; // берём размеры из хедэра
 ysz:=fw[adr+2];
 adr:=adr+6; // скипаем остальные запчасти хедэра
// if (pos('ICON',form1.PageControl2.Pages[form1.PageControl2.ActivePageIndex].Caption)=1) then inc (adr);
 inc (adr);
 n:=0;
 fmMain.imPreview.Picture.Bitmap.Height:=ysz;
 fmMain.imPreview.Picture.Bitmap.Width:=xsz;
 repeat // разматываем....
  if (n and 7)=0 then  begin
   b:=fw[adr];
   adr:=adr+1;
  end;
  n:=n+1;
  if (b and 1)=1 then
   fmMain.imPreview.Canvas.Pixels[x,y]:=clBlack
  else
   fmMain.imPreview.Canvas.Pixels[x,y]:=clWhite;
  b:=b shr 1;
  x:=x+1;
  if x=xsz then begin
   x:=0;
   y:=y+1;
  end;
 until((n>xsz*ysz));
end;

function TfmMain.ReadFileToMem(fName: string):TByteArray;
var
 f:file;
 NumRead,Len,i,idx:LongInt;
 Buf:array[0..64767] of byte;
 percent,oldPosition:integer;
begin
 sbStatus.Panels[0].Text:=_('Reading file...');
 AssignFile(f,fName);
 FileMode:=0;
 Reset(f,1);
 Len:=FileSize(f);
 SetLength(Result,Len);
 pbProgress.Max:=100;
 pbProgress.Position:=0;
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
   pbProgress.Position:=percent;
   oldPosition:=percent;
   Application.ProcessMessages;
  end;
 until (NumRead=0);
 CloseFile(f);
 pbProgress.Position:=100;
end;

procedure TfmMain.btOpenFwClick(Sender: TObject);
var
 ok:boolean;
begin
 if not Stop then begin
  Stop:=true;
  EnableForm;
  Exit;
 end;
 OpenDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not OpenDialog1.Execute then Exit;
 Stop:=false;
 DisableForm;
 StartPNGAddreses.Clear;
 lbImages.Clear;
 fwImages.Clear;
 fwImagesOrig.Clear;
 imgOffsets.Clear;
 fw:=ReadFileToMem(OpenDialog1.FileName);
 SetLength(fwOrig,Length(fw));
 CopyMemory(fwOrig,fw,Length(fw));
 fwFileName:=OpenDialog1.FileName;
 ReadImgTable(fw);
 if Stop then begin
  ClearForm;
  EnableForm;
  Exit;
 end;
// SearchForPNGs(fw);
 FixPNGs;
 if Stop then begin
  ClearForm;
  EnableForm;
  Exit;
 end;
 EnableForm;
 ok:=(lbImages.Count>0);
 if not ok then MessageBox(Application.Handle, PChar(_('Can''t found any image!'+#13+#10+'Maybe it''s not db2020 RAW firmware file?')), PChar(_('Error')), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
 if ok then lbImages.ItemIndex:=0;
 sbStatus.Panels[1].Text:=IntToStr(lbImages.Count)+_(' images found')+'    ';
 lbImagesClick(Self);
 lbImages.Repaint;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
 sl:TStrings;
 i:integer;
begin
 TP_GlobalIgnoreClass(TsSkinManager);
 TP_GlobalIgnoreClass(TJvFormStorage);
 TP_GlobalIgnoreClass(TJvAppRegistryStorage);
 TP_Ignore(Self,'cbLanguage');
 TP_Ignore(Self,'cbSkins');
 TP_GlobalIgnoreClass(TsSpinEdit);
 TP_IgnoreClassProperty(TfmMain,'Caption');
 TranslateComponent(Self);
 sSkinManager1.SkinDirectory:=ExtractFilePath(Application.ExeName)+'Skins';
 sl:=TStringList.Create;
 sSkinManager1.GetSkinNames(sl);
 cbSkins.Items.AddStrings(sl);
 sl.Free;
 fmMain.Caption:=fmMain.Caption+' v'+swversion;
 Application.Title:=Application.Title+' v'+swversion;
 fmMain.DoubleBuffered:=true;
 StartPNGAddreses:=TStringList.Create;
 fwImages:=TObjectList.Create;
 fwImagesOrig:=TObjectList.Create;
 fwImages.OwnsObjects:=true;
 fwImagesOrig.OwnsObjects:=true;
 fixedPNGImages:=TObjectList.Create;
 fixedPNGImages.OwnsObjects:=true;
 imgOffsets:=TStringList.Create;
 footer:=#$49#$45#$4E#$44#$AE#$42#$60#$82;
 headerPNG:=#$89#$50#$4E#$47#$0D#$0A#$1A#$0A#$00#$00#$00#$0D#$49#$48#$44#$52;
 headerGIF:='GIF89a';
 sfSearch.RootDirectory:=ExtractFilePath(Application.ExeName)+'locale';
 sfSearch.Search;
 Languages:=TStringList.Create;
 while sfSearch.Searching do Application.ProcessMessages;
 Languages.AddStrings(sfSearch.Directories);
 Languages.Sort;
 cbLanguage.Clear;
 for i:=0 to Languages.Count-1 do
  cbLanguage.Items.Add(getlanguagename(Languages[i]));
end;

procedure TfmMain.WriteMemToFile(fName: string; const fw: TByteArray);
var
 f:file;
 Buf:array[0..64767] of byte;
 i,j,Len:LongInt;
 percent,oldPosition:integer;
begin
 sbStatus.Panels[0].Text:=_('Saving file...');
 AssignFile(f,fName);
 FileMode:=2;
 Rewrite(f,1);
 Len:=Length(fw)-1;
 pbProgress.Min:=0;
 pbProgress.Max:=100;
 i:=0;
 oldPosition:=0;
 while i<(Length(fw)-sizeof(Buf)) do begin
  for j:=0 to sizeof(Buf)-1 do begin
   Buf[j]:=fw[i+j];
  end;
  BlockWrite(f,Buf,sizeof(Buf));
  i:=i+sizeof(Buf);
  percent:=Round((i/Len)*100);
  if oldPosition<>percent then begin
   pbProgress.Position:=percent;
   oldPosition:=percent;
   Application.ProcessMessages;
  end;
 end;
 for j:=0 to Length(fw)-i-1 do begin
  Buf[j]:=fw[i+j];
 end;
 BlockWrite(f,Buf,Length(fw)-i);
 CloseFile(f);
 pbProgress.Position:=100;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
 StartPNGAddreses.Free;
 fwImages.Free;
 fwImagesOrig.Free;
 fixedPNGImages.Free;
 imgOffsets.Free;
 Languages.Free;
end;

{procedure TfmMain.SearchForPNGs(const fw: TByteArray);
var
 i,j,Len:LongInt;
 tmpStr:string;
 im:TfwImage;
 percent,oldPosition:integer;
begin
 sbStatus.Panels[0].Text:='Пошук зображень...';
 pbProgress.Position:=0;
 pbProgress.Min:=0;
 pbProgress.Max:=100;
 tmpStr:=String(fw);
 Len:=Length(tmpStr);
 j:=0;
 oldPosition:=0;
 fwImages.Clear;
 StartPNGAddreses.Clear;
 while true do begin
  if Length(tmpStr)=0 then Break;
  i:=Pos(headerPNG,tmpStr);
  if i=0 then Break;
  percent:=Round((j/Len)*100);
  if oldPosition<>percent then begin
   pbProgress.Position:=percent;
   oldPosition:=percent;
   Application.ProcessMessages;
  end;
  StartPNGAddreses.Add(IntToStr(j+i));
  j:=j+i;
  tmpStr:=Copy(tmpStr,i+1,Length(tmpStr));
  if Pos(footer,tmpStr)<>0 then begin
//   im:=TfwImage.Create(fw,j,imPNG);
   fwImages.Add(im);
   sbStatus.Panels[1].Text:=IntToStr(fwImages.Count)+' зображень знайдено'+'          ';
   Application.ProcessMessages;
  end else
   StartPNGAddreses.Delete(StartPNGAddreses.Count-1);
 end;
 lbImages.Items.AddStrings(StartPNGAddreses);
 pbProgress.Position:=100;
end;}

procedure TfmMain.lbImagesClick(Sender: TObject);
var
 im,im2:TPNGObject;
 fwIm:TfwImage;
 tmpStr:string;
begin
 if Length(fw)<1 then Exit;
 if lbImages.Count<1 then Exit;
 sbStatus.Panels[0].Text:=_('Opening image...');
 Application.ProcessMessages;
{ im:=TfwImage(fwImages[lbImages.ItemIndex]).GetPicture(fw);
 im:=FixImageColors(im);}
 try
//  TfwImage(fwImages[lbImages.ItemIndex]).SaveRAW(fw,'c:\1.zlib');
  fwIm:=TfwImage(fwImages[lbImages.ItemIndex]);
  im:=fwIm.GetPicture(fw);
  if fwIm.imgType=imPNG then begin
   im2:=FixImageColors(im);
   imPreview.Picture.Assign(im2);
   im.Free;
   im2.Free;
  end else begin
   imPreview.Picture.Assign(im);
   im.Free;
  end;
  tmpStr:='  '+_('Image type: ');
  if fwIm.imgType=imPNG then
   tmpStr:=tmpStr+_('PNG')
  else if fwIm.imgType=imPKI then
   tmpStr:=tmpStr+_('packed');
  fwIm.UpdateSize(fw);
  tmpStr:=tmpStr+#10#13+'  '+_('Pixels size: ')+IntToStr(fwIm.Fim_width)+'x'+IntToStr(fwIm.Fim_height);
  tmpStr:=tmpStr+#10#13+'  '+_('Bytes size: ')+IntToStr(fwIm.FimRealSize);
  tmpStr:=tmpStr+#10#13+'  '+_('Space for image: ')+IntToStr(fwIm.FimDataSize);
  lbImageInfo.Caption:=tmpStr;
  fwIm:=TfwImage(fwImagesOrig[lbImages.ItemIndex]);
  im:=fwIm.GetPicture(fwOrig);
  if fwIm.imgType=imPNG then begin
   im2:=FixImageColors(im);
   im.Free;
   imOriginal.Picture.Assign(im2);
   im2.Free;
  end else begin
   imOriginal.Picture.Assign(im);
   im.Free;
  end;
  tmpStr:='  '+_('Image type: ');
  if fwIm.imgType=imPNG then
   tmpStr:=tmpStr+_('PNG')
  else if fwIm.imgType=imPKI then
   tmpStr:=tmpStr+_('packed');
  fwIm.UpdateSize(fwOrig);
  tmpStr:=tmpStr+#10#13+'  '+_('Pixels size: ')+IntToStr(fwIm.Fim_width)+'x'+IntToStr(fwIm.Fim_height);
  tmpStr:=tmpStr+#10#13+'  '+_('Bytes size: ')+IntToStr(fwIm.FimRealSize);
  tmpStr:=tmpStr+#10#13+'  '+_('Space for image: ')+IntToStr(fwIm.FimDataSize);
  lbOrigImageInfo.Caption:=tmpStr;
 except
  on E: Exception do begin
   MessageBox(Application.Handle, PAnsiChar(_('Error while working with image!'+#13+#10+'Looks like it''s broken')+#10#13+_('Message: ')+E.Message), PChar(_('Error')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
   Exit;
  end;
 end;
 sbStatus.Panels[0].Text:=_('Waiting');
end;

{ TfwImage }

procedure TfwImage.Assign(im: TfwImage);
begin
 fStartAddress:=im.fStartAddress;
 fEndAddress:=im.fEndAddress;
 Fim_width:=im.Fim_width;
 Fim_height:=im.Fim_height;
 FChanged:=im.FChanged;
 FimRealSize:=im.FimRealSize;
 FimDataSize:=im.FimDataSize;
 imgType:=im.imgType;
 fOffset:=im.fOffset;
 FEmpty:=im.FEmpty;
end;

procedure TfwImage.CopyFrom(const fwFrom,
  fwTo: TByteArray);
var
 i:integer;
begin
 for i:=StartAddress to EndAddress-1 do begin
  fwTo[i]:=fwFrom[i];
 end;
end;

constructor TfwImage.Create(const fw: TByteArray; const stAddress: Integer; const len: Integer; imType:TImgType; const offset:LongInt);
var
 tmpHex:string;
begin
 inherited Create;
 StartAddress:=stAddress;
 imgType:=imType;
 EndAddress:=stAddress+len;
 FimRealSize:=len;
 tmpHex:='$'+IntToHex(fw[stAddress+2],2)+IntToHex(fw[stAddress+1],2);
 Fim_width:=StrToInt(tmpHex);
 tmpHex:='$'+IntToHex(fw[stAddress+4],2)+IntToHex(fw[stAddress+3],2);
 Fim_height:=StrToInt(tmpHex);
 FChanged:=false;
 UpdateSize(fw);
 FimDataSize:=FimRealSize;
 fOffset:=offset;
// EndAddress:=FindEndAddress(fw);
end;

constructor TfwImage.Create();
begin
 inherited Create;
end;

function TfwImage.FindEndAddress(const fw: TByteArray): LongInt;
var
 tmpStr:string;
begin
 Result:=0;
 if Length(fw)<1 then Exit;
 if imgType<>imPNG then Exit;
 tmpStr:=String(fw);
 tmpStr:=Copy(tmpStr,StartAddress,Length(tmpStr));
 Result:=Pos(footer,tmpStr)+7;
end;

function TfwImage.GetImgLength: LongInt;
begin
// Result:=EndAddress-StartAddress;
 Result:=FimRealSize;
end;

function TfwImage.GetPackedPicture(fw:TByteArray): TByteArray;
var
 i:integer;
begin
 SetLength(Result,EndAddress-StartAddress);
 UpdateSize(fw);
 for i:=StartAddress to StartAddress+ImgLength do begin
  Result[i-StartAddress]:=fw[i];
 end;
end;

function TfwImage.GetPicture(const fw: TByteArray): TPNGObject;
var
 tmpStr:string;
 outStr:TStringStream;
 img:TPNGObject;
 len:integer;
 ImgBuf:TByteArray;
 //
// fs:TFileStream;
begin
 Result:=TPNGObject.Create;
 if Length(fw)<1 then Exit;
 if (StartAddress=0) or (EndAddress=0) then Exit;
// UpdateSize(fw);
 tmpStr:=String(fw);
 tmpStr:=Copy(tmpStr,StartAddress+13,EndAddress-13);
 outStr:=TStringStream.Create(tmpStr);
 if imgType=imPNG then begin
  img:=TPNGObject.Create;
  Result:=img;
  try
   img.LoadFromStream(outStr);
  except
   on E: Exception do begin
    MessageBox(Application.Handle, PAnsiChar(_('Error while working with image!'+#13+#10+'Looks like it''s broken')+#10#13+_('Message: ')+E.Message), PChar(_('Error')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
    Exit;
   end;
  end;
  outStr.Free;
  Result:=img;
 end else if imgType=imPKI then begin
  ImgBuf:=UnZlib(outStr,len);
{  fs:=TFileStream.Create('c:\1.zlib',fmCreate);
  fs.CopyFrom(outStr,len);
  fs.Free;}
  tmpStr:=String(ImgBuf);
  outStr.Free;
  outStr:=TStringStream.Create(tmpStr);
  img:=LoadPacked(outStr,Fim_width,Fim_height);
  outStr.Free;
  Result.Assign(img);
  img.Free;
 end;
end;

procedure TfmMain.btSaveFwClick(Sender: TObject);
begin
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(SaveDialog1.FileName) then begin
  if MessageBox(Application.Handle, PChar(_('File already exists. Rewrite?')), PChar(_('Rewrite?')), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then Exit;
 end;
 DisableForm;
 WriteMemToFile(SaveDialog1.FileName,fw);
 EnableForm;
end;

procedure TfmMain.btReplaceImgClick(Sender: TObject);
var
 Buf:TByteArray;
 fwImg:TfwImage;
 im:TPNGObject;
 ms:TStringStream;
 tmpfName:TFileName;
 im_width,im_height:integer;
 //
// tmp_read:integer;
// Buf2:TByteArray;
 tmpStr:string;
begin
 if lbImages.ItemIndex<0 then Exit;
 if not OpenPictureDialog1.Execute then Exit;
 DisableForm;
 im:=TPNGObject.Create;
 im.LoadFromFile(OpenPictureDialog1.FileName);
 im_width:=im.Width;
 im_height:=im.Height;
 im.Free;
 Buf:=ReadFileToMem(OpenPictureDialog1.FileName);
 if TfwImage(fwImages[lbImages.ItemIndex]).imgType=imPKI then begin
  tmpStr:=GenTempFileName;
  WriteMemToFile(tmpStr,Buf);
  ConvertToRGBA(tmpStr);
  Buf:=ReadFileToMem(tmpStr);
  DeleteFile(tmpStr);
 end;
 if cbFixColors.Checked then begin
  ms:=TStringStream.Create(String(Buf));
  im:=TPNGObject.Create;
  try
   im.LoadFromStream(ms);
  except
   on E: Exception do begin
    MessageBox(Application.Handle, PAnsiChar(_('Error while working with image!'+#13+#10+'Looks like it''s broken')+#10#13+_('Message: ')+E.Message), PChar(_('Error')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
    EnableForm;
    Exit;
   end;
  end;
  ms.Free;
  im:=FixImageColors(im);
  tmpfName:=GenTempFileName;
  im.SaveToFile(tmpfName);
  im.Free;
  if TfwImage(fwImages[lbImages.ItemIndex]).imgType=imPNG then
   OptimizeImg(tmpfName);
  SetLength(Buf,1);
  Buf:=ReadFileToMem(tmpfName);
  DeleteFile(tmpfName);
 end;
 fwImg:=TfwImage(fwImages[lbImages.ItemIndex]);
 sbStatus.Panels[0].Text:=_('Replacing image...');
 if fwImg.imgType=imPNG then begin
  if fwImg.ImgLength<Length(Buf) then begin
   MessageBox(Application.Handle, PAnsiChar(_('Image is too big, can''t replace'+#10#13+'Image size: ')+IntToStr(Length(Buf))+#10#13+_('Allowed size: ')+IntToStr(fwImg.ImgLength)), PChar(_('Error')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
   EnableForm;
   Exit;
  end;
  fwImg.SetPicture(fw,Buf,im_width,im_height);
 end else if fwImg.imgType=imPKI then begin
  ms:=TStringStream.Create(String(Buf));
  im:=TPNGObject.Create;
  im.LoadFromStream(ms);
//  im.SaveToFile('c:\1.png');
  ms.Free;
  Buf:=SavePacked(im);
  ms:=TStringStream.Create(String(Buf));
  Buf:=Zlib(ms);
  ms.Free;
  ms:=TStringStream.Create(String(Buf));
//  Buf2:=UnZlib(ms,tmp_read);
//  SetLength(Buf,tmp_read);
  ms.Free;
//  fwImg.SaveRAW(fw,'c:\1.orig');
//  WriteMemToFile('c:\1.zlib',Buf2);
//  WriteMemToFile('c:\1.zlib',Buf);
  if fwImg.ImgLength<Length(Buf) then begin
   MessageBox(Application.Handle, PAnsiChar(_('Image is too big, can''t replace'+#10#13+'Image size: ')+IntToStr(Length(Buf))+#10#13+_('Allowed size: ')+IntToStr(fwImg.ImgLength)), PChar(_('Error')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
   EnableForm;
   Exit;
  end;
  fwImg.SetPicture(fw,Buf,im_width,im_height);
 end;
 im:=TfwImage(fwImages[lbImages.ItemIndex]).GetPicture(fw);
 if TfwImage(fwImages[lbImages.ItemIndex]).imgType=imPNG then
  im:=FixImageColors(im);
 fixedPNGImages.Items[lbImages.ItemIndex]:=im;
 imPreview.Picture.Assign(im);
  tmpStr:='  '+_('Image type: ');
  if fwImg.imgType=imPNG then
   tmpStr:=tmpStr+_('PNG')
  else if fwImg.imgType=imPKI then
   tmpStr:=tmpStr+_('packed');
  tmpStr:=tmpStr+#10#13+'  '+_('Pixels size: ')+IntToStr(fwImg.Fim_width)+'x'+IntToStr(fwImg.Fim_height);
  tmpStr:=tmpStr+#10#13+'  '+_('Bytes size: ')+IntToStr(fwImg.FimRealSize);
  tmpStr:=tmpStr+#10#13+'  '+_('Space for image: ')+IntToStr(fwImg.FimDataSize);
  lbImageInfo.Caption:=tmpStr;
 EnableForm;
end;

procedure TfmMain.btSaveImgClick(Sender: TObject);
var
// im:TPNGObject;
 fwIm:TfwImage;
begin
 if lbImages.ItemIndex<0 then Exit;
 SavePictureDialog1.FileName:=lbImages.Items[lbImages.ItemIndex];
 if not SavePictureDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SavePictureDialog1.FileName,'.png')) then begin
  if MessageBox(Application.Handle, PChar(_('File already exists. Rewrite?')), PChar(_('Rewrite?')), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   EnableForm;
   Exit;
  end
 end;
 DisableForm;
 fwIm:=TfwImage(fwImages[lbImages.ItemIndex]);
// im:=fwIm.GetPicture(fw);
// imPreview.Picture.Assign(im);
 fwIm.SaveToFile(fw,ChangeFileExt(SavePictureDialog1.FileName,'.png'),cbFixColors.Checked);
 EnableForm;
end;

procedure TfwImage.LoadFromString(Str: string);
var
 sl:TStringList;
begin
 sl:=SplitString(Str,#0);
 if sl.Count<7 then begin
  raise Exception.Create(_('Error loading image'));
  Exit;
 end;
 fStartAddress:=StrToInt(sl[0]);
 fEndAddress:=StrToInt(sl[1]);
 Fim_width:=StrToInt(sl[2]);
 Fim_height:=StrToInt(sl[3]);
 FChanged:=StrToBool(sl[4]);
 FimRealSize:=StrToInt(sl[5]);
 if StrToInt(sl[6])=0 then
  imgType:=imPKI
 else if StrToInt(sl[6])=1 then
  imgType:=imPNG
 else
  raise Exception.Create(_('Looks like this file is for newer version of software'));
 if sl.Count<8 then
  raise Exception.Create(_('Looks like this file is for newer version of software'));
 FEmpty:=StrToBool(sl[7]);
 fOffset:=StrToInt(sl[8]);
end;

procedure TfwImage.SaveRAW(const fw: TByteArray; fName: string);
var
 fStream:TFileStream;
 outStr:TStringStream;
 tmpStr:string;
begin
 if Length(fw)<1 then Exit;
 if (StartAddress=0) or (EndAddress=0) then Exit;
 tmpStr:=String(fw);
 tmpStr:=Copy(tmpStr,StartAddress+13,EndAddress-13);
 outStr:=TStringStream.Create(tmpStr);
 UpdateSize(fw);
 fStream:=TFileStream.Create(fName,fmCreate);
 fStream.CopyFrom(outStr,ImgLength+1);
 fStream.Free;
 outStr.Free;
end;

procedure TfwImage.SaveToFile(const fw: TByteArray;const fName: TFileName; FixColors:boolean=false);
var
 outStr:TStringStream;
 fileStr:TFileStream;
 tmpStr:string;
 im:TPNGObject;
// len:integer;
// ImgBuf:TByteArray;
begin
 if Length(fw)<1 then Exit;
 if (StartAddress=0) or (EndAddress=0) then Exit;
 UpdateSize(fw);
 if imgType=imPNG then begin
  tmpStr:=String(fw);
  tmpStr:=Copy(tmpStr,StartAddress+13,EndAddress-13);
  outStr:=TStringStream.Create(tmpStr);
  tmpStr:=outStr.DataString;
  fileStr:=TFileStream.Create(fName,fmCreate or fmShareDenyWrite);
  fileStr.CopyFrom(outStr,outStr.Size);
  outStr.Free;
  fileStr.Free;
  if FixColors then begin
   im:=TPNGObject.Create;
   im.LoadFromFile(fName);
   im:=fmMain.FixImageColors(im);
   im.SaveToFile(fName);
   im.Free;
  end;
 end else if imgType=imPKI then begin
  im:=GetPicture(fw);
{  if FixColors then
   im:=fmMain.FixImageColors(im);}
  im.SaveToFile(fName);
  im.Free;
 end;
end;

function TfwImage.SaveToString: string;
begin
 Result:=IntToStr(fStartAddress)+#0+
         IntToStr(fEndAddress)+#0+
         IntToStr(Fim_width)+#0+
         IntToStr(Fim_height)+#0+
         BoolToStr(FChanged)+#0+
         IntToStr(FimRealSize)+#0;
 if imgType=imPKI then
  Result:=Result+'0'
 else
  Result:=Result+'1';
 Result:=Result+#0+BoolToStr(FEmpty)+#0+
         IntToStr(fOffset);
end;

procedure TfwImage.SetPicture(var fw:TByteArray; const Buffer: TByteArray; const im_width,im_height: integer);
var
 i:integer;
 imgDataStart:integer;
 //imgLen:integer;
// Buf2:TByteArray;
 nEqual:boolean;
 len:integer;
 tmpHex:string;
 newImSize:integer;
begin
// imgLen:=EndAddress-StartAddress;
 nEqual:=false;
 if fw[StartAddress+1]<>fw[StartAddress+7] then nEqual:=true;
 if fw[StartAddress+3]<>fw[StartAddress+9] then nEqual:=true;
 if nEqual then
  if MessageBox(Application.Handle, PChar(_('New image size differs from original, but cannot be safely saved!'+#13+#10+'Replace anyway?')), PChar(_('Warning!')), MB_ICONWARNING or MB_YESNO or MB_TASKMODAL)<>idYes then Exit;
 newImSize:=Length(Buffer);
 UpdateSize(fw);
 len:=FimDataSize;

{ fw[StartAddress+1]:=im_width;
 fw[StartAddress+7]:=im_width;
 fw[StartAddress+3]:=im_height;
 fw[StartAddress+9]:=im_height;}
 tmpHex:=IntToHex(im_width,4);
 fw[StartAddress+2]:=StrToInt('$'+Copy(tmpHex,1,2));
 fw[StartAddress+1]:=StrToInt('$'+Copy(tmpHex,3,2));
 fw[StartAddress+8]:=StrToInt('$'+Copy(tmpHex,1,2));
 fw[StartAddress+7]:=StrToInt('$'+Copy(tmpHex,3,2));
 tmpHex:=IntToHex(im_height,4);
 fw[StartAddress+4]:=StrToInt('$'+Copy(tmpHex,1,2));
 fw[StartAddress+3]:=StrToInt('$'+Copy(tmpHex,3,2));
 fw[StartAddress+10]:=StrToInt('$'+Copy(tmpHex,1,2));
 fw[StartAddress+9]:=StrToInt('$'+Copy(tmpHex,3,2));

 Fim_width:=im_width;
 Fim_height:=im_height;
 imgDataStart:=StartAddress+12;
// imgLen:=EndAddress-imgDataStart;
 for i:=0 to len-1 do begin
  if i>newImSize-1 then
   fw[i+imgDataStart]:=$00
  else
   fw[i+imgDataStart]:=Buffer[i];
 end;
{ SetLength(Buf2,imgLen);
 for i:=0 to imgLen-1 do begin
  Buf2[i]:=fw[i+imgDataStart];
 end;}
 FChanged:=true;
end;

procedure TfmMain.DisableForm;
begin
// fmMain.Enabled:=false;
 fmWait.Show;
 lbImages.Enabled:=false;
 tmHideProgress.Enabled:=false;
 btOpenFw.Caption:=_('Stop');
 btOpenFw.Hint:=_('Stop processing');
 btOpenFw.Tag:=1;
 Screen.Cursor:=crHourGlass;
 pbProgress.Position:=0;
 pbProgress.Visible:=true;
 Application.ProcessMessages;
end;

procedure TfmMain.EnableForm;
var
 ok:boolean;
begin
// fmMain.Enabled:=true;
 lbImages.Enabled:=true;
 btOpenFw.Caption:=_('Open');
 btOpenFw.Hint:=_('Open RAW file');
 btOpenFw.Tag:=0;
 Screen.Cursor:=crArrow;
 sbStatus.Panels[0].Text:=_('Waiting');
 tmHideProgress.Enabled:=true;
 lbImages.Repaint;
 Stop:=true;
 ok:=(lbImages.Count>0);
 btReplaceImg.Enabled:=ok;
 btSaveImg.Enabled:=ok;
 btSaveProject.Enabled:=ok;
 btSaveFw.Enabled:=ok;
 btFreeSpaceLog.Enabled:=ok;
 btMakeVKP.Enabled:=ok;
 btRestoreOriginal.Enabled:=ok;
 btClearFW.Enabled:=ok;
 btTest.Enabled:=ok;
 btOpenOrig.Enabled:=ok;
 btOpenRepl.Enabled:=ok;
 btSaveOrig.Enabled:=ok;
 btSaveRepl.Enabled:=ok;
 btDelImg.Enabled:=ok;
 fmWait.Hide;
end;

procedure TfmMain.tmHideProgressTimer(Sender: TObject);
begin
 pbProgress.Visible:=false;
end;

procedure TfmMain.btMakeVKPClick(Sender: TObject);
var
 fVkp:System.text;
 tmpStr:string;
 tmpStrings:TStrings;
 i:integer;
 //patch preview
 im_patch:TPNGObject;
begin
 DisableForm;
 sbStatus.Panels[0].Text:=_('Generating patch...');
 tmpStrings:=GenerateVKP(fwOrig,fw);
 if tmpStrings.Count<1 then begin
  EnableForm;
  MessageBox(Application.Handle, PChar(_('No images changed or images are equal!'+#13+#10+'Will not create empty file')), PChar(_('Nothing to write')), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
  Exit;
 end;
 tmpStr:=ExtractFileName(fwFileName);
 if Pos('_MAIN',tmpStr)<1 then begin
  if not InputQuery(_('Enter version'),_('Unable to guess firmware version'+#10#13+'Please enter it'),tmpStr) then Exit;
 end else begin
  tmpStr:=Copy(tmpStr,0,Pos('_MAIN',tmpStr)-1);
 end;
 SaveDialog1.Filter:=_('VKP files (*.vkp)|*.vkp');
 if not SaveDialog1.Execute then begin
  EnableForm;
  Exit;
 end;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.vkp')) then begin
  if MessageBox(Application.Handle, PChar(_('File already exists. Rewrite?')), PChar(_('Rewrite?')), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   EnableForm;
   Exit;
  end
 end;
 Application.ProcessMessages;
 AssignFile(fVkp,ChangeFileExt(SaveDialog1.FileName,'.vkp'));
 FileMode:=2;
 Rewrite(fVkp);
 WriteLn(fVkp,';'+tmpStr);
 //Write subHeader
 WriteLn(fVkp,';replace system graphics of db2020 phone');
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,';automatically generated by');
 WriteLn(fVkp,';SE db2020 Image Tool '+swversion);
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,';замена системной графики телефонов с db2020');
 WriteLn(fVkp,';автоматически сгенерирован программой');
 WriteLn(fVkp,';SE db2020 Image Tool '+swversion);
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,';заміна системної графіки телефонів з db2020');
 WriteLn(fVkp,';автоматично зґенерований програмою');
 WriteLn(fVkp,';SE db2020 Image Tool '+swversion);
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,'+44140000');
 //--------------------------
 Application.ProcessMessages;
 for i:=0 to tmpStrings.Count-1 do
  WriteLn(fVkp,tmpStrings[i]);
 CloseFile(fVkp);
 //Create preview image
 sbStatus.Panels[0].Text:=_('Generating preview...');
 Application.ProcessMessages;
 try
  im_patch:=CreatePatchPreview;
  if im_patch<>nil then begin
   tmpStr:=GenTempFileName;
//   tmpStr:=ExtractFilePath(tmpStr)+ExtractFileName(tmpStr)+'_preview.png';
   im_patch.SaveToFile(tmpStr);
   Application.ProcessMessages;
   OptimizeImg(tmpStr);
   im_patch.Free;
   MoveFileEx(PChar(tmpStr),PChar(ExtractFilePath(SaveDialog1.FileName)+ExtractFileName(SaveDialog1.FileName)+'_preview.png'),MOVEFILE_REPLACE_EXISTING or MOVEFILE_COPY_ALLOWED);
  end;
 except
  MessageBox(Application.Handle, 'Cannot generate patch preview image, maybe you have replaced too many images'+#13+#10+'However, the .vkp should be ok!', 'Cannot generate preview', MB_ICONWARNING or MB_OK or MB_TASKMODAL);
 end;
 EnableForm;
end;

function TfmMain.GenerateVKP(const fwSrc,fwMod: TByteArray): TStrings;
var
 Len,i:LongInt;
 percent,oldPosition:integer;
 SameByte:boolean;
 tmpResSrc,tmpResDst:string;
begin
 Len:=Length(fwSrc)-1;
 Result:=TStringList.Create;
 pbProgress.Max:=100;
 pbProgress.Position:=0;
 oldPosition:=0;
 for i:=0 to Len do begin
  if fwSrc[i]=fwMod[i] then SameByte:=true
   else SameByte:=false;
  if not SameByte then begin
   tmpResSrc:=tmpResSrc+IntToHex(fwSrc[i],2);
   tmpResDst:=tmpResDst+IntToHex(fwMod[i],2);
  end;
//  if (SameByte or (Length(tmpResSrc)>10)) then if Length(tmpResSrc)>0 then begin
  if (SameByte) then if Length(tmpResSrc)>0 then begin
   Result.Add(IntToHex(i-(Length(tmpResSrc) div 2),8)+': '+tmpResSrc+' '+tmpResDst);
   tmpResSrc:='';
   tmpResDst:='';
  end;
  percent:=Round((i/Len)*100);
  if oldPosition<>percent then begin
   pbProgress.Position:=percent;
   oldPosition:=percent;
   Application.ProcessMessages;
  end;
 end;
 pbProgress.Position:=100;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 tmSlideForm.Enabled:=false;
 StopSlide:=true;
 if fmMain.WindowState=wsMaximized then Exit;
 while fmMain.Top>-(fmMain.Height+10) do begin
  fmMain.Top:=fmMain.Top-20;
  Application.ProcessMessages;
  Sleep(10);
 end;
end;

procedure TfmMain.Z0068535980301Click(Sender: TObject);
var
 ed:TEdit;
begin
 if (Sender as TMenuItem).Tag=1 then begin
  ShellExecute(Application.Handle,'open','mailto:misha.cn.ua@gmail.com?subject=SeImageTool',nil,nil,SW_SHOWNORMAL);
 end else begin
  ed:=TEdit.Create(fmMain);
  ed.Parent:=fmMain;
  ed.Text:=AnsiReplaceStr((Sender as TMenuItem).Caption,'&','');
  ed.Text:=AnsiReplaceStr(ed.Text,'EGold','');
  ed.Text:=Trim(ed.Text);
  ed.SelectAll;
  ed.CopyToClipboard;
  ed.Free;
 end;
end;

procedure TfmMain.tmSlideFormTimer(Sender: TObject);
var
 dstTop:integer;
begin
 tmSlideForm.Enabled:=false;
 if fmMain.WindowState=wsMaximized then Exit;
 fmMain.Visible:=true;
 dstTop:=(Screen.DesktopHeight div 2)-(fmMain.Height div 2);
 while fmMain.Top<dstTop do begin
  if StopSlide then Exit;
  fmMain.Top:=fmMain.Top+20;
  Application.ProcessMessages;
  Sleep(10);
 end;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
 fmMain.Top:=-(fmMain.Height+10);
 fmMain.Left:=(Screen.DesktopWidth div 2)-(fmMain.Width div 2);
 lbAbout.AutoSize:=false;
 lbAbout.AutoSize:=true;
 tmSlideForm.Enabled:=true;
end;

procedure TfmMain.lbImagesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 R:TRect;
 OldFontColor:TColor;
 Str:string;
 img:TPNGObject;
 aspRatio:real;
 tmpInt:integer;
begin
 if btOpenFw.Tag<>0 then Exit;
 (Control as TsListBox).Canvas.Font.Color:=(Control as TsListBox).Font.Color;
 with (Control as TsListBox).Canvas do begin
  OldFontColor:=Font.Color;
  if odSelected in State then begin
   Brush.Color:=fmMain.sSkinManager1.GetHighLightColor;
   Font.Color:=fmMain.sSkinManager1.GetHighLightFontColor;
   if Index=(Control as TsListBox).ItemIndex then Font.Color:=clYellow;
  end else begin
   Brush.Color:=(Control as TsListBox).Color;
//   if Index=(Control as TsListBox).ItemIndex then Font.Color:=clMaroon;
  end;
  FillRect(Rect);
  Str:=(Control as TsListBox).Items[Index];
  R:=Rect;
  R.Right:=R.Left+(Control as TsListBox).ItemHeight;
//  img:=TfwImage(fwImages[Index]).GetPicture(fw);
  img:=TPNGObject(fixedPNGImages[Index]);
  aspRatio:=img.Width/img.Height;
  if (aspRatio)<((R.Right-R.Left)/(R.Bottom-R.Top)) then
   R.Right:=R.Left+Round(aspRatio*(R.Right-R.Left))
  else
   R.Bottom:=R.Top+Round((R.Bottom-R.Top)/aspRatio);
  tmpInt:=((Control as TsListBox).ItemHeight-(R.Bottom-R.Top)) div 2;
  R.Bottom:=R.Bottom+tmpInt;
  R.Top:=R.Top+tmpInt;
//  img:=FixImageColors(img);
  img.Draw((Control as TsListBox).Canvas,R);
  R:=Rect;
  R.Left:=R.Left+(Control as TsListBox).ItemHeight+3;
  DrawText(Handle,PAnsiChar(Str),Length(Str),R,DT_SINGLELINE or DT_END_ELLIPSIS or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  Font.Color:=OldFontColor;
 end;
end;

procedure TfmMain.seThumbHeightChange(Sender: TObject);
begin
 lbImages.ItemHeight:=seThumbHeight.Value;
end;

procedure TfmMain.cbStretchPreviewClick(Sender: TObject);
begin
 imPreview.Stretch:=cbStretchPreview.Checked;
 imOriginal.Stretch:=cbStretchPreview.Checked;
end;

function TfmMain.SwapRGBtpBGR(color: TColor): TColor;
var
 crgb:Longint;
begin
 crgb:=ColorToRGB(color);
 Result:=RGB(GetBValue(crgb),GetGValue(crgb),GetRValue(crgb));
end;

procedure TfmMain.OptimizeImg(fName: TFileName);
var
 path,name,tmpcDir,outStr:string;
 exCode:Cardinal;
 appd:string;
begin
 path:=ExtractFilePath(fName);
 name:=ExtractFileName(fName);
 tmpcDir:=GetCurrentDir;
 SetCurrentDir(path);
 appd:=ExtractFilePath(Application.ExeName);
// ExtractPNGout(path);
// exCode:=WinExec32AndRedirectOutput('pngout.exe /y /d0 '+name,outStr);
 //Now try PngOptimizerCL.exe
 exCode:=WinExec32AndRedirectOutput(appd+'PngOptimizerCL.exe -file:'+name,outStr);
 if exCode<>1 then begin
  MessageBox(Application.Handle, PAnsiChar(_('Error while optimizing image!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr), PChar(_('Error!')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
 exCode:=WinExec32AndRedirectOutput(appd+'optipng.exe -o7 -i0 '+name,outStr);
 if exCode<>0 then begin
  MessageBox(Application.Handle, PAnsiChar(_('Error while optimizing image!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr), PChar(_('Error!')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
// WinExec32AndWait('pngout.exe /y /d0 /q '+name,SW_HIDE);
// DeleteFile('pngout.exe');
 SetCurrentDir(tmpcDir);
end;

function TfmMain.GenTempFileName: TFileName;
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

procedure TfmMain.CopyAlpha(var src, dst: TPNGObject);
var
 i,j:integer;
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
end;

function TfmMain.FixImageColors(img: TPNGObject): TPNGObject;
var
 i,j:integer;
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
end;

{procedure TfmMain.ExtractPNGOut(path: string);
var
 Res:TResourceStream;
begin
 Res := TResourceStream.Create(hInstance, 'PNGOUTEXE', Pchar('EXE1'));
 Res.SavetoFile(IncludeTrailingPathDelimiter(path)+'pngout.exe');
 Res.Free;
end;}

procedure TfmMain.FixPNGs;
var
 i,count:integer;
 im,im2:TPNGObject;
 percent,oldPosition:integer;
begin
 sbStatus.Panels[0].Text:=_('Processing colors...');
 pbProgress.Position:=0;
 oldPosition:=-1;
 pbProgress.Min:=0;
 pbProgress.Max:=100;
 fixedPNGImages.Clear;
 count:=fwImages.Count-1;
 for i:=0 to count do begin
  percent:=Round((i*100)/(count+1));
  if percent<>oldPosition then begin
   pbProgress.Position:=percent;
   oldPosition:=percent;
  end;
  sbStatus.Panels[1].Text:=IntToStr(i)+_(' images processed')+'    ';
  Application.ProcessMessages;
  im:=TfwImage(fwImages[i]).GetPicture(fw);
  if TfwImage(fwImages[i]).imgType=imPNG then begin
   im2:=FixImageColors(im);
   fixedPNGImages.Add(im2);
   im.Free;
  end else
   fixedPNGImages.Add(im);
 end;
 pbProgress.Position:=100;
 Application.ProcessMessages;
end;

procedure TfmMain.JvFormStorage1AfterRestorePlacement(Sender: TObject);
begin
{ if JvFormStorage1.ReadInteger('Version')<iVersion then
  sSkinManager1.SkinName:='Winter';}
end;

procedure TfmMain.JvFormStorage1AfterSavePlacement(Sender: TObject);
begin
 JvFormStorage1.WriteInteger('Version',iVersion);
end;

procedure TfmMain.cbSkinsChange(Sender: TObject);
begin
 sSkinManager1.SkinName:=cbSkins.Text;
end;

procedure TfmMain.sSkinManager1AfterChange(Sender: TObject);
var
 i:integer;
begin
 for i:=0 to cbSkins.Items.Count-1 do
  if cbSkins.Items[i]=sSkinManager1.SkinName then cbSkins.ItemIndex:=i;
end;

procedure TfmMain.ReadImgTable(const fw: TByteArray);
var
 tmpStr:string;
 tableStart:LongInt;
 pheader:LongInt;
 numIcons:LongInt;
 offset:LongInt;
 names:LongInt;
 picbase:LongInt;
 offsettable:LongInt;
 i:LongInt;
 pic_n_start,pic_n_len,pic_offset:LongInt;
 fFtype:string[4];
 //
 im,im2:TfwImage;
 percent,old_percent:integer;
 len:integer;
 //
 LoadFrom,LoadTo:LongInt;
 tmpOffset:integer;
 //
 imgCount:integer;
begin
 StartPNGAddreses.Clear;
 imgOffsets.Clear;
 imgCount:=0;
 LoadFrom:=seLoadFrom.Value;
 LoadTo:=seLoadTo.Value;
 sbStatus.Panels[0].Text:=_('Calculating sizes of images...');
 pbProgress.Position:=0;
 pbProgress.Max:=100;
 old_percent:=0;
 tmpStr:=String(fw);
 tableStart:=Pos('ICON_16BIT_V2',tmpStr)-13;
 pheader:=GetDWORD(fw,tableStart+$34);
 numIcons:=pheader;
 offset:=GetDWORD(fw,tableStart+$34+$10);
 picbase:=tableStart+offset;
 names:=tableStart+$34+$10+4;
 offsettable:=names+numIcons*2;
{ Memo1.Lines.Clear;
 Memo1.Lines.Add('base        :$'+IntToHex(tableStart+imgbase,8));
 Memo1.Lines.Add('pheader     :$'+IntToHex(pheader,8));
 Memo1.Lines.Add('numIcons    :'+IntToStr(numIcons));
 Memo1.Lines.Add('offset      :$'+IntToHex(offset,8));
 Memo1.Lines.Add('names       :$'+IntToHex(names,8));
 Memo1.Lines.Add('offsettable :$'+IntToHex(offsettable+imgbase,8));
 Memo1.Lines.Add('picbase     :$'+IntToHex(picbase+imgbase,8));}
 len:=numIcons;
 if LoadTo<1 then LoadTo:=numIcons;
 if LoadTo>numIcons then
  LoadTo:=numIcons;
 for i:=LoadFrom to LoadTo-1 do begin
  percent:=Round((i/len)*100);
//  fmMain.sMemo1.Lines.Add('Loading: '+IntToStr(MilliSecondOf(Time)));
  if percent<>old_percent then begin
   pbProgress.Position:=percent;
   old_percent:=percent;
  end;
  sbStatus.Panels[1].Text:=IntToStr(imgCount)+_(' images processed')+'    ';
  Application.ProcessMessages;
  if Stop then Exit;
  pic_offset:=Get3Bytes(fw,offsettable+i*3);
  pic_n_start:=pic_offset;
  fFtype:='.bwi';
  pic_n_start:=picbase+pic_n_start;
   if (fw[pic_n_start]=$AA) then begin
    if
      (fw[pic_n_start+5]=$00) and
      (fw[pic_n_start+6]=$00) then begin
        fFtype:='.unk';
        if fw[pic_n_start+11]=$5A then fFtype:='.pki';
        if fw[pic_n_start+11]=$89 then fFtype:='.png';
    end;
   end;
//   pic_n_len:=Length(fw)-pic_n_start;
   pic_n_len:=pic_n_start+102400;
  if (fFtype<>'.png') and (fFtype<>'.pki') then begin
   continue;
  end;
  im:=nil;
  im2:=nil;
//  fmMain.sMemo1.Lines.Add('Calc len: '+IntToStr(MilliSecondOf(Time)));
  if fFtype='.png' then begin
   im:=TfwImage.Create(fw,pic_n_start,pic_n_len,imPNG,pic_offset);
   im2:=TfwImage.Create();
   im2.Assign(im);
  end else if fFtype='.pki' then begin
   im:=TfwImage.Create(fw,pic_n_start,pic_n_len,imPKI,pic_offset);
   im2:=TfwImage.Create();
   im2.Assign(im);
  end;
//  fmMain.sMemo1.Lines.Add('Ok: '+IntToStr(MilliSecondOf(Time)));
  if im<>nil then begin
   if imgOffsets.Find('$'+IntToHex(pic_n_start,8),tmpOffset) then begin
    im.Free;
    im2.Free;
    continue;
   end;
   fwImages.Add(im);
   fwImagesOrig.Add(im2);
   if fFtype='.png' then
    StartPNGAddreses.Add('PNG $'+IntToHex(pic_n_start,8))
   else if fFtype='.pki' then
    StartPNGAddreses.Add('PKI $'+IntToHex(pic_n_start,8))
   else
    StartPNGAddreses.Add('UNK $'+IntToHex(pic_n_start,8));
   imgOffsets.Add('$'+IntToHex(pic_n_start,8));
   imgCount:=imgCount+1;
  end;
//  fmMain.sMemo1.Lines.Add('Next img: '+IntToStr(MilliSecondOf(Time)));
 end;
 lbImages.Items.AddStrings(StartPNGAddreses);
end;

function TfmMain.GetDWORD(const fw: TByteArray;
  const addr: Cardinal): DWORD;
var
 byte1,byte2:string;
begin
 byte1:=IntToHex(fw[addr],2);
 byte2:=IntToHex(fw[addr+1],2);
 Result:=StrToInt('$'+byte2+byte1);
end;

function TfmMain.Get3Bytes(const fw: TByteArray;
  const addr: Cardinal): LongInt;
var
 byte1,byte2,byte3:string;
begin
 byte1:=IntToHex(fw[addr],2);
 byte2:=IntToHex(fw[addr+1],2);
 byte3:=IntToHex(fw[addr+2],2);
 Result:=StrToInt('$'+byte3+byte2+byte1);
end;

procedure TfmMain.FormResize(Sender: TObject);
var
 imWidth:integer;
begin
 lbAbout.AutoSize:=false;
 lbAbout.AutoSize:=true;
 pnAbout.Height:=lbAbout.Height;
 imWidth:=sPanel3.Width-imArrow.Width;
 gbOriginal.Width:=imWidth div 2;
 btRestoreOriginal.Left:=imArrow.Left+13;
end;

procedure TfmMain.ClearForm;
begin
 lbImages.Clear;
 StartPNGAddreses.Clear;
 imgOffsets.Clear;
 fwImages.Clear;
 fwImagesOrig.Clear;
end;

procedure TfmMain.JvFormStorage1RestorePlacement(Sender: TObject);
var
 lang:string;
 idx:integer;
begin
 lang:=JvFormStorage1.ReadString('Language','en');
 idx:=Languages.IndexOf(lang);
 if idx<0 then idx:=0;
 cbLanguage.ItemIndex:=idx;
 cbLanguageChange(Self);
end;

procedure TfmMain.JvFormStorage1SavePlacement(Sender: TObject);
var
 lang:string;
begin
 lang:='en';
 lang:=Languages[cbLanguage.ItemIndex];
 JvFormStorage1.WriteString('Language',lang);
end;

procedure TfmMain.cbLanguageChange(Sender: TObject);
var
 lang:string;
begin
 lang:='en';
 lang:=Languages[cbLanguage.ItemIndex];
 UseLanguage(lang);
 RetranslateComponent(fmMain);
 if fmWait<>nil then
  RetranslateComponent(fmWait);
 fmMain.FormResize(Self);
end;

procedure TfmMain.Button1Click(Sender: TObject);
var
 Buf:TByteArray;
 str:TStringStream;
 len:integer;
begin
 Buf:=ReadFileToMem('c:\1.zlib');
// str:=TStringStream.Create(Copy(String(Buf),13,Length(String(Buf))));
 str:=TStringStream.Create(String(Buf));
 Buf:=UnZlib(str,len);
 str.Free;
 str:=TStringStream.Create(String(Buf));
 imPreview.Picture.Assign(LoadPacked(str,TfwImage(fwImages[lbImages.ItemIndex]).Fim_width,TfwImage(fwImages[lbImages.ItemIndex]).Fim_height));
 str.Free;
end;

procedure TfmMain.Button2Click(Sender: TObject);
var
 tmpStr:string;
 outStr:TStringStream;
 len:integer;
 ImgBuf:TByteArray;
 //
 fs:TFileStream;
 fwim:TfwImage;
begin
 fwim:=TfwImage(fwImages[lbImages.ItemIndex]);
 if Length(fw)<1 then Exit;
 if (fwim.StartAddress=0) or (fwim.EndAddress=0) then Exit;
 tmpStr:=String(fw);
 tmpStr:=Copy(tmpStr,fwim.StartAddress+13,fwim.EndAddress-13);
 outStr:=TStringStream.Create(tmpStr);
 if fwim.imgType=imPKI then begin
  ImgBuf:=UnZlib(outStr,len);
  fs:=TFileStream.Create('c:\1.unzlib',fmCreate);
  fs.CopyFrom(outStr,len);
  fs.Free;
  tmpStr:=String(ImgBuf);
  outStr.Free;
  outStr:=TStringStream.Create(tmpStr);
  outStr.Free;
 end;
end;

{procedure TfmMain.ExtractApfZapf(path: string);
var
 Res:TResourceStream;
begin
 Res := TResourceStream.Create(hInstance, 'APFZAPFEXE', Pchar('EXE2'));
 Res.SavetoFile(IncludeTrailingPathDelimiter(path)+'apf2zapf.exe');
 Res.Free;
end;}

procedure TfmMain.btRestoreOriginalClick(Sender: TObject);
var
 fwIm,fwImOrig:TfwImage;
 im:TPNGObject;
begin
 if lbImages.ItemIndex<0 then Exit;
 fwIm:=TfwImage(fwImages[lbImages.ItemIndex]);
 fwImOrig:=TfwImage(fwImagesOrig[lbImages.ItemIndex]);
 fwIm.CopyFrom(fwOrig,fw);
 fwIm.Assign(fwImOrig);
{ fwIm.Fim_width:=fwImOrig.Fim_width;
 fwIm.Fim_height:=fwImOrig.Fim_height;
 fwIm.FimRealSize:=fwImOrig.FimRealSize;
 fwIm.FChanged:=false;}
 im:=TfwImage(fwImages[lbImages.ItemIndex]).GetPicture(fw);
 im:=FixImageColors(im);
 fixedPNGImages.Items[lbImages.ItemIndex]:=im;
 imPreview.Picture.Assign(im);
end;

function TfmMain.CreatePatchPreview: TPNGObject;
var
 i:Longint;
 im_patch_w,im_patch_h:Longint;
 imgList:TStrings;
 im_patch,im,im2:TPNGObject;
 tmpInt:Longint;
 R:TRect;
 tmpWidth:Longint;
 curLeft:Longint;
 maxH,maxH_patch:Longint;
begin
 im_patch_w:=0;
 maxH:=0;
 maxH_patch:=0;
 imgList:=TStringList.Create;
 for i:=0 to fwImages.Count-1 do begin
  Application.ProcessMessages;
  if TfwImage(fwImages[i]).FChanged then begin
   imgList.Add(IntToStr(i));
   if maxH<TfwImage(fwImagesOrig[i]).Fim_height then
    maxH:=TfwImage(fwImagesOrig[i]).Fim_height;
   if maxH_patch<TfwImage(fwImages[i]).Fim_height then
    maxH_patch:=TfwImage(fwImages[i]).Fim_height;
   if TfwImage(fwImages[i]).Fim_width>TfwImage(fwImagesOrig[i]).Fim_width then
    tmpInt:=TfwImage(fwImages[i]).Fim_width
   else
    tmpInt:=TfwImage(fwImagesOrig[i]).Fim_width;
   im_patch_w:=im_patch_w+tmpInt+10;
  end;
 end;
 im_patch_h:=maxH+5+maxH_patch;
 if imgList.Count>1 then im_patch_w:=im_patch_w-10;
 im_patch_h:=im_patch_h+5;
 Result:=nil;
 if im_patch_w>3000 then begin
  if MessageBox(Application.Handle, PChar(Format(_('The .vkp is ready, now it''s time to create a preview.'+#13+#10+'But patch preview image size is large (%dx%d pixels), and software can crash while generating it.'+#13+#10+'Generate preview anyway?'),[im_patch_w,im_patch_h])), PChar(_('Too big preview')), MB_ICONWARNING or MB_YESNO or MB_TASKMODAL)=idNo then Exit;
 end;
 im_patch:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,im_patch_w,im_patch_h+3);
 R.Left:=0; R.Top:=0;
  im:=TPNGObject.CreateBlank(COLOR_RGB,8,2,im_patch.Height-1);
  im.Canvas.Brush.Style:=bsSolid;
  im.Canvas.Brush.Color:=clOlive;
  im.Canvas.FillRect(im.Canvas.ClipRect);
  im.CreateAlpha;
  DrawPNG(im_patch,im,0,0);
  im.Free;
 curLeft:=3;
 for i:=0 to imgList.Count-1 do begin
  Application.ProcessMessages;
  im:=TfwImage(fwImagesOrig[StrToInt(imgList[i])]).GetPicture(fwOrig);
  im:=FixImageColors(im);
  im2:=TfwImage(fwImages[StrToInt(imgList[i])]).GetPicture(fw);
  im2:=FixImageColors(im2);
  R.Top:=2;
  R.Left:=curLeft;
  if im2.Width>im.Width then
   R.Left:=R.Left+(im2.Width-im.Width) div 2;
  R.Bottom:=R.Top+im.Height;
  if maxH>im.Height then begin
   R.Top:=R.Top+(maxH-im.Height) div 2;
   R.Bottom:=R.Bottom+(maxH-im.Height) div 2;
  end;
  R.Bottom:=R.Top+im.Height;
  tmpWidth:=im.Width;
  DrawPNG(im_patch,im,R.Left,R.Top);
  R.Left:=curLeft;
  if im2.Width<im.Width then
   R.Left:=R.Left+(im.Width-im2.Width) div 2;
  im.Free;
  R.Top:=maxH+10;
  R.Right:=R.Left+im2.Width;
  R.Bottom:=R.Top+im2.Height;
  if maxH_patch>im2.Height then begin
   R.Top:=R.Top+(maxH_patch-im2.Height) div 2;
   R.Bottom:=R.Bottom+(maxH_patch-im2.Height) div 2;
  end;
  if tmpWidth<im2.Width then
   tmpWidth:=im2.Width;
  DrawPNG(im_patch,im2,R.Left,R.Top);
  im2.Free;
  curLeft:=curLeft+tmpWidth+4;
  if i<imgList.Count-1 then begin
   im:=TPNGObject.CreateBlank(COLOR_RGB,8,2,im_patch.Height-1);
   im.Canvas.Brush.Style:=bsSolid;
   im.Canvas.Brush.Color:=clOlive;
   im.Canvas.FillRect(im.Canvas.ClipRect);
   im.CreateAlpha;
   DrawPNG(im_patch,im,curLeft,0);
   im.Free;
  end;
  curLeft:=curLeft+4;
 end;
   im:=TPNGObject.CreateBlank(COLOR_RGB,8,2,im_patch.Height);
   im.Canvas.Brush.Style:=bsSolid;
   im.Canvas.Brush.Color:=clOlive;
   im.Canvas.FillRect(im.Canvas.ClipRect);
   im.CreateAlpha;
   DrawPNG(im_patch,im,im_patch.Width-2,0);
   im.Free;
 im:=TPNGObject.CreateBlank(COLOR_RGB,8,im_patch.Width,2);
 im.Canvas.Brush.Style:=bsSolid;
 im.Canvas.Brush.Color:=clOlive;
 im.Canvas.FillRect(im.Canvas.ClipRect);
 im.CreateAlpha;
 DrawPNG(im_patch,im,0,maxH+2);
 DrawPNG(im_patch,im,0,0);
 DrawPNG(im_patch,im,0,im_patch.Height-2);
 im.Free;
 Result:=im_patch;
end;

procedure TfmMain.DrawPNG(dst: TPNGObject; const src: TPNGObject; Left,
  Top: integer);
var
 y:integer;
// copyWidth,copyHeight:integer;
begin
 if dst.Width<(src.Width+Left) then Exit;
 for y:=0 to src.Height-1 do begin
  if (y+Top)>(dst.Height-1) then Exit;
  CopyMemory(Pointer(Integer(dst.Scanline[y+Top])+Left*3),src.Scanline[y],src.Width*3);
  if ((dst.Header.ColorType=COLOR_RGBALPHA) or (dst.Header.ColorType=COLOR_GRAYSCALEALPHA)) and
     ((src.Header.ColorType=COLOR_RGBALPHA) or (src.Header.ColorType=COLOR_GRAYSCALEALPHA)) then
   CopyMemory(Pointer(Integer(dst.AlphaScanline[y+Top])+Left),src.AlphaScanline[y],src.Width);
 end;
end;

procedure TfmMain.btTestClick(Sender: TObject);
var
 i,j:integer;
 w,h:integer;
 Buf,Buf2:TByteArray;
 fwIm:TfwImage;
 percent,oldPercent,Len:integer;
 nEqual:boolean;
 im:TPNGObject;
 ms:TStringStream;
const
 sPath='c:\img\';
begin
 if not Stop then begin
  Stop:=true;
  EnableForm;
  Exit;
 end;
 Stop:=false;
 pbProgress.Max:=100;
 pbProgress.Position:=0;
 Len:=lbImages.Count-1;
 oldPercent:=0;
 DisableForm;
 for i:=0 to Len do begin
//  lbImages.ItemIndex:=i;
  percent:=Round((i*100)/Len);
  if percent<>oldPercent then begin
   pbProgress.Position:=percent;
   oldPercent:=percent;
   Application.ProcessMessages;
  end;
  if Stop then begin
   EnableForm;
   Exit;
  end;
  if TfwImage(fwImagesOrig[i]).imgType<>imPKI then continue;
  fwIm:=TfwImage(fwImagesOrig[i]);
  fwIm.SaveToFile(fwOrig,sPath+lbImages.Items[i]+'.png',true);
  w:=fwIm.Fim_width;
  h:=fwIm.Fim_height;
  im:=TPNGObject.Create;
  im.LoadFromFile(sPath+lbImages.Items[i]+'.png');
  im:=FixImageColors(im);
  Buf:=SavePacked(im);
  ms:=TStringStream.Create(String(Buf));
  Buf:=Zlib(ms);
  if TfwImage(fwImages[i]).ImgLength<Length(Buf) then begin
   im.Free;
   ms.Free;
   Continue;
   Exit;
  end;
  ms.Free;
  im.Free;
  TfwImage(fwImages[i]).SetPicture(fw,Buf,w,h);
  Buf:=TfwImage(fwImages[i]).GetPackedPicture(fw);
  Buf2:=TfwImage(fwImagesOrig[i]).GetPackedPicture(fwOrig);
  nEqual:=false;
  if Length(Buf)<>Length(Buf2) then nEqual:=true;
  if not nEqual then begin
   for j:=0 to Length(Buf)-1 do begin
    if Buf[j]<>Buf2[j] then begin
     nEqual:=true;
     Break;
    end;
   end;
  end;
  if nEqual then begin
{   WriteMemToFile(sPath+'nequal\'+lbImages.Items[i]+'_orig'+'.zraw',Buf2);
   WriteMemToFile(sPath+'nequal\'+lbImages.Items[i]+'_repl'+'.zraw',Buf);}
  end;
 end;
 EnableForm;
end;

procedure TfmMain.btSaveOrigClick(Sender: TObject);
begin
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.raw')) then begin
  if MessageBox(Application.Handle, PChar(_('File already exists. Rewrite?')), PChar(_('Rewrite?')), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   Exit;
  end
 end;
 TfwImage(fwImages[lbImages.ItemIndex]).SaveRAW(fw,ChangeFileExt(SaveDialog1.FileName,'.raw'));
end;

procedure TfmMain.btSaveReplClick(Sender: TObject);
begin
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.raw')) then begin
  if MessageBox(Application.Handle, PChar(_('File already exists. Rewrite?')), PChar(_('Rewrite?')), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   Exit;
  end
 end;
 TfwImage(fwImagesOrig[lbImages.ItemIndex]).SaveRAW(fwOrig,ChangeFileExt(SaveDialog1.FileName,'.raw'));
end;

procedure TfmMain.btOpenOrigClick(Sender: TObject);
var
 fs:TFileStream;
 fwIm:TfwImage;
begin
 OpenDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not OpenDialog1.Execute then Exit;
 fs:=TFileStream.Create(OpenDialog1.FileName,fmOpenRead);
 fwIm:=TfwImage(fwImagesOrig[lbImages.ItemIndex]);
 imOriginal.Picture.Assign(LoadPacked(fs,fwIm.Fim_width,fwIm.Fim_height));
 fs.Free;
end;

procedure TfmMain.btOpenReplClick(Sender: TObject);
var
 fs:TFileStream;
 fwIm:TfwImage;
begin
 OpenDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not OpenDialog1.Execute then Exit;
 fs:=TFileStream.Create(OpenDialog1.FileName,fmOpenRead);
 fwIm:=TfwImage(fwImages[lbImages.ItemIndex]);
 imPreview.Picture.Assign(LoadPacked(fs,fwIm.Fim_width,fwIm.Fim_height));
 fs.Free;
end;

procedure TfwImage.UpdateSize(fw: TByteArray);
var
 tmpStr:string;
 outStr:TStringStream;
 k,j:integer;
 ImgBuf:TByteArray;
 tmpWindow:string;
begin
 if imgType=imPKI then begin
  tmpStr:='';
  tmpStr:=String(fw);
  tmpStr:=Copy(tmpStr,StartAddress+13,EndAddress+4096);
  outStr:=TStringStream.Create(tmpStr);
  UnZlib(outStr,FimRealSize);
  fEndAddress:=fStartAddress+FimRealSize+12;
  outStr.Free;
//  UnZlib(fw,StartAddress+13,FimRealSize);
 end else if imgType=imPNG then begin
  SetLength(ImgBuf,Length(fw)-(StartAddress));
  j:=7;
  for k:=StartAddress+7 to Length(fw)-1 do begin
    j:=j+1;
    tmpWindow:=chr(fw[k-7])+chr(fw[k-6])+chr(fw[k-5])+
               chr(fw[k-4])+chr(fw[k-3])+chr(fw[k-2])+chr(fw[k-1])+
               chr(fw[k]);
    if footer=tmpWindow then begin
     FimRealSize:=j;
     break;
    end;
  end;
  FimRealSize:=FimRealSize-12;
  fEndAddress:=fStartAddress+FimRealSize+12;
 end;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if [ssCtrl,ssAlt,ssShift]=Shift then
  if Key=VK_F12 then begin
   btTest.Visible:=true;
   btSaveFw.Visible:=true;
   btSaveOrig.Visible:=true;
   btSaveRepl.Visible:=true;
   btOpenOrig.Visible:=true;
   btOpenRepl.Visible:=true;
   pnDevControls.Visible:=true;
   lbAbout.AutoSize:=false;
   lbAbout.AutoSize:=true;
   pnAbout.Height:=lbAbout.Height;
 end;
end;

procedure TfmMain.btClearFWClick(Sender: TObject);
var
 i:integer;
 fwim:TfwImage;
begin
 CopyMemory(fw,fwOrig,Length(fw));
 fwImages.Clear;
 SetLength(FreeBlocks,0);
 for i:=0 to fwImages.Count-1 do begin
  fwim:=TfwImage.Create;
  fwim.Assign(TfwImage(fwImagesOrig[i]));
 end;
end;

procedure TfmMain.btFreeSpaceLogClick(Sender: TObject);
var
 i,j:integer;
 fwIm:TfwImage;
 bImg:TimgBounds;
 lsFreeSpaces:TimgBoundsList;
begin
 lsFreeSpaces:=TimgBoundsList.Create(true);
 for i:=0 to fwImages.Count-1 do begin
  bImg:=TimgBounds.Create;
  fwIm:=TfwImage(fwImages[i]);
  bImg.iStart:=fwIm.StartAddress;
  bImg.iEnd:=fwIm.EndAddress;
  lsFreeSpaces.Add(bImg);
 end;
 //Sort list
 for i:=0 to lsFreeSpaces.Count-1 do begin
  for j:=i to lsFreeSpaces.Count-1 do begin
   if lsFreeSpaces[i].iStart>lsFreeSpaces[j].iStart then
    lsFreeSpaces.Exchange(i,j);
  end;
 end;
 ShowMessage(IntToStr(lsFreeSpaces.Count));
 //Merge list items
 for i:=lsFreeSpaces.Count-1 downto 1 do begin
  if lsFreeSpaces.Items[i].iStart=lsFreeSpaces.Items[i-1].iEnd then begin
   lsFreeSpaces.Items[i-1].iEnd:=lsFreeSpaces.Items[i].iEnd;
   lsFreeSpaces.Delete(i);
  end;
 end;
 ShowMessage(IntToStr(lsFreeSpaces.Count));
 for i:=lsFreeSpaces.Count-1 downto 1 do begin
  if lsFreeSpaces.Items[i].iStart=lsFreeSpaces.Items[i-1].iEnd then begin
   lsFreeSpaces.Items[i-1].iEnd:=lsFreeSpaces.Items[i].iEnd;
   lsFreeSpaces.Delete(i);
  end;
 end;
 ShowMessage(IntToStr(lsFreeSpaces.Count));
end;

{ TimgBoundsList }

function TimgBoundsList.GetItem(Index: Integer): TimgBounds;
begin
  Result := TimgBounds(inherited Items[Index]);
end;

procedure TimgBoundsList.SetItem(Index: Integer; const Value: TimgBounds);
begin
  inherited Items[Index] := Value;
end;

procedure TfmMain.ConvertToRGBA(fName: TFileName);
var
 path,name,tmpcDir,outStr:string;
 exCode:Cardinal;
 appd:string;
begin
 path:=ExtractFilePath(fName);
 name:=ExtractFileName(fName);
 tmpcDir:=GetCurrentDir;
 SetCurrentDir(path);
 DeleteFile(ChangeFileExt(name,'.new'));
 appd:=ExtractFilePath(Application.ExeName);
 //Now try pngcrush
 exCode:=WinExec32AndRedirectOutput(appd+'pngcrush -c 6 -force '+name+' '+ChangeFileExt(name,'.new'),outStr);
 if exCode<>0 then begin
  MessageBox(Application.Handle, PAnsiChar(_('Error while converting image to RGBA!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr), PChar(_('Error!')), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
 DeleteFile(name);
 RenameFile(ChangeFileExt(name,'.new'),name);
 SetCurrentDir(tmpcDir);
end;

procedure TfmMain.btSaveProjectClick(Sender: TObject);
var
 i:integer;
 tmpStr:string;
 fs:TFileStream;
 f:TZCompressionStream;
begin
 DisableForm;
 sbStatus.Panels[0].Text:=_('Saving project...');
 SaveDialog1.Filter:=_('IMT files (*.imt)|*.imt|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.imt')) then begin
  if MessageBox(Application.Handle, PChar(_('File already exists. Rewrite?')), PChar(_('Rewrite?')), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   EnableForm;
   Exit;
  end
 end;
 fs:=TFileStream.Create(SaveDialog1.FileName,fmCreate);
 f:=TZCompressionStream.Create(fs,zcDefault);
 //Write original firmware
 sWriteBlock(f,Length(fwOrig));
 sWriteBlock(f,String(fwOrig));
 //Write changed firmware
 sWriteBlock(f,Length(fw));
 sWriteBlock(f,String(fw));
 //Write original images
 sWriteBlock(f,fwImagesOrig.Count);
 for i:=0 to fwImagesOrig.Count-1 do begin
  tmpStr:=TfwImage(fwImagesOrig[i]).SaveToString;
  sWriteBlock(f,tmpStr);
 end;
 //Write changed images
 sWriteBlock(f,fwImages.Count);
 for i:=0 to fwImages.Count-1 do begin
  tmpStr:=TfwImage(fwImages[i]).SaveToString;
  sWriteBlock(f,tmpStr);
 end;
 f.Free;
 fs.Free;
 EnableForm;
end;

procedure TfmMain.btLoadProjectClick(Sender: TObject);
var
 count,i:integer;
 tmpStr:string;
 fs:TFileStream;
 f:TZDecompressionStream;
 fwim:TfwImage;
begin
 DisableForm;
 sbStatus.Panels[0].Text:=_('Loading project...');
 OpenDialog1.Filter:=_('IMT files (*.imt)|*.imt|All files (*.*)|*.*');
 if not OpenDialog1.Execute then begin
  EnableForm;
  Exit;
 end;
 fs:=TFileStream.Create(OpenDialog1.FileName,fmOpenRead);
 f:=TZDecompressionStream.Create(fs);
 //Read original firmware
 count:=StrToInt(sReadBlock(f));
 tmpStr:=sReadBlock(f);
 setLength(fwOrig,count);
 for i:=1 to Length(tmpStr) do begin
  fwOrig[i-1]:=ord(tmpStr[i]);
 end;
 //Read changed firmware
 count:=StrToInt(sReadBlock(f));
 tmpStr:=sReadBlock(f);
 setLength(fw,count);
 for i:=1 to Length(tmpStr) do begin
  fw[i-1]:=ord(tmpStr[i]);
 end;
 //Read original images
 count:=StrToInt(sReadBlock(f));
 for i:=0 to count-1 do begin
  tmpStr:=sReadBlock(f);
  fwim:=TfwImage.Create;
  try
   fwim.LoadFromString(tmpStr);
  except
   on E:Exception do begin
    MessageBox(Application.Handle, PChar(E.Message), PChar(_('Error')), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
    EnableForm;
    Exit;
   end;
  end;
  fwImages.Add(fwim);
 end;
 //Read changed images
 count:=StrToInt(sReadBlock(f));
 for i:=0 to count-1 do begin
  tmpStr:=sReadBlock(f);
  fwim:=TfwImage.Create;
  fwim.LoadFromString(tmpStr);
  fwImagesOrig.Add(fwim);
 end;
 f.Free;
 fs.Free;
 StartPNGAddreses.Clear;
 for i:=0 to fwImages.Count-1 do begin
  fwim:=TfwImage(fwImages[i]);
  if fwim.imgType=imPNG then
   StartPNGAddreses.Add('PNG $'+IntToHex(fwim.StartAddress,8))
  else if fwim.imgType=imPKI then
   StartPNGAddreses.Add('PKI $'+IntToHex(fwim.StartAddress,8));
 end;
 lbImages.Items.AddStrings(StartPNGAddreses);
 FixPNGs;
 EnableForm;
 if lbImages.Count>0 then lbImages.ItemIndex:=0;
 sbStatus.Panels[1].Text:=IntToStr(lbImages.Count)+_(' images found')+'    ';
 lbImagesClick(Self);
 lbImages.Repaint;
end;

procedure TfmMain.btDelImgClick(Sender: TObject);
var
 Res:TResourceStream;
 im:TPNGObject;
 fwim:TfwImage;
 Buf:TByteArray;
 b1:char;
 i:integer;
 ms:TStringStream;
 tmpStr:string;
begin
 fwim:=TfwImage(fwImages[lbImages.ItemIndex]);
 if fwim.imgType=imPNG then begin
  Res := TResourceStream.Create(hInstance, 'EMPTYPNG', Pchar('PNG1'));
  SetLength(Buf,Res.Size);
  for i:=0 to Res.Size-1 do begin
   Res.Read(b1,1);
   Buf[i]:=ord(b1);
  end;
  fwim.SetPicture(fw,Buf,1,1);
  Res.Free;
 end else if fwim.imgType=imPKI then begin
  im:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,1,1);
  Buf:=SavePacked(im);
  ms:=TStringStream.Create(String(Buf));
  Buf:=Zlib(ms);
  ms.Free;
  im.Free;
  fwim.SetPicture(fw,Buf,1,1);
 end;
 fwim.Empty:=true;
 fwim.UpdateSize(fw);
 SetLength(FreeBlocks,Length(FreeBlocks)+1);
 FreeBlocks[Length(FreeBlocks)-1]:=fwim;
 im:=TfwImage(fwImages[lbImages.ItemIndex]).GetPicture(fw);
 if TfwImage(fwImages[lbImages.ItemIndex]).imgType=imPNG then
  im:=FixImageColors(im);
 fixedPNGImages.Items[lbImages.ItemIndex]:=im;
 imPreview.Picture.Assign(im);
  tmpStr:='  '+_('Image type: ');
  if fwim.imgType=imPNG then
   tmpStr:=tmpStr+_('PNG')
  else if fwim.imgType=imPKI then
   tmpStr:=tmpStr+_('packed');
  tmpStr:=tmpStr+#10#13+'  '+_('Pixels size: ')+IntToStr(fwim.Fim_width)+'x'+IntToStr(fwim.Fim_height);
  tmpStr:=tmpStr+#10#13+'  '+_('Bytes size: ')+IntToStr(fwim.FimRealSize);
  tmpStr:=tmpStr+#10#13+'  '+_('Space for image: ')+IntToStr(fwIm.FimDataSize);
  lbImageInfo.Caption:=tmpStr;
end;

end.
