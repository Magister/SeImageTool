program ImgToolDB2020;

uses
  FastMM4,
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uFileIO in 'uFileIO.pas',
  uTypes in 'uTypes.pas',
  uFwWork in 'uFwWork.pas',
  uImgUtils in 'uImgUtils.pas',
  uAbout in 'uAbout.pas' {fmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.Run;
end.
