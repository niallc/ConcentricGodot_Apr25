# res://ui/tooltip_manager.gd
extends Node

const HOVER_TOOLTIP_SCENE = preload("res://ui/hover_tooltip.tscn")
const SHOW_DELAY: float = 0.5  # Seconds to wait before showing.
const HIDE_DELAY: float = 0.05 # A very short delay before hiding.

var _tooltip_instance: Control
var _show_timer: Timer
var _hide_timer: Timer

# State variables
var _target_for_show: Control = null # The node we are about to show a tooltip for.
var _target_for_hide: Control = null # The node we are about to hide a tooltip for.
var _target_is_visible: Control = null # The node whose tooltip is currently fully visible.
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
	
	_hide_timer = Timer.new()
	_hide_timer.wait_time = HIDE_DELAY
	_hide_timer.one_shot = true
	_hide_timer.timeout.connect(_on_hide_timer_timeout)
	add_child(_hide_timer)


func request_show_tooltip(text_content: String, requesting_node: Control) -> void:
	if not is_instance_valid(requesting_node):
		return

	# If a hide is pending for this exact node, cancel the hide and do nothing else.
	# This prevents the hide/show flicker on minor mouse movements.
	if _target_for_hide == requesting_node:
		_hide_timer.stop()
		_target_for_hide = null
		return

	# If we are already showing or pending a show for this node, also do nothing.
	if _target_is_visible == requesting_node or _target_for_show == requesting_node:
		return

	# A new, different target is being hovered.
	# Hide any currently visible tooltip immediately.
	if _tooltip_instance.visible:
		_tooltip_instance.hide_tooltip()

	# Set up the pending show for the new target.
	# We DO NOT update the content here. We only store the data for later.
	_target_for_show = requesting_node
	_pending_tooltip_text = text_content
	_show_timer.start()


func request_hide_tooltip(requesting_node: Control) -> void:
	if not is_instance_valid(requesting_node):
		return
	
	# If this hide request is for the node we are about to show a tip for, cancel the show.
	if _target_for_show == requesting_node:
		_show_timer.stop()
		_target_for_show = null

	# If the tooltip is visible for this node, start the hide timer.
	if _target_is_visible == requesting_node:
		_target_for_hide = requesting_node
		_hide_timer.start()


func _on_show_timer_timeout() -> void:
	if not is_instance_valid(_target_for_show):
		return

	# The mouse has been hovering long enough. Show the tooltip.
	var root_viewport: Window = get_tree().get_root()
	var mouse_pos: Vector2 = root_viewport.get_mouse_position()
	var viewport_size: Vector2 = root_viewport.size

	var tooltip_pos = mouse_pos + Vector2(20, 20)
	var tooltip_size = _tooltip_instance.size

	if tooltip_pos.x + tooltip_size.x > viewport_size.x:
		tooltip_pos.x = viewport_size.x - tooltip_size.x - 5
	if tooltip_pos.y + tooltip_size.y > viewport_size.y:
		tooltip_pos.y = mouse_pos.y - tooltip_size.y - 20

	_tooltip_instance.display_at(tooltip_pos)
	_target_is_visible = _target_for_show
	_target_for_show = null

	_tooltip_instance.update_content(_pending_tooltip_text)

func _on_hide_timer_timeout() -> void:
	if not is_instance_valid(_target_for_hide):
		return

	# The hide delay has passed. Actually hide the tooltip.
	if _target_is_visible == _target_for_hide:
		_tooltip_instance.hide_tooltip()
		_target_is_visible = null
	
	_target_for_hide = null
