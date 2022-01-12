extends Node

# location
signal playerStartedAtLocation(playerCharacter, locationName, toSpawnId) # use to spawn a player and start the simulation at a location
signal playerMoved(direction) # used to move the player arround rooms, not used with player inputs
signal characterMoved(character, direction) # use to move any other character arround rooms
signal changedEncounterRate(value)
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
signal commandPublished(command) # use to send commands to the execution queue
signal commandOnQueue(command) # listen to know when a command is on execution queue


# battle
# use for flow control
signal battleStarted(players, enemies) # use to show the battle screen, battle logic is paused until 'battleScreenSetUp' signal is fired
signal battleEnded()
signal askedPlayerBattleInput(character) # use as a cue show a command window
signal battleCursorOpen(player, move)
signal battleCursorConfirm(player, targets, move) # targets is an array
# used as internal communication, dont fire, or listen to then
signal setupBattleScreen(players, enemies)
signal battleScreenReady()
signal showBattleResult(players, battleResult)
signal startedBattleAnimation(character, animation)
signal finishedBattleAnimation(character)


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
signal guiClearWindows()
signal guiConfirm(source)
signal guiCancel(source)
# inputs used to move the cursor
signal guiUp()
signal guiDown()
signal guiLeft()
signal guiRight()
signal guiSelect()
signal guiHover(data) # listen to get which item the player has his cursor over

