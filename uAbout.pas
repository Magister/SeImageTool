unit uAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinProvider, StdCtrls, sLabel, JvExControls, JvgStaticText,
  JvExStdCtrls, JvHtControls, gnugettext;

type
  TfmAbout = class(TForm)
    sSkinProvider1: TsSkinProvider;
    JvHTLabel1: TJvHTLabel;
    lbThanks: TJvHTListBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation

uses uMain;

{$R *.dfm}

procedure TfmAbout.FormShow(Sender: TObject);
begin
 fmAbout.Left:=fmMain.Left+(fmMain.Width div 2)-(fmAbout.Width div 2);
 fmAbout.Top:=fmMain.Top+(fmMain.Height div 2)-(fmAbout.Height div 2);
 lbThanks.SetFocus;
 lbThanks.ItemIndex:=0;
end;

procedure TfmAbout.FormCreate(Sender: TObject);
begin
 TranslateComponent(Self);
 fmAbout.Caption:=fmAbout.Caption+' v'+swversion;
end;

end.
