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
    macOSFormProp1: TmacOSFormProp;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  macOSFormProp1.DocEdited := not macOSFormProp1.DocEdited;
end;

end.

