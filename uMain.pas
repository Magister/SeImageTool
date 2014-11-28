unit uMain;

{.$define debug}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sAlphaListBox, ComCtrls, acProgressBar,
  ExtCtrls, sMemo, pngImage, Contnrs, sStatusBar, ExtDlgs, sSkinProvider,
  sSkinManager, sSplitter, sPanel, sLabel, Menus, ShellAPI,
  JvFormPlacement, JvComponentBase, JvAppStorage, JvAppRegistryStorage,
  sCheckBox, sEdit, sSpinEdit, JclMiscel, sComboBox, AbZlTyp, ZlibEx123,
  Buttons, sBitBtn, sHintManager, sBevel, gnugettext, sRadioButton,
  JclCompression, sGroupBox, uStreamIO, JvSearchFiles, languagecodes, uByteUtils,
  DateUtils, XPMan, PngBitBtn, ImgList, PngImageList, ActnList, sListView,
  JvExStdCtrls, JvListComb, ToolWin, sToolBar;

type
  TImgType=(imPNG,imPKI,imBWI,imUNK);
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
    sPanel2: TsPanel;
    sSplitter1: TsSplitter;
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
    sHintManager1: TsHintManager;
    sLabel4: TsLabel;
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
    btLoadProject: TsBitBtn;
    btSaveProject: TsBitBtn;
    sBevel4: TsBevel;
    sBevel5: TsBevel;
    sfSearch: TJvSearchFiles;
    XPManifest1: TXPManifest;
    PngImageList1: TPngImageList;
    btOpenFw: TsBitBtn;
    btSaveImg: TsBitBtn;
    btDelImg: TsBitBtn;
    btReplaceImg: TsBitBtn;
    btMakeVKP: TsBitBtn;
    btClearFW: TsBitBtn;
    lbNoWarranty: TsLabelFX;
    sPanel5: TsPanel;
    lbFreeBlocks: TLabel;
    ActionList1: TActionList;
    acOpen: TAction;
    acSaveImg: TAction;
    acDeleteImg: TAction;
    acReplaceImg: TAction;
    acMakeVKP: TAction;
    acClearFW: TAction;
    acLoadProject: TAction;
    acSaveProject: TAction;
    acRestoreOriginal: TAction;
    btAbout: TsBitBtn;
    acAbout: TAction;
    cbExpertMode: TsCheckBox;
    sSplitter2: TsSplitter;
    pnDevControls: TsToolBar;
    ToolButton2: TToolButton;
    btShowImageAddress: TToolButton;
    pnLog: TsPanel;
    meLog: TsMemo;
    lbData: TsLabel;
    btClearLog: TsBitBtn;
    acClearLog: TAction;
    sPanel6: TsPanel;
    lbImages: TsListBox;
    sPanel7: TsPanel;
    cbDeleted: TsCheckBox;
    cbReplaced: TsCheckBox;
    cbUnchanged: TsCheckBox;
    edFilterName: TsEdit;
    lbFilteredImages: TsLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbImagesClick(Sender: TObject);
    procedure tmHideProgressTimer(Sender: TObject);
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
    procedure btSaveOrigClick(Sender: TObject);
    procedure btSaveReplClick(Sender: TObject);
    procedure btOpenOrigClick(Sender: TObject);
    procedure btOpenReplClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sSplitter1Resize(Sender: TObject);
    procedure lbImagesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acOpenExecute(Sender: TObject);
    procedure acSaveImgExecute(Sender: TObject);
    procedure acDeleteImgExecute(Sender: TObject);
    procedure acReplaceImgExecute(Sender: TObject);
    procedure acMakeVKPExecute(Sender: TObject);
    procedure acClearFWExecute(Sender: TObject);
    procedure acLoadProjectExecute(Sender: TObject);
    procedure acSaveProjectExecute(Sender: TObject);
    procedure acRestoreOriginalExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure cbExpertModeClick(Sender: TObject);
    procedure btShowImageAddressClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure acClearLogExecute(Sender: TObject);
    procedure cbDeletedClick(Sender: TObject);
    procedure cbReplacedClick(Sender: TObject);
    procedure cbUnchangedClick(Sender: TObject);
    procedure edFilterNameChange(Sender: TObject);
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
    function GenerateVKP(const fwSrc,fwMod:TByteArray):TStringList;overload;
    function GenerateVKP(const fwSrc,fwMod:PByte;iLen:Cardinal):TStringList;overload;
    function GenerateVKP(const fwSrc:PByte):TStringList;overload;
    function GenTempFileName:TFileName;
    procedure OptimizeImg(fName:TFileName);
//    procedure ExtractPNGOut(path:string);
//    procedure ExtractApfZapf(path:string);
    procedure FixPNGs;
//    procedure ReadImgTable(const fw:TByteArray);
    procedure ReadImgTable;
    function CreatePatchPreview:TPNGObject;
    procedure DrawPNG(dst:TPNGObject;const src:TPNGObject;Left,Top:integer);
    //
    procedure ConvertToRGBA(fName:TFileName);
    function GetCurrentImg:integer;
    procedure UpdateFilter;
  public
    { Public declarations }
  end;

const
  swversion='2.02 (c) 2008 Magister';
  iVersion=202;

type
  TFreeBlock=record
   Offset:LongInt;
   Length:LongInt;
   idx:integer;
  end;
  TBlockArray=array of TFreeBlock;

var
  fmMain: TfmMain;
  footer:string[8];
  headerPNG:string[16];
  headerGIF:string[6];
  fwFileName:string;
  Stop:boolean=true;
  StopSlide:boolean=false;
  Languages:TStringList;
  FreeBlocks:TBlockArray;
  replacedCount,replacedSize,maxImage:LongInt;
  imgbase:DWORD=$44140000;
  loadedBABE:boolean;

//New
type
 TfnImage=record
  StartOffset:LongInt;
  DataLength:LongInt;
  ImgLength:LongInt;
  imType:TImgType;
  Image:TPNGObject;
  RAWData:TByteArray;
  name:string[10];
  im_width:integer;
  im_height:integer;
  empty:boolean;
  Replaced:boolean;
  orig_offset:LongInt;
 end;
 TimArray=array of TfnImage;

var
 hRAWFile:Integer;
 hMemFile:THandle;
 FData:PByte;
// FNewData:PByte;
 iFileLen:LongInt;
 tableStart,pheader,numIcons,offset,picbase,names,offsettable:LongInt;
 imArray:TimArray;
 imArrayRepl:TimArray;
 //
 deletedImg:TPNGObject;
 //speed
 stTime:TDateTime;
 //deletion
 GlobalDeleted:LongInt;
 GlobalDeletedIdx:integer;
 //filter
 lsImages:TStringList;

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

implementation

uses StrUtils, Math, uWaitForm, uAbout;

{$R *.dfm}
//{$R pngout.res}
//{$R apfzapf.res}
{$R empty.res}

procedure DeleteFromArray(var arr:TBlockArray; const idx:integer);
var
 i:integer;
begin
 for i:=idx to Length(arr)-2 do
  arr[i]:=arr[i+1];
 SetLength(arr,Length(arr)-1);
end;

procedure SortFreeBlocks(var Blocks:TBlockArray);
var
 i,j:integer;
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

procedure RealignFreeBlocks;
var
 i,j:integer;
 tmpFb:TFreeBlock;
 tmpStr:string;
 totalLen:LongInt;
 minBlock,maxBlock:LongInt;
begin
 if Length(FreeBlocks)<1 then begin
  fmMain.lbFreeBlocks.Caption:='';
  Exit;
 end;
  for i:=0 to Length(FreeBlocks)-1 do begin
   for j:=i+1 to Length(FreeBlocks)-1 do begin
    if FreeBlocks[i].Offset>FreeBlocks[j].Offset then begin
     tmpFb:=FreeBlocks[i];
     FreeBlocks[i]:=FreeBlocks[j];
     FreeBlocks[j]:=tmpFb;
    end;
   end;
  end;
  for i:=Length(FreeBlocks)-1 downto 1 do begin
   if FreeBlocks[i].Offset=FreeBlocks[i-1].Offset then
    DeleteFromArray(FreeBlocks,i);
  end;
  for i:=Length(FreeBlocks)-1 downto 1 do begin
   if FreeBlocks[i].Offset=FreeBlocks[i-1].Offset+FreeBlocks[i-1].Length+1 then begin
    FreeBlocks[i-1].Length:=FreeBlocks[i-1].Length+FreeBlocks[i].Length;
    DeleteFromArray(FreeBlocks,i);
   end;
  end;
 minBlock:=FreeBlocks[0].Length;
 maxBlock:=minBlock;
 totalLen:=0;
 for i:=0 to Length(FreeBlocks)-1 do begin
  totalLen:=totalLen+FreeBlocks[i].Length;
  if minBlock>FreeBlocks[i].Length then minBlock:=FreeBlocks[i].Length;
  if maxBlock<FreeBlocks[i].Length then maxBlock:=FreeBlocks[i].Length;
 end;
 if replacedSize>totalLen then
  fmMain.lbFreeBlocks.Font.Color:=clRed
 else
  fmMain.lbFreeBlocks.Font.Color:=clWindowText;
 if maxBlock<maxImage then
  fmMain.lbFreeBlocks.Font.Color:=clRed;
 tmpStr:=Format(_('Free space: %d bytes in %d blocks'),[totalLen,Length(FreeBlocks)]);
 tmpStr:=tmpStr+#10#13+Format(_('Largest block: %d bytes; Smallest block: %d bytes'),[maxBlock,minBlock]);
 tmpStr:=tmpStr+#10#13+Format(_('Need to replace: %d images consuming %d bytes'),[replacedCount,replacedSize]);
 fmMain.lbFreeBlocks.Caption:=tmpStr;
end;

{Get translation converted to string}
function _(msgid:string):AnsiString;overload;
begin
 Result:=gnugettext._(msgid);
end;

procedure SetImgParamsFromHeader(const P:PByte;var imrec:TfnImage);
begin
 imrec.im_width:=GetDWORD(P,imrec.StartOffset+picbase+1);
 imrec.im_height:=GetDWORD(P,imrec.StartOffset+picbase+3);
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

function LoadPacked(const fStream:TStream; const im_width,im_height: integer):TPNGObject;overload;
var
 x,y:integer;
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

function LoadBWI(const fw:TByteArray; adr:dword):TPNGObject;overload;
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
 inc (adr);
 n:=0;
 Result:=TPNGObject.CreateBlank(COLOR_RGB,8,xsz,ysz);
 repeat // разматываем....
  if (n and 7)=0 then  begin
   b:=fw[adr];
   adr:=adr+1;
  end;
  n:=n+1;
  if (b and 1)=1 then
   Result.Canvas.Pixels[x,y]:=clBlack
  else
   Result.Canvas.Pixels[x,y]:=clWhite;
  b:=b shr 1;
  x:=x+1;
  if x=xsz then begin
   x:=0;
   y:=y+1;
  end;
 until((n>xsz*ysz));
end;

function LoadBWI(const P:PByte; imAddr:dword; var img:TfnImage):TPNGObject;overload;
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
 img.DataLength:=xsz*ysz;
 img.ImgLength:=img.DataLength;
 Result:=TPNGObject.CreateBlank(COLOR_RGB,8,xsz,ysz);
 adr:=adr+6; // скипаем остальные запчасти хедэра
 inc (adr);
 n:=0;
 repeat // разматываем....
  if (n and 7)=0 then  begin
   b:=GetByte(P,adr);
   adr:=adr+1;
  end;
  n:=n+1;
  if (b and 1)=1 then
   Result.Canvas.Pixels[x,y]:=clBlack
  else
   Result.Canvas.Pixels[x,y]:=clWhite;
  b:=b shr 1;
  x:=x+1;
  if x=xsz then begin
   x:=0;
   y:=y+1;
  end;
 until((n>xsz*ysz));
end;

function SwapRGBtpBGR(color: TColor): TColor;
var
 crgb:Longint;
begin
 crgb:=ColorToRGB(color);
 Result:=RGB(GetBValue(crgb),GetGValue(crgb),GetRValue(crgb));
end;

procedure CopyAlpha(var src, dst: TPNGObject);
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

function FixImageColors(img: TPNGObject): TPNGObject;
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

function LoadPNG(const P:PByte; imAddr:dword; var img:TfnImage; const stOffset:Cardinal=12):TPNGObject;overload;
var
 tmpWindow:PChar;
 sigLen:integer;
 i,Len:Cardinal;
 fs:TStringStream;
 tmpStr:string;
begin
 tmpWindow:=PChar(#$49#$45#$4E#$44#$AE#$42#$60#$82);
 sigLen:=Length(footer);
 tmpStr:='';
 Len:=0;
 for i:=imAddr+stOffset to iFileLen-1 do begin
  if CompareMem(tmpWindow,Pointer(Cardinal(P)+i),sigLen) then begin
   Len:=i+Length(footer);
   break;
  end;
 end;
 for i:=imAddr+stOffset to Len-1 do begin
  tmpStr:=tmpStr+chr(PByte(Cardinal(P)+i)^);
 end;
 Len:=Len-stOffset;
 img.DataLength:=Len-imAddr;
 img.ImgLength:=Len-imAddr;
 fs:=TStringStream.Create(tmpStr);
 Result:=TPNGObject.Create;
 Result.LoadFromStream(fs);
 Result:=FixImageColors(Result);
 img.im_width:=Result.Width;
 img.im_height:=Result.Height;
 fs.Free;
end;

function GetImgFromArray(Data:PByte;arr:TimArray;Index:integer):TPNGObject;
var
 tmpStr:string;
 fs:TStringStream;
begin
 if arr[Index].Image=nil then begin
  if arr[Index].imType=imPKI then begin
   SetImgParamsFromHeader(Data,arr[Index]);
   tmpStr:=DecompressImg(Data,arr[Index].StartOffset+picbase,iFileLen,arr[Index].DataLength);
   arr[Index].ImgLength:=arr[Index].DataLength;
   fs:=TStringStream.Create(tmpStr);
   Result:=LoadPacked(fs,arr[Index].im_width,arr[Index].im_height);
   arr[Index].Image:=Result;
   fs.Free;
  end else if arr[Index].imType=imBWI then begin
   Result:=LoadBWI(Data,arr[Index].StartOffset+picbase,arr[Index]);
   arr[Index].Image:=Result;
  end else if arr[Index].imType=imPNG then begin
   Result:=LoadPNG(Data,arr[Index].StartOffset+picbase,arr[Index]);
   arr[Index].Image:=Result;
  end else begin
   Result:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,1,1);
   arr[Index].Image:=Result;
  end;
 end else begin
  Result:=arr[Index].Image;
 end;
end;

function PlaceImages:TimArray;
var
 i,j:integer;
 imToPlace:TimArray;
 tmpImg:TfnImage;
 tmpBlocks:TBlockArray;
 imgOk:boolean;
 imLen:Integer;
 globIdx:integer;
 reAdressedNames:array of TfnImage;
 brIteration:boolean;
 tmpStr,tmpStr2:string;
 tmpCount,tmpSize:LongInt;
begin
 fmMain.meLog.Lines.Add('--------------- Trying to place images ---------------');
 Result:=nil;
 globIdx:=0;
 SetLength(tmpBlocks,Length(FreeBlocks));
 for i:=0 to Length(FreeBlocks)-1 do
  tmpBlocks[i]:=FreeBlocks[i];
 for i:=0 to Length(imArrayRepl)-1 do begin
  if ((imArrayRepl[i].Replaced) and (not imArrayRepl[i].empty))
        or (i=GlobalDeletedIdx) then begin
   GetImgFromArray(FData,imArray,i);
   SetLength(imToPlace,Length(imToPlace)+1);
   imToPlace[Length(imToPlace)-1]:=imArrayRepl[i];
   if i=GlobalDeletedIdx then globIdx:=Length(imToPlace)-1;
  end;
 end;
 tmpImg:=imToPlace[globIdx];
 imToPlace[globIdx]:=imToPlace[0];
 imToPlace[0]:=tmpImg;
 globIdx:=0;
 for i:=1 to Length(imToPlace)-1 do begin
  for j:=i+1 to Length(imToPlace)-1 do begin
   if imToPlace[i].ImgLength>imToPlace[j].ImgLength then begin
    tmpImg:=imToPlace[i];
    imToPlace[i]:=imToPlace[j];
    imToPlace[j]:=tmpImg;
   end;
  end;
 end;
 SortFreeBlocks(tmpBlocks);
 i:=-1;
 while i<Length(tmpBlocks) do begin
  i:=i+1;
  if tmpBlocks[i].Length<Length(imToPlace[globIdx].RAWData) then continue;
  imToPlace[globIdx].StartOffset:=tmpBlocks[i].Offset;
  tmpBlocks[i].Offset:=tmpBlocks[i].Offset+Length(imToPlace[globIdx].RAWData)+1;
  tmpBlocks[i].Length:=tmpBlocks[i].Length-(Length(imToPlace[globIdx].RAWData)+1);
  break;
 end;
 GlobalDeleted:=imToPlace[globIdx].StartOffset;
 for i:=0 to Length(imToPlace)-1 do begin
  if i=globIdx then continue;
  brIteration:=false;
  for j:=0 to Length(reAdressedNames)-1 do begin
   if imToPlace[i].orig_offset=reAdressedNames[j].orig_offset then begin
    imToPlace[i].StartOffset:=reAdressedNames[j].StartOffset;
    tmpStr:=IntToHex(imToPlace[i].StartOffset,6);
    tmpStr2:=Copy(tmpStr,5,2)+Copy(tmpStr,3,2)+Copy(tmpStr,1,2);
    fmMain.meLog.Lines.Add('Image: '+imToPlace[i].name+' is a duplicate of '+reAdressedNames[j].name+', offset: '+tmpStr2);
    brIteration:=true;
    break;
   end;
  end;
  if brIteration then continue;
  SortFreeBlocks(tmpBlocks);
  imgOk:=false;
  imLen:=Length(imToPlace[i].RAWData);
  for j:=0 to Length(tmpBlocks)-1 do begin
   if imLen<=tmpBlocks[j].Length then begin
    imToPlace[i].StartOffset:=tmpBlocks[j].Offset;
    tmpStr:=IntToHex(imToPlace[i].StartOffset,6);
    tmpStr2:=Copy(tmpStr,5,2)+Copy(tmpStr,3,2)+Copy(tmpStr,1,2);
    fmMain.meLog.Lines.Add('Image: '+imToPlace[i].name+'; offset: '+tmpStr2+'; length: '+IntToHex(imToPlace[i].ImgLength,6));
//    fmMain.meLog.Lines.Add('Block before: Start: '+IntToHex(picbase+tmpBlocks[j].Offset,8)+'; End: '+IntToHex(picbase+tmpBlocks[j].Offset+tmpBlocks[j].Length,8));
    tmpBlocks[j].Offset:=tmpBlocks[j].Offset+imLen+1;
    tmpBlocks[j].Length:=tmpBlocks[j].Length-(imLen+1);
//    fmMain.meLog.Lines.Add('Block after: Start: '+IntToHex(picbase+tmpBlocks[j].Offset,8)+'; End: '+IntToHex(picbase+tmpBlocks[j].Offset+tmpBlocks[j].Length,8));
    imgOk:=true;
    break;
   end;
  end;
  SetLength(reAdressedNames,Length(reAdressedNames)+1);
  reAdressedNames[Length(reAdressedNames)-1]:=imToPlace[i];
  if not imgOk then begin
   MessageBox(Application.Handle, PAnsiChar(AnsiString(_('There is no enough free space to replace all images.'+#13+#10+'Either cancel some of the replacements, or delete one or more images to get free space.'))), PAnsiChar(AnsiString(_('Not enough free blocks'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
   Result:=nil;
   reAdressedNames:=nil;
   fmMain.meLog.Lines.Add('----------------------- Failed -----------------------');
   Exit;
  end;
 end;
 tmpCount:=0;
 tmpSize:=0;
 for i:=0 to Length(tmpBlocks)-1 do begin
  tmpCount:=tmpCount+1;
  tmpSize:=tmpSize+tmpBlocks[i].Length;
 end;
 fmMain.meLog.Lines.Add(Format('%d free blocks left, total size: %d',[tmpCount,tmpSize]));
 Result:=imToPlace;
 reAdressedNames:=nil;
 fmMain.meLog.Lines.Add('------------------------- Ok -------------------------');
// for i:=0 to Length(imToPlace)-1 do begin
//  for j:=0 to Length(imArrayRepl)-1 do begin
//   if imArrayRepl[j].orig_offset=imToPlace[i].orig_offset then
//    imArrayRepl[j]:=imToPlace[i];
//  end;
// end;
// Result:=true;
end;

function GetImgFromRawData(arr:TimArray;Index:integer):TPNGObject;
var
 tmpStr:string;
 len:integer;
 fs:TStringStream;
 Data:PByte;
 i:integer;
 dLen:Integer;
begin
 len:=Length(arr[Index].RAWData);
 GetMem(Data,len);
 dLen:=arr[Index].DataLength;
 for i:=0 to len-1 do
  SetByte(Data,i,arr[Index].RAWData[i]);
 if arr[Index].Image=nil then begin
  if arr[Index].imType=imPKI then begin
   tmpStr:=DecompressImg(Data,0,len,len);
   fs:=TStringStream.Create(tmpStr);
   Result:=LoadPacked(fs,arr[Index].im_width,arr[Index].im_height);
   arr[Index].Image:=Result;
   fs.Free;
  end else if arr[Index].imType=imBWI then begin
   Result:=LoadBWI(Data,0,arr[Index]);
   arr[Index].Image:=Result;
  end else if arr[Index].imType=imPNG then begin
   Result:=LoadPNG(Data,0,arr[Index]);
   arr[Index].Image:=Result;
  end else begin
   Result:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,1,1);
   arr[Index].Image:=Result;
  end;
  arr[Index].DataLength:=dLen;
 end else begin
  Result:=arr[Index].Image;
 end;
 FreeMem(Data);
end;

procedure SetPicture(const FData:PByte;var fim:TfnImage;const Buf:TByteArray;const w,h:integer);
var
// nEqual:boolean;
 tmpHex:string;
 newImSize:integer;
 i,c:integer;
begin
// nEqual:=false;
// if GetByte(FData,fim.StartOffset+picbase+1)<>GetByte(FData,fim.StartOffset+picbase+7) then nEqual:=true;
// if GetByte(FData,fim.StartOffset+picbase+3)<>GetByte(FData,fim.StartOffset+picbase+9) then nEqual:=true;
// if nEqual then
//  if MessageBox(Application.Handle, PChar(_('New image size differs from original, but cannot be safely saved!'+#13+#10+'Replace anyway?')), PChar(_('Warning!')), MB_ICONWARNING or MB_YESNO or MB_TASKMODAL)<>idYes then Exit;
 SetByte(FData,fim.StartOffset+picbase,StrToInt('$AA'));
 if fim.imType=imPKI then
  SetByte(FData,fim.StartOffset+picbase+11,StrToInt('$5A'))
 else if fim.imType=imPNG then
  SetByte(FData,fim.StartOffset+picbase+11,StrToInt('$89'));
 newImSize:=Length(Buf);
 tmpHex:=IntToHex(w,4);
 SetByte(FData,fim.StartOffset+picbase+2,StrToInt('$'+Copy(tmpHex,1,2)));
 SetByte(FData,fim.StartOffset+picbase+1,StrToInt('$'+Copy(tmpHex,3,2)));
 SetByte(FData,fim.StartOffset+picbase+8,StrToInt('$'+Copy(tmpHex,1,2)));
 SetByte(FData,fim.StartOffset+picbase+7,StrToInt('$'+Copy(tmpHex,3,2)));
 tmpHex:=IntToHex(h,4);
 SetByte(FData,fim.StartOffset+picbase+4,StrToInt('$'+Copy(tmpHex,1,2)));
 SetByte(FData,fim.StartOffset+picbase+3,StrToInt('$'+Copy(tmpHex,3,2)));
 SetByte(FData,fim.StartOffset+picbase+10,StrToInt('$'+Copy(tmpHex,1,2)));
 SetByte(FData,fim.StartOffset+picbase+9,StrToInt('$'+Copy(tmpHex,3,2)));
 //replace
 c:=0;
 for i:=fim.StartOffset+picbase+12 to fim.StartOffset+picbase+fim.DataLength+11 do begin
  if c<newImSize then begin
   SetByte(FData,i,Buf[c])
  end else begin
   SetByte(FData,i,0);
  end;
  c:=c+1;
 end;
 fim.ImgLength:=newImSize;
end;

function ImgToString(im:TfnImage):string;
begin
 with im do begin
  if im.imType=imPKI then
   Result:='0'
  else if imType=imPNG then
   Result:='1'
  else if imType=imBWI then
   Result:='2';
  Result:=Result+#0+
          IntToStr(StartOffset)+#0+
          IntToStr(DataLength)+#0+
          IntToStr(ImgLength)+#0+
          IntToStr(im_width)+#0+
          IntToStr(im_height)+#0+
          BoolToStr(empty)+#0+
          BoolToStr(Replaced)+#0+
          name+#0+
          IntToStr(orig_offset);
 end;
end;

function ImgFromString(str:string):TfnImage;
var
 sl:TStringList;
begin
 sl:=SplitString(Str,#0);
 if sl.Count<10 then begin
  raise Exception.Create(_('Error loading image'));
  Exit;
 end;
 if sl[0]='0' then
  Result.imType:=imPKI
 else if sl[0]='1' then
  Result.imType:=imPNG
 else if sl[0]='2' then
  Result.imType:=imBWI;
 Result.StartOffset:=StrToInt(sl[1]);
 Result.DataLength:=StrToInt(sl[2]);
 Result.ImgLength:=StrToInt(sl[3]);
 Result.im_width:=StrToInt(sl[4]);
 Result.im_height:=StrToInt(sl[5]);
 Result.empty:=StrToBool(sl[6]);
 Result.Replaced:=StrToBool(sl[7]);
 Result.name:=sl[8];
 Result.orig_offset:=StrToInt(sl[9]);
end;

procedure LoadRAW(fName:string);
var
 FmbnData:PByte;
 FmbnByte:PByte;
 Dst:PByte;
 babeHdr:TBABEHDR;
 i:integer;
 newSize:DWORD;
 BlockAddr,BlockLen:DWORD;
begin
 if FData<>nil then begin
  if loadedBABE then
   FreeMem(FData)
  else
   UnmapViewOfFile(FData);
  FData:=nil;
 end;
 hRAWFile:=FileOpen(fName,fmOpenRead or fmShareDenyWrite);
 if hRAWFile<=0 then
  raise Exception.Create(_('Failed to open RAW file'));
 iFileLen:=GetFileSize(hRAWFile,nil);
 hMemFile:=CreateFileMapping(hRAWFile,nil,PAGE_READONLY,0,0,nil);
 if hMemFile=0 then
  raise Exception.Create(_('Failed to open RAW file'));
 CloseHandle(hRAWFile);
 if ExtractFileExt(AnsiUpperCaseFileName(fName))='.MBN' then begin
  fmMain.meLog.Lines.Add('--------------- Trying to open BABE... ---------------');
  FmbnData:=MapViewOfFile(hMemFile,FILE_MAP_READ,0,0,0);
  if FmbnData=nil then
   raise Exception.Create(_('Cannot read MBN file'));
  FmbnByte:=FmbnData;
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
  fmMain.meLog.Lines.Add(Format('Opened as BABE, '+
        'version: %d; '+
        'CID: %d; '+
        'numblocks: %d',
        [babeHdr.headerver,
        babeHdr.cidfile,
        babeHdr.numblocks]));
  FmbnByte:=nil;
  if babeHdr.babefile<>$BEBA then begin
   UnmapViewOfFile(FmbnData);
   FmbnData:=nil;
   MessageBox(Application.Handle, PChar(AnsiString(_('It''s not a BABE file or it is corrupted, cannot open!'))), PChar(AnsiString(_('Error'))), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
   Exit;
  end;
  if (babeHdr.headerver = 4) then begin
   FmbnByte:=FmbnData;
   inc(FmbnByte,babeHdr.numblocks*20+$380);
   FData:=nil;
   newSize:=0;
   imgbase:=PDWord(FmbnByte)^;
   fmMain.meLog.Lines.Add('Image base: $'+IntToHex(imgbase,8));
   for i:=0 to babeHdr.numblocks-1 do begin
    BlockAddr:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(BlockAddr));
    BlockLen:=PDWord(FmbnByte)^;
    inc(FmbnByte,sizeof(BlockLen));
    newSize:=newSize+BlockLen;
    ReallocMem(FData,newSize);
    Dst:=PByte(DWORD(FData)+BlockAddr-imgbase);
    CopyMemory(Dst,FmbnByte,BlockLen);
    inc(FmbnByte,BlockLen);
   end;
  end else begin
   UnmapViewOfFile(FmbnData);
   FmbnData:=nil;
   MessageBox(Application.Handle, PChar(Format(_('Not supported BABE version: %d'),[babeHdr.headerver])), PChar(AnsiString(_('Error'))), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
   Exit;
  end;
  UnmapViewOfFile(FmbnData);
  fmMain.meLog.Lines.Add('----------------------- Ok ---------------------------');
 end else begin
  imgbase:=$44140000;
  FData:=MapViewOfFile(hMemFile,FILE_MAP_READ,0,0,0);
  if FData=nil then
   raise Exception.Create(_('Cannot read RAW file'));
 end;
 CloseHandle(hMemFile);
end;

procedure SetRAWData(var fim:TfnImage;const Buf:TByteArray);
var
 i:integer;
 tmpHex:string;
begin
 SetLength(fim.RAWData,Length(Buf)+12);
 fim.ImgLength:=Length(Buf);
 for i:=0 to 11 do
  fim.RAWData[i]:=GetByte(FData,picbase+fim.StartOffset+i);

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
 if fim.imType=imPKI then
  fim.RAWData[11]:=StrToInt('$5A')
 else if fim.imType=imPNG then
  fim.RAWData[11]:=StrToInt('$89');
 for i:=0 to Length(Buf)-1 do
  fim.RAWData[i+12]:=Buf[i];
end;

procedure RecalculateFreeBlocks;
var
 i:integer;
begin
 FreeBlocks:=nil;
 for i:=0 to Length(imArrayRepl)-1 do begin
  if not (imArrayRepl[i].empty or imArrayRepl[i].Replaced) then continue;
  SetLength(FreeBlocks,Length(FreeBlocks)+1);
//  if GlobalDeletedIdx=i then begin
//   FreeBlocks[Length(FreeBlocks)-1].Offset:=imArray[i].StartOffset+Length(imArrayRepl[i].RAWData);
//   FreeBlocks[Length(FreeBlocks)-1].Length:=imArray[i].DataLength-Length(imArrayRepl[i].RAWData);
//  end else begin
   FreeBlocks[Length(FreeBlocks)-1].Offset:=imArray[i].StartOffset;
   FreeBlocks[Length(FreeBlocks)-1].Length:=imArray[i].DataLength+11;
//  end;
 end;
 RealignFreeBlocks;
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

procedure TfmMain.FormCreate(Sender: TObject);
var
 sl:TStrings;
 i:integer;
 Res:TResourceStream;
begin
 lsImages:=TStringList.Create;
 GlobalDeleted:=-1;
 GlobalDeletedIdx:=-1;
 replacedCount:=0;
 replacedSize:=0;
 maxImage:=0;
 TP_GlobalIgnoreClass(TsSkinManager);
 TP_GlobalIgnoreClass(TJvFormStorage);
 TP_GlobalIgnoreClass(TJvAppRegistryStorage);
 TP_Ignore(Self,'cbLanguage');
// TP_Ignore(Self,'cbSkins');
 TP_GlobalIgnoreClass(TsSpinEdit);
 TP_IgnoreClassProperty(TfmMain,'Caption');
 TranslateComponent(Self);
 sSkinManager1.SkinDirectory:=ExtractFilePath(Application.ExeName)+'Skins';
 sl:=TStringList.Create;
 sSkinManager1.GetSkinNames(sl);
 sl.Insert(0,_('No skin'));
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
 deletedImg:=TPNGObject.Create;
 Res := TResourceStream.Create(hInstance, 'DELETEDPNG', Pchar('PNG2'));
 deletedImg.LoadFromStream(Res);
 Res.Free;
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
 lsImages.Free;
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
(*var
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
 sbStatus.Panels[0].Text:=_('Waiting');*)
var
 aImg:TfnImage;
 tmpStr:string;
begin
// aImg:=imArray[lbImages.ItemIndex];
 aImg:=imArray[getCurrentImg];
 if aImg.imType=imBWI then begin
//  btReplaceImg.Enabled:=false;
//  btDelImg.Enabled:=false;
  acReplaceImg.Enabled:=false;
  acDeleteImg.Enabled:=false;
 end else begin
  acReplaceImg.Enabled:=true;
  acDeleteImg.Enabled:=true;
  btReplaceImg.SkinData.Invalidate;
  btDelImg.SkinData.Invalidate;
 end;
 tmpStr:='  '+_('Image type: ');
 if aImg.imType=imPNG then
  tmpStr:=tmpStr+_('PNG')
 else if aImg.imType=imPKI then
  tmpStr:=tmpStr+_('packed')
 else if aImg.imType=imBWI then
  tmpStr:=tmpStr+_('Black&&White');
 tmpStr:=tmpStr+#10#13+'  '+_('Pixels size: ')+IntToStr(aImg.im_width)+'x'+IntToStr(aImg.im_height);
 tmpStr:=tmpStr+#10#13+'  '+_('Bytes size: ')+IntToStr(aImg.ImgLength);
 tmpStr:=tmpStr+#10#13+'  '+_('Space for image: ')+IntToStr(aImg.DataLength);
 tmpStr:=tmpStr+#10#13+'  '+_('Image address: ')+IntToHex(aImg.StartOffset+picbase,8);
 lbOrigImageInfo.Caption:=tmpStr;
// imOriginal.Picture.Assign(GetImgFromArray(FData,imArray,lbImages.ItemIndex));
 imOriginal.Picture.Assign(GetImgFromArray(FData,imArray,GetCurrentImg));
 if Length(imArrayRepl)>0 then begin
//  if imArrayRepl[lbImages.ItemIndex].empty then begin
  if imArrayRepl[GetCurrentImg].empty then begin
   imPreview.Picture.Assign(deletedImg);
//  end else if imArrayRepl[lbImages.ItemIndex].Replaced then begin
  end else if imArrayRepl[GetCurrentImg].Replaced then begin
//   imPreview.Picture.Assign(GetImgFromRawData(imArrayRepl,lbImages.ItemIndex));
   imPreview.Picture.Assign(GetImgFromRawData(imArrayRepl,GetCurrentImg));
  end else begin
   imPreview.Picture.Bitmap.FreeImage;
  end;
//  aImg:=imArrayRepl[lbImages.ItemIndex];
  aImg:=imArrayRepl[getCurrentImg];
  if (aImg.Replaced) or (aImg.empty) then begin
   tmpStr:='  '+_('Image type: ');
   if aImg.imType=imPNG then
    tmpStr:=tmpStr+_('PNG')
   else if aImg.imType=imPKI then
    tmpStr:=tmpStr+_('packed')
   else if aImg.imType=imBWI then
    tmpStr:=tmpStr+_('Black&&White');
   tmpStr:=tmpStr+#10#13+'  '+_('Pixels size: ')+IntToStr(aImg.im_width)+'x'+IntToStr(aImg.im_height);
   tmpStr:=tmpStr+#10#13+'  '+_('Bytes size: ')+IntToStr(aImg.ImgLength);
   tmpStr:=tmpStr+#10#13+'  '+_('Space for image: ')+IntToStr(aImg.DataLength);
   lbImageInfo.Caption:=tmpStr;
  end else
   lbImageInfo.Caption:='';
 end else begin
  imPreview.Picture.Bitmap.FreeImage;
  lbImageInfo.Caption:='';
 end;
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
    MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Error while working with image!'+#13+#10+'Looks like it''s broken')+#10#13+_('Message: ')+E.Message)), PAnsiChar(AnsiString(_('Error'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
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
   im:=FixImageColors(im);
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
  if MessageBox(Application.Handle, PChar(AnsiString(_('New image size differs from original, but cannot be safely saved!'+#13+#10+'Replace anyway?'))), PChar(AnsiString(_('Warning!'))), MB_ICONWARNING or MB_YESNO or MB_TASKMODAL)<>idYes then Exit;
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
// btOpenFw.Caption:=_('Stop');
 btOpenFw.Hint:=_('Stop processing');
 btOpenFw.Tag:=1;
 Screen.Cursor:=crHourGlass;
 pbProgress.Position:=0;
 pbProgress.Visible:=true;
 Application.ProcessMessages;
 stTime:=Time;
end;

procedure TfmMain.EnableForm;
var
 ok:boolean;
begin
// fmMain.Enabled:=true;
 lbImages.Enabled:=true;
// btOpenFw.Caption:=_('Open');
 btOpenFw.Hint:=_('Open RAW file');
 btOpenFw.Tag:=0;
 Screen.Cursor:=crArrow;
 sbStatus.Panels[0].Text:=Format(_('Finished in %s milliseconds, now waiting'),[IntToStr(MilliSecondsBetween(stTime,Time))]);
 tmHideProgress.Enabled:=true;
 lbImages.Repaint;
 Stop:=true;
 ok:=(lsImages.Count>0);
 acReplaceImg.Enabled:=ok;
 btReplaceImg.SkinData.Invalidate;
 acSaveImg.Enabled:=ok;
 btSaveImg.SkinData.Invalidate;
 acSaveProject.Enabled:=ok;
 btSaveProject.SkinData.Invalidate;
 acMakeVKP.Enabled:=ok;
 btMakeVKP.SkinData.Invalidate;
 acRestoreOriginal.Enabled:=ok;
 btRestoreOriginal.SkinData.Invalidate;
 acClearFW.Enabled:=ok;
 btClearFW.SkinData.Invalidate;
 btOpenOrig.Enabled:=ok;
 btOpenRepl.Enabled:=ok;
 btSaveOrig.Enabled:=ok;
 btSaveRepl.Enabled:=ok;
 acDeleteImg.Enabled:=ok;
 btDelImg.SkinData.Invalidate;
 if ok then begin
  if (lbImages.ItemIndex>=0) and (lbImages.ItemIndex<lbImages.Count) then begin
   if imArray[getCurrentImg].imType=imBWI then begin
    acReplaceImg.Enabled:=false;
    acDeleteImg.Enabled:=false;
   end;
  end;
 end;
 fmWait.Hide;
 lbFilteredImages.Caption:=Format(_('Images shown: %d'),[lbImages.Count]);
end;

procedure TfmMain.tmHideProgressTimer(Sender: TObject);
begin
 pbProgress.Visible:=false;
end;

function TfmMain.GenerateVKP(const fwSrc,fwMod: TByteArray): TStringList;
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
{ tmSlideForm.Enabled:=false;
 StopSlide:=true;
 if fmMain.WindowState=wsMaximized then Exit;
 while fmMain.Top>-(fmMain.Height+10) do begin
  fmMain.Top:=fmMain.Top-20;
  Application.ProcessMessages;
  Sleep(10);
 end;}
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
// fmMain.Top:=-(fmMain.Height+10);
// fmMain.Left:=(Screen.DesktopWidth div 2)-(fmMain.Width div 2);
 lbNoWarranty.AutoSize:=false;
 lbNoWarranty.AutoSize:=true;
// tmSlideForm.Enabled:=true;
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
   if Index=(Control as TsListBox).ItemIndex then begin
    Font.Color:=clYellow;
    Font.Style:=[];
    if Length(imArrayRepl)>0 then begin
     if imArrayRepl[lsImages.IndexOf(lbImages.Items[Index])].Replaced then begin
      Font.Color:=clBlue;
      Font.Style:=[fsBold];
     end;
     if imArrayRepl[lsImages.IndexOf(lbImages.Items[Index])].empty then begin
      Font.Color:=clRed;
      Font.Style:=[fsBold];
     end;
    end;
   end;
  end else begin
   Brush.Color:=(Control as TsListBox).Color;
   if Length(imArrayRepl)>0 then begin
    if imArrayRepl[lsImages.IndexOf(lbImages.Items[Index])].Replaced then
     Brush.Color:=clYellow;
    if imArrayRepl[lsImages.IndexOf(lbImages.Items[Index])].empty then
     Brush.Color:=clSilver;
   end;
  end;
  FillRect(Rect);
  Str:=(Control as TsListBox).Items[Index]+' (';
  if imArray[lsImages.IndexOf(lbImages.Items[Index])].imType=imPKI then
   Str:=Str+'PKI)'
  else if imArray[lsImages.IndexOf(lbImages.Items[Index])].imType=imPNG then
   Str:=Str+'PNG)'
  else if imArray[lsImages.IndexOf(lbImages.Items[Index])].imType=imBWI then
   Str:=Str+'BWI)'
  else
   Str:=Str+'UNK)';
  R:=Rect;
  R.Right:=R.Left+(Control as TsListBox).ItemHeight;
  img:=GetImgFromArray(FData,imArray,lsImages.IndexOf(lbImages.Items[Index]));
  if img.Height<>0 then
   aspRatio:=img.Width/img.Height
  else
   Exit;
  if (aspRatio)<((R.Right-R.Left)/(R.Bottom-R.Top)) then
   R.Right:=R.Left+Round(aspRatio*(R.Right-R.Left))
  else
   R.Bottom:=R.Top+Round((R.Bottom-R.Top)/aspRatio);
  tmpInt:=((Control as TsListBox).ItemHeight-(R.Bottom-R.Top)) div 2;
  R.Bottom:=R.Bottom+tmpInt;
  R.Top:=R.Top+tmpInt;
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
 exCode:=WinExec32AndRedirectOutput(appd+'PngOptimizerCL.exe -file:"'+name+'"',outStr);
 if exCode<>1 then begin
  MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Error while optimizing image!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr)), PChar(AnsiString(_('Error!'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
 exCode:=WinExec32AndRedirectOutput(appd+'optipng.exe -o7 -i0 '+name,outStr);
 if exCode<>0 then begin
  MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Error while optimizing image!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr)), PChar(AnsiString(_('Error!'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
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
 if cbSkins.Text=_('No skin') then begin
  sSkinManager1.Active:=false;
  lbOrigImageInfo.Font.Color:=clWindowText;
  lbImageInfo.Font.Color:=clWindowText;
 end else begin
  sSkinManager1.SkinName:=cbSkins.Text;
  sSkinManager1.Active:=true;
 end;
 lbNoWarranty.AutoSize:=false;
 lbNoWarranty.AutoSize:=true;
 pnAbout.Height:=lbNoWarranty.Height;
 gbOriginal.Width:=(sPanel3.Width-imArrow.Width) div 2;
 btRestoreOriginal.Left:=imArrow.Left+13;
end;

procedure TfmMain.sSkinManager1AfterChange(Sender: TObject);
var
 i:integer;
begin
 if not sSkinManager1.Active then
  cbSkins.ItemIndex:=0
 else for i:=0 to cbSkins.Items.Count-1 do
  if cbSkins.Items[i]=sSkinManager1.SkinName then cbSkins.ItemIndex:=i;
end;

//procedure TfmMain.ReadImgTable(const fw: TByteArray);
procedure TfmMain.ReadImgTable;
(*var
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
 tmpOffset:integer;
 //
 imgCount:integer;
begin
 StartPNGAddreses.Clear;
 imgOffsets.Clear;
 imgCount:=0;
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
 for i:=0 to numIcons-1 do begin
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
end;*)
var
 i:integer;
 tmpWindow:PChar;
 StartAddress:integer;
 imNames:TStrings;
const
 sigLen=13;
begin
// tableStart:=Pos('ICON_16BIT_V2',tmpStr)-13;
 tmpWindow:=PChar('ICON_16BIT_V2');
 for i:=0 to iFileLen-1 do begin
  if CompareMem(tmpWindow,Pointer(Integer(FData)+i),sigLen) then begin
   tableStart:=i-12;
   break;
  end;
 end;
 pheader:=GetDWORD(FData,tableStart+$34);
 numIcons:=pheader;
 offset:=GetDWORD(FData,tableStart+$34+$10);
 picbase:=tableStart+offset;
 names:=tableStart+$34+$10+4;
 offsettable:=names+numIcons*2;
 imNames:=TStringList.Create;
 lbData.Caption:=Format('table start: %s; '+
                        'pheader: %s; '+
                        'images count: %s; '+
                        'offset: %s; '+#10#13+
                        'picbase: %s; '+
                        'names start: %s; '+
                        'offset table: %s; ', 
                [IntToHex(tableStart,8),
                 IntToHex(pheader,8),
                 IntToStr(numIcons),
                 IntToHex(offset,8),
                 IntToHex(picbase,8),
                 IntToHex(names,8),
                 IntToHex(offsettable,8)]);

 SetLength(imArray,numIcons);
 for i:=0 to numIcons-1 do begin
  StartAddress:=Get3Bytes(FData,offsettable+i*3);
  imArray[i].StartOffset:=StartAddress;
  imArray[i].orig_offset:=StartAddress;
  StartAddress:=StartAddress+picbase;
  imArray[i].imType:=imBWI;
  if (GetByte(FData,StartAddress)=$AA) then begin
   if (GetByte(FData,StartAddress+5)=$00) and
      (GetByte(FData,StartAddress+6)=$00) then begin
         imArray[i].imType:=imUNK;
         if GetByte(FData,StartAddress+11)=$5A then imArray[i].imType:=imPKI;
         if GetByte(FData,StartAddress+11)=$89 then imArray[i].imType:=imPNG;
   end;
  end;
  imArray[i].name:=IntToHex(GetDWORD(FData,names+i*2),2);
  imArray[i].DataLength:=-1;
  imArray[i].ImgLength:=-1;
  imArray[i].Image:=nil;
  imArray[i].empty:=false;
  imArray[i].Replaced:=false;
  imNames.Add(imArray[i].name);
 end;
 lbImages.Clear;
 lsImages.Clear;
 lsImages.AddStrings(imNames);
 lbImages.Items.AddStrings(imNames);
 imNames.Free;
 sbStatus.Panels[1].Text:=IntToStr(lsImages.Count)+_(' images found')+'    ';
end;

procedure TfmMain.FormResize(Sender: TObject);
var
 imWidth:integer;
begin
 lbNoWarranty.AutoSize:=false;
 lbNoWarranty.AutoSize:=true;
 pnAbout.Height:=lbNoWarranty.Height;
 imWidth:=sPanel3.Width-imArrow.Width;
 gbOriginal.Width:=imWidth div 2;
 btRestoreOriginal.Left:=imArrow.Left+13;
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
 if not sSkinManager1.Active then begin
  cbSkins.ItemIndex:=0;
  lbOrigImageInfo.Font.Color:=clWindowText;
  lbImageInfo.Font.Color:=clWindowText;
 end else for idx:=0 to cbSkins.Items.Count-1 do
  if cbSkins.Items[idx]=sSkinManager1.SkinName then cbSkins.ItemIndex:=idx;
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
 idx:integer;
begin
 lang:='en';
 lang:=Languages[cbLanguage.ItemIndex];
 UseLanguage(lang);
 RetranslateComponent(fmMain);
 if cbSkins.Items.Count>0 then begin
  idx:=cbSkins.ItemIndex;
  cbSkins.Items[0]:=_('No skin');
  cbSkins.ItemIndex:=idx;
 end;
 if fmWait<>nil then
  RetranslateComponent(fmWait);
 if fmAbout<>nil then
  RetranslateComponent(fmAbout);
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
 imPreview.Picture.Assign(LoadPacked(str,TfwImage(fwImages[GetCurrentImg]).Fim_width,TfwImage(fwImages[GetCurrentImg]).Fim_height));
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
 fwim:=TfwImage(fwImages[GetCurrentImg]);
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

function TfmMain.CreatePatchPreview: TPNGObject;
var
 i:Longint;
 im_patch_w,im_patch_h:Longint;
 imgList:array of integer;
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
 SetLength(imgList,0);
 for i:=0 to Length(imArrayRepl)-1 do begin
  if not (imArrayRepl[i].empty or imArrayRepl[i].Replaced) then continue;
  Application.ProcessMessages;
  SetLength(imgList,Length(imgList)+1);
  imgList[Length(imgList)-1]:=i;
  if maxH<imArray[i].im_height then
   maxH:=imArray[i].im_height;
  if maxH_patch<imArrayRepl[i].im_height then
   maxH_patch:=imArrayRepl[i].im_height;
  if imArrayRepl[i].im_width>imArray[i].im_width then
   tmpInt:=imArrayRepl[i].im_width
  else
   tmpInt:=imArray[i].im_width;
  im_patch_w:=im_patch_w+tmpInt+10;
 end;
 im_patch_h:=maxH+5+maxH_patch;
 if Length(imgList)>1 then im_patch_w:=im_patch_w-10;
 im_patch_h:=im_patch_h+5;
 Result:=nil;
 if im_patch_w>5000 then begin
  if MessageBox(Application.Handle, PChar(Format(_('The .vkp is ready, now it''s time to create a preview.'+#13+#10+'But patch preview image size is large (%dx%d pixels), and software can crash while generating it.'+#13+#10+'Generate preview anyway?'),[im_patch_w,im_patch_h])), PChar(AnsiString(_('Too big preview'))), MB_ICONWARNING or MB_YESNO or MB_TASKMODAL)=idNo then Exit;
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
 for i:=0 to Length(imgList)-1 do begin
  Application.ProcessMessages;
  im:=GetImgFromArray(FData,imArray,imgList[i]);
  im2:=GetImgFromRawData(imArrayRepl,imgList[i]);
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
//  im.Free;
  R.Top:=maxH+10;
  R.Right:=R.Left+im2.Width;
  R.Bottom:=R.Top+im2.Height;
  if maxH_patch>im2.Height then begin
   R.Top:=R.Top+(maxH_patch-im2.Height) div 2;
   R.Bottom:=R.Bottom+(maxH_patch-im2.Height) div 2;
  end;
  if tmpWidth<im2.Width then
   tmpWidth:=im2.Width;
  DrawPNG(im_patch,im2,R.Left+2,R.Top-2);
//  im2.Free;
  curLeft:=curLeft+tmpWidth+4;
  if i<Length(imgList)-1 then begin
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

procedure TfmMain.btSaveOrigClick(Sender: TObject);
begin
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.raw')) then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   Exit;
  end
 end;
 TfwImage(fwImages[GetCurrentImg]).SaveRAW(fw,ChangeFileExt(SaveDialog1.FileName,'.raw'));
end;

procedure TfmMain.btSaveReplClick(Sender: TObject);
begin
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.raw')) then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   Exit;
  end
 end;
 TfwImage(fwImagesOrig[GetCurrentImg]).SaveRAW(fwOrig,ChangeFileExt(SaveDialog1.FileName,'.raw'));
end;

procedure TfmMain.btOpenOrigClick(Sender: TObject);
var
 fs:TFileStream;
 fwIm:TfwImage;
begin
 OpenDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not OpenDialog1.Execute then Exit;
 fs:=TFileStream.Create(OpenDialog1.FileName,fmOpenRead);
 fwIm:=TfwImage(fwImagesOrig[GetCurrentImg]);
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
 fwIm:=TfwImage(fwImages[GetCurrentImg]);
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
   btSaveOrig.Visible:=true;
   btSaveRepl.Visible:=true;
   btOpenOrig.Visible:=true;
   btOpenRepl.Visible:=true;
   pnDevControls.Visible:=true;
   lbNoWarranty.AutoSize:=false;
   lbNoWarranty.AutoSize:=true;
   pnAbout.Height:=lbNoWarranty.Height;
 end;
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
  MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Error while converting image to RGBA!'+#13+#10+'Error code: ')+IntToStr(exCode)+#13+#10+_('Message: ')+outStr)), PChar(AnsiString(_('Error!'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
 end;
 DeleteFile(name);
 RenameFile(ChangeFileExt(name,'.new'),name);
 SetCurrentDir(tmpcDir);
end;

function TfmMain.GenerateVKP(const fwSrc, fwMod: PByte;
  iLen: Cardinal): TStringList;
var
 Len,i,c:LongInt;
 percent,oldPosition:integer;
 SameByte:boolean;
 tmpResSrc,tmpResDst:string;
 bSrc,bMod:byte;
 curAddr:LongInt;
begin
 Len:=iLen-1;
 Result:=TStringList.Create;
 pbProgress.Max:=100;
 pbProgress.Position:=0;
 oldPosition:=0;
 curAddr:=0;
 c:=0;
 for i:=0 to Len do begin
  bSrc:=GetByte(fwSrc,i);
  bMod:=GetByte(fwMod,i);
  if bSrc=bMod then SameByte:=true
   else SameByte:=false;
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
   pbProgress.Position:=percent;
   oldPosition:=percent;
   Application.ProcessMessages;
  end;
 end;
 pbProgress.Position:=100;
end;

function TfmMain.GenerateVKP(const fwSrc: PByte): TStringList;
(*var
 i,j,c:integer;
 tmpStr:string;
 curAddr:Cardinal;
 src,dst:string;
 newArOr,newAr:TimArray;
 tmpIm:TfnImage;
 strOffsets:TStringList;
 oftLines:TStringList;
begin
 Result:=TStringList.Create;
 strOffsets:=TStringList.Create;
 for i:=0 to Length(imArrayRepl)-1 do begin
  GetImgFromArray(FData,imArray,i);
  if (imArrayRepl[i].empty) or (imArrayRepl[i].Replaced) then begin
   if strOffsets.IndexOf(IntToHex(imArrayRepl[i].StartOffset,4))>=0 then continue;
   strOffsets.Add(IntToHex(imArrayRepl[i].StartOffset,4));
   SetLength(newAr,Length(newAr)+1);
   newAr[Length(newAr)-1]:=imArrayRepl[i];
   SetLength(newArOr,Length(newArOr)+1);
   newArOr[Length(newArOr)-1]:=imArray[i];
  end;
 end;
 for i:=0 to Length(newAr)-1 do begin
  for j:=i to Length(newAr)-1 do begin
   if newAr[i].StartOffset>newAr[j].StartOffset then begin
    tmpIm:=newAr[i];
    newAr[i]:=newAr[j];
    newAr[j]:=tmpIm;
    tmpIm:=newArOr[i];
    newArOr[i]:=newArOr[j];
    newArOr[j]:=tmpIm;
   end;
  end;
 end;
 oftLines:=TStringList.Create;
 for i:=0 to Length(newAr)-1 do begin
  if newAr[i].StartOffset<>newArOr[i].StartOffset then begin
   oftLines.Add(IntToHex(offsettable+i*3,8)+': '+
               IntToHex(Get3Bytes(FData,offsettable+i*3),6)+' '+
               IntToHex(newAr[i].StartOffset,6));
  end;
 end;
 oftLines.Sort;
 Result.AddStrings(oftLines);
 oftLines.Free;
 for i:=0 to Length(newAr)-1 do begin
   Result.Add(';replacing image '+newAr[i].name);
   curAddr:=picbase+newAr[i].StartOffset;
   c:=0;
   src:='';dst:='';
   tmpStr:=IntToHex(curAddr,8)+': ';
   for j:=0 to newAr[i].DataLength-1 do begin
    if c>15 then begin
     c:=0;
     Result.Add(tmpStr+src+' '+dst);
     src:='';dst:='';
     tmpStr:=IntToHex(curAddr,8)+': ';
    end;
    src:=src+IntToHex(GetByte(FData,curAddr),2);
    if j<Length(newAr[i].RAWData) then
     dst:=dst+IntToHex(newAr[i].RAWData[j],2)
    else
     dst:=dst+'00';
    c:=c+1;
    curAddr:=curAddr+1;
   end;
   if Length(src)>0 then
    Result.Add(tmpStr+src+' '+dst);
  end;
 newAr:=nil;
 newArOr:=nil;*)
var
 oftLines:TStringList;
 i,j:integer;
 FNewData:PByte;
 newAr:TimArray;
 tmpIm:TfnImage;
 src,dst,tmpStr:string;
 reAdressedNames:TStringList;
begin
 Result:=TStringList.Create;
 reAdressedNames:=TStringList.Create;
 {$ifdef debug}
 dst:=IntToHex(GlobalDeleted,6);
 tmpStr:=Copy(dst,5,2)+Copy(dst,3,2)+Copy(dst,1,2);
 Result.Add(';deleted image offset: '+tmpStr);
 {$endif}
 newAr:=PlaceImages;
 if newAr=nil then begin
  Result.Free;
  Result:=nil;
  Exit;
 end;
 oftLines:=TStringList.Create;
 for i:=0 to Length(newAr)-1 do begin
  for j:=0 to Length(imArrayRepl)-1 do begin
   if imArrayRepl[j].orig_offset=newAr[i].orig_offset then
    imArrayRepl[j].StartOffset:=newAr[i].StartOffset;
  end;
 end;
 for i:=0 to Length(imArrayRepl)-1 do begin
  if not imArrayRepl[i].Replaced then continue;
  if imArrayRepl[i].empty then
   if i<>GlobalDeletedIdx then
    imArrayRepl[i].StartOffset:=GlobalDeleted;
  if reAdressedNames.IndexOf(imArrayRepl[i].name)>-1 then
   continue;
  reAdressedNames.Add(imArrayRepl[i].name);
  if imArrayRepl[i].StartOffset<>imArray[i].StartOffset then begin
  {$ifdef debug}
   oftLines.Add(';image '+imArrayRepl[i].name);
   if i=GlobalDeletedIdx then
    oftLines.Add(';it is global deleted image');
   dst:=IntToHex(imArrayRepl[i].StartOffset,6);
   tmpStr:=Copy(dst,5,2)+Copy(dst,3,2)+Copy(dst,1,2);
   oftLines.Add(';start offset: '+tmpStr);
   dst:=IntToHex(imArrayRepl[i].orig_offset,6);
   tmpStr:=Copy(dst,5,2)+Copy(dst,3,2)+Copy(dst,1,2);
   oftLines.Add(';original offset: '+tmpStr);
   oftLines.Add(';data length: '+IntToStr(imArrayRepl[i].DataLength));
   oftLines.Add(';image length: '+IntToStr(imArrayRepl[i].ImgLength));
   {$endif}

   tmpStr:=IntToHex(offsettable+i*3,8)+': ';
   src:=IntToHex(Get3Bytes(FData,offsettable+i*3),6);
   tmpStr:=tmpStr+Copy(src,5,2)+Copy(src,3,2)+Copy(src,1,2)+' ';
   dst:=IntToHex(imArrayRepl[i].StartOffset,6);
   tmpStr:=tmpStr+Copy(dst,5,2)+Copy(dst,3,2)+Copy(dst,1,2);
   oftLines.Add(tmpStr);
  end;
 end;
 {$ifndef debug}
 oftLines.Sort;
 {$endif}
 Result.AddStrings(oftLines);
 oftLines.Free;
 GetMem(FNewData,iFileLen);
 MoveMemory(FNewData,FData,iFileLen);
// for i:=0 to Length(imArrayRepl)-1 do begin
//  if not (imArrayRepl[i].Replaced or imArrayRepl[i].empty) then continue;
//  GetImgFromArray(FData,imArray,i);
//  SetLength(newAr,Length(newAr)+1);
//  newAr[Length(newAr)-1]:=imArrayRepl[i];
//  if newAr[Length(newAr)-1].im_height<1 then
//   ShowMessage('Error!');
// end;
 for i:=1 to Length(newAr)-1 do begin
  for j:=i to Length(newAr)-1 do begin
   if (not newAr[i].empty) and (newAr[j].empty) then begin
    tmpIm:=newAr[i];
    newAr[i]:=newAr[j];
    newAr[j]:=tmpIm;
   end;
  end;
 end;
// Result.AddStrings(oftLines);
 for i:=0 to Length(FreeBlocks)-1 do begin
  for j:=FreeBlocks[i].Offset to FreeBlocks[i].Offset+FreeBlocks[i].Length-1 do
   SetByte(FNewData,picbase+j,0);
 end;
 for i:=0 to Length(newAr)-1 do begin
  if not (newAr[i].Replaced or newAr[i].empty) then continue;
{  for j:=0 to newAr[i].ImgLength+11 do begin
   if j<Length(newAr[i].RAWData) then
    SetByte(FNewData,newAr[i].StartOffset+picbase+j,newAr[i].RAWData[j])
   else
    SetByte(FNewData,newAr[i].StartOffset+picbase+j,0)
  end;}
  for j:=0 to Length(newAr[i].RAWData) do begin
    SetByte(FNewData,newAr[i].StartOffset+picbase+j,newAr[i].RAWData[j])
  end;
//   Result.Add(';replacing image '+newAr[i].name);
//   curAddr:=picbase+newAr[i].StartOffset;
//   c:=0;
//   src:='';dst:='';
//   tmpStr:=IntToHex(curAddr,8)+': ';
//   for j:=0 to newAr[i].DataLength-1 do begin
//    if c>15 then begin
//     c:=0;
//     Result.Add(tmpStr+src+' '+dst);
//     src:='';dst:='';
//     tmpStr:=IntToHex(curAddr,8)+': ';
//    end;
//    src:=src+IntToHex(GetByte(FData,curAddr),2);
//    if j<Length(newAr[i].RAWData) then
//     dst:=dst+IntToHex(newAr[i].RAWData[j],2)
//    else
//     dst:=dst+'00';
//    c:=c+1;
//    curAddr:=curAddr+1;
//   end;
//   if Length(src)>0 then
//    Result.Add(tmpStr+src+' '+dst);
 end;
 for j:=0 to Length(newAr[0].RAWData) do begin
   SetByte(FNewData,newAr[0].StartOffset+picbase+j,newAr[0].RAWData[j])
 end;
 oftLines:=GenerateVKP(FData,FNewData,iFileLen);
 Result.AddStrings(oftLines);
 oftLines.Free;
 reAdressedNames.Free;
 FreeMem(FNewData);
end;

procedure TfmMain.sSplitter1Resize(Sender: TObject);
begin
 gbOriginal.Width:=(sPanel3.Width-imArrow.Width) div 2;
 btRestoreOriginal.Left:=imArrow.Left+13;
end;

procedure TfmMain.lbImagesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {$WARNINGS OFF}
 if Key=VK_DELETE then
  btDelImg.Click;
{ if [ssCtrl]=Shift then begin
  if Key=VkKeyScan('r') then
   btRestoreOriginal.Click;
 end;}
 {$WARNINGS ON}
end;

procedure TfmMain.acOpenExecute(Sender: TObject);
begin
 if not Stop then begin
  Stop:=true;
  EnableForm;
  Exit;
 end;
 OpenDialog1.Filter:=_('All supported files|*.mbn;*.raw|MBN files (*.mbn)|*.mbn|RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 if not OpenDialog1.Execute then Exit;
 lbImages.Clear;
 lsImages.Clear;
 lbData.Caption:=' '+#10#13+' ';
 imArray:=nil;
 imArrayRepl:=nil;
 FreeBlocks:=nil;
 GlobalDeleted:=-1;
 GlobalDeletedIdx:=-1;
 replacedCount:=0;
 replacedSize:=0;
 RealignFreeBlocks;

 Stop:=false;
 DisableForm;
 fwFileName:=OpenDialog1.FileName;
 LoadRAW(fwFileName);
 if FData<>nil then
  ReadImgTable;
 EnableForm;
 if lbImages.Count>0 then begin
  lbImages.ItemIndex:=0;
  lbImages.OnClick(Self);
 end;
end;

procedure TfmMain.acSaveImgExecute(Sender: TObject);
var
// im:TPNGObject;
// fwIm:TfwImage;
 im:TPNGObject;
 fim:TfnImage;
 i:integer;
 tmpStr:string;
 fs:TFileStream;
 ms:TStringStream;
 im2:TPNGObject;
begin
 if GetCurrentImg<0 then Exit;
 SavePictureDialog1.FileName:=lsImages[getCurrentImg];
 if not SavePictureDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SavePictureDialog1.FileName,'.png')) then begin
  if MessageBox(Application.Handle, PAnsiChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   EnableForm;
   Exit;
  end
 end;
 DisableForm;
// fwIm:=TfwImage(fwImages[lbImages.ItemIndex]);
// im:=fwIm.GetPicture(fw);
// imPreview.Picture.Assign(im);
// fwIm.SaveToFile(fw,ChangeFileExt(SavePictureDialog1.FileName,'.png'),cbFixColors.Checked);
 fim:=imArray[getCurrentImg];
 GetImgFromArray(FData,imArray,getCurrentImg);
 if fim.imType=imPNG then begin
  for i:=fim.StartOffset+picbase+12 to fim.StartOffset+picbase+fim.ImgLength+11 do begin
   tmpStr:=tmpStr+chr(PByte(Integer(FData)+i)^);
  end;
  ms:=TStringStream.Create(tmpStr);
  if cbFixColors.Checked then begin
   im2:=TPNGObject.Create;
   im2.LoadFromStream(ms);
   im2:=FixImageColors(im2);
   ms.Free;
   im2.SaveToFile(ChangeFileExt(SavePictureDialog1.FileName,'.png'));
  end else begin
   fs:=TFileStream.Create(ChangeFileExt(SavePictureDialog1.FileName,'.png'),fmCreate);
   fs.CopyFrom(ms,ms.Size);
   ms.Free;
   fs.Free;
  end;
 end else begin
  im:=GetImgFromArray(FData,imArray,GetCurrentImg);
  im.SaveToFile(ChangeFileExt(SavePictureDialog1.FileName,'.png'));
 end;
 EnableForm;
end;

procedure TfmMain.acDeleteImgExecute(Sender: TObject);
var
// Res:TResourceStream;
 im:TPNGObject;
 fim:TfnImage;
 Buf:TByteArray;
 i:integer;
 ms:TStringStream;
 imEnd:integer;
 tmpName:string;
begin
 if Length(imArrayRepl)<1 then begin
  SetLength(imArrayRepl,numIcons);
  for i:=0 to Length(imArray)-1 do begin
   imArrayRepl[i]:=imArray[i];
  end;
 end else begin
  GetImgFromArray(FData,imArray,GetCurrentImg);
  if imArrayRepl[GetCurrentImg].ImgLength=-1 then
   imArrayRepl[GetCurrentImg]:=imArray[GetCurrentImg];
 end;
 fim:=imArrayRepl[GetCurrentImg];
 for i:=0 to Length(FreeBlocks)-1 do begin
  imEnd:=FreeBlocks[i].Offset+FreeBlocks[i].Length;
  if (fim.StartOffset>=FreeBlocks[i].Offset) and
     (fim.StartOffset<=imEnd) then
    Exit;
  if fim.StartOffset=GlobalDeleted then
    Exit;
 end;
 fim.imType:=imPKI;
 if GlobalDeleted>0 then begin
  fim.StartOffset:=GlobalDeleted;
 end;
 im:=TPNGObject.CreateBlank(COLOR_RGBALPHA,8,1,1);
 Buf:=SavePacked(im);
 ms:=TStringStream.Create(String(Buf));
 Buf:=Zlib(ms);
 fim.Empty:=true;
 fim.Replaced:=true;
 fim.im_width:=1;
 fim.im_height:=1;
 fim.ImgLength:=Length(Buf);
 ms.Free;
 im.Free;
 SetRAWData(fim,Buf);
 if fim.Image<>nil then begin
  fim.Image:=nil;
 end;
// imArrayRepl[lbImages.ItemIndex]:=fim;
 SetLength(FreeBlocks,Length(FreeBlocks)+1);
// if GlobalDeleted<1 then begin
//  FreeBlocks[Length(FreeBlocks)-1].Offset:=imArray[lbImages.ItemIndex].StartOffset+Length(fim.RAWData);
//  FreeBlocks[Length(FreeBlocks)-1].Length:=imArray[lbImages.ItemIndex].DataLength-Length(fim.RAWData);
// end else begin
  FreeBlocks[Length(FreeBlocks)-1].Offset:=imArray[GetCurrentImg].StartOffset;
  FreeBlocks[Length(FreeBlocks)-1].Length:=imArray[GetCurrentImg].DataLength+11;
// end;
 FreeBlocks[Length(FreeBlocks)-1].idx:=GetCurrentImg;
 if GlobalDeleted<0 then begin
  GlobalDeleted:=fim.StartOffset;
  GlobalDeletedIdx:=GetCurrentImg;
 end;
 for i:=0 to Length(imArrayRepl)-1 do begin
  if fim.orig_offset=imArrayRepl[i].orig_offset then begin
   GetImgFromArray(FData,imArray,i);
   tmpName:=imArrayRepl[i].name;
   imArrayRepl[i]:=fim;
   imArrayRepl[i].name:=tmpName;
  end;
 end;
 lbImages.OnClick(Self);
 lbImages.Repaint;
 RealignFreeBlocks;
end;

procedure TfmMain.acReplaceImgExecute(Sender: TObject);
var
 Buf:TByteArray;
 fim:TfnImage;
 im:TPNGObject;
 ms:TStringStream;
 tmpfName:TFileName;
 im_width,im_height:integer;
 i:integer;
 idx:integer;
 //
 tmpStr:string;
 tmpName:string;
// Replaced:boolean;
begin
 if GetCurrentImg<0 then Exit;
 if not OpenPictureDialog1.Execute then Exit;
 DisableForm;
// Replaced:=false;
 idx:=GetCurrentImg;
 if Length(imArrayRepl)<1 then begin
  SetLength(imArrayRepl,numIcons);
  for i:=0 to Length(imArray)-1 do begin
   imArrayRepl[i]:=imArray[i];
  end;
 end else begin
  GetImgFromArray(FData,imArray,idx);
  if imArrayRepl[idx].ImgLength=-1 then
   imArrayRepl[idx]:=imArray[idx];
 end;
 im:=TPNGObject.Create;
 im.LoadFromFile(OpenPictureDialog1.FileName);
 im_width:=im.Width;
 im_height:=im.Height;
 im.Free;
 Buf:=ReadFileToMem(OpenPictureDialog1.FileName);
 if imArray[idx].imType=imPKI then begin
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
    MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Error while working with image!'+#13+#10+'Looks like it''s broken')+#10#13+_('Message: ')+E.Message)), PChar(AnsiString(_('Error'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
    EnableForm;
    Exit;
   end;
  end;
  ms.Free;
  im:=FixImageColors(im);
  tmpfName:=GenTempFileName;
  im.SaveToFile(tmpfName);
  im.Free;
  if imArrayRepl[idx].imType=imPNG then
   OptimizeImg(tmpfName);
  SetLength(Buf,1);
  Buf:=ReadFileToMem(tmpfName);
  DeleteFile(tmpfName);
 end;
 fim:=imArrayRepl[idx];
 sbStatus.Panels[0].Text:=_('Replacing image...');
 if fim.imType=imPNG then begin
  if GlobalDeleted<0 then begin
   if fim.DataLength<Length(Buf) then begin
    MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Image is too big, can''t replace'+#10#13+'Image size: ')+IntToStr(Length(Buf))+#10#13+_('Allowed size: ')+IntToStr(fim.DataLength))), PChar(AnsiString(_('Error'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
    EnableForm;
    Exit;
   end;
  end;
//  SetPicture(FNewData,fim,Buf,im_width,im_height);
  fim.im_width:=im_width;
  fim.im_height:=im_height;
  SetRAWData(fim,Buf);
 end else if fim.imType=imPKI then begin
  ms:=TStringStream.Create(String(Buf));
  im:=TPNGObject.Create;
  im.LoadFromStream(ms);
  ms.Free;
  Buf:=SavePacked(im);
  ms:=TStringStream.Create(String(Buf));
  Buf:=Zlib(ms);
  ms.Free;
  ms:=TStringStream.Create(String(Buf));
  ms.Free;
  if GlobalDeleted<0 then begin
   if fim.DataLength<Length(Buf) then begin
     MessageBox(Application.Handle, PAnsiChar(AnsiString(_('Image is too big, can''t replace'+#10#13+'Image size: ')+IntToStr(Length(Buf))+#10#13+_('Allowed size: ')+IntToStr(fim.DataLength))), PChar(AnsiString(_('Error'))), MB_ICONERROR or MB_OK or MB_TASKMODAL);
     EnableForm;
     Exit;
   end;
  end;
  fim.im_width:=im_width;
  fim.im_height:=im_height;
  SetRAWData(fim,Buf);
//  SetPicture(FNewData,fim,Buf,im_width,im_height);
 end;
 fim.Replaced:=true;
 fim.empty:=false;
 fim.Image:=nil;
 fim.ImgLength:=Length(Buf);
 if GlobalDeleted>0 then begin
  replacedCount:=replacedCount+1;
  replacedSize:=replacedSize+Length(fim.RAWData);
  if maxImage<Length(fim.RAWData) then maxImage:=Length(fim.RAWData);
 end;
 imArrayRepl[idx]:=fim;
 for i:=0 to Length(imArrayRepl)-1 do begin
  if fim.orig_offset=imArrayRepl[i].orig_offset then begin
   GetImgFromArray(FData,imArray,i);
   tmpName:=imArrayRepl[i].name;
   imArrayRepl[i]:=fim;
   imArrayRepl[i].name:=tmpName;
  end;
 end;
 if GlobalDeleted>0 then begin
  SetLength(FreeBlocks,Length(FreeBlocks)+1);
  FreeBlocks[Length(FreeBlocks)-1].Offset:=imArray[GetCurrentImg].StartOffset;
  FreeBlocks[Length(FreeBlocks)-1].Length:=imArray[GetCurrentImg].DataLength+11;
  RealignFreeBlocks;
 end;
 EnableForm;
 lbImages.OnClick(Self);
end;

procedure TfmMain.acMakeVKPExecute(Sender: TObject);
var
 fVkp:System.text;
 tmpStr:string;
 tmpStrings:TStrings;
 i:integer;
 //patch preview
 im_patch:TPNGObject;
 fim:TfnImage;
 j:integer;
 tmpName:string;
begin
 sbStatus.Panels[0].Text:=_('Generating patch...');
 if Length(imArrayRepl)<1 then begin
  EnableForm;
  MessageBox(Application.Handle, PChar(AnsiString(_('No images changed or images are equal!'+#13+#10+'Will not create empty file'))), PChar(AnsiString(_('Nothing to write'))), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
  Exit;
 end;
 DisableForm;
 for j:=0 to Length(imArrayRepl)-1 do begin
  fim:=imArrayRepl[j];
  if not (fim.Replaced or fim.empty) then Continue;
  for i:=j+1 to Length(imArrayRepl)-1 do begin
   if fim.orig_offset=imArrayRepl[i].orig_offset then begin
    GetImgFromArray(FData,imArray,i);
    tmpName:=imArrayRepl[i].name;
    imArrayRepl[i]:=fim;
    imArrayRepl[i].name:=tmpName;
   end;
  end;
 end;
 RecalculateFreeBlocks;
 tmpStrings:=GenerateVKP(FData);
 if tmpStrings=nil then begin
  EnableForm;
  Exit;
 end;
 if tmpStrings.Count<1 then begin
  EnableForm;
  MessageBox(Application.Handle, PChar(AnsiString(_('No images changed or images are equal!'+#13+#10+'Will not create empty file'))), PChar(AnsiString(_('Nothing to write'))), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
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
  if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
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
 WriteLn(fVkp,';replace system graphics of db2020 phones');
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,';automatically generated by');
 WriteLn(fVkp,';SE db2020 Image Tool '+swversion);
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,';замена системной графики телефонов на db2020');
 WriteLn(fVkp,';автоматически сгенерирован программой');
 WriteLn(fVkp,';SE db2020 Image Tool '+swversion);
 WriteLn(fVkp,';---------------------------------------------');
 WriteLn(fVkp,';заміна системної графіки телефонів на db2020');
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
//  im_patch:=nil;
  if im_patch<>nil then begin
   tmpStr:=GenTempFileName;
//   tmpStr:=ExtractFilePath(tmpStr)+ExtractFileName(tmpStr)+'_preview.png';
   im_patch.SaveToFile(tmpStr);
   Application.ProcessMessages;
//   OptimizeImg(tmpStr);
   im_patch.Free;
   MoveFileEx(PChar(tmpStr),PChar(ExtractFilePath(SaveDialog1.FileName)+ChangeFileExt(ExtractFileName(SaveDialog1.FileName),'')+'_preview.png'),MOVEFILE_REPLACE_EXISTING or MOVEFILE_COPY_ALLOWED);
  end;
 except
  MessageBox(Application.Handle, 'Cannot generate patch preview image, maybe you have replaced too many images'+#13+#10+'However, the .vkp should be ok!', 'Cannot generate preview', MB_ICONWARNING or MB_OK or MB_TASKMODAL);
 end;
 EnableForm;
end;

procedure TfmMain.acClearFWExecute(Sender: TObject);
begin
{ CopyMemory(fw,fwOrig,Length(fw));
 fwImages.Clear;
 SetLength(FreeBlocks,0);
 for i:=0 to fwImages.Count-1 do begin
  fwim:=TfwImage.Create;
  fwim.Assign(TfwImage(fwImagesOrig[i]));
 end;}
 imArrayRepl:=nil;
 FreeBlocks:=nil;
 GlobalDeleted:=-1;
 GlobalDeletedIdx:=-1;
 replacedCount:=0;
 replacedSize:=0;
 lbImages.Repaint;
 RealignFreeBlocks;
 lbImages.OnClick(Self);
end;

procedure TfmMain.acLoadProjectExecute(Sender: TObject);
var
 count,i,j:integer;
 tmpStr:string;
 fs:TFileStream;
 f:TZDecompressionStream;
 fim:TfnImage;
 tmpName:string;
 prjVersion:integer;
begin
 sbStatus.Panels[0].Text:=_('Loading project...');
 OpenDialog1.Filter:=_('IMT files (*.imt)|*.imt|All files (*.*)|*.*');
 if not OpenDialog1.Execute then begin
  Exit;
 end;
 DisableForm;
 replacedCount:=0;
 replacedSize:=0;
 maxImage:=0;
 fs:=TFileStream.Create(OpenDialog1.FileName,fmOpenRead);
 f:=TZDecompressionStream.Create(fs);
 prjVersion:=StrToIntDef(sReadBlock(f),0);
 if prjVersion<>iVersion then begin
  if prjVersion=200 then begin
   if MessageBox(Application.Handle, PChar(Format(_('This project was created with version %f of software which has bugs that prevent it''s normal usage. Load anyway?'),[prjVersion/100])), PChar(AnsiString(_('Error'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL or MB_DEFBUTTON2)=IDNO then begin
    f.Free;
    fs.Free;
    EnableForm;
    Exit;
   end;
  end else if prjVersion>iVersion then begin
   MessageBox(Application.Handle, PChar(Format(_('This project was created with version %f of software which is newer than current software and thus cannot be loaded.'+#10#13+'Please download new version from http://magister.ipsys.net'),[prjVersion/100])), PChar(AnsiString(_('Error'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL or MB_DEFBUTTON2);
   f.Free;
   fs.Free;
   EnableForm;
   Exit;
  end;
 end;
 tmpStr:=sReadBlock(f);
 if fwFileName='' then begin
  fwFileName:=tmpStr;
  if not FileExists(fwFileName) then begin
   f.Free;
   fs.Free;
   EnableForm;
   raise Exception.Create(_('Cannot load firmware file: %s'+#10#13+'Open it manually and then load project'));
  end;
  LoadRAW(fwFileName);
  ReadImgTable;
 end else begin
  if ChangeFileExt(ExtractFileName(AnsiUpperCaseFileName(fwFileName)),'')<>ChangeFileExt(ExtractFileName(AnsiUpperCaseFileName(tmpStr)),'') then begin
   if MessageBox(Application.Handle, PChar(AnsiString(_('Loaded firmware file is not the same the project was created'+#10#13+'Loading rhis project with incorrect firmware can crash program. Load anyway?'))), PChar(AnsiString(_('Different firmware file'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL or MB_DEFBUTTON2)=IDNO then begin
    EnableForm;
    Exit;
   end;
  end;
 end;
 count:=StrToInt(sReadBlock(f));
 SetLength(imArrayRepl,numIcons);
 for i:=0 to Length(imArray)-1 do begin
  imArrayRepl[i]:=imArray[i];
 end;
 for j:=0 to count-1 do begin
  tmpStr:=sReadBlock(f);
  fim:=ImgFromString(tmpStr);
  tmpStr:=sReadBlock(f);
  if tmpStr='0' then
   fim.RAWData:=nil
  else begin
   SetLength(fim.RAWData,Length(tmpStr));
   fim.RAWData:=TByteArray(tmpStr);
  end;
  for i:=0 to Length(imArrayRepl)-1 do begin
   if fim.orig_offset=imArrayRepl[i].orig_offset then begin
    GetImgFromArray(FData,imArray,i);
    tmpName:=imArrayRepl[i].name;
    imArrayRepl[i]:=fim;
    imArrayRepl[i].name:=tmpName;
   end;
  end;
  if not fim.empty then begin
   replacedCount:=replacedCount+1;
   replacedSize:=replacedSize+Length(fim.RAWData);
  end;
  if maxImage<Length(fim.RAWData) then
   maxImage:=Length(fim.RAWData);
 end;
 GlobalDeleted:=StrToInt(sReadBlock(f));
 GlobalDeletedIdx:=StrToInt(sReadBlock(f));
 EnableForm;
 if lbImages.Count>0 then lbImages.ItemIndex:=0;
 sbStatus.Panels[1].Text:=IntToStr(lsImages.Count)+_(' images found')+'    ';
 lbImagesClick(Self);
 lbImages.Repaint;
 f.Free;
 fs.Free;
 FreeBlocks:=nil;
 RecalculateFreeBlocks;
end;

procedure TfmMain.acSaveProjectExecute(Sender: TObject);
var
 i:integer;
 tmpStr:string;
 fs:TFileStream;
 f:TZCompressionStream;
 count:integer;
begin
 sbStatus.Panels[0].Text:=_('Saving project...');
 SaveDialog1.Filter:=_('IMT files (*.imt)|*.imt|All files (*.*)|*.*');
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.imt')) then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   Exit;
  end
 end;
 DisableForm;
 fs:=TFileStream.Create(ChangeFileExt(SaveDialog1.FileName,'.imt'),fmCreate);
 f:=TZCompressionStream.Create(fs,zcDefault);
{ //Write original firmware
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
 end;}
 //Write changed images
 sWriteBlock(f,iVersion);
 sWriteBlock(f,fwFileName);
 count:=0;
 for i:=0 to Length(imArrayRepl)-1 do begin
  if (imArrayRepl[i].Replaced) or (imArrayRepl[i].empty) then begin
   GetImgFromArray(FData,imArray,i);
   count:=count+1;
  end;
 end;
 sWriteBlock(f,count);
 for i:=0 to Length(imArrayRepl)-1 do begin
  if (imArrayRepl[i].Replaced) or (imArrayRepl[i].empty) then begin
   tmpStr:=ImgToString(imArrayRepl[i]);
   sWriteBlock(f,tmpStr);
   if Length(imArrayRepl[i].RAWData)>0 then begin
    sWriteBlock(f,String(imArrayRepl[i].RAWData));
   end else begin
    sWriteBlock(f,0);
   end;
  end;
 end;
 sWriteBlock(f,GlobalDeleted);
 sWriteBlock(f,GlobalDeletedIdx);
 f.Free;
 fs.Free;
 EnableForm;
end;

procedure TfmMain.acRestoreOriginalExecute(Sender: TObject);
var
 i:integer;
 c:integer;
 fim:TfnImage;
 gdOffset:integer;
begin
 if GetCurrentImg<0 then Exit;
(* fwIm:=TfwImage(fwImages[lbImages.ItemIndex]);
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
 imPreview.Picture.Assign(im);*)
 if Length(imArrayRepl)<1 then Exit;
 c:=0;
 for i:=0 to Length(imArrayRepl)-1 do begin
  if (imArrayRepl[i].Replaced) or (imArrayRepl[i].empty) then c:=c+1;
  if c>1 then break;
 end;
 gdOffset:=imArray[GlobalDeletedIdx].StartOffset;
// if lbImages.ItemIndex=GlobalDeletedIdx then begin
//  if c>1 then begin
//   MessageBox(Application.Handle, PChar(AnsiString(_('This image is used as global deleted picture and can be restored only via full undo'))), PChar(AnsiString(_('Cannot restore'))), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
//   Exit;
//  end else begin
//   GlobalDeleted:=-1;
//   GlobalDeletedIdx:=-1;
//  end;
// end;
 fim:=imArray[GetCurrentImg];
 for i:=0 to Length(imArrayRepl)-1 do begin
  if fim.orig_offset=imArrayRepl[i].orig_offset then begin
   if imArray[i].StartOffset=gdOffset then begin
    if c>1 then begin
     MessageBox(Application.Handle, PChar(AnsiString(_('This image is used as global deleted picture and can be restored only via full undo'))), PChar(AnsiString(_('Cannot restore'))), MB_ICONWARNING or MB_OK or MB_TASKMODAL);
     Exit;
    end else begin
     GlobalDeleted:=-1;
     GlobalDeletedIdx:=-1;
    end;
   end;
   GetImgFromArray(FData,imArray,i);
   imArrayRepl[i]:=fim;
  end;
 end;
 RecalculateFreeBlocks;
 lbImages.OnClick(Self);
 lbImages.RepaintItem(lbImages.ItemIndex);
end;

procedure TfmMain.acAboutExecute(Sender: TObject);
begin
 fmAbout.ShowModal;
end;

procedure TfmMain.cbExpertModeClick(Sender: TObject);
begin
 pnLog.Visible:=cbExpertMode.Checked;
 pnDevControls.Visible:=cbExpertMode.Checked;
 sSplitter2.Visible:=cbExpertMode.Checked;
 sbStatus.Top:=fmMain.Height;
end;

procedure TfmMain.btShowImageAddressClick(Sender: TObject);
var
 idx:integer;
 tmpStr,tmpStr2:string;
begin
 if lbImages.Count<1 then Exit;
 idx:=GetCurrentImg;
 if (idx<0) or (idx>=lsImages.Count) then Exit;
 tmpStr:=IntToHex(imArray[idx].StartOffset,6);
 tmpStr2:=Copy(tmpStr,5,2)+Copy(tmpStr,3,2)+Copy(tmpStr,1,2);
 meLog.Lines.Add(Format('Image %s: offset=%s; length=%d bytes',[imArray[idx].name,tmpStr2,imArray[idx].DataLength]));
end;

procedure TfmMain.ToolButton2Click(Sender: TObject);
var
 i:integer;
 tmpStr,tmpStr2:string;
 totSize:integer;
begin
 SortFreeBlocks(FreeBlocks);
 totSize:=0;
 meLog.Lines.Add('------------- Free blocks sorted by size -------------');
 for i:=0 to Length(FreeBlocks)-1 do begin
  tmpStr:=IntToHex(FreeBlocks[i].Offset,6);
  tmpStr2:=Copy(tmpStr,5,2)+Copy(tmpStr,3,2)+Copy(tmpStr,1,2);
  meLog.Lines.Add(Format('Block %d: offset=%s, length=%d bytes',[i+1,tmpStr,FreeBlocks[i].Length]));
  totSize:=totSize+FreeBlocks[i].Length;
 end;
 meLog.Lines.Add(Format('Total size: %d bytes in %d blocks',[totSize,Length(FreeBlocks)]));
 meLog.Lines.Add('------------------------------------------------------');
end;

procedure TfmMain.acClearLogExecute(Sender: TObject);
begin
 meLog.Lines.Clear;
end;

function TfmMain.GetCurrentImg: integer;
begin
 if lbImages.ItemIndex<0 then begin
  Result:=-1;
  Exit;
 end;
 if lbImages.ItemIndex>=lbImages.Count then begin
  Result:=-1;
  Exit;
 end;
 Result:=lsImages.IndexOf(lbImages.Items[lbImages.ItemIndex]);
end;

procedure TfmMain.cbDeletedClick(Sender: TObject);
begin
 UpdateFilter;
end;

procedure TfmMain.cbReplacedClick(Sender: TObject);
begin
 UpdateFilter;
end;

procedure TfmMain.cbUnchangedClick(Sender: TObject);
begin
 UpdateFilter;
end;

procedure TfmMain.edFilterNameChange(Sender: TObject);
begin
 UpdateFilter;
end;

procedure TfmMain.UpdateFilter;
var
 i:integer;
 AddItem:boolean;
 arr:TimArray;
 tmpLs:TStringList;
 cName:string;
 filterText:string;
begin
 tmpLs:=TStringList.Create;
 filterText:=AnsiUpperCase(Trim(edFilterName.Text));
 if Length(imArrayRepl)<1 then
  arr:=imArray
 else
  arr:=imArrayRepl;
 if (lbImages.ItemIndex>=0) and (lbImages.ItemIndex<lbImages.Count) then
  cName:=lbImages.Items[lbImages.ItemIndex]
 else
  cName:='';
 lbImages.Clear;
 for i:=0 to lsImages.Count-1 do begin
  AddItem:=false;
  if cbDeleted.Checked then
   if arr[i].empty then AddItem:=true;
  if cbReplaced.Checked then
   if (arr[i].Replaced) and (not arr[i].empty) then AddItem:=true;
  if cbUnchanged.Checked then
   if not (arr[i].empty or arr[i].Replaced) then AddItem:=true;
  if filterText<>'' then
   if Pos(filterText,AnsiUpperCase(lsImages[i]))>0 then
    AddItem:=true
   else
    AddItem:=false;
  if AddItem then
   tmpLs.Add(lsImages[i]);
 end;
 lbImages.Items.AddStrings(tmpLs);
 lbFilteredImages.Caption:=Format(_('Images shown: %d'),[lbImages.Count]);
 tmpLs.Free;
 if cName<>'' then begin
  i:=lbImages.Items.IndexOf(cName);
  if i>-1 then
   lbImages.ItemIndex:=i;
 end;
end;

end.
