unit Coords;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TDirection = (drNorth, drEast, drSouth, drWest);

  TPosition = object
    X: integer;
    Y: integer;
  end;

  TPositionArray = array of TPosition;

implementation

end.

