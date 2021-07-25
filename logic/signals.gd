extends Node

# location
signal playerStartedAtLocation(playerCharacter, locationName, toSpawnId) # use to spawn a player and start the simulation at a location
signal playerMoved(direction) # used to move the player arround rooms, not used with player inputs
signal characterMoved(character, direction) # use to move any other character arround rooms
# listen to get annoucements
signal playerArrivedLocation(location) # fired when a player spawns
signal playerLeftLocation(location) # fired when a player leaves a location
signal playerChangedRoom(direction) # fired when a player successfully moves, use to execute room transitions
signal playerRoomChangeDenied() # fired when a player cant change rooms
# used as internal communication, dont fire, or listen to then
signal playerTransferedLocation(newLocationName, toSpawnId) # fired when a player leaves a location
signal playerSpawned(location, x, y, direction) # fired to set up 3d map and camera 


# inputs used to move the camera arround
signal playerMovedForward()
signal playerMovedBackward()
signal playerRotatedLeft()
signal playerRotatedRight()


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
signal commandsPaused() # use to pause all battle timelines
signal commandsResumed() # use to resume all battle timelines
# used as internal communication, dont fire, or listen to then
signal commandPublished(command)


# battle
# use for flow control
signal battleStarted(players, enemies) # use to show the battle screen, battle logic is paused until 'battleScreenSetUp' signal is fired
signal battleEnded(loot) # TODO
signal charaterTimerSet(character, ticks) # use to set a character (friend or foe) battle timeline
signal charaterTimerPaused(character) # use to pause a character (friend or foe) battle timeline
signal charaterTimerResumed(character) # use to resume a character (friend or foe) battle timeline
signal askedPlayerBattleInput(character) # use as a cue show a command window
signal playerConfirmedBattleInput(command) # use when the player picks a command
# used as internal communication, dont fire, or listen to then
signal battleScreenReady() # used to continue to run battle logic
signal startedBattleAnimation(character, animation) # used to tell a character to play an animation


# inventory
signal characterEquipedWeapon(character, weaponIndex)
signal characterEquipedArmor(character, armor)
signal characterUsedItem(character, itemIndex)
signal characterReceivedItemOrWeapon(character, entity)
signal characterDroppedItem(character, itemIndex)
signal characterDroppedWeapon(character, weaponIndex)


# GUI
# used as internal communication, dont fire, or listen to then
signal guiOpenWindow(window)
signal guiCloseWindow()
signal guiConfirm(source)
# inputs used to move the cursor
signal guiUp()
signal guiDown()
signal guiLeft()
signal guiRight()
signal guiSelect()
signal guiCancel()

