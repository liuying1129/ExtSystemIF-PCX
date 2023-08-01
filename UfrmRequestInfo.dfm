object frmRequestInfo: TfrmRequestInfo
  Left = 192
  Top = 123
  Width = 950
  Height = 506
  Caption = #26597#30475#30003#35831#21333
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 934
    Height = 57
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 11
      Width = 52
      Height = 13
      Caption = #24320#22987#26085#26399
    end
    object Label2: TLabel
      Left = 131
      Top = 11
      Width = 52
      Height = 13
      Caption = #32467#26463#26085#26399
    end
    object BitBtn1: TBitBtn
      Left = 673
      Top = 25
      Width = 75
      Height = 25
      Caption = #26597#35810
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object LabeledEdit1: TLabeledEdit
      Left = 241
      Top = 27
      Width = 60
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #22995#21517
      TabOrder = 1
    end
    object LabeledEdit2: TLabeledEdit
      Left = 309
      Top = 27
      Width = 170
      Height = 21
      EditLabel.Width = 39
      EditLabel.Height = 13
      EditLabel.Caption = #26465#30721#21495
      TabOrder = 2
    end
    object DateTimePicker1: TDateTimePicker
      Left = 18
      Top = 27
      Width = 100
      Height = 21
      Date = 36524.000000000000000000
      Time = 36524.000000000000000000
      TabOrder = 3
    end
    object DateTimePicker2: TDateTimePicker
      Left = 129
      Top = 27
      Width = 100
      Height = 21
      Date = 36524.999988425920000000
      Time = 36524.999988425920000000
      TabOrder = 4
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 57
    Width = 934
    Height = 410
    Align = alClient
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = UniQuery1
    Left = 48
    Top = 72
  end
  object UniQuery1: TADOQuery
    Parameters = <>
    Left = 77
    Top = 72
  end
end
