object fmWait: TfmWait
  Left = 385
  Top = 345
  BorderStyle = bsToolWindow
  Caption = 'Wait...'
  ClientHeight = 80
  ClientWidth = 205
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabelFX1: TsLabelFX
    Left = 0
    Top = 0
    Width = 205
    Height = 80
    Align = alClient
    Alignment = taCenter
    AutoSize = False
    Caption = 'Please wait...'
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 5391682
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 4
    Top = 8
  end
end
