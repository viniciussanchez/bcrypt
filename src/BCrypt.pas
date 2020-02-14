unit BCrypt;

interface

uses BCrypt.Types;

type
  TBCrypt = class
  public
    class function GenerateHash(const APassword: string): string; overload;
    class function GenerateHash(const APassword: string; ACost: Byte): string; overload;
    class function GenerateHash(const APassword: string; ACost: Byte; AHashType: THashType): string; overload;
    class function CompareHash(const APassword: string; const AHash: string): Boolean;
    class function NeedsRehash(const AHash: string): Boolean; overload;
    class function NeedsRehash(const AHash: string; ACost: Byte): Boolean; overload;
    class function GetHashInfo(const AHash: string): THashInfo;
  end;

implementation

uses BCrypt.Consts, BCrypt.Core;

class function TBCrypt.GenerateHash(const APassword: string): string;
begin
  Result := TBCryptImpl.New.GenerateHash(UTF8String(APassword), THashType.BSD, BCRYPT_DEFAULT_COST);
end;

class function TBCrypt.GenerateHash(const APassword: string; ACost: Byte): string;
begin
  Result := TBCryptImpl.New.GenerateHash(UTF8String(APassword), THashType.BSD, ACost);
end;

class function TBCrypt.GenerateHash(const APassword: string; ACost: Byte; AHashType: THashType): string;
begin
  Result := TBCryptImpl.New.GenerateHash(UTF8String(APassword), AHashType, ACost);
end;

class function TBCrypt.CompareHash(const APassword: string; const AHash: string): Boolean;
begin
  Result := TBCryptImpl.New.CompareHash(UTF8String(APassword), AHash);
end;

class function TBCrypt.GetHashInfo(const AHash: string): THashInfo;
begin
  Result := TBCryptImpl.New.GetHashInfo(AHash);
end;

class function TBCrypt.NeedsRehash(const AHash: string; ACost: Byte): Boolean;
begin
  Result := TBCryptImpl.New.NeedsRehash(AHash, ACost);
end;

class function TBCrypt.NeedsRehash(const AHash: string): Boolean;
begin
  Result := TBCryptImpl.New.NeedsRehash(AHash, BCRYPT_DEFAULT_COST);
end;

end.
