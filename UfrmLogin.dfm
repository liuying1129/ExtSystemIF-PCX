object frmLogin: TfrmLogin
  Left = 211
  Top = 224
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = #30331#24405
  ClientHeight = 247
  ClientWidth = 367
  Color = clBtnFace
  Constraints.MinWidth = 130
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object suiForm1: TPanel
    Left = 0
    Top = 0
    Width = 367
    Height = 247
    Align = alClient
    BevelInner = bvRaised
    BorderWidth = 1
    Color = 16767438
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Image1: TImage
      Left = 4
      Top = 34
      Width = 81
      Height = 57
      Stretch = True
      Transparent = True
    end
    object Label1: TLabel
      Left = 162
      Top = 196
      Width = 65
      Height = 13
      Caption = #29256#26435#25152#26377#65306
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 162
      Top = 214
      Width = 65
      Height = 13
      Caption = #32852#31995#30005#35805#65306
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object LabeledEdit4: TLabeledEdit
      Left = 159
      Top = 26
      Width = 120
      Height = 19
      Ctl3D = False
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = #24037'    '#21495#65306
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 0
      OnExit = LabeledEdit4Exit
    end
    object LabeledEdit5: TLabeledEdit
      Left = 159
      Top = 54
      Width = 120
      Height = 19
      Ctl3D = False
      EditLabel.Width = 65
      EditLabel.Height = 13
      EditLabel.Caption = #29992#25143#21517#31216#65306
      Enabled = False
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 1
    end
    object LabeledEdit2: TLabeledEdit
      Left = 159
      Top = 82
      Width = 120
      Height = 19
      Ctl3D = False
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = #21475'    '#20196#65306
      LabelPosition = lpLeft
      ParentCtl3D = False
      PasswordChar = '*'
      TabOrder = 2
    end
    object suiButton3: TBitBtn
      Left = 73
      Top = 157
      Width = 80
      Height = 27
      Caption = #30830#23450
      TabOrder = 3
      OnClick = suiButton3Click
      OnKeyDown = suiButton3KeyDown
    end
    object suiButton4: TBitBtn
      Left = 205
      Top = 157
      Width = 80
      Height = 27
      Caption = #36864#20986
      TabOrder = 4
      OnClick = suiButton4Click
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 280
    Top = 56
  end
  object DosMove1: TDosMove
    Active = True
    Left = 312
    Top = 56
  end
  object ActionList1: TActionList
    Left = 249
    Top = 56
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 27
      OnExecute = suiButton4Click
    end
  end
end
