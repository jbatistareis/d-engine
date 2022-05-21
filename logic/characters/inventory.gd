class_name Inventory

var items : Array = []
var weapons : Array = []

var weapon : Weapon = Weapon.new()
#armors are not meant to be caried, you can only have your equiped one, and you can change then only on specific places
var armor : Armor = null

var money : int = 0


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

