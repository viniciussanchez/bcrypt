unit BCrypt.Core;

interface

{$Q-} {$OVERFLOWCHECKS OFF}

uses {$IFDEF FPC}SysUtils, Classes, Types, StrUtils, Math{$ELSE}System.SysUtils, System.Classes, System.Types, System.StrUtils, System.Math{$ENDIF}, BCrypt.Types, BCrypt.Intf, BCrypt.Consts;

type
  TBCryptImpl = class(TInterfacedObject, IBCrypt)
  private
    FSBox: array [0 .. 1023] of DWORD;
    FPBox: array [0 .. 17] of DWORD;
    procedure EKSKey(const ASalt, AHashKey: TBytes);
    procedure Encipher(var lr: array of DWORD; const AOffset: Longint);
    procedure InitializeKey();
    procedure NKey(const AHashKey: TBytes);
    function BsdBase64Encode(const ARawByteData: TBytes; ACharacterLength: Longint): string;
    function BsdBase64Decode(const AEncodedString: string): TBytes;
    function Crypt(const APassword: UTF8String; const ASalt: string; ACost: Byte; AHashType: THashType): string;
    function CryptRaw(const AHashKey, ASalt: TBytes; ACost: Byte): TBytes;
    function FormatPasswordHash(const ASalt, AHash: TBytes; ACost: Byte; AHashType: THashType): string;
    function MakeSalt: TBytes;
    function MTRandomBytes(ANumberOfBytes: DWORD): string;
    function ResolveHashType(const AHashType: string): THashType;
    function StreamToWord(const ARawByteData: TBytes; var AOffset: Longint): DWORD;
    function GenerateHash(const APassword: UTF8String; AHashType: THashType; ACost: Byte): string;
    function CompareHash(const APassword: UTF8String; const AHash: string): Boolean;
    function NeedsRehash(const AHash: string; ACost: Byte): Boolean;
    function GetHashInfo(const AHash: string): THashInfo;
  public
    class function New: IBCrypt;
  end;

implementation

function TBCryptImpl.BsdBase64Decode(const AEncodedString: string): TBytes;
  function Char64(ACharacter: Char): Longint;
  begin
    if Ord(ACharacter) > Length(BsdBase64DecodeTable) then
      Result := -1
    else
      Result := BsdBase64DecodeTable[ACharacter];
  end;
  procedure Append(AValue: Byte);
  var
    LLength: DWORD;
  begin
    LLength := Length(Result);
    SetLength(Result, LLength + 1);
    Result[LLength] := AValue;
  end;
var
  I, LEncodedStringLength, C1, C2, C3, C4: Longint;
begin
  SetLength(Result, 0);
  I := 1;
  LEncodedStringLength := Length(AEncodedString);
  while (I < LEncodedStringLength) and (Length(Result) < BCRYPT_SALT_LEN) do
  begin
    C1 := Char64(AEncodedString[I]);
    Inc(I);
    C2 := Char64(AEncodedString[I]);
    Inc(I);
    if (C1 = -1) or (C2 = -1) then
      Exit;
    Append((C1 shl 2) or ((C2 and $30) shr 4));
    if (I > LEncodedStringLength) or (Length(Result) >= BCRYPT_SALT_LEN) then
      Break;
    C3 := Char64(AEncodedString[I]);
    Inc(I);
    if (C3 = -1) then
      Exit;
    Append(((C2 and $0F) shl 4) or ((C3 and $3C) shr 2));
    if (I > LEncodedStringLength) or (Length(Result) >= BCRYPT_SALT_LEN) then
      Break;
    C4 := Char64(AEncodedString[I]);
    Inc(I);
    if C4 = -1 then
      Exit;
    Append(((C3 and $03) shl 6) or C4);
  end;
end;

function TBCryptImpl.BsdBase64Encode(const ARawByteData: TBytes; ACharacterLength: Longint): string;
var
  I, B1, B2: Longint;
begin
  Result := '';
  if (ACharacterLength <= 0) or (ACharacterLength > Length(ARawByteData)) then
    Exit;
  I := 0;
  while I < ACharacterLength do
  begin
    B1 := ARawByteData[I] and $FF;
    Inc(I);
    Result := Result + BsdBase64EncodeTable[(B1 shr 2) and $3F];
    B1 := (B1 and $03) shl 4;
    if I >= ACharacterLength then
    begin
      Result := Result + BsdBase64EncodeTable[B1 and $3F];
      Exit;
    end;
    B2 := ARawByteData[I] and $FF;
    Inc(I);
    B1 := B1 or ((B2 shr 4) and $0F);
    Result := Result + BsdBase64EncodeTable[B1 and $3F];
    B1 := (B2 and $0F) shl 2;
    if I >= ACharacterLength then
    begin
      Result := Result + BsdBase64EncodeTable[B1 and $3F];
      Exit;
    end;
    B2 := ARawByteData[I] and $FF;
    Inc(I);
    B1 := B1 or ((B2 shr 6) and $03);
    Result := Result + BsdBase64EncodeTable[B1 and $3F];
    Result := Result + BsdBase64EncodeTable[B2 and $3F];
  end;
end;

function TBCryptImpl.CryptRaw(const AHashKey, ASalt: TBytes; ACost: Byte): TBytes;
var
  LData: array [0 .. 5] of DWORD;
  LLength: Integer;
  LRounds: DWORD;
  I, J: Longint;
begin
  Move(MagicText[0], LData[0], Sizeof(MagicText));
  LLength := Length(LData);
  LRounds := 1 shl ACost;
  InitializeKey();
  EKSKey(ASalt, AHashKey);
  for I := 1 to LRounds do
  begin
    NKey(AHashKey);
    NKey(ASalt);
  end;
  for I := 1 to 64 do
    for J := 0 to (LLength shr 1) - 1 do
      Encipher(LData, J shl 1);
  SetLength(Result, LLength * 4);
  J := 0;
  for I := 0 to LLength - 1 do
  begin
    Result[J] := (LData[I] shr 24) and $FF;
    Inc(J);
    Result[J] := (LData[I] shr 16) and $FF;
    Inc(J);
    Result[J] := (LData[I] shr 8) and $FF;
    Inc(J);
    Result[J] := LData[I] and $FF;
    Inc(J);
  end;
end;

procedure TBCryptImpl.EKSKey(const ASalt, AHashKey: TBytes);
var
  lr: array [0 .. 1] of DWORD;
  I, LPasswordOffset, LSaltOffset, LPasswordLength, LSaltLength: Longint;
begin
  LPasswordOffset := 0;
  LSaltOffset := 0;
  LPasswordLength := Length(FPBox);
  LSaltLength := Length(FSBox);
  lr[0] := 0;
  lr[1] := 0;
  for I := 0 to LPasswordLength - 1 do
    FPBox[I] := FPBox[I] xor StreamToWord(AHashKey, LPasswordOffset);
  for I := 0 to (LPasswordLength div 2) - 1 do
  begin
    lr[0] := lr[0] xor StreamToWord(ASalt, LSaltOffset);
    lr[1] := lr[1] xor StreamToWord(ASalt, LSaltOffset);
    Encipher(lr, 0);
    FPBox[2 * I] := lr[0];
    FPBox[2 * I + 1] := lr[1];
  end;
  for I := 0 to (LSaltLength div 2) - 1 do
  begin
    lr[0] := lr[0] xor StreamToWord(ASalt, LSaltOffset);
    lr[1] := lr[1] xor StreamToWord(ASalt, LSaltOffset);
    Encipher(lr, 0);
    FSBox[2 * I] := lr[0];
    FSBox[2 * I + 1] := lr[1];
  end;
end;

procedure TBCryptImpl.Encipher(var lr: array of DWORD; const AOffset: Longint);
var
  I, N, LBlock, R: DWORD;
begin
  LBlock := lr[AOffset];
  R := lr[AOffset + 1];
  LBlock := LBlock xor FPBox[0];
  I := 1;
  while I <= BLOWFISH_NUM_ROUNDS - 1 do
  begin
    N := FSBox[(LBlock shr 24) and $FF];
    N := DWORD(N + FSBox[$100 or ((LBlock shr 16) and $FF)]);
    N := N xor FSBox[$200 or ((LBlock shr 8) and $FF)];
    N := DWORD(N + FSBox[$300 or (LBlock and $FF)]);
    R := R xor (N xor FPBox[I]);
    Inc(I);
    N := FSBox[(R shr 24) and $FF];
    N := DWORD(N + FSBox[$100 or ((R shr 16) and $FF)]);
    N := N xor FSBox[$200 or ((R shr 8) and $FF)];
    N := DWORD(N + FSBox[$300 or (R and $FF)]);
    LBlock := LBlock xor (N xor FPBox[I]);
    Inc(I);
  end;
  lr[AOffset] := R xor FPBox[BLOWFISH_NUM_ROUNDS + 1];
  lr[AOffset + 1] := LBlock;
end;

function TBCryptImpl.FormatPasswordHash(const ASalt, AHash: TBytes; ACost: Byte; AHashType: THashType): string;
var
  LHash, LPrefix, LSalt, LCost: string;
begin
  case AHashType of
    THashType.BSD:
      LPrefix := '2a';
    THashType.PHP, THashType.Default:
      LPrefix := '2y';
  end;
  LSalt := BsdBase64Encode(ASalt, Length(ASalt));
  LHash := BsdBase64Encode(AHash, Length(MagicText) * 4 - 1);
  LCost := ACost.ToString.PadLeft(2, '0');
  Result := Format('$%s$%s$%s%s', [LPrefix, LCost, LSalt, LHash]);
end;

procedure TBCryptImpl.InitializeKey();
begin
  Move(SBoxOrg, FSBox, Sizeof(FSBox));
  Move(PBoxOrg, FPBox, Sizeof(FPBox));
end;

function TBCryptImpl.MTRandomBytes(ANumberOfBytes: DWORD): string;
var
  LRandomByte: string;
  LWorkingByte: Integer;
  LCount: DWORD;  
begin
  LCount := 1;
  LWorkingByte := 0;
  SetLength(LRandomByte, (ANumberOfBytes * 2) + 1);
  Randomize;
  while LCount <= (ANumberOfBytes * 2) do
  begin
    LWorkingByte := LWorkingByte or RandomRange(1000000, Maxint) xor RandomRange(10000, Maxint);
    LRandomByte[LCount] := Chr(LWorkingByte mod 256);
    Inc(LCount);
  end;
  SetLength(LRandomByte, ANumberOfBytes);
  Result := LRandomByte;
end;

procedure TBCryptImpl.NKey(const AHashKey: TBytes);
var
  lr: array [0 .. 1] of DWORD;
  I, LPasswordOffset, LPasswordLength, LSaltLength: Longint;
begin
  LPasswordOffset := 0;
  LPasswordLength := Length(FPBox);
  LSaltLength := Length(FSBox);
  lr[0] := 0;
  lr[1] := 0;
  for I := 0 to LPasswordLength - 1 do
    FPBox[I] := FPBox[I] xor StreamToWord(AHashKey, LPasswordOffset);
  for I := 0 to (LPasswordLength div 2) - 1 do
  begin
    Encipher(lr, 0);
    FPBox[2 * I] := lr[0];
    FPBox[2 * I + 1] := lr[1];
  end;
  for I := 0 to (LSaltLength div 2) - 1 do
  begin
    Encipher(lr, 0);
    FSBox[2 * I] := lr[0];
    FSBox[2 * I + 1] := lr[1];
  end;
end;

function TBCryptImpl.MakeSalt: TBytes;
var
  LByteArray: TBytes;
  LRandomTemp: string;
  I: Longint;
begin
  SetLength(LRandomTemp, 17);
  SetLength(LByteArray, 17);
  Randomize;
  LRandomTemp := MTRandomBytes(BCRYPT_SALT_LEN);
  I := 0;
  while I < Length(LRandomTemp) do
  begin
    LByteArray[i] := Ord(LRandomTemp[i + 1]);
    Inc(i);
  end;
  SetLength(LByteArray, 16);
  Result := LByteArray;
end;

function TBCryptImpl.StreamToWord(const ARawByteData: TBytes; var AOffset: Longint): DWORD;
var
  I: Longint;
begin
  Result := 0;
  for I := 1 to 4 do
  begin
    Result := (Result shl 8) or (ARawByteData[AOffset] and $FF);
    AOffset := (AOffset + 1) mod Length(ARawByteData);
  end;
end;

function TBCryptImpl.GenerateHash(const APassword: UTF8String; AHashType: THashType; ACost: Byte): string;
var
  LPasswordKey, LSaltBytes, LHash: TBytes;
begin
  SetLength(LPasswordKey, Length(APassword) + 1);
  Move(APassword[1], LPasswordKey[0], Length(APassword));
  LPasswordKey[high(LPasswordKey)] := 0;
  LSaltBytes := MakeSalt;
  LHash := CryptRaw(LPasswordKey, LSaltBytes, ACost);
  Result := FormatPasswordHash(LSaltBytes, LHash, ACost, AHashType);
end;

function TBCryptImpl.Crypt(const APassword: UTF8String; const ASalt: string; ACost: Byte; AHashType: THashType): string;
var
  LPasswordKey, LSaltBytes, LHash: TBytes;
begin
  SetLength(LPasswordKey, Length(APassword) + 1);
  Move(APassword[1], LPasswordKey[0], Length(APassword));
  LPasswordKey[high(LPasswordKey)] := 0;
  LSaltBytes := BsdBase64Decode(ASalt);
  LHash := CryptRaw(LPasswordKey, LSaltBytes, ACost);
  Result := FormatPasswordHash(LSaltBytes, LHash, ACost, AHashType);
end;

function TBCryptImpl.ResolveHashType(const AHashType: string): THashType;
begin
  case AnsiIndexStr(AHashType, ['$2y$', '$2a$']) of
    0:
      Result := THashType.PHP;
    1:
      Result := THashType.BSD;
    else
      Result := THashType.Unknown;
  end;
end;

function TBCryptImpl.CompareHash(const APassword: UTF8String; const AHash: string): Boolean;
var
  LWorkingBcryptHash, LSalt: string;
  LHashCounter, LResultStatus, LCost: Byte;
  LHashType: THashType;
  LPasswordInfo: THashInfo;
begin
  LResultStatus := 0;
  try
    LPasswordInfo := GetHashInfo(AHash);
  except
    on E: EBCrypt do
    begin
      Result := False;
      Exit;
    end;
  end;
  LCost := LPasswordInfo.Cost;
  LHashType := LPasswordInfo.&Type;
  LSalt := LPasswordInfo.Salt;
  LWorkingBcryptHash := Crypt(APassword, LSalt, LCost, LHashType);
  if (Length(LWorkingBcryptHash) < 60) or (Length(LWorkingBcryptHash) > 60) then
  begin
    Result := False;
    Exit;
  end;
  if Length(AHash) <> Length(LWorkingBcryptHash) then
  begin
    Result := False;
    Exit;
  end;
  for LHashCounter := 1 to Length(AHash) do
    LResultStatus := LResultStatus or (Ord(LWorkingBcryptHash[LHashCounter]) xor Ord(AHash[LHashCounter]));
  Result := (LResultStatus = 0);
end;

function TBCryptImpl.NeedsRehash(const AHash: string; ACost: Byte): Boolean;
var
  LOldCost: Byte;
begin
  LOldCost := StrToInt(Copy(AHash, 5, 2));
  Result := False;
  if LOldCost <> ACost then
    Result := True;
end;

class function TBCryptImpl.New: IBCrypt;
begin
  Result := Self.Create;
end;

function TBCryptImpl.GetHashInfo(const AHash: string): THashInfo;
var
  LPasswordInfo: THashInfo;
  LCost: Byte;
  LHash, LSalt: string;
  LHashType: THashType;
begin
  if Length(AHash) <> 60 then
  begin
    raise EBCrypt.Create(Format(#10#13'Invalid hash %s'#10#13, [AHash]));
    Exit;
  end;
  LHashType := ResolveHashType(Copy(AHash, 1, 4));
  LCost := StrToInt(Copy(AHash, 5, 2));
  LSalt := Copy(AHash, 8, 22);
  LHash := Copy(AHash, 30, 60);
  LPasswordInfo.&Type := LHashType;
  LPasswordInfo.Cost := LCost;
  LPasswordInfo.Salt := LSalt;
  LPasswordInfo.Hash := LHash;
  Result := LPasswordInfo;
end;

end.
