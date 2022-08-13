extends Node

# signals marked as internal use should not be manually fired

# player related
# to start a match: playerEnteredGame -> playerTransferedLocation
# controls provided by Godots ui_* signals, see each state logic for mappings
signal playerEnteredGame(playerCharacter) # sets the current GameManager.player
signal changedEncounterRate(value) # changes location encounter rate

# listen to get annoucements
signal playerArrivedLocation(location) # when a player spawns
signal playerLeftLocation(location) # when a player leaves
signal playerChangedRoom(direction) # when a player successfully moves (Direction enum)
signal playerRoomChangeDenied() # when a player cant change rooms

# internal use
signal playerSpawned(location, x, y, direction) # fired to set up 3d map and camera

# moves camera, internal use
signal cameraMovedForward()
signal cameraMovedBackward()
signal cameraRotatedLeft()
signal cameraRotatedRight()
signal cameraSnapped(x, y, facingDirection)


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
signal commandsCleared() # removes all commands


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
signal battleShowCharacterMoves(character)
signal battleHideCharacterMoves()
signal battleCursorMove(title, position)
signal battleCursorHide()
signal battleShowResult(battleResult)


# inventory related
signal characterEquipedWeapon(character, weaponIndex)
signal characterEquipedArmor(character, armor)
signal characterUsedItem(character, itemIndex)
signal characterReceivedItemOrWeapon(character, entity)
signal characterDroppedItem(character, itemIndex)
signal characterDroppedWeapon(character, weaponIndex)


# ui related
# internal use
signal guiUp()
signal guiDown()
signal guiLeft()
signal guiRight()
signal guiConfirm()
signal guiCancel()
signal guiOpenExploringMenu()
signal guiCloseExploringMenu()

