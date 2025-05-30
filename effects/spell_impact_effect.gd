# res://effects/spell_impact_effect.gd
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const FRAME_BASE_PATH: String = "res://art/sprite_sheets/burst_fx/new" # Make sure this matches your actual path
const FRAME_COUNT: int = 32 # e.g., new0000.png to new0031.png
const ANIMATION_NAME: String = "burst" # Should match the animation name set up in .tscn with the placeholder
const ANIMATION_FPS: float = 16.0

func _ready():
	_try_upgrade_animation_to_full_sequence()

func _try_upgrade_animation_to_full_sequence():
	if not animated_sprite:
		printerr("SpellImpactEffect: AnimatedSprite2D node not found. Cannot upgrade animation.")
		return
	if not animated_sprite.sprite_frames:
		printerr("SpellImpactEffect: No SpriteFrames resource assigned to AnimatedSprite2D in the scene. Please set up a placeholder animation.")
		return

	var sprite_frames_res: SpriteFrames = animated_sprite.sprite_frames
	
	if not sprite_frames_res.has_animation(ANIMATION_NAME):
		printerr("SpellImpactEffect: Expected placeholder animation '%s' not found in SpriteFrames. Cannot upgrade." % ANIMATION_NAME)
		return

	var loaded_full_sequence_textures: Array[Texture2D] = []
	var all_full_frames_found_and_valid: bool = true

	# Attempt to load the full sequence
	for i in range(FRAME_COUNT):
		var frame_path: String = "%s%04d.png" % [FRAME_BASE_PATH, i]
		if ResourceLoader.exists(frame_path):
			var tex_resource = load(frame_path)
			if tex_resource is Texture2D:
				loaded_full_sequence_textures.append(tex_resource)
			else:
				printerr("SpellImpactEffect: Full sequence frame '%s' loaded but is not a Texture2D. Aborting upgrade to full animation." % frame_path)
				all_full_frames_found_and_valid = false
				break
		else:
			# If any frame for the full sequence is missing, we don't upgrade.
			# The placeholder (single-frame) animation will be used.
			print("SpellImpactEffect: Full sequence frame '%s' not found. Using placeholder animation for '%s'." % [frame_path, ANIMATION_NAME])
			all_full_frames_found_and_valid = false
			break
			
	if all_full_frames_found_and_valid and loaded_full_sequence_textures.size() == FRAME_COUNT:
		# Successfully loaded all frames for the full sequence, so replace the placeholder(s)
		
		# --- CORRECTED SECTION START ---
		if sprite_frames_res.has_animation(ANIMATION_NAME): # Should be true if placeholder was set up
			sprite_frames_res.remove_animation(ANIMATION_NAME) 
		sprite_frames_res.add_animation(ANIMATION_NAME) # Add it back, now empty
		# --- CORRECTED SECTION END ---

		for tex in loaded_full_sequence_textures:
			sprite_frames_res.add_frame(ANIMATION_NAME, tex)
		
		sprite_frames_res.set_animation_speed(ANIMATION_NAME, ANIMATION_FPS)
		animated_sprite.animation = ANIMATION_NAME 
		print("SpellImpactEffect: Successfully upgraded '%s' to full burst animation." % ANIMATION_NAME)
	# else: The placeholder animation set up in the .tscn file will be used.
		# The print message about missing frames (if any) serves as notification.

func play_effect():
	# We now assume that a valid (placeholder or full) "burst" animation is set on AnimatedSprite2D,
	# and the AnimationPlayer's "lifecycle" track correctly calls play("burst").
	if animation_player.has_animation("lifecycle"):
		animation_player.play("lifecycle")
	else:
		printerr("SpellImpactEffect: Animation 'lifecycle' (for AnimationPlayer) not found!")
		queue_free() # Can't play the controlling animation, so remove immediately
