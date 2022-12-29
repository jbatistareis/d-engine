extends Node


func _ready():
	Signals.connect("characterEquipedArmor", self, "equipArmor")
	Signals.connect("characterEquipedWeapon", self, "equipWeapon")
	Signals.connect("characterUsedItem", self, "useItem")
	
	Signals.connect("characterReceivedWeapon", self, "receiveWeapon")
	Signals.connect("characterReceivedArmor", self, "receiveArmor")
	Signals.connect("characterReceivedItem", self, "receiveItem")
	
	Signals.connect("characterDroppedWeapon", self, "dropWeapon")
	Signals.connect("characterDroppedArmor", self, "dropArmor")
	Signals.connect("characterDroppedItem", self, "dropItem")


func equipWeapon(character : Character, weapon : Weapon) -> void:
	var index = character.inventory.weapons.bsearch_custom(
		weapon.shortName,
		EntityArrayHelper, 'shortNameFind')
	
	if character.inventory.weapons[index].shortName == weapon.shortName:
		var oldWeapon = character.inventory.weapon
		var newWeapon = character.inventory.weapons[index]
		
		character.inventory.weapons.remove(index)
		character.inventory.weapons.append(oldWeapon)
		character.inventory.weapons.sort_custom(EntityArrayHelper, "shortNameSort")
		
		character.inventory.weapon = newWeapon
	else:
		push_error(ErrorMessages.WPN_NO_FOUND)


func equipArmor(character : Character, armor : Armor) -> void:
	character.inventory.armor = armor


func useItem(user : Character, receivers : Array, item : Item) -> void:
	var index = user.inventory.items.bsearch_custom(
		item.shortName,
		EntityArrayHelper, 'shortNameFind')
	
	if user.inventory.items[index].shortName == item.shortName:
		user.inventory.items.remove(index)
		user.inventory.items.sort_custom(EntityArrayHelper, "shortNameSort")
		
		ScriptTool.getReference(item.actionExpression).execute(receivers)
	else:
		push_error(ErrorMessages.ITM_NO_FOUND)




func receiveWeapon(character : Character, weapon : Weapon) -> void:
	character.inventory.weapons.append(weapon)
	character.inventory.weapons.sort_custom(EntityArrayHelper, "shortNameSort")


# TODO
func receiveArmor(character : Character, armor : Armor) -> void:
	pass


func receiveItem(character : Character, item : Item) -> void:
	character.inventory.items.append(item)
	character.inventory.items.sort_custom(EntityArrayHelper, "shortNameSort")




func dropWeapon(character : Character, weapon : Weapon) -> void:
	var index = character.inventory.weapons.bsearch_custom(
		weapon.shortName,
		EntityArrayHelper, 'shortNameFind')
	
	if character.inventory.weapons[index].shortName == weapon.shortName:
		character.inventory.weapons.remove(index)
		character.inventory.weapons.sort_custom(EntityArrayHelper, "shortNameSort")
	else:
		push_error(ErrorMessages.WPN_NO_FOUND)


# TODO
func dropArmor(character : Character, armor : Armor) -> void:
	pass


func dropItem(character : Character, item : Item) -> void:
	var index = character.inventory.items.bsearch_custom(
		item.shortName,
		EntityArrayHelper, 'shortNameFind')
	
	if character.inventory.items[index].shortName == item.shortName:
		character.inventory.items.remove(index)
		character.inventory.items.sort_custom(EntityArrayHelper, "shortNameSort")
	else:
		push_error(ErrorMessages.ITM_NO_FOUND)

