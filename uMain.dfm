object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Leitura de arquivos Paradox'
  ClientHeight = 625
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 563
    Width = 1018
    Height = 59
    Align = alBottom
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 562
    ExplicitWidth = 1014
    object Button1: TButton
      AlignWithMargins = True
      Left = 130
      Top = 4
      Width = 127
      Height = 47
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Exportar csv/txt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 120
      Height = 47
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Abrir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1018
    Height = 554
    Align = alClient
    DataSource = DataSource1
    DrawingStyle = gdsGradient
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 312
    Top = 160
  end
  object OpenDialog1: TOpenDialog
    Left = 200
    Top = 176
  end
  object SaveDialog1: TSaveDialog
    Left = 248
    Top = 224
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 272
    Top = 112
  end
  object FDConnection1: TFDConnection
    LoginPrompt = False
    Left = 200
    Top = 96
  end
end
