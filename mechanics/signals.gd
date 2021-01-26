extends Node

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

# room
signal characterArrivedRoom(character, room)
signal characterLeftRoom(character, room)

# location
signal characterArrivedLocation(character, location)
signal characterLeftLocation(character, oldLocation, newLocation)
signal characterTravelledLocation(character, direction, fromRoom, toRoom)

# commands
signal publishedCommand(command)

# messages


