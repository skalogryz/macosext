unit Unit1;

{$mode objfpc}{$H+}
{$modeswitch objectivec1}

interface

uses
  CocoaAll,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  macOSFormProp;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    macOSFormProp1: TmacOSFormProp;
    Memo1: TMemo;
    ScrollBar1: TScrollBar;
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if macOSFormProp1.Appearance <> macOSNSAppearanceNameVibrantDark
    then macOSFormProp1.Appearance := macOSNSAppearanceNameVibrantDark
    else macOSFormProp1.Appearance := macOSNSAppearanceNameAqua;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  bar : NSToolbar;
  sub : NSToolbarItem;
begin
  bar := NSToolbar(NSToolbar(NSToolbar.alloc).initWithIdentifier(NSSTR('tool')));

  sub := NSToolbarItem(NSToolbarItem.alloc).initWithItemIdentifier(NSSTR('id1'));
  sub.autorelease;

  sub.setLabel(NSSTR('hello world'));
  sub.setPaletteLabel(NSSTR('pal hello world');



  //bar.setShowsBaselineSeparator(false);
  NSView(Self.Handle).window.setToolbar(bar);
  //bar.insertItemWithItemIdentifier_atIndex
end;

end.

