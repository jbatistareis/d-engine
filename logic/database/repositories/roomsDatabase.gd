extends EntityDatabase


func _ready() -> void:
	self.useSameId = true


# TODO remove
var rooms : Array = [
	Room.new(1, 1, 2),
	Room.new(2, 1, 0, 2)
]

# TODO get from DB
func getEntity(id : int) -> Room:
	return rooms[id - 1]

