unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, sHintManager, sSkinProvider, sSkinManager,
  ExtDlgs, ComCtrls, sTrackBar, StdCtrls, Buttons, sBitBtn, sComboBox,
  sCheckBox, sEdit, sSpinEdit, ExtCtrls, sBevel, sLabel, sPanel, ImgList,
  sMemo, JvBaseDlg, JvBrowseFolder, JvSimpleXml,
  JvSearchFiles, JvFormPlacement, JvComponentBase, JvAppStorage,
  JvAppRegistryStorage, Menus, sAlphaListBox, sSpeedButton, sGroupBox,
  ToolWin, sToolBar, sDialogs, sSplitter, acProgressBar,
  sStatusBar, uTypes, uImgUtils, gnugettext, DateUtils, ImagingClasses,
  ImagingTypes, ImagingComponents, acAlphaImageList, ShlObj, XPMan, ShellAPI,
  Mask, sMaskEdit;

type
  TfmMain = class(TForm)
    sbStatus: TsStatusBar;
    pbProgress: TsProgressBar;
    sPanel2: TsPanel;
    sSplitter1: TsSplitter;
    sPanel3: TsPanel;
    imArrow: TImage;
    sPanel4: TsPanel;
    pnAbout: TsPanel;
    lbNoWarranty: TsLabelFX;
    Button1: TButton;
    Button2: TButton;
    gbOriginal: TsGroupBox;
    imOriginal: TImage;
    lbOrigImageInfo: TLabel;
    btSaveOrig: TsBitBtn;
    btOpenOrig: TsBitBtn;
    gbPreview: TsGroupBox;
    imPreview: TImage;
    lbImageInfo: TLabel;
    btSaveRepl: TsBitBtn;
    btOpenRepl: TsBitBtn;
    btRestoreOriginal: TsBitBtn;
    sPanel5: TsPanel;
    lbFreeBlocks: TsLabel;
    sPanel6: TsPanel;
    lbFilteredImages: TsLabel;
    sbHideFilter: TsSpeedButton;
    pnFilter: TsPanel;
    sbClearEdFilter: TsSpeedButton;
    cbDeleted: TsCheckBox;
    cbReplaced: TsCheckBox;
    cbUnchanged: TsCheckBox;
    edFilterName: TsEdit;
    lbImages: TsListBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    tmHideProgress: TTimer;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Z0068535980301: TMenuItem;
    R4284232349151: TMenuItem;
    U7785587523021: TMenuItem;
    N49528031: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    tmSlideForm: TTimer;
    sfSearch: TJvSearchFiles;
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
    acAbout: TAction;
    acClearLog: TAction;
    acSaveRAW: TAction;
    sxXML: TJvSimpleXML;
    sHintManager1: TsHintManager;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    sPanel1: TsPanel;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sBevel1: TsBevel;
    sBevel2: TsBevel;
    sBevel3: TsBevel;
    sLabel3: TsLabel;
    sBevel4: TsBevel;
    sBevel5: TsBevel;
    sBevel6: TsBevel;
    seThumbHeight: TsSpinEdit;
    cbStretchPreview: TsCheckBox;
    cbSkins: TsComboBox;
    cbLanguage: TsComboBox;
    btLoadProject: TsBitBtn;
    btOpenFw: TsBitBtn;
    btSaveImg: TsBitBtn;
    btDelImg: TsBitBtn;
    btReplaceImg: TsBitBtn;
    btMakeVKP: TsBitBtn;
    btClearFW: TsBitBtn;
    btAbout: TsBitBtn;
    cbExpertMode: TsCheckBox;
    tbHue: TsTrackBar;
    btSaveRAW: TsBitBtn;
    pnLog: TsPanel;
    lbData: TsLabel;
    meLog: TsMemo;
    btClearLog: TsBitBtn;
    sSplitter2: TsSplitter;
    pnDevControls: TsToolBar;
    btFreeSpaceLog: TToolButton;
    btLinkImg: TToolButton;
    btRestoreGraphicsVKP: TToolButton;
    cbUseNames: TsCheckBox;
    sPathDialog1: TsPathDialog;
    pbOriginal: TPaintBox;
    pbReplaced: TPaintBox;
    JvAppRegistryStorage1: TJvAppRegistryStorage;
    JvFormStorage1: TJvFormStorage;
    sAlphaImageList1: TsAlphaImageList;
    btSaveRAWImage: TToolButton;
    cbShowImageTableNumber: TsCheckBox;
    sLabel4: TsLabel;
    tbSavePatchedImage: TToolButton;
    btSaveNewRAW: TToolButton;
    sLabel5: TsLabel;
    edImgBase: TsMaskEdit;
    sBevel7: TsBevel;
    ToolButton1: TToolButton;
    cbAlternatePITSearch: TsCheckBox;
    procedure acOpenExecute(Sender: TObject);
    procedure lbImagesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbImagesClick(Sender: TObject);
    procedure cbStretchPreviewClick(Sender: TObject);
    procedure edFilterNameChange(Sender: TObject);
    procedure lbImagesData(Control: TWinControl; Index: Integer;
      var Data: String);
    procedure cbExpertModeClick(Sender: TObject);
    procedure sbClearEdFilterClick(Sender: TObject);
    procedure cbDeletedClick(Sender: TObject);
    procedure cbReplacedClick(Sender: TObject);
    procedure cbUnchangedClick(Sender: TObject);
    procedure seThumbHeightChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acSaveImgExecute(Sender: TObject);
    procedure lbImagesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sbHideFilterClick(Sender: TObject);
    procedure pbOriginalPaint(Sender: TObject);
    procedure acClearLogExecute(Sender: TObject);
    procedure acReplaceImgExecute(Sender: TObject);
    procedure sSkinManager1BeforeChange(Sender: TObject);
    procedure pbReplacedPaint(Sender: TObject);
    procedure acDeleteImgExecute(Sender: TObject);
    procedure cbSkinsChange(Sender: TObject);
    procedure sSkinManager1AfterChange(Sender: TObject);
    procedure lbImagesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acMakeVKPExecute(Sender: TObject);
    procedure acSaveRAWExecute(Sender: TObject);
    procedure acClearFWExecute(Sender: TObject);
    procedure acLoadProjectExecute(Sender: TObject);
    procedure tbHueMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JvFormStorage1AfterRestorePlacement(Sender: TObject);
    procedure tmHideProgressTimer(Sender: TObject);
    procedure acRestoreOriginalExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure cbUseNamesClick(Sender: TObject);
    procedure btFreeSpaceLogClick(Sender: TObject);
    procedure btSaveRAWImageClick(Sender: TObject);
    procedure cbShowImageTableNumberClick(Sender: TObject);
    procedure tbSavePatchedImageClick(Sender: TObject);
    procedure btSaveNewRAWClick(Sender: TObject);
    procedure btRestoreGraphicsVKPClick(Sender: TObject);
    procedure JvFormStorage1SavePlacement(Sender: TObject);
    procedure JvFormStorage1RestorePlacement(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edImgBaseChange(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure lbImagesKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ClearData;
    procedure UpdateFullList;
    procedure UpdateList;
    procedure DisableForm;
    procedure EnableForm;
    procedure SaveImageToFile(ItemIndex,TableIndex:integer;fName:TFileName; imName:string);
    function GetImageFromItem(str:string;Index:integer):TfwImg;
    function GetIndexInTables(tNo:integer;Tables:TImgTables;idx:integer; idx_is_global:boolean=false):integer;
    procedure CheckReplacedTables;
    procedure ChangePanelsSkinSection(Control: TWinControl; SkinSection: string);
    function LoadVKP(fName:TFileName):TStringList;
    function GetImageTableByDisplayIndex(idx:integer):integer;
    function GetImageByDisplayIndex(idx:integer;Replaced:boolean=false): TfwImg;
    procedure UpdateFreeBlocks;
    procedure DoReplaceImage(fName:TFileName;Index:integer);
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure SetDirty(flag:boolean=true);
    function IsDirty:boolean;
  public
    { Public declarations }
    procedure ErrorMsg(const Msg,Capt:WideString);
    procedure toLog(s:string);
  end;

var
  fmMain: TfmMain;
  fmEnabled:boolean=true;

const
  swversion='2.5 ALPHA 8 (c) 2008-2009 Magister';
  fmCaption='SE Image Tool';

implementation

uses uFileIO,uFwWork, uAbout, uByteUtils, Math;

var
 imTables,imReplTables:TImgTables; //Image tables
 stTime:TDateTime; //To calculate operations time
 lsImages:TStrings; //List to hold full list of images
 lsFilteredImages:TStrings; //List to hold filtered list of images
 OldHintPoint:TPoint; //For displaing hint at images list
 deletedImg:TSingleImage; //'Image deleted' picture
 fwFileName:TFileName; //File name of currently opened firmware
 //Save image, fw and patch path
 PathFw, PathImage, PathPatch: string;

{$R *.dfm}
{$R images.res}

procedure SetProgress(Text:string;percent:integer;LogMsg:string='');
begin
 if LogMsg='' then begin
  fmMain.sbStatus.Panels[0].Text:=Text;
  fmMain.pbProgress.Position:=percent;
 end else begin
  fmMain.toLog(LogMsg);
 end;
 Application.ProcessMessages;
end;

procedure TfmMain.acOpenExecute(Sender: TObject);
var
 res:TResData;
 i,allImages:integer;
begin

 //Check dirty flag
 if IsDirty then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('There are unsaved changes. Discard them?'))), PChar(AnsiString(_('Discard changes?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   Exit;
  end;
 end;

 //Disable form
 DisableForm;

 //Select file
 OpenDialog1.Filter:=_('All supported files|*.mbn;*.cxc;*.raw|MBN files (*.mbn)|*.mbn|CXC files (*.cxc)|*.cxc|RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 OpenDialog1.InitialDir:=PathFw;
 if not OpenDialog1.Execute then begin
  EnableForm;
  Exit;
 end;
 PathFw:=ExtractFilePath(OpenDialog1.FileName);

 //Flush status bar platform caption
 sbStatus.Tag:=1;
 sbStatus.Panels[2].Text:='';

 //Is it really needed?
 //Add file to recent
 //SHAddToRecentDocs(SHARD_PATH,PChar(OpenDialog1.FileName));

 //Start time counter
 stTime:=Time;

 //Clear everything
 ClearData;

 //Load firmware file
 fwFileName:=OpenDialog1.FileName;
 try
  res:=LoadFW(meLog.Lines,fwFileName,@SetProgress);
 except
  EnableForm;
 end;
 if res.PByteRes=nil then begin
  EnableForm;
  Exit;
 end;

 //Load image tables and count images
 SetProgress(_('Searching for image tables...'),50);
 if cbAlternatePITSearch.Checked then
  imTables:=LoadImageTables(FData,meLog.Lines,@SetProgress,true)
 else
  imTables:=LoadImageTables(FData,meLog.Lines,@SetProgress);
 allImages:=0;
 for i:=0 to Length(imTables)-1 do
  allImages:=allImages+Length(imTables[i].Images);
 toLog(Format(_('Loaded %d image table(s), total %d images'),[Length(imTables),allImages]));
 if allImages<1 then begin
  EnableForm;
  Exit;
 end;

 //Check if replaced images array is empty, and fill it if so
 CheckReplacedTables;

 //Load image names if needed
 if cbUseNames.Checked then
  LoadNames(imTables,meLog.Lines,@SetProgress);

 //Update lists
 UpdateFullList;
 UpdateList;

 //Select first image
 if lbImages.Count>0 then begin
  lbImages.ItemIndex:=0;
  lbImages.Selected[0]:=true;
  lbImages.OnClick(Self);
 end;

 //Update free blocks label
 UpdateFreeBlocks;

 SetDirty(false);

 //Set img base
 edImgBase.Text:='+'+IntToHex(imgbase,2);

 //Enable form
 EnableForm;

 lbImages.SetFocus;
 
end;

procedure TfmMain.DisableForm;
begin
// fmWait.Show;
 if not fmEnabled then Exit;
 fmEnabled:=false;
 lbImages.Enabled:=false;
 tmHideProgress.Enabled:=false;
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
// if fmEnabled then Exit;
 lbImages.Enabled:=true;
 btOpenFw.Hint:=_('Open RAW file');
 btOpenFw.Tag:=0;
 Screen.Cursor:=crDefault;
 sbStatus.Panels[0].Text:=Format(_('Finished in %s milliseconds, now waiting'),[IntToStr(MilliSecondsBetween(stTime,Time))]);
 tmHideProgress.Enabled:=true;
// Stop:=true;
 ok:=(lbImages.Count>0);
 acReplaceImg.Enabled:=ok;
 btReplaceImg.SkinData.Invalidate;
 acSaveImg.Enabled:=ok;
 btSaveImg.SkinData.Invalidate;
 acSaveProject.Enabled:=ok;
// btSaveProject.SkinData.Invalidate;
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
// if ok then begin
//  if (lbImages.ItemIndex>=0) and (lbImages.ItemIndex<lbImages.Count) then begin
//   if imArray[getCurrentImg].imType=imBWI then begin
//    acReplaceImg.Enabled:=false;
//    acDeleteImg.Enabled:=false;
//   end;
//  end;
// end;
// fmWait.Hide;
 lbFilteredImages.Caption:=Format(_('Images shown: %d'),[lbImages.Count]);
 fmEnabled:=true;
 pbOriginal.Repaint;
 pbReplaced.Repaint;
 lbImages.Repaint;
end;

procedure TfmMain.UpdateList;
var
 i:integer;
 filter:string;
 useFilter:boolean;
 tmpList:TStrings;
 cName:string;
 AddItem:boolean;
 im:TfwImg;
 percent,oldpercent:integer;
begin
 cName:='';
 if (lbImages.ItemIndex>=0) and (lbImages.ItemIndex<lbImages.Count) then
  if lsFilteredImages.Count>lbImages.ItemIndex then
   cName:=lsFilteredImages[lbImages.ItemIndex];
 tmpList:=TStringList.Create;
 lbImages.Tag:=1;
 filter:=AnsiUpperCase(Trim(edFilterName.Text));
 useFilter:=Length(filter)>0;
 lsFilteredImages.Clear;
 SetProgress(_('Updating view...'),0);
 oldpercent:=0;
 for i:=0 to lsImages.Count-1 do begin
  percent:=Round(i/lsImages.Count*100);
  if percent<>oldpercent then begin
   oldpercent:=percent;
  end;
  AddItem:=false;
  im:=GetImageFromItem(lsImages[i],i);
  if cbDeleted.Checked then
   if im.deleted then AddItem:=true;
  if cbReplaced.Checked then
   if (im.replaced) and (not im.deleted) then AddItem:=true;
  if cbUnchanged.Checked then
   if not (im.deleted or im.replaced) then AddItem:=true;
  if useFilter then
   if Pos(filter,AnsiUpperCase(lsImages[i]))<=0 then AddItem:=false; 
  if AddItem then
    lsFilteredImages.Add(lsImages[i]);
 end;
 lbImages.Count:=lsFilteredImages.Count;
 lbImages.Tag:=0;
 lbImages.Invalidate;
 lbFilteredImages.Caption:=Format(_('Images shown: %d'),[lbImages.Count]);
 FreeAndNil(tmpList);
 if cName<>'' then begin
  i:=lsFilteredImages.IndexOf(cName);
  if i>-1 then begin
   lbImages.ItemIndex:=i;
   lbImages.Selected[i]:=true;
  end;
 end;
end;

procedure TfmMain.lbImagesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 s:string;
 lb:TsListBox;
 Cnv:TCanvas;
 R:TRect;
 fwImg:TfwImg;
 img:TSingleImage;
 aspRatio:real;
 tmpInt:integer;
 idx:integer;
 LoadedImg:boolean;
begin
 //Init
 lb:=(Control as TsListBox);
 if lb.Tag<>0 then Exit;
 Cnv:=lb.Canvas;
 R:=Rect;

 //Get text to draw
 s:=lb.Items[Index];
 idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
 if cbShowImageTableNumber.Checked then
  s:='['+IntToStr(idx+1)+'] '+Copy(s,Pos(#1,s)+1,Length(s))
 else
  s:=Copy(s,Pos(#1,s)+1,Length(s));

 //Get image to draw
 if idx>-1 then begin
  img:=nil;
  LoadedImg:=false;
  fwImg:=imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index)];
  if fwImg.Image<>nil then begin
   img:=fwImg.Image;
   LoadedImg:=true;
  end;
  if not LoadedImg then begin
   img:=GetImgFromArray(FData,imTables[idx],GetIndexInTables(idx,imTables,Index));
   fwImg:=imTables[idx].Images[GetIndexInTables(idx,imTables,Index)];
  end;

 //Set colors
 if odSelected in State then begin
  Cnv.Brush.Color:=fmMain.sSkinManager1.GetHighLightColor;
  Cnv.Font.Color:=fmMain.sSkinManager1.GetHighLightFontColor;
  if Index=lb.ItemIndex then begin
   Cnv.Font.Color:=clYellow;
   Cnv.Font.Style:=[];
  end;
 end else begin
  if fwImg.deleted then
   Cnv.Brush.Color:=clGray
  else if fwImg.replaced then
   Cnv.Brush.Color:=clGreen
  else
   Cnv.Brush.Color:=lb.Color;
 end;

 //Fill Rect
 Cnv.FillRect(R);

 R.Right:=R.Left+(Control as TsListBox).ItemHeight;

 //Calc image size in listbox
  if img.Height<>0 then
   aspRatio:=img.Width/img.Height
  else
   aspRatio:=1;
  if (aspRatio)<((R.Right-R.Left)/(R.Bottom-R.Top)) then
   R.Right:=R.Left+Round(aspRatio*(R.Right-R.Left))
  else
   R.Bottom:=R.Top+Round((R.Bottom-R.Top)/aspRatio);
  tmpInt:=(lb.ItemHeight-(R.Bottom-R.Top)) div 2;
  R.Bottom:=R.Bottom+tmpInt;
  R.Top:=R.Top+tmpInt;

  //Draw image and resize Rect so text would not overwrite image
  try
   DisplayTransparentImage(cnv,R,img);
  except
  end;

  // We don't need to free PNG object, because it should be in the cache
  R:=Rect;
  R.Left:=R.Left+lb.ItemHeight+3;
 end;

 //Draw text
 Cnv.TextRect(R,R.Left,(R.Top+(R.Bottom-R.Top) div 2)-Cnv.TextHeight(s) div 2,s);

 //Update status bar caption, if needed
 if (platform_version<>unknown) and (sbStatus.Tag=1) then begin
  case platform_version of
   db2010: begin
    sbStatus.Panels[2].Text:='db201x      ';
    if not loadedBABE then begin
     imgbase:=$44020000;
     edImgBase.Text:='+'+IntToHex(imgbase,2);
    end;
   end;
   db2020: sbStatus.Panels[2].Text:='db2020      ';
   db3150: sbStatus.Panels[2].Text:='db3150      ';
  end;
  sbStatus.Tag:=0;
 end;
end;

procedure TfmMain.FormResize(Sender: TObject);
var
 imWidth:Integer;
begin
 lbNoWarranty.AutoSize:=false;
 lbNoWarranty.AutoSize:=true;
 pnAbout.Height:=lbNoWarranty.Height;
 imWidth:=sPanel3.Width-imArrow.Width;
 gbOriginal.Width:=imWidth div 2;
 btRestoreOriginal.Left:=imArrow.Left+13;
 btRestoreOriginal.Top:=((imArrow.Top+imArrow.Height) div 2)-btRestoreOriginal.Height+10;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
 img:TImagingPNG;
 Res:TResourceStream;
 sl:TStrings;
begin
 DragAcceptFiles(Handle,true);
 fmMain.Caption:=fmCaption+' v'+swversion;
 Application.Title:=fmMain.Caption;
 sSkinManager1.SkinDirectory:=ExtractFilePath(Application.ExeName)+'Skins';
 lbImages.DoubleBuffered:=true;
 lsImages:=TStringList.Create;
 lsFilteredImages:=TStringList.Create;
 lbNoWarranty.Caption:=lbNoWarranty.Caption+#10#13;
 img:=TImagingPNG.Create;
 Res:=TResourceStream.Create(hInstance, 'DELETEDPNG', PChar('PNG2'));
 img.LoadFromStream(Res);
 FreeAndNil(Res);
 deletedImg:=TSingleImage.Create;
 img.AssignToImage(deletedImg);
 FreeAndNil(img);
 sl:=TStringList.Create;
 sSkinManager1.GetSkinNames(sl);
 sl.Insert(0,_('No skin'));
 cbSkins.Items.AddStrings(sl);
 FreeAndNil(sl);
 sSkinManager1.Active:=JvFormStorage1.ReadBoolean('SkinManager active',true);
 sSkinManager1.SkinName:=JvFormStorage1.ReadString('SkinName',sSkinManager1.SkinName);
 sSkinManager1BeforeChange(sSkinManager1);
 sSkinManager1AfterChange(sSkinManager1);
 //!!!TEMP
// btSaveRAW.Left:=btLoadProject.Left;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
 DragAcceptFiles(Handle,false);
 JvFormStorage1.WriteBoolean('SkinManager active',sSkinManager1.Active);
 JvFormStorage1.WriteString('SkinName',sSkinManager1.SkinName);
 FreeAndNil(lsImages);
 FreeAndNil(lsFilteredImages);
 FreeAndNil(deletedImg);
end;

function TfmMain.GetIndexInTables(tNo: integer; Tables: TImgTables;
  idx: integer; idx_is_global:boolean=false): integer;
var
 gIdx,i:integer;
begin
 if idx_is_global then
  gIdx:=idx
 else
  gIdx:=lsImages.IndexOf(lsFilteredImages[idx]);
 for i:=0 to tNo-1 do begin
  gIdx:=gIdx-Length(imTables[i].Images);
 end;
 Result:=gIdx;
end;

procedure TfmMain.lbImagesClick(Sender: TObject);
begin
 pbOriginal.Repaint;
 pbReplaced.Repaint;
end;

procedure TfmMain.cbStretchPreviewClick(Sender: TObject);
begin
 pbOriginal.Repaint;
 pbReplaced.Repaint;
end;

procedure TfmMain.UpdateFullList;
var
 z,i:integer;
begin
 lsImages.Clear;
 for z:=0 to Length(imTables)-1 do begin
  for i:=0 to Length(imTables[z].Images)-1 do begin
   lsImages.Add(IntToStr(z)+#1+imTables[z].Images[i].DisplayName);
  end;
 end;
end;

procedure TfmMain.edFilterNameChange(Sender: TObject);
begin
 if not fmEnabled then Exit;
 DisableForm;
 UpdateList;
 EnableForm;
end;

function TfmMain.GetImageFromItem(str: string;Index:integer): TfwImg;
var
 idx:integer;
begin
 idx:=StrToIntDef(Copy(str,0,Pos(#1,str)-1),-1);
 if imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index,true)].Image<>nil then
  Result:=imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index,true)]
 else
  Result:=imTables[idx].Images[GetIndexInTables(idx,imTables,Index,true)];
end;

procedure TfmMain.lbImagesData(Control: TWinControl; Index: Integer;
  var Data: String);
begin
 if lsFilteredImages.Count<(Index+1) then Exit;
 if Index<0 then Exit;
 Data:=lsFilteredImages[Index];
end;

procedure TfmMain.cbExpertModeClick(Sender: TObject);
begin
 pnDevControls.Visible:=(Sender as TsCheckBox).Checked;
end;

procedure TfmMain.sbClearEdFilterClick(Sender: TObject);
begin
 DisableForm;
 edFilterName.Clear;
 UpdateList;
 EnableForm;
end;

procedure TfmMain.cbDeletedClick(Sender: TObject);
begin
 DisableForm;
 UpdateList;
 EnableForm;
end;

procedure TfmMain.cbReplacedClick(Sender: TObject);
begin
 DisableForm;
 UpdateList;
 EnableForm;
end;

procedure TfmMain.cbUnchangedClick(Sender: TObject);
begin
 DisableForm;
 UpdateList;
 EnableForm;
end;

procedure TfmMain.seThumbHeightChange(Sender: TObject);
begin
 lbImages.ItemHeight:=seThumbHeight.Value;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
 lbImages.ItemHeight:=seThumbHeight.Value;
end;

procedure TfmMain.acSaveImgExecute(Sender: TObject);
var
 s:string; //Item text
 idx:integer; //Image table index
 selCount,savedNumber:integer;
 i:integer;
 SavePath:string;
 oldPercent,percent:integer;
begin
 selCount:=0;
 for i:=0 to lbImages.Count-1 do
  if lbImages.Selected[i] then SelCount:=SelCount+1;

 if selCount>1 then begin
  //Save more than one image
  sPathDialog1.Path:=PathImage;
  if not sPathDialog1.Execute then Exit;
  PathImage:=sPathDialog1.Path;
  DisableForm;
  SavePath:=IncludeTrailingPathDelimiter(sPathDialog1.Path);
  savedNumber:=0;
  oldPercent:=0;
  for i:=0 to lbImages.Count-1 do begin
   if lbImages.Selected[i] then begin
    savedNumber:=savedNumber+1;
    percent:=Round(savedNumber/selCount*100);
    if (percent-oldPercent)<>0 then begin
     oldPercent:=percent;
     SetProgress(Format(_('Saving: %d of %d'),[savedNumber,selCount]),percent);
     Application.ProcessMessages;
    end;
    //First, get file name
    s:=lbImages.Items[i];
    idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
    //Trim table index from name
    s:=Copy(s,Pos(#1,s)+1,Length(s));
    //Save it
    if cbShowImageTableNumber.Checked then
     SaveImageToFile(i,idx,SavePath+IntToStr(idx+1)+'_'+s+'.png',s)
    else
     SaveImageToFile(i,idx,SavePath+s+'.png',s)
   end;
  end;
  EnableForm;
 end else begin
  //Save single image
  //First, get file name
  s:=lbImages.Items[lbImages.ItemIndex];
  idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
  //Trim table index from name
  s:=Copy(s,Pos(#1,s)+1,Length(s));
  //Save it
  //Set default name
  SavePictureDialog1.FileName:=s+'.png';
  SavePictureDialog1.InitialDir:=PathImage;
  if not SavePictureDialog1.Execute then Exit;
  PathImage:=ExtractFilePath(SavePictureDialog1.FileName);
  if FileExists(ChangeFileExt(SavePictureDialog1.FileName,'.png')) then begin
   if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
    EnableForm;
    Exit;
   end
  end;
  DisableForm;
  SaveImageToFile(lbImages.ItemIndex,idx,SavePictureDialog1.FileName,s);
  EnableForm;
 end;
 lbImages.SetFocus;
end;

procedure TfmMain.ClearData;
begin
 lbImages.Clear;
 imTables:=nil;
 imReplTables:=nil;
 lsImages.Clear;
 lsFilteredImages.Clear;
end;

procedure TfmMain.SaveImageToFile(ItemIndex, TableIndex: integer;
  fName: TFileName; imName:string);
var
 img:TSingleImage;
begin
 //Get image and save it
 if TableIndex>-1 then begin
  img:=GetImgFromArray(FData,imTables[TableIndex],GetIndexInTables(TableIndex,imTables,ItemIndex));
  if img.Height<1 then begin
   toLog(Format(_('Height of image %s is less than 1, skipped'),[imName]));
   Exit;
  end;
  if img.Width<1 then begin
   toLog(Format(_('Width of image %s is less than 1, skipped'),[imName]));
   Exit;
  end;
  if FileExists(fName) then
   toLog(Format(_('Image %s already exists, overwriting it'),[ExtractFileName(fName)]));
  img.SaveToFile(fName);
  // We don't need to free PNG object, because it should be in the cache
 end;
end;

procedure TfmMain.toLog(s: string);
begin
 meLog.Lines.Add(s);
end;

procedure TfmMain.lbImagesMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 i:integer;
 s:string;
 pn:TPoint;
 idx:integer;
 fwimg:TfwImg;
begin
 if not fmEnabled then Exit;
 if ((OldHintPoint.X-X)=0) and
    ((OldHintPoint.Y-Y)=0) then Exit;
 OldHintPoint.X:=X;
 OldHintPoint.Y:=Y;
 i:=lbImages.ItemAtPos(Point(X,Y),true);
 if i<0 then begin
  lbImages.Hint:='';
 end else begin
  s:=lbImages.Items[i];
  idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);

  s:=Copy(s,Pos(#1,s)+1,Length(s))+#10#13+_('Image table: ')+IntToStr(idx+1);

  fwimg:=imTables[idx].Images[GetIndexInTables(idx,imTables,i)];
  case fwimg.imType of
   imPNG:s:=s+#10#13+_('Image type: ')+'PNG';
   imPKI:s:=s+#10#13+_('Image type: ')+'PKI';
   imBWI:s:=s+#10#13+_('Image type: ')+'BWI';
   imColor:s:=s+#10#13+_('Image type: ')+'Color';
   imBMP:s:=s+#10#13+_('Image type: ')+'BMP';
  end;

  s:=s+#10#13+_('Image dimensions: ')+IntToStr(fwimg.im_width)+'x'+IntToStr(fwimg.im_height)+' '+_('pixels');
  s:=s+#10#13+_('Image placeholder: ')+IntToStr(fwimg.im_width_space)+'x'+IntToStr(fwimg.im_height_space)+' '+_('pixels');
  s:=s+#10#13+_('Image address: ')+'$'+IntToHex(imTables[idx].picbase+fwimg.orig_offset,8);
  s:=s+#10#13+_('Space for image: ')+IntToStr(fwimg.Space)+' '+_('bytes');
//  s:=s+#10#13+_('Space for image: ')+'$'+IntToHex(fwimg.Space,2)+' '+_('bytes');
  s:=s+#10#13+_('Image end: ')+'$'+IntToHex(imTables[idx].picbase+fwimg.orig_offset+fwimg.Space,8);

{  //db2010 data
  s:=s+#10#13+'bt: '+IntToStr(fwimg.bt);
  s:=s+#10#13+'bp: '+IntToStr(fwimg.bp);
  s:=s+#10#13+'transp: '+IntToStr(fwimg.transp);
  s:=s+#10#13+'pal_sz: '+IntToStr(fwimg.pal_sz);
  s:=s+#10#13+'transp_sz: '+IntToStr(fwimg.transp_sz);}

  //Now if image is replaced - show replaced image params
  if fmEnabled then begin
   fwimg:=imReplTables[idx].Images[GetIndexInTables(idx,imTables,i)];
   if fwimg.deleted then begin
    s:=s+#10#13+#10#13+_('Image deleted');
   end else if fwimg.replaced then begin
    s:=s+#10#13+#10#13+_('Image replaced to:');
    case fwimg.imType of
     imPNG:s:=s+#10#13+_('Image type: ')+'PNG';
     imPKI:s:=s+#10#13+_('Image type: ')+'PKI';
     imBWI:s:=s+#10#13+_('Image type: ')+'BWI';
     imColor:s:=s+#10#13+_('Image type: ')+'Color';
     imBMP:s:=s+#10#13+_('Image type: ')+'BMP';
    end;
    s:=s+#10#13+_('Image dimensions: ')+IntToStr(fwimg.im_width)+'x'+IntToStr(fwimg.im_height)+' '+_('pixels');
    s:=s+#10#13+_('Image size: ')+IntToStr(fwimg.Used)+' '+_('bytes');
   end;
  end;

  lbImages.Hint:=s;
  pn.X:=x;
  pn.Y:=y;
  pn:=lbImages.ClientToScreen(pn);
  Application.ActivateHint(pn);
 end;


end;

procedure TfmMain.sbHideFilterClick(Sender: TObject);
begin
 pnFilter.Visible:=not pnFilter.Visible;
 if pnFilter.Visible then
  sbHideFilter.Caption:='t'
 else
  sbHideFilter.Caption:='u';
end;

procedure TfmMain.pbOriginalPaint(Sender: TObject);
var
 idx:integer;
 s:string;
 img:TSingleImage;
 R:TRect;
begin
 //Get table index
 if (lbImages.ItemIndex<0) or (lbImages.ItemIndex>=lsFilteredImages.Count) then Exit;
 s:=lsFilteredImages[lbImages.ItemIndex];
 idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);

 //Get image to draw
 img:=nil;
 if idx>-1 then
  img:=GetImgFromArray(FData,imTables[idx],GetIndexInTables(idx,imTables,lbImages.ItemIndex));

 if img=nil then Exit;

// imOriginal.Picture.Assign(img);
 if cbStretchPreview.Checked then begin
  DisplayTransparentImage(pbOriginal.Canvas,pbOriginal.ClientRect,img,rfBicubic)
 end else begin
  R:=CenterRect(img.BoundsRect,pbOriginal.ClientRect);
  DisplayTransparentImage(pbOriginal.Canvas,R,img,rfBicubic)
 end;
end;

procedure TfmMain.acClearLogExecute(Sender: TObject);
begin
 meLog.Clear;
end;

procedure TfmMain.acReplaceImgExecute(Sender: TObject);
var
 Index:integer;
begin
 //Get image name and index
 Index:=lbImages.ItemIndex;

 //Open new image
 OpenPictureDialog1.InitialDir:=PathImage;
 if not OpenPictureDialog1.Execute then Exit;
 PathImage:=ExtractFilePath(OpenPictureDialog1.FileName);

 DoReplaceImage(OpenPictureDialog1.FileName,Index);

 lbImages.SetFocus;

end;

procedure TfmMain.CheckReplacedTables;
var
 i,idx:integer;
begin
 if Length(imReplTables)<>Length(imTables) then begin
  SetLength(imReplTables,Length(imTables));
  for idx:=0 to Length(imTables)-1 do begin
   imReplTables[idx].tableStart:=imTables[idx].tableStart;
   imReplTables[idx].pheader:=imTables[idx].pheader;
   imReplTables[idx].numIcons:=imTables[idx].numIcons;
   imReplTables[idx].offset:=imTables[idx].offset;
   imReplTables[idx].picbase:=imTables[idx].picbase;
   imReplTables[idx].names:=imTables[idx].names;
   imReplTables[idx].offsettable:=imTables[idx].offsettable;
   SetLength(imReplTables[idx].Images,Length(imTables[idx].Images));
   for i:=0 to Length(imTables[idx].Images)-1 do begin
    imReplTables[idx].Images[i]:=imTables[idx].Images[i];
    imReplTables[idx].Images[i].Image:=nil;
   end;
  end;
 end;
end;

procedure TfmMain.sSkinManager1BeforeChange(Sender: TObject);
begin
 if not sSkinManager1.Active then begin
  sPanel1.SkinData.SkinSection:='PANEL';
 end else begin
  if (AnsiLowerCase(sSkinManager1.SkinName)='wlm') then
   sPanel1.SkinData.SkinSection:='ICOLINE'
  else if (AnsiLowerCase(sSkinManager1.SkinName)='vista') then
   sPanel1.SkinData.SkinSection:='TOOLBAR'
  else if (AnsiLowerCase(sSkinManager1.SkinName)='neutral3') then
   sPanel1.SkinData.SkinSection:='ICOLINE'
  else
   sPanel1.SkinData.SkinSection:='PANEL';
  end;
  ChangePanelsSkinSection(fmMain,sPanel1.SkinData.SkinSection);
end;

procedure TfmMain.pbReplacedPaint(Sender: TObject);
var
 idx:integer;
 s:string;
 img:TSingleImage;
 R:TRect;
begin
 if not fmEnabled then Exit;

 //Get table index
 if (lbImages.ItemIndex<0) or (lbImages.ItemIndex>=lsFilteredImages.Count) then Exit;
 s:=lsFilteredImages[lbImages.ItemIndex];
 idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);

 //Get image to draw
 img:=nil;
 if idx>-1 then
  img:=imReplTables[idx].Images[GetIndexInTables(idx,imTables,lbImages.ItemIndex)].Image;

 if img=nil then Exit;

 if cbStretchPreview.Checked then begin
  DisplayTransparentImage(pbReplaced.Canvas,pbReplaced.ClientRect,img,rfBicubic)
 end else begin
  R:=CenterRect(img.BoundsRect,pbReplaced.ClientRect);
  DisplayTransparentImage(pbReplaced.Canvas,R,img,rfBicubic)
 end;
end;

procedure TfmMain.acDeleteImgExecute(Sender: TObject);
var
 Index,idx,z,i:integer;
 s:string;
 fwimg:TfwImg;
begin
 //Disable form
 DisableForm;

 for Index:=0 to lbImages.Count-1 do begin
  //Check if image is selected
  if not lbImages.Selected[Index] then Continue;

  //Get image name and index
  s:=lbImages.Items[Index];
  idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
  s:=IntToStr(idx+1)+'_'+Copy(s,Pos(#1,s)+1,Length(s));
  if idx<0 then Exit;

  //Get image from array
  fwimg:=imTables[idx].Images[GetIndexInTables(idx,imReplTables,Index)];

  //Remove picture and set 'deleted' flag
  fwimg.deleted:=true;
  fwimg.replaced:=false;
  fwimg.Image:=deletedImg;

  //Save img to replaced array
  imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index)]:=fwimg;

  //Check other images with the same address and delete them too
  for z:=0 to Length(imTables)-1 do begin
   for i:=0 to Length(imTables[z].Images)-1 do begin
    if imTables[z].Images[i].name<>fwimg.name then begin
     if imTables[z].Images[i].orig_offset=fwimg.orig_offset then begin
      imReplTables[z].Images[i]:=imTables[z].Images[i];
      with imReplTables[z].Images[i] do begin
       deleted:=true;
       replaced:=true;
       Image:=deletedImg;
      end;
     end;
    end;
   end;
  end;

 end;

 //Update free blocks label
 UpdateFreeBlocks;

 SetDirty();

 //Enable form
 EnableForm;
end;

procedure TfmMain.cbSkinsChange(Sender: TObject);
begin
 if cbSkins.Text=_('No skin') then begin
  sSkinManager1.Active:=false;
  sSkinManager1BeforeChange(sSkinManager1);
  lbOrigImageInfo.Font.Color:=clWindowText;
  lbImageInfo.Font.Color:=clWindowText;
 end else begin
  sSkinProvider1.SkinData.BeginUpdate;
  sSkinManager1.SkinName:=cbSkins.Text;
  sSkinProvider1.SkinData.EndUpdate;
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

procedure TfmMain.ChangePanelsSkinSection(Control: TWinControl;
  SkinSection: string);
var
 i:integer;
 ctrl:TControl;
 sp:TsPanel;
 tb:TsToolBar;
begin
 if Control.ControlCount<1 then Exit;
 for i:=0 to Control.ControlCount-1 do begin
  ctrl:=Control.Controls[i];
  if (ctrl is TWinControl) then
   ChangePanelsSkinSection(TWinControl(ctrl),SkinSection);
  if (ctrl is TsPanel) then begin
   sp:=(ctrl as TsPanel);
   if (sp.SkinData.SkinSection='ICOLINE') or (sp.SkinData.SkinSection='PANEL') then
    sp.SkinData.SkinSection:=SkinSection;
  end;
  if (ctrl is TsToolBar) then begin
   tb:=(ctrl as TsToolBar);
   if (tb.SkinData.SkinSection='ICOLINE') or (tb.SkinData.SkinSection='TOOLBAR') then
    if SkinSection='PANEL' then
     tb.SkinData.SkinSection:='TOOLBAR'
    else
     tb.SkinData.SkinSection:=SkinSection;
  end;
 end;
end;

procedure TfmMain.lbImagesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_DELETE then begin
  acDeleteImg.Execute;
  lbImages.SetFocus;
 end else if Key=VK_RETURN then begin
  Key:=0;
 end;
end;

procedure TfmMain.acMakeVKPExecute(Sender: TObject);
var
 newFw:PByte;
 PatchList:TStringList;
 fVkp:System.Text;
 tmpStr:string;
 percent,old_pos,i:integer;
begin
 DisableForm;
 //Create patched firmware
 try
  newFw:=CreatePatchedFW(imTables,imReplTables,@SetProgress);
 except
  on E:Exception do begin
   try
    FreeMem(newFw);
   except
   end;
   EnableForm;
   raise Exception.Create(E.Message);
  end;
 end;

 //Generate VKP (do byte-compare)
 PatchList:=GenerateVKP(FData,newFw,iFileLen,imTables,@SetProgress);

 //Free memory
 FreeMem(newFw);

 //Check if patch is empty
 if PatchList.Count<1 then begin
  EnableForm;
  raise Exception.Create(_('Nothing is changed, will not generate empty patch'));
 end;

 //Generate preview image

 EnableForm;

 //Save everything
 SaveDialog1.Filter:=_('VKP files (*.vkp)|*.vkp');
 tmpStr:=ExtractFileName(fwFileName);
 if Pos('_MAIN',tmpStr)<1 then begin
  if not InputQuery(_('Enter version'),_('Unable to guess firmware version'+#10#13+'Please enter it'),tmpStr) then Exit;
 end else begin
  tmpStr:=Copy(tmpStr,0,Pos('_MAIN',tmpStr)-1);
 end;
 SaveDialog1.FileName:=tmpStr+'.vkp';
 SaveDialog1.InitialDir:=PathPatch;
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.vkp')) then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   EnableForm;
   Exit;
  end
 end;
 PathPatch:=ExtractFilePath(SaveDialog1.FileName);
 AssignFile(fVkp,ChangeFileExt(SaveDialog1.FileName,'.vkp'));
 FileMode:=2;
 Rewrite(fVkp);
 WriteLn(fVkp,';(!) '+tmpStr);
 //Write subHeader
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,';(i) заміна системної графіки телефонів Sony Ericsson');
 WriteLn(fVkp,';(i) автоматично зґенерований програмою');
 WriteLn(fVkp,';(i) SE Image Tool '+swversion);
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,';(i) replace system graphics of Sony Ericsson phones');
 WriteLn(fVkp,';(i) automatically generated by');
 WriteLn(fVkp,';(i) SE Image Tool '+swversion);
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,';(i) замена системной графики телефонов Sony Ericsson');
 WriteLn(fVkp,';(i) автоматически сгенерирован программой');
 WriteLn(fVkp,';(i) SE Image Tool '+swversion);
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,'+'+IntToHex(imgbase,8));
 //--------------------------
 Application.ProcessMessages;
 old_pos:=0;
 for i:=0 to PatchList.Count-1 do begin
  WriteLn(fVkp,PatchList[i]);
  percent:=Round((i/(PatchList.Count))*100);
  if old_pos<>percent then begin
   pbProgress.Position:=percent;
   old_pos:=percent;
   Application.ProcessMessages;
  end;
 end;
 CloseFile(fVkp);
 SetDirty(false);
end;

procedure TfmMain.acSaveRAWExecute(Sender: TObject);
var
 newFw:PByte;
 ms:TMemoryStream;
begin
 if Length(imTables)<1 then
  raise Exception.Create(_('No firmware loaded'));

 //Create patched firmware
 newFw:=CreatePatchedFW(imTables,imReplTables,@SetProgress);

 //Query filename
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw|All files (*.*)|*.*');
 SaveDialog1.FileName:=ChangeFileExt(fwFileName,'')+'_patched.raw';
 SaveDialog1.InitialDir:=PathFw;
 if not SaveDialog1.Execute then Exit;
 if FileExists(ChangeFileExt(SaveDialog1.FileName,'.raw')) then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('File already exists. Rewrite?'))), PChar(AnsiString(_('Rewrite?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   FreeMem(newFw);
   EnableForm;
   Exit;
  end
 end;
 PathFw:=ExtractFilePath(SaveDialog1.FileName);

 //Save to file
 ms:=TMemoryStream.Create;
 ms.SetSize(iFileLen);
 CopyMemory(ms.Memory,newFw,iFileLen);
 ms.SaveToFile(SaveDialog1.FileName);
 ms.Free;

 //Free memory
 FreeMem(newFw);
end;

procedure TfmMain.acClearFWExecute(Sender: TObject);
begin
 //Clear replaced images
 imReplTables:=nil;

 //Fill replaced images array
 CheckReplacedTables;

 //Repaint
 lbImages.Invalidate;
 lbImagesClick(lbImages);

 //Update free blocks label
 UpdateFreeBlocks;

 SetDirty(false);
end;

procedure TfmMain.acLoadProjectExecute(Sender: TObject);
var
 patchLines:TStringList;
 newFw:PByte;
 changedOffsets:TIntegerArray;
 newImTables:TImgTables;
 changedImages:TImgTables;
begin
 //Open file
 OpenDialog1.Filter:=_('VKP files (*.vkp)|*.vkp');
 OpenDialog1.InitialDir:=PathPatch;
 if not OpenDialog1.Execute then Exit;
 PathPatch:=ExtractFilePath(OpenDialog1.FileName);

 //Disable form
 DisableForm;

 try
  //Load VKP
  patchLines:=LoadVKP(OpenDialog1.FileName);

  //Apply VKP to firmware
  newFw:=ApplyVKPToFw(imTables,imReplTables,patchLines,changedOffsets,@SetProgress);

  //Load image tables from new FW
  newImTables:=LoadImageTables(newFw,meLog.Lines,@SetProgress);

  //Compare current and patched image tables, and extract changes
  changedImages:=CompareImageTables(imTables,newImTables,newFw, deletedImg, @SetProgress);

  //Load changed images from patched firmware to project
  imReplTables:=changedImages;
 finally
  //Free everything
  FreeAndNil(patchLines);

  //Enable form
  EnableForm;
 end;

 //Free everything
 FreeMem(newFw);

 SetDirty(false);

 //Enable form
 EnableForm;
end;

function TfmMain.LoadVKP(fName: TFileName): TStringList;
var
 f:System.text;
 s:string;
begin
 Result:=TStringList.Create;

 //Open file
 FileMode:=fmOpenRead;
 AssignFile(f,fName);
 Reset(f);

 //Read it
 while not eof(f) do begin
  Readln(f,s);
  s:=Trim(s);

  //Skip empty lines
  if Length(s)<1 then Continue;

  //Skip comments
  if Copy(s,1,1)=';' then Continue;

  //Add line
  Result.Add(s);
 end;

 //Close file
 CloseFile(f);
end;

procedure TfmMain.tbHueMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 sSkinManager1.HueOffset:=tbHue.Position;
end;

procedure TfmMain.JvFormStorage1AfterRestorePlacement(Sender: TObject);
begin
 sSkinManager1.HueOffset:=tbHue.Position;
 if pnFilter.Visible then
  sbHideFilter.Caption:='t'
 else
  sbHideFilter.Caption:='u';
 FormResize(Self);
end;

procedure TfmMain.tmHideProgressTimer(Sender: TObject);
begin
 pbProgress.Visible:=false;
end;

procedure TfmMain.acRestoreOriginalExecute(Sender: TObject);

var
 Index,idx,z,i:integer;
 s:string;
 fwimg:TfwImg;
begin
 //Disable form
 DisableForm;

 for Index:=0 to lbImages.Count-1 do begin
  //Check if image is selected
  if not lbImages.Selected[Index] then Continue;

  //Get image name and index
  s:=lbImages.Items[Index];
  idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
  s:=IntToStr(idx+1)+'_'+Copy(s,Pos(#1,s)+1,Length(s));
  if idx<0 then Exit;

  //Get image from array
  fwimg:=imTables[idx].Images[GetIndexInTables(idx,imTables,Index)];

  //Clear image
  fwimg.deleted:=false;
  fwimg.replaced:=false;
  fwimg.Image:=nil;

  //Save img to replaced array
  imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index)]:=fwimg;

  //Check other images with the same address and restore them too
  for z:=0 to Length(imTables)-1 do begin
   for i:=0 to Length(imTables[z].Images)-1 do begin
    if imTables[z].Images[i].name<>fwimg.name then begin
     if imTables[z].Images[i].orig_offset=fwimg.orig_offset then begin
      imReplTables[z].Images[i]:=imTables[z].Images[i];
      with imReplTables[z].Images[i] do begin
       deleted:=false;
       replaced:=false;
       Image:=nil;
      end;
     end;
    end;
   end;
  end;
  
 end;

 //Update free blocks label
 UpdateFreeBlocks;

 //Enable form
 EnableForm;
end;

procedure TfmMain.acAboutExecute(Sender: TObject);
begin
 fmAbout.ShowModal;
end;

procedure TfmMain.cbUseNamesClick(Sender: TObject);
var
 z,i:integer;
 s:string;
begin
 DisableForm;
 //Load or unload names
 if cbUseNames.Checked then
  LoadNames(imTables,meLog.Lines,@SetProgress)
 else begin
  for z:=0 to Length(imTables)-1 do begin
   for i:=0 to Length(imTables[z].Images)-1 do begin
    imTables[z].Images[i].DisplayName:=imTables[z].Images[i].name;
   end;
  end;
 end;
 //Update lists
 s:='';i:=0;
 if (lbImages.ItemIndex>=0) and (lbImages.ItemIndex<lbImages.Count) then begin
  //Saving current image name
  s:=GetImageByDisplayIndex(lbImages.ItemIndex).name;
 end;

 UpdateFullList;
 UpdateList;

 if s<>'' then begin
  //Restore current image, finding it by name
  for z:=0 to lbImages.Count-1 do begin
   //Search only current image table
   if GetImageTableByDisplayIndex(z)=i then begin
    if s=GetImageByDisplayIndex(z).name then begin
     //Got it!
     lbImages.ItemIndex:=z;
     lbImages.Selected[z]:=true;
     break;
    end
   end;
  end;
 end;

 EnableForm;
end;

procedure TfmMain.btFreeSpaceLogClick(Sender: TObject);
var
 i,z:integer;
 FreeBlocks:TFreeBlocks;
begin
 for z:=0 to Length(imTables)-1 do begin
  toLog('============= Image table '+IntToStr(z)+' =============');
  //Get free blocks
  FreeBlocks:=GetFreeBlocks(imTables[z],imReplTables[z]);
  //Sort them by offset accending
  SortFeeBlocksByOffset(FreeBlocks);
  //Print free blocks to log
  for i:=0 to Length(FreeBlocks)-1 do begin
   toLog(Format('Block %d: start - %d, length - %d',[i,FreeBlocks[i].StartOffset,FreeBlocks[i].Length]));
  end;
  toLog('=========================================');
 end;
end;

procedure TfmMain.btSaveRAWImageClick(Sender: TObject);
var
 img:TfwImg;
 imTable:TImgTable;
 data:TmByteArray;
 dstfName:string;
begin
 //Get selected image
 img:=GetImageByDisplayIndex(lbImages.ItemIndex);
 //Get selected image table
 imTable:=imTables[GetImageTableByDisplayIndex(lbImages.ItemIndex)];
 data:=GetRAWData(FData,imTable,img);
 //Save to file
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw');
 SaveDialog1.FileName:=img.DisplayName+'.raw';
 if SaveDialog1.Execute then begin
  dstfName:=SaveDialog1.FileName;
  if ExtractFileExt(dstfName)='' then
   dstfName:=ChangeFileExt(dstfName,'.raw');
  WriteMemToFile(dstfName,data);
 end;
end;

function TfmMain.GetImageByDisplayIndex(idx:integer;Replaced:boolean=false): TfwImg;
var
 i:integer;
begin
 i:=GetImageTableByDisplayIndex(idx);
 if Replaced then
  Result:=imReplTables[i].Images[GetIndexInTables(i,imReplTables,idx)]
 else
  Result:=imTables[i].Images[GetIndexInTables(i,imTables,idx)]
end;

function TfmMain.GetImageTableByDisplayIndex(idx: integer): integer;
var
 s:string;
begin
 s:=lbImages.Items[idx];
 Result:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
end;

procedure TfmMain.cbShowImageTableNumberClick(Sender: TObject);
begin
 lbImages.Repaint;
end;

procedure TfmMain.tbSavePatchedImageClick(Sender: TObject);
var
 img,img2:TfwImg;
 dstfName:string;
begin
 //Get selected image
 img:=GetImageByDisplayIndex(lbImages.ItemIndex,true);
 img2:=GetImageByDisplayIndex(lbImages.ItemIndex,false);
 //Save to file
 SaveDialog1.Filter:=_('PNG files (*.png)|*.png');
 SaveDialog1.FileName:=img2.DisplayName+'.png';
 if SaveDialog1.Execute then begin
  dstfName:=SaveDialog1.FileName;
  if ExtractFileExt(dstfName)='' then
   dstfName:=ChangeFileExt(dstfName,'.png');
  img.Image.SaveToFile(dstfName);
 end;
end;

procedure TfmMain.UpdateFreeBlocks;
var
 FreeBlocks:TFreeBlocks;
 MaxBlock,MinBlock,TotalBlocks,TotalSpace:integer;
 i,z:integer;
 s:string;
begin
 s:='';
 if lsImages.Count<1 then begin
  lbFreeBlocks.Caption:='';
  Exit;
 end;
 for z:=0 to Length(imReplTables)-1 do begin
  //Get free blocks
  FreeBlocks:=nil;
  FreeBlocks:=GetFreeBlocks(imTables[z],imReplTables[z]);
  //Calc some stats
  MaxBlock:=-1;
  MinBlock:=MaxInt;
  TotalSpace:=0;
  TotalBlocks:=Length(FreeBlocks);
  for i:=0 to TotalBlocks-1 do begin
   if FreeBlocks[i].Length>MaxBlock then MaxBlock:=FreeBlocks[i].Length;
   if FreeBlocks[i].Length<MinBlock then MinBlock:=FreeBlocks[i].Length;
   TotalSpace:=TotalSpace+FreeBlocks[i].Length;
  end;
  if MinBlock=MaxInt then MinBlock:=MaxBlock;
  if MaxBlock=-1 then begin
   MaxBlock:=0; MinBlock:=0;
  end;
  s:=s+#13+Format(_('Image table %d: %d free blocks, max block: %d, min block: %d, total free space: %d'),[z+1,TotalBlocks,MaxBlock,MinBlock,TotalSpace]);
 end;
 //Show result on label
 lbFreeBlocks.Caption:=Copy(s,2,Length(s));
end;

procedure TfmMain.btSaveNewRAWClick(Sender: TObject);
var
 img,img2:TfwImg;
 dstfName:TFileName;
begin
 //Get selected image
 img:=GetImageByDisplayIndex(lbImages.ItemIndex,true);
 //Get selected image table
 img2:=GetImageByDisplayIndex(lbImages.ItemIndex,false);
 //Save to file
 SaveDialog1.Filter:=_('RAW files (*.raw)|*.raw');
 SaveDialog1.FileName:=img2.DisplayName+'.raw';
 if SaveDialog1.Execute then begin
  dstfName:=SaveDialog1.FileName;
  if ExtractFileExt(dstfName)='' then
   dstfName:=ChangeFileExt(dstfName,'.raw');
  WriteMemToFile(dstfName,img.RAWData);
 end;
end;

procedure TfmMain.ErrorMsg(const Msg, Capt: WideString);
begin
 MessageBoxW(Application.Handle,PWideChar(Msg),PWideChar(Capt),MB_OK or MB_ICONERROR or MB_TASKMODAL);
end;

function CheckSupported(fName:TFileName):boolean;
var
 img:TSingleImage;
begin
 Result:=true;
 try
  img:=TSingleImage.CreateFromFile(fName);
  img.Free;
 except
  Result:=false;
 end;
end;

procedure TfmMain.WMDropFiles(var Msg: TWMDropFiles);
const
 maxlen = 254;
var
 h: THandle;
 num,PlPos:integer;
 pchr: array[0..maxlen] of char;
 fname: string;
 CurPos:TPoint;
begin
 GetCursorPos(CurPos);
 CurPos:=lbImages.ScreenToClient(CurPos);
 h:=Msg.Drop;
 num:=DragQueryFile(h,Dword(-1),nil,0);
 if num<1 then begin
  DragFinish(h);
  Exit;
 end;
 DragQueryFile(h,0,pchr,maxlen);
 fname:=pchr;
 if CheckSupported(fname) then begin
  PlPos:=lbImages.ItemAtPos(CurPos,false);
  if PlPos<0 then PlPos:=lbImages.ItemIndex;
  DoReplaceImage(fname,PlPos);
 end;
 DragFinish(h);
end;

procedure TfmMain.DoReplaceImage(fName: TFileName;Index:integer);
var
 s:string;
 idx:integer;
 fwimg:TfwImg;
 img:TSingleImage;
 Buf,BufPNG,BufPKI,BufRLE,BufNotRLE,BufBMP:TmByteArray;
 z,i:integer;
 ColorsArray:TColorArray;
 TranspArray:TmByteArray;
begin

 //Disable form
 DisableForm;

 //Calc image table index
 s:=lbImages.Items[Index];
 idx:=StrToIntDef(Copy(s,0,Pos(#1,s)-1),-1);
 s:=IntToStr(idx+1)+'_'+Copy(s,Pos(#1,s)+1,Length(s));
 if idx<0 then Exit;

 //Get image from array
 fwimg:=imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index)];

 //Load image from disk
 img:=LoadImageFromDisk(fName,true);

 //Now we need to encode image
 //For different platforms different formats should be used

 if platform_version=db2010 then begin
  //Count used colors
  GetUsedColors(img,ColorsArray,TranspArray);
  if Length(ColorsArray)>256 then begin
   MessageBoxW(Application.Handle,PWideChar(_('Warning! Image has more than 256 colors and will be saved as uncompressed BMP!')),PWideChar(_('Warning!')),MB_OK or MB_ICONWARNING or MB_TASKMODAL);
  end;
  //Get image as RLE
  try
   BufNotRLE:=GetImageDataAsNotRLE(img,@SetProgress);
  except
   SetLength(BufNotRLE,0);
  end;
  //Get image as not RLE
  try
   BufRLE:=GetImageDataAsRLE(img,@SetProgress);
  except
   SetLength(BufRLE,0);
  end;
  //Select the smallest, but preffer not RLE
  if (Length(BufRLE)<Length(BufNotRLE)) and (Length(BufRLE)<>0) then begin
   Buf:=BufRLE;
  end else begin
   if Length(BufNotRLE)<>0 then Buf:=BufNotRLE else Buf:=BufRLE;
  end;
  //Set image type
  fwimg.imType:=imColor;
  if (Length(TranspArray)=0) or ((Length(TranspArray)=1) and (TranspArray[0]=$FF)) then begin
   //Get image as BMP only if it is not transparent
   BufBMP:=GetImageDataAsBMP(img,@SetProgress);
   if (Length(Buf)<Length(BufBMP)) and (Length(Buf)<>0) then begin
   end else begin
    Buf:=BufBMP;
    //Set image type
    fwimg.imType:=imBMP;
   end;
  end;
  if Length(Buf)=0 then begin
   ErrorMsg(_('Error compressing image!'),_('Error!'));
   EnableForm;
   Exit;
  end;
  //Swap colors to display image
  img.SwapChannels(ChannelRed,ChannelBlue);
 end else begin
  //Get image as PNG and as PKI in two ByteArrays
  BufPNG:=GetImageDataAsPNG(img,@SetProgress);
  //Swap channels for PKI
  img.SwapChannels(ChannelRed,ChannelBlue);
  BufPKI:=GetImageDataAsPKI(img,@SetProgress);

  //Select the smallest, but preffer PKI
  if Length(BufPNG)<Length(BufPKI) then begin
   Buf:=BufPNG;
   fwimg.imType:=imPNG;
  end else begin
   Buf:=BufPKI;
   fwimg.imType:=imPKI;
  end;
 end;

 //Now replace the image
 fwimg.im_width:=img.Width;
 fwimg.im_height:=img.Height;
 SetRAWData(fwimg,Buf,imReplTables[idx].picbase);
 fwimg.replaced:=true;
 fwimg.deleted:=false;
 fwimg.Image:=img;
 imReplTables[idx].Images[GetIndexInTables(idx,imReplTables,Index)]:=fwimg;

 //Search if there images with the same address, and replace them too
 for z:=0 to Length(imTables)-1 do begin
  for i:=0 to Length(imTables[z].Images)-1 do begin
   if imTables[z].Images[i].name<>fwimg.name then begin
    if imTables[z].picbase+imTables[z].Images[i].orig_offset=imTables[idx].picbase+fwimg.orig_offset then begin
     imReplTables[z].Images[i]:=imTables[z].Images[i];
     with imReplTables[z].Images[i] do begin
      imType:=fwimg.imType;
      StartOffset:=fwimg.StartOffset;
      Space:=fwimg.Space;
      Used:=fwimg.Used;
      Image:=fwimg.Image;
      RAWData:=fwimg.RAWData;
      deleted:=fwimg.deleted;
      replaced:=fwimg.replaced;
      im_width:=fwimg.im_width;
      im_height:=fwimg.im_height;
     end;
    end;
   end;
  end;
 end;

 //Update free blocks label
 UpdateFreeBlocks;

 //Set dirty flag
 SetDirty();

 //Enable form
 EnableForm;
end;

procedure TfmMain.btRestoreGraphicsVKPClick(Sender: TObject);
var
 z,i:Integer;
 lastImgOffset,lastImgIndex:Integer;
 percent,old_pos,len:Integer;
 //vkp
 c,cnt:Integer;
 tmpResSrc,tmpStr:string;
 bSrc:byte;
 curAddr:Integer;
 vkp:TStringList;
 fVkp:System.text;
begin
 if Length(imTables)<1 then Exit;
 DisableForm;
 sbStatus.Panels[0].Text:=_('Generating patch...');
 Application.ProcessMessages;
 toLog('-------------- Generating restore patch --------------');
 vkp:=TStringList.Create;
 for z:=0 to Length(imTables)-1 do begin
  toLog('Table start: '+IntToHex(imTables[z].tableStart,8));
  lastImgOffset:=imTables[z].Images[0].orig_offset;
  lastImgIndex:=0;
  len:=Length(imTables[z].Images)-1;
  old_pos:=0;
  for i:=1 to len do begin
   percent:=Round((i*100)/len);
   if percent<>old_pos then begin
    old_pos:=percent;
    pbProgress.Position:=percent;
    Application.ProcessMessages;
   end;
   if lastImgOffset<(imTables[z].Images[i].orig_offset) then begin
    lastImgOffset:=imTables[z].Images[i].orig_offset;
    lastImgIndex:=i;
   end;
  end;
  GetImgFromArray(FData,imTables[z],lastImgIndex);
  lastImgOffset:=lastImgOffset+imTables[z].Images[lastImgIndex].Space+imTables[z].picbase;
  meLog.Lines.Add('Last image end: '+IntToHex(lastImgOffset,8));
  //Generate VKP
  vkp.Add('; Image table '+IntToStr(z));
  pbProgress.Max:=100;
  pbProgress.Position:=0;
  old_pos:=0;
  curAddr:=imTables[z].tableStart;
  c:=0;
  tmpResSrc:=IntToHex(imTables[z].tableStart,1);
  cnt:=StrToInt('$'+Copy(tmpResSrc,Length(tmpResSrc),1));
  tmpResSrc:='';
  for i:=imTables[z].tableStart to lastImgOffset do begin
   bSrc:=GetByte(FData,i);
   c:=c+1;
   cnt:=cnt+1;
   tmpResSrc:=tmpResSrc+IntToHex(bSrc,2);
   if cnt>15 then begin
    vkp.Add(IntToHex(curAddr-c+1,8)+': '+tmpResSrc+' '+tmpResSrc);
    c:=0;
    cnt:=0;
    tmpResSrc:='';
   end;
   curAddr:=curAddr+1;
   percent:=Round((i/(lastImgOffset-imTables[z].tableStart))*100);
   if old_pos<>percent then begin
    pbProgress.Position:=percent;
    old_pos:=percent;
    Application.ProcessMessages;
   end;
  end;
  if Length(tmpResSrc)>0 then begin
   vkp.Add(IntToHex(curAddr-c,8)+': '+tmpResSrc+' '+tmpResSrc);
   tmpResSrc:='';
  end;
  pbProgress.Position:=100;
 end;
 tmpStr:=ExtractFileName(fwFileName);
 if Pos('_MAIN',tmpStr)<1 then begin
  if not InputQuery(_('Enter version'),_('Unable to guess firmware version'+#10#13+'Please enter it'),tmpStr) then Exit;
 end else begin
  tmpStr:=Copy(tmpStr,0,Pos('_MAIN',tmpStr)-1);
 end;
 SaveDialog1.Filter:=_('VKP files (*.vkp)|*.vkp');
 SaveDialog1.FileName:='restore_'+tmpStr;
 SaveDialog1.InitialDir:=PathPatch;
 if not SaveDialog1.Execute then begin
  EnableForm;
  Exit;
 end;
 PathPatch:=ExtractFilePath(SaveDialog1.FileName);
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
 WriteLn(fVkp,';(!) '+tmpStr);
 //Write subHeader
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,';(i) заміна системної графіки телефонів Sony Ericsson');
 WriteLn(fVkp,';(i) автоматично зґенерований програмою');
 WriteLn(fVkp,';(i) SE Image Tool '+swversion);
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,';(i) replace system graphics of Sony Ericsson phones');
 WriteLn(fVkp,';(i) automatically generated by');
 WriteLn(fVkp,';(i) SE Image Tool '+swversion);
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,';(i) замена системной графики телефонов Sony Ericsson');
 WriteLn(fVkp,';(i) автоматически сгенерирован программой');
 WriteLn(fVkp,';(i) SE Image Tool '+swversion);
 WriteLn(fVkp,';(i) ------------------------------------------------');
 WriteLn(fVkp,'+'+IntToHex(imgbase,8));
 //--------------------------
 sbStatus.Panels[0].Text:=_('Saving...');
 Application.ProcessMessages;
 len:=vkp.Count-1;
 old_pos:=0;
 for i:=0 to len do begin
  WriteLn(fVkp,vkp[i]);
  percent:=Round((i/(len))*100);
  if old_pos<>percent then begin
   pbProgress.Position:=percent;
   old_pos:=percent;
   Application.ProcessMessages;
  end;
 end;
 CloseFile(fVkp);
 vkp.Free;
 EnableForm;
end;

procedure TfmMain.JvFormStorage1SavePlacement(Sender: TObject);
begin
 with JvFormStorage1 do begin
  WriteString('PathFw',PathFw);
  WriteString('PathImage',PathImage);
  WriteString('PathPatch',PathPatch);
 end;
end;

procedure TfmMain.JvFormStorage1RestorePlacement(Sender: TObject);
begin
 with JvFormStorage1 do begin
  PathFw:=ReadString('PathFw');
  PathImage:=ReadString('PathImage');
  PathPatch:=ReadString('PathPatch');
 end;
end;

procedure TfmMain.SetDirty(flag: boolean);
begin
 if flag then
  fmMain.Tag:=1
 else
  fmMain.Tag:=0;
 if fmMain.Tag=1 then
  fmMain.Caption:=fmCaption+' v'+swversion+' *'
 else
  fmMain.Caption:=fmCaption+' v'+swversion;
end;

function TfmMain.IsDirty: boolean;
begin
 Result:=(fmMain.Tag<>0);
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 //Check dirty flag
 CanClose:=true;
 if IsDirty then begin
  if MessageBox(Application.Handle, PChar(AnsiString(_('There are unsaved changes. Discard them?'))), PChar(AnsiString(_('Discard changes?'))), MB_ICONQUESTION or MB_YESNO or MB_TASKMODAL)=IDNO then begin
   CanClose:=false;
  end;
 end;
end;

procedure TfmMain.edImgBaseChange(Sender: TObject);
begin
 imgbase:=StrToInt('$'+Copy(Trim(edImgBase.Text),2,MaxInt));
end;

function CheckIfOffsetIsPIT(var c_offset:integer):boolean;
var
 tbl_adress:DWORD;
 imt:TImgTable;
 pit:array of DWORD;
 f_imTables:TImgTables;
 i,j:integer;
 st_offset:integer;
 img:TSingleImage;
begin
 Result:=true;
 st_offset:=c_offset;
 //Now check if offset if PIT
 SetLength(pit,0);
 SetLength(f_imTables,0);
 //Read PIT and check if offsets are links to image tables
 while true do begin
  SetLength(pit,Length(pit)+1);
  SetLength(f_imTables,Length(f_imTables)+1);
  tbl_adress:=GetDWORD(FData,c_offset);
  if tbl_adress=6 then begin
   //End of PIT
   break;
  end;
  if tbl_adress<imgbase then begin
   if Length(pit)=0 then begin
    Result:=false;
    Exit;
   end else break;
  end;
  pit[Length(pit)-1]:=tbl_adress-imgbase;
  try
   {$R+}
   imt:=ReadImgTable(nil,'',FData,pit[Length(pit)-1]);
   {$R-}
   if imt.pheader=0 then begin
    Result:=false;
    Exit;
   end;
  except
   Result:=false;
   Exit;
  end;
  f_imTables[Length(f_imTables)-1]:=imt;
  inc(c_offset,4);
  if not ((GetDWORD(FData,c_offset)=0) and (GetDWORD(FData,c_offset)=0)) then break;
  inc(c_offset,8);
  //Assume PIT should be less than 50 items
  if Length(pit)>20 then begin
   Result:=false;
   Exit;
  end;
 end;
 //If last imt is empty, delete it
 if Length(pit)>0 then begin
  if Length(f_imTables[Length(f_imTables)-1].Images)=0 then begin
   SetLength(pit,Length(pit)-1);
   SetLength(f_imTables,Length(f_imTables)-1);
  end;
 end;
 if Length(pit)=0 then begin
  Result:=false;
  Exit;
 end;
 //Validate image tables
 for i:=0 to Length(f_imTables)-1 do begin
  imt:=f_imTables[i];
  if Length(imt.Images)<10 then begin
   Result:=false;
   Exit;
  end;
 end;
 //Assume there should not be db2010 images on newer platforms
 if platform_version<>db2010 then begin
  for i:=0 to Length(f_imTables)-1 do begin
   imt:=f_imTables[i];
   for j:=0 to Length(imt.Images)-1 do begin
    if imt.Images[j].imType=imColor then begin
     Result:=false;
     Exit;
    end;
   end;
  end;
 end;
 for i:=0 to Length(f_imTables)-1 do begin
  imt:=f_imTables[i];
  for j:=0 to Length(imt.Images)-1 do begin
   if imt.Images[j].imType=imColor then begin
    try
     img:=GetImgFromArray(FData,imt,j);
     img.Free;
    except
     Result:=false;
     Exit;
    end;
   end;
  end;
 end;
 //Show imtables found
 fmMain.meLog.Lines.Add(Format('PIT found at %s',[IntToHex(st_offset,8)]));
 for i:=0 to Length(f_imTables)-1 do begin
  fmMain.meLog.Lines.Add(Format('table start: %s; '+
                        'pheader: %s; '+
                        'images count: %s; '+
                        'offset: %s; '+
                        'picbase: %s; '+
                        'names start: %s; '+
                        'offset table: %s; '+
                        'table size: %s; ',
                  [IntToHex(f_imTables[i].tableStart,8),
                  IntToHex(f_imTables[i].pheader,8),
                  IntToStr(f_imTables[i].numIcons),
                  IntToHex(f_imTables[i].offset,8),
                  IntToHex(f_imTables[i].picbase,8),
                  IntToHex(f_imTables[i].names,8),
                  IntToHex(f_imTables[i].offsettable,8),
                  IntToHex(f_imTables[i].table_size,8)]));
 end;
end;

procedure TfmMain.ToolButton1Click(Sender: TObject);
var
 Finded:boolean;
 c_offset,percent,old_percent:integer;
 prProc:TProgressProc;
begin
 DisableForm;
 fmMain.meLog.Lines.Add('-------------------------------');

 prProc:=@SetProgress;
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
   if CheckIfOffsetIsPIT(c_offset) then
     fmMain.meLog.Lines.Add('-------------------------------');
  end else begin
  end;
  c_offset:=c_offset+1;
 end;
 prProc(_('Searching for PIT...'),100);
 EnableForm;
end;

procedure TfmMain.lbImagesKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then Key:=#0;
end;

end.
