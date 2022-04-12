unit Views.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, BCrypt, BCrypt.Types, TypInfo;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCompare: TButton;
    btnGenerate: TButton;
    btnGetHashInfo: TButton;
    btnNeedsRehash: TButton;
    edtHash: TLabeledEdit;
    edtHashInfo: TLabeledEdit;
    edtNeedsRehash: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtPasswordCompare: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblCompareFalse: TLabel;
    lblCompareTrue: TLabel;
    lblCost: TLabel;
    lblHash: TLabel;
    lblNeedsRehashFalse: TLabel;
    lblNeedsRehashTrue: TLabel;
    lblSalt: TLabel;
    lblType: TLabel;
    mmBCrypt: TMemo;
    Panel1: TPanel;
    pclBCrypt: TPageControl;
    tabCompare: TTabSheet;
    tabGenerate: TTabSheet;
    tabHashInfo: TTabSheet;
    tabNeedsRehash: TTabSheet;
    procedure btnCompareClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnGetHashInfoClick(Sender: TObject);
    procedure btnNeedsRehashClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.btnGetHashInfoClick(Sender: TObject);
var
  LHashInfo: THashInfo;
begin
  LHashInfo := TBCrypt.GetHashInfo(edtHashInfo.Text);
  lblCost.Caption := IntToStr(LHashInfo.Cost);
  lblSalt.Caption := LHashInfo.Salt;
  lblHash.Caption := LHashInfo.Hash;
  lblType.Caption := GetEnumName(TypeInfo(THashType), Integer(LHashInfo.&Type));
end;

procedure TForm1.btnNeedsRehashClick(Sender: TObject);
begin
  lblNeedsRehashTrue.Visible := TBCrypt.NeedsRehash(edtNeedsRehash.Text);
  lblNeedsRehashFalse.Visible := not lblNeedsRehashTrue.Visible;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  pclBCrypt.ActivePage := tabGenerate;
end;

procedure TForm1.btnCompareClick(Sender: TObject);
begin
  lblCompareTrue.Visible := TBCrypt.CompareHash(edtPasswordCompare.Text, edtHash.Text);
  lblCompareFalse.Visible := not lblCompareTrue.Visible;
end;

procedure TForm1.btnGenerateClick(Sender: TObject);
begin
  mmBCrypt.Lines.Add(TBCrypt.GenerateHash(edtPassword.Text));
end;

end.

