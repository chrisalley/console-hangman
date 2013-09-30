{ *********************************************************************** }
{                                                                         }
{  Console Hangman                                                        }
{  Version 1.1 - Fixed TDateTime error when recording the champions       }
{  Version 1.0 - First release of program                                 }
{  Last Revised: 10th of May 2004                                         }
{  Copyright (c) 2004 Chris Alley                                         }
{                                                                         }
{ *********************************************************************** }

unit UShowMessage;

interface

procedure ShowMessage(Msg: string);

implementation

procedure ShowMessage(Msg: string);
{ Displays a simple message on the screen. }
begin
  writeln(Msg);
  writeln;
end;

end.
