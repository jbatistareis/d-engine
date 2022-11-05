extends MarginContainer

const _BTN_NAME = 'btn%d'
const _BTN_FOCUS_NAME = '../btn%d'

# TODO user theme
var defaultTheme : Theme = preload("res://assets/theme/default/default.theme")
var item : Item


# TODO party
func open(item : Item, position : Vector2) -> void:
	for child in $container.get_children():
		child.queue_free()
	
	self.item = item
	visible = true
	
	var btnIndex = 0
	for character in [GameManager.player]:
		var button = createButton(character)
		button.name = _BTN_NAME % btnIndex
		$container.add_child(button)
	
	for index in range($container.get_child_count()):
		$container.get_child(index).focus_neighbour_top = NodePath(_BTN_FOCUS_NAME % max(0, (index + 1) % $container.get_child_count()))
		$container.get_child(index).focus_neighbour_bottom = NodePath(_BTN_FOCUS_NAME % ((index + 1) % $container.get_child_count()))
		
		$container.get_child(index).focus_next = $container.get_child(index).focus_neighbour_bottom
		$container.get_child(index).focus_previous = $container.get_child(index).focus_neighbour_top
	
	$container.get_child(0).grab_focus()
	
	set_deferred("rect_position", position)


func close() -> void:
	visible = false
	
	for child in $container.get_children():
		child.queue_free()


func createButton(character : Character) -> Button:
	var button = Button.new()
	button.theme = defaultTheme
	button.flat = true
	button.text = character.name
	button.connect("pressed", self, "use", [character])
	
	return button


func use(character : Character) -> void:
	var index = character.inventory.items.bsearch_custom(item.shortName, EntityArrayHelper, 'shortNameFind')
	var inventoryItem = character.inventory.removeItem(index)
	
	ScriptTool.getReference(inventoryItem.actionExpression).execute([character])
	
	close()
	get_parent().showWindow(character)

