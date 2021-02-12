class_name Inventory
extends Entity


var items : Array
var weapons : Array
var persistent : bool

var weapon : Weapon
#armors are not meant to be caried, you can only have your equiped one, and you can change then only on specific places
var armor : Armor

var money : int


func _init(id : int, persistent : bool, itemIds : Array = [], weaponIds : Array = [], equipedWeaponId: int = 1, equipedArmorId : int = 1, armorProtection : int = 0, money : int = 0).(id) -> void:
	self.persistent = persistent
	
	for id in itemIds:
		items.append(ItemsDatabase.spawnEntity(id))
	
	for id in weaponIds:
		weapons.append(WeaponsDatabase.spawnEntity(id))
	
	self.weapon = WeaponsDatabase.spawnEntity(equipedWeaponId) if equipedWeaponId > 0 else null
	self.armor = ArmorsDatabase.spawnEntity(equipedArmorId) if equipedArmorId > 0 else null
	self.armor.currentProtection = armorProtection


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


#TODO produce armor status on serialize

