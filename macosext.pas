{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit macosext;

{$warn 5023 off : no warning about unused units}
interface

uses
  macosextreg, MacOSAppMenu, macosuiproc, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('macosextreg', @macosextreg.Register);
end;

initialization
  RegisterPackage('macosext', @Register);
end.
