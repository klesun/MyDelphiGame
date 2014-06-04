object Form2: TForm2
  Left = 107
  Top = 220
  Width = 391
  Height = 142
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '192.168.0.100'
    Visible = False
  end
  object BitBtn1: TBitBtn
    Left = 176
    Top = 16
    Width = 185
    Height = 41
    Caption = 'Connect'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
end
