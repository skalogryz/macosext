unit macOSFormProp;

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

  { TmacOSFormProp }

  TmacOSFormProp = class(TLCLComponent)
  private
    fAppearance : String;
    fDocEdited: Boolean;
  protected
    procedure SetApparance(const AAppearance: String);
    procedure SetDocEdited(ADocEdited: Boolean);
  published
    constructor Create(AOwner: TComponent); override;
    property Appearance: string read fAppearance write SetApparance;
    property DocEdited: Boolean read fDocEdited write SetDocEdited;
  end;

implementation

{ TmacOSFormProp }

{$ifdef LCLCocoa}
// https://developer.apple.com/documentation/appkit/nsappearance?language=objc
// NSAppearanceNameAqua
// NSAppearanceNameLightContent (deprecated)
// NSAppearanceNameVibrantDark
// NSAppearanceNameVibrantLight

const
  _SEL_AN: SEL = nil;
  _SEL_W:  SEL = nil;
  _SEL_SA: SEL = nil;

function ComponentToNSWindow(Owner: TComponent): NSWindow;
var
  obj : NSObject;
begin
  Result := nil;
  if not Assigned(Owner) or not (Owner is TWinControl) then Exit;

  obj := NSObject(TWinControl(Owner).Handle);
  if not Assigned(obj) then Exit;

  if not Assigned(_SEL_W) then
    _SEL_W := NSSelectorFromString(NSSTR('window'));
  if obj.respondsToSelector(_SEL_W) then
    Result := objc_msgSend(obj, _SEL_W);
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

  if not Assigned(_SEL_AN) then
    _SEL_AN := NSSelectorFromString(NSSTR('appearanceNamed:'));

  apr := objc_msgSend(cls, _SEL_AN, NSSTR(@ap[1]));
  if not Assigned(apr) then Exit;

  if not Assigned(_SEL_SA) then
    _SEL_SA := NSSelectorFromString(NSSTR('setAppearance:'));

  if win.respondsToSelector(_SEL_SA) then
  begin
    objc_msgSend(win, _SEL_SA, apr);
    Result := true;
  end;
end;
{$endif}

procedure TmacOSFormProp.SetApparance(const AAppearance: String);
begin
  if fAppearance = AAppearance then Exit;
  fAppearance := AAppearance;
  {$ifdef LCLCocoa}
  UpdateAppearance(Owner, AAppearance);
  {$endif}
end;

procedure TmacOSFormProp.SetDocEdited(ADocEdited: Boolean);
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

constructor TmacOSFormProp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fAppearance := 'NSAppearanceNameAqua';
end;

end.
