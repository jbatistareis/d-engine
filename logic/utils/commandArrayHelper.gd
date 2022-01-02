class_name CommandArrayHelper
extends EntityArrayHelper


static func tickSortReverse(a : Command, b: Command) -> bool:
	if (a.remainingTicks > b.remainingTicks):
		return true
	return false

