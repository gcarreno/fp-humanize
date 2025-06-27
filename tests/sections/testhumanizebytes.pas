unit TestHumanizeBytes;

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
{ TTestBytes }
  TTestBytes= class(TTestCase)
  private
    FRet: String;
  protected
  public
  published
    procedure TestBytesBase2;
    procedure TestBytesBase10;
  end;

implementation

uses
  humanize
;

procedure TTestBytes.TestBytesBase2;
begin
  FRet:= THumanize.Bytes(1024, 1);
  AssertEquals('Bytes 1024, 1', '1.0 KiB', FRet);
  FRet:= THumanize.Bytes(1024, 2);
  AssertEquals('Bytes 1024, 2', '1.00 KiB', FRet);
end;

procedure TTestBytes.TestBytesBase10;
begin
  FRet:= THumanize.Bytes(1000, 1, True);
  AssertEquals('Bytes 1000, 1', '1.0 KB', FRet);
  FRet:= THumanize.Bytes(1000, 2, True);
  AssertEquals('Bytes 1000, 2', '1.00 KB', FRet);
end;

initialization

  RegisterTest(TTestBytes);
end.

