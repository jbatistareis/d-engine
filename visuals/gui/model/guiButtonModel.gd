class_name GuiButtonModel
extends Control

var action : int = Enums.GuiAction.CANCEL

# misc metadata
var text : String = ''
var disabled : bool = false
var identifier : String = ''
var hover : bool = false
var data = null

# slide metadata
var slideLabels : Array = []
var slideValues : Array = []
var slideIndex : int = 0

var label = Label.new()
var bg = ColorRect.new()


func _init(text : String, action : int = Enums.GuiAction.CANCEL, data = null, identifier : String = '', disabled : bool = false) -> void:
	self.text = text
	self.action = action
	self.data = data
	self.identifier = identifier
	self.disabled = disabled
	
	label.set("custom_colors/font_color", GuiColors.TEXT_COLOR)
	
	add_child(bg)
	add_child(label)


func _process(delta : float) -> void:
	if hover:
		bg.color = GuiColors.HOVER_COLOR
	else:
		bg.color = Color.transparent


func _enter_tree() -> void:
	label.text = text
	
	match action:
		Enums.GuiAction.SLIDE:
			label.text += ': ' + slideLabels[slideIndex]
		
		Enums.GuiAction.TOGGLE:
			if data == null:
				data = false
			
			label.text += ': ' + ('Yes' if data else 'No')
	
	yield(get_tree(), "idle_frame")
	rect_min_size = label.rect_size
	bg.rect_min_size = label.rect_size


func action() -> void:
	if !disabled:
		match action:
			Enums.GuiAction.CANCEL:
				Signals.emit_signal("guiCloseWindow")
			
			Enums.GuiAction.CONFIRM:
				Signals.emit_signal("guiConfirm", self)
			
			Enums.GuiAction.NEW_WINDOW:
				Signals.emit_signal("guiOpenWindow", data, Vector2.ZERO)
			
			Enums.GuiAction.NEXT:
				# TODO
				pass
			
			Enums.GuiAction.PREVIOUS:
				# TODO
				pass
			
			Enums.GuiAction.SLIDE:
				slideIndex = (slideIndex + 1) % slideValues.size()
				data = slideValues[slideIndex]
				label.text = text + ': ' + slideLabels[slideIndex]
			
			Enums.GuiAction.TOGGLE:
				data = !data
				label.text = text + ': ' + ('Yes' if data else 'No')

