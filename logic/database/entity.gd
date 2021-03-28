class_name Entity

var id : int
var shortName : String = 'entity'


func serialize() -> PoolByteArray:
	return var2bytes(self)

