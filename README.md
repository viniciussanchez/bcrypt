# BCrypt
![Platforms](https://img.shields.io/badge/Supported%20platforms-Windows,%20MacOS%20and%20Linux-green.svg)

A library to help you hash passwords.
You can read about [bcrypt in Wikipedia](https://en.wikipedia.org/wiki/Bcrypt "BCrypt") as well as in the following article: [How To Safely Store A Password](https://codahale.com/how-to-safely-store-a-password/ "How To Safely Store A Password")

![bcrypt](https://github.com/viniciussanchez/bcrypt/blob/master/img/bcrypt.png)

# Installation

### Via Boss

For ease I recommend using the [**Boss**](https://github.com/HashLoad/boss) (Dependency Manager for Delphi) for installation, simply by running the command below on a terminal (Windows PowerShell for example):

```
boss install https://github.com/viniciussanchez/bcrypt
```

### Manual
If you choose to install manually, simply add the following folders to your project, in *Project > Options > Resource Compiler > Directories and Conditionals > Include file search path*
```
../bcrypt/src
```

# Usage

### Generate hash

```pascal
var
  LHash: string;
begin
  LHash := TBCrypt.GenerateHash(password, cost, type);
end;
```

Where
  * `password` is the password to be hashed
  * `type` is one of THashType.PHP, THashType.BSD, or THashType.Default, THashType.BSD is the default $2a$
  * `cost` is a number between 10 and 30, default is 10

### Compare hash

```pascal
var
  LVerify : Boolean;
begin
  LVerify := TBCrypt.CompareHash(password, hash);
end;
```

Where
  * `password` is the password to be verified
  * `hash` is a hash generated, similar to `$2y$12$GuC.Gk2YDsp8Yvga.IuSNOWM0fxEIsAEaWC1hqEI14Wa.7Ps3iYFq`
  
### Get hash info

```pascal
var
  LHashInfo: THashInfo;
  LSalt, LHash: string;
  LHashType: THashType;
  LCost: Word;
begin
  LHashInfo := TBCrypt.GetHashInfo(hash);
  LCost := LHashInfo.Cost;
  LSalt := LHashInfo.Salt;
  LHash := LHashInfo.Hash;
  LHashType := LHashInfo.&Type;
```  

Where
  * `hash` is a hash generated 
  
### Needs rehash

```pascal
var
  LNeeds : Boolean;
begin
  LNeeds := TBCrypt.NeedsRehash(hash, cost);
end;
```

Where
  * `hash` is a hash, similar to `$2y$12$GuC.Gk2YDsp8Yvga.IuSNOWM0fxEIsAEaWC1hqEI14Wa.7Ps3iYFq`
  * `cost` is a number between 10 and 30, default is 10

# Hash Info
The characters that comprise the resultant hash are:

```
./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
```

Resultant hashes will be 60 characters long.

![bcrypt-calculation-time](https://github.com/viniciussanchez/bcrypt/blob/master/img/bcrypt-calculation-time.png)

# Credits
The code for this comes from a few sources:
  * [Free Pascal BCrypt](https://github.com/hiraethbbs/pascal_bcrypt "Free Pascal BCrypt")
  * [BCrypt for Delphi](https://github.com/JoseJimeniz/bcrypt-for-delphi "BCrypt for Delphi")
