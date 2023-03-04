extends VBoxContainer

const _TITLE : String = "%s preview"
var factItem : PackedScene = preload("res://tools/tabs/character/factPreview.tscn")


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
	
	for child in $windows/verdict/facts/container.get_children():
		child.queue_free()
	
	var verdict = Persistence.loadDTO(shortName, Enums.EntityType.VERDICT)
	
	$windows/verdict/idGrid/lblNameValue.text = verdict.name
	$windows/verdict/idGrid/btnVerdictShortname.text = verdict.shortName
	
	var i = 1
	for fact in verdict.actions:
		var factScene = factItem.instantiate()
		$windows/verdict/facts/container.add_child(HSeparator.new())
		$windows/verdict/facts/container.add_child(factScene)
		
		factScene.factPosition = i
		factScene.fact = fact
		i += 1


func showInventory(shortName : String) -> void:
	$pvwTitle.title = _TITLE % "Inventory"
	$windows/lblNone.visible = false
	$windows/verdict.visible = false
	$windows/inventory.visible = true
	$windows/model.visible = false
	
	for child in $windows/inventory/items/scroll/container.get_children():
		child.queue_free()
	
	for child in $windows/inventory/weapons/scroll/container.get_children():
		child.queue_free()
	
	var inventory = Persistence.loadDTO(shortName, Enums.EntityType.INVENTORY)
	
	$windows/inventory/data/lblNameValue.text = inventory.name
	$windows/inventory/data/btnInvShortname.text = inventory.shortName
	$windows/inventory/data/btnArmName.text = inventory.armorShortName if (inventory.armorShortName != null) else "..."
	$windows/inventory/data/btnWpnName.text = inventory.weaponShortName if (inventory.weaponShortName != null) else "..."
	$windows/inventory/data/lblMoneyValue.text = str(inventory.money)
	
	$windows/inventory/data/btnArmName.disabled = (inventory.armorShortName == null)
	$windows/inventory/data/btnWpnName.disabled = (inventory.weaponShortName == null)
	
	for item in inventory.itemShortNames:
		var btnItem = LinkButton.new()
		btnItem.text = item
		btnItem.pressed.connect(func(): ToolSignals.selectedItem.emit(item))
		
		$windows/inventory/items/scroll/container.add_child(btnItem)
	
	for weapon in inventory.weaponShortNames:
		var btnWeapon = LinkButton.new()
		btnWeapon.text = weapon
		btnWeapon.pressed.connect(func(): ToolSignals.selectedWeapon.emit(weapon))
		
		$windows/inventory/items/scroll/container.add_child(btnWeapon)


func showModel(shortName : String) -> void:
	$pvwTitle.title = _TITLE % "Model"
	$windows/lblNone.visible = false
	$windows/verdict.visible = false
	$windows/inventory.visible = false
	$windows/model.visible = true


func _on_btn_verdict_shortname_pressed() -> void:
	ToolSignals.selectedVerdict.emit($windows/verdict/idGrid/btnVerdictShortname.text)

