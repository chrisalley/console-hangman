{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

unit UMain;

interface

uses
  SysUtils,
  UConstantsAndTypes,
  UInputAndOutput,
  UDatabaseOperations,
  UGameLogic,
  UShowMessage;

procedure PlayGame(DifficultyLevel: TDifficultyLevel);
procedure SetDifficultyLevel(var DifficultyLevel: TDifficultyLevel);
procedure DoGameMenuChoice(var DifficultyLevel: TDifficultyLevel);
procedure DoMainMenuChoice;

implementation

procedure PlayGame(DifficultyLevel: TDifficultyLevel);
{ The main procedure that controls what happens in the game. This procedure }
{ first opens or creates a database, then gets the players name and sets up }
{ the game so that everything is set to default. After that, the game begins }
{ and keeps repeating in a loop until the game is either won or lost. The }
{ program then calls a procedure that displays the results and update's the }
{ player's record. }
var
  GameRecord: TGameRecord;
  PlayerFile: TPlayerFile;
begin
  CreateOrOpenFile(PlayerFile);
  GameRecord := GetPlayerRecord(PlayerFile, GameRecord);
  GameRecord.PlayerRecord.DateLastPlayed := Now;
  Flush(PlayerFile, GameRecord.PlayerRecord);
  GameRecord.DifficultyLevel := DifficultyLevel;
  GameRecord.MysteryWord := GetRandomWord(GameRecord);
  GameRecord.IncorrectGuessesLeft := SetAllowableIncorrectGuesses;
  GameRecord.AvailableLetters := SetAvailableLettersToDefault;
  GameRecord.UsedLetters := SetUsedLettersToDefault;
  GameRecord.UsedLetters := AddVowelsToUsedLetters(GameRecord);
  UpdateSets(GameRecord);
  GameRecord.CurrentStateOfMysteryWord :=
    UpdateCurrentStateOfMysteryWord(GameRecord);
  GameRecord.GameStatus := Running;
  repeat
    repeat
      DisplayGameInterface(GameRecord);
      GameRecord.GuessedLetter := GetLetterFromUser(GameRecord);
    until CheckValidityOfGuessedLetter(GameRecord, GameRecord.GuessedLetter) =
      True;
    UpdateSets(GameRecord);
    GameRecord.CurrentStateOfMysteryWord :=
      UpdateCurrentStateOfMysteryWord(GameRecord);
    if CheckIfGuessedLetterIsInMysteryWord(GameRecord) = False then
      GameRecord.IncorrectGuessesLeft :=
        DecrementIncorrectGuessesLeftByOne(GameRecord);
    if CheckIfPlayerHasWon(GameRecord) = True then
      GameRecord.GameStatus := Won;
    if GameRecord.IncorrectGuessesLeft = 0 then
      GameRecord.GameStatus := Lost;
  until (GameRecord.GameStatus = Won) or (GameRecord.GameStatus = Lost);
  GameRecord.PlayerRecord.NumberOfGamesPlayed :=
    GameRecord.PlayerRecord.NumberOfGamesPlayed + 1;
  DisplayGameResults(PlayerFile, GameRecord);
  UpdateRecord(PlayerFile, GameRecord.PlayerRecord);
  closefile(PlayerFile);
end;

procedure ViewOrPrintReport;
{ A menu procedure that does whatever the user chooses to do in the }
{ GetViewOrPrintReportMenuChoice function. }
var
  PlayerFile: TPlayerFile;
begin
  CreateOrOpenFile(PlayerFile);
  repeat
    case GetViewOrPrintReportMenuChoice of
      vprmViewReport       : ViewReport(PlayerFile);
      vprmPrintReport      : PrintReport(PlayerFile);
      vprmReturnToMainMenu : break;
    end;
  until False;
end;

procedure SetDifficultyLevel(var DifficultyLevel: TDifficultyLevel);
{ A menu procedure that does whatever the user chooses to do in the }
{ GetDifficultyLevelMenuChoice function. }
begin
  case GetDifficultyLevelMenuChoice of
    dlmEasy      : DifficultyLevel := Easy;
    dlmMedium    : DifficultyLevel := Medium;
    dlmDifficult : DifficultyLevel := Difficult;
  end;
  ShowMessage('The difficulty level has been updated.');
  ContinueProgram;
end;

procedure DoGameMenuChoice(var DifficultyLevel: TDifficultyLevel);
{ A menu procedure that does whatever the user chooses to do in the }
{ GetGameMenuChoice function. }
begin
  repeat
    case GetGameMenuChoice of
      gmStartGame             : PlayGame(DifficultyLevel);
      gmSelectDifficultyLevel : SetDifficultyLevel(DifficultyLevel);
      gmViewOrPrintReport     : ViewOrPrintReport;
      gmReturnToMainMenu      : break;
    end;
  until False;
end;

procedure DoMainMenuChoice;
{ A menu procedure that does whatever the user chooses to do in the }
{ GetMainMenuChoice function. }
var
  DifficultyLevel: TDifficultyLevel;
begin
  DifficultyLevel := Easy;
  repeat
    case GetMainMenuChoice of
      mmPlayGame           : DoGameMenuChoice(DifficultyLevel);
      mmDisplayAboutScreen : DisplayAboutScreen;
      mmQuitProgram        : break;
    end;
  until False;
end;

end.
