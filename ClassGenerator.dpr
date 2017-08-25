program ClassGenerator;

uses
  Forms,
  ApplicationGUI in 'ApplicationGUI.pas' {ApplicationGUIForm},
  PropertyStyle in 'Models\PropertyStyle.pas',
  PropertyObj in 'Models\PropertyObj.pas',
  Generator in 'Models\Generator.pas',
  Controller in 'Models\Controller.pas',
  Properties in 'Models\Properties.pas',
  UnitConst in 'UnitConst.pas',
  TechnoType in 'Models\TechnoType.pas',
  GeneratorInterface in 'Models\GeneratorInterface.pas',
  DelphiGenerator in 'Models\DelphiGenerator.pas',
  TechnoGenerator in 'Models\TechnoGenerator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TApplicationGUIForm, ApplicationGUIForm);
  Application.Run;
end.
