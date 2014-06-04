object Form1: TForm1
  Left = 253
  Top = 163
  AutoScroll = False
  Caption = 'Form1'
  ClientHeight = 699
  ClientWidth = 1092
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 120
    Top = 135
    Width = 67
    Height = 24
    Caption = 'Player 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 200
    Top = 135
    Width = 26
    Height = 24
    Caption = 'not'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 240
    Top = 135
    Width = 90
    Height = 24
    Caption = 'connected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    Interval = 40
    Left = 24
    Top = 16
  end
  object ClientSocket1: TClientSocket
    Active = False
    Address = '192.168.0.222'
    ClientType = ctNonBlocking
    Port = 10048
    Left = 769
    Top = 140
  end
end
