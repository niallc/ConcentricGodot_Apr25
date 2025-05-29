# Concentric Godot - Technical Specification v3.0

*Version: 3.0 (Draft 2)*
*Date: 2025-05-29*

## 1. Introduction

This document describes the technical design and current implementation of "Concentric" in Godot. Concentric is a turn-based Player vs. Environment (PvE) deck-building auto-battler. The game was written by Piato at `duel.neocities.org/concentric/`, this version is being built by Niall C (in discussion with Piato).

The core gameplay involves the player building a small deck of cards for automated battles against computer adversaries. Battle outcomes are determined by the game's logic, and then visually replayed to the player. We imagine development so that winning battles yields rewards, such as new cards, allowing the player to further refine their deck and progress (but none of this is implemented yet).

While the broader game will hopefully include elements like maze navigation and persistent deckbuilding, this technical specification primarily focuses on the core battle simulation logic and the battle replay system as they are currently implemented.

### 1.1. Target Audience (for this document)
This document is intended for:
* Developers (including the original author and any future collaborators) working on the project.
* AI assistants (like LLMs) aiding in code generation and understanding.
It aims to provide a clear understanding of the current architecture, data structures, and established patterns to ensure consistent and maintainable development.

### 1.2. Technology Stack
* **Engine:** Godot Engine v4.x
* **Language:** GDScript
* **Testing:** GUT (Godot Unit Test) framework for logic testing.

## 2. System Architecture

### 2.1. Overview
The project employs a modular architecture, separating game logic, data representation, and visual presentation. The core interaction revolves around a battle simulation producing a detailed log of events, which is then consumed by a replay scene to visualize the battle.

*(**TODO:** An architectural diagram, potentially in Mermaid syntax, could be inserted here. It would show the main components: Battle Logic, Card System, Event Log, Replay Scene, UI Elements, Data Resources, and Autoloads, and their primary interactions.)*

A simplified textual representation of this flow:
`Game Setup (Deck Selection, etc.) -> Battle.run_battle() -> Battle Events Array -> BattleReplayScene.load_events() -> Visual Playback`

### 2.2. Major Components and Responsibilities

* **Core Logic (`res://logic/`):**
    * Handles the deterministic simulation of battles, card interactions, and game rules, independent of any visual representation.
    * Key Classes: `Battle.gd`, `Combatant.gd`, `SummonInstance.gd`, `CardInZone.gd`.
    * Card Effect Scripts (`res://logic/card_effects/*.gd`): Implement unique behaviors for each card.
* **Data (`res://data/`, `res://logic/cards/`):**
    * `CardResource` definitions (`.gd` and base `.tres` files in `res://logic/cards/`) define the structure for cards.
    * Specific card instances (`.tres` files in `res://data/cards/instances/`) store data for each unique card in the game (stats, art, links to effect scripts).
    * `card_data.json`: The source JSON file from which card `.tres` resources and effect script placeholders are generated.
* **Battle Replay (`res://scenes/battle_replay_scene.tscn`, `res://ui/`):**
    * Responsible for parsing the `BattleEvents Array` and visually reconstructing the battle.
    * Manages visual elements like summon representations (`SummonVisual.tscn`), card icons (`CardIconVisual.tscn`), player stats displays (HP, Mana), and zone representations (library, graveyard).
* **Tools (`res://logic/tools/`):**
    * `card_importer_tool.gd`: An `@tool` script used within the Godot editor to parse `card_data.json` and automatically generate/update `CardResource` (`.tres`) files and placeholder card effect scripts (`.gd`).
* **Autoloads/Singletons:**
    * `Constants.gd`: Provides global access to game-wide constants (e.g., `MAX_MANA`, `STARTING_HP`, `LANE_COUNT`).
    * `CardDB.gd`: Loads all `CardResource` definitions from `res://data/cards/instances/` at startup and provides a centralized way to access them by their string `id`.
    * `GameManager.gd` (Currently Minimal/Placeholder): Envisioned to manage overall game state, scene transitions, and potentially player progression data in the broader game scope. For the current battle/replay focus, its role is minimal.

### 2.3. Key Data Flow: Battle Simulation to Replay
1.  The `Battle.run_battle()` method simulates an entire battle based on initial decks and player names.
2.  During the simulation, every significant action or state change generates a dictionary representing a battle event. These are collected into an `Array[Dictionary]` (the Battle Events Array).
3.  This Battle Events Array is the *sole output* of the simulation and the *sole input* for the `BattleReplayScene`.
4.  The `BattleReplayScene` processes this array sequentially, updating its visual components to reflect the events, creating a turn-by-turn playback of the battle.

## 3. Coding Conventions & Guidelines

### 3.1. GDScript Style
* **Indentation:** Use Tabs only for indentation in `.gd` files.
* **Naming Conventions:** Observe existing patterns (e.g., `_private_method_or_variable`, `ClassName`, `variable_name`, `CONSTANT_NAME`).
* **Type Hinting:** Use static typing and type hints where practical to improve code clarity and maintainability.

### 3.2. Event Generation Best Practices
* Events should be generated for all significant state changes or actions that need to be reflected in the replay.
* **Atomicity:** Prefer finer-grained events if complex actions can be broken down. However, some actions (like a spell with multiple consequences) might have a primary "spell cast" event followed by more specific outcome events.
* **Sourcing:**
    * `instance_id`: Should always refer to the primary game entity (card instance, summon instance) that the event is *about*. If not applicable (e.g., `battle_end`), use `-1`.
    * `card_id`: If `instance_id` refers to a card or summon, `card_id` (the `CardResource.id`) should also be included for easy lookup of static data.
    * `source_card_id`: The `CardResource.id` of the card/effect that *caused* this event.
    * `source_instance_id`: The battle-specific `instance_id` of the card/summon instance that *caused* this event.
* Ensure all relevant IDs are correctly passed down through method calls that ultimately trigger event generation (e.g., `SummonInstance.die()` passing cause of death to `Combatant.add_card_to_graveyard()`).
* Consult this document (Section 5: Battle Event System) for the expected properties of each event type.

## 4. Core Logic Implementation Details

### 4.1. Card Instance Model
A distinction is made between the static definition of a card (`CardResource`) and its active instances within a game.

* **4.1.1. `CardResource` (and subtypes `SpellCardResource`, `SummonCardResource`)**
    * Location: `res://logic/cards/card.gd` (base), `spell_card.gd`, `summon_card.gd`.
    * Base class for all card types, `extends Resource` and has `class_name CardResource`.
    * Defines static properties: `id: String`, `card_name: String`, `cost: int`, `artwork_path: String`, `description_template: String`, and a `script: GDScript` link to its effect logic.
    * `SpellCardResource` and `SummonCardResource` inherit from `CardResource` and add type-specific properties (e.g., `base_power` for summons) and virtual methods for effects (e.g., `apply_effect` for spells, `_on_arrival` for summons).
* **4.1.2. `CardInZone` (`res://logic/card_in_zone.gd`)**
    * Represents a specific instance of a card when it's in a non-battlefield zone (library, graveyard, or temporarily in the "play" zone during resolution).
    * `extends RefCounted` and has `class_name CardInZone`.
    * Properties:
        * `card_resource: CardResource`: The underlying static card data.
        * `instance_id: int`: A unique identifier for *this specific copy* of the card within the current battle. This ID is assigned by `Battle._generate_new_card_instance_id()` when the `CardInZone` object is first created (typically during `Combatant.setup` for initial library population).
    * This allows tracking individual cards as they move between zones like the library and graveyard.
* **4.1.3. `SummonInstance` (`res://logic/summon_instance.gd`)**
    * Represents a specific creature instance that is active on the battlefield (in a lane).
    * `extends Object` and has `class_name SummonInstance`.
    * Holds dynamic state: `current_hp`, `power_modifiers`, `max_hp_modifiers`, `tags`, `is_newly_arrived`, etc.
    * Properties:
        * `card_resource: SummonCardResource`: The static data for the summon type.
        * `instance_id: int`: A unique identifier for *this specific creature on the field* within the current battle. This ID is assigned by `Battle._generate_new_card_instance_id()` when the `SummonInstance` is created (typically when a summon card is played).
* **4.1.4. Instance ID Philosophy**
    * All unique, battle-specific instance IDs for card-related entities (both `CardInZone` objects and `SummonInstance` objects) are generated by a single counter, `_next_card_instance_id`, within `Battle.gd` via the `_generate_new_card_instance_id()` method.
    * This means IDs are unique across the entire battle scope for any "instantiated" card concept.
    * The *meaning* of an `instance_id` (whether it refers to a card in a hidden zone or a creature on the field) is determined by the context in which it's used (e.g., a property of a `CardInZone` object vs. a property of a `SummonInstance` object, or how it's specified in a battle event's details).
    * Events use `instance_id` to refer to the primary subject of the event. `source_instance_id` refers to the specific game entity instance that *caused* the event. Other fields like `attacking_instance_id` or `to_details.instance_id` provide further contextual IDs.

### 4.2. `Combatant.gd`
* Location: `res://logic/combatant.gd`
* Represents a player or AI opponent in a battle.
* Manages: HP, mana, library (Array of `CardInZone`), graveyard (Array of `CardInZone`), and lanes (Array of `SummonInstance` or null).
* Key Methods:
    * `setup(deck_res: Array[CardResource], ...)`: Initializes the combatant. Critically, it converts the input `Array[CardResource]` (deck list) into an `Array[CardInZone]` for the library, assigning a unique `instance_id` to each `CardInZone` using `battle_instance._generate_new_card_instance_id()`.
    * `take_damage(amount, source_card_id, source_instance_id)`: Reduces HP, generates `hp_change` event.
    * `heal(amount, source_card_id, source_instance_id)`: Increases HP, generates `hp_change` event.
    * `gain_mana(amount, source_card_id, source_instance_id)`: Increases mana, generates `mana_change` event.
    * `lose_mana(amount, source_card_id, source_instance_id)`: Decreases mana, generates `mana_change` event.
    * `pay_mana(amount)`: Decreases mana, generates `mana_change` event. The `mana_change` event generated by this method currently sources the change to the `combatant_name` rather than a specific card being played. *(See Section 10: Known Discrepancies or Areas for Refinement)*.
    * `add_card_to_graveyard(p_card_in_zone_for_graveyard: CardInZone, p_from_zone: String, p_instance_id_from_origin_zone: int, p_cause_source_card_id: String, p_cause_source_instance_id: int)`: Moves a `CardInZone` to the graveyard. Generates a `card_moved` event, using `p_cause_source_card_id` and `p_cause_source_instance_id` to populate the event's `source_card_id` and `source_instance_id` fields, correctly attributing the cause of the move.
    * `remove_card_from_library() -> CardInZone`: Removes and returns the top `CardInZone` from the library, generating a `card_moved` event (library -> play) which includes the `instance_id` of the `CardInZone`.
    * `mill_top_card(p_mill_reason_card_id: String, p_mill_reason_instance_id: int)`: Pops a `CardInZone` from library (via `remove_card_from_library`), then adds it to graveyard (via `add_card_to_graveyard`), passing the mill reason as the cause for the graveyard move.

### 4.3. `Battle.gd`
* Location: `res://logic/battle.gd`
* Orchestrates the entire battle simulation from setup to completion.
* **4.3.1. Battle Setup & Turn Management:**
    * `run_battle(deck1, deck2, name1, name2, seed)`: Initializes duelists, creates `CardInZone` objects for their libraries, and manages the main turn loop.
    * Generates `initial_library_state` events at the start, logging `card_ids`. *(See Section 10: Known Discrepancies or Areas for Refinement for potential enhancement to include instance_ids here)*.
    * Alternates turns between `duelist1` and `duelist2`, calling `conduct_turn` for the active duelist.
* **4.3.2. Card Instance ID Generation:**
    * Maintains `_next_card_instance_id`, starting at 1 for each new battle.
    * `_generate_new_card_instance_id() -> int`: Increments and returns `_next_card_instance_id`, providing unique IDs for all `CardInZone` objects and new `SummonInstance` objects created during the battle.
* **4.3.3. Event Generation (`add_event`)**
    * All battle events are channeled through `add_event(event_data: Dictionary)` which enriches the raw event data with `turn`, `timestamp`, and a unique `event_id`.

### 4.4. Card Effect Scripts (`res://logic/card_effects/`)
* Individual `.gd` files that extend `SpellCardResource` or `SummonCardResource`.
* They implement card-specific logic by overriding virtual methods defined in their base `CardResource` types (e.g., `apply_effect(p_played_spell_card_in_zone: CardInZone, ...)` for spells, `_on_arrival(summon_instance, ...)` for summons).
* Effect scripts can:
    * Read game state via references to `active_combatant`, `opponent_combatant`, `battle_instance`, and the `summon_instance` (for summon effects).
    * Modify game state by calling methods on these objects (e.g., `active_combatant.gain_mana()`, `target_instance.take_damage()`).
    * Generate new battle events by calling `battle_instance.add_event()`.
* **Example (Spell Effect - `Focus`):**
    * `focus_effect.gd` extends `SpellCardResource`.
    * Its `apply_effect(p_focus_card_in_zone, active_combatant, ...)` method calls `active_combatant.gain_mana(mana_gain, focus_spell_card_id, focus_spell_instance_id)`.
    * It also generates a `visual_effect` event sourced to the Focus spell's instance.
* **Example (Summon Effect - `Healer`):**
    * `healer_effect.gd` extends `SummonCardResource`.
    * Its `_on_arrival(_summon_instance, active_combatant, ...)` method calls `active_combatant.heal(heal_amount, healer_card_id, healer_instance_id)` and logs a `visual_effect` event.

## 5. Battle Event System

### 5.1. Purpose and Design
The Battle Event System is the communication backbone between the deterministic battle simulation (`Battle.gd` and related logic) and the visual `BattleReplayScene.gd`. It provides a chronological, structured log of all actions and state changes.

### 5.2. Common Event Properties
Each event in the `battle_events: Array[Dictionary]` generally includes:
* `event_type: String`: The primary identifier for the event's nature (e.g., `"turn_start"`, `"summon_arrives"`).
* `turn: int`: The turn number in which the event occurred.
* `timestamp: float`: A sequentially increasing value to ensure correct ordering of events within a turn.
* `event_id: int`: A unique, sequentially increasing ID for every event logged in the battle.
* `instance_id: int`: The unique battle-specific `instance_id` of the primary card entity (`CardInZone` or `SummonInstance`) this event pertains to. If the event is not about a specific card entity (e.g., `battle_end`, `turn_start` mana), this is typically `-1`.
* `card_id: String` (Recommended if `instance_id` is for a card/summon): The `CardResource.id` (e.g., "GoblinScout") of the entity referred to by `instance_id`.
* `source_card_id: String` (Optional): The `CardResource.id` of the card or game effect that *caused* this event to occur.
* `source_instance_id: int` (Optional): The battle-specific `instance_id` of the card/summon instance that *caused* this event. `-1` if not applicable.

### 5.3. Detailed Event Type Specifications
The following lists the `event_type` string. For most events, the standard properties above apply, and their specific payloads are implemented in the relevant game logic files. Notable unique properties or critical ID semantics are highlighted.

* `initial_library_state`
    * Notable: Contains `card_ids: Array[String]` (IDs of card resources). `instance_id` is not for a single card.
* `turn_start`
* `mana_change`
    * Notable: `amount` (can be +/-), `new_total`, `source_card_id` (e.g., "None, turn start mana", or a card ID that generated mana). `instance_id` is the `instance_id` of the card causing the change, or -1 if generic.
* `card_played`
    * Notable: `instance_id` is the `instance_id` of the `CardInZone` that was played. Contains `card_id`, `card_type`, `remaining_mana`.
* `card_moved`
    * Notable: A versatile event. `instance_id` is the `instance_id` of the card *as it existed in `from_zone`*. `to_details: Dictionary` may contain `instance_id` if a new ID is assigned in the `to_zone` (e.g., a `CardInZone` becoming a `SummonInstance`). Fields include `player`, `card_id`, `from_zone`, `to_zone`, `from_details`, `to_details`, `reason`, and sourcing IDs.
* `card_removed`
    * Notable: For cards ceasing to exist in a zone (e.g., consumed). Contains `player`, `card_id`, `instance_id` (of the card removed), `from_zone`, `reason`, and sourcing IDs.
* `summon_arrives`
    * Notable: `instance_id` is the *new* unique ID for the `SummonInstance` on the field. Includes `player`, `card_id`, `lane`, stats (`power`, `max_hp`, `current_hp`), `is_swift`, `tags`. `source_card_id` and `source_instance_id` indicate if summoned by another card's effect.
* `summon_leaves_lane`
    * Notable: For non-death removals (e.g., bounce). `instance_id` is that of the summon that left. Includes `player`, `card_id`, `lane`, `reason`, and sourcing IDs.
* `summon_turn_activity`
    * Notable: `instance_id` is the summon performing the activity. `activity_type: String` (e.g., "attack", "direct_attack", "ability_mana_gen") clarifies. Includes `player`, `card_id`, `lane`, `details`.
* `combat_damage`
    * Notable: `instance_id` is `attacking_instance_id`. Includes comprehensive attacker (`attacking_player`, `attacking_lane`, `attacking_card_id`, `attacking_instance_id`) and defender (`defending_player`, `defending_lane`, `defending_card_id`, `defending_instance_id`) details, plus `amount` and `defender_remaining_hp`.
* `direct_damage`
    * Notable: `instance_id` is `attacking_instance_id`. For summons attacking a player directly. Includes attacker details, `target_player`, `amount`, `target_player_remaining_hp`.
* `effect_damage`
    * Notable: For non-combat damage to a player from a card effect. `instance_id` is `source_instance_id` (the card dealing damage). Includes `source_player`, `source_card_id`, `target_player`, `amount`, `target_player_remaining_hp`.
* `hp_change`
    * Notable: Player's main HP. `instance_id` is the ID of the card causing it, or -1. Includes `player`, `amount`, `new_total`, `source_card_id`.
* `creature_hp_change`
    * Notable: Summon's HP. `instance_id` is the ID of the summon whose HP changed. Includes `player` (owner), `lane`, `card_id`, `amount`, `new_hp`, `new_max_hp`, `source_card_id`.
* `stat_change`
    * Notable: Summon's Power/MaxHP. `instance_id` is the summon whose stat changed. Includes `player` (owner), `lane`, `card_id`, `stat: String` ("power" or "max_hp"), `amount` (modifier), `new_value` (total), `source_card_id`.
* `status_change`
    * Notable: Summon gains/loses a dynamic tag. `instance_id` is the summon affected. Includes `player` (owner), `lane`, `card_id`, `status: String`, `gained: bool`, `source_card_id`.
* `creature_defeated`
    * Notable: `instance_id` is the summon that was defeated. Includes `player` (owner), `lane`, `card_id`. Sourced by what caused the death via `source_card_id` and `source_instance_id` passed to `SummonInstance.die()`.
* `graveyards_swapped`
    * Notable: Custom event for Coffin Traders. Contains `player1_name`, `player1_graveyard_now_contains_instance_ids: Array[int]`, and equivalents for player 2. `instance_id` is the Coffin Traders' instance ID.
* `visual_effect`
    * Notable: Generic event for replay-specific cues. `instance_id` is often the primary subject/source of the visual. Includes `effect_id`, `card_id` (optional), `target_locations`, `details`, and sourcing IDs.
* `log_message`
    * Notable: For general messages or non-critical conditions. `instance_id` relates to the log's subject if applicable.
* `battle_end`
    * Notable: `instance_id` is -1. Contains `outcome` and `winner`.

## 6. Battle Replay Scene (`res://scenes/battle_replay_scene.tscn`)

### 6.1. Overview and Purpose
The `BattleReplayScene` is responsible for visualizing a battle based *solely* on the array of event dictionaries produced by `Battle.run_battle()`. It does not contain any game logic itself.

### 6.2. Event Consumption and State Management
* Script: `res://scenes/battle_replay.gd`
* Receives `battle_events: Array[Dictionary]` via `load_and_start_simple_replay()`.
* Maintains `current_event_index` to step through events.
* `active_summon_visuals: Dictionary` maps a summon's `instance_id` to its instantiated `SummonVisual` node. This is crucial for updating and removing summon visuals.
* `player1_library_card_ids`, `player1_graveyard_card_ids` (and equivalents for player 2) store arrays of `card_id` strings to represent these zones. Updates are driven by `card_moved`, `card_removed`, and `initial_library_state` events.
* Processes events sequentially, calling specific handler functions (e.g., `handle_summon_arrives`, `handle_creature_hp_change`) based on `event.event_type`.
* Uses `await` with `Timer` nodes or `AnimationPlayer.animation_finished` signals for pacing and synchronization.

### 6.3. Key Scene Components and Scripts

* **Main Layout:** Uses `MarginContainer`, `VBoxContainer`, and `HBoxContainer` nodes for overall layout. Player areas are typically top and bottom.
* **Player Stats UI:**
    * HP Pips: `HBoxContainer` nodes (e.g., `bottom_player_hp_pips_container`) dynamically styled using `StyleBox` resources (`HP_PIP_FULL_STYLE`, `HP_PIP_EMPTY_STYLE`) based on `hp_change` events.
    * Mana Pips: Similar to HP pips, using mana-specific styles, updated by `mana_change` events.
* **Card Zones (Library/Graveyard):**
    * `HBoxContainer` nodes (e.g., `bottom_player_library_hbox`).
    * Dynamically populated with `CardIconVisual` instances by `_update_zone_display()` based on `card_moved`, `card_removed`, and `initial_library_state` events.
* **Lane Containers:**
    * `HBoxContainer` nodes (`bottom_lane_container`, `top_lane_container`) hold `Panel` nodes for each lane.
    * Each lane `Panel` contains an `AspectRatioContainer` named "CardSlotSquare" which serves as the parent for `SummonVisual` instances.
* **`SummonVisual.tscn` / `res://ui/summon_visual.gd`:**
    * A reusable scene instance representing a summon on the field.
    * Contains `TextureRect` for card art and frame, `Label` nodes for power and HP.
    * `update_display(new_instance_id, new_card_res, power, hp, max_hp, _tags)`: Sets art, text based on `SummonCardResource` and dynamic stats from events.
    * `play_animation(anim_name)`: Triggers animations like "Attack_Punch_Top/Bottom", "death", "ability".
    * Provides tween-based animations for arrival sequences (`animate_fade_in`, `animate_scale_pop`, `animate_shake`) combined in `play_full_arrival_sequence_and_await`.
* **`CardIconVisual.tscn` / `res://ui/card_icon_visual.gd`:**
    * A reusable scene for displaying card art with a frame, primarily used for cards in library/graveyard zones and for spell effect popups.
    * `update_display(card_res: CardResource, ...)`: Sets the card art.
    * `_apply_proportional_margins()`: Adjusts art margins within the frame based on percentages.
* **Spell Effect Popups:**
    * `TopEffectsCanvasLayer` and `SpellPopupAnchor` are used to display `CardIconVisual` instances for spells being cast.
    * `_play_generic_spell_effect_visual()` handles showing the spell card, optional burst effects (`UnmakeImpactEffectScene`), and creature fading.
* **Effect Scenes:**
    * `res://effects/spell_impact_effect.tscn`: A `Node2D` scene with an `AnimatedSprite2D` and an `AnimationPlayer` to play a burst animation and then `queue_free` itself.

### 6.4. Animation and Pacing
* The replay uses `await get_tree().create_timer(duration / playback_speed_scale).timeout` for general pacing between events or steps within handlers.
* For visual actions, it awaits signals like `animation_player.animation_finished` from `SummonVisual` or other animated nodes.
* `SummonVisual` itself uses `create_tween()` for programmatic animations like fade-in, scale-pop, and shake.
* `playback_speed_scale` allows adjusting the overall speed of the replay.

## 7. Data Management & Tools

### 7.1. `CardDB.gd` Autoload
* Location: `res://logic/tools/CardDB.gd`
* A singleton that loads all `CardResource` (`.tres`) files from `res://data/cards/instances/` into a dictionary (`card_resources`) upon game startup (`_ready()` method).
* Provides `get_card_resource(card_id: String) -> CardResource` to access cached card definitions by their string ID. This is used by the replay scene and potentially other parts of the game logic.

### 7.2. `card_data.json` and Card Importer Tool
* Workflow:
    1.  Card data is defined in `res://data/cards/card_data.json`.
    2.  The `@tool` script `res://logic/tools/card_importer_tool.gd` is run from the Godot Editor.
    3.  The tool reads the JSON, validates entries, and for each card:
        * Creates or updates a `.tres` file (e.g., `goblin_scout.tres`) in `res://data/cards/instances/`. This resource file is typed as either `SpellCardResource` or `SummonCardResource`.
        * Populates the resource's exported properties (ID, name, cost, art, stats, tags, etc.) from the JSON data.
        * Ensures a corresponding effect script (e.g., `goblin_scout_effect.gd`) exists in `res://logic/card_effects/`. If not, it creates a placeholder script that extends the correct base card script (`spell_card.gd` or `summon_card.gd`).
        * Links the `.tres` resource's `script` property to its specific effect script.
* This tool automates the creation and maintenance of card resource files, ensuring consistency with the JSON data source.

## 8. Project Structure (Directory Layout Summary)

* `art/`: Contains visual assets like card artwork and UI elements.
* `data/`:
    * `cards/card_data.json`: Source data for all cards.
    * `cards/instances/`: Stores individual card `.tres` resource files.
    * `fonts/`: Font files.
    * `sprite_sheets/`: Image sequences for animations.
* `effects/`: Scene files (`.tscn`) and scripts (`.gd`) for visual effects.
* `logic/`: Core game logic, independent of Godot scenes.
    * `battle.gd`, `combatant.gd`, `summon_instance.gd`, `card_in_zone.gd`: Main simulation classes.
    * `card_effects/`: GDScript files defining specific behaviors for each card.
    * `cards/`: Base `CardResource.gd`, `SpellCardResource.gd`, `SummonCardResource.gd` scripts and base `.tres`.
    * `constants.gd`: Global constants (Autoload).
    * `tools/`: Editor tools and singletons like `CardDB.gd` (Autoload) and `card_importer_tool.gd`.
* `scenes/`: Main game scenes.
    * `battle_replay_scene.tscn` and `battle_replay.gd`: For battle visualization.
    * `placeholder_root_node_2d.tscn`: Temporary scene for testing.
* `tests/`: GUT test scripts.
* `ui/`: Reusable UI scene components and their scripts.
    * `card_icon_visual.tscn` / `.gd`.
    * `summon_visual.tscn` / `.gd`.
    * `styles/`: `.tres` files defining `StyleBox` resources.

## 9. Testing
* **Logic Testing:** Primarily uses the GUT (Godot Unit Test) framework. Test scripts are located in the `tests/` directory.
* **Replay Scene Testing:** Currently relies on manual testing by feeding known event sequences into the `BattleReplayScene` and visually verifying the output.

## 10. Known Discrepancies or Areas for Refinement

* **`Combatant.pay_mana` Event Sourcing:** The `mana_change` event generated when a combatant pays mana is currently sourced to the `combatant_name` with `instance_id: combatant_name` (which is a string, not an int, and inconsistent with typical `instance_id` usage). For richer replay information (e.g., visually linking mana cost to the card played), this event should be enhanced to include `source_card_id` and `source_instance_id` of the card whose cost is being paid. The `instance_id` for such an event should also be the `instance_id` of the card played, or -1 if it's a generic mana payment not tied to a card. This is a known area for future improvement. *(TODO: Refactor `pay_mana` event generation)*.
* **`initial_library_state` Event Content:** This event currently logs an array of `card_ids` (strings). For complete traceability of card instances from the very start of the battle, consider changing `card_ids: Array[String]` to an array of dictionaries, e.g., `cards_in_library: Array[{"card_id": String, "instance_id": int}]`. This would allow the replay (or other systems) to know the unique `instance_id` of every card in the library from turn 0. *(TODO: Enhance `initial_library_state` event structure)*.
* **Event Sourcing Review:** A full audit of all event-generating code paths could be beneficial to ensure consistent and comprehensive application of `source_card_id` and `source_instance_id` where appropriate, to maximize the clarity of the event log. Some older effect scripts might still need adjustments to fully provide this sourcing for all their generated events.
* **`visual_effect` Event Specificity:** While the `visual_effect` event type is flexible, some effects currently using generic `effect_id`s that are then handled by broad functions like `_play_generic_spell_effect_visual` might benefit from more distinct `effect_id`s if their visual representations in the replay are intended to be significantly different or require unique handling logic in the replay scene.
* **`instance_id` in `hp_change` event (for player):** The `hp_change` event (for player HP) can have an `instance_id` field. If the damage/heal is from a specific card instance, this `instance_id` should be that card's instance ID. If it's from a non-card source (e.g. a game rule, or if the source is ambiguous), it should be `-1`. Ensure this is consistently applied.
* **Consistency of `instance_id` Type:** Ensure all `instance_id` fields across all events are consistently integers (or -1 for non-applicable), avoiding string types like `combatant_name`.