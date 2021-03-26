class_name Inventory

var items : Array = []
var weapons : Array = []

var weapon : Weapon = null
#armors are not meant to be caried, you can only have your equiped one, and you can change then only on specific places
var armor : Armor = null

var money : int = 0


#TODO add some sort of consumable armor plate
func repairArmor() -> void:
	var oldProtection = armor.currentProtection
	var newProtection = armor.currentProtection + armor.plateValue
	armor.currentProtection = newProtection if (newProtection < armor.protection) else armor.protection
	
	Signals.emit_signal("armorRepaired", armor, armor.currentProtection - oldProtection)


func add(entity : Entity) -> void:
	if entity is Item:
		items.append(entity as Item)
	
	if entity is Weapon:
		weapons.append(entity as Weapon)


func removeItem(index : int) -> Item:
	var item = items[index]
	items.remove(index)
	
	return item


func removeWeapon(index : int) -> Weapon:
	var weapon = weapons[index]
	weapons.remove(index)
	
	return weapon


func equipWeapon(index : int) -> void:
	if weapon != null:
		weapons.append(weapon)
	
	weapon = removeWeapon(index)


func equipArmor(newArmor : Armor) -> void:
	armor = newArmor

