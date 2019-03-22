unit SnakeUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Coords, Crt;

const
  SPRITES: array[0..3] of string = ('∧', '>', 'V', '<');

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
  published
    property Tail: TPositionArray read FTail;
  end;

implementation

constructor TSnake.Create;
begin
  Direction := drEast;
  PendingGrow := 3;
end;

destructor TSnake.Destroy;
begin
  inherited Destroy;
end;

procedure TSnake.Move;
var
  I, J: integer;
  Growing: boolean;
begin
  J := 1;
  Growing := PendingGrow > 0;
  if Growing then
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
  TailPos: TPosition;
begin
  TextColor(Black);

  GotoXY(Position.X, Position.Y);
  Write(SPRITES[Ord(Direction)]);

  for TailPos in Tail do
  begin
    GotoXY(TailPos.X, TailPos.Y);
    Write('S');
  end;
end;

procedure TSnake.Grow;
begin
  Inc(PendingGrow, 6);
end;

end.

