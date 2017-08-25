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
end;

implementation

{ TTechnoClassGenerator }

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
