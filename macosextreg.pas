unit macosextreg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, macOSFormProp, PropEdits;

procedure Register;

implementation

type

  { TAppearancePropEditor }

  TAppearancePropEditor = class(TStringPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues({%H-}Proc: TGetStrProc); override;

  end;

procedure Register;
begin
  RegisterComponents('macOS',[TMacOSFormProp]);
  RegisterPropertyEditor( TypeInfo(String), TMacOSFormProp,
    'Appearance', TAppearancePropEditor);
end;

{ TAppearancePropEditor }

function TAppearancePropEditor.GetAttributes: TPropertyAttributes;
begin
  Result:=inherited GetAttributes;
  Result := Result + [paValueList];
end;

procedure TAppearancePropEditor.GetValues(Proc: TGetStrProc);
begin
  Proc(macOSNSAppearanceNameAqua);
  Proc(macOSNSAppearanceNameVibrantDark);
  Proc(macOSNSAppearanceNameVibrantLight);
end;

initialization
  {$i macosextres.lrs}

end.

