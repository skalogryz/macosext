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
  macOSNSAppearanceNameDarkAqua = 'NSAppearanceNameDarkAqua';

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

  if obj.isKindOfClass(NSView) then
    Result := NSView(obj).window;
end;

type
  NSAppearanceInt = NSObject; // declare as alias, rather than a subclass

  NSAppearanceWin = objccategory external (NSResponder)
    procedure setAppearance(app: NSAppearanceInt); message 'setAppearance:';
  end;

  NSAppearanceCat = objccategory external (NSAppearanceInt)
    class function appearanceNamed(app: NSObject): NSAppearanceInt; message 'appearanceNamed:';
  end;

type
  NSAppearanceClass = class of NSAppearanceInt;

function UpdateAppearance(Owner: TComponent; const AAppearance: String): Boolean;
var
  cls : NSAppearanceClass;
  apr : id;
  win : NSWindow;
  nm  : NSString;
begin
  Result := false;

  win := ComponentToNSWindow(Owner);
  if not Assigned(win) then Exit;

  if AAppearance = ''
    then nm := NSSTR(DefaultAppearance) // it's constant
    else nm := NSString.stringWithUTF8String(@AAppearance[1]);

  cls := NSAppearanceClass(NSClassFromString(NSSTR('NSAppearance')));
  if not Assigned(cls) then Exit; // not suppored in OSX version

  // respondesToSelector returns if a class can respond to class methods!
  // BUT, "respondesToSelector" is actually an instance method.
  // in order to get "class instance object" (rather than "instance of a class")
  // once should get cls.classClass object, cast it NSObject and call respondsToSelector
  // from it
  if NSObject(cls.classClass).respondsToSelector(ObjCSelector('appearanceNamed:')) then
    apr := cls.appearanceNamed(nm)
  else
    apr := nil;

  if not Assigned(apr) then Exit;
  win.setAppearance(apr);
  Result := true;
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
