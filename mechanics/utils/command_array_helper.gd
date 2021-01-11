class_name CommandArrayHelper
extends EntityArrayHelper


static func tickSort(a : Command, b: Command) -> bool:
	if (a.remainingTicks < b.remainingTicks):
		return true
	return false

