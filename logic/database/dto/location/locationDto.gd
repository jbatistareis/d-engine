class_name LocationDTO
extends DTO

# IDs of rooms, portals, and spawns, are defined by the editor

var name : String = 'Base Location'
var shortName : String = 'BSELOC'
var description : String = 'Placeholder location'

# { id, x, y, type, orientation, mesh, exits, portals, entranceLogic, exitLogic, friendlyShortNames, foeShortNameGroups, visited } dict
var roomDicts : Array = [GameParameters.roomBase]

# { id, passLogic, newLocationShortName, toSpawnId } dict
var portals : Array = [GameParameters.portalBase]

# { id, direction, toRoomId } dict
var spawns : Array = [GameParameters.spwanBase]

var entranceLogic : String = GameParameters.LOCATION_NOOP
var exitLogic : String = GameParameters.LOCATION_NOOP

var encounterRate : float = 0.0

