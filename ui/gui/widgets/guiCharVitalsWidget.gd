class_name GuiCharVitalsWidget
extends GuiWidget

const BAR_SIZE : float = 150.0

var character : Character

var hBox : HBoxContainer = HBoxContainer.new()
var hpArmBarBox : MarginContainer = MarginContainer.new()
var timerBarContainer : MarginContainer = MarginContainer.new()
var label : Label = Label.new()
var timerBar1 : ColorRect = ColorRect.new()
var timerBar2 : ColorRect = ColorRect.new()
var hpBar : ColorRect = ColorRect.new()
var deadBar : ColorRect = ColorRect.new()
var armorBar : ColorRect = ColorRect.new()
var timerTween : Tween = Tween.new()
var hpTween : Tween = Tween.new()
var armorTween : Tween = Tween.new()


func _init(character : Character) -> void:
	self.character = character
	
	Signals.connect("commandOnQueue", self, "commandQueued")
	Signals.connect("characterChangedHp", self, "hpBarChange")
	Signals.connect("armorChangedIntegrity", self, "armorBarChange")
	Signals.connect("characterChangedExtraHp", self, "extraHpBarChange")
	Signals.connect("characterDied", self, "dead")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	
	var labelText = PoolStringArray([' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])
	
	var i = 0
	for ch in character.shortName:
		labelText.set(i, ch)
		i += 1
	
	label.set('custom_colors/font_color', GuiTheme.TEXT_COLOR)
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	label.text = labelText.join('')
	
	timerBar1.color = GuiTheme.COMMAND_PRG_POS
	timerBar2.color = GuiTheme.COMMAND_PRG_PRE
	
	deadBar.color = GuiTheme.DEAD_BAR
	hpBar.color = GuiTheme.HP_BAR
	armorBar.color = GuiTheme.ARMOR_BAR
	
	timerBarContainer.add_child(timerBar2)
	timerBarContainer.add_child(timerBar1)
	timerBarContainer.rect_min_size = Vector2(BAR_SIZE, 0)
	
	hpArmBarBox.add_child(deadBar)
	hpArmBarBox.add_child(hpBar)
	hpArmBarBox.add_child(armorBar)
	hpArmBarBox.rect_min_size = Vector2(BAR_SIZE, 0)
	
	hBox.add_child(label)
	hBox.add_child(hpArmBarBox)
	hBox.add_child(timerBarContainer)
	hBox.add_constant_override('separation', GuiTheme.WIDGET_PADDING.x)
	
	add_child(hBox)
	add_child(timerTween)
	add_child(hpTween)
	add_child(armorTween)


func _ready() -> void:
	hBox.rect_position += (GuiTheme.WIDGET_PADDING / 2)
	rect_min_size = hBox.rect_size + GuiTheme.WIDGET_PADDING
	
	yield(get_tree(), "idle_frame")
	armorBar.rect_size.y = hBox.rect_size.y * 0.5
	timerBar1.rect_size.x = 0
	
	hpBarSize(character.currentHp / float(character.maxHp))
	
	if character.inventory.armor != null:
		if character.inventory.armor.maxIntegrity > 0:
			armorBarSize(character.inventory.armor.currentIntegrity / float(character.inventory.armor.maxIntegrity))
		else:
			armorBarSize(0)
	else:
		armorBarSize(0)


func commandQueued(command : Command) -> void:
	if command.executorCharacter == character:
		timerTween.remove_all()
		
		if command is ExecuteMoveCommand: # pre
			timerBar1.color = GuiTheme.COMMAND_PRG_PRE
			timerBar2.color = GuiTheme.COMMAND_PRG_POS
		else: # pos
			timerBar1.color = GuiTheme.COMMAND_PRG_POS
			timerBar2.color = GuiTheme.COMMAND_PRG_PRE
		
		timerBar1.rect_size.x = 0
		timerTween.interpolate_method(self, "timerProgress", 0, 1, GameParameters.GCD * command.totalTicks)
		timerTween.start()


func hpBarChange(character : Character, amount : int) -> void:
	if character == self.character:
		hpTween.remove_all()
		hpTween.interpolate_method(
			self,
			"hpBarSize",
			hpBar.rect_size.x / BAR_SIZE,
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
			armorBar.rect_size.x / BAR_SIZE,
			armor.currentIntegrity / float(armor.maxIntegrity),
			0.2
		)
		armorTween.start()


func dead(character : Character) -> void:
	if character == self.character:
		timerTween.remove_all()
		hpTween.remove_all()
		armorTween.remove_all()
		
		timerBar1.color = GuiTheme.COMMAND_DEAD
		timerBar2.color = GuiTheme.COMMAND_DEAD
		hpBar.color = GuiTheme.DEAD_BAR
		armorBar.color = GuiTheme.DEAD_BAR


func timerProgress(percent : float) -> void:
	timerBar1.rect_size.x = ceil(BAR_SIZE * percent)


func hpBarSize(percent : float) -> void:
	hpBar.rect_size.x = ceil(BAR_SIZE * percent)


func armorBarSize(percent : float) -> void:
	armorBar.rect_size.x = ceil(BAR_SIZE * percent)


func extraHpBarChange(character : Character, amount : int) -> void:
	if character == self.character:
		pass


func pause() -> void:
	yield(get_tree(), "idle_frame")
	timerTween.stop_all()


func resume() -> void:
	yield(get_tree(), "idle_frame")
	timerTween.resume_all()

