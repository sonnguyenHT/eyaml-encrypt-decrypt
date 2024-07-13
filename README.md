# AWS Secrets encryption/decryption with  Eyaml - GnuPG

Scripts and data repository for managing aws secrets data

## Prerequisites

- [GnuPG](https://gnupg.org/download/index.html) installed

### MAC-OS installation

Install gpg

```bash
brew install gpg
```

Install hiera-eyaml gpg

```bash
sudo gem install gpgme hiera-eyaml hiera-eyaml-gpg ruby_gpg
```
If you found the error logs related to ruby/config.h run the following command will solve it
```bash
cd /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/include/ruby-2.6.0
sudo ln -s universal-darwin22 universal-darwin21
```
### Ubuntu / Debian install

Install gpg

```bash
sudo apt-get update -y
sudo apt-get -y install gpg
```

Install hiera-eyaml

```bash
sudo apt-get -y install build-essential ruby rubygems ruby-dev
```

Install hiera-gpg with gem

```bash
sudo gem install gpgme hiera-eyaml hiera-eyaml-gpg ruby_gpg
```

## Feature

- Encrypt sensitive data by eyaml backend gpg
- Decrypt data with your private gpg key

## Get started

Verify if your gpg is working

```bash
gpg --version
```

### Generate your gpg key

Run the below command

```bash
gpg --full-generate-key
```

Finish the prompt to generate gpg key. Verify the key ring

```bash
gpg -k
```

It should output the information like below. The `ultimate` mean its your key

```text
/Users/daidao/.gnupg/pubring.kbx
--------------------------------
pub   rsa4096 2022-06-07 [SC]
      58EED76BB8F81319FE8139EB37792E661DF6ABCF
uid           [ultimate] Dai Dao <dai.dao@galaxyfinx.com>
sub   rsa4096 2022-06-07 [E]
```

### Export public key

```bash
gpg --output your_name.pgp --armor --export your_email@email
```

### Upload it into member folder then create PR to main

#### Others member of keyring have to do the following

Import new member public key

```bash
gpg --import your_name.pgp
```

Sign the key

```bash
gpg --sign-key your_email@email
```

Alternative, key_id/thumbprint could be used instead of email

#### After that, the keyrings should be up to date with all member public key

Import and sign all key in keyring

```bash
./gpg-keys/sign_key.sh ./gpg-keys/keyrings/all.gpg
```

### After importing and signing, your key ring should look like this kind of format

```bash
gpg -k
```

```text
/Users/daidao/.gnupg/pubring.kbx
--------------------------------
pub   rsa4096 2022-06-07 [SC]
      58EED76BB8F81319FE8139EB37792E661DF6ABCF
uid           [ultimate] Dai Dao <dai.dao@galaxyfinx.com>
sub   rsa4096 2022-06-07 [E]

pub   rsa4096 2022-07-18 [SC]
      C95014FBAB1FB2B15EB8D79EF4F820ED67FDF7A9
uid           [  full  ] FinX Engineering <hnr@galaxyfinx.com>
sub   rsa4096 2022-07-18 [E]

pub   rsa4096 2022-06-07 [SC]
      B72C2BCACA5090CE972ADA1CD362901F68FD051A
uid           [  full  ] Dustin Nguyen <dustin.nguyen@galaxyfinx.com>
sub   rsa4096 2022-06-07 [E]
```

### Decrypt secrets file

```bash
eyaml decrypt -n gpg -f secrets.yaml
```

### Encrypts data, edit file

```bash
eyaml edit secrets.yaml --gpg-recipients-file recipients
```

Encrypt the value you wish to be encrypted by adding following pattern `DEC::GPG[sensitive_data]!`

## Author

- Dai Dao

## License

Copyright © 2022 Galaxy FinX JSC. All rights reserved

* Reference docs: https://dev.to/betadots/using-eyaml-gpg-to-store-secrets-in-hiera-1if4
