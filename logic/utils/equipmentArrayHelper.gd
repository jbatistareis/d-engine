class_name EquipmentArrayHelper
extends EntityArrayHelper


static func itemIdSort(a : Equipment, b: Equipment) -> bool:
	if (a.getItemId() < b.getItemId()):
		return true
	return false


static func itemIdFind(equipment : Equipment, itemId : int) -> bool:
	if (equipment.getItemId() < itemId):
		return true
	return false

