extends Node

signal selectedArmor(shortName)
signal selectedCharacter(shortName)
signal selectedDialog(shortName)
signal selectedInventory(shortName)
signal selectedItem(shortName)
signal selectedLocation(shortName)
signal selectedMove(shortName)
signal selectedVerdict(shortName)
signal selectedWeapon(shortName)

signal loadedMove(dto)

signal previewedVerdict(shortName)
signal previewedInventory(shortName)
signal previewedModel(shortName)

signal factMovedUp(node)
signal factMovedDown(node)
signal factRemoved(node)

signal selectedRooms(rooms)
signal hoveredRoom(room)
signal previewTile(locationShortName, modelName)

