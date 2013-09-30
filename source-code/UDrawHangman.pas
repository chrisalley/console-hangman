{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

unit UDrawHangman;

interface

uses
  UConstantsAndTypes;

procedure DisplayPicture0;
procedure DisplayPicture1;
procedure DisplayPicture2;
procedure DisplayPicture3;
procedure DisplayPicture4;
procedure DisplayPicture5;
procedure DisplayPicture6;
procedure DisplayPicture7;
procedure DisplayPicture8;
procedure DisplayPicture9;
procedure DisplayHangman(GameRecord: TGameRecord);

implementation

procedure DisplayPicture0;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                   O  ');
  writeln('*  |                  -|- ');
  writeln('*  |                   |  ');
  writeln('*  |                  / \ ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture1;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                   O  ');
  writeln('*  |                  -|- ');
  writeln('*  |                   |  ');
  writeln('*  |                  /   ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture2;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                   O  ');
  writeln('*  |                  -|- ');
  writeln('*  |                   |  ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture3;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                   O  ');
  writeln('*  |                  -|- ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture4;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                   O  ');
  writeln('*  |                  -|  ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture5;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                   O  ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture6;
begin
  writeln('*  +-------------------+  ');
  writeln('*  |                   |  ');
  writeln('*  |                   |  ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture7;
begin
  writeln('*  +-------------------   ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture8;
begin
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  |                      ');
  writeln('*  +----------------------');
end;

procedure DisplayPicture9;
begin
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*  -----------------------');
end;

procedure DisplayPicture10;
begin
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
  writeln('*                         ');
end;

procedure DisplayHangman(GameRecord: TGameRecord);
begin
  case GameRecord.IncorrectGuessesLeft of
    0: DisplayPicture0;
    1: DisplayPicture1;
    2: DisplayPicture2;
    3: DisplayPicture3;
    4: DisplayPicture4;
    5: DisplayPicture5;
    6: DisplayPicture6;
    7: DisplayPicture7;
    8: DisplayPicture8;
    9: DisplayPicture9;
    10: DisplayPicture10;
  end;
end;

end.
