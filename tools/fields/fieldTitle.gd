extends HBoxContainer

@export
var title : String :
	set(value):
		if !is_inside_tree():
			await ready
		$title.text = value

