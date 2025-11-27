extends Area2D

func _on_area_entered(area: Area2D) -> void:
	queue_free()
	var body = area.get_parent();
	if body.has_method("add_score"):
		body.add_score(1)
