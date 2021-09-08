unit BCrypt.Types;

interface

uses {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF};

type
{$SCOPEDENUMS ON}
  THashType = (Default, PHP, BSD, Unknown);
{$SCOPEDENUMS OFF}

  THashInfo = object
    &Type: THashType;
    Cost: Word;
    Salt: string;
    Hash: string;
  end;

  EBCrypt = class(Exception);
  {$IFDEF POSIX}
  UTF8String = type AnsiString(CP_UTF8);
  {$ENDIF POSIX}  

implementation

end.
