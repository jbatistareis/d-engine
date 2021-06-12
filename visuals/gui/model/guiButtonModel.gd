class_name GuiButtonModel
extends Control

var action : int = Enums.GuiAction.CONFIRM

# misc metadata
var text : String = ''
var disabled : bool = false
var identifier : String = ''
var hover : bool = false
var data = null

var label : Label = Label.new()
var bg : ColorRect = ColorRect.new()

# window metadata
var newWindow

# slide metadata
var slideLabels : Array = []
var slideValues : Array = []
var slideIndex : int = 0


func _ready() -> void:
	label.text = text
	
	add_child(bg)
	add_child(label)
	
	match action:
		Enums.GuiAction.SLIDE:
			label.text += ': ' + slideLabels[slideIndex]
		
		Enums.GuiAction.TOGGLE:
			if data == null:
				data = false
			
			label.text += ': ' + ('Yes' if data else 'No')
	
	rect_min_size = label.rect_size
	bg.rect_min_size = label.rect_size


func _process(delta : float) -> void:
	if hover:
		bg.color = Color.darkslategray
	else:
		bg.color = Color.transparent


func action() -> void:
	if !disabled:
		match action:
			Enums.GuiAction.CANCEL:
				Signals.emit_signal("guiCloseWindow")
			
			Enums.GuiAction.CONFIRM:
				Signals.emit_signal("guiConfirm", self)
			
			Enums.GuiAction.NEW_WINDOW:
				Signals.emit_signal("guiOpenWindow", newWindow)
			
			Enums.GuiAction.NEXT:
				# TODO
				pass
			
			Enums.GuiAction.PREVIOUS:
				# TODO
				pass
			
			Enums.GuiAction.SLIDE:
				slideIndex = (slideIndex + 1) % slideValues.size()
				data = slideValues[slideIndex]
				label.text = text.substr(0, text.length()) + ': ' + slideLabels[slideIndex]
			
			Enums.GuiAction.TOGGLE:
				data = !data
				label.text = text.substr(0, text.length()) + ': ' + ('Yes' if data else 'No')

