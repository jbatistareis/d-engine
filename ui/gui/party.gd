extends MarginContainer

const _BTN_SIZE : Vector2 = Vector2(82, 28)

# TODO user theme
var defaultTheme : Theme = preload("res://assets/theme/default/default.theme")
var item : Item


# TODO party
func open(item : Item) -> void:
	self.item = item
	visible = true
	
	for child in $container.get_children():
		child.queue_free()
	
	for character in [GameManager.player]:
		$container.add_child(createButton(character))
	
	$container.get_child(0).grab_focus()


func close() -> void:
	visible = false
	
	for child in $container.get_children():
		child.queue_free()


func createButton(character : Character) -> Button:
	var button = Button.new()
	button.theme = defaultTheme
	button.flat = true
	button.rect_min_size = _BTN_SIZE
	button.text = character.name
	button.connect("pressed", self, "use", [character])
	
	return button


func use(character : Character) -> void:
	var inventoryItem = character.inventory.items.bsearch_custom(item.shortName, EntityArrayHelper, 'shortNameFind')
	character.inventory.removeItem(inventoryItem)
	
	ScriptTool.getReference(inventoryItem.excuteExpression).execute([character])
	

