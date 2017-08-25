unit Controller;

interface

uses
  Generator,
  PropertyStyle,
  TechnoType,
  Classes;

type TController = class
  public
    class function propertyExists(const aPropertyName: string; const aGenerator: TGenerator): integer; overload;
    class function propertyExists(const aIndex: integer; const aGenerator: TGenerator): boolean; overload;
    class function addProperty(const aPropertyName: string; aPropertyStyle: TPropertyStyle; const aGenerator: TGenerator): boolean;
    class function updateProperty(const aIndex: integer; aNewPropertyStyle: TPropertyStyle; const aGenerator: TGenerator): boolean;
    class function deleteProperty(const aIndex: integer; const aGenerator: TGenerator): boolean;
    class function getPropertyStyleString(const aPropertyStyle: TPropertyStyle): string;
    class function getTechnoString(const aTechnoType: TTechnoType): string;
    class function getPropertyNameAndStyle(const aIndex: integer;
                                           const aGenerator: TGenerator;
                                           out aName: string;
                                           out aStyle: string): boolean;
    class function getClassGeneration(const aTechnoType: TTechnoType; const aGenerator: TGenerator): TStringList;
end;

implementation

uses
  sysUtils,
  PropertyObj,
  GeneratorInterface,
  DelphiGenerator
  ,windows // for outputdebugstring
  ;

{ TController }

class function TController.addProperty(const aPropertyName: string;
  aPropertyStyle: TPropertyStyle; const aGenerator: TGenerator): boolean;
begin
  result := false;
  if (aPropertyName <> '')
  and (assigned(aGenerator))
  then
  begin
    aGenerator.properties.Add(TProperty.Create(aPropertyName, aPropertyStyle));
    result := true;
  end;
end;

class function TController.deleteProperty(const aIndex: integer;
  const aGenerator: TGenerator): boolean;
var
  vProperty: TProperty;
begin
  result := false;
  if propertyExists(aIndex, aGenerator) then
  begin
    vProperty := aGenerator.properties.Items[aIndex];
    vProperty.Free;
    aGenerator.properties.Delete(aIndex);
    result := true;
  end;
end;
{
procedure TestUseInterface(iInt: IInterface);
var
  iClassGen: IClassGenerator;
begin
  if supports(iInt, iClassGenerator, iClassGen) then
  begin
    outputdebugstring('use iClassGen');
    iClassGen := nil;
  end;
end;
}
class function TController.getClassGeneration(
  const aTechnoType: TTechnoType;
  const aGenerator: TGenerator): TStringList;
var
  iClassGen: IClassGenerator;
  vDcg: TDelphiClassGenerator;
begin
  result := nil;
  if assigned(aGenerator) then
  begin
    case aTechnoType of
      ttDelphi:
      begin
        vDcg :=  TDelphiClassGenerator.Create(aGenerator);
        iClassGen := vDcg;
        result := iClassGen.generate;
        //TestUseInterface(iClassGen);
        iClassGen := nil;
        vDcg.Free;
      end;
      ttCs:
      begin
        // to implement
      end;
      ttJava:
      begin
        // to implement
      end;
    end;
  end;
end;

class function TController.getPropertyNameAndStyle(const aIndex: integer;
  const aGenerator: TGenerator; out aName, aStyle: string): boolean;
begin
  result := false;
  aName := '';
  aStyle := '';
  if propertyExists(aIndex, aGenerator) then
  begin
    aName := aGenerator.properties.Items[aIndex].name;
    aStyle := getPropertyStyleString(aGenerator.properties.Items[aIndex].style);
    result := true;
  end;
end;

class function TController.getPropertyStyleString(
  const aPropertyStyle: TPropertyStyle): string;
begin
  case aPropertyStyle of
    psInteger: result := 'integer';
    psString: result := 'string';
    psBoolean: result := 'boolean';
    psFloat: result := 'float';
    psDouble: result := 'double';
    psStringList: result := 'stringList';
  end;
end;

class function TController.getTechnoString(
  const aTechnoType: TTechnoType): string;
begin
  case aTechnoType of
    ttDelphi: result := 'Delphi';
    ttCs: result := 'C#';
    ttJava: result := 'Java';
  end;
end;

class function TController.propertyExists(const aIndex: integer;
  const aGenerator: TGenerator): boolean;
begin
  result := false;
  if assigned(aGenerator)
  and (aIndex > -1) and (aIndex < aGenerator.properties.Count)
  then
    result := true;
end;

class function TController.updateProperty(const aIndex: integer;
  aNewPropertyStyle: TPropertyStyle; const aGenerator: TGenerator): boolean;
var
  vProperty: TProperty;
begin
  result := false;
  if propertyExists(aIndex, aGenerator) then
  begin
    vProperty := aGenerator.properties.Items[aIndex];
    vProperty.style := aNewPropertyStyle;
    result := true;
  end;
end;

class function TController.propertyExists(const aPropertyName: string;
  const aGenerator: TGenerator): integer;
var
  i: Integer;
begin
  result := -1;
  if assigned(aGenerator) and (aPropertyName <> '') then
  begin
    if assigned(aGenerator.properties) then
    begin
      for i := 0 to aGenerator.properties.Count - 1 do
      begin
        if uppercase(aGenerator.properties.Items[i].name) = uppercase(aPropertyName) then
        begin
          result := i;
          break;
        end;
      end;
    end;
  end;
end;

end.
