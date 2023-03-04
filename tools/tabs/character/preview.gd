extends VBoxContainer

const _TITLE : String = "%s preview"


func _ready() -> void:
	ToolSignals.previewedVerdict.connect(showVerdict)
	ToolSignals.previewedInventory.connect(showInventory)
	ToolSignals.previewedModel.connect(showModel)


func showVerdict(shortName : String) -> void:
	$pvwTitle.title = _TITLE % "Verdict"
	$windows/lblNone.visible = false
	$windows/verdict.visible = true
	$windows/inventory.visible = false
	$windows/model.visible = false


func showInventory(shortName : String) -> void:
	$pvwTitle.title = _TITLE % "Inventory"
	$windows/lblNone.visible = false
	$windows/verdict.visible = true
	$windows/inventory.visible = false
	$windows/model.visible = false


func showModel(shortName : String) -> void:
	$pvwTitle.title = _TITLE % "Model"
	$windows/lblNone.visible = false
	$windows/verdict.visible = true
	$windows/inventory.visible = false
	$windows/model.visible = false

