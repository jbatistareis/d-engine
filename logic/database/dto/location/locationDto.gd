class_name LocationDTO
extends DTO

# IDs of rooms, portals, and spawns, are defined by the editor

var name : String = 'Base Location'
var shortName : String = 'BSELOC'
var description : String = 'Placeholder location'

# { id, x, y, type, orientation, model, exits, entryLogic, entranceLogic, exitLogic, foeShortNameGroups, visited } dict
var rooms: Array = [DefaultValues.roomBase]

var entranceLogic : String = DefaultValues.LOCATION_NOOP
var exitLogic : String = DefaultValues.LOCATION_NOOP

var encounterRate : float = 0.0

