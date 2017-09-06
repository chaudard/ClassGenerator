unit ApplicationGUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids
  , Generator
  , PropertyStyle
  , TechnoType
  ;

type
  TApplicationGUIForm = class(TForm)
    lbClassName: TLabel;
    edClassName: TEdit;
    lbPropertyName: TLabel;
    edPropertyName: TEdit;
    lbPropertyType: TLabel;
    cbPropertyStyle: TComboBox;
    sgProperties: TStringGrid;
    lbProperties: TLabel;
    btAddProperty: TButton;
    btDeleteProperty: TButton;
    memoShortCutsEdProperty: TMemo;
    memoShortCutsSgProperties: TMemo;
    cbConfirmSuppress: TCheckBox;
    cbConfirmUpdate: TCheckBox;
    cbTechno: TComboBox;
    btGenerateClass: TButton;
    memoResultGeneration: TMemo;
    procedure btAddPropertyClick(Sender: TObject);
    procedure sgPropertiesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edPropertyNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPropertyNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btDeletePropertyClick(Sender: TObject);
    procedure sgPropertiesClick(Sender: TObject);
    procedure sgPropertiesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btGenerateClassClick(Sender: TObject);
    procedure edClassNameChange(Sender: TObject);
  private
    { Déclarations privées }
    FClassGenerator: TGenerator;
    function getPropertyStyleChoosen: TPropertyStyle;
    function getTechnoChoosen: TTechnoType;
    procedure iniPropertyList;
    procedure iniTechnoList;
    procedure addProperty(Sender: TObject; const bDoEmptyField: boolean);
    procedure deleteProperty(Sender: TObject);
    function selectTheFoundedProperty: boolean;
    procedure selectRowIndex(const aIndex: integer);
    procedure gridDeselectAll;
    procedure updateControlsWithGridSelection;
    procedure clearFirstDatasRow;
    procedure clearGrid;
    procedure fillGrid;
    procedure clearAndFillGrid;
    procedure changeType(const aKey: word);
    function canModify(const aIndex: integer; const aTypeModification: integer): boolean;
  public
    { Déclarations publiques }
  end;

var
  ApplicationGUIForm: TApplicationGUIForm;

implementation

uses
  Properties,
  Controller,
  PropertyObj,
  UnitConst
  ;

{$R *.dfm}

procedure TApplicationGUIForm.btAddPropertyClick(Sender: TObject);
const
  cDoEmptyField: boolean = false;
begin
  addProperty(Sender, cDoEmptyField);
end;

procedure TApplicationGUIForm.btDeletePropertyClick(Sender: TObject);
begin
  deleteProperty(Sender);
end;

procedure TApplicationGUIForm.btGenerateClassClick(Sender: TObject);
var
  vTechno: TTechnoType;
  vResult: TStringList;
begin
  memoResultGeneration.Lines.Clear;
  vTechno := getTechnoChoosen;
  vResult := TController.getClassGeneration(vTechno, FClassGenerator);
  if assigned(vResult) then
  begin
    memoResultGeneration.Lines.AddStrings(vResult);
    vResult.Free;
  end;
end;

function TApplicationGUIForm.canModify(const aIndex: integer; const aTypeModification: integer): boolean;
var
  vConfirmMsg: string;
  vName: string;
  vStyle: string;
  vbCheck: boolean;
  vModif: string;
begin
  result := true;
  vbCheck := true;
  vModif := TYPE_MODIFICATION_PROPERTY_MODIFICATION_STRING;
  if aTypeModification = TYPE_MODIFICATION_PROPERTY_DELETE then
  begin
    vbCheck := cbConfirmSuppress.Checked;
    vModif := TYPE_MODIFICATION_PROPERTY_DELETE_STRING;
  end
  else
  if aTypeModification = TYPE_MODIFICATION_PROPERTY_UPDATE then
  begin
    vbCheck := cbConfirmUpdate.Checked;
    vModif := TYPE_MODIFICATION_PROPERTY_UPDATE_STRING;
  end;

  if vbCheck then
  begin
    result := false;
    if TController.getPropertyNameAndStyle(aIndex,
                                           FClassGenerator,
                                           vName,
                                           vStyle)
    then
    begin
      vConfirmMsg := format(CONFIRM_STRING,[vModif, vName, vStyle]);
      result := MessageDlg(vConfirmMsg,mtConfirmation,mbYesNo,0,mbNo) = mrYes;
    end;
  end;
end;

procedure TApplicationGUIForm.changeType(const aKey: word);
begin
  if aKey = VK_UP then
  begin
    if cbPropertyStyle.ItemIndex = 0 then
      cbPropertyStyle.ItemIndex := cbPropertyStyle.Items.Count - 1
    else
      cbPropertyStyle.ItemIndex := cbPropertyStyle.ItemIndex - 1
  end
  else
  if aKey = VK_DOWN then
  begin
    if cbPropertyStyle.ItemIndex = cbPropertyStyle.Items.Count - 1 then
      cbPropertyStyle.ItemIndex := 0
    else
      cbPropertyStyle.ItemIndex := cbPropertyStyle.ItemIndex + 1;
  end;
end;

procedure TApplicationGUIForm.clearAndFillGrid;
begin
  clearGrid;
  fillGrid;
end;

procedure TApplicationGUIForm.clearFirstDatasRow;
begin
  sgProperties.Cells[PROPERTY_COLUMN_POSITION,1] := '';
  sgProperties.Cells[TYPE_COLUMN_POSITION,1] := '';
end;

procedure TApplicationGUIForm.clearGrid;
begin
  sgProperties.RowCount := 2;
  clearFirstDatasRow;
end;

procedure TApplicationGUIForm.deleteProperty(Sender: TObject);
var
  vPropertyName: string;
  vIndex: integer;
begin
  vPropertyName := edPropertyName.Text;
  if vPropertyName <> '' then
  begin
    vIndex := TController.propertyExists(vPropertyName, FClassGenerator);
    if vIndex > -1 then
    begin
      if canModify(vIndex, TYPE_MODIFICATION_PROPERTY_DELETE)
      and TController.deleteProperty(vIndex,
                                     FClassGenerator)
      then
      begin
        clearAndFillGrid;
        // force the selection of the row just above except if vindex = 0
        if (vindex = 0) and (FClassGenerator.properties.Count > 0) then
          vindex := 1;
        selectRowIndex(vIndex);
        updateControlsWithGridSelection;
      end
      else
        showmessage(MSG_PROPERTY_NOT_DELETED);
    end
    else
      showmessage(MSG_PROPERTY_DOES_NOT_EXISTS);
  end
  else
    showmessage(MSG_PROPERTY_FIELD_EMPTY);
end;

procedure TApplicationGUIForm.edClassNameChange(Sender: TObject);
begin
  FClassGenerator.name := edClassName.Text;
end;

procedure TApplicationGUIForm.edPropertyNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
const
  cDoEmptyField: boolean = true;
begin
  if Key = VK_RETURN then
  begin
    if shift = [ssShift] then
      deleteProperty(sender)
    else
      addProperty(sender, cDoEmptyField);
  end
  else
  if Key = VK_UP then
  begin
    if Shift = [ssCtrl] then
      changeType(Key)
    else
      updateControlsWithGridSelection;
  end
  else
  if Key = VK_DOWN then
  begin
    if Shift = [ssCtrl] then
      changeType(Key)
  end;
end;

procedure TApplicationGUIForm.edPropertyNameKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  selectTheFoundedProperty;
end;

procedure TApplicationGUIForm.fillGrid;
var
  i: Integer;
  vIndex: integer;
  vName: string;
  vStyle: string;
begin
  if assigned(FClassGenerator)
  and (FClassGenerator.properties.Count > 0)
  and (sgProperties.RowCount = 2)
  then
  begin
    for i := 0 to FClassGenerator.properties.Count - 1 do
    begin
      if i > 0 then
        sgProperties.RowCount := sgProperties.RowCount + 1;
      vindex := i + 1;
      if TController.getPropertyNameAndStyle(i,
                                             FClassGenerator,
                                             vName,
                                             vStyle) then
      begin
        sgProperties.Cells[PROPERTY_COLUMN_POSITION,vIndex] := vName;
        sgProperties.Cells[TYPE_COLUMN_POSITION,vIndex] := vStyle;
      end;
    end;
  end;
end;

procedure TApplicationGUIForm.addProperty(Sender: TObject; const bDoEmptyField: boolean);
var
  vNewPropertyName: string;
  vPropertyStyle: TPropertyStyle;
  vIndex: integer;
begin
  vNewPropertyName := edPropertyName.Text;
  if vNewPropertyName <> '' then
  begin
    vIndex := TController.propertyExists(vNewPropertyName, FClassGenerator);
    if vIndex = -1 then
    begin
      vPropertyStyle := getPropertyStyleChoosen;

      if TController.addProperty(vNewPropertyName,
                                 vPropertyStyle,
                                 FClassGenerator)
      then
      begin
        clearAndFillGrid;
        // force the selection of the last row
        selectRowIndex(FClassGenerator.properties.Count);
        if bDoEmptyField then
          edPropertyName.Text := ''; // in order to allow introduce another property directly
      end
      else
        showmessage(MSG_PROPERTY_NOT_ADDED);
    end
    else
    begin
      if canModify(vIndex, TYPE_MODIFICATION_PROPERTY_UPDATE) then
      begin
        vPropertyStyle := getPropertyStyleChoosen;
        if TController.updateProperty(vIndex,
                                      vPropertyStyle,
                                      FClassGenerator)
        then
        begin
          clearAndFillGrid;
          // force the selection of the current row
          selectRowIndex(sgProperties.Row - 1);
        end
        else
          showmessage(MSG_PROPERTY_NOT_UPDATED);
      end;
    end;
  end
  else
    showmessage(MSG_PROPERTY_FIELD_EMPTY);
end;

procedure TApplicationGUIForm.FormCreate(Sender: TObject);
var
  vProperties: TProperties;
begin
  vProperties := TProperties.Create;
  FClassGenerator := TGenerator.Create(DEFAULT_NEW_CLASS_NAME, vProperties);
  iniPropertyList;
  iniTechnoList;
  gridDeselectAll;
end;

procedure TApplicationGUIForm.FormDestroy(Sender: TObject);
begin
  FClassGenerator.Free;
end;

function TApplicationGUIForm.getPropertyStyleChoosen: TPropertyStyle;
begin
  result := TPropertyStyle(cbPropertyStyle.ItemIndex);
end;

function TApplicationGUIForm.getTechnoChoosen: TTechnoType;
begin
  result := TTechnoType(cbTechno.ItemIndex);
end;

procedure TApplicationGUIForm.gridDeselectAll;
begin
  sgProperties.Selection := TGridRect(Rect(-1, -1, -1, -1));
end;

procedure TApplicationGUIForm.iniPropertyList;
var
  i: integer;
begin
  cbPropertyStyle.Clear;
  for i := 0 to PROPERTY_STYLE_COUNT - 1 do
    cbPropertyStyle.Items.Add(TController.getPropertyStyleString(TPropertyStyle(i)));
  cbPropertyStyle.ItemIndex := 0;
end;

procedure TApplicationGUIForm.iniTechnoList;
var
  i: integer;
begin
  cbTechno.Clear;
  for i := 0 to TECHNO_TYPE_COUNT - 1 do
    cbTechno.Items.Add(TController.getTechnoString(TTechnoType(i)));
  cbTechno.ItemIndex := 0;
end;

procedure TApplicationGUIForm.selectRowIndex(const aIndex: integer);
begin
  if (aIndex < sgProperties.RowCount) and (aIndex > 0) then
  begin
    sgProperties.Selection := TGridRect(Rect(0,
                                             aIndex,
                                             1,
                                             aIndex));
  end
  else
  begin
    gridDeselectAll;
  end;
end;

function TApplicationGUIForm.selectTheFoundedProperty: boolean;
var
  index: integer;
begin
  result := false;
  if edPropertyName.Text <> '' then
  begin
    index := TController.propertyExists(edPropertyName.Text, FClassGenerator);
    if index > -1 then
      selectRowIndex(index + 1);
  end;
end;

procedure TApplicationGUIForm.sgPropertiesClick(Sender: TObject);
begin
  updateControlsWithGridSelection;
end;

procedure TApplicationGUIForm.updateControlsWithGridSelection;
var
  vIndex: integer;
  vProperty: TProperty;
begin
  if sgProperties.Row > 0 then
  begin
    vIndex := sgProperties.Row - 1;
    if TController.propertyExists(vIndex, FClassGenerator) then
    begin
      vProperty := FClassGenerator.properties.Items[vIndex];
      edPropertyName.Text := vProperty.name;
      cbPropertyStyle.ItemIndex := ord(vProperty.style);
    end;
  end;
end;

procedure TApplicationGUIForm.sgPropertiesDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  cLeftGap: word = 5;
  cTopGap: word = 5;
begin
  // titles of the columns
  if (ACol < sgProperties.FixedCols) or (ARow < sgProperties.FixedRows) then
    begin
      sgProperties.Canvas.Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
      if aCol = 0 then
        sgProperties.Canvas.TextOut(rect.left + cLeftGap, rect.top + cTopGap,PROPERTY_COLUMN_TITLE)
      else
      if aCol = 1 then
        sgProperties.Canvas.TextOut(rect.left + cLeftGap, rect.top + cTopGap,TYPE_COLUMN_TITLE);
    end;
end;

procedure TApplicationGUIForm.sgPropertiesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  vIndexProperty: integer;
  vbMove: boolean;
begin
  vbMove := false;
  vIndexProperty := sgProperties.Row-1;
  if Shift = [ssCtrl] then
  begin
    if Key = VK_UP then
    begin
      if sgProperties.Row > 1 then
      begin
        FClassGenerator.properties.Move(vIndexProperty, vIndexProperty - 1);
        dec(vIndexProperty);
        vbMove := true;
      end;
    end
    else
    if Key = VK_DOWN then
    begin
      if sgProperties.Row < sgProperties.RowCount - 1 then
      begin
        FClassGenerator.properties.Move(vIndexProperty, vIndexProperty + 1);
        inc(vIndexProperty);
        vbMove := true;
      end;
    end;
  end;
  if vbMove then
  begin
    clearAndFillGrid;
    selectRowIndex(vIndexProperty + 1);
  end;
end;

end.
