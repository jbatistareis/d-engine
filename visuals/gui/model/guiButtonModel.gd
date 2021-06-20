class_name GuiButtonModel
extends Control

var disabled : bool = false
var hover : bool = false

# presentation
var text : String
var action : int

# common metadata
var identifier : String
var data

# slide metadata
var slideLabels : Array = []
var slideValues : Array = []
var slideIndex : int = 0

var margin : MarginContainer = MarginContainer.new()
var label : Label = Label.new()
var bg : ColorRect = ColorRect.new()


func _init(text : String, action : int = Enums.GuiAction.CANCEL, data = null, identifier : String = '') -> void:
	self.text = text
	self.action = action
	self.data = data
	self.identifier = identifier
	self.disabled = disabled
	
	label.set("custom_colors/font_color", GuiTheme.TEXT_COLOR)
	label.text = text
	
	match action:
		Enums.GuiAction.SLIDE:
			label.text += ': ' + slideLabels[slideIndex]
		
		Enums.GuiAction.TOGGLE:
			if data == null:
				data = false
			
			label.text += ': ' + ('Yes' if data else 'No')
	
	margin.add_constant_override("margin_top", GuiTheme.MARGIN_SIZE)
	margin.add_constant_override("margin_left", GuiTheme.MARGIN_SIZE)
	margin.add_constant_override("margin_bottom", GuiTheme.MARGIN_SIZE)
	margin.add_constant_override("margin_right", GuiTheme.MARGIN_SIZE)
	
	margin.add_child(label)
	add_child(bg)
	add_child(margin)
	
	margin.anchor_bottom = 1
	margin.anchor_right = 1
	
	bg.anchor_bottom = 1
	bg.anchor_right = 1


func _ready() -> void:
	rect_min_size = margin.rect_size


func _process(delta : float) -> void:
	if hover:
		bg.color = GuiTheme.HOVER_COLOR
	else:
		bg.color = GuiTheme.UNSELECTED_COLOR


func fitWidth(value : float) -> void:
	rect_min_size.x = value


func action() -> void:
	if !disabled:
		match action:
			Enums.GuiAction.CANCEL:
				Signals.emit_signal("guiCloseWindow")
			
			Enums.GuiAction.CONFIRM:
				Signals.emit_signal("guiConfirm", self)
			
			Enums.GuiAction.NEW_WINDOW:
				Signals.emit_signal("guiOpenWindow", data)
			
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

