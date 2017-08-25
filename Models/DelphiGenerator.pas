unit DelphiGenerator;

interface

uses
  TechnoGenerator,
  classes
  ;

type TDelphiClassGenerator = class(TTechnoClassGenerator)
  public
    function generate: TStringList; override;
end;

implementation

{ TDelphiClassGenerator }

function TDelphiClassGenerator.generate: TStringList;
begin
  result := nil;
  if assigned(FGenerator) then
  begin
    result := TStringList.Create;
    result.Add('Hello World!.');
  end;
end;

end.
