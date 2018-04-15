unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  macOSFormProp;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    macOSFormProp1: TmacOSFormProp;
    Memo1: TMemo;
    ScrollBar1: TScrollBar;
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

end.

