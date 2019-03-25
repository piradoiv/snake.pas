unit SnakeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Coords, Crt, VidUtils;

const
  HEAD_COLOR = Black;
  BODY_COLOR = Black;
  BODY_ALT_COLOR = Red;
  GROW_AMOUNT_ON_START = 3;
  GROW_AMOUNT_ON_EAT = 6;

type

  { TSnake }

  TSnake = class
  private
    PendingGrow: integer;
    FTail: TPositionArray;
  public
    Direction: TDirection;
    Position: TPosition;
    constructor Create;
    destructor Destroy; override;
    procedure Move;
    procedure Draw;
    procedure Grow;
    procedure CleanTail;
  published
    property Tail: TPositionArray read FTail;
  end;

implementation

constructor TSnake.Create;
begin
  Direction := drEast;
  CleanTail;
end;

destructor TSnake.Destroy;
begin
  inherited Destroy;
end;

procedure TSnake.Move;
var
  I, J: integer;
begin
  J := 1;
  if PendingGrow > 0 then
  begin
    Dec(PendingGrow);
    SetLength(FTail, Length(Tail) + 1);
    J := 0;
  end;

  for I := Low(Tail) to High(Tail) do
    if I = High(Tail) then
      Tail[I] := Position
    else
      Tail[I] := Tail[I + J];

  case Direction of
    drNorth: Dec(Position.Y);
    drSouth: Inc(Position.Y);
    drEast: Inc(Position.X);
    drWest: Dec(Position.X);
  end;
end;

procedure TSnake.Draw;
var
  I: integer;
begin
  TextColor(HEAD_COLOR);
  TextBackground(HEAD_COLOR);
  TextOut(Position.X, Position.Y, ' ');

  for I := Low(Tail) to High(Tail) do
  begin
    TextBackground(BODY_COLOR);
    if I mod 2 = 0 then
      TextBackground(BODY_ALT_COLOR);
    TextOut(Tail[I].X, Tail[I].Y, ' ');
  end;
end;

procedure TSnake.Grow;
begin
  Inc(PendingGrow, GROW_AMOUNT_ON_EAT);
end;

procedure TSnake.CleanTail;
begin
  SetLength(FTail, 0);
  PendingGrow := GROW_AMOUNT_ON_START;
end;

end.

