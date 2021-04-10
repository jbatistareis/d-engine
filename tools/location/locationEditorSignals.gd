extends Node

signal fileOpened(shortName)
signal loadedLocation(location)
signal selectedRoom(room, soloSelect) # used by grid
signal deselectedRoom(room) # used by grid
signal selectedItem(room) # used by tile
signal deselectedItem(room) # used by tile
signal testLocation(location, x, y, direction)

