extends Control


@onready var _label := $LabelValue

func set_value(value : String) -> void:
	_label.set_text(value)
