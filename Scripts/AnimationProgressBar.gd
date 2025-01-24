@tool
class_name AnimationProgressBar
extends AnimatedSprite2D

# Exported animation name
@export var animation_name: String = "default"

# Method to set progress
func set_progress(_from: float, progress: float) -> void:
	var frame: int = int(progress * sprite_frames.get_frame_count(animation_name))
	frame = clamp(frame, 0, sprite_frames.get_frame_count(animation_name) - 1)
	self.frame = frame
