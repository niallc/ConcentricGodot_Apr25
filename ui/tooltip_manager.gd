# res://ui/tooltip_manager.gd
extends Node

const HOVER_TOOLTIP_SCENE = preload("res://ui/hover_tooltip.tscn")
const SHOW_DELAY: float = 0.5  # Seconds to wait before showing.
const HIDE_DELAY: float = 0.05 # A very short delay before hiding.

var _tooltip_instance: Control
var _show_timer: Timer
var _hide_timer: Timer

# State variables
var _target_for_show: Control = null
var _target_for_hide: Control = null
var _target_is_visible: Control = null
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

	if _target_for_hide == requesting_node:
		_hide_timer.stop()
		_target_for_hide = null
		return

	if _target_is_visible == requesting_node or _target_for_show == requesting_node:
		return

	if _tooltip_instance.visible:
		_tooltip_instance.hide_tooltip()

	print("TOOLTIP_MANAGER: request_show_tooltip for ", requesting_node.name, " at ", Time.get_ticks_msec(), "ms. Starting show_timer.")
	print("    tooltip currently visible? ", _tooltip_instance.visible, ", modulate.a: ", _tooltip_instance.modulate.a)

	_target_for_show = requesting_node
	_pending_tooltip_text = text_content
	_show_timer.start()


func request_hide_tooltip(requesting_node: Control) -> void:
	if not is_instance_valid(requesting_node):
		return
	
	if _target_for_show == requesting_node:
		_show_timer.stop()
		_target_for_show = null

	if _target_is_visible == requesting_node:
		_target_for_hide = requesting_node
		_hide_timer.start()
	print("TOOLTIP_MANAGER: request_hide_tooltip for ", requesting_node.name, " at ", Time.get_ticks_msec(), "ms")
	print("    current visible? ", _tooltip_instance.visible, ", modulate.a: ", _tooltip_instance.modulate.a)


func _on_show_timer_timeout() -> void:
	if not is_instance_valid(_target_for_show):
		return
	if _target_is_visible == _target_for_show:
		print("TOOLTIP_MANAGER: Avoiding redundant show.")
		return

	# FIX 1: Update the tooltip's content BEFORE calculating its position.
	_tooltip_instance.update_content(_pending_tooltip_text)
	
	var root_viewport: Window = get_tree().get_root()
	var mouse_pos: Vector2 = root_viewport.get_mouse_position()
	var viewport_size: Vector2 = root_viewport.size

	# Get the tooltip size AFTER its content has been updated.
	var tooltip_size = _tooltip_instance.size
	var tooltip_pos = mouse_pos + Vector2(20, 20)

	if tooltip_pos.x + tooltip_size.x > viewport_size.x:
		tooltip_pos.x = viewport_size.x - tooltip_size.x - 5
	if tooltip_pos.y + tooltip_size.y > viewport_size.y:
		tooltip_pos.y = mouse_pos.y - tooltip_size.y - 20

	_tooltip_instance.display_at(tooltip_pos)
	_target_is_visible = _target_for_show
	_target_for_show = null


func _on_hide_timer_timeout() -> void:
	if not is_instance_valid(_target_for_hide):
		return
	if _target_is_visible != _target_for_hide:
		print("TOOLTIP_MANAGER: Avoiding redundant hide.")
		return

	if _target_is_visible == _target_for_hide:
		_tooltip_instance.hide_tooltip()
		# REMOVED: The line `_tooltip_instance.update_content("")` was here.
		# It's now handled by the tooltip itself when its animation finishes.
		_target_is_visible = null
	
	_target_for_hide = null
