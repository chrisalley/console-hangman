{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

unit UConstantsAndTypes;

interface

const

  PlayerFilePath            = 'PlayerFile.dat';
  EasyWordListFilePath      = 'EasyWords.txt';
  MediumWordListFilePath    = 'MediumWords.txt';
  DifficultWordListFilePath = 'DifficultWords.txt';

  mmPlayGame           = '1';
  mmDisplayAboutScreen = '2';
  mmQuitProgram        = '3';

  gmStartGame             = '1';
  gmSelectDifficultyLevel = '2';
  gmViewOrPrintReport     = '3';
  gmReturnToMainMenu      = '4';

  dlmEasy      = '1';
  dlmMedium    = '2';
  dlmDifficult = '3';

  vprmViewReport       = '1';
  vprmPrintReport      = '2';
  vprmReturnToMainMenu = '3';

  ProgramName = 'Console Hangman';
  Copyright   = 'Copyright to Chris Alley, 2004';
  Version     = 'Version 1.0';

  Won     = 'Won';
  Lost    = 'Lost';
  Running = 'Running';

  MysteryLetter = '*';

  ReportFontName = 'Courier New';
  ReportFontSize = 10;

type

  TDifficultyLevel = (Easy, Medium, Difficult);
  TLetterSet = set of char;
  TString20 = string[20];
  TChampionArray = array[Easy..Difficult] of TString20;
  TBestScoreArray = array[Easy..Difficult] of integer;
  TBestScoreDateArray = array[Easy..Difficult] of TDateTime;
  TPlayerRecord = record
    FirstName: TString20;
    DateLastPlayed: TDateTime;
    NumberOfGamesPlayed: integer;
    BestScore: TBestScoreArray;
    BestScoreDate: TBestScoreDateArray;
    FilePosition: integer;
  end;
  TPlayerFile = file of TPlayerRecord;
  TGameRecord = record
    PlayerRecord: TPlayerRecord;
    MysteryWord: TString20;
    CurrentStateOfMysteryWord: TString20;
    AvailableLetters: TLetterSet;
    UsedLetters: TLetterSet;
    GuessedLetter: char;
    IncorrectGuessesLeft: integer;
    GameStatus: TString20;
    DifficultyLevel: TDifficultyLevel;
    CheatMode: boolean;
  end;
  TChampionRecord = record
    FirstName: TString20;
    Score: integer;
    ScoreDate: TDateTime;
    DifficultyLevel: TDifficultyLevel;
  end;

implementation

end.
