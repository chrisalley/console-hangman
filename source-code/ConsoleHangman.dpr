{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

program ConsoleHangman;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  UConstantsAndTypes in 'UConstantsAndTypes.pas',
  UInputAndOutput in 'UInputAndOutput.pas',
  UGameLogic in 'UGameLogic.pas',
  UDatabaseOperations in 'UDatabaseOperations.pas',
  UMain in 'UMain.pas',
  UShowMessage in 'UShowMessage.pas',
  UDrawHangman in 'UDrawHangman.pas',
  Crt in 'Crt.pas';

begin
  DoMainMenuChoice;
end.
