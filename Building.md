# building

this file will outline how to build Relocation Failed for any platform that you may need! -mac because FUCK apple, and also if you try to port it i will personally come and shut your project down. my game will NOT, be on apple. repeat ***NOT***. ***ON***. ***APPLE***.

## part 1

before you can start to build the game, you need to install some applications to aid in the process of building. if you do not want to install these programs then you can build through the console seperately.

first, you need to install [Visual Studio Code](https://code.visualstudio.com), thankfully. due to the way that thi game was built. you dont need visual studio itself.
once you install that, you should proceed to install [Haxe](https://haxe.org). since this is the language the game was programmed in, this is pretty important to have.

### part 2 dependencies

for this game to be buildable, you need some different dependencies for the game to be buildable, thankfully, we have a command set you can paste in your console for easy installation of the dependencies.

```powershell
haxelib install openfl; haxelib install lime; haxelib install flixel; haxelib install flixel-addons; haxelib install flixel-ui; haxelib install svg; haxelib install flxsvg; haxelib install hlwnative; haxelib install hscript; haxelib install hxcpp; haxelib install hxdiscord_rpc;
```

#### part 3 building

now that you have the dependencies installed, building the game is simple! all you have to type into your console is:

```powershell
lime test hl -debug
```
