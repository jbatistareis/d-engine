class_name InventorySummary

var summary : Array = []


func _init(items : Array) -> void:
	var temp = []
	
	for item in items:
		if !temp.has(item.shortName):
			temp.append(item.shortName)
	
	for itemShortName in temp:
		var amount = 0
		var currItem
		
		for item in items:
			if itemShortName == item.shortName:
				currItem = item
				amount += 1
		
		summary.append(InventorySummaryItem.new(currItem, amount))

