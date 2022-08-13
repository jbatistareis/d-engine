class_name LocationDTO
extends DTO

# IDs of rooms, portals, and spawns, are defined by the editor

var name : String = 'Base Location'
var shortName : String = 'BSELOC'
var description : String = 'Placeholder location'

# { id, x, y, type, orientation, mesh, exits, portals, entranceLogic, exitLogic, friendlyShortNames, foeShortNameGroups, visited } dict
var rooms: Array = [DefaultValues.roomBase]

var entranceLogic : String = DefaultValues.LOCATION_NOOP
var exitLogic : String = DefaultValues.LOCATION_NOOP

var encounterRate : float = 0.0

