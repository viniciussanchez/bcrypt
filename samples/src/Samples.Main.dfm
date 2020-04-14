object FrmSamples: TFrmSamples
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'BCrypt'
  ClientHeight = 226
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pclBCrypt: TPageControl
    Left = 0
    Top = 0
    Width = 649
    Height = 226
    ActivePage = tabCompare
    Align = alClient
    TabOrder = 0
    object tabGenerate: TTabSheet
      Caption = 'Generate hash'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 641
        Height = 198
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object edtPassword: TLabeledEdit
          Left = 12
          Top = 23
          Width = 534
          Height = 21
          EditLabel.Width = 50
          EditLabel.Height = 13
          EditLabel.Caption = 'Password:'
          TabOrder = 0
        end
        object btnGenerate: TButton
          Left = 552
          Top = 21
          Width = 75
          Height = 25
          Caption = 'Generate'
          TabOrder = 1
          OnClick = btnGenerateClick
        end
        object mmBCrypt: TMemo
          Left = 12
          Top = 52
          Width = 615
          Height = 137
          ReadOnly = True
          TabOrder = 2
        end
      end
    end
    object tabCompare: TTabSheet
      Caption = 'Compare hash'
      ImageIndex = 1
      object lblCompareTrue: TLabel
        Left = 93
        Top = 114
        Width = 26
        Height = 13
        Caption = 'True'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object lblCompareFalse: TLabel
        Left = 93
        Top = 114
        Width = 29
        Height = 13
        Caption = 'False'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object edtPasswordCompare: TLabeledEdit
        Left = 12
        Top = 23
        Width = 613
        Height = 21
        EditLabel.Width = 50
        EditLabel.Height = 13
        EditLabel.Caption = 'Password:'
        TabOrder = 0
      end
      object edtHash: TLabeledEdit
        Left = 12
        Top = 71
        Width = 613
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Hash:'
        TabOrder = 1
      end
      object btnCompare: TButton
        Left = 12
        Top = 109
        Width = 75
        Height = 25
        Caption = 'Compare'
        TabOrder = 2
        OnClick = btnCompareClick
      end
    end
    object tabHashInfo: TTabSheet
      Caption = 'Get hash info'
      ImageIndex = 2
      object Label1: TLabel
        Left = 12
        Top = 64
        Width = 26
        Height = 13
        Caption = 'Info:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 12
        Top = 83
        Width = 28
        Height = 13
        Caption = 'Type:'
      end
      object Label3: TLabel
        Left = 12
        Top = 102
        Width = 26
        Height = 13
        Caption = 'Cost:'
      end
      object Label4: TLabel
        Left = 16
        Top = 121
        Width = 22
        Height = 13
        Caption = 'Salt:'
      end
      object Label5: TLabel
        Left = 12
        Top = 140
        Width = 28
        Height = 13
        Caption = 'Hash:'
      end
      object lblType: TLabel
        Left = 46
        Top = 83
        Width = 3
        Height = 13
      end
      object lblCost: TLabel
        Left = 46
        Top = 102
        Width = 3
        Height = 13
      end
      object lblSalt: TLabel
        Left = 46
        Top = 121
        Width = 3
        Height = 13
      end
      object lblHash: TLabel
        Left = 46
        Top = 140
        Width = 3
        Height = 13
      end
      object edtHashInfo: TLabeledEdit
        Left = 12
        Top = 23
        Width = 534
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Hash:'
        TabOrder = 0
      end
      object btnGetHashInfo: TButton
        Left = 552
        Top = 21
        Width = 75
        Height = 25
        Caption = 'Get'
        TabOrder = 1
        OnClick = btnGetHashInfoClick
      end
    end
    object tabNeedsRehash: TTabSheet
      Caption = 'Needs rehash'
      ImageIndex = 3
      object lblNeedsRehashTrue: TLabel
        Left = 93
        Top = 55
        Width = 26
        Height = 13
        Caption = 'True'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object lblNeedsRehashFalse: TLabel
        Left = 93
        Top = 55
        Width = 29
        Height = 13
        Caption = 'False'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object edtNeedsRehash: TLabeledEdit
        Left = 12
        Top = 23
        Width = 613
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Hash:'
        TabOrder = 0
      end
      object btnNeedsRehash: TButton
        Left = 12
        Top = 50
        Width = 75
        Height = 25
        Caption = 'Check'
        TabOrder = 1
        OnClick = btnNeedsRehashClick
      end
    end
  end
end
