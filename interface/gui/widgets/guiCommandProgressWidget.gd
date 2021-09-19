class_name GuiCommandProgressWidget
extends GuiWidget

var gcd : float = 0.25 # TODO make external

var character : Character

var hBox = HBoxContainer.new()
var barContainer = MarginContainer.new()
var margin = MarginContainer.new()
var label = Label.new()
var pre : ColorRect = ColorRect.new()
var pos : ColorRect = ColorRect.new()
var tween = Tween.new()


func _init(character : Character) -> void:
	self.character = character
	
	Signals.connect("characterPreTimerSet", self, "beginPre")
	Signals.connect("characterPosTimerSet", self, "beginPos")
	Signals.connect("characterTimerPaused", self, "pauseCharacter")
	Signals.connect("characterTimerResumed", self, "resumeCharacter")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	
	var name = PoolStringArray([' ', ' ', ' ', ' ', ' ', ' ', ' '])
	
	var i = 0
	for ch in character.shortName:
		name.set(i, ch)
		i += 1
	
	label.set('custom_colors/font_color', GuiTheme.TEXT_COLOR)
	label.add_font_override('font', GuiTheme.font)
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.text = name.join('')
	
	pre.color = GuiTheme.COMMAND_PRG_PRE
	pos.color = GuiTheme.COMMAND_PRG_POS
	
	barContainer.add_child(pre)
	barContainer.add_child(pos)
	
	hBox.add_child(label)
	hBox.add_child(barContainer)
	
	margin.add_child(hBox)
	
	add_child(margin)
	add_child(tween)


func _enter_tree() -> void:
	barContainer.rect_min_size = hBox.rect_size + Vector2(200, 0)


func _ready() -> void:
	rect_min_size = hBox.rect_size


func progressPre(percent : float) -> void:
	pre.rect_size.x = 200 * percent


func progressPos(percent : float) -> void:
	pos.rect_size.x = 200 * percent


func beginPre(character : Character, ticks : int) -> void:
	if character == self.character:
		barContainer.move_child(pre, 1)
		tween.interpolate_method(self, "progressPre", 0, 1, gcd * ticks)
		tween.start()


func beginPos(character : Character, ticks : int) -> void:
	if character == self.character:
		barContainer.move_child(pos, 1)
		tween.interpolate_method(self, "progressPos", 0, 1, gcd * ticks)
		tween.start()


func pause() -> void:
	tween.stop_all()


func resume() -> void:
	tween.resume_all()


func pauseCharacter(character : Character) -> void:
	if character == self.character:
		tween.stop_all()


func resumeCharacter(character : Character) -> void:
	if character == self.character:
		tween.resume_all()

