extends HSplitContainer

const _ENCOUNTER_LABEL : String = "Enc.: %3d%% "

var location : LocationDTO = LocationDTO.new()


func _on_sld_enc_drag_ended(value_changed: bool) -> void:
	if !value_changed:
		return
	
	$tabs/Location/parameters/idGrid/lblEnc.text = _ENCOUNTER_LABEL % (100 * $tabs/Location/parameters/idGrid/sldEnc.value)
	location.encounterRate = $tabs/Location/parameters/idGrid/sldEnc.value

