extends Node

# location
# these are used to move around
signal playerStartedAtLocation(characterId, locationId, fromPortalId) # used to spawn and start the simulation at a location
signal playerMoved(direction) # used to move the player arround rooms
signal characterMoved(character, direction) # used to move any other character arround rooms
# these are fired as an alert
signal playerArrivedLocation(location, fromPortal) # fired when a player spawns, every spawn is cleared
signal playerLeftLocation(oldLocation, newLocation, fromPortal) # fired when a player leaves a location, spawns are left intact
signal characterTravelled(character, direction, fromRoom, toRoom) # fired when any character moves

# rooms
signal characterArrivedRoom(character, room) # fired when a character arrives a room
signal characterLeftRoom(character, room) # fired when a character leaves a room

# character
signal characterSpawned(character)
signal characterDespawned(character)
signal characterLeveledUp(character)
signal characterGotExperience(character, amount)
signal characterGainedHp(character, amount)
signal characterLostHp(character, amount)
signal characterDied(character)

# armor
signal armorSpawned(armor)
signal armorDespawned(armor)
signal armorTookHit(armor, amount)
signal armorRepaired(armor, amount)

# weapon
signal weaponSpawned(weapon)
signal weaponDespawned(weapon)

# items
signal itemSpawned(item)
signal itemDespawned(item)

# commands
signal commandsPaused()
signal commandsResumed()
signal publishedCommand(command)

# battle
signal battleStart(player, enemies)
signal charaterTimerSet(character, ticks)
signal charaterTimerPaused(character)
signal charaterTimerResumed(character)
signal askedPlayerInput(character) # use to show a command window
signal playerConfirmedInput(command) # used when the command window confirms a command

# messages


