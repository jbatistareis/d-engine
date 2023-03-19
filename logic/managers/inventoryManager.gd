extends Node


func _ready():
	Signals.characterEquipedArmor.connect(equipArmor)
	Signals.characterEquipedWeapon.connect(equipWeapon)
	Signals.characterUsedItem.connect(useItem)
	
	Signals.characterReceivedWeapon.connect(receiveWeapon)
	Signals.characterReceivedArmor.connect(receiveArmor)
	Signals.characterReceivedItem.connect(receiveItem)
	
	Signals.characterDroppedWeapon.connect(dropWeapon)
	Signals.characterDroppedArmor.connect(dropArmor)
	Signals.characterDroppedItem.connect(dropItem)


func equipWeapon(character : Character, weapon : Weapon) -> void:
	if character.inventory.weapons.has(weapon):
		character.inventory.weapons.erase(weapon)
		character.inventory.weapons.append(character.inventory.weapon)
		character.inventory.weapons.sort_custom(func(a, b): return EntityArrayHelper.shortNameSort(a, b))
		
		character.inventory.weapon = weapon
	else:
		push_error(ErrorMessages.WPN_NO_FOUND)


func equipArmor(character : Character, armor : Armor) -> void:
	character.inventory.armor = armor


func useItem(user : Character, receivers : Array, item : Item) -> void:
	if user.inventory.items.has(item):
		user.inventory.items.erase(item)
		user.inventory.items.sort_custom(func(a, b): EntityArrayHelper.shortNameSort(a, b))
		
		ScriptTool.getReference(item.actionExpression).execute(receivers)
	else:
		push_error(ErrorMessages.ITM_NO_FOUND)




func receiveWeapon(character : Character, weapon : Weapon) -> void:
	character.inventory.weapons.append(weapon)
	character.inventory.weapons.sort_custom(func(a, b): return EntityArrayHelper.shortNameSort(a, b))


# TODO
func receiveArmor(_character : Character, _armor : Armor) -> void:
	pass


func receiveItem(character : Character, item : Item) -> void:
	character.inventory.items.append(item)
	character.inventory.items.sort_custom(func(a, b): return EntityArrayHelper.shortNameSort(a, b))




func dropWeapon(character : Character, weapon : Weapon) -> void:
	if character.inventory.weapons.has(weapon):
		character.inventory.weapons.erase(weapon)
		character.inventory.weapons.sort_custom(func(a, b): return EntityArrayHelper.shortNameSort(a, b))
	else:
		push_error(ErrorMessages.WPN_NO_FOUND)


# TODO
func dropArmor(_character : Character, _armor : Armor) -> void:
	pass


func dropItem(character : Character, item : Item) -> void:
	if character.inventory.items.has(item):
		character.inventory.items.erase(item)
		character.inventory.items.sort_custom(func(a, b): return EntityArrayHelper.shortNameSort(a, b))
	else:
		push_error(ErrorMessages.ITM_NO_FOUND)

