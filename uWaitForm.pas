unit uWaitForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinProvider, StdCtrls, sLabel, gnugettext;

type
  TfmWait = class(TForm)
    sLabelFX1: TsLabelFX;
    sSkinProvider1: TsSkinProvider;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWait: TfmWait;

implementation

{$R *.dfm}

procedure TfmWait.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose:=false;
end;

procedure TfmWait.FormShow(Sender: TObject);
begin
 SetZOrder(true);
end;

procedure TfmWait.FormCreate(Sender: TObject);
begin
 TranslateComponent(Self);
end;

end.
