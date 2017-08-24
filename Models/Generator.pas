unit Generator;

interface

uses
  Properties;

type TGenerator = class
  private
    FName: string;
    FProperties: TProperties;
    function getName: string;
    procedure setName(const aName: string);
    function getProperties: TProperties;
    procedure setProperties(const aProperties:TProperties);
  published
    property name: string read getName write setName;
    property properties: TProperties read getProperties write setProperties;
  public
    constructor Create; overload;
    constructor Create(const aName: string; const aProperties: TProperties); overload;
    destructor Destroy; override;
end;

implementation

{ TGenerator }

constructor TGenerator.Create;
begin
  inherited Create;
  name := '';
  properties := nil;
end;

constructor TGenerator.Create(const aName: string;
  const aProperties: TProperties);
begin
  inherited Create;
  name := aName;
  properties := aProperties;
end;

destructor TGenerator.Destroy;
var
  i: Integer;
begin
  if assigned(FProperties) then
  begin
    for i := FProperties.Count - 1 downto 0 do
      FProperties.Items[i].Free;
    FProperties.Free;
  end;
  inherited Destroy;
end;

function TGenerator.getName: string;
begin
  result := FName;
end;

function TGenerator.getProperties: TProperties;
begin
  result := FProperties;
end;

procedure TGenerator.setName(const aName: string);
begin
  FName := aName;
end;

procedure TGenerator.setProperties(const aProperties: TProperties);
begin
  FProperties := aProperties;
end;

end.
