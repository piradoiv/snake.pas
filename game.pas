unit Game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CustApp, SnakeUnit, Coords, Crt;

const
  SPEED = 150;

type

  TGameState = (gsWelcome, gsPlaying, gsGameOver);

  TSnakeApplication = class(TCustomApplication)
  private
    State: TGameState;
    Snake: TSnake;
    Apple: TPosition;
    procedure DoWelcomeScreen;
    procedure DoPlayingScreen;
    procedure DoGameOverScreen;
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

procedure TSnakeApplication.DoWelcomeScreen;
var
  I: integer;
  Line: string;
  Lines: array of string;
begin
  State := gsPlaying;
  TextBackground(Green);
  ClrScr;
  TextColor(Black);

  SetLength(Lines, 4);
  Lines[0] := 'Snake!';
  Lines[1] := '-----------';
  Lines[2] := '(j) up / (k) down / (h) left / (l) right';
  Lines[3] := 'Press any key to start';

  for I := Low(Lines) to High(Lines) do
  begin
    Line := Lines[I];
    GotoXY(
      Round((ScreenWidth / 2) - (Length(Line) / 2)),
      Round(ScreenHeight / 2) + I - 1
      );
    Writeln(Line);
  end;

  ReadKey;
end;

procedure TSnakeApplication.DoPlayingScreen;
var
  PressedKey: char;
  Position: TPosition;
  CalculatedDelay: integer;
begin
  if KeyPressed then
    while KeyPressed do
    begin
      PressedKey := ReadKey;
      case PressedKey of
        'j': if Snake.Direction <> drSouth then Snake.Direction := drNorth;
        'k': if Snake.Direction <> drNorth then Snake.Direction := drSouth;
        'l': if Snake.Direction <> drWest then Snake.Direction := drEast;
        'h': if Snake.Direction <> drEast then Snake.Direction := drWest;
      end;
    end;

  Snake.Move;

  if (Snake.Position.X <= 0) or (Snake.Position.X > ScreenWidth) or
    (Snake.Position.Y <= 0) or (Snake.Position.Y > ScreenHeight) then
  begin
    State := gsGameOver;
    Exit;
  end;

  for Position in Snake.Tail do
    if (Snake.Position.X = Position.X) and (Snake.Position.Y = Position.Y) then
    begin
      State := gsGameOver;
      Exit;
    end;

  if (Snake.Position.X = Apple.X) and (Snake.Position.Y = Apple.Y) then
  begin
    Snake.Grow;
    Apple.X := Random(ScreenWidth);
    Apple.Y := Random(ScreenHeight);
  end;

  TextBackground(LightGray);
  TextColor(Black);
  ClrScr;

  Snake.Draw;

  GotoXY(Apple.X, Apple.Y);
  TextColor(Red);
  Write('d');

  GotoXY(1, 1);
  CursorOff;

  CalculatedDelay := SPEED - (Length(Snake.Tail) * 2);
  if Snake.Direction in [drNorth, drSouth] then
    Delay(CalculatedDelay * 2)
  else
    Delay(CalculatedDelay);
end;

procedure TSnakeApplication.DoGameOverScreen;
var
  C: char;
begin
  TextBackground(Red);
  TextColor(White);
  ClrScr;
  Writeln('Game over');
  Writeln('Press ''x'' to exit');
  repeat
    C := ReadKey;
  until C = 'x';
  Terminate;
end;

procedure TSnakeApplication.DoRun;
begin
  case State of
    gsWelcome: DoWelcomeScreen;
    gsPlaying: DoPlayingScreen;
    gsGameOver: DoGameOverScreen;
    else
      Terminate;
  end;
end;

constructor TSnakeApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Randomize;
  StopOnException := True;
  State := gsWelcome;
  Snake := TSnake.Create;
  Snake.Position.X := Round(ScreenWidth / 2);
  Snake.Position.Y := Round(ScreenHeight / 2);

  Apple.X := Random(ScreenWidth);
  Apple.Y := Random(ScreenHeight);
end;

destructor TSnakeApplication.Destroy;
begin
  NormVideo;
  CursorOn;
  ClrScr;
  Snake.Free;
  inherited Destroy;
end;

end.

