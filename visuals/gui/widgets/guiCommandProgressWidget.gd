class_name GuiCommandProgressWidget
extends GuiWidget

var gcd : float = 0.25 # TODO make external

var character : Character

var hBox = HBoxContainer.new()
var barContainer = MarginContainer.new()
var bg : ColorRect = ColorRect.new()
var pre : ColorRect = ColorRect.new()
var pos : ColorRect = ColorRect.new()
var tween = Tween.new()


func _init(character : Character) -> void:
	self.character = character
	
	Signals.connect("characterPreTimerSet", self, "beginPre")
	Signals.connect("characterPosTimerSet", self, "beginPos")
	Signals.connect("characterTimerPaused", self, "pause")
	Signals.connect("characterTimerResumed", self, "resume")
	
	var name = PoolStringArray([' ', ' ', ' ', ' ', ' ', ' ', ' | '])
	
	var i = 0
	for ch in character.shortName:
		name.set(i, ch)
		i += 1
	
	var label = Label.new()
	label.set("custom_colors/font_color", GuiTheme.TEXT_COLOR)
	label.add_font_override('font', GuiTheme.font)
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.text = name.join('')
	
	barContainer.add_child(bg)
	barContainer.add_child(pre)
	barContainer.add_child(pos)
	bg.color = GuiTheme.COMMAND_PRG_BG
	pre.color = GuiTheme.COMMAND_PRG_PRE
	pos.color = GuiTheme.COMMAND_PRG_POS
	
	hBox.add_child(label)
	hBox.add_child(barContainer)
	
	add_child(hBox)
	add_child(tween)


func _enter_tree() -> void:
	yield(get_tree(), "idle_frame")
	
	rect_min_size = hBox.rect_size
	
	bg.rect_size = Vector2(200, rect_min_size.y)
	pre.rect_size = Vector2(0, rect_min_size.y)
	pos.rect_size = Vector2(0, rect_min_size.y)


func _ready() -> void:
	rect_min_size = hBox.rect_size


func progressPre(percent : float) -> void:
	pre.rect_size.x = 200 * percent


func progressPos(percent : float) -> void:
	pos.rect_size.x = 200 * percent


func beginPre(character : Character, ticks : int) -> void:
	if character == self.character:
		tween.interpolate_method(self, "progressBg", 0, 1, gcd * ticks)
		tween.start()


func beginPos(character : Character, ticks : int) -> void:
	if character == self.character:
		tween.interpolate_method(self, "progressBar", 0, 1, gcd * ticks)
		tween.start()


func pause(character : Character) -> void:
	if character == self.character:
		tween.stop_all()


func resume(character : Character) -> void:
	if character == self.character:
		tween.resume_all()

