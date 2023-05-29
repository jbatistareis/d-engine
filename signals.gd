extends Node

# signals marked as internal use should not be manually fired

# player related
# start a match by calling 'playerLoaded' with a save filename
# controls provided by Godots ui_* signals, see each state logic for mappings
signal playerLoaded(saveSlotName) # TODO loads all data, changes scene, spawns the player
signal playerSaved(saveSlotName) # TODO gathers all data, saves to file
signal changedEncounterRate(value) # changes location encounter rate

# listen for annoucements
signal playerArrivedLocation(location) # when a player spawns
signal playerLeftLocation(location) # when a player leaves
signal playerChangedRoom(direction) # when a player successfully moves (Direction enum)
signal playerRoomChangeDenied() # when a player cant change rooms

# internal use
signal playerSpawned(location, x, y, direction) # fired to set up 3d map and camera
signal playerInteracted(direction) # fired when players presses the action button while idle
signal cameraMovedForward()
signal cameraMovedBackward()
signal cameraRotatedLeft()
signal cameraRotatedRight()
signal cameraSnapped(x, y, facingDirection)


# animation related
# fired to start/wait for an animation on the scenery
# the listener has to be hardcoded on the scene that will run the animation
signal startedMiscAnimation(animationName)
signal endedMiscAnimation(animationName) 


# character related, listen for announcements
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
signal commandOnQueue(command) # when a command is put checked execution queue
signal commandsCleared() # removes all commands


# battle related
signal battleStarted(players, enemies) # change to battle state

# listen for announcements
signal battleWon(players, battleResult)
signal battleLost()

# internal use
signal setupBattleScreen(players, enemies) # for transition animation
signal battleScreenReady() # fired when animation is done, logic starts after this
signal battleEnded()
signal startedBattleAnimation(character, animation)
signal finishedBattleAnimation(character) # cue to resume logic
signal battleAskedMove(character)
signal battlePickedMove(player, move)
signal battleMoveDescription(text)
signal battleSetCursorPosition(character, position)
signal battleCursorShow(player, move)
signal battleShowResult(battleResult)
signal battleInventoryShow(character)
signal battleInventoryHide()


# inventory related
signal characterEquipedWeapon(character, weapon)
signal characterEquipedArmor(character, armor)
signal characterUsedItem(user, receivers, item)

signal characterReceivedWeapon(character, weapon)
signal characterReceivedArmor(character, armor)
signal characterReceivedItem(character, item)

signal characterDroppedWeapon(character, weapon)
signal characterDroppedArmor(character, armor)
signal characterDroppedItem(character, item)


# ui related
# internal use
signal guiUp()
signal guiDown()
signal guiLeft()
signal guiRight()
signal guiConfirm()
signal guiCancel()
signal guiBack()
signal guiOpenExploringMenu()
signal guiCloseExploringMenu()
signal guiPartyMenuPick(index)
signal guiPopupPartyMenu(position)
signal guiHidePartyMenu()
signal guiPartyMenuHidden()


# toast related
signal permanentToast(message)
signal normalToast(message)
signal hideToast()

