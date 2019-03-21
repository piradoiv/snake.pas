program ProjectSnake;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  Game;

var
  Application: TSnakeApplication;
begin
  Application := TSnakeApplication.Create(nil);
  Application.Title := 'Snake';
  Application.Run;
  Application.Free;
end.
