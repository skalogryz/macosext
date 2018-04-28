unit MacOSFormProp;

{$mode delphi}{$H+}
{$ifdef LCLCocoa}
{$modeswitch objectivec1}
{$endif}

interface

uses
  {$ifdef LCLCocoa}CocoaAll,{$endif}
  Classes, SysUtils, Controls, LCLClasses;

const
  macOSNSAppearanceNameAqua = 'NSAppearanceNameAqua';
  DefaultAppearance = macOSNSAppearanceNameAqua;
  macOSNSAppearanceNameVibrantDark = 'NSAppearanceNameVibrantDark';
  macOSNSAppearanceNameVibrantLight = 'NSAppearanceNameVibrantLight';

type

  { TMacOSFormProp }

  TMacOSFormProp = class(TLCLComponent)
  private
    fAppearance : String;
    fDocEdited: Boolean;
  protected
    procedure SetApparance(const AAppearance: String);
    procedure SetDocEdited(ADocEdited: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Appearance: string read fAppearance write SetApparance;
    property DocEdited: Boolean read fDocEdited write SetDocEdited;
  end;

implementation

{ TMacOSFormProp }

{$ifdef LCLCocoa}
// https://developer.apple.com/documentation/appkit/nsappearance?language=objc
// NSAppearanceNameAqua
// NSAppearanceNameLightContent (deprecated)
// NSAppearanceNameVibrantDark
// NSAppearanceNameVibrantLight

function ComponentToNSWindow(Owner: TComponent): NSWindow;
var
  obj : NSObject;
begin
  Result := nil;
  if not Assigned(Owner) or not (Owner is TWinControl) then Exit;

  obj := NSObject(TWinControl(Owner).Handle);
  if not Assigned(obj) then Exit;

  if obj.respondsToSelector(ObjCSelector('window')) then
    Result := objc_msgSend(obj, ObjCSelector('window'));
end;

function UpdateAppearance(Owner: TComponent; const AAppearance: String): Boolean;
var
  cls : id;
  ap  : string;
  apr : id;
  win : NSWindow;
begin
  Result := false;

  win := ComponentToNSWindow(Owner);
  if not Assigned(win) then Exit;

  if AAppearance = ''
    then ap := DefaultAppearance
    else ap := AAppearance;

  cls := NSClassFromString( NSSTR('NSAppearance'));
  if not Assigned(cls) then Exit; // not suppored in OSX version

  apr := objc_msgSend(cls, ObjCSelector('appearanceNamed:'), NSSTR(@ap[1]));
  if not Assigned(apr) then Exit;

  if win.respondsToSelector(ObjCSelector('setAppearance:')) then
  begin
    objc_msgSend(win, ObjCSelector('setAppearance:'), apr);
    Result := true;
  end;
end;
{$endif}

procedure TMacOSFormProp.SetApparance(const AAppearance: String);
begin
  if fAppearance = AAppearance then Exit;
  fAppearance := AAppearance;
  {$ifdef LCLCocoa}
  UpdateAppearance(Owner, AAppearance);
  {$endif}
end;

procedure TMacOSFormProp.SetDocEdited(ADocEdited: Boolean);
{$ifdef LCLCocoa}
var
  win : NSWindow;
{$endif}
begin
  fDocEdited := ADocEdited;
  {$ifdef LCLCocoa}
  win := ComponentToNSWindow(Owner);
  if Assigned(win) then win.setDocumentEdited(ADocEdited);
  {$endif}
end;

constructor TMacOSFormProp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fAppearance := 'NSAppearanceNameAqua';
end;

end.
