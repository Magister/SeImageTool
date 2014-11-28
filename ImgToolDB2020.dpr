program ImgToolDB2020;

uses
  FastMM4,
  gnugettext,
  Forms,
  uMain in 'uMain.pas' {fmMain},
  pngMerge in 'pngMerge.pas',
  uWaitForm in 'uWaitForm.pas' {fmWait},
  uStreamIO in 'uStreamIO.pas',
  uByteUtils in 'uByteUtils.pas',
  uAbout in 'uAbout.pas' {fmAbout},
  uEditIMT in 'uEditIMT.pas' {fmEditIMT};

{$R *.res}

begin
  UseLanguage('en');
  AddDomainForResourceString('acnt');
  Application.Initialize;
  Application.Title := 'SE db2020 Image Tool';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmWait, fmWait);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.CreateForm(TfmEditIMT, fmEditIMT);
  Application.Run;
end.
