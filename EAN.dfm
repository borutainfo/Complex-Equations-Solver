object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'Rozwi'#261'zywanie uk'#322'adu r'#243'wna'#324' liniowych o wsp'#243#322'czynnikach zespolon' +
    'ych'
  ClientHeight = 331
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 310
    Width = 488
    Height = 13
    Caption = 
      '"Podstawowe procedury numeryczne w j'#281'zyku Turbo Pascal"  A. Marc' +
      'iniak, D. Gregulec, J. Kaczmarek'
  end
  object Label2: TLabel
    Left = 8
    Top = 292
    Width = 510
    Height = 13
    Caption = 
      'Autor aplikacji: Sebastian Boruta. Wydzia'#322' informatyki, Politech' +
      'nika Pozna'#324'ska 2015. Na podstawie ksi'#261#380'ki:'
  end
  object Label3: TLabel
    Left = 8
    Top = 270
    Width = 89
    Height = 13
    Caption = 'Status wykonania:'
  end
  object wynik: TLabel
    Left = 103
    Top = 270
    Width = 6
    Height = 13
    Caption = '0'
    Color = clBtnText
    ParentColor = False
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 113
    Height = 65
    Caption = ' Arytmetyka '
    TabOrder = 0
  end
  object ar_zwykla: TRadioButton
    Left = 19
    Top = 25
    Width = 62
    Height = 17
    Caption = 'zwyk'#322'a'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = ar_zwyklaClick
  end
  object ar_przedzialowa: TRadioButton
    Left = 19
    Top = 46
    Width = 78
    Height = 17
    Caption = 'przedzia'#322'owa'
    TabOrder = 2
    OnClick = ar_przedzialowaClick
  end
  object uklad_rownan: TStringGrid
    Left = 127
    Top = 8
    Width = 410
    Height = 129
    ColCount = 1
    DoubleBuffered = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 79
    Width = 113
    Height = 58
    Caption = ' Ile r'#243'wna'#324'? '
    TabOrder = 4
    object ile_rownan: TEdit
      Left = 11
      Top = 26
      Width = 94
      Height = 21
      TabOrder = 0
      Text = '3'
    end
  end
  object ustaw: TButton
    Left = 8
    Top = 143
    Width = 113
    Height = 25
    Caption = 'Ustaw'
    TabOrder = 5
    OnClick = ustawClick
  end
  object rozwiazanie: TStringGrid
    Left = 127
    Top = 143
    Width = 410
    Height = 143
    ColCount = 1
    DefaultColWidth = 168
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 6
    RowHeights = (
      24)
  end
  object oblicz: TButton
    Left = 8
    Top = 174
    Width = 113
    Height = 59
    Caption = 'Oblicz!'
    Enabled = False
    TabOrder = 7
    OnClick = obliczClick
  end
  object reset: TButton
    Left = 8
    Top = 239
    Width = 113
    Height = 25
    Caption = 'Resetuj'
    TabOrder = 8
    OnClick = resetClick
  end
end
