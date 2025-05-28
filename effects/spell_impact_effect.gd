# res://effects/spell_impact_effect.gd
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer 
# Note: We don't strictly need a reference to AnimatedSprite2D in script if AnimationPlayer handles it.

func play_effect():
	# This function now just tells the AnimationPlayer to play its "lifecycle" animation.
	# The "lifecycle" animation will, in turn, tell the AnimatedSprite2D to play, and then queue_free the whole effect.
	if animation_player.has_animation("lifecycle"):
		animation_player.play("lifecycle")
	else:
		printerr("SpellImpactEffect: Animation 'lifecycle' not found!")
		queue_free() # Can't play, so remove immediately
