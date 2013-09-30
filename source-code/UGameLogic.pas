{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

unit UGameLogic;

{$R+}

interface

uses
  SysUtils,
  UConstantsAndTypes,
  UShowMessage,
  UDatabaseOperations;

function GetDifficultyLevelAsAString(DifficultyLevel: TDifficultyLevel):
  TString20;
procedure UpdateBestScoreAndBestScoreDate(var GameRecord: TGameRecord);
function FindOutIfScoreIsBestScore(var GameRecord: TGameRecord): string;
procedure UpdateChampionDetails(var ChampionRecord: TChampionRecord;
  PlayerRecord: TPlayerRecord);
function WorkOutWhoIsChampion(var PlayerFile: TPlayerFile;
  DifficultyLevel: TDifficultyLevel): TString20;
function GetAmountOfWordsInTextFile(var WordListFile: textfile): integer;
function GetRandomWord(GameRecord: TGameRecord): TString20;
function CheckValidityOfGuessedLetter(GameRecord: TGameRecord;
  GuessedLetter: char): boolean;
procedure UpdateSets(var GameRecord: TGameRecord);
function UpdateCurrentStateOfMysteryWord(GameRecord: TGameRecord): TString20;
function AddVowelsToUsedLetters(GameRecord: TGameRecord): TLetterSet;
function CheckIfGuessedLetterIsInMysteryWord(GameRecord: TGameRecord): boolean;
function CheckIfPlayerHasWon(GameRecord: TGameRecord): boolean;
function DecrementIncorrectGuessesLeftByOne(GameRecord: TGameRecord): integer;
function SetAvailableLettersToDefault: TLetterSet;
function SetUsedLettersToDefault: TLetterSet;
function SetAllowableIncorrectGuesses: integer;

implementation

function GetDifficultyLevelAsAString(DifficultyLevel: TDifficultyLevel):
  TString20;
begin
  case DifficultyLevel of
    Easy: Result := 'Easy';
    Medium: Result := 'Medium';
    Difficult: Result := 'Difficult';
  end;
end;

procedure UpdateBestScoreAndBestScoreDate(var GameRecord: TGameRecord);
begin
  GameRecord.PlayerRecord.BestScore[GameRecord.DifficultyLevel] :=
    GameRecord.IncorrectGuessesLeft;
  GameRecord.PlayerRecord.BestScoreDate[GameRecord.DifficultyLevel] := Now;
end;

function FindOutIfScoreIsBestScore(var GameRecord: TGameRecord): string;
begin
  Result := '';
  if GameRecord.IncorrectGuessesLeft =
    GameRecord.PlayerRecord.BestScore[GameRecord.DifficultyLevel] then
    Result := 'This equals your best score on ' +
      GetDifficultyLevelAsAString(GameRecord.DifficultyLevel);
  if GameRecord.IncorrectGuessesLeft >
    GameRecord.PlayerRecord.BestScore[GameRecord.DifficultyLevel] then
    Result := 'This is your best score yet on ' +
      GetDifficultyLevelAsAString(GameRecord.DifficultyLevel);
end;

procedure UpdateChampionDetails(var ChampionRecord: TChampionRecord;
  PlayerRecord: TPlayerRecord);
begin
  ChampionRecord.Score :=
    PlayerRecord.BestScore[ChampionRecord.DifficultyLevel];
  ChampionRecord.ScoreDate :=
    PlayerRecord.BestScoreDate[ChampionRecord.DifficultyLevel];
  ChampionRecord.FirstName := PlayerRecord.FirstName;
end;

function WorkOutWhoIsChampion(var PlayerFile: TPlayerFile;
  DifficultyLevel: TDifficultyLevel): TString20;
var
  PlayerRecord: TPlayerRecord;
  ChampionRecord: TChampionRecord;
begin
  fillchar(ChampionRecord, sizeof(ChampionRecord), #0);
  ChampionRecord.FirstName := 'Nobody';
  if filesize(PlayerFile) > 0 then
  begin
    seek(PlayerFile, 0);
    PlayerRecord := ReadRecordFromFile(PlayerFile);
    if PlayerRecord.BestScore[DifficultyLevel] > 0 then
      UpdateChampionDetails(ChampionRecord, PlayerRecord);
    seek(PlayerFile, 0);
    while not eof(PlayerFile) do
    begin
      PlayerRecord := ReadRecordFromFile(PlayerFile);
      if (PlayerRecord.BestScore[DifficultyLevel] > ChampionRecord.Score)
        and (PlayerRecord.BestScore[DifficultyLevel] > 0) then
        UpdateChampionDetails(ChampionRecord, PlayerRecord)
      else
        if (PlayerRecord.BestScore[DifficultyLevel] = ChampionRecord.Score)
          and (PlayerRecord.BestScore[DifficultyLevel] > 0) then
          if PlayerRecord.BestScoreDate[DifficultyLevel] >
            ChampionRecord.ScoreDate then
            UpdateChampionDetails(ChampionRecord, PlayerRecord);
    end;
  end;
  Result := ChampionRecord.FirstName;
end;

function GetAmountOfWordsInTextFile(var WordListFile: textfile): integer;
begin
  Result := 0;
  reset(WordListFile);
  while not eof(WordListFile) do
  begin
    readln(WordListFile);
    Result := Result + 1;
  end;
  closefile(WordListFile);
end;

function GetRandomWord(GameRecord: TGameRecord): TString20;
{ Gets a random word from a text file for the player to guess. }
var
  WordListFile: textfile;
  Count, RandomNumber: integer;
begin
  Count := 0;
  if GameRecord.DifficultyLevel = Easy then
    assignfile(WordListFile, EasyWordListFilePath);
  if GameRecord.DifficultyLevel = Medium then
    assignfile(WordListFile, MediumWordListFilePath);
  if GameRecord.DifficultyLevel = Difficult then
    assignfile(WordListFile, DifficultWordListFilePath);
  Randomize;
  RandomNumber := Random(GetAmountOfWordsInTextFile(WordListFile));
  reset(WordListFile);
  while not eof(WordListFile) do
  begin
    Count := Count + 1;
    readln(WordListFile, Result);
    if Count = RandomNumber then
      break;
  end;
  closefile(WordListFile);
end;

function CheckValidityOfGuessedLetter(GameRecord: TGameRecord;
  GuessedLetter: char): boolean;
{ Checks to if the player's guessed letter is in the available letters set. }
begin
  if not (GuessedLetter in GameRecord.AvailableLetters) then
    Result := False
  else
    Result := True;
end;

procedure UpdateSets(var GameRecord: TGameRecord);
{ Subtracts the guessed letter from the available letters set and adds it to }
{ the used letters set. }
begin
  GameRecord.AvailableLetters :=
    GameRecord.AvailableLetters - [GameRecord.GuessedLetter];
  GameRecord.UsedLetters := GameRecord.UsedLetters + [GameRecord.GuessedLetter];
end;

function UpdateCurrentStateOfMysteryWord(GameRecord: TGameRecord): TString20;
{ Updates the mystery word by showing any guessed letters as the actual letter }
{ instead of asterisks. }
var
  Count: integer;
begin
  Result := '';
  for Count := 1 to length(GameRecord.MysteryWord) do
  begin
    if GameRecord.MysteryWord[Count] in GameRecord.UsedLetters then
      Result := Result + GameRecord.MysteryWord[Count]
    else
      Result := Result + MysteryLetter;
  end;
end;

function AddVowelsToUsedLetters(GameRecord: TGameRecord): TLetterSet;
{ Carries out a cheat that gives the player all the vowels at the start. }
begin
  if GameRecord.CheatMode = True then
    Result := GameRecord.UsedLetters + ['A', 'E', 'I', 'O', 'U', 'Y'];
end;

function CheckIfGuessedLetterIsInMysteryWord(GameRecord: TGameRecord): boolean;
var
  Count: integer;
begin
  Result := False;
  for Count := 1 to length(GameRecord.MysteryWord) do
    if GameRecord.GuessedLetter = GameRecord.MysteryWord[Count] then
      Result := True;
end;

function CheckIfPlayerHasWon(GameRecord: TGameRecord): boolean;
var
  Count: integer;
begin
  Result := True;
  for Count := 1 to length(GameRecord.CurrentStateOfMysteryWord) do
  begin
    if GameRecord.CurrentStateOfMysteryWord[Count] =
      MysteryLetter then
    begin
      Result := False;
      break;
    end;
  end;
end;

function DecrementIncorrectGuessesLeftByOne(GameRecord: TGameRecord): integer;
begin
  Result := GameRecord.IncorrectGuessesLeft - 1;
end;

function SetAvailableLettersToDefault: TLetterSet;
begin
  Result := ['A' .. 'Z'];
end;

function SetUsedLettersToDefault: TLetterSet;
begin
  Result := [];
end;

function SetAllowableIncorrectGuesses: integer;
begin
  Result := 10;
end;

end.
