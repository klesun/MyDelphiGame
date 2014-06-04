object Form1: TForm1
  Left = 788
  Top = 378
  AutoScroll = False
  Caption = 'Form1'
  ClientHeight = 454
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
  object Label4: TLabel
    Left = 432
    Top = 80
    Width = 82
    Height = 32
    Caption = 'Label4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object P2Health: TLabel
    Left = 640
    Top = 80
    Width = 44
    Height = 13
    Caption = 'P2Health'
  end
  object Label20: TLabel
    Left = 32
    Top = 416
    Width = 38
    Height = 13
    Caption = 'Label20'
  end
  object Label5: TLabel
    Left = 720
    Top = 232
    Width = 32
    Height = 13
    Caption = 'Label5'
  end
  object ServerSocket1: TServerSocket
    Active = True
    Port = 10048
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    Left = 809
    Top = 140
  end
  object Timer1: TTimer
    Interval = 40
    OnTimer = Timer1Timer
    Left = 24
    Top = 16
  end
end
