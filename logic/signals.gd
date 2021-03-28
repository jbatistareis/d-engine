extends Node

# location
# fire to move around
signal playerStartedAtLocation(playerCharacter, locationName, toSpawnId) # use to spawn a player and start the simulation at a location
signal playerMoved(direction) # use to move the player arround rooms
signal characterMoved(character, direction) # use to move any other character arround rooms
# listen to get annoucements
signal playerArrivedLocation(location) # fired when a player spawns
signal playerLeftLocation(location) # fired when a player leaves a location
signal playerChangedRoom() # fired when a player successfully moves, use to confirm room transitions
# used as internal communication, dont fire, or listen to then
signal playerTransferedLocation(newLocationName, toSpawnId) # fired when a player leaves a location


# character
# listen to get annoucements
signal characterLeveledUp(character)
signal characterGotExperience(character, amount)
signal characterGainedHp(character, amount)
signal characterLostHp(character, amount)
signal characterDied(character)


# armor
# listen to get annoucements
signal armorTookHit(armor, amount)
signal armorRepaired(armor, amount)


# commands
# listen to get annoucements
signal commandsPaused() # used to pause all timers
signal commandsResumed() # used to resume all timers
# used as internal communication, dont fire, or listen to then
signal commandPublished(command)


# battle
# use for flow control
signal battleStart(players, enemies)
signal battleEnd(loot) # TODO
signal charaterTimerSet(character, ticks)
signal charaterTimerPaused(character)
signal charaterTimerResumed(character)
signal askedPlayerBattleInput(character) # use to show a command window
signal playerConfirmedBattleInput(command) # use when the player picks a command


# inventory
signal characterEquipedWeapon(character, weaponIndex)
signal characterEquipedArmor(character, armor)
signal characterUsedItem(character, itemIndex)
signal characterReceivedItemOrWeapon(character, entity)
signal characterDroppedItem(character, itemIndex)
signal characterDroppedWeapon(character, weaponIndex)

