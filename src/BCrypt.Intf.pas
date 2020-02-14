unit BCrypt.Intf;

interface

uses BCrypt.Types;

type
  IBCrypt = interface
    ['{4C75D7B3-5850-4062-B0BE-7FDA5D98936B}']
    function GenerateHash(const APassword: UTF8String; AHashType: THashType; ACost: Byte): string;
    function CompareHash(const APassword: UTF8String; const AHash: string): Boolean;
    function NeedsRehash(const AHash: string; ACost: Byte): Boolean;
    function GetHashInfo(const AHash: string): THashInfo;
  end;

implementation

end.
