extends EntityDatabase

var moves : Array = [
	Move.new(
		1,
		'Attack',
		'Attacks using a weapon',
		'$CHARACTER.WEAPON_DAMAGE + $CHARACTER.BASE_DAMAGE',
		'$ROLL.NORMAL.D10',
		0,
		0),
	Move.new(
		2,
		'Counter',
		'Counters using a weapon, with halved damage',
		'$CHARACTER.WEAPON_DAMAGE / 2',
		'$ROLL.WORST.D10',
		0,
		0)]

# TODO get from DB
func getEntity(id : int) -> Move:
	return moves[id - 1]

