# D Engine  
###### It is suposed to be a single player RPG engine made with Godot  
Inspired by Dungeon World and Ron Penton's MUD Game Programming, oldie but goodie.  
It almost works, nothing to show *for now*.  


## Details  
#### The world  
Maps are divided in square cells of 1 Godot cubic units arranged side by side, floors are done by teleporting the character to a clossed off area of the map. The player moves by 1 cell at a time in 4 directions (north, east, south, and west).  
#### The conflicts  
Battles are random, with the possibility to adjust the encounter rate on the fly, in a real time with pause scheme. Participants have an armor that soaks damage, and are suscetible to 3 stat altering conditions: strength, defense, and cooldown, positive or negative, up to 3 stacks. The effect strength of each stack is defined by the amor +/- scaling.  
#### The power  
Characters have 3 stats: strength, dexterity, and constitution. Weapons can scale using strength and/or dexterity, while health grows with constitution.  
Weapons define the attacks available, and each attack has a windup and a cooldown period.  
> This is loosely based on Dungeon World's rules, and can change over time.  
#### DM secrets  
To aid development, there are custom tools made in game to edit the game database.  
This "database" is a simple file storage system, each game object has its properties serialized on an unique file, which is loaded at runtime. Nothing too fancy.  


## Note  
It is going to work some day.  


## DONE  
- [x] 3D map
- [x] Scene preload system
- [x] Map movement system
- [x] Controls system
- [x] Spawn system
- [x] Dynamic script system
- [x] Command system
- [x] Battle system
- [x] Ai system
- [x] Inventory system
- [x] Item system
- [x] "Database" system
- [x] ~~Message~~ Toast system
- [x] UI ~~system~~
- [x] Maps dev tool
- [x] Characters dev tool
- [x] Atacks dev tool
- [x] Items dev tool
- [x] Weapons dev tool
- [x] Armors dev tool
- [x] Inventory dev tool
- [x] AI dev tool


## TODO  
- [ ] Dialog system
- [ ] Quest system
- [ ] Map interation system
- [ ] Event system
- [ ] Save system
- [ ] Dialogs dev tool
- [ ] Events dev tool
- [ ] _A not too boring demo_

