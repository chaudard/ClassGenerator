unit TechnoGenerator;

interface

uses
  GeneratorInterface,
  Generator,
  classes
  ;

type TTechnoClassGenerator = class(TObject,
                                   iClassGenerator)
  private
    FCountRef: integer;
  protected
    FGenerator: TGenerator;
  public
    constructor Create; overload;
    constructor Create(const aGenerator: TGenerator); overload;
    destructor Destroy; override;

    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    function generate: TStringList; virtual; abstract;

    class function UpperFirstLetter(const aString: string): string;
end;

implementation

{ TTechnoClassGenerator }

uses
    sysUtils;

constructor TTechnoClassGenerator.Create;
begin
  FGenerator := nil;
  FCountRef := 0;
end;

constructor TTechnoClassGenerator.Create(const aGenerator: TGenerator);
begin
  FGenerator := aGenerator;
  FCountRef := 0;
end;

destructor TTechnoClassGenerator.Destroy;
begin

  inherited;
end;

function TTechnoClassGenerator.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := S_FALSE;
end;

class function TTechnoClassGenerator.UpperFirstLetter(
  const aString: string): string;
begin
  result := '';
  if aString <> '' then
  begin
    result := UpperCase(Copy(aString, 1, 1));
    if Length(aString) > 1 then
    begin
      result := result + Copy(aString, 2, Length(aString) - 1);
    end;
  end;
end;

function TTechnoClassGenerator._AddRef: Integer;
begin
  inc(FCountRef);
  Result := S_OK;
end;

function TTechnoClassGenerator._Release: Integer;
begin
  dec(FCountRef);
  Result := S_OK;
end;

end.
