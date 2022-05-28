class_name WeaponDTO
extends DTO

var name = 'Base Weapon'
var shortName = 'BSEWPN'

var damage : int = 1
# use Enums.DiceType
var modifierDice : int = Enums.DiceType.D4
# use Enums.DiceRollType
var modifierRollType : int = Enums.DiceRollType.BEST
# use Enums.CharacterModifier
var modifier : int = Enums.CharacterModifier.STR

var cdPre : int = 1
var cdPos : int = 1

var moveShortNames : Array = ['BSEATK']

