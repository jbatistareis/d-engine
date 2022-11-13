extends Tabs

var verdictDto : VerdictDTO = VerdictDTO.new()
var list : Array = []

var actionScene : PackedScene = preload("res://tools/verdict/action/action.tscn")

onready var fileList : ItemList = $background/mainSeparator/fileList
onready var actionList : VBoxContainer = $background/mainSeparator/dataPanel/dataContainer/actions/data/scroll/VBoxContainer


func _ready() -> void:
	EditorSignals.connect("selectedVerdict", self, "loadVerdict")
	
	loadData()
	setFields()


func loadData() -> void:
	fileList.clear()
	list = Persistence.listEntities(Enums.EntityType.VERDICT)
	for item in list:
		fileList.add_item(item)


func loadVerdict(shortName : String) -> void:
	verdictDto = Persistence.loadDTO(shortName, Enums.EntityType.VERDICT)
	fileList.select(list.find(verdictDto.shortName))
	setFields()


func setFields() -> void:
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtName.text = verdictDto.name
	$background/mainSeparator/dataPanel/dataContainer/identification/fields/grid/txtShortName.text = verdictDto.shortName
	
	for card in actionList.get_children():
		card.queue_free()
	
	for action in verdictDto.actions:
		
		var actionCard = actionScene.instance()
		actionList.add_child(actionCard)
		
		actionCard.actionDict = action


func _on_fileList_item_selected(index):
	loadVerdict(fileList.get_item_text(index))


func _on_txtName_text_changed(new_text):
	verdictDto.name = new_text


func _on_txtShortName_text_changed(new_text):
	verdictDto.shortName = new_text


func _on_btnSave_pressed():
	$saveConfirm.entityName = verdictDto.shortName
	$saveConfirm.popup_centered()


func _on_btnReload_pressed():
	loadData()
	fileList.select(list.find(verdictDto.shortName))


func _on_saveConfirm_confirmed():
	verdictDto.actions.clear()
	
	for card in actionList.get_children():
		verdictDto.actions.append(card.actionDict)
	
	Persistence.saveDTO(verdictDto)
	_on_btnReload_pressed()


func _on_btnAdd_pressed():
	var actionCard = actionScene.instance()
	actionList.add_child(actionCard)
	
	actionCard.actionDict = DefaultValues.actionBase

