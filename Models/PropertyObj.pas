unit PropertyObj;

interface

uses
  PropertyStyle;

type TProperty = class
  private
    FName: string;
    FStyle: TPropertyStyle;
    function getName: string;
    procedure setName(const aName: string);
    function getStyle: TPropertyStyle;
    procedure setStyle(const aStyle: TPropertyStyle);
  published
    property name: string read getName write setName;
    property style: TPropertyStyle read getStyle write setStyle;
  public
    constructor Create; overload;
    constructor Create(const aName: string; const aStyle: TPropertyStyle); overload;
    destructor Destroy; override;
end;

implementation

{ TProperty }

constructor TProperty.Create;
begin
  inherited Create;
  name := '';
  style := TPropertyStyle.psInteger;
end;

constructor TProperty.Create(const aName: string; const aStyle: TPropertyStyle);
begin
  inherited Create;
  name := aName;
  style := aStyle;
end;

destructor TProperty.Destroy;
begin
  inherited Destroy;
end;

function TProperty.getName: string;
begin
  result := FName;
end;

function TProperty.getStyle: TPropertyStyle;
begin
  result := FStyle;
end;

procedure TProperty.setName(const aName: string);
begin
  FName := aName;
end;

procedure TProperty.setStyle(const aStyle: TPropertyStyle);
begin
  FStyle := aStyle;
end;

end.
