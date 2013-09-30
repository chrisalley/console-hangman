{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

unit UDatabaseOperations;

interface

uses
  SysUtils,
  UConstantsAndTypes;

procedure CreateOrOpenFile(var PlayerFile: TPlayerFile);
function ReadRecordFromFile(var PlayerFile: TPlayerFile): TPlayerRecord;
procedure AddNewRecordToFile(var PlayerFile: TPlayerFile;
  var PlayerRecord: TPlayerRecord);
procedure UpdateRecord(var PlayerFile: TPlayerFile;
  PlayerRecord: TPlayerRecord);
procedure Flush(var PlayerFile: TPlayerFile; PlayerRecord: TPlayerRecord);

implementation

procedure CreateOrOpenFile(var PlayerFile: TPlayerFile);
begin
  if fileexists(PlayerFilePath) then
  begin
    assignfile(PlayerFile, PlayerFilePath);
    reset(PlayerFile);
  end
  else
  begin
    assignfile(PlayerFile, PlayerFilePath);
    rewrite(PlayerFile);
  end;
end;

function ReadRecordFromFile(var PlayerFile: TPlayerFile): TPlayerRecord;
begin
  read(PlayerFile, Result);
end;

procedure AddNewRecordToFile(var PlayerFile: TPlayerFile;
  var PlayerRecord: TPlayerRecord);
begin
  seek(PlayerFile, filesize(PlayerFile));
  PlayerRecord.FilePosition := filesize(PlayerFile);
  write(PlayerFile, PlayerRecord);
end;

procedure UpdateRecord(var PlayerFile: TPlayerFile;
  PlayerRecord: TPlayerRecord);
begin
  seek(PlayerFile, PlayerRecord.FilePosition);
  write(PlayerFile, PlayerRecord);
end;

procedure Flush(var PlayerFile: TPlayerFile; PlayerRecord: TPlayerRecord);
begin
  UpdateRecord(PlayerFile, PlayerRecord);
  closefile(PlayerFile);
  reset(PlayerFile);
end;

end.
