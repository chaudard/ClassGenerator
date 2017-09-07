unit DelphiGenerator;

interface

uses
  TechnoGenerator,
  classes
  , PropertyObj
  ;

type TDelphiClassGenerator = class(TTechnoClassGenerator)
  private
    class function getUpperFirstLetterAndPropertyStyleString(const aProp: TProperty; out aUfl: string; out aPss: string): boolean;
    class function getConstPropertyArgument(const aUfl: string; const aPss: string): string;

    procedure startCreate(const aSl: TStringList);
    function getCreateArguments: string;
    procedure addPrivate(const aSl: TStringList);
    procedure addPublished(const aSl: TStringList);
    procedure addPublic(const aSl: TStringList);
    procedure addCreator(const aSl: TStringList);
    procedure addCreatorParams(const aSl: TStringList);
    procedure addDestructor(const aSl: TStringList);
    procedure addGetters(const aSl: TStringList);
    procedure addSetters(const aSl: TStringList);
  public
    function generate: TStringList; override;
end;

implementation

{ TDelphiClassGenerator }

uses
    sysUtils
  , Controller
  ;

////////////////////////////////////////////////////////////////////////////////
class function TDelphiClassGenerator.getConstPropertyArgument(const aUfl,
  aPss: string): string;
begin
  result := format('const a%s: %s', [aUfl, aPss]);
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
////////////////////////////////////////////////////////////////////////////////

procedure TDelphiClassGenerator.startCreate(const aSl: TStringList);
begin
  aSl.Add('begin');
  aSl.Add('  inherited Create;');
end;

function TDelphiClassGenerator.getCreateArguments: string;
var
  i: integer;
  vProp: TProperty;
  vUfl: string;
  vPss: string;
begin
  result := '';
  for i := 0 to FGenerator.properties.Count - 1 do
  begin
    getUpperFirstLetterAndPropertyStyleString(FGenerator.properties.Items[i], vUfl, vPss);
    result := result + getConstPropertyArgument(vUfl, vPss);
    if i < FGenerator.properties.Count - 1 then
      result := result + '; ';
  end;
end;

procedure TDelphiClassGenerator.addCreator(const aSl: TStringList);
var
  vProp: TProperty;
begin
  aSl.Add(format('constructor T%s.Create;', [TTechnoClassGenerator.UpperFirstLetter(FGenerator.name)]));
  startCreate(aSl);
  for vProp in FGenerator.properties do
  begin
    aSL.Add(format('  %s := ;',[vProp.name]));
  end;
  aSl.Add('end');
end;

procedure TDelphiClassGenerator.addCreatorParams(const aSl: TStringList);
var
  vProp: TProperty;
begin
  aSl.Add(format('constructor T%s.Create(%s);', [TTechnoClassGenerator.UpperFirstLetter(FGenerator.name), getCreateArguments]));
  startCreate(aSl);
  for vProp in FGenerator.properties do
  begin
    aSL.Add(format('  %s := a%s;',[vProp.name, TTechnoClassGenerator.UpperFirstLetter(vProp.name)]));
  end;
  aSl.Add('end');
end;

procedure TDelphiClassGenerator.addDestructor(const aSl: TStringList);
begin
  aSl.Add(format('destructor T%s.Destroy;', [TTechnoClassGenerator.UpperFirstLetter(FGenerator.name)]));
  aSl.Add('begin');
  aSl.Add('  inherited Destroy;');
  aSl.Add('end');
end;

procedure TDelphiClassGenerator.addGetters(const aSl: TStringList);
var
  vProp: TProperty;
  vUfl: string;
  vPss: string;
begin
  for vProp in FGenerator.properties do
  begin
    aSl.Add('');
    getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);

    aSl.Add(format('function T%s.get%s: %s;', [TTechnoClassGenerator.UpperFirstLetter(FGenerator.name),
                                               vUfl,
                                               vPss]));
    aSl.Add('begin');
    aSl.Add(format('  result := F%s;', [vUfl]));
    aSl.Add('end');
  end;
end;

procedure TDelphiClassGenerator.addSetters(const aSl: TStringList);
var
  vProp: TProperty;
  vUfl: string;
  vPss: string;
begin
  for vProp in FGenerator.properties do
  begin
    aSl.Add('');
    getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
    aSl.Add(format('procedure T%s.set%s(%s);', [TTechnoClassGenerator.UpperFirstLetter(FGenerator.name),
                                                vUfl,
                                                getConstPropertyArgument(vUfl, vPss)]));
    aSl.Add('begin');
    aSl.Add(format('  F%s := a%s;', [vUfl, vUfl]));
    aSl.Add('end');
  end;
end;

procedure TDelphiClassGenerator.addPrivate(const aSl: TStringList);
var
  vProp: TProperty;
  vUfl: string;
  vPss: string;
begin
  aSl.Add('  private');
  for vProp in FGenerator.properties do
  begin
    getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
    aSl.Add(format('    F%s: %s;', [vUfl,
                                       vPss]));
  end;
  for vProp in FGenerator.properties do
  begin
    getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
    aSl.Add(format('    function get%s: %s;', [vUfl,
                                                  vPss]));
    aSl.Add(format('    procedure set%s(%s);', [vUfl,
                                                   getConstPropertyArgument(vUfl, vPss)]));
  end;
end;

procedure TDelphiClassGenerator.addPublic(const aSl: TStringList);
begin
  aSl.Add('  public');
  aSl.Add('    constructor Create; overload;');
  aSl.add(format('    constructor Create(%s); overload;', [getCreateArguments]));
  aSl.Add('    destructor Destroy; override;');
end;

procedure TDelphiClassGenerator.addPublished(const aSl: TStringList);
var
  vProp: TProperty;
  vUfl: string;
  vPss: string;
begin
  aSl.Add('  published');
  for vProp in FGenerator.properties do
  begin
    getUpperFirstLetterAndPropertyStyleString(vProp, vUfl, vPss);
    aSl.Add(format('    property %s: %s read get%s write set%s;', [vProp.name,
                                                                      vPss,
                                                                      vUfl,
                                                                      vUfl]));
  end;
end;

function TDelphiClassGenerator.generate: TStringList;
var
  vGenName: string;
begin
  result := nil;
  if assigned(FGenerator) then
  begin
    result := TStringList.Create;
    vGenName := TTechnoClassGenerator.UpperFirstLetter(FGenerator.name);
    result.Add(format('type T%s = class', [vGenName]));
    addPrivate(result);
    addPublished(result);
    addPublic(result);
    result.Add('end;');
    result.Add('');
    result.Add('implementation');
    result.Add('');
    result.Add(format('{ T%s }', [vGenName]));
    result.Add('');
    addCreator(result);
    result.Add('');
    addCreatorParams(result);
    result.Add('');
    addDestructor(result);
    addGetters(result);
    addSetters(result);
  end;
end;

end.
