# building

this file will outline how to build Relocation Failed for any platform you need! -Mac because FUCK apple, and also if you try to port it I will personally come and shut your project down. my game will NOT, be on Apple. repeat ***NOT***. ***ON***. ***APPLE***.

## part 1

Before building the game, you should install some applications to help with the process. Should you not want to install these programs, you can build the game from the Windows command line console.

first, you should install [Visual Studio Code](https://code.visualstudio.com). due to the way that this game was built. you don't need Visual Studio itself.
once you install that, you should install [Haxe](https://haxe.org). Since this is the language the game was programmed in, it's important.

### part 2 dependencies

for this game to be buildable, you need some different dependencies for the game to be buildable, thankfully, as of February 9, we have an easier way to set up the game! simply run the [Dependencies.bat](./setup/Dependencies.bat) file!

#### part 3 building

now that you have the dependencies installed, building the game is simple! all you have to type into your console is:

```PowerShell
lime test hl -debug
```
