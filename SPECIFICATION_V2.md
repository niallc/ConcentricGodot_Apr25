# Concentric Godot Port - Specification v2
*Version: 2.0 (Draft)*
*Date: 2025-05-05*

## 1. Project Overview

* **Game Type:** Turn-based Player vs. Environment (PvE) Deck-Building Auto-Battler.
* **Core Loop (Full Game):** Player selects a deck, navigates a maze encountering adversaries, battles are automatically simulated, player collects rewards (new cards), and repeats until a final boss (Besieger) is defeated.
* **Key Distinction:** Player interaction is limited to deck building and maze navigation. Battle outcomes are pre-calculated based on deterministic logic and then visually replayed.
* **Target Platform:** Godot Engine v4.x, using GDScript.
* **Project Goal (Current Scope):** To implement the core **Battle Simulation** logic and a visually engaging **Battle Replay** scene based solely on the simulation's output (event log). Integration with other game components (Maze, Deck Building, Persistence) is outside the current scope but the architecture should facilitate future integration.
* **Current Status:** The core battle simulation logic for the target set of 70 cards (derived from original JS implementation) is implemented and covered by unit tests (GUT). The next phase focuses on implementing the Battle Replay scene.

## 2. Architecture

The project follows a modular design separating data, logic, and presentation.

* **Scene Structure (Potential Full Game):**
    * `MainMenu.tscn` (Out of Scope): Initial entry point.
    * `MazeScene.tscn` (Out of Scope): Maze navigation interface.
    * `DeckBuildingScene.tscn` (Out of Scope): Interface for player deck construction.
    * `BattleReplayScene.tscn` (**Current Focus**): Visualizes a completed battle simulation.
    * `ResultsScene.tscn` (Out of Scope): Displays battle/quest outcomes and rewards.

* **Core Logic Classes (`res://logic/`):** Encapsulate simulation rules, independent of visuals.
    * `Battle.gd`: Orchestrates a single battle simulation, manages turns, and generates the event log.
    * `Combatant.gd`: Represents the state of a player or opponent during a battle (HP, mana, library, graveyard, lanes).
    * `SummonInstance.gd`: Represents a specific creature instance on the board, holding dynamic state (current HP/Power, modifiers, status effects).
    * Card Effect Scripts (`res://logic/card_effects/*.gd`): Implement unique card behaviors by overriding methods from base card scripts.

* **Data (Resources - `res://data/`):** Define static game data.
    * Card Resources (`res://logic/cards/*.tres`, `res://data/cards/instances/*.tres`): Define base card types (`CardResource`, `SpellCardResource`, `SummonCardResource`) and specific card instances (`.tres` files) holding stats, art paths, descriptions, and links to effect scripts.
    * `card_data.json`: Source file for card data, used by the importer tool.

* **Tools (`res://logic/tools/`):**
    * `card_importer_tool.gd`: `@tool` script run in the editor to generate/update card `.tres` resources and placeholder `_effect.gd` scripts from `card_data.json`.

* **Autoload Singletons:**
    * `Constants.gd`: Holds globally accessible constants (max HP, lane count, etc.).
    * `GameManager.gd` (Minimal/Placeholder): Will eventually manage game state, scene transitions, player pool, etc. For now, only needed if coordinating scenes beyond the battle replay.

* **Key Interface: Battle Events:** The `Battle.run_battle()` function returns an `Array[Dictionary]`, where each dictionary is a `BattleEvent`. This array is the *sole* input for the `BattleReplayScene`, ensuring separation between simulation logic and visual presentation.

* **Component Interaction Diagram:**

    ```mermaid
    graph LR
        subgraph OutOfScope
            MM[MainMenu]
            MS[MazeScene]
            DB[DeckBuildingScene]
            RS[ResultsScene]
            GM[GameManager]
        end

        subgraph CoreLogic
            B(Battle)
            C{Combatant}
            SI{SummonInstance}
            CE[Card Effects]
            %% Simplified ID for Card Resources
            CR[CardResources]
            JSON[CardDataJson] -- Used by --> TOOL[ImporterTool] %% Simplified ID
            TOOL -- Generates/Updates --> CR
            TOOL -- Generates --> CE
        end

        subgraph ReplayFocus
            BRE[BattleReplay Scene]
            SV[Summon Visual Node]
        end

        subgraph DataInterface
            BE[BattleEvents Array]
        end

        %% Connections
        GM ---|Initiates Battle| B;
        B -- run_battle() --> BE;
        GM -- Passes Events --> BRE;
        BRE -- Reads --> BE;
        BRE -- Instantiates/Updates --> SV;
        BRE -- Updates --> UI[Replay UI]; %% Simplified ID

        B -- Instantiates --> C;
        B -- Instantiates --> SI;
        B -- Calls Methods --> C;
        B -- Calls Methods --> SI;
        B -- Calls Methods --> CE;
        SI -- Calls Methods --> CE;

        C -- Calls --> B(add_event);
        SI -- Calls --> B(add_event);
        CE -- Calls --> B(add_event);

        SI -- References --> CR;
        CE -- References --> CR;
        B -- Uses --> CR;

        style BE fill:#9cf,stroke:#333,stroke-width:2px
    ```

## 3. Core Data Structures

* **`CardResource` (`res://logic/cards/card.gd`, `res://logic/cards/card.tres`):**
    * Base class for all cards (`extends Resource`, `class_name CardResource`).
    * `@export var id: String`: Unique identifier (e.g., "GoblinScout").
    * `@export var card_name: String`: Display name (e.g., "Goblin Scout").
    * `@export var cost: int`: Mana cost.
    * `@export var artwork_path: String`: Path to card art (e.g., "res://art/cards/goblin_scout.webp").
    * `@export var description_template: String`: Base description text.
    * `@export var script: GDScript`: Link to the specific effect script (`_effect.gd`) or base script.
    * Methods: `get_card_type() -> String`, `get_formatted_description() -> String`.

* **`SpellCardResource` (`res://logic/cards/spell_card.gd`, `res://logic/cards/spell_card.tres`):**
    * Inherits `CardResource` (`class_name SpellCardResource`).
    * Virtual Methods: `apply_effect(source_card_res, active_combatant, opponent_combatant, battle_instance)`, `can_play(active_combatant, opponent_combatant, turn_count, battle_instance) -> bool`.

* **`SummonCardResource` (`res://logic/cards/summon_card.gd`, `res://logic/cards/summon_card.tres`):**
    * Inherits `CardResource` (`class_name SummonCardResource`).
    * `@export var base_power: int`.
    * `@export var base_max_hp: int`.
    * `@export var tags: Array[String]`: Static tags (e.g., "Undead", "Relentless").
    * `@export var is_swift: bool`: Can act on arrival turn.
    * Virtual Methods: `_on_arrival(summon_instance, ...)`, `_on_death(summon_instance, ...)`, `perform_turn_activity_override(summon_instance, ...) -> bool`, `_on_kill_target(killer, defeated, ...)`, `_get_direct_attack_bonus_damage(summon_instance) -> int`, `_get_bonus_combat_damage(attacker, target) -> int`, `_on_deal_direct_damage(summon_instance, ...) -> bool`, `_end_of_turn_upkeep_effect(summon_instance, ...)`.

* **Card Instances (`res://data/cards/instances/*.tres`):**
    * Individual `.tres` files inheriting from `SpellCardResource` or `SummonCardResource`.
    * Contain specific data (cost, stats, name, art path, description) set via Inspector or tool script.
    * Crucially link to their specific `_effect.gd` script via the `script` property.

* **`card_data.json` & Importer Tool:**
    * `res://data/cards/card_data.json`: Source of truth for card data in a simple format.
    * Structure: Array of objects, each with keys like `id`, `type`, `name`, `cost`, `art`, `description`, `power`, `hp`, `tags`, `swift`.
    * `res://logic/tools/card_importer_tool.gd`: `@tool` script run via `Script -> Run...` menu. Reads JSON, creates/updates `.tres` files in `instances/`, creates placeholder `_effect.gd` scripts in `card_effects/`, links scripts to resources. Uses snake_case for filenames. Halts on first validation or save error.

## 4. Core Logic Implementation

* **`Combatant.gd` (`extends Object`, `class_name Combatant`):**
    * Properties: `combatant_name`, `max_hp`, `current_hp`, `mana`, `library: Array[CardResource]`, `graveyard: Array[CardResource]`, `lanes: Array` (holds `SummonInstance` or `null`), `battle_instance: Battle`, `opponent: Combatant`.
    * Key Methods:
        * `setup()`: Initializes state, duplicates deck (no shuffle).
        * `take_damage()`: Reduces `current_hp`, generates `hp_change` event, returns `true` if HP <= 0.
        * `heal()`: Increases `current_hp` (up to `max_hp`), generates `hp_change` event.
        * `gain_mana()`: Increases `mana` (up to `Constants.MAX_MANA`), generates `mana_change` event.
        * `lose_mana()`: Decreases `mana` (down to 0), generates `mana_change` event.
        * `pay_mana()`: Decreases `mana`, generates `mana_change` event, returns `true` if successful.
        * `add_card_to_graveyard()`: Appends card resource, generates `card_moved` event.
        * `mill_top_card()`: Removes card from library top, calls `add_card_to_graveyard`.
        * `find_first_empty_lane()`: Returns index or -1.
        * `place_summon_in_lane()`: Assigns `SummonInstance` to `lanes` array.
        * `remove_summon_from_lane()`: Sets lane slot to `null`.

* **`SummonInstance.gd` (`extends Object`, `class_name SummonInstance`):**
    * Properties: `card_resource: SummonCardResource`, `owner_combatant`, `opponent_combatant`, `battle_instance`, `lane_index`, `base_power`, `base_max_hp`, `current_hp`, `power_modifiers: Array[Dictionary]`, `max_hp_modifiers: Array[Dictionary]`, `tags: Array[String]`, `is_newly_arrived`, `is_swift`, `is_relentless`, `custom_state: Dictionary`.
    * Modifier Format: `{"source": String, "value": int, "duration": int}` (`-1` = permanent).
    * Key Methods:
        * `setup()`: Initializes state from `card_resource`, sets `is_relentless` based on tags.
        * `get_current_power()`, `get_current_max_hp()`: Calculate stats by applying active modifiers to base values.
        * `take_damage()`: Reduces `current_hp`, generates `creature_hp_change`, calls `die()` if needed.
        * `heal()`: Increases `current_hp` (up to `get_current_max_hp()`), generates `creature_hp_change`.
        * `add_power()`, `add_hp()`: Add modifier dictionary to list, generate `stat_change` event (reporting *new* calculated total). `add_hp` also calls `heal`.
        * `add_counter()`: Calls `add_power` and `add_hp`.
        * `perform_turn_activity()`: Checks for script override, then checks `is_relentless`/opposing lane, calls `_perform_direct_attack` or `_perform_combat`, generates `summon_turn_activity` event.
        * `_perform_direct_attack()`: Calculates damage (using `get_current_power` + bonus damage hook), calls `opponent_combatant.take_damage`, generates `direct_damage` event, calls `_on_deal_direct_damage` hook, checks for Glassgraft sacrifice, checks game over.
        * `_perform_combat()`: Calculates damage (using `get_current_power` + bonus damage hook), calls `target_instance.take_damage`, generates `combat_damage` event, checks for kill and calls `_on_kill_target` hook, calls `_on_attack_resolved` hook.
        * `die()`: Generates `creature_defeated`, calls `_on_death` hook, checks `replaced_in_lane` flag before calling `owner_combatant.remove_summon_from_lane`, checks `prevent_graveyard` flag before calling `owner_combatant.add_card_to_graveyard`.
        * `_end_of_turn_upkeep()`: Resets `is_newly_arrived`, processes modifier durations (decrements, removes expired), generates `stat_change` events if stats changed due to expiration, clamps `current_hp` to new `max_hp` (generating `creature_hp_change` if needed), calls `_end_of_turn_upkeep_effect` hook.

* **`Battle.gd` (`extends Object`, `class_name Battle`):**
    * Properties: `duelist1: Combatant`, `duelist2: Combatant`, `turn_count`, `battle_events: Array[Dictionary]`, `_event_timestamp_counter`, `_event_id_counter`, `rng`, `current_seed`, `battle_state`.
    * Key Methods:
        * `run_battle()`: Entry point. Initializes state, sets up Combatants, runs main turn loop, returns `battle_events`.
        * `add_event()`: Appends event dictionary to `battle_events`, adding `turn`, `timestamp`, `event_id`.
        * `check_game_over()`: Checks if `duelist1.current_hp <= 0` or `duelist2.current_hp <= 0`, calls `log_winner` if true and state was "Ongoing". Returns `true` if game ended.
        * `log_winner()`: Sets `battle_state` to "Finished", determines outcome (uses "Draw (Player loss)" for turn limit), generates `battle_end` event.
        * `conduct_turn()`: Executes phases for the active player:
            1.  **Start of Turn:** Generate `turn_start` event. `active_duelist.gain_mana()`. (*TODO: Add start-of-turn triggers if needed*). Check game over.
            2.  **Card Play:** Check top card of `library`. Check `can_play` (mana, custom script, lane availability). If playable: `pay_mana`, `remove_card_from_library`, generate `card_played` event. If Summon: create `SummonInstance`, `setup`, `place_summon_in_lane`, generate `summon_arrives`, call `_on_arrival`. If Spell: call `apply_effect`, `add_card_to_graveyard`. Check game over.
            3.  **Summon Activity:** Iterate active player's lanes. For each `SummonInstance` not newly arrived (unless swift), call `perform_turn_activity`. Check game over after each summon acts.
            4.  **End of Turn:** Iterate active player's lanes, call `_end_of_turn_upkeep` on each `SummonInstance`. (*TODO: Add end-of-turn triggers if needed*).
    * **Simultaneous Event Order:** Active Player > Opponent Player; Lane 1 > Lane 2 > Lane 3; Library/Graveyard Top > Bottom.

* **Effect Scripts (`res://logic/card_effects/*.gd`):**
    * Inherit from `SpellCardResource` or `SummonCardResource`.
    * Override virtual methods (`apply_effect`, `can_play`, `_on_arrival`, `_on_death`, `_on_kill_target`, `_get_bonus_combat_damage`, etc.) to implement card-specific logic.
    * Responsible for calling `battle_instance.add_event` for visual effects or specific logging related to their actions.
    * Example (Troll): `troll_effect.gd` overrides `_end_of_turn_upkeep_effect` to call `summon_instance.heal(1)`.

## 5. Battle Event Specification

* **Purpose:** Chronological, structured log generated by `Battle.run_battle()`, detailing all significant state changes and actions for consumption by the `BattleReplay` scene.
* **Format:** `Array[Dictionary]`
* **Common Properties (in each Dictionary):**
    * `event_type: String`: Identifier for the event category.
    * `turn: int`: Turn number (0-based start, increments after opponent's turn completes).
    * `timestamp: float`: Auto-incrementing value for ordering events within a turn.
    * `event_id: int`: Unique sequential ID for each event generated.
* **Detailed Event Types:**
    * **`turn_start`**: Indicates the start of a player's turn phase.
        * `player: String`: Name of the active combatant.
    * **`mana_change`**: Player gains or loses mana.
        * `player: String`: Name of the affected combatant.
        * `amount: int`: Mana change (+ve for gain, -ve for loss/cost).
        * `new_total: int`: Mana total after the change.
        * `source: String` (Optional): ID of the card/effect causing the change (e.g., "turn_start", "CardID", "AmnesiaMage").
    * **`card_played`**: Summary event logged after a card is successfully played and its cost paid.
        * `player: String`: Name of the player.
        * `card_id: String`: ID of the card resource played.
        * `card_type: String`: "Spell" or "Summon".
        * `remaining_mana: int`: Player's mana after paying the cost.
    * **`card_moved`**: A card resource reference moves between zones.
        * `player: String`: Name of the combatant whose zones are involved.
        * `card_id: String`: ID of the card resource moved.
        * `from_zone: String`: e.g., "library", "graveyard", "lane", "play", "limbo", "library_top_heedless_vandal", "library_bottom_ghoul".
        * `to_zone: String`: e.g., "library", "graveyard", "lane", "play", "limbo".
        * `from_details: Dictionary` (Optional): e.g., `{"lane": int}` (1-based), `{"position": "top" | "bottom"}`.
        * `to_details: Dictionary` (Optional): e.g., `{"lane": int}` (1-based), `{"position": "top" | "bottom"}`.
        * `reason: String` (Optional): ID of card/effect causing the move (e.g., "play", "death", "reanimate", "mill_ghoul").
    * **`card_removed`**: A card resource reference is removed entirely (e.g., consumed from graveyard).
        * `player: String`: Owner of the zone.
        * `card_id: String`: ID of the card resource removed.
        * `from_zone: String`: "graveyard", etc.
        * `reason: String`: ID of card/effect causing removal (e.g., "corpsecraft_titan", "superior_intellect", "chanter_of_ashes").
    * **`summon_arrives`**: A `SummonInstance` is created and placed in a lane.
        * `player: String`: Owner of the summon.
        * `card_id: String`: ID of the summon card resource.
        * `lane: int`: Lane index (1-based).
        * `instance_id: int` (**TODO: Implement** - Unique ID for this specific instance).
        * `power: int`: Initial calculated power.
        * `max_hp: int`: Initial calculated max HP.
        * `current_hp: int`: Initial current HP (usually == max_hp).
        * `is_swift: bool`: If the summon can act this turn.
        * `tags: Array[String]` (Optional): Initial tags (e.g., ["Undead"]).
        * `source_effect: String` (Optional): ID of the card/effect that summoned it (if not played directly, e.g., "GoblinRally", "Reanimate").
    * **`summon_leaves_lane`**: A `SummonInstance` is removed from a lane (for reasons other than standard death, e.g., bounce).
        * `player: String`: Owner of the summon.
        * `lane: int`: Lane index (1-based).
        * `card_id: String`: ID of the summon card resource.
        * `instance_id: int` (**TODO: Implement**).
        * `reason: String`: Cause (e.g., "bounce_portal_mage", "bounce_elsewhere").
    * **`summon_turn_activity`**: A summon starts its action phase for the turn.
        * `player: String`: Owner of the summon.
        * `lane: int`: Lane index (1-based).
        * `instance_id: int` (**TODO: Implement**).
        * `activity_type: String`: "attack" (vs creature), "direct_attack" (vs player), "ability_mana_gen" (WallOfVines), etc.
    * **`combat_damage`**: Damage dealt from one summon instance to another.
        * `attacking_player: String`.
        * `attacking_lane: int` (1-based).
        * `attacking_instance_id: int` (**TODO: Implement**).
        * `defending_player: String`.
        * `defending_lane: int` (1-based).
        * `defending_instance_id: int` (**TODO: Implement**).
        * `amount: int`: Damage dealt (always >= 0).
        * `defender_remaining_hp: int`: Target's HP *after* damage.
    * **`direct_damage`**: Damage dealt from a summon instance directly to a player.
        * `attacking_player: String`.
        * `attacking_lane: int` (1-based).
        * `attacking_instance_id: int` (**TODO: Implement**).
        * `target_player: String`: Player taking damage.
        * `amount: int`: Damage dealt (always >= 0).
        * `target_player_remaining_hp: int`: Target player's HP *after* damage.
    * **`effect_damage`**: Damage dealt directly to a player from a spell/effect source (not combat).
        * `source_card_id: String`: ID of the spell/summon causing damage.
        * `source_player: String`: Player controlling the source.
        * `target_player: String`: Player taking damage.
        * `amount: int`: Damage dealt (always >= 0).
        * `target_player_remaining_hp: int`: Target player's HP *after* damage.
    * **`hp_change`**: A player's main HP changes (heal or non-combat damage).
        * `player: String`: Affected player.
        * `amount: int`: Change amount (+ve for heal, -ve for damage).
        * `new_total: int`: HP after change.
        * `source: String` (Optional): ID of card/effect causing change (e.g., "Healer", "Nap", "KnightOfOpposites").
    * **`creature_hp_change`**: A summon instance's HP changes.
        * `player: String`: Owner of the summon.
        * `lane: int`: Lane index (1-based).
        * `instance_id: int` (**TODO: Implement**).
        * `amount: int`: Change amount (+ve for heal, -ve for damage).
        * `new_hp: int`: Current HP after change.
        * `new_max_hp: int`: Current Max HP after change.
        * `source: String` (Optional): ID of card/effect/instance causing change.
    * **`stat_change`**: A summon instance's calculated Power or MaxHP changes.
        * `player: String`: Owner of the summon.
        * `lane: int`: Lane index (1-based).
        * `instance_id: int` (**TODO: Implement**).
        * `stat: String`: "power" or "max_hp".
        * `amount: int`: The amount the stat *modifier* added/removed.
        * `new_value: int`: The *new calculated total* value of the stat after the change.
        * `source: String` (Optional): ID of card/effect causing change (e.g., "EnergyAxe", "expiration").
    * **`status_change`**: A summon instance gains or loses a status/tag dynamically.
        * `player: String`: Owner of the summon.
        * `lane: int`: Lane index (1-based).
        * `instance_id: int` (**TODO: Implement**).
        * `status: String`: Name of the status (e.g., "Relentless", "Undead").
        * `gained: bool`: `true` if gained, `false` if lost.
        * `source: String` (Optional): ID of card/effect causing change.
    * **`creature_defeated`**: A summon instance's HP reached <= 0 and it died.
        * `player: String`: Owner of the summon.
        * `lane: int`: Lane index (1-based).
        * `instance_id: int` (**TODO: Implement**).
        * `card_id: String` (Optional): ID of the defeated creature's card resource.
    * **`visual_effect`**: Trigger a purely visual effect not tied directly to state change.
        * `effect_id: String`: Unique name for the effect animation (e.g., "inferno_damage", "hexplate_buff", "samurai_sacrifice").
        * `target_locations: Array[String]`: List of targets (e.g., ["Player lane 1", "Opponent", "all_lanes", "Player graveyard"]). Needs mapping in replay script.
        * `details: Dictionary` (Optional): Extra data for the animation (e.g., `{"amount": 3}`, `{"color": "#FF0000"}`).
    * **`log_message`**: Generic message for debugging or non-critical info replay.
        * `message: String`: Text to display/log.
    * **`battle_end`**: Final event indicating battle conclusion.
        * `outcome: String`: "Player Wins", "Opponent Wins", "Draw (Player loss)". (**NOTE:** Need to ensure `log_winner` uses consistent player/opponent naming).
        * `winner: String`: Name of the winning combatant ("Nobody" for draw).

* **TODO:** Decide on and implement `instance_id` generation (e.g., simple counter in `Battle`) and inclusion in relevant events. Store this ID on `SummonInstance`.
* **TODO:** Refine `source` fields - use Card IDs consistently where applicable.
* **Tracking Usage:** The `BattleReplay` implementation should document which event fields it uses. Periodically review generated events vs. used fields to identify potentially redundant data.

## 6. Battle Replay Scene (`BattleReplay`) Guidance

* **Goal:** Visually reconstruct the battle turn-by-turn based *only* on the `BattleEvents` array. Provide clear feedback to the player about the game flow and actions.
* **Input:** `battle_events: Array[Dictionary]` (passed from `GameManager` or test script).
* **Scene Structure (`battle_replay_scene.tscn`):**
    * Root Node (e.g., `Control` or `Node2D`).
    * Background.
    * Player Areas (Top/Bottom): Containers for lanes, HP, Mana, Deck/Grave indicators.
        * HP Bars (e.g., `TextureProgressBar` or custom segment approach).
        * Mana Displays (e.g., `HBoxContainer` with mana crystal icons).
        * Deck/Graveyard Indicators (e.g., `TextureRect` with card back, `Label` for count).
        * Player Name Labels.
    * Lane Containers (e.g., `HBoxContainer` within each player area).
        * Individual Lane Nodes (e.g., `PanelContainer` or `TextureRect`, `Constants.LANE_COUNT` per player). IDs like `TopLane1`, `BottomLane2`.
    * UI Layer: Turn counter label, Playback controls (Buttons: Play/Pause, Step, Speed?), potentially an event log display area.
    * AnimationPlayer node (optional, for complex pre-defined animations).
    * Effect Layer (optional, for particle effects or overlays).
* **Summon Visual Node (`summon_visual.tscn` - Reusable Scene):**
    * Root (e.g., `Control` or `Node2D`).
    * `TextureRect` for card artwork (`card_art`).
    * `Label` for Power (`power_label`).
    * `Label` for HP (`hp_label`, format "Current/Max").
    * (Optional) Nodes for status icons (e.g., Swift, Relentless).
    * (Optional) `AnimationPlayer` for simple animations (damage flash, death fade).
    * Script (`summon_visual.gd`):
        * `instance_id: int` (Set when instantiated by replay).
        * `card_id: String`.
        * `func update_display(card_res: SummonCardResource, power: int, hp: int, max_hp: int, tags: Array[String])`: Updates art, labels, status icons.
        * `func play_animation(anim_name: String)`: Plays animation (e.g., "take_damage", "attack", "death", "buff").
* **Core Logic (`battle_replay.gd`):**
    * `var battle_events: Array[Dictionary]`
    * `var current_event_index: int = -1`
    * `var is_playing: bool = false`
    * `var playback_speed_scale: float = 1.0`
    * `var active_summon_visuals: Dictionary = {}` # Maps instance_id to SummonVisual node instance
    * `_ready()`: Get references to UI nodes. Potentially load events if passed via GameManager.
    * `load_events(events: Array[Dictionary])`: Stores events, resets state.
    * `_process(delta)` or Timer Timeout: If `is_playing`, call `process_next_event()`.
    * `_on_PlayButton_pressed()`: Set `is_playing = true`.
    * `_on_PauseButton_pressed()`: Set `is_playing = false`.
    * `_on_StepButton_pressed()`: If not playing, call `process_next_event()`.
    * `process_next_event()`:
        * Increment `current_event_index`.
        * If index out of bounds, set `is_playing = false`, return.
        * Get `event = battle_events[current_event_index]`.
        * Use `match event.event_type:` to call specific handlers.
        * Use `await` with timers or animation signals within handlers for pacing.
* **Event Handlers (Example Implementations):**
    * `func handle_turn_start(event):`
        * `$TurnLabel.text = "Turn %d (%s)" % [event.turn, event.player]`
        * `await get_tree().create_timer(0.5 * playback_speed_scale).timeout`
    * `func handle_summon_arrives(event):`
        * Load `SummonVisual` scene: `var visual_scene = preload("res://ui/summon_visual.tscn")`
        * Instantiate: `var visual_node = visual_scene.instantiate()`
        * Set properties: `visual_node.instance_id = event.instance_id` (**Requires instance_id added to event!**)
        * Find target lane node (e.g., `$TopPlayerArea/Lanes/TopLane%d % event.lane`).
        * Add visual node: `target_lane_node.add_child(visual_node)`
        * Store reference: `active_summon_visuals[event.instance_id] = visual_node`
        * Update display: `visual_node.update_display(load(card_resource_path), event.power, event.hp, event.max_hp, event.tags)` (**Need card resource path mapping? Or pass more data in event?**)
        * Play arrival animation: `visual_node.play_animation("arrive")`
        * `await visual_node.animation_player.animation_finished # Or timer`
    * `func handle_creature_hp_change(event):`
        * Find visual node: `var visual_node = active_summon_visuals.get(event.instance_id)` (**Requires instance_id**)
        * If found:
            * `visual_node.update_display(...)` # Update HP label
            * `visual_node.play_animation("heal")` or `visual_node.play_animation("damage")`
            * `await visual_node.animation_player.animation_finished`
    * `func handle_creature_defeated(event):`
        * Find visual node: `var visual_node = active_summon_visuals.get(event.instance_id)` (**Requires instance_id**)
        * If found:
            * `visual_node.play_animation("death")`
            * `await visual_node.animation_player.animation_finished`
            * Remove reference: `active_summon_visuals.erase(event.instance_id)`
            * Remove node: `visual_node.queue_free()`
    * *...(Implement handlers for all other relevant event types: mana_change, card_moved, stat_change, combat_damage, direct_damage, visual_effect, battle_end, etc.)...*
* **Simplified Replay First:** Implement handlers first using only `print()` statements or simple `Label` updates to verify event processing order and data extraction *before* adding complex scene instantiation and animations. This validates the event log consumption.
* **Timing/Pacing:** Use `await get_tree().create_timer(duration * playback_speed_scale).timeout` between processing steps within handlers or between events to control speed. Use `await some_animation_player.animation_finished` to wait for visual actions to complete.

## 7. Other Components (Briefly)

* **GameManager:** Central coordinator. Will need methods like `start_battle(player_deck, opponent_deck)` which instantiates `Battle`, runs it, and transitions to `BattleReplayScene`, passing the events. Manages player card pool, quest state (Out of Scope).
* **Maze/DeckBuilding/Results:** Interact with `GameManager` to get necessary data (available rooms, card pool, battle outcomes) and trigger actions (select room, build deck, start battle). (Out of Scope).
* **Integration Points:** `GameManager` passing decks to `Battle` and events to `BattleReplay`. `BattleReplay` potentially signalling completion back to `GameManager` to transition to `ResultsScene`.

## 8. Testing Strategy

* **Logic (GUT):** Extensive unit tests cover `Combatant`, `SummonInstance`, card effect logic, and resource loading. Tests verify state changes and event generation. (Currently ~74 tests passing).
* **Battle Simulation:** Tests run minimal `Battle` simulations with specific decks to verify outcomes and high-level event sequences.
* **Battle Replay:** Primarily manual testing by feeding known event sequences (from tests or saved simulations) and verifying visual output matches expectations. Automated scene-based testing might be possible but complex. Focus on testing individual event handlers visually, especially during the "Simplified Replay First" phase.

## 9. Constants & Configuration

* `Constants.gd` (Autoload): Defines core game values (HP, Mana, Lanes, Turns).
* Card data configured via `card_data.json` and `.tres` files.
* Consider Project Settings for replay speed defaults or other UI configurations.

## 10. Future Considerations / Potential Refactors

* **Control Change / Static Auras:** Identified as complex mechanics requiring potential architectural changes if implemented (rethinking `SummonInstance` ownership, global effect management).
* **Counters:** Generic counters (e.g., +1/+1 counters, poison counters) could likely be implemented using the existing `SummonInstance.custom_state` dictionary or potentially by adding a dedicated `counters: Dictionary` property. The modifier system handles stat changes, but distinct named counters might need separate tracking.
* **Performance:** Monitor performance during replay, especially with many visual effects or summons. Optimize event processing and animations if needed.
* **Event Granularity:** Review event usage by the replay; potentially prune unused fields or add more detail if required by animations.

