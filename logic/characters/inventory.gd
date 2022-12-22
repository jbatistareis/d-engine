class_name Inventory
extends Entity

var items : Array = []
var weapons : Array = []

var weapon : Weapon
#armors are not meant to be caried, you can only have your equiped one, and you can change then only on specific places
var armor : Armor

var money : int


func fromShortName(inventoryShortName : String) -> Inventory:
	return fromDTO(Persistence.loadDTO(inventoryShortName, Enums.EntityType.INVENTORY))


func fromDTO(inventoryDto : InventoryDTO) -> Inventory:
	self.name = inventoryDto.name
	self.shortName = inventoryDto.shortName
	
	for itemSrtNm in inventoryDto.itemShortNames:
		self.items.append(Item.new().fromShortName(itemSrtNm))
	self.items.sort_custom(EntityArrayHelper, "shortNameSort")
	
	for weaponSrtNm in inventoryDto.weaponShortNames:
		self.weapons.append(Weapon.new().fromShortName(weaponSrtNm))
	self.weapons.sort_custom(EntityArrayHelper, "shortNameSort")
	
	self.weapon = Weapon.new().fromShortName(inventoryDto.weaponShortName)
	self.armor = Armor.new().fromShortName(inventoryDto.armorShortName)
	
	self.money = inventoryDto.money
	
	return self


func toDTO() -> InventoryDTO:
	var inventoryDto = InventoryDTO.new()
	inventoryDto.name = self.name
	inventoryDto.shortName = self.shortName
	
	for item in self.items:
		inventoryDto.itemShortNames.append(item.shortName)
	for weapon in self.weapons:
		inventoryDto.weaponShortNames.append(weapon.shortName)
	
	inventoryDto.weapon = self.weapon.shortName
	inventoryDto.armor = self.armor.shortName
	
	inventoryDto.money = self.money
	
	return inventoryDto


func add(entity : Entity) -> void:
	if entity is Item:
		items.append(entity as Item)
		items.sort_custom(EntityArrayHelper, "shortNameSort")
	
	if entity is Weapon:
		weapons.append(entity as Weapon)
		weapons.sort_custom(EntityArrayHelper, "shortNameSort")


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
		var oldWeapon = weapon
		var newWeapon = weapons[index]
		
		weapons.remove(index)
		add(oldWeapon)
		weapon = newWeapon


func equipArmor(newArmor : Armor) -> void:
	armor = newArmor

