{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

{.$define debug}

unit UInputAndOutput;

interface

uses
  SysUtils,
  Printers,
  Crt,
  UConstantsAndTypes,
  UGameLogic,
  UDatabaseOperations,
  UDrawHangman;

procedure ContinueProgram;
procedure PrintReport(var PlayerFile: TPlayerFile);
procedure ViewReport(var PlayerFile: TPlayerFile);
function GetViewOrPrintReportMenuChoice: char;
procedure DisplayGameResults(var PlayerFile: TPlayerFile;
  var GameRecord: TGameRecord);
procedure DisplayLetterSet(LetterSet: TLetterSet);
procedure DisplayGameInterface(GameRecord: TGameRecord);
function GetLetterFromUser(GameRecord: TGameRecord): char;
procedure GetUserName(var Name: TString20; var GameRecord: TGameRecord);
function GetPlayerRecord(var PlayerFile: TPlayerFile;
  GameRecord: TGameRecord): TGameRecord;
function GetDifficultyLevelMenuChoice: char;
procedure DisplayAboutScreen;
function GetGameMenuChoice: char;
function GetMainMenuChoice: char;

implementation

procedure ContinueProgram;
{ Tells the user to continue and clears the screen when the user is ready. }
begin
  writeln('Press ENTER to continue.');
  readln;
  clrscr;
end;

procedure PrintReport(var PlayerFile: TPlayerFile);
{ Prints the high scores and champions to the default printer. }
var
  PrinterFile: textfile;
  PlayerRecord: TPlayerRecord;
  DifficultyLevel: TDifficultyLevel;
begin
  assignprn(PrinterFile);
  rewrite(PrinterFile);
  printer.canvas.font.name := ReportFontName;
  printer.canvas.font.size := ReportFontSize;
  writeln(PrinterFile, '                          Hangman Game Report                               ');
  writeln(PrinterFile, '                                                                            ');
  writeln(PrinterFile, ' ========================================================================== ');
  writeln(PrinterFile, '                                                                            ');
  writeln(PrinterFile, '                Player              Last Played  Games      Best Scores     ');
  writeln(PrinterFile, '                                                                            ');
  writeln(PrinterFile, '                                                        Easy  Medium  Hard  ');
  writeln(PrinterFile, '                                                                            ');
  writeln(PrinterFile, ' ========================================================================== ');
  writeln(PrinterFile, '                                                                            ');
  seek(PlayerFile, 0);
  while not eof(PlayerFile) do
  begin
    PlayerRecord := ReadRecordFromFile(PlayerFile);
    write(PrinterFile, '  ');
    write(PrinterFile, PlayerRecord.FirstName: 20);
    write(PrinterFile, DateTimeToStr(PlayerRecord.DateLastPlayed): 25);
    write(PrinterFile, PlayerRecord.NumberOfGamesPlayed: 7);
    write(PrinterFile, PlayerRecord.BestScore[Easy]: 6);
    write(PrinterFile, PlayerRecord.BestScore[Medium]: 6);
    write(PrinterFile, PlayerRecord.BestScore[Difficult]: 6);
    writeln(PrinterFile);
  end;
  writeln(PrinterFile);
  for DifficultyLevel := Easy to Difficult do
  begin
    write(PrinterFile, ' ');
    if WorkOutWhoIsChampion(PlayerFile, DifficultyLevel) = 'Nobody' then
    begin
      write(PrinterFile, 'No current champions on ');
      writeln(PrinterFile, GetDifficultyLevelAsAString(DifficultyLevel), '.');
    end
    else
    begin
      write(PrinterFile, WorkOutWhoIsChampion(PlayerFile, DifficultyLevel));
      write(PrinterFile, ' is the current champion at ');
      write(PrinterFile, GetDifficultyLevelAsAString(DifficultyLevel));
      writeln(PrinterFile, ' level.');
    end;
  end;
  writeln(PrinterFile);
  closefile(PrinterFile);
  writeln('A game report has been sent to the default printer.');
  writeln;
  ContinueProgram;
end;

procedure ViewReport(var PlayerFile: TPlayerFile);
{ Prints the high scores and champions to the screen. }
var
  PlayerRecord: TPlayerRecord;
  DifficultyLevel: TDifficultyLevel;
begin
  writeln('                          Hangman Game Report                               ');
  writeln('                                                                            ');
  writeln(' ========================================================================== ');
  writeln('                                                                            ');
  writeln('                Player              Last Played  Games      Best Scores     ');
  writeln('                                                                            ');
  writeln('                                                        Easy  Medium  Hard  ');
  writeln('                                                                            ');
  writeln(' ========================================================================== ');
  writeln('                                                                            ');
  seek(PlayerFile, 0);
  while not eof(PlayerFile) do
  begin
    PlayerRecord := ReadRecordFromFile(PlayerFile);
    write('  ');
    write(PlayerRecord.FirstName: 20);
    write(DateTimeToStr(PlayerRecord.DateLastPlayed): 25);
    write(PlayerRecord.NumberOfGamesPlayed: 7);
    write(PlayerRecord.BestScore[Easy]: 6);
    write(PlayerRecord.BestScore[Medium]: 6);
    write(PlayerRecord.BestScore[Difficult]: 6);
    writeln;
  end;
  writeln;
  for DifficultyLevel := Easy to Difficult do
  begin
    if WorkOutWhoIsChampion(PlayerFile, DifficultyLevel) = 'Nobody' then
    begin
      write('No current champions on ');
      writeln(GetDifficultyLevelAsAString(DifficultyLevel), '.');
    end
    else
    begin
      write(WorkOutWhoIsChampion(PlayerFile, DifficultyLevel));
      write(' is the current champion at ');
      writeln(GetDifficultyLevelAsAString(DifficultyLevel), ' level.');
    end;
  end;
  writeln;
  ContinueProgram;
end;

function GetViewOrPrintReportMenuChoice: char;
{ Displays the View/Print Report sub menu and gets the user's choice. }
begin
  repeat
    writeln('** View / Print Report ***************************');
    writeln('*');
    writeln('*  (', vprmViewReport, ') View Report');
    writeln('*  (', vprmPrintReport, ') Print Report');
    writeln('*  (', vprmReturnToMainMenu, ') Return to the Main Menu');
    writeln('*');
    writeln('**************************************************');
    writeln;
    writeln('Type in the number of your choice and press ENTER: ');
    readln(Result);
    if not (Result in [vprmViewReport .. vprmReturnToMainMenu]) then
    begin
      writeln('That is not a valid choice. Press ENTER to try again.');
      readln;
    end;
    clrscr;
  until Result in [vprmViewReport .. vprmReturnToMainMenu];
end;

procedure DisplayGameResults(var PlayerFile: TPlayerFile;
  var GameRecord: TGameRecord);
{ Displays the results of a game of hangman, telling the user if he or she }
{ won or lost or if the user got a high score. }
begin
  writeln('** Game Results **********************************');
  writeln('*');
  if GameRecord.GameStatus = Won then
  begin
    write('*  Congratulations ', GameRecord.PlayerRecord.FirstName, '.');
    writeln(' Your score is ', GameRecord.IncorrectGuessesLeft, '.');
    if not (FindOutIfScoreIsBestScore(GameRecord) = '') then
    begin
      write('*  ');
      writeln(FindOutIfScoreIsBestScore(GameRecord), '.');
      UpdateBestScoreAndBestScoreDate(GameRecord);
    end;
    Flush(PlayerFile, GameRecord.PlayerRecord);
    if GameRecord.PlayerRecord.FirstName = WorkOutWhoIsChampion(PlayerFile,
      GameRecord.DifficultyLevel) then
    begin
      write('*  You are now the champion on ');
      writeln(GetDifficultyLevelAsAString(GameRecord.DifficultyLevel), '!');
    end;
  end
  else
  begin
    DisplayHangman(GameRecord);
    writeln('*');
    writeln('*  Too bad, you lost ', GameRecord.PlayerRecord.FirstName, '.');
    writeln('*  The mystery word was: ', GameRecord.MysteryWord);
  end;
  writeln('*');
  writeln('**************************************************');
  writeln;
  ContinueProgram;
end;

procedure DisplayLetterSet(LetterSet: TLetterSet);
{ Displays either the available letters or used letters set onto the screen }
{ depending on which set is passed into the procedure. }
var
  Letter: char;
begin
  for Letter := 'A' to 'Z' do
    if Letter in LetterSet then
      write(Letter);
  writeln;
end;

procedure DisplayGameInterface(GameRecord: TGameRecord);
{ Displays the main hangman interface, with all the necessary score keeping }
{ counters and letters used and unused letters. }
begin
  writeln('** Console Hangman *******************************');
  writeln('*');
{$ifdef debug}
  writeln(GameRecord.MysteryWord);
  writeln;
{$endif}
  DisplayHangman(GameRecord);
  writeln('*');
  writeln('*  Mystery Word: ', GameRecord.CurrentStateOfMysteryWord);
  writeln('*');
  write('*  Available Letters: ');
  DisplayLetterSet(GameRecord.AvailableLetters);
  writeln('*');
  write('*  Used Letters: ');
  DisplayLetterSet(GameRecord.UsedLetters);
  writeln('*');
  writeln('*  Incorrect Guesses Left: ', GameRecord.IncorrectGuessesLeft);
  writeln('*');
  writeln('**************************************************');
  writeln;
end;

function GetLetterFromUser(GameRecord: TGameRecord): char;
{ Gets a letter from the user and outputs a suitable message if the letter is }
{ not valid or has already been used. }
begin
  writeln('Guess a letter:');
  readln(Result);
  Result := upcase(Result);
  clrscr;
  if CheckValidityOfGuessedLetter(GameRecord, Result) = False then
  begin
    if (Result = #13) or (Result = ' ') then
    { #13 is ASCII for the eoln character. }
    begin
      write('You did not type in a letter, ');
      writeln('or you have a space in front of it.');
    end
    else
    begin
      writeln('This character "', Result,'" is either not in the');
      writeln('alphabet or you have already guessed it.');
    end;
    writeln;
    writeln('Press ENTER to choose a different letter.');
    readln;
    clrscr;
  end;
end;

procedure GetUserName(var Name: TString20; var GameRecord: TGameRecord);
{ Gets the player's name from an input from the keyboard and converts the }
{ first letter to uppercase. }
begin
  GameRecord.CheatMode := False;
  Name := '';
  while (Name = '') or (Name = 'VOWELS') do
  begin
    writeln('Enter your name:');
    readln(Name);
    Name[1] := upcase(Name[1]);
    writeln;
    if Name = '' then
    begin
      writeln('It helps if you actually type in your name...');
      ContinueProgram;
      writeln;
    end;
   if Name = 'VOWELS' then // VOWELS is the keyword to activate game cheats.
    begin
      if GameRecord.CheatMode = False then
      begin
        writeln('Cheat mode is now on.');
        GameRecord.CheatMode := True;
      end
      else
      begin
        writeln('Cheat mode is now off.');
        GameRecord.CheatMode := False;
      end;
      writeln;
    end;
  end;
end;

function GetPlayerRecord(var PlayerFile: TPlayerFile;
  GameRecord: TGameRecord): TGameRecord;
{ Gets a players record from the database or makes a new record and displays }
{ a message depending if the player is new or not. }
var
  Name: TString20;
begin
  GetUserName(Name, GameRecord);
  reset(PlayerFile);
  while not eof(PlayerFile) do
  begin
    GameRecord.PlayerRecord := ReadRecordFromFile(PlayerFile);
    if GameRecord.PlayerRecord.FirstName = Name then
    begin
      write('Hello ', GameRecord.PlayerRecord.FirstName);
      writeln(', nice to play with you again.');
      write('You last played on ');
      writeln(DateTimeToStr(GameRecord.PlayerRecord.DateLastPlayed));
      writeln;
      ContinueProgram;
      Result := GameRecord;
      exit;
    end;
  end;
  fillchar(GameRecord.PlayerRecord, sizeof(GameRecord.PlayerRecord), #0);
  GameRecord.PlayerRecord.FirstName := Name;
  AddNewRecordToFile(PlayerFile, GameRecord.PlayerRecord);
  write('Hello ', GameRecord.PlayerRecord.FirstName);
  writeln(', I hope you enjoy the game.');
  writeln('Your name has been added to the database.');
  writeln;
  ContinueProgram;
  Result := GameRecord;
end;

function GetDifficultyLevelMenuChoice: char;
{ Displays the difficulty level menu and returns the choice of what difficulty }
{ level the player chooses. }
begin
  repeat
    writeln('** Choose Your Difficulty Level ******************');
    writeln('*');
    writeln('*  (', dlmEasy, ') Easy');
    writeln('*  (', dlmMedium, ') Medium');
    writeln('*  (', dlmDifficult, ') Difficult');
    writeln('*');
    writeln('**************************************************');
    writeln;
    writeln('Type in the number of your choice and press ENTER: ');
    readln(Result);
    if not (Result in [dlmEasy .. dlmDifficult]) then
    begin
      writeln('That is not a valid choice. Press ENTER to try again.');
      readln;
    end;
    clrscr;
  until Result in [dlmEasy .. dlmDifficult];
end;

procedure DisplayAboutScreen;
{ Displays the program name, copright information, and the version number. }
begin
  writeln('** About Console Hangman *************************');
  writeln('*');
  writeln('*  ', ProgramName);
  writeln('*  ', Copyright);
  writeln('*  ', Version);
  writeln('*');
  writeln('**************************************************');
  writeln;
  ContinueProgram;
end;

function GetGameMenuChoice: char;
{ Displays the game menu and returns the user's choice. }
begin
  repeat
    writeln('** Game Options **********************************');
    writeln('*');
    writeln('*  (', gmStartGame, ') Start the Game');
    writeln('*  (', gmSelectDifficultyLevel, ') Select Difficulty Level');
    writeln('*  (', gmViewOrPrintReport, ') View / Print Report');
    writeln('*  (', gmReturnToMainMenu, ') Return to the Main Menu');
    writeln('*');
    writeln('**************************************************');
    writeln;
    writeln('Type in the number of your choice and press ENTER: ');
    readln(Result);
    if not (Result in [gmStartGame .. gmReturnToMainMenu]) then
    begin
      writeln('That is not a valid choice. Press ENTER to try again.');
      readln;
    end;
    clrscr;
  until Result in [gmStartGame .. gmReturnToMainMenu];
end;

function GetMainMenuChoice: char;
{ Displays the main menu and returns the user's choice. }
begin
  repeat
    writeln('** Console Hangman *******************************');
    writeln('*');
    writeln('*  (', mmPlayGame, ') Play the Game');
    writeln('*  (', mmDisplayAboutScreen, ') About Console Hangman');
    writeln('*  (', mmQuitProgram, ') Quit');
    writeln('*');
    writeln('**************************************************');
    writeln;
    writeln('Type in the number of your choice and press ENTER: ');
    readln(Result);
    if not (Result in [mmPlayGame .. mmQuitProgram]) then
    begin
      writeln('That is not a valid choice. Press ENTER to try again.');
      readln;
    end;
    clrscr;
  until Result in [mmPlayGame .. mmQuitProgram];
end;

end.
