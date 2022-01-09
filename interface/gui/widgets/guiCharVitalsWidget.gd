class_name GuiCharVitalsWidget
extends GuiWidget

var character : Character

var hBox = HBoxContainer.new()
var hpArmBarBox = MarginContainer.new()
var timerBarContainer = MarginContainer.new()
var label = Label.new()
var posBar : ColorRect = ColorRect.new()
var preBar : ColorRect = ColorRect.new()
var hpBar : ColorRect = ColorRect.new()
var deadBar : ColorRect = ColorRect.new()
var armorBar : ColorRect = ColorRect.new()
var timerTween = Tween.new()
var hpTween = Tween.new()
var armorTween = Tween.new()


func _init(character : Character) -> void:
	self.character = character
	
	Signals.connect("characterPreTimerSet", self, "beginPre")
	Signals.connect("characterPosTimerSet", self, "beginPos")
	Signals.connect("characterTimerPaused", self, "pauseCharacter")
	Signals.connect("characterTimerResumed", self, "resumeCharacter")
	Signals.connect("characterGainedHp", self, "hpBarChange")
	Signals.connect("characterLostHp", self, "hpBarChange")
	Signals.connect("armorTookHit", self, "armorBarChange")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	
	var labelText = PoolStringArray([' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])
	
	var i = 0
	for ch in character.shortName:
		labelText.set(i, ch)
		i += 1
	
	label.set('custom_colors/font_color', GuiTheme.TEXT_COLOR)
	label.add_font_override('font', GuiTheme.font)
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.text = labelText.join('')
	
	posBar.color = GuiTheme.COMMAND_PRG_POS
	preBar.color = GuiTheme.COMMAND_PRG_PRE
	
	deadBar.color = GuiTheme.DEAD_BAR
	hpBar.color = GuiTheme.HP_BAR
	armorBar.color = GuiTheme.ARMOR_BAR
	
	timerBarContainer.add_child(preBar)
	timerBarContainer.add_child(posBar)
	timerBarContainer.rect_min_size = Vector2(200, 0)
	
	hpArmBarBox.add_child(deadBar)
	hpArmBarBox.add_child(hpBar)
	hpArmBarBox.add_child(armorBar)
	hpArmBarBox.rect_min_size = Vector2(200, 0)
	
	hBox.add_child(label)
	hBox.add_child(hpArmBarBox)
	hBox.add_child(timerBarContainer)
	
	add_child(hBox)
	add_child(timerTween)
	add_child(hpTween)
	add_child(armorTween)


func _ready() -> void:
	rect_min_size = hBox.rect_size
	
	yield(get_tree(), "idle_frame")
	armorBar.rect_size.y = hBox.rect_size.y * 0.5
	posBar.rect_size.x = 0
	
	hpBarSize(character.currentHp / float(character.maxHp))
	if character.inventory.armor != null:
		armorBarSize(character.inventory.armor.currentProtection / float(character.inventory.armor.maxProtection))
	else:
		armorBarSize(0)


func timerProgress(percent : float) -> void:
	posBar.rect_size.x = 200 * percent


func beginPre(character : Character, ticks : int) -> void:
	if self.character.currentHp == 0:
		dead()
		return
	
	if character == self.character:
		posBar.color = GuiTheme.COMMAND_PRG_PRE
		preBar.color = GuiTheme.COMMAND_PRG_POS
		posBar.rect_size.x = 0
		timerTween.interpolate_method(self, "timerProgress", 0, 1, GameParameters.GCD * ticks)
		timerTween.start()


func beginPos(character : Character, ticks : int) -> void:
	if self.character.currentHp == 0:
		dead()
		return
	
	if character == self.character:
		posBar.color = GuiTheme.COMMAND_PRG_POS
		preBar.color = GuiTheme.COMMAND_PRG_PRE
		posBar.rect_size.x = 0
		timerTween.interpolate_method(self, "timerProgress", 0, 1, GameParameters.GCD * ticks)
		timerTween.start()


func hpBarSize(percent : float) -> void:
	hpBar.rect_size.x = 200 * percent


func armorBarSize(percent : float) -> void:
	armorBar.rect_size.x = 200 * percent


func hpBarChange(character : Character, amount : int) -> void:
	if character == self.character:
		hpTween.remove_all()
		hpTween.interpolate_method(
			self,
			"hpBarSize",
			hpBar.rect_size.x / 200.0,
			character.currentHp / float(character.maxHp),
			0.2
		)
		hpTween.start()


func armorBarChange(armor : Armor, amount : int) -> void:
	if armor == character.inventory.armor:
		armorTween.remove_all()
		armorTween.interpolate_method(
			self,
			"armorBarSize",
			armorBar.rect_size.x / 200.0,
			armor.currentProtection / float(armor.maxProtection),
			0.2
		)
		armorTween.start()


func dead() -> void:
	posBar.color = GuiTheme.COMMAND_DEAD
	preBar.color = GuiTheme.COMMAND_DEAD
	hpBar.color = GuiTheme.DEAD_BAR
	armorBar.color = GuiTheme.DEAD_BAR


func pause() -> void:
	timerTween.stop_all()


func resume() -> void:
	timerTween.resume_all()


func pauseCharacter(character : Character) -> void:
	if character == self.character:
		pause()


func resumeCharacter(character : Character) -> void:
	if character == self.character:
		resume()

