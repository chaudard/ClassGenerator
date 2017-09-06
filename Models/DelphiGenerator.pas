unit DelphiGenerator;

interface

uses
  TechnoGenerator,
  classes
  , PropertyObj
  ;

type TDelphiClassGenerator = class(TTechnoClassGenerator)
  public
    function generate: TStringList; override;
    class function getUpperFirstLetterAndPropertyStyleString(const aProp: TProperty; out aUfl: string; out aPss: string): boolean;
end;

implementation

{ TDelphiClassGenerator }

uses
    sysUtils
  , Controller
  ;

function TDelphiClassGenerator.generate: TStringList;
var
  vProp: TProperty;
  vUfl: string;
  vPss: string;
begin
  result := nil;
  if assigned(FGenerator) then
  begin
    result := TStringList.Create;
    result.Add(format('type T%s = class', [TTechnoClassGenerator.UpperFirstLetter(FGenerator.name)]));
    result.Add('  private');
    for vProp in FGenerator.properties do
    begin
      getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
      result.Add(format('    F%s: %s;', [vUfl,
                                         vPss]));
    end;
    for vProp in FGenerator.properties do
    begin
      getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
      result.Add(format('    function get%s: %s;', [vUfl,
                                                    vPss]));
      result.Add(format('    procedure set%s(const a%s: %s);', [vUfl,
                                                                vUfl,
                                                                vPss]));
    end;
    result.Add('  published');
    for vProp in FGenerator.properties do
    begin
      getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
      result.Add(format('    property %s: %s read get%s write set%s;', [vProp.name,
                                                                        vPss,
                                                                        vUfl,
                                                                        vUfl]));
    end;
  end;
end;

class function TDelphiClassGenerator.getUpperFirstLetterAndPropertyStyleString(
  const aProp: TProperty; out aUfl, aPss: string): boolean;
begin
  result := false;
  aUfl := '';
  aPss := '';
  if assigned(aProp) then
  begin
    aUfl := TTechnoClassGenerator.UpperFirstLetter(aProp.name);
    aPss := TController.getPropertyStyleString(aProp.style);
    result := true;
  end;
end;

end.
