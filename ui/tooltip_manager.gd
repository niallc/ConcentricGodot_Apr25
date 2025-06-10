# res://ui/tooltip_manager.gd
extends Node

const HOVER_TOOLTIP_SCENE = preload("res://ui/hover_tooltip.tscn")
const SHOW_DELAY: float = 0.5 # Seconds to wait before showing tooltip

var _tooltip_instance: Control
var _show_timer: Timer
var _current_hover_target: Control # The UI element we are currently hovering over
var _pending_tooltip_text: String = ""

func _ready() -> void:
	if HOVER_TOOLTIP_SCENE:
		_tooltip_instance = HOVER_TOOLTIP_SCENE.instantiate()
		var canvas_layer = CanvasLayer.new()
		canvas_layer.layer = 128
		add_child(canvas_layer)
		canvas_layer.add_child(_tooltip_instance)
	else:
		printerr("TooltipManager: HOVER_TOOLTIP_SCENE not loaded!")
		return

	_show_timer = Timer.new()
	_show_timer.wait_time = SHOW_DELAY
	_show_timer.one_shot = true
	_show_timer.timeout.connect(_on_show_timer_timeout)
	add_child(_show_timer)


# Called when the mouse enters a UI element that wants a tooltip.
func request_show_tooltip(text_content: String, requesting_node: Control) -> void:
	if not is_instance_valid(requesting_node):
		return

	# If we are already showing or about to show a tooltip for this same node, do nothing.
	if _current_hover_target == requesting_node:
		return
		
	# If we were hovering something else, hide that tooltip immediately.
	if _tooltip_instance.visible:
		_tooltip_instance.hide_tooltip()

	# Set up the pending show for the new target.
	_current_hover_target = requesting_node
	_pending_tooltip_text = text_content
	_show_timer.start()


# Called when the mouse exits a UI element.
func request_hide_tooltip(requesting_node: Control) -> void:
	if not is_instance_valid(requesting_node):
		return

	# If the mouse is leaving the element we are currently tracking,
	# cancel any pending show and hide any visible tooltip.
	if _current_hover_target == requesting_node:
		_show_timer.stop()
		_current_hover_target = null
		_pending_tooltip_text = ""
		if _tooltip_instance.visible:
			_tooltip_instance.hide_tooltip()


# This function is now responsible for ACTUALLY showing the tooltip.
func _on_show_timer_timeout() -> void:
	# Check if the target is still valid (i.e., hasn't been cleared by request_hide_tooltip)
	if not is_instance_valid(_current_hover_target) or _pending_tooltip_text == "":
		return

	# At this point, the mouse has been hovering for SHOW_DELAY seconds. Show the tooltip.
	
	var root_viewport: Window = get_tree().get_root()
	var mouse_pos: Vector2 = root_viewport.get_mouse_position()
	var viewport_size: Vector2 = root_viewport.size # Using the .size property, which exists on Window

	_tooltip_instance.update_content(_pending_tooltip_text)
	
	var tooltip_pos = mouse_pos + Vector2(20, 20)

	var tooltip_size = _tooltip_instance.size
	if tooltip_pos.x + tooltip_size.x > viewport_size.x:
		tooltip_pos.x = viewport_size.x - tooltip_size.x - 5
	if tooltip_pos.y + tooltip_size.y > viewport_size.y:
		tooltip_pos.y = mouse_pos.y - tooltip_size.y - 20

	_tooltip_instance.display_at(tooltip_pos)
