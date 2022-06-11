extends Tabs

var moveDto : MoveDTO = MoveDTO.new()
var list : Array = []


func _ready() -> void:
	EditorSignals.connect("selectedMove", self, "loadMove")
	
	loadAllData()
	setFields()


func loadMove(shortName : String) -> void:
	moveDto = Persistence.loadDTO(shortName, Enums.EntityType.MOVE)
	setFields()
	
	$background/mainSeparator/fileList.select(list.find(shortName))


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = moveDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = moveDto.shortName


func loadAllData() -> void:
	list = Persistence.listEntities(Enums.EntityType.MOVE)
	
	$background/mainSeparator/fileList.clear()
	for move in list:
		$background/mainSeparator/fileList.add_item(move)



# files list
func _on_fileList_item_selected(index):
	loadMove($background/mainSeparator/fileList.get_item_text(index))


