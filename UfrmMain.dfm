object frmMain: TfrmMain
  Left = 189
  Top = 122
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26465#30721#25195#25551' - '#23545#25509'PCX-HIS'
  ClientHeight = 467
  ClientWidth = 791
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 791
    Height = 41
    Align = alTop
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 660
      Top = 11
      Width = 23
      Height = 22
      Hint = #26597#30475#33713#22495#30003#35831#21333
      Caption = #65311
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object LabeledEdit1: TLabeledEdit
      Left = 143
      Top = 12
      Width = 170
      Height = 21
      EditLabel.Width = 131
      EditLabel.Height = 13
      EditLabel.Caption = #25195#25551#25110#36755#20837#26465#30721'('#22238#36710')'
      LabelPosition = lpLeft
      TabOrder = 0
      OnKeyDown = LabeledEdit1KeyDown
    end
    object CheckBox1: TCheckBox
      Left = 354
      Top = 13
      Width = 195
      Height = 17
      TabStop = False
      Caption = #26080#38656#30830#35748','#25195#25551#21518#30452#25509#23548#20837'LIS'
      TabOrder = 1
      OnClick = CheckBox1Click
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 791
    Height = 407
    Align = alClient
    Caption = #26465#30721#20449#24687
    TabOrder = 1
    object Panel3: TPanel
      Left = 2
      Top = 15
      Width = 787
      Height = 58
      Align = alTop
      TabOrder = 0
      object LabeledEdit2: TLabeledEdit
        Left = 84
        Top = 26
        Width = 60
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #22995#21517
        ReadOnly = True
        TabOrder = 0
      end
      object LabeledEdit3: TLabeledEdit
        Left = 162
        Top = 26
        Width = 35
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #24615#21035
        ReadOnly = True
        TabOrder = 1
      end
      object LabeledEdit4: TLabeledEdit
        Left = 212
        Top = 26
        Width = 35
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #24180#40836
        ReadOnly = True
        TabOrder = 2
      end
      object LabeledEdit5: TLabeledEdit
        Left = 287
        Top = 26
        Width = 80
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = #30003#35831#31185#23460
        ReadOnly = True
        TabOrder = 3
      end
      object LabeledEdit6: TLabeledEdit
        Left = 374
        Top = 26
        Width = 60
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = #30003#35831#21307#29983
        ReadOnly = True
        TabOrder = 4
      end
      object LabeledEdit7: TLabeledEdit
        Left = 6
        Top = 26
        Width = 72
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = #26465#30721
        ReadOnly = True
        TabOrder = 5
      end
      object LabeledEdit8: TLabeledEdit
        Left = 440
        Top = 26
        Width = 140
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = #30003#35831#26102#38388
        ReadOnly = True
        TabOrder = 6
      end
      object LabeledEdit11: TLabeledEdit
        Left = 587
        Top = 26
        Width = 92
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 85
        EditLabel.Height = 13
        EditLabel.Caption = #20303#38498#21495'/'#20307#26816#21495
        ReadOnly = True
        TabOrder = 7
      end
      object Edit2: TEdit
        Left = 247
        Top = 26
        Width = 35
        Height = 21
        TabStop = False
        Color = clMenu
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
      object LabeledEdit9: TLabeledEdit
        Left = 682
        Top = 26
        Width = 60
        Height = 21
        TabStop = False
        Color = clMenu
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = #30149#20154#31867#21035
        ReadOnly = True
        TabOrder = 9
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 372
      Width = 787
      Height = 33
      Align = alBottom
      TabOrder = 1
      object Label1: TLabel
        Left = 152
        Top = 3
        Width = 345
        Height = 13
        Caption = #27880#65306'1'#12289#20462#25913#30456#21516#24037#20316#32452#12289#30456#21516#26679#26412#31867#22411#31532#19968#26465#30340#32852#26426#21495#21363#21487
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object BitBtn1: TBitBtn
        Left = 7
        Top = 4
        Width = 100
        Height = 25
        Caption = #23548#20837'LIS-F3'
        TabOrder = 0
        OnClick = BitBtn1Click
      end
    end
    object Memo1: TMemo
      Left = 2
      Top = 73
      Width = 787
      Height = 89
      Align = alTop
      Color = clMenu
      ReadOnly = True
      TabOrder = 2
    end
    object DBGrid1: TDBGridEh
      Left = 2
      Top = 162
      Width = 787
      Height = 210
      TabStop = False
      Align = alClient
      AllowedSelections = [gstRecordBookmarks, gstRectangle, gstColumns]
      DataSource = DataSource1
      DynProps = <>
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRowselCheckboxesEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghDialogFind, dghColumnResize, dghColumnMove, dghExtendVertLines]
      TabOrder = 3
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 448
    Width = 791
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Text = #25805#20316#20154#21592#24037#21495':'
        Width = 82
      end
      item
        Width = 100
      end
      item
        Text = #25805#20316#20154#21592#22995#21517':'
        Width = 82
      end
      item
        Width = 70
      end
      item
        Width = 50
      end>
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Yklissa123;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=YkLis;Data Source=202.96.1.105'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 601
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = VirtualTable1
    Left = 40
    Top = 211
  end
  object VirtualTable1: TVirtualTable
    AfterOpen = VirtualTable1AfterOpen
    FieldDefs = <
      item
        Name = #22806#37096#31995#32479#39033#30446#30003#35831#32534#21495
        DataType = ftString
        Size = 20
      end
      item
        Name = 'HIS'#39033#30446#20195#30721
        DataType = ftString
        Size = 50
      end
      item
        Name = 'HIS'#39033#30446#21517#31216
        DataType = ftString
        Size = 100
      end
      item
        Name = 'LIS'#39033#30446#20195#30721
        DataType = ftString
        Size = 50
      end
      item
        Name = 'LIS'#39033#30446#21517#31216
        DataType = ftString
        Size = 100
      end
      item
        Name = #24037#20316#32452
        DataType = ftString
        Size = 50
      end
      item
        Name = #26679#26412#31867#22411
        DataType = ftString
        Size = 50
      end
      item
        Name = #32852#26426#21495
        DataType = ftString
        Size = 20
      end>
    Left = 72
    Top = 211
    Data = {
      030008001400CDE2B2BFCFB5CDB3CFEEC4BFC9EAC7EBB1E0BAC5010014000000
      00000B00484953CFEEC4BFB4FAC2EB01003200000000000B00484953CFEEC4BF
      C3FBB3C601006400000000000B004C4953CFEEC4BFB4FAC2EB01003200000000
      000B004C4953CFEEC4BFC3FBB3C601006400000000000600B9A4D7F7D7E90100
      3200000000000800D1F9B1BEC0E0D0CD01003200000000000600C1AABBFABAC5
      0100140000000000000000000000}
  end
  object ActionList1: TActionList
    Left = 573
    Top = 8
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 114
      OnExecute = BitBtn1Click
    end
  end
  object DosMove1: TDosMove
    Active = True
    Left = 545
    Top = 8
  end
  object UniConnection1: TADOConnection
    LoginPrompt = False
    Left = 629
    Top = 8
  end
end
