object fmAbout: TfmAbout
  Left = 331
  Top = 237
  BorderStyle = bsToolWindow
  Caption = 'About SE db2020 Image Tool'
  ClientHeight = 315
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object JvHTLabel1: TJvHTLabel
    Left = 0
    Top = 0
    Width = 635
    Height = 113
    Align = alTop
    Caption = 
      '<br>'#13#10'<align=center>You can use and distribute software for free' +
      ', but you <b>SHOULD NOT modify it</b><br>'#13#10'If you like this soft' +
      'ware, support author by sending some money to one of WebMoney wa' +
      'llets:<br>'#13#10'<b><font color=clRed>WMZ: Z006853598030 WMU: U778558' +
      '752302 WMR: R428423234915 or EGold: 4952803</font></b><br>'#13#10'If y' +
      'ou find some bug, or have ideas on program development write me:' +
      ' <a href=mailto:misha.cn.ua@gmail.com>misha.cn.ua@gmail.com</a><' +
      'br>'#13#10'<br>'#13#10'A big THANKS to following people:<br></align>'#13#10'<br>'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  object lbThanks: TJvHTListBox
    Left = 0
    Top = 113
    Width = 635
    Height = 202
    HideSel = True
    Align = alClient
    ColorHighlight = clMenuHighlight
    ColorHighlightText = clWindow
    ColorDisabledText = clGrayText
    Items.Strings = (
      '<align=center><b>--Development--</b></align>'
      
        '<b>Hussein</b> - for information on image table and B&W image fo' +
        'rmat'
      '<b>ego</b> - for information on packed image format'
      '<b>INFerno-- (aka se-team)</b> - for information on BABE format'
      '<b>den_po</b> - for information on names table and list of names'
      '<b>svansvan</b> - for help on names table and .xml with names'
      '<b>timos_06</b> - for discovering of a strange bug'
      '<align=center><b>--Translations--</b></align>'
      '<b>Magister (it'#39's me :) )</b> - Ukrainian and English'
      '<b>DJSuB</b> - Hungarian'
      '<b>Adrian</b> - Spanish'
      '<b>Blast Pit</b> - Russian'
      
        '<align=center><b><a href=http://magister.ipsys.net>Visit my site' +
        ' for new versions</a></b></align>'
      '<align=center><b>---------------------------</b></align>')
    TabOrder = 0
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 4
    Top = 4
  end
end
