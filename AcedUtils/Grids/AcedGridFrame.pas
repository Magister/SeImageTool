
/////////////////////////////////////////////////////
//                                                 //
//   AcedGridFrame 1.03                            //
//                                                 //
//   ����� ��� ���������, ������ � �������������   //
//   ������, �������������� � ���� �������.        //
//                                                 //
//   mailto: acedutils@yandex.ru                   //
//                                                 //
/////////////////////////////////////////////////////

unit AcedGridFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, AcedGrids, AcedConsts;

{ ����� TGridFrame ���������� ������ � ���� ������� �� ���������� �������
  � ������������ ������ � ���� ������� ��������, �������� �������������
  � ����������. ����� � �������� ����� ������������� �� ������ ����, �� �������
  ���� ��� �� ������. ���� ����� �� ���������� � ������, �� ����� ������������
  �� ������, � ������ ������������ �� ������ ���, ����� �� ���������� ����
  ����� ���������. ����� � ������ ������ ����� ���������� ����� ������,
  ������� ������� �� ��������� ������ ������ (�������, ����������, ����������
  ����������). ��� �������� ������������� ���� �����. �����, ����������
  ������������� ���������� � ���� ����, ������������ �� ������ �� �������
  �������. ���� ������ ������ ���������� � ������� '*', ������ ����� ���������
  ��������� ����� ��������� � ������� �������. ���� ���� ������ �����������,
  ������ ������, ����� � ������� ���������� � ��������� ������. ����� �����
  ���������� ������ ���������� �� �����, ���� ������ Ctrl+L. }

type
  TGFDrawGrid = class(TDrawGrid)
  protected
    procedure ColWidthsChanged; override;
  end;

  TGridFrame = class(TFrame)
    DesignRect: TShape;
  private
    FItemList: PStringItemList;
    FRowCount: Integer;
    FColumnInfo: PGridColumnList;
    FColumnCount: Integer;
    FTimerWnd: HWND;
    FDelayedSelectPause: Cardinal;
    FDelayedRowIndex: Integer;
    FHintHidePause: Cardinal;
    FOnGetData: TGridGetDataEvent;
    FOnGetColor: TGridCellGetColorEvent;
    FOnSelectItem: TGridFrameEvent;
    FOnDelayedSelectItem: TGridFrameEvent;
    FOnDoubleClick: TGridFrameEvent;
    FOnKeyDown: TGridKeyDownEvent;
    FOnEnterFrame: TGridEnterExitEvent;
    FOnExitFrame: TGridEnterExitEvent;
    FMDRowIndex: Integer;
    FSearchInProgress: Boolean;
    FInfoApp: Boolean;
    FTimerWork: Boolean;
    FInactiveSelection: Boolean;
    FSearchByColumns: Boolean;
    FTitleMultiline: Boolean;
    FMultiline: Boolean;

    procedure dgInfoDrawCell(Sender: TObject; AColumn, ARow: Integer; Rect: TRect; AState: TGridDrawState);
    procedure dgInfoSelectCell(Sender: TObject; AColumn, ARow: Integer; var CanSelect: Boolean);
    procedure dgInfoDblClick(Sender: TObject);
    procedure dgInfoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dgInfoKeyPress(Sender: TObject; var Key: Char);
    procedure dgInfoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure dgInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dgInfoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edSearchEnter(Sender: TObject);
    procedure edSearchChange(Sender: TObject);

    function GetColumnInfo(ColumnIndex: Integer): PGridColumnInfo;
    procedure SetRowCount(Value: Integer);
    function GetCells(RowIndex, ColumnIndex: Integer): string;
    procedure SetCells(RowIndex, ColumnIndex: Integer; const Value: string);
    procedure WriteTitle(var Rect: TRect; AColumn: Integer);
    procedure WriteValue(var Rect: TRect; AColumn: Integer; const S: string);
    function GetCellSelect: Boolean;
    procedure SetCellSelect(Value: Boolean);
    function GetGridVisible: Boolean;
    procedure SetGridVisible(Value: Boolean);
    function GetEntitled: Boolean;
    procedure SetEntitled(APresent: Boolean);
    procedure SearchNext;
    procedure UpdateTitleHeight;
    procedure UpdateRowHeights;
    procedure SetDelayedSelectPause(Value: Cardinal);
    procedure TimerWndProc(var AMsg: TMessage);
    procedure ResetDelayedSelection(TestIndex: Integer);
    procedure ProcessColumnResize;

  protected
    procedure DoEnter; override;
    procedure DoExit; override;
    
  public

    DataGrid: TGFDrawGrid;
    SearchEdit: TEdit;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  { Init ������������ ������ ��� AColumnCount ��������. }

    procedure Init(AColumnCount: Integer);

  { ApplyFormats ������������� ����������� ������ �������� �� ������ ��������
    ����� �������� ColumnInfo. ������ ��� ��������� ���������� � ����� ��������
    �������������. }

    procedure ApplyFormats;

  { Activate ������������ ��� ���������� ����������� �����. �� ����� ������
    ���������� ���������������� ���������, ������� ��������� ������� ����������
    ������ ������. ������ ����������� � ���, ��� ������ ���� �������� �
    ���������� ����������� �����. }

    procedure Activate;

  { Deactivate ������� ������ ������ � ������� ��� ������ �� ������. }

    procedure Deactivate;

  { SetFocus ������������� ����� ����� �� ������ �����. }

    procedure SetFocus; override;

  { IsFocused ���������� True, ���� ����� ������� ������� �����. }

    function Focused: Boolean; override;

  { SelectRow �������� ������ � �������� Index (��������� � ����). ����
    �������� Immediate ����� True � ������������ ��������� ��������� ���������
    � ���������, �� ��������������� ��������� ���������� �����, ��� ������
    ��������. }

    procedure SelectRow(Index: Integer; Immediate: Boolean = False);

  { GetSelectedRowIndex ���������� ������ ���������� ������ (��� -1). }

    function GetSelectedRowIndex: Integer;

  { GetSelectedColumnIndex ���������� ������ ����������� ������� (��� -1). }

    function GetSelectedColumnIndex: Integer;

  { SetSearchText �������� ���������� ���� ����� �� ������ S. ���� BeginSearch
    ����� False, �� ����� ��� ���� �� �����������. }

    procedure SetSearchText(const S: string; BeginSearch: Boolean = True);

  { ����� ����� � ������� (��� ����� �����). �������� ����� �������� ������
    ������������� � ������, ����������� �������� OnGetData. }

    property RowCount: Integer read FRowCount write SetRowCount;

  { ����� �������� � �������. }

    property ColumnCount: Integer read FColumnCount;

  { ���������� � ��������. }

    property ColumnInfo[ColumnIndex: Integer]: PGridColumnInfo read GetColumnInfo;

  { �����, ��������� � ������� �����. }

    property Cells[RowIndex, ColumnIndex: Integer]: string read GetCells write SetCells;

  { ��������, ����������� �������� ���������� � ������, ��������� � �������
    �����. ��� ������������� ����� �������� �������� �� ������������ �������
    �������� ������� �� �����������. }

    property ItemList: PStringItemList read FItemList;

  { ���� True (�� ���������), �� ��������� ������ ��������� �� ������ ����,
    ����� ����� �� �������� �������� ���������. }

    property InactiveSelection: Boolean read FInactiveSelection write FInactiveSelection;

  { ���� True, �� ��� ������ ���������� ������, � �� ������ (goRewSelect) }

    property CellSelect: boolean read GetCellSelect write SetCellSelect;

  { ���� False, �� ���� ����� �� ���������������. }

    property GridVisible: Boolean read GetGridVisible write SetGridVisible;

  { ���� False, �� ��������� �������� �� ��������� � ������ ������. }

    property Entitled: Boolean read GetEntitled write SetEntitled;

  { ���� False, �� ����� ������������ �� �������, � �� �� ��������. }

    property SearchByColumns: Boolean read FSearchByColumns write FSearchByColumns;

  { ���� True, �� ������ � ����������� �������� ������������ �� ������ � �����
    � ��� ����������� �� ������, ����� ��� ���������� ���� ����� ���������. }

    property TitleMultiline: Boolean read FTitleMultiline write FTitleMultiline;

  { ���� True, �� ������ ������������ �� ������ � ����� � ��� ����������� ��
    ������ ���, ����� ��� ���������� ����� ���� ����� ���������. }

    property Multiline: Boolean read FMultiline write FMultiline;

  { ���� �������� ����� �������� ������� �� ����, �� ����� ����� ����������
    ����������� ����� ��������� ������ ����� ������� ���������, �����������
    �������� OnDelayedSelectItem. ��� ����������, ���� � ������� ����� �������
    ��������� �� ����� ���������� �� ������ ������. }

    property DelayedSelectPause: Cardinal read FDelayedSelectPause write SetDelayedSelectPause;

  { ��������, ������������, �� ������� ����������� ��������� ��������� ���
    ��� �����, ���������� ������� ����� �� ��������� (�� ��������� 10000). }

    property HintHidePause: Cardinal read FHintHidePause write FHintHidePause;

  { �������, ����������� ����� � ������� (������ ���� ��������� �� ������
    ��������� ApplyFormats). }

    property OnGetData: TGridGetDataEvent read FOnGetData write FOnGetData;

  { �������, ������������ ���� ������ � ������� (����� �� ���������). }

    property OnGetColor: TGridCellGetColorEvent read FOnGetColor write FOnGetColor;

  { ���������, ���������� ��� ������ (���������) ����� ������. }

    property OnSelectItem: TGridFrameEvent read FOnSelectItem write FOnSelectItem;

  { ���� ������������ �������� ��� ��������� ������ (�������� DelayedSelectPause
    ������� �� ����), �� ���������, ����������� ������� �������� ����������,
    ����� �������� �������� ���������� ������� � � ������� ����� ������� ������
    ������ �� ���� ��������. }

    property OnDelayedSelectItem: TGridFrameEvent read FOnDelayedSelectItem write FOnDelayedSelectItem;

  { ���������, ���������� ��� ������� ������ ����� �� ������. }

    property OnDoubleClick: TGridFrameEvent read FOnDoubleClick write FOnDoubleClick;

  { ���������, ���������� ��� ������� �������. }

    property OnKeyDown: TGridKeyDownEvent read FOnKeyDown write FOnKeyDown;

  { ���������, ���������� ��� ����������� ������ ����� �� �����. }

    property OnEnterFrame: TGridEnterExitEvent read FOnEnterFrame write FOnEnterFrame;

  { ���������, ���������� ����� ������� ������� ������ �����. }

    property OnExitFrame: TGridEnterExitEvent read FOnExitFrame write FOnExitFrame;
  end;

implementation

uses AcedBinary, AcedStrings;

{$R *.DFM}

{ TGFDrawGrid }

procedure TGFDrawGrid.ColWidthsChanged;
begin
  inherited;
  TGridFrame(Parent).ProcessColumnResize;
end;

{ TGridFrame }

constructor TGridFrame.Create(AOwner: TComponent);
begin
  inherited;
  DesignRect.Pen.Style := psClear;
  SearchEdit := TEdit.Create(Self.Owner);
  with SearchEdit do
  begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := Self.Width;
    Height := 19;
    TabStop := False;
    Anchors := [akLeft, akTop, akRight];
    AutoSelect := False;
    AutoSize := False;
    Color := clBtnFace;
    TabOrder := 0;
    OnChange := edSearchChange;
    OnEnter := edSearchEnter;
  end;
  DataGrid := TGFDrawGrid.Create(Self.Owner);
  with DataGrid do
  begin
    Parent := Self;
    Left := 0;
    Top := 20;
    Width := Self.Width;
    Height := Self.Height - 20;
    Anchors := [akLeft, akTop, akRight, akBottom];
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -13;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    DefaultRowHeight := 19;
    DefaultDrawing := False;
    FixedCols := 0;
    RowCount := 2;
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine,
      goHorzLine, goColSizing, goRowSelect, goThumbTracking];
    ParentShowHint := False;
    ShowHint := True;
    TabOrder := 1;
    OnSelectCell := dgInfoSelectCell;
    OnDblClick := dgInfoDblClick;
    OnDrawCell := dgInfoDrawCell;
    OnKeyDown := dgInfoKeyDown;
    OnKeyPress := dgInfoKeyPress;
    OnMouseMove := dgInfoMouseMove;
    OnMouseDown := dgInfoMouseDown;
    OnMouseUp := dgInfoMouseUp;
  end;
  FSearchByColumns := True;
  FInactiveSelection := True;
  FHintHidePause := 10000;
  FTimerWnd := Classes.AllocateHWnd(TimerWndProc);
  FMDRowIndex := -1;
end;

destructor TGridFrame.Destroy;
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  if FColumnInfo <> nil then
  begin
    if FRowCount > 0 then
    begin
      Finalize(FItemList^[0], FRowCount * FColumnCount);
      FreeMem(FItemList);
    end;
    Finalize(FColumnInfo^[0], FColumnCount);
    FreeMem(FColumnInfo);
  end;
  Classes.DeallocateHWnd(FTimerWnd);
  inherited;
end;

procedure TGridFrame.Init(AColumnCount: Integer);
var
  I: Integer;
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  if (AColumnCount < 1) or (AColumnCount > MaxLastGridColumn + 1) then
    RaiseError(SErrWrongNumberOfGridColumns);
  if FColumnInfo <> nil then
  begin
    if FRowCount > 0 then
      SetRowCount(-1);
    Finalize(FColumnInfo^[0], FColumnCount);
    FInfoApp := False;
    FreeMem(FColumnInfo);
  end;
  FColumnInfo := G_AllocMem(AColumnCount * SizeOf(TGridColumnInfo));
  FColumnCount := AColumnCount;
  DataGrid.ColCount := AColumnCount;
  DataGrid.FixedRows := 1;
  for I := FColumnCount - 1 downto 0 do
    with FColumnInfo^[I] do
    begin
      LeftIndent := 2;
      RightIndent := 3;
      TitleAlignment := taCenter;
      Searched := True;
    end;
end;

procedure TGridFrame.ApplyFormats;
var
  I: Integer;
begin
  if FColumnInfo = nil then
    RaiseError(SErrFrameNotInitialized);
  if not Assigned(FOnGetData) then
    RaiseError(SErrOnGetDataNotAssigned);
  if (FDelayedSelectPause<>0) and not Assigned(FOnDelayedSelectItem) then
    RaiseError(SErrOnDelayedSelectItemNotAssigned);
  for I := FColumnCount - 1 downto 0 do
    DataGrid.ColWidths[I] := FColumnInfo^[I].Width;
  FInfoApp := True;
end;

procedure TGridFrame.Activate;
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  FOnGetData(Self);
  if (DataGrid.FixedRows > 0) and FTitleMultiline then
    UpdateTitleHeight;
  if FMultiline then
    UpdateRowHeights;
  DataGrid.Invalidate;
  if Assigned(FOnSelectItem) then
    FOnSelectItem(Self, GetSelectedRowIndex);
  if FDelayedSelectPause <> 0 then
    ResetDelayedSelection(GetSelectedRowIndex);
end;

procedure TGridFrame.Deactivate;
begin
  SetSearchText('', False);
  SetRowCount(-1);
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
end;

procedure TGridFrame.dgInfoDrawCell(Sender: TObject; AColumn, ARow: Integer;
  Rect: TRect; AState: TGridDrawState);
var
  C, BC, FC: TColor;
  TempRect: TRect;
  Selected, Inactive: Boolean;
begin
  if not FInfoApp then
    Exit;
  Dec(ARow, DataGrid.FixedRows);
  if ARow >= 0 then
  begin
    if FRowCount > 0 then
    begin
      Selected := gdSelected in AState;
      Inactive := False;
      if Selected then
      begin
        if Focused then
        begin
          BC := clHighlight;
          FC := clHighlightText;
        end
        else if FInactiveSelection then
        begin
          BC := clInactiveCaption;
          FC := clHighlightText;
          Inactive := True;
        end else
        begin
          BC := clWindow;
          FC := clWindowText;
          Selected := False;
        end;
      end else
      begin
        BC := clWindow;
        FC := clWindowText;
      end;
      if Assigned(FOnGetColor) then
      begin
        C := FOnGetColor(Self, ARow, AColumn, Selected, Inactive);
        if C <> clDefault then
          FC := C;
      end;
      with DataGrid.Canvas do
      begin
        Brush.Color := BC;
        Font := DataGrid.Font;
        Font.Color := FC;
      end;
      WriteValue(Rect, AColumn, FItemList^[ARow * FColumnCount + AColumn]);
    end else
      with DataGrid.Canvas do
      begin
        Brush.Color := clWindow;
        Windows.FillRect(Handle, Rect, Brush.Handle);
      end;
  end else
  begin
    with DataGrid.Canvas do
    begin
      Brush.Color := clBtnFace;
      Font := DataGrid.Font;
      Font.Color := clBtnText;
    end;
    TempRect := Rect;
    WriteTitle(Rect, AColumn);
    with DataGrid.Canvas do
    begin
      DrawEdge(Handle, TempRect, BDR_RAISEDINNER, BF_RIGHT or BF_BOTTOM);
      DrawEdge(Handle, TempRect, BDR_RAISEDINNER, BF_LEFT or BF_TOP);
    end;
  end;
end;

procedure TGridFrame.dgInfoSelectCell(Sender: TObject; AColumn, ARow: Integer;
  var CanSelect: Boolean);
begin
  if Focused then
  begin
    SearchEdit.Font.Color := clWindowText;
    SetSearchText('*', False);
    if Assigned(FOnSelectItem) then
      if FRowCount <> 0 then
        FOnSelectItem(Self, ARow - DataGrid.FixedRows)
      else
        FOnSelectItem(Self, -1);
    if FDelayedSelectPause <> 0 then
      if FRowCount <> 0 then
        ResetDelayedSelection(ARow - DataGrid.FixedRows)
      else
        ResetDelayedSelection(-1);
  end;
end;

procedure TGridFrame.dgInfoDblClick(Sender: TObject);
begin
  if Assigned(FOnDoubleClick) then
    FOnDoubleClick(Self, GetSelectedRowIndex);
end;

procedure TGridFrame.dgInfoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Self, GetSelectedRowIndex, Key, Shift);
end;

procedure TGridFrame.dgInfoKeyPress(Sender: TObject; var Key: Char);
begin
  with SearchEdit do
    if Key >= #32 then
    begin
      Text := Text + Key;
      SelStart := Length(Text);
    end
    else if Key = #12 then
    begin
      SearchNext;
      Key := #0;
    end
    else if (Key = #8) and not G_IsEmpty(Text) then
    begin
      Text := Copy(Text, 1, Length(Text) - 1);
      SelStart := Length(Text);
    end;
end;

procedure TGridFrame.dgInfoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Column, Row, W: Integer;
  S: string;
  P: TPoint;
begin
  if not FMultiline and (Shift = []) then
  begin
    DataGrid.MouseToCell(X, Y, Column, Row);
    if (Column <> -1) and (Row >= DataGrid.FixedRows) and (Row < DataGrid.FixedRows + FRowCount) then
    begin
      S := FItemList^[(Row - DataGrid.FixedRows) * FColumnCount + Column];
      if not G_IsEmpty(S) then
      begin
        if G_SameStr(S, DataGrid.Hint) then
          Exit;
        DataGrid.Canvas.Font := DataGrid.Font;
        with FColumnInfo^[Column] do
          W := Width - LeftIndent - RightIndent;
        if DataGrid.Canvas.TextExtent(S).cx > W then
          with Application do
          begin
            CancelHint;
            DataGrid.Hint := S;
            P.X := X;
            P.Y := Y;
            HintHidePause := FHintHidePause;
            ActivateHint(P);
            Exit;
          end;
      end;
    end;
  end;
  Application.CancelHint;
end;

procedure TGridFrame.dgInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMDRowIndex := DataGrid.Row;
end;

procedure TGridFrame.dgInfoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FMDRowIndex >= 0) and (DataGrid.Selection.Top <> FMDRowIndex) then
  begin
    SelectRow(FMDRowIndex - 1);
    FMDRowIndex := -1;
  end;
end;

procedure TGridFrame.edSearchEnter(Sender: TObject);
begin
  Windows.SetFocus(DataGrid.Handle);
end;

procedure TGridFrame.edSearchChange(Sender: TObject);
var
  S: string;
  I, J, N: Integer;
  Full: Boolean;
begin
  if FSearchInProgress then
  begin
    S := SearchEdit.Text;
    SearchEdit.Font.Color := clWindowText;
    if not G_IsEmpty(S) and (S[1] = '*') then
    begin
      G_Delete(S, 1, 1);
      Full := True;
    end else
      Full := False;
    N := Length(S);
    if N = 0 then
    begin
      SelectRow(0);
      Exit;
    end;
    if FSearchByColumns then
    begin
      if Full then
      begin
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            for I := 0 to FRowCount - 1 do
              if G_PosText(S, FItemList^[I * FColumnCount + J]) <> 0 then
              begin
                SelectRow(I);
                Exit;
              end;
      end else
      begin
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            for I := 0 to FRowCount - 1 do
              if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
              begin
                SelectRow(I);
                Exit;
              end;
      end;
    end else
      if Full then
      begin
        for I := 0 to FRowCount - 1 do
          for J := 0 to FColumnCount - 1 do
            if FColumnInfo^[J].Searched then
              if G_PosText(S, FItemList^[I * FColumnCount+J]) <> 0 then
              begin
                SelectRow(I);
                Exit;
              end;
      end else
      begin
        for I := 0 to FRowCount - 1 do
          for J := 0 to FColumnCount - 1 do
            if FColumnInfo^[J].Searched then
              if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
              begin
                SelectRow(I);
                Exit;
              end;
      end;
    SearchEdit.Font.Color := clGrayText;
  end;
end;

function TGridFrame.GetColumnInfo(ColumnIndex: Integer): PGridColumnInfo;
begin
  if (FColumnInfo <> nil) and (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
    Result := @FColumnInfo^[ColumnIndex]
  else
  begin
    RaiseError(SErrWrongGridColumnIndex);
    Result := nil;
  end;
end;

procedure TGridFrame.SetRowCount(Value: Integer);
begin
  if Value <> FRowCount then
  begin
    if FRowCount > 0 then
    begin
      Finalize(FItemList^[0], FRowCount * FColumnCount);
      FreeMem(FItemList);
    end;
    if Value > 0 then
    begin
      FRowCount := Value;
      FItemList := G_AllocMem(Value * FColumnCount * SizeOf(Pointer));
      DataGrid.RowCount := DataGrid.FixedRows + Value;
    end else
    begin
      FItemList := nil;
      FRowCount := 0;
      DataGrid.RowCount := DataGrid.FixedRows + 1;
      if Assigned(FOnSelectItem) then
        FOnSelectItem(Self, -1);
      if FDelayedSelectPause <> 0 then
        ResetDelayedSelection(-1);
    end;
  end;
end;

function TGridFrame.GetCells(RowIndex, ColumnIndex: Integer): string;
begin
  if (RowIndex >= 0) and (RowIndex < FRowCount) then
  begin
    if (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
      Result := FItemList^[RowIndex * FColumnCount + ColumnIndex]
    else
      RaiseError(SErrWrongGridColumnIndex);
  end else
    RaiseError(SErrWrongGridRowIndex);
end;

procedure TGridFrame.SetCells(RowIndex, ColumnIndex: Integer; const Value: string);
begin
  if (RowIndex >= 0) and (RowIndex < FRowCount) then
  begin
    if (ColumnIndex >= 0) and (ColumnIndex < FColumnCount) then
      FItemList^[RowIndex * FColumnCount + ColumnIndex] := Value
    else
      RaiseError(SErrWrongGridColumnIndex);
  end else
    RaiseError(SErrWrongGridRowIndex);
end;

procedure TGridFrame.WriteTitle(var Rect: TRect; AColumn: Integer);
var
  DC: HDC;
begin
  with FColumnInfo^[AColumn], Rect, DataGrid.Canvas do
  begin
    Brush.Color := clBtnFace;
    Font.Color := clBtnText;
    DC := Handle;
    Windows.FillRect(DC, Rect, Brush.Handle);
    Inc(Left, LeftIndent);
    Dec(Right, RightIndent);
    Inc(Top, 2);
    if not FTitleMultiline then
      case TitleAlignment of
        taLeftJustify:
          Windows.ExtTextOut(DC, Left, Top, TextFlags or ETO_CLIPPED, @Rect,
            PChar(Title), Length(Title), nil);
        taRightJustify:
          Windows.ExtTextOut(DC, Right - TextWidth(Title), Top,
            TextFlags or ETO_CLIPPED, @Rect, PChar(Title), Length(Title), nil);
      else { taCenter }
        Windows.ExtTextOut(DC, Left + (Right - Left - TextWidth(Title)) div 2, Top,
          TextFlags or ETO_CLIPPED, @Rect, PChar(Title), Length(Title), nil);
      end
    else
      case TitleAlignment of
        taLeftJustify:
          DrawTextEx(DC, PChar(Title), Length(Title), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_LEFT, nil);
        taRightJustify:
          DrawTextEx(DC, PChar(Title), Length(Title), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_RIGHT, nil);
      else { taCenter }
        DrawTextEx(DC, PChar(Title), Length(Title), Rect,
          DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_CENTER, nil);
      end;
    Changed;
  end;
end;

procedure TGridFrame.WriteValue(var Rect: TRect; AColumn: Integer; const S: string);
var
  DC: HDC;
begin
  with FColumnInfo^[AColumn], Rect, DataGrid.Canvas do
  begin
    DC := Handle;
    Windows.FillRect(DC, Rect, Brush.Handle);
    Inc(Left, LeftIndent);
    Dec(Right, RightIndent);
    Inc(Top, 2);
    if not FMultiline then
      case Alignment of
        taLeftJustify:
          Windows.ExtTextOut(DC, Left, Top, TextFlags or ETO_CLIPPED, @Rect,
            PChar(S), Length(S), nil);
        taRightJustify:
          Windows.ExtTextOut(DC, Right - TextWidth(S), Top,
            TextFlags or ETO_CLIPPED, @Rect, PChar(S), Length(S), nil);
      else { taCenter }
        Windows.ExtTextOut(DC, Left + (Right - Left - TextWidth(S)) div 2, Top,
          TextFlags or ETO_CLIPPED, @Rect, PChar(S), Length(S), nil);
      end
    else
      case Alignment of
        taLeftJustify:
          DrawTextEx(DC, PChar(S), Length(S), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_LEFT, nil);
        taRightJustify:
          DrawTextEx(DC, PChar(S), Length(S), Rect,
            DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_RIGHT, nil);
      else { taCenter }
        DrawTextEx(DC, PChar(S), Length(S), Rect,
          DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX or DT_CENTER, nil);
      end;
    Changed;
  end;
end;

function TGridFrame.GetCellSelect: Boolean;
begin
  Result := goRowSelect in DataGrid.Options;
end;

procedure TGridFrame.SetCellSelect(Value: Boolean);
begin
  If Value then
    DataGrid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine,
      goHorzLine, goColSizing, goThumbTracking, goDrawFocusSelected]
  else
    DataGrid.Options := [goFixedVertLine, goFixedHorzLine, goVertLine,
      goHorzLine, goColSizing, goRowSelect, goThumbTracking];
end;

function TGridFrame.GetGridVisible: Boolean;
begin
  Result := DataGrid.GridLineWidth <> 0;
end;

procedure TGridFrame.SetGridVisible(Value: Boolean);
begin
  DataGrid.GridLineWidth := Integer(Value);
end;

function TGridFrame.GetEntitled: Boolean;
begin
  Result := DataGrid.FixedRows > 0;
end;

procedure TGridFrame.SetEntitled(APresent: Boolean);
begin
  if APresent then
    DataGrid.FixedRows := 1
  else
    DataGrid.FixedRows := 0;
end;

procedure TGridFrame.SearchNext;
var
  S: string;
  I, J, N, RS: Integer;
  Full: Boolean;
begin
  RS := GetSelectedRowIndex;
  if RS >= FRowCount - 1 then
    Exit;
  Inc(RS);
  S := SearchEdit.Text;
  SearchEdit.Font.Color := clWindowText;
  if not G_IsEmpty(S) and (S[1] = '*') then
  begin
    G_Delete(S, 1, 1);
    Full := True;
  end else
    Full := False;
  N := Length(S);
  if N = 0 then
    Exit;
  if FSearchByColumns then
  begin
    if Full then
    begin
      for J := 0 to FColumnCount - 1 do
        if FColumnInfo^[J].Searched then
          for I := RS to FRowCount - 1 do
            if G_PosText(S, FItemList^[I * FColumnCount + J]) <> 0 then
            begin
              SelectRow(I);
              Exit;
            end;
    end else
    begin
      for J := 0 to FColumnCount - 1 do
        if FColumnInfo^[J].Searched then
          for I := RS to FRowCount - 1 do
            if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
            begin
              SelectRow(I);
              Exit;
            end;
    end;
  end else
    if Full then
    begin
      for I := RS to FRowCount - 1 do
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            if G_PosText(S, FItemList^[I * FColumnCount + J]) <> 0 then
            begin
              SelectRow(I);
              Exit;
            end;
    end else
    begin
      for I := RS to FRowCount - 1 do
        for J := 0 to FColumnCount - 1 do
          if FColumnInfo^[J].Searched then
            if G_SameTextL(FItemList^[I * FColumnCount + J], S, N) then
            begin
              SelectRow(I);
              Exit;
            end;
    end;
  SearchEdit.Font.Color := clGrayText;
end;

procedure TGridFrame.UpdateTitleHeight;
var
  J,RwH: Integer;
  Rect: TRect;
  DC: HDC;
begin
  Rect.Left := 0;
  Rect.Top := 0;
  with DataGrid.Canvas do
  begin
    Font := DataGrid.Font;
    DC := Handle;
    Lock;
    RwH := DataGrid.DefaultRowHeight;
    for J := FColumnCount - 1 downto 0 do
      with FColumnInfo^[J] do
      begin
        Rect.Right := Width - RightIndent - LeftIndent;
        if not G_IsEmpty(Title) then
        begin
          DrawTextEx(DC, PChar(Title), Length(Title), Rect,
            DT_CALCRECT or DT_EXPANDTABS or DT_NOPREFIX or DT_WORDBREAK, nil);
          Inc(Rect.Bottom, 4);
          if Rect.Bottom > RwH then
            RwH := Rect.Bottom;
        end;
      end;
    DataGrid.RowHeights[0] := RwH;
    UnLock;
    Changed;
  end;
end;

procedure TGridFrame.UpdateRowHeights;
var
  I,J,RwH: Integer;
  Rect: TRect;
  S: string;
  DC: HDC;
begin
  Rect.Left := 0;
  Rect.Top := 0;
  with DataGrid.Canvas do
  begin
    Font := DataGrid.Font;
    DC := Handle;
    Lock;
    for I := 0 to FRowCount - 1 do
    begin
      RwH := DataGrid.DefaultRowHeight;
      for J := FColumnCount - 1 downto 0 do
      begin
        with FColumnInfo^[J] do
          Rect.Right := Width - RightIndent - LeftIndent;
        S := FItemList^[I * FColumnCount + J];
        if not G_IsEmpty(S) then
        begin
          DrawTextEx(DC, PChar(S), Length(S), Rect,
            DT_CALCRECT or DT_EXPANDTABS or DT_NOPREFIX or DT_WORDBREAK,nil);
          Inc(Rect.Bottom, 4);
          if Rect.Bottom > RwH then
            RwH := Rect.Bottom;
        end;
      end;
      DataGrid.RowHeights[DataGrid.FixedRows + I] := RwH;
    end;
    UnLock;
    Changed;
  end;
end;

procedure TGridFrame.SetDelayedSelectPause(Value: Cardinal);
begin
  if FTimerWork then
  begin
    KillTimer(FTimerWnd, 1);
    FTimerWork := False;
  end;
  FDelayedSelectPause := Value;
end;

procedure TGridFrame.TimerWndProc(var AMsg: TMessage);
var
  Index: Integer;
begin
  with AMsg do
    if Msg = WM_TIMER then
    begin
      if FTimerWork then
      begin
        KillTimer(FTimerWnd, 1);
        FTimerWork := False;
        Index := GetSelectedRowIndex;
        if Index = FDelayedRowIndex then
          FOnDelayedSelectItem(Self, Index);
      end;
    end else
      Result := DefWindowProc(FTimerWnd, Msg, wParam, lParam);
end;

procedure TGridFrame.ResetDelayedSelection(TestIndex: Integer);
begin
  if FTimerWork then
    if TestIndex = FDelayedRowIndex then
      Exit
    else
    begin
      KillTimer(FTimerWnd, 1);
      FTimerWork := False;
    end;
  FDelayedRowIndex := TestIndex;
  if SetTimer(FTimerWnd,1,FDelayedSelectPause,nil) = 0 then
    RaiseError(SErrNoAvailableTimers);
  FTimerWork := True;
end;

procedure TGridFrame.ProcessColumnResize;
var
  J: Integer;
begin
  if FInfoApp then
  begin
    for J := FColumnCount - 1 downto 0 do
      FColumnInfo^[J].Width := DataGrid.ColWidths[J];
    if (DataGrid.FixedRows > 0) and FTitleMultiline then
      UpdateTitleHeight;
    if FMultiline then
      UpdateRowHeights;
  end;
end;

procedure TGridFrame.DoEnter;
begin
  SearchEdit.Font.Color := clWindowText;
  SetSearchText('*', False);
  if Assigned(FOnEnterFrame) then
    FOnEnterFrame(Self);
  inherited;
end;

procedure TGridFrame.DoExit;
begin
  SetSearchText('', False);
  if Assigned(FOnExitFrame) then
    FOnExitFrame(Self);
  inherited;
end;

procedure TGridFrame.SetFocus;
begin
  Windows.SetFocus(DataGrid.Handle);
  SearchEdit.Font.Color := clWindowText;
  SetSearchText('*',False);
end;

function TGridFrame.Focused: Boolean;
var
  WC: TWinControl;
begin
  WC := Screen.ActiveControl;
  Result := (WC = SearchEdit) or (WC = DataGrid);
end;

procedure TGridFrame.SelectRow(Index: Integer; Immediate: Boolean);
var
  CurrentTop, NewTop, VC: Integer;
  Rect: TGridRect;
begin
  if (Index >= 0) and (Index < FRowCount) then
  begin
    CurrentTop := DataGrid.TopRow;
    VC := DataGrid.VisibleRowCount;
    Dec(CurrentTop, DataGrid.FixedRows);
    if Index < CurrentTop then
    begin
      if Index > 0 then
        NewTop := Index - 1
      else
        NewTop := 0;
      Inc(NewTop, DataGrid.FixedRows);
      DataGrid.TopRow := NewTop;
    end
    else if Index > CurrentTop + VC - 2 then
    begin
      if Index <= FRowCount - VC then
      begin
        if Index > 0 then
          NewTop := Index - 1
        else
          NewTop := 0;
      end else
        NewTop := FRowCount - VC;
      Inc(NewTop, DataGrid.FixedRows);
      DataGrid.TopRow := NewTop;
    end;
    If goRowSelect in DataGrid.Options then
    begin
      Rect.Left := 0;
      Rect.Right := FColumnCount - 1;
    end else
    begin
      Rect.Left  := DataGrid.Col;
      Rect.Right := Rect.Left;
    end;
    Rect.Top := DataGrid.FixedRows + Index;
    Rect.Bottom := Rect.Top;
    DataGrid.Selection := Rect;
    if Assigned(FOnSelectItem) then
      FOnSelectItem(Self, Index);
    if FDelayedSelectPause <> 0 then
      if Immediate then
      begin
        if FTimerWork then
        begin
          KillTimer(FTimerWnd,1);
          FTimerWork := False;
        end;
        FOnDelayedSelectItem(Self, Index);
      end else
        ResetDelayedSelection(Index);
  end;
end;

function TGridFrame.GetSelectedRowIndex: Integer;
begin
  if FRowCount > 0 then
  begin
    Result := DataGrid.Selection.Top - DataGrid.FixedRows;
    if Result < 0 then
    begin
      Result := 0;
      SelectRow(0);
    end
    else if Result >= FRowCount then
    begin
      Result := FRowCount - 1;
      SelectRow(Result);
    end;
  end else
    Result := -1;
end;

function TGridFrame.GetSelectedColumnIndex: Integer;
begin
  if FRowCount > 0 then
  begin
    Result := DataGrid.Selection.Left - DataGrid.FixedCols;
    if Result < 0 then
      Result := 0
    else if Result >= FColumnCount then
      Result := FColumnCount - 1;
  end else
    Result := -1;
end;

procedure TGridFrame.SetSearchText(const S: string; BeginSearch: Boolean);
begin
  SearchEdit.Font.Color := clWindowText;
  if BeginSearch then
    with SearchEdit do
    begin
      Text := S;
      SelStart := Length(S);
    end
  else
  begin
    FSearchInProgress := False;
    with SearchEdit do
    begin
      Text := S;
      SelStart := Length(S);
    end;
    FSearchInProgress := True;
  end;
end;

end.

