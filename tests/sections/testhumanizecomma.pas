unit TestHumanizeComma;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
;

type
{ TTestComma }
  TTestComma= class(TTestCase)
  private
    FRet: String;
  protected
  public
  published
    procedure TestCommaInt;
    procedure TestCommaFloat;
    procedure TestCommaStr;
  end;

implementation

uses
  humanize
;

const
  cStrings: array of String = ('One', 'two', '3', 'cat');

{ TTestComma }

procedure TTestComma.TestCommaInt;
begin
  FRet:= THumanize.Comma(102458);
  AssertEquals('Comma 102458', '102,458', FRet);
end;

procedure TTestComma.TestCommaFloat;
begin
  FRet:= THumanize.Comma(102458.42, 1);
  AssertEquals('Comma 102458.42 1', '102,458.4', FRet);
  FRet:= THumanize.Comma(102458.42, 2);
  AssertEquals('Comma 102458.42 1', '102,458.42', FRet);
end;

procedure TTestComma.TestCommaStr;
begin
  FRet:= THumanize.Comma(cStrings);
  AssertEquals('Comma Strings #1', 'One, two, 3, cat', FRet);
  FRet:= THumanize.Comma(cStrings, True);
  AssertEquals('Comma Strings #2', '3, cat, One, two', FRet);
end;

initialization

  RegisterTest(TTestComma);
end.

