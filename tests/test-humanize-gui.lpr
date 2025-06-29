program testhumanizegui;

{$mode objfpc}{$H+}

uses
  Interfaces
, Forms
, GuiTestRunner
, TestHumanizeBytes
, TestHumanizeComma
, TestHumanizeOrdinals
, TestHumanizeTime
;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

