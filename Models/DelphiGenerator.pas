unit DelphiGenerator;

interface

uses
  GeneratorInterface,
  Generator,
  classes
  ;

type TDelphiClassGenerator = class(TObject, iClassGenerator)
  private
    FGenerator: TGenerator;
  public
    constructor Create; overload;
    constructor Create(const aGenerator: TGenerator); overload;
    destructor Destroy; override;

    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    function generate: TStringList;
end;

implementation

uses
  windows;

{ TDelphiClassGenerator }

constructor TDelphiClassGenerator.Create;
begin
  FGenerator := nil;
end;

constructor TDelphiClassGenerator.Create(const aGenerator: TGenerator);
begin
  FGenerator := aGenerator;
end;

destructor TDelphiClassGenerator.Destroy;
begin

  inherited;
end;

function TDelphiClassGenerator.generate: TStringList;
begin
  result := nil;
  if assigned(FGenerator) then
  begin
    result := TStringList.Create;
    result.Add('Hello World!.');
  end;
end;

function TDelphiClassGenerator.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TDelphiClassGenerator._AddRef: Integer;
begin
  Result := S_OK;
end;

function TDelphiClassGenerator._Release: Integer;
begin
  Result := S_OK;
  Destroy;
end;

end.
