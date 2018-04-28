unit macosuiproc;

{$mode objfpc}{$H+}
{$ifdef LCLCocoa}
{$modeswitch objectivec2}
{$endif}

interface

uses
  {$ifdef LCLCocoa}
  CocoaAll,
  {$endif}
  Classes, SysUtils, Forms, LCLType
  {$ifdef LCLCocoa}
  ,CocoaInt, CocoaUtils
  {$endif}
  ;

//function PromptUserSheet(const DialogMessage : String; DialogType : longint; Buttons : Array of Longint; DefaultIndex, EscapeResult : Longint) : Longint; overload;
//function PromptUserSheet(const DialogMessage : String; DialogType : longint; Buttons : PLongint; ButtonCount, DefaultIndex, EscapeResult : Longint) : Longint; overload;
procedure PromptUserSheet(const DialogCaption, DialogMessage : String;
  DialogType : longint; const Buttons : Array of Longint; DefaultIndex: Integer;
  AParentForm: TCustomForm); overload;
procedure PromptUserSheet(const DialogCaption, DialogMessage : String;
  DialogType : longint; AParentForm: TCustomForm); overload;
procedure PromptUserSheet(const DialogCaption, DialogMessage : String; AParentForm: TCustomForm); overload;

implementation

{function PromptUserSheet(const DialogMessage: String; DialogType: longint;
  Buttons: array of Longint; DefaultIndex, EscapeResult: Longint): Longint;
begin
  Result := PromptUserSheet('', DialogMessage, DialogType, Buttons, length(Buttons), DefaultIndex, EscapeResult);
end;

function PromptUserSheet(const DialogMessage: String; DialogType: longint;
  Buttons: PLongint; ButtonCount, DefaultIndex, EscapeResult: Longint): Longint;
begin
  Result := PromptUserSheet('', DialogMessage, DialogType, Buttons, ButtonCount, DefaultIndex, EscapeResult);
end; }

procedure PromptUserSheet(const DialogCaption, DialogMessage: String;
  DialogType: longint; const Buttons: array of Longint; DefaultIndex: Longint;
  AParentForm: TCustomForm);
var
  btn : PLongint;
  bc  : Integer;
  {$ifdef LCLCocoa}
  win : NSWindow;
  {$endif}
begin
  btn := nil;
  bc := length(Buttons);
  if (bc>0) then btn:=@Buttons[0];

  {$ifdef LCLCocoa}
  win := nil;
  if Assigned(AParentForm) then
  begin
    if not AParentForm.HandleAllocated then Exit;
    win := NSView(AParentForm.Handle).window;
  end
  else
    win := NSApplication.sharedApplication.keyWindow;

  if Assigned(win) then
    CocoaPromptUser(DialogCaption, DialogMessage
      ,DialogType, btn, bc, DefaultIndex, 0, win);
  {$endif}
end;

procedure PromptUserSheet(const DialogCaption, DialogMessage : String;
  DialogType : longint; AParentForm: TCustomForm); overload;
begin
  PromptUserSheet(DialogCaption, DialogMessage, DialogType, [idButtonOk], 0, AParentForm);
end;

procedure PromptUserSheet(const DialogCaption, DialogMessage : String; AParentForm: TCustomForm); overload;
begin
  PromptUserSheet(DialogCaption, DialogMessage, idDialogInfo, [idButtonOk], 0, AParentForm);
end;

end.

