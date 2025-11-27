extends Area2D

const PATH = "res://scenes/levels/level_"
func _on_body_entered(body):
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	
	var next_level_path = PATH + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
