unit Game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CustApp, SnakeUnit, Coords, Crt, VidUtils;

const
  DELAY_SPEED = 150;
  MIN_DELAY = 75;

  VK_UP = #72;
  VK_DOWN = #80;
  VK_RIGHT = #77;
  VK_LEFT = #75;
  VK_ESC = #27;
  VK_ENTER = #13;

type

  TGameState = (gsWelcome, gsStartGame, gsPlaying, gsGameOver, gsTerminate);

  { TSnakeApplication }

  TSnakeApplication = class(TCustomApplication)
  private
    State: TGameState;
    Snake: TSnake;
    Apple: TPosition;
    procedure DoWelcomeScreen;
    procedure DoPlayingScreen;
    procedure DoGameOverScreen;
    procedure Draw;
    procedure DrawApple;
    procedure GameCheckCollitions;
    procedure HandleGameKeyEvents;
    procedure MoveAppleToRandomPosition;
    procedure StartGame;
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

procedure TSnakeApplication.DoWelcomeScreen;
begin
  State := gsStartGame;
  TextBackground(Green);
  ClearScreen;
  TextColor(Black);

  TextOutCentered([
    'Snake!',
    '-----------',
    'Use arrow keys to move',
    'Press any key to start'
  ]);

  ReadKey;
end;

procedure TSnakeApplication.DoGameOverScreen;
var
  C: Char;
begin
  TextBackground(Red);
  TextColor(White);
  ClearScreen;

  TextOutCentered([
    'Game over! :-(',
    '--------------',
    'Press ENTER to play again, or ESC to exit'
  ]);

  repeat
    C := ReadKey;
    case C of
      VK_ESC: State := gsTerminate;
      VK_ENTER: State := gsStartGame;
    end;
  until State <> gsGameOver;
end;

procedure TSnakeApplication.DoPlayingScreen;
var
  CalculatedDelay: integer;
begin
  HandleGameKeyEvents;
  Snake.Move;
  GameCheckCollitions;
  if State = gsGameOver then
    Exit;

  Draw;

  CalculatedDelay := DELAY_SPEED - (Length(Snake.Tail) * 2);
  if CalculatedDelay < MIN_DELAY then
    CalculatedDelay := MIN_DELAY;

  Delay(CalculatedDelay);
end;

procedure TSnakeApplication.Draw;
begin
  TextBackground(Green);
  TextColor(Green);
  CursorOff;
  ClearScreen;

  Snake.Draw;
  DrawApple;

  GotoXY(1, ScreenHeight);
end;

procedure TSnakeApplication.DrawApple;
begin
  TextColor(Red);
  TextBackground(Green);
  TextOut(Apple.X, Apple.Y, '@');
end;

procedure TSnakeApplication.GameCheckCollitions;
var
  Position: TPosition;
begin
  if (Snake.Position.X <= 0) or (Snake.Position.X > ScreenWidth) or
    (Snake.Position.Y <= 0) or (Snake.Position.Y > ScreenHeight) then
    State := gsGameOver;

  for Position in Snake.Tail do
    if (Snake.Position.X = Position.X) and (Snake.Position.Y = Position.Y) then
      State := gsGameOver;

  if (Snake.Position.X = Apple.X) and (Snake.Position.Y = Apple.Y) then
  begin
    Snake.Grow;
    MoveAppleToRandomPosition;
  end;
end;

procedure TSnakeApplication.HandleGameKeyEvents;
var
  PressedKey: char;
  Direction: TDirection;
begin
  if not KeyPressed then
    Exit;

  Direction := Snake.Direction;
  while KeyPressed do
  begin
    PressedKey := ReadKey;
    case PressedKey of
      VK_UP: if Direction <> drSouth then
          Snake.Direction := drNorth;
      VK_DOWN: if Direction <> drNorth then
          Snake.Direction := drSouth;
      VK_RIGHT: if Direction <> drWest then
          Snake.Direction := drEast;
      VK_LEFT: if Direction <> drEast then
          Snake.Direction := drWest;
      VK_ESC: Terminate;
    end;
  end;
end;

procedure TSnakeApplication.MoveAppleToRandomPosition;
const
  PADDING = 5;
begin
  Apple.X := PADDING + Random(ScreenWidth - PADDING);
  Apple.Y := PADDING + Random(ScreenHeight - PADDING);
end;

procedure TSnakeApplication.StartGame;
begin
  State := gsPlaying;
  MoveAppleToRandomPosition;
  Snake.Direction := drEast;
  Snake.Position.X := Round(ScreenWidth / 2);
  Snake.Position.Y := Round(ScreenHeight / 2);
  Snake.CleanTail;
end;

procedure TSnakeApplication.DoRun;
begin
  RefreshWindowSize;
  case State of
    gsWelcome: DoWelcomeScreen;
    gsStartGame: StartGame;
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
  Snake := TSnake.Create;
  State := gsWelcome;
end;

destructor TSnakeApplication.Destroy;
begin
  NormVideo;
  CursorOn;
  ClearScreen;
  Snake.Free;
  inherited Destroy;
end;

end.
