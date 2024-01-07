extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlatformSprite/Area2D/CollisionShape2D.disabled = false
	$PlatformSprite.visible = true
	$PlatformSprite.play("fade_out")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_platform_sprite_animation_finished():
	$PlatformSprite/Area2D/CollisionShape2D.disabled = true
	$PlatformSprite.visible = false
