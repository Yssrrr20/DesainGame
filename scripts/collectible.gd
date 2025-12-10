extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_entered(area: Area2D) -> void:
	animation_player.play("pickUp animation")
	var body = area.get_parent();
	if body.has_method("add_score"):
		body.add_score(1)
