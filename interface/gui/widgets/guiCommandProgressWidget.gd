class_name GuiCommandProgressWidget
extends GuiWidget

var character : Character

var hBox = HBoxContainer.new()
var barContainer = MarginContainer.new()
var margin = MarginContainer.new()
var label = Label.new()
var bar1 : ColorRect = ColorRect.new()
var bar2 : ColorRect = ColorRect.new()
var tween = Tween.new()


func _init(character : Character) -> void:
	self.character = character
	
	Signals.connect("characterPreTimerSet", self, "beginPre")
	Signals.connect("characterPosTimerSet", self, "beginPos")
	Signals.connect("characterTimerPaused", self, "pauseCharacter")
	Signals.connect("characterTimerResumed", self, "resumeCharacter")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	
	var labelText = PoolStringArray([' ', ' ', ' ', ' ', ' ', ' ', ' '])
	
	var i = 0
	for ch in character.shortName:
		labelText.set(i, ch)
		i += 1
	
	label.set('custom_colors/font_color', GuiTheme.TEXT_COLOR)
	label.add_font_override('font', GuiTheme.font)
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.text = labelText.join('')
	
	bar1.color = GuiTheme.COMMAND_PRG_POS
	bar2.color = GuiTheme.COMMAND_PRG_PRE
	
	barContainer.add_child(bar2)
	barContainer.add_child(bar1)
	
	hBox.add_child(label)
	hBox.add_child(barContainer)
	
	margin.add_child(hBox)
	
	add_child(margin)
	add_child(tween)


func _enter_tree() -> void:
	barContainer.rect_min_size = hBox.rect_size + Vector2(200, 0)


func _ready() -> void:
	rect_min_size = hBox.rect_size
	
	yield(get_tree(), "idle_frame")
	bar1.rect_size.x = 0


func progress(percent : float) -> void:
	bar1.rect_size.x = 200 * percent


func beginPre(character : Character, ticks : int) -> void:
	if character == self.character:
		yield(get_tree(), "idle_frame")
		bar1.color = GuiTheme.COMMAND_PRG_PRE
		bar2.color = GuiTheme.COMMAND_PRG_POS
		bar1.rect_size.x = 0
		tween.interpolate_method(self, "progress", 0, 1, GameParameters.GCD * ticks)
		tween.start()


func beginPos(character : Character, ticks : int) -> void:
	if character == self.character:
		yield(get_tree(), "idle_frame")
		bar1.color = GuiTheme.COMMAND_PRG_POS
		bar2.color = GuiTheme.COMMAND_PRG_PRE
		bar1.rect_size.x = 0
		tween.interpolate_method(self, "progress", 0, 1, GameParameters.GCD * ticks)
		tween.start()


func pause() -> void:
	tween.stop_all()


func resume() -> void:
	tween.resume_all()


func pauseCharacter(character : Character) -> void:
	if character == self.character:
		pause()


func resumeCharacter(character : Character) -> void:
	if character == self.character:
		resume()

