class_name WeaponDTO
extends DTO

var name = 'Base Weapon'
var shortName = 'BSEWPN'

var damage : int = 1
var modifierDice : int = Enums.DiceType.D4
var modifierRollType : int = Enums.DiceRollType.BEST
var modifier : int = Enums.CharacterModifier.STR

var cdPre : int = 1
var cdPos : int = 1

var moveShortNames : Array = ['BSEATK']

