unit MacOSAppMenu;

{$mode delphi}{$H+}
{$ifdef LCLCocoa}{$modeswitch objectivec2}{$endif}

interface

uses
  {$ifdef LCLCocoa}
  CocoaAll,
  {$endif}
  Classes, SysUtils, LCLClasses, Menus, Forms;

type

  { TMacOSAppMenu }

  TMacOSAppMenu = class(TLCLComponent)
  private
    fAboutMenuItem   : TMenuItem;
    fAboutInstalled  : Boolean;
    fExitMenuItem    : TMenuItem;
    fPrefMenuItem    : TMenuItem;
    procedure SetAboutMenuItem(AValue: TMenuItem);
    procedure SetExitMenuItem(AValue: TMenuItem);
    procedure SetPrefMenuItem(AValue: TMenuItem);
  protected
    procedure UpdateMenu;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AboutMenuItem: TMenuItem read fAboutMenuItem write SetAboutMenuItem;
    property PreferncesMenuItem: TMenuItem read fPrefMenuItem write SetPrefMenuItem;
    property ExitMenuItem: TMenuItem read fExitMenuItem write SetExitMenuItem;
  end;

implementation

{ TMacOSAppMenu }

procedure TMacOSAppMenu.SetAboutMenuItem(AValue: TMenuItem);
begin
  if fAboutMenuItem=AValue then Exit;
  fAboutMenuItem:=AValue;
  UpdateMenu;
end;

procedure TMacOSAppMenu.SetExitMenuItem(AValue: TMenuItem);
begin
  if fExitMenuItem=AValue then Exit;
  fExitMenuItem:=AValue;
  UpdateMenu;
end;

procedure TMacOSAppMenu.SetPrefMenuItem(AValue: TMenuItem);
begin
  if fPrefMenuItem=AValue then Exit;
  fPrefMenuItem:=AValue;
  UpdateMenu;
end;

constructor TMacOSAppMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$ifdef LCLCocoa}
  //win := ComponentToNSWindow(Owner);
  writeln('TMacOSAppMenu.Create - creating');
  UpdateMenu;
  {$endif}
end;

{$ifdef LCLCocoa}
type
  NSMenuFix = objccategory external (NSMenu)
    function itemAtIndex(index: NSInteger): NSMenuItem; message 'itemAtIndex:'; // missing in NSMenu. available since 10.0
  end;

procedure InstallAbout;
var
  menu    : NSMenu;
  abtStr  : NSString;
  abtMenu : NSMenuItem;
begin
  writeln('installing about');
  menu := NSApplication.sharedApplication.mainMenu.itemAtIndex(0).submenu;
  writeln('allocating');

  abtStr := NSString.stringWithUTF8String('About');
  abtMenu := menu.itemWithTitle(abtStr);
  if Assigned(abtMenu) then begin
    writeln('allocated');
    //todo:
  end;

{NSString *prefsTitle = [NSString stringWithFormat:@"Preferences%C", (unichar)0x2026];
NSMenuItem *prefsMenuItem = [menu itemWithTitle:prefsTitle];
if (prefsMenuItem)}
{
    [prefsMenuItem setTarget:self];
    [prefsMenuItem setAction:@selector(openPreferences:)];
}

end;
{$endif}

procedure TMacOSAppMenu.UpdateMenu;
begin
  {$ifndef LCLCocoa}
  Exit; // non-cocoa - do nothing
  {$else}
  if not Assigned(Owner) then Exit;
  if (csDesigning in Owner.ComponentState) then Exit;

  if Assigned(fAboutMenuItem) and fAboutMenuItem.Visible then begin
    fAboutMenuItem.Visible := false;
    InstallAbout;
  end;
  {$endif}
end;

type

  { TMacOSAppMenuHandlers }

  TMacOSAppMenuHandlers = class(TObject)
  public
    class procedure FormAdded(Sender: TObject; Form: TCustomForm);
  end;

{ TMacOSAppMenuHandlers }

class procedure TMacOSAppMenuHandlers.FormAdded(Sender: TObject;
  Form: TCustomForm);
begin
end;

procedure initHandler;
begin
  Screen.AddHandlerFormAdded(TMacOSAppMenuHandlers.FormAdded, false);
end;

initialization
  {$ifdef LCLCocoa}
  //initHandler;
  {$endif}

end.

