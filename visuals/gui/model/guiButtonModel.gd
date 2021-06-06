class_name GuiButtonModel

var label : String = ''
var action : int = Enums.GuiAction.CONFIRM

# misc metadata
var identifier : String = ''
var hover : bool = false
var disabled : bool = false
var data = null

# window metadata
var newWindow

# slide metadata
var slideOrientation : int = Enums.GuiOrientation.HORIZONTAL
var slideLabels : Array = []
var slideValues : Array = []
var slideIndex : int = 0


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
			
			Enums.GuiAction.TOGGLE:
				data = true if (data == null) else !data

