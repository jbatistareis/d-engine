extends Node

# location
# these are used to move around
signal playerStartedAtLocation(characterId, locationId, fromPortalId) # used to spawn a player and start the simulation at a location
signal playerMoved(direction) # used to move the player arround rooms
signal characterMoved(character, direction) # used to move any other character arround rooms
# these are fired as information
signal playerArrivedLocation(location, fromPortal) # fired when a player spawns, every spawn is cleared
signal playerLeftLocation(oldLocation, newLocation, fromPortal) # fired when a player leaves a location, spawns are left intact
signal characterTravelled(character, direction, fromRoom, toRoom) # fired when any character moves

# rooms
signal characterArrivedRoom(character, room)
signal characterLeftRoom(character, room)

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
signal commandPublished(command)

# battle
signal battleStart(players, enemies)
signal battleEnd(loot) # TODO
signal charaterTimerSet(character, ticks)
signal charaterTimerPaused(character)
signal charaterTimerResumed(character)
signal askedPlayerBattleInput(character) # use to show a command window
signal playerConfirmedBattleInput(command) # used when the command window confirms a command

# inventory
signal characterEquipedWeapon(character, weaponIndex)
signal characterEquipedArmor(character, armor)
signal characterUsedItem(character, itemIndex)
signal characterReceivedItemOrWeapon(character, entity)
signal characterDroppedItem(character, itemIndex)
signal characterDroppedWeapon(character, weaponIndex)

