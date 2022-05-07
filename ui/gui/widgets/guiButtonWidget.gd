class_name GuiButtonWidget
extends GuiWidget

var disabled : bool = false
var hover : bool = false

# presentation
var text : String
var action : int
var closeOnConfirm : bool = true

# common metadata
var identifier : String
var data

# slide metadata
var slideLabels : Array = []
var slideValues : Array = []
var slideIndex : int = 0

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
	
	add_child(bg)
	add_child(label)


func _ready() -> void:
	label.rect_position += (GuiTheme.WIDGET_PADDING / 2)
	rect_min_size = label.rect_size + GuiTheme.WIDGET_PADDING


func _process(delta : float) -> void:
	bg.color = GuiTheme.HOVER_COLOR if hover else GuiTheme.UNSELECTED_COLOR


func fitWidth(value : float) -> void:
	rect_min_size.x = value
	bg.rect_min_size = rect_min_size


func action() -> void:
	if !disabled:
		match action:
			Enums.GuiAction.CANCEL:
				Signals.emit_signal("guiCancel", self)
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

