object ApplicationGUIForm: TApplicationGUIForm
  Left = 0
  Top = 0
  Caption = 'Class generator'
  ClientHeight = 682
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    440
    682)
  PixelsPerInch = 96
  TextHeight = 13
  object lbClassName: TLabel
    Left = 16
    Top = 26
    Width = 35
    Height = 13
    Caption = 'Class : '
  end
  object lbPropertyName: TLabel
    Left = 16
    Top = 64
    Width = 52
    Height = 13
    Caption = 'Property : '
  end
  object lbPropertyType: TLabel
    Left = 215
    Top = 64
    Width = 34
    Height = 13
    Caption = 'Type : '
  end
  object lbProperties: TLabel
    Left = 16
    Top = 183
    Width = 59
    Height = 13
    Caption = 'Properties : '
  end
  object edClassName: TEdit
    Left = 74
    Top = 26
    Width = 135
    Height = 21
    TabOrder = 0
    OnChange = edClassNameChange
  end
  object edPropertyName: TEdit
    Left = 74
    Top = 61
    Width = 135
    Height = 21
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    OnKeyDown = edPropertyNameKeyDown
    OnKeyUp = edPropertyNameKeyUp
  end
  object cbPropertyStyle: TComboBox
    Left = 248
    Top = 61
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      'integer'
      'string'
      'boolean'
      'float'
      'double'
      'stringList')
  end
  object sgProperties: TStringGrid
    Left = 16
    Top = 202
    Width = 409
    Height = 120
    ColCount = 2
    DefaultColWidth = 190
    DrawingStyle = gdsClassic
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 3
    OnClick = sgPropertiesClick
    OnDrawCell = sgPropertiesDrawCell
    OnKeyUp = sgPropertiesKeyUp
  end
  object btAddProperty: TButton
    Left = 74
    Top = 53
    Width = 95
    Height = 9
    Caption = '+'
    TabOrder = 4
    Visible = False
    OnClick = btAddPropertyClick
  end
  object btDeleteProperty: TButton
    Left = 182
    Top = 53
    Width = 27
    Height = 9
    Caption = '-'
    TabOrder = 5
    Visible = False
    OnClick = btDeletePropertyClick
  end
  object memoShortCutsEdProperty: TMemo
    Left = 74
    Top = 88
    Width = 135
    Height = 79
    Enabled = False
    Lines.Strings = (
      'return : +'
      'shift+return : -'
      'up : get selected cell'
      'ctrl+up : change type'
      'ctrl+down : change type')
    TabOrder = 6
  end
  object memoShortCutsSgProperties: TMemo
    Left = 16
    Top = 328
    Width = 409
    Height = 33
    Enabled = False
    Lines.Strings = (
      'ctrl+up : move to the top'
      'ctrl+down : move to the bottom')
    TabOrder = 7
  end
  object cbConfirmSuppress: TCheckBox
    Left = 215
    Top = 104
    Width = 114
    Height = 17
    Caption = 'confirm suppression'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object cbConfirmUpdate: TCheckBox
    Left = 215
    Top = 88
    Width = 114
    Height = 17
    Caption = 'confirm update'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object cbTechno: TComboBox
    Left = 16
    Top = 376
    Width = 145
    Height = 21
    TabOrder = 10
  end
  object btGenerateClass: TButton
    Left = 167
    Top = 374
    Width = 146
    Height = 25
    Caption = 'generate class'
    TabOrder = 11
    OnClick = btGenerateClassClick
  end
  object memoResultGeneration: TMemo
    Left = 16
    Top = 405
    Width = 409
    Height = 269
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 12
  end
  object btnCopyToClipBoard: TButton
    Left = 312
    Top = 374
    Width = 113
    Height = 25
    Caption = 'copy to clipboard'
    TabOrder = 13
    OnClick = btnCopyToClipBoardClick
  end
end
