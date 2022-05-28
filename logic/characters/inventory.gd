class_name Inventory
extends Entity

var items : Array = []
var weapons : Array = []

var weapon : Weapon
#armors are not meant to be caried, you can only have your equiped one, and you can change then only on specific places
var armor : Armor

var money : int


func _init(inventoryShortName : String) -> void:
	var dto = Persistence.loadDTO(inventoryShortName, Enums.EntityType.INVENTORY)
	
	self.name = dto.name
	self.shortName = dto.shortName
	
	for itemSrtNm in dto.itemShortNames:
		self.items.clear()
		self.items.append(Item.new(itemSrtNm))
	for weaponSrtNm in dto.weaponShortNames:
		self.weapons.clear()
		self.weapons.append(Weapon.new(weaponSrtNm))
	
	self.weapon = Weapon.new(dto.weaponShortName)
	self.armor = Armor.new(dto.armorShortName)
	
	self.money = dto.money


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

