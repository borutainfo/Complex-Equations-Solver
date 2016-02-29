unit EAN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Grids, StrUtils,
  Vcl.ValEdit, Vcl.ExtCtrls, Vcl.Tabs, Vcl.DockTabSet, Vcl.Samples.Spin, CplxMtrx, CplxMtrxI, IntervalArithmetic32and64;

type
  TForm1 = class(TForm)
    RadioGroup1: TRadioGroup;
    ar_zwykla: TRadioButton;
    ar_przedzialowa: TRadioButton;
    uklad_rownan: TStringGrid;
    GroupBox1: TGroupBox;
    ustaw: TButton;
    ile_rownan: TEdit;
    rozwiazanie: TStringGrid;
    oblicz: TButton;
    reset: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    wynik: TLabel;
    procedure ustawClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure obliczClick(Sender: TObject);
    procedure ar_przedzialowaClick(Sender: TObject);
    procedure ar_zwyklaClick(Sender: TObject);
    procedure resetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  n, st: Integer;
  x: cplxvector;
  a: cplxmatrix;
  xI: cplxvectorI;
  aI: cplxmatrixI;
  test1, test2: string;
  super: interval;

implementation
{$R *.dfm}

// rozdzielanie stringa
procedure SplitStr(const Source, Delimiter: String; var DelimitedList: TStringList);
var
  s: PChar;

  DelimiterIndex: Integer;
  Item: String;
begin
  s:=PChar(Source);

  repeat
    DelimiterIndex:=Pos(Delimiter, s);
    if DelimiterIndex=0 then Break;

    Item:=Copy(s, 1, DelimiterIndex-1);

    DelimitedList.Add(Item);

    inc(s, DelimiterIndex + Length(Delimiter)-1);
  until DelimiterIndex = 0;
  DelimitedList.Add(s);
end;

// podzial przedzialu
procedure przedzial(const source: String; var left, right : Extended);
var temp : string;
    lista: TStringList;
begin
  if (AnsiContainsStr(source, ';')) then
  begin
    lista := TStringList.Create;
    temp := Trim(AnsiReplaceStr(AnsiReplaceStr(source, ']', ''),'[',''));
    SplitStr(temp,';',lista);
    left := left_read(trim(lista[0]));
    right := left_read(trim(lista[1]));
    lista.Free;
  end
  else 
  begin
    left := left_read(source);
    right := left_read(source);
  end;
end;

// wciœniêto przycisk 'oblicz'
procedure TForm1.obliczClick(Sender: TObject);
var czytaj, znak, test, temp_l, temp_r: string;
    lista: TStringList;
    i, j: Integer;
begin
  SetLength(a, n+1, n+1);
  SetLength(x, n+1);
  SetLength(aI, n+1, n+1);
  SetLength(xI, n+1);

  lista := TStringList.Create;

  // czytamy dane
  for i := 1 to n do
    for j := 1 to (n+1) do
    begin
      a[i, j].im := 0;
      a[i, j].re := 0; 
      aI[i, j].im.a := 0;
      aI[i, j].re.a := 0; 
      aI[i, j].im.b := 0;
      aI[i, j].re.b := 0; 
      
      // usuwamy nieporz¹dane znaki
      uklad_rownan.cells[j-1,i]:= AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(Trim(AnsiLowerCase(uklad_rownan.cells[j-1,i])), '(', ''), ')', ''), ' ', ''),'.',',');
      czytaj := Trim(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(uklad_rownan.cells[j-1,i],'[-','[('),';-',';('), '+', ' +'), '-', ' -'),'[(','[-'),';(',';-'));

      // podzia³ na re i im
      znak := '';
      if (AnsiContainsStr(czytaj, ' +')) then
      begin
        SplitStr(czytaj,' +',lista);
      end
      else if (AnsiContainsStr(czytaj, ' -')) then
      begin
        znak := '-';
        SplitStr(czytaj,' -',lista);
      end
      else
      begin
        lista.Add(czytaj);
      end;

      if(lista[0]='')then
        lista[0]:='0';

      // zapisujemy dane dla arytmetyki zwyk³ej

        // jeœli tylko jeden argument
        if (lista.Count = 1) then
        begin
          if(AnsiContainsStr(lista[0], 'i')) then
          begin
            test := AnsiReplaceStr(lista[0], 'i', '');
            if(test='') then
              test := '1';
            // jeœli arytmetyka zwyk³a
            if ar_zwykla.Checked then
              a[i, j].im := left_read(test)
            // jesli przedzia³owa
            else 
            begin
              przedzial(test,aI[i,j].im.a,aI[i,j].im.b);
            end;
          end
          else
          begin
            // jeœli arytmetyka zwyk³a
            if ar_zwykla.Checked then
              a[i, j].re := left_read(lista[0])
            // jesli przedzia³owa
            else 
            begin
              przedzial(lista[0],aI[i,j].re.a,aI[i,j].re.b);
            end;
          end;
        end

        // jeœli 2 argumenty
        else if (lista.count = 2) then
        begin
          if(lista[1]='')then
            lista[1]:='0';
          if(AnsiContainsStr(lista[0], 'i')) then
          begin
            test := AnsiReplaceStr(lista[0], 'i', '');
            if(test='') then
              test := '1';
            // jeœli arytmetyka zwyk³a
            if ar_zwykla.Checked then 
            begin
              a[i, j].im := left_read(test);
              a[i, j].re := left_read(znak+lista[1]);
            end 
            // jesli przedzia³owa
            else 
            begin
              przedzial(test,aI[i,j].im.a,aI[i,j].im.b);
              przedzial(znak+lista[1],aI[i,j].re.a,aI[i,j].re.b);
            end;
          end
          else
          begin
            test := AnsiReplaceStr(lista[1], 'i', '');
            if(test='') then
              test := '1';
            if ar_zwykla.Checked then 
            begin
            a[i, j].im := left_read(znak+test);
            a[i, j].re := left_read(lista[0]);
            end
            // jesli przedzia³owa
            else 
            begin
              przedzial(znak+test,aI[i,j].im.a,aI[i,j].im.b);
              przedzial(lista[0],aI[i,j].re.a,aI[i,j].re.b);
            end;
          end;
        end;
      lista.Clear;
    end; 
  lista.Free;
  
  // wyœwietlanie wyników dla zwyk³ej
  if ar_zwykla.Checked then
  begin
    complexmatrix(n,a,x,st);
    if (st <> 2) then
    for i := 1 to n do
    begin
      rozwiazanie.cells[1,i]:=to_string(x[i].re);
      rozwiazanie.cells[2,i]:=to_string(x[i].im);
    end;
  end
  // wyœwietlanie wyników dla przedzia³owej
  else
  begin
    complexmatrixI(n,aI,xI,st);
    if (st <> 2) then
    for i := 1 to n do
    begin
      iends_to_strings(xI[i].re,temp_l,temp_r);
      rozwiazanie.cells[1,i]:=temp_l;
      rozwiazanie.cells[2,i]:=temp_r;
      rozwiazanie.cells[3,i]:=to_string(int_width(xI[i].re));
      iends_to_strings(xI[i].im,temp_l,temp_r);
      rozwiazanie.cells[4,i]:=temp_l;
      rozwiazanie.cells[5,i]:=temp_r;
      rozwiazanie.cells[6,i]:=to_string(int_width(xI[i].im));
    end;
  end;

  if (st = 2) then begin
    ustawClick(self);
    wynik.Font.Color := clRed;
  end
  else begin
    wynik.Font.Color := clWindowText;
  end;

  wynik.Caption := IntToStr(st);
end;

// resetowanie ustawieñ
procedure TForm1.resetClick(Sender: TObject);
var i : integer;
begin
  for i := 0 to (uklad_rownan.ColCount - 1) do
    uklad_rownan.Cols[i].Clear;

  for i := 0 to (rozwiazanie.ColCount - 1) do
    rozwiazanie.Cols[i].Clear;
     
  uklad_rownan.ColCount := 1;
  uklad_rownan.RowCount := 1;
  rozwiazanie.RowCount := 1;
  rozwiazanie.ColCount := 1;
  ile_rownan.Text := '3';
  oblicz.Enabled := false;
  rozwiazanie.cells[0,0]:='Wyniki';
  uklad_rownan.cells[0,0]:='Dane';
  wynik.Font.Color := clWindowText;
  wynik.Caption := '0';
end;                   

// procedura ustawiania wielkoœci formularza
procedure TForm1.ustawClick(Sender: TObject);
var
  i, j: Integer;
begin

  n := StrToInt(ile_rownan.Text);

  rozwiazanie.cells[0,0]:='';
  uklad_rownan.cells[0,0]:='';

  uklad_rownan.ColCount := n+1;
  uklad_rownan.RowCount := n+1;
  for i := 0 to (n-1) do
  begin
    uklad_rownan.cells[i,0]:='x['+IntToStr(i+1)+']';
    rozwiazanie.cells[0,i+1]:=uklad_rownan.cells[i,0];
  end;
  uklad_rownan.cells[n,0]:='=';
  rozwiazanie.RowCount := n+1;

  if ar_przedzialowa.Checked then
  begin
    for i := 0 to (n) do
    begin
    uklad_rownan.ColWidths[i] := 96;
    end;
    rozwiazanie.ColCount := 7;
    rozwiazanie.cells[1,0]:='rzeczywista (od)';
    rozwiazanie.cells[2,0]:='rzeczywista (do)';
    rozwiazanie.cells[3,0]:='szerokoœæ rzecz.';
    rozwiazanie.cells[4,0]:='urojona (od)';
    rozwiazanie.cells[5,0]:='urojona (do)';
    rozwiazanie.cells[6,0]:='szerokoœæ uroj.';
    for i := 1 to n do
    begin
      rozwiazanie.cells[1,i]:='';
      rozwiazanie.cells[2,i]:='';
      rozwiazanie.cells[3,i]:='';
      rozwiazanie.cells[4,i]:='';
      rozwiazanie.cells[5,i]:='';
      rozwiazanie.cells[6,i]:='';
    end;
  end;

  if ar_zwykla.Checked then
  begin
    for i := 0 to (n) do
    begin
    uklad_rownan.ColWidths[i] := 64;
    end;
    rozwiazanie.ColCount := 3;
    rozwiazanie.cells[1,0]:='rzeczywista';
    rozwiazanie.cells[2,0]:='urojona';
    for i := 1 to n do
    begin
      rozwiazanie.cells[1,i]:='';
      rozwiazanie.cells[2,i]:='';
    end;
  end;

  oblicz.Enabled := True;

end;

procedure TForm1.ar_przedzialowaClick(Sender: TObject);
begin
  oblicz.Enabled := False;
end;

procedure TForm1.ar_zwyklaClick(Sender: TObject);
begin
  oblicz.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  rozwiazanie.ColWidths[0] := 51;
  rozwiazanie.cells[1,0]:='rzeczywista';
  rozwiazanie.cells[2,0]:='urojona';
  rozwiazanie.cells[0,0]:='Wyniki';
  uklad_rownan.cells[0,0]:='Dane';

end;

end.
