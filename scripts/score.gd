extends Label

func _on_player_score_changed(new_score: Variant) -> void:
	text = str(new_score)
