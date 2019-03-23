unit VidUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Crt;

procedure TextOut(X, Y: integer; Text: string);
procedure TextOutCentered(Lines: array of const);

implementation

procedure TextOut(X, Y: integer; Text: string);
begin
  GotoXY(X, Y);
  Write(Text);
end;

procedure TextOutCentered(Lines: array of const);
var
  I, X, Y: integer;
  Line: string;
begin
  for I := Low(Lines) to High(Lines) do
  begin
    Line := String(Lines[I].VString);
    X := Round((ScreenWidth / 2) - (Length(Line) / 2));
    Y := Round(ScreenHeight / 2) + I - 1;
    TextOut(X, Y, Line);
  end;
  GotoXY(ScreenWidth, ScreenHeight);
end;

end.
