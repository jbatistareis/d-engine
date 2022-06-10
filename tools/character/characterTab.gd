extends Tabs

var characterDto : CharacterDTO = CharacterDTO.new()


func _ready() -> void:
	setFields()
	loadAllData()


func loadCharacter(shortName : String) -> void:
	characterDto = Persistence.loadDTO(shortName, Enums.EntityType.CHARACTER)
	setFields()


func setFields() -> void:
	pass


func loadAllData() -> void:
	pass



# files list
func _on_fileList_item_selected(index):
	loadCharacter($background/mainSeparator/fileList.get_item_text(index))



# identification
func _on_txtName_text_changed(new_text):
	pass # Replace with function body.


func _on_txtShortName_text_changed(new_text):
	pass # Replace with function body.


func _on_optType_item_selected(index):
	pass # Replace with function body.



# hp
func _on_sbBaseHp_value_changed(value):
	pass # Replace with function body.


func _on_sbCurrentHp_value_changed(value):
	pass # Replace with function body.


func _on_sbExtraHp_value_changed(value):
	pass # Replace with function body.



# stats
func _on_sbStrength_value_changed(value):
	pass # Replace with function body.


func _on_sbDexterity_value_changed(value):
	pass # Replace with function body.


func _on_sbConstitution_value_changed(value):
	pass # Replace with function body.


func _on_sbIntelligence_value_changed(value):
	pass # Replace with function body.


func _on_sbWisdom_value_changed(value):
	pass # Replace with function body.


func _on_sbCharisma_value_changed(value):
	pass # Replace with function body.



# misc
func _on_optInventory_item_selected(index):
	pass # Replace with function body.


func _on_optVerdict_item_selected(index):
	pass # Replace with function body.


func _on_optModel_item_selected(index):
	pass # Replace with function body.



# view
func _on_btnViewInventory_pressed():
	pass # Replace with function body.


func _on_btnViewVerdict_pressed():
	pass # Replace with function body.


func _on_btnViewModel_pressed():
	pass # Replace with function body.


func _on_btnEditInventory_pressed():
	pass # Replace with function body.


func _on_btnEditVerdict_pressed():
	pass # Replace with function body.



# buttons
func _on_btnSave_pressed():
	Persistence.saveDTO(characterDto)
	loadAllData()


func _on_btnReload_pressed():
	loadAllData()
	setFields()

