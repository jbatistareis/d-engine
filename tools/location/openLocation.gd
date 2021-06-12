extends WindowDialog

var extensionRegex : RegEx = RegEx.new()


func _ready() -> void:
	extensionRegex.compile(GamePaths.EXTENSION_REGEX)
	
	$VBoxContainer/HBoxContainer/btnLoadFile.connect("pressed", self, "open")
	connect("visibility_changed", self, "listFiles")


func open() -> void:
	if $VBoxContainer/filesContainer.is_anything_selected():
		LocationEditorSignals.emit_signal(
			"fileOpened",
			$VBoxContainer/filesContainer.get_item_text($VBoxContainer/filesContainer.get_selected_items()[0]))
		hide()


func listFiles() -> void:
	$VBoxContainer/filesContainer.clear()
	
	if visible:
		var dir = Directory.new()
		if dir.open(GamePaths.LOCATION) == OK:
			dir.list_dir_begin()
			var file = dir.get_next()
			
			while !file.empty():
				if !dir.current_is_dir():
					$VBoxContainer/filesContainer.add_item(extensionRegex.sub(file, ''))
				file = dir.get_next()
		
		$VBoxContainer/filesContainer.sort_items_by_text()

