unit uEditIMT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, ValEdit, StdCtrls, Buttons, sBitBtn, sPanel,
  sSkinProvider, pngimage;

type
  TfmEditIMT = class(TForm)
    veTable: TValueListEditor;
    imPreview: TImage;
    sPanel1: TsPanel;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sSkinProvider1: TsSkinProvider;
    procedure FormShow(Sender: TObject);
    procedure veTableDrawCell(Sender: TObject; ACol, cRow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEditIMT: TfmEditIMT;

implementation

{$R *.dfm}

uses uMain;

procedure TfmEditIMT.FormShow(Sender: TObject);
var
 i:integer;
begin
 if Length(imArrayRepl)<1 then begin
  SetLength(imArrayRepl,numIcons);
  for i:=0 to Length(imArray)-1 do begin
   imArrayRepl[i]:=imArray[i];
  end;
 end;
 for i:=0 to Length(imArray)-1 do begin
  veTable.InsertRow(imArrayRepl[i].name,IntToHex(imArrayRepl[i].StartOffset,6),true);
 end;
end;

procedure TfmEditIMT.veTableDrawCell(Sender: TObject; ACol, cRow: Integer;
  Rect: TRect; State: TGridDrawState);
var
 R:TRect;
 OldFontColor:TColor;
 Str:string;
 img:TPNGObject;
 aspRatio:real;
 tmpInt:integer;
 ARow:integer;
begin
 if ACol<>0 then Exit;
 if cRow<1 then Exit;
 ARow:=cRow-1;
 veTable.Canvas.Font.Color:=veTable.Font.Color;
 with veTable.Canvas do begin
  OldFontColor:=Font.Color;
  if gdSelected in State then begin
   Brush.Color:=fmMain.sSkinManager1.GetHighLightColor;
   Font.Color:=fmMain.sSkinManager1.GetHighLightFontColor;
   if ARow=veTable.Row then begin
    Font.Color:=clYellow;
    Font.Style:=[];
    if Length(imArrayRepl)>0 then begin
     if imArrayRepl[ARow].Replaced then begin
      Font.Color:=clBlue;
      Font.Style:=[fsBold];
     end;
     if imArrayRepl[ARow].empty then begin
      Font.Color:=clRed;
      Font.Style:=[fsBold];
     end;
    end;
   end;
  end else begin
   Brush.Color:=veTable.Color;
   if Length(imArrayRepl)>0 then begin
    if imArrayRepl[ARow].Replaced then
     Brush.Color:=clYellow;
    if imArrayRepl[ARow].empty then
     Brush.Color:=clSilver;
   end;
  end;
  FillRect(Rect);
  Str:=veTable.Cells[ACol,cRow]+' (';
  if imArray[ARow].imType=imPKI then
   Str:=Str+'PKI)'
  else if imArray[ARow].imType=imPNG then
   Str:=Str+'PNG)'
  else if imArray[ARow].imType=imBWI then
   Str:=Str+'BWI)'
  else
   Str:=Str+'UNK)';
  R:=Rect;
  R.Right:=R.Left+veTable.RowHeights[ARow];
  img:=GetImgFromArray(FData,imArray,ARow);
  if img.Height<>0 then
   aspRatio:=img.Width/img.Height
  else
   Exit;
  if (aspRatio)<((R.Right-R.Left)/(R.Bottom-R.Top)) then
   R.Right:=R.Left+Round(aspRatio*(R.Right-R.Left))
  else
   R.Bottom:=R.Top+Round((R.Bottom-R.Top)/aspRatio);
  tmpInt:=(veTable.RowHeights[ARow]-(R.Bottom-R.Top)) div 2;
  R.Bottom:=R.Bottom+tmpInt;
  R.Top:=R.Top+tmpInt;
  img.Draw(veTable.Canvas,R);
  R:=Rect;
  R.Left:=R.Left+veTable.RowHeights[ARow]+3;
  DrawText(Handle,PAnsiChar(Str),Length(Str),R,DT_SINGLELINE or DT_END_ELLIPSIS or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
  Font.Color:=OldFontColor;
 end;
end;

end.
