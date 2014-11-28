object fmEditIMT: TfmEditIMT
  Left = 274
  Top = 250
  Width = 644
  Height = 354
  Caption = 'Edit image table'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imPreview: TImage
    Left = 337
    Top = 0
    Width = 299
    Height = 282
    Align = alClient
  end
  object veTable: TValueListEditor
    Left = 0
    Top = 0
    Width = 337
    Height = 282
    Align = alLeft
    TabOrder = 0
    TitleCaptions.Strings = (
      'Image'
      'Image offset')
    OnDrawCell = veTableDrawCell
    ColWidths = (
      150
      181)
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 282
    Width = 636
    Height = 41
    Align = alBottom
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    object sBitBtn1: TsBitBtn
      Left = 84
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      SkinData.SkinSection = 'BUTTON'
    end
    object sBitBtn2: TsBitBtn
      Left = 440
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 12
    Top = 64
  end
end
