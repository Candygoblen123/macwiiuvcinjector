# macwiiuvcinjector
A script that will inject roms into wiiu vc games on Catalina

### Things that are working right now:
- SNES injection

### If something is not working, please open an issue

### Things on the TODO list:
- [x] SNES injector
- [ ] NDS injector
- [ ] NES injector
- [ ] N64 injector
- [ ] GBA injector
- [ ] *Wii injector*
- [ ] *GCN injector*

#### Key
- [x] Checked boxes are complete
- [ ] ~~Strikethrough are given up on~~
- [ ] Empty boxes are upcoming
- [ ] *italics is up next*

### Install
#### Have Homebrew (macos) already? Run this in terminal:
```shell
brew tap candygoblen123/macwiiuvcinjector
brew install wiiuinjector
```

#### Need Homebrew (macos)? Run this in terminal:
```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
[Go to the Homebrew (macos) website at brew.sh to learn more](https://brew.sh)

###### Guide for install without brew coming soon

### Uninstall
#### With brew:
```shell
brew remove wiiuinjector
brew bundle dump
brew bundle --force cleanup
rm -rf ./Brewfile
brew untap candygoblen123/macwiiuvcinjector
```
