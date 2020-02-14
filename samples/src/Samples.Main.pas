unit Samples.Main;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFrmSamples = class(TForm)
    pclBCrypt: TPageControl;
    tabGenerate: TTabSheet;
    tabCompare: TTabSheet;
    Panel1: TPanel;
    edtPassword: TLabeledEdit;
    btnGenerate: TButton;
    mmBCrypt: TMemo;
    edtPasswordCompare: TLabeledEdit;
    edtHash: TLabeledEdit;
    btnCompare: TButton;
    lblCompareTrue: TLabel;
    lblCompareFalse: TLabel;
    tabHashInfo: TTabSheet;
    edtHashInfo: TLabeledEdit;
    btnGetHashInfo: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblType: TLabel;
    lblCost: TLabel;
    lblSalt: TLabel;
    lblHash: TLabel;
    tabNeedsRehash: TTabSheet;
    edtNeedsRehash: TLabeledEdit;
    btnNeedsRehash: TButton;
    lblNeedsRehashTrue: TLabel;
    lblNeedsRehashFalse: TLabel;
    procedure btnGenerateClick(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGetHashInfoClick(Sender: TObject);
    procedure btnNeedsRehashClick(Sender: TObject);
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.dfm}

uses BCrypt, BCrypt.Types, System.TypInfo;

procedure TFrmSamples.btnCompareClick(Sender: TObject);
begin
  lblCompareTrue.Visible := TBCrypt.CompareHash(edtPasswordCompare.Text, edtHash.Text);
  lblCompareFalse.Visible := not lblCompareTrue.Visible;
end;

procedure TFrmSamples.btnGenerateClick(Sender: TObject);
begin
  mmBCrypt.Lines.Add(TBCrypt.GenerateHash(edtPassword.Text));
end;

procedure TFrmSamples.btnGetHashInfoClick(Sender: TObject);
var
  LHashInfo: THashInfo;
begin
  LHashInfo := TBCrypt.GetHashInfo(edtHashInfo.Text);
  lblCost.Caption := IntToStr(LHashInfo.Cost);
  lblSalt.Caption := LHashInfo.Salt;
  lblHash.Caption := LHashInfo.Hash;
  lblType.Caption := GetEnumName(TypeInfo(THashType), Integer(LHashInfo.&Type));
end;

procedure TFrmSamples.btnNeedsRehashClick(Sender: TObject);
begin
  lblNeedsRehashTrue.Visible := TBCrypt.NeedsRehash(edtNeedsRehash.Text);
  lblNeedsRehashFalse.Visible := not lblNeedsRehashTrue.Visible;
end;

procedure TFrmSamples.FormShow(Sender: TObject);
begin
  pclBCrypt.ActivePage := tabGenerate;
end;

end.
