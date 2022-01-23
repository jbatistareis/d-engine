extends Node


# player related
# to start a match: playerEnteredGame -> playerTransferedLocation
# controls provided by Godots ui_* signals, see each state logic for mappings
signal playerEnteredGame(playerCharacter) # sets the current player
signal playerTransferedLocation(newLocationName, toSpawnId) # puts player in a location, at spawn point

# internal use
signal playerMoved(direction) # moves the player arround rooms, not used with player inputs
signal playerSpawned(location, x, y, direction) # fired to set up 3d map and camera 
signal characterMoved(character, direction) # moves any other character arround rooms
signal changedEncounterRate(value) # changes location rate

# listen to get annoucements
signal playerArrivedLocation(location) # when a player spawns
signal playerLeftLocation(location) # when a player leaves
signal playerChangedRoom(direction) # when a player successfully moves (Direction enum)
signal playerRoomChangeDenied() # when a player cant change rooms

# moves the camera, fw/bw fired by location manager, l/r fired by exploring state
signal cameraMovedForward()
signal cameraMovedBackward()
signal cameraRotatedLeft()
signal cameraRotatedRight()


# game character related
signal characterLeveledUp(character)
signal characterGotExperience(character, amount)
signal characterChangedHp(character, amount)
signal characterChangedExtraHp(character, amount)
signal characterTookDamage(character)
signal characterDied(character)
signal armorChangedIntegrity(armor, amount)


# command related
signal commandsPaused() # pauses all battle timelines
signal commandsResumed() # resumes all battle timelines

# internal use
signal commandPublished(command) # sends commands to the execution queue
signal commandOnQueue(command) # when a command is put on execution queue


# battle related
# internal use
signal battleStarted(players, enemies) # changes state to battle, logic is held until 'battleScreenReady' signal is fired
signal setupBattleScreen(players, enemies) # for transition animation
signal battleScreenReady() # logic starts after this
signal battleEnded()
signal askedPlayerBattleInput(character)
signal battleCursorOpen(player, move)
signal battleWon(players, battleResult)
signal battleLost()
signal startedBattleAnimation(character, animation)
signal finishedBattleAnimation(character) # cue to resume logic


# inventory related
signal characterEquipedWeapon(character, weaponIndex)
signal characterEquipedArmor(character, armor)
signal characterUsedItem(character, itemIndex)
signal characterReceivedItemOrWeapon(character, entity)
signal characterDroppedItem(character, itemIndex)
signal characterDroppedWeapon(character, weaponIndex)


# UI related
# internal use
signal guiOpenWindow(window)
signal guiCloseWindow()
signal guiClearWindows()
signal guiUp()
signal guiDown()
signal guiLeft()
signal guiRight()
signal guiSelect() # used in a 'press A' context
signal guiConfirm(source) # used in an 'OK' button context
signal guiCancel(source)
signal guiHover(data) # listen to get which item the player has his cursor over

