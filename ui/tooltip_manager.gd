# res://ui/tooltip_manager.gd (or your chosen path)
extends Node

const HOVER_TOOLTIP_SCENE = preload("res://ui/hover_tooltip.tscn") # Adjust path if needed
const SHOW_DELAY: float = 0.5 # Seconds to wait before showing tooltip

var _tooltip_instance: Control = null
var _show_timer: Timer = null
var _current_hover_target: Control = null # The UI element currently hovered / requesting tooltip
var _pending_tooltip_text: String = ""

func _ready() -> void:
	# Instance the tooltip scene and add it to a top-level canvas layer
	# to ensure it draws above everything else.
	if HOVER_TOOLTIP_SCENE:
		_tooltip_instance = HOVER_TOOLTIP_SCENE.instantiate()
		
		# Create a CanvasLayer to host the tooltip
		var canvas_layer = CanvasLayer.new()
		canvas_layer.layer = 128 # High value to be on top
		add_child(canvas_layer) # Add CanvasLayer to the TooltipManager (which is an Autoload)
		canvas_layer.add_child(_tooltip_instance)
	else:
		printerr("TooltipManager: HOVER_TOOLTIP_SCENE not loaded!")
		return

	_show_timer = Timer.new()
	_show_timer.wait_time = SHOW_DELAY
	_show_timer.one_shot = true
	_show_timer.timeout.connect(_on_show_timer_timeout)
	add_child(_show_timer)


func request_show_tooltip(text_content: String, requesting_node: Control) -> void:
	if not is_instance_valid(_tooltip_instance) or not is_instance_valid(requesting_node):
		return

	# If mouse moves to a new target while a tooltip for another is showing or pending
	if _current_hover_target != requesting_node:
		_tooltip_instance.hide_tooltip() # Start hiding the old one immediately

	_current_hover_target = requesting_node
	_pending_tooltip_text = text_content
	
	_show_timer.start()


func request_hide_tooltip(requesting_node: Control) -> void:
	if not is_instance_valid(_tooltip_instance) or not is_instance_valid(requesting_node):
		return

	# If this hide request is for the node that was about to show a tooltip, cancel the show
	if requesting_node == _current_hover_target:
		_show_timer.stop()
		_current_hover_target = null # Clear the target
		_pending_tooltip_text = ""

	# If a tooltip is visible and it's for the requesting_node (or if we want to hide any active tooltip)
	# A more robust check would be if _tooltip_instance.visible AND it was shown FOR this node.
	# For now, any hide request while the timer is not running for it will hide the current tooltip.
	# This simplifies logic if mouse quickly flits between elements.
	if _tooltip_instance.visible:
		_tooltip_instance.hide_tooltip()


func _on_show_timer_timeout() -> void:
	if not is_instance_valid(_tooltip_instance) or not is_instance_valid(_current_hover_target):
		return

	# Final check: is the mouse still over the target control?
	# This is tricky because _current_hover_target.has_point() needs global coordinates
	# and the mouse_entered/exited signals are more reliable for knowing "current hover".
	# We'll assume if _current_hover_target hasn't been cleared by a corresponding
	# request_hide_tooltip, it's still valid to show.
	if _current_hover_target:
		var mouse_pos = _current_hover_target.get_global_mouse_position()
		var viewport_size = _current_hover_target.get_viewport_rect().size
		
		_tooltip_instance.update_content(_pending_tooltip_text)
		
		# Basic positioning: offset from mouse.
		# We'll need to get the tooltip's size after text is set to adjust position.
		var tooltip_pos = mouse_pos + Vector2(20, 20) # Offset from mouse

		# Crude screen edge adjustment (can be refined)
		var tooltip_size = _tooltip_instance.size # Relies on size being updated correctly by update_content
		if tooltip_pos.x + tooltip_size.x > viewport_size.x:
			tooltip_pos.x = viewport_size.x - tooltip_size.x - 5 # 5px margin
		if tooltip_pos.y + tooltip_size.y > viewport_size.y:
			tooltip_pos.y = mouse_pos.y - tooltip_size.y - 20 # Show above mouse if it overflows bottom

		_tooltip_instance.display_at(tooltip_pos)
