extends Node

# character
signal characterSpawned(spawnId, characterId)
signal characterDespawned(spawnId, characterId)
signal characterLeveledUp(spawnId, currentLevel)
signal characterGotExperience(spawnId, amount)
signal characterGainedHp(spawnId, amount)
signal characterLostHp(spawnId, amount)
signal characterDied(spawnId)

# armor
signal armorSpawned(spawnId, armorId)
signal armorDespawned(spawnId, armorId)
signal armorTookHit(spawnId, amount)
signal armorRepaired(spawnId, amount)

# weapon
signal weaponSpawned(spawnId, weaponId)
signal weaponDespawned(spawnId, weaponId)

# items
signal itemSpawned(spawnId, itemId)
signal itemDespawned(spawnId, itemId)

# room
signal characterArrivedRoom(characterSpawnId, roomSpawnId)
signal characterLeftRoom(characterSpawnId, roomSpawnId)

# location
signal characterArrivedLocation(characterSpawnId, locationId)
signal characterLeftLocation(characterSpawnId, locationId)
signal characterTravelledLocation(characterSpawnId, direction, currentRoomId, newRoomId)

# commands
signal publishedCommand(command)

# messages


