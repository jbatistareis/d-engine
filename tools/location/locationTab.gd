extends Tabs

var locationDto : LocationDTO


func _ready() -> void:
	loadLocation(LocationDTO.new())


func loadLocation(locationDto : LocationDTO) -> void:
	self.locationDto = locationDto
	$background/mainDivider/map/scroll/grid.loadRooms(self.locationDto.roomDicts)

