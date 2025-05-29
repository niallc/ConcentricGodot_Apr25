# Concentric Godot Port - Specification v2
*Version: 2.1 (Revised Draft)*
*Date: 2025-05-20*

## 1. Project Overview

* **Game Type:** Turn-based Player vs. Environment (PvE) Deck-Building Auto-Battler. [cite: 1]
* **Core Loop (Full Game):** Player selects a deck, navigates a maze encountering adversaries, battles are automatically simulated, player collects rewards (new cards), and repeats until a final boss (Besieger) is defeated. [cite: 1]
* **Key Distinction:** Player interaction is limited to deck building and maze navigation. [cite: 1] Battle outcomes are pre-calculated based on deterministic logic and then visually replayed. [cite: 1]
* **Target Platform:** Godot Engine v4.x, using GDScript. [cite: 1]
* **Project Goal (Current Scope):** To implement the core **Battle Simulation** logic and a visually engaging **Battle Replay** scene based solely on the simulation's output (event log). [cite: 1] Integration with other game components (Maze, Deck Building, Persistence) is outside the current scope but the architecture should facilitate future integration. [cite: 1]
* **Current Status:** The core battle simulation logic is being refined to ensure robust instance tracking and event generation for the Battle Replay scene. [cite: 1] Unit tests (GUT) cover existing logic. [cite: 1]

## 2. Architecture

The project follows a modular design separating data, logic, and presentation. [cite: 1]

* **Scene Structure (Potential Full Game):**
    * `MainMenu.tscn` (Out of Scope) [cite: 1]
    * `MazeScene.tscn` (Out of Scope) [cite: 1]
    * `DeckBuildingScene.tscn` (Out of Scope) [cite: 1]
    * `BattleReplayScene.tscn` (**Current Focus**) [cite: 1]
    * `ResultsScene.tscn` (Out of Scope) [cite: 1]

* **Core Logic Classes (`res://logic/`):** Encapsulate simulation rules, independent of visuals. [cite: 1]
    * `Battle.gd`: Orchestrates a single battle simulation, manages turns, generates unique instance IDs for all card entities in the battle, and produces the event log.
    * `Combatant.gd`: Represents the state of a player or opponent during a battle (HP, mana, library, graveyard, lanes). [cite: 1] Library and Graveyard now store `CardInZone` objects.
    * `CardInZone.gd`: Represents a specific instance of a card in a non-battlefield zone (library, graveyard, "play"), linking a `CardResource` with a battle-specific `instance_id`.
    * `SummonInstance.gd`: Represents a specific creature instance on the board, holding dynamic state (current HP/Power, modifiers, status effects) and a unique battle-specific `instance_id`. [cite: 1]
    * Card Effect Scripts (`res://logic/card_effects/*.gd`): Implement unique card behaviors by overriding methods from base card scripts (`SpellCardResource`, `SummonCardResource`). [cite: 1]

* **Data (Resources - `res://data/`):** Define static game data. [cite: 1]
    * Card Resources (`res://logic/cards/*.tres`, `res://data/cards/instances/*.tres`): Define base card types (`CardResource`, `SpellCardResource`, `SummonCardResource`) and specific card instances (`.tres` files) holding stats, art paths, descriptions, and links to effect scripts. [cite: 1]
    * `card_data.json`: Source file for card data, used by the importer tool. [cite: 1]

* **Tools (`res://logic/tools/`):**
    * `card_importer_tool.gd`: `@tool` script run in the editor to generate/update card `.tres` resources and placeholder `_effect.gd` scripts from `card_data.json`. [cite: 1]

* **Autoload Singletons:**
    * `Constants.gd`: Holds globally accessible constants (max HP, lane count, etc.). [cite: 1]
    * `GameManager.gd` (Minimal/Placeholder): Will eventually manage game state, scene transitions, player pool, etc. [cite: 1]
    * `CardDB.gd`: Loads and provides access to all `CardResource` definitions by their ID.

* **Key Interface: Battle Events:** The `Battle.run_battle()` function returns an `Array[Dictionary]`, where each dictionary is a `BattleEvent`. [cite: 1] This array is the *sole* input for the `BattleReplayScene`. [cite: 1]

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
            CIZ{CardInZone} 
            SI{SummonInstance}
            CE[Card Effects]
            CR[CardResources]
            JSON[CardDataJson] -- Used by --> TOOL[ImporterTool]
            TOOL -- Generates/Updates --> CR
            TOOL -- Generates --> CE
        end

        subgraph ReplayFocus
            BRE[BattleReplay Scene]
            SV[Summon Visual Node] 
            CV[Card Visual Node] 
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
        BRE -- Instantiates/Updates --> CV; 
        BRE -- Updates --> UI[Replay UI];

        B -- Instantiates --> C;
        B -- Generates IDs for --> CIZ; 
        B -- Generates IDs for --> SI;
        B -- Calls Methods --> C;
        B -- Calls Methods --> SI;
        B -- Calls Methods --> CE; 

        C -- Holds --> CIZ; 
        SI -- Calls Methods --> CE; 

        C -- Calls --> B(add_event);
        SI -- Calls --> B(add_event);
        CE -- Calls --> B(add_event); 

        CIZ -- References --> CR;
        SI -- References --> CR; 
        CE -- References --> CR; 
        B -- Uses --> CR; 

        style BE fill:#9cf,stroke:#333,stroke-width:2px
    ```

## 3. Core Data Structures

* **`CardResource` (`res://logic/cards/card.gd`, `res://logic/cards/card.tres`):**
    * Base class for all cards (`extends Resource`, `class_name CardResource`). [cite: 1]
    * `@export var id: String`: Unique identifier (e.g., "GoblinScout"). [cite: 1]
    * `@export var card_name: String`: Display name (e.g., "Goblin Scout"). [cite: 1]
    * `@export var cost: int`: Mana cost. [cite: 1]
    * `@export var artwork_path: String`: Path to card art. [cite: 1]
    * `@export var description_template: String`: Base description text. [cite: 1]
    * `@export var script: GDScript`: Link to the specific effect script (`_effect.gd`) or base script. [cite: 1]
    * Methods: `get_card_type() -> String`, `get_formatted_description() -> String`. [cite: 1]

* **`SpellCardResource` (`res://logic/cards/spell_card.gd`, `res://logic/cards/spell_card.tres`):**
    * Inherits `CardResource` (`class_name SpellCardResource`). [cite: 1]
    * Virtual Methods: `apply_effect(p_played_spell_card_in_zone: CardInZone, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle)`, `can_play(active_combatant: Combatant, opponent_combatant: Combatant, turn_count: int, battle_instance: Battle) -> bool`. [cite: 1]

* **`SummonCardResource` (`res://logic/cards/summon_card.gd`, `res://logic/cards/summon_card.tres`):**
    * Inherits `CardResource` (`class_name SummonCardResource`). [cite: 1]
    * `@export var base_power: int`. [cite: 1]
    * `@export var base_max_hp: int`. [cite: 1]
    * `@export var tags: Array[String]`: Static tags. [cite: 1]
    * `@export var is_swift: bool`: Can act on arrival turn. [cite: 1]
    * Virtual Methods: `_on_arrival(summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle)`, `_on_death(summon_instance: SummonInstance, active_combatant: Combatant, opponent_combatant: Combatant, battle_instance: Battle)`, `perform_turn_activity_override(summon_instance: SummonInstance, ...) -> bool`, `_on_kill_target(killer: SummonInstance, defeated: SummonInstance, ...)`, `_get_direct_attack_bonus_damage(summon_instance: SummonInstance) -> int`, `_get_bonus_combat_damage(attacker: SummonInstance, target: SummonInstance) -> int`, `_on_deal_direct_damage(summon_instance: SummonInstance, ...) -> bool`, `_end_of_turn_upkeep_effect(summon_instance: SummonInstance, ...)`. [cite: 1]

* **`CardInZone` (`res://logic/card_in_zone.gd`):**
    * Represents a specific instance of a card in a non-battlefield zone (library, graveyard, or temporarily in "play").
    * `extends RefCounted`, `class_name CardInZone`.
    * Properties:
        * `card_resource: CardResource`: The underlying static card data.
        * `instance_id: int`: A unique identifier for this specific instance of the card within the current battle, assigned by `Battle._generate_new_card_instance_id()`.
    * Methods: `_init(p_card_resource: CardResource, p_instance_id: int)`, `get_card_id() -> String`, `get_card_name() -> String`, `get_cost() -> int`, `get_card_instance_id() -> int`.

* **Card Instances (`res://data/cards/instances/*.tres`):**
    * Individual `.tres` files inheriting from `SpellCardResource` or `SummonCardResource`. [cite: 1]
    * Contain specific data set via Inspector or tool. [cite: 1]
    * Link to their specific `_effect.gd` script via the `script` property. [cite: 1]

* **`card_data.json` & Importer Tool:**
    * `res://data/cards/card_data.json`: Source of truth for card data. [cite: 1]
    * `res://logic/tools/card_importer_tool.gd`: `@tool` script to generate/update resources and effect script placeholders. [cite: 1]

## 4. Core Logic Implementation

* **`Combatant.gd` (`extends Object`, `class_name Combatant`):**
    * Properties: `combatant_name`, `max_hp`, `current_hp`, `mana`, `library: Array[CardInZone]`, `graveyard: Array[CardInZone]`, `lanes: Array` (holds `SummonInstance` or `null`), `battle_instance: Battle`, `opponent: Combatant`. [cite: 1]
    * Key Methods:
        * `setup(deck_res_list: Array[CardResource], ...)`: Initializes state. [cite: 1] Wraps `CardResource` objects from `deck_res_list` into `CardInZone` objects for the library, each getting a unique `instance_id` from `battle_instance`.
        * `take_damage(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Reduces `current_hp`, generates `hp_change` event. [cite: 1]
        * `heal(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Increases `current_hp`, generates `hp_change` event. [cite: 1]
        * `gain_mana(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Increases `mana`, generates `mana_change` event. [cite: 1]
        * `lose_mana(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Decreases `mana`, generates `mana_change` event. [cite: 1]
        * `pay_mana(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Decreases `mana`, generates `mana_change` event. [cite: 1] (**TODO:** Confirm if `p_source_card_id` and `p_source_instance_id` for payer are needed for event or if play context is enough).
        * `add_card_to_graveyard(p_card_in_zone_obj: CardInZone, p_from_zone: String, p_instance_id_from_origin_zone: int = -1, p_reason_card_id: String = "", p_reason_instance_id: int = -1)`: Appends `CardInZone`, generates `card_moved` event with rich source/destination details. [cite: 1] (**TODO:** Implement this signature change in code).
        * `remove_card_from_library() -> CardInZone`: Removes `CardInZone` from library top, generates `card_moved` event. [cite: 1]
        * `mill_top_card(reason_suffix: String)`: Calls `remove_card_from_library`, then `add_card_to_graveyard`. [cite: 1]
        * `find_first_empty_lane() -> int`. [cite: 1]
        * `place_summon_in_lane(summon_instance: SummonInstance, lane_index: int)`. [cite: 1]
        * `remove_summon_from_lane(lane_index: int)`. [cite: 1]

* **`SummonInstance.gd` (`extends Object`, `class_name SummonInstance`):**
    * Properties: `card_resource: SummonCardResource`, `owner_combatant`, `opponent_combatant`, `battle_instance`, `lane_index`, `instance_id: int` (unique ID for this summon on the field, assigned by `Battle`), `base_power`, `base_max_hp`, `current_hp`, `power_modifiers`, `max_hp_modifiers`, `tags`, `is_newly_arrived`, `is_swift`, `is_relentless`, `custom_state`. [cite: 1]
    * Key Methods:
        * `setup(card_res: SummonCardResource, ..., new_instance_id: int)`: Initializes state, including its `instance_id`. [cite: 1]
        * `take_damage(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Reduces `current_hp`, generates `creature_hp_change`, calls `die()`. [cite: 1]
        * `heal(amount: int, p_source_card_id: String, p_source_instance_id: int)`: Increases `current_hp`, generates `creature_hp_change`. [cite: 1]
        * `add_power(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)`: Adds modifier, generates `stat_change`. [cite: 1]
        * `add_hp(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)`: Adds modifier, generates `stat_change`, calls `heal`. [cite: 1]
        * `add_counter(amount: int, p_source_card_id: String, p_source_instance_id: int, duration: int)`: Calls `add_power` and `add_hp`. [cite: 1]
        * `perform_turn_activity()`: Generates `summon_turn_activity` event (event includes acting summon's `card_id` and `instance_id`). [cite: 1]
        * `_perform_direct_attack()`: Generates `direct_damage` event (event includes attacker details). [cite: 1]
        * `_perform_combat(target_instance: SummonInstance)`: Generates `combat_damage` event (event includes attacker/defender details). [cite: 1]
        * `die()`: Generates `creature_defeated`. [cite: 1] Calls `owner_combatant.add_card_to_graveyard` (passing a new `CardInZone` with a new `instance_id`, and the dying summon's `instance_id` as `p_instance_id_from_origin_zone`). (**TODO:** `die()` should pass its own `card_resource.id` and `instance_id` as the `p_reason_card_id` and `p_reason_instance_id` to `add_card_to_graveyard` for the resulting `card_moved` event's sourcing).
        * `_end_of_turn_upkeep()`: Generates `stat_change` or `creature_hp_change` if stats/HP change due to expirations. [cite: 1] Sourced to "expiration", `instance_id` is the summon.

* **`Battle.gd` (`extends Object`, `class_name Battle`):**
    * Properties: `duelist1: Combatant`, `duelist2: Combatant`, `turn_count`, `battle_events: Array[Dictionary]`, `_event_timestamp_counter`, `_event_id_counter`, `rng`, `current_seed`, `battle_state`, `_next_card_instance_id: int`. [cite: 1]
    * Key Methods:
        * `_generate_new_card_instance_id() -> int`: Returns a unique integer ID for any card entity (`CardInZone` or `SummonInstance`) within the battle.
        * `run_battle()`: Initializes, sets up Combatants, runs turn loop. [cite: 1] Emits `initial_library_state` events.
        * `add_event()`: Appends event, adding `turn`, `timestamp`, `event_id`. [cite: 1] (**TODO:** Consider adding basic validation here for presence/type of `event_type` and `instance_id`).
        * `conduct_turn()`:
            1.  **Card Play:** `CardInZone` is drawn. [cite: 1] `card_played` event logged (includes played `CardInZone`'s `instance_id`).
                * If Summon: New `SummonInstance` created (gets new `instance_id`). `summon_arrives` event logged (includes new `SummonInstance`'s `instance_id`, and `source_card_id`/`source_instance_id` if summoned by an effect). `card_moved` event (from "play" with original `CardInZone`'s `instance_id`, to "lane" with new `SummonInstance`'s `instance_id` in `to_details`).
                * If Spell: `apply_effect` called (passes the `CardInZone` of the spell). `add_card_to_graveyard` called (passes the same `CardInZone`).

## 5. Battle Event Specification

* **Purpose:** Chronological, structured log detailing all significant state changes and actions for consumption by the `BattleReplay` scene. [cite: 1]
* **Format:** `Array[Dictionary]` [cite: 1]
* **Common Properties (in each Dictionary):**
    * `event_type: String`: Identifier for the event category. [cite: 1]
    * `turn: int`: Turn number. [cite: 1]
    * `timestamp: float`: Auto-incrementing value for ordering. [cite: 1]
    * `event_id: int`: Unique sequential ID for each event. [cite: 1]
    * `instance_id: int`: The `instance_id` of the primary card/summon instance this event is about. Use `-1` if not applicable to a specific card instance (e.g., player HP change from turn start, `battle_end`).
    * `card_id: String` (Optional, but recommended if `instance_id` refers to a card/summon instance): The `CardResource.id` of the primary instance.
    * `source_card_id: String` (Optional): The `CardResource.id` of the card/effect that caused this event.
    * `source_instance_id: int` (Optional): The `instance_id` of the specific card/summon instance that caused this event. Use `-1` if not applicable.

* **Detailed Event Types:**
    * **`initial_library_state`**: Indicates initial cards in a player's library.
        * `player: String`
        * `card_ids: Array[String]` (**TODO:** Review if this should be an array of objects like `{"card_id": String, "instance_id": int}` for full tracking from turn 0).
        * `instance_id: -1` (Event is about a zone).
    * **`turn_start`**:
        * `player: String`. [cite: 1]
        * `instance_id: -1`.
    * **`mana_change`**:
        * `player: String`. [cite: 1]
        * `amount: int`. [cite: 1]
        * `new_total: int`. [cite: 1]
        * `source_card_id: String` (Optional): ID of card/effect (e.g., "turn_start", "CardID"). [cite: 1] (Was "source").
        * `instance_id: int`: `instance_id` of the card causing the change, or `-1` if generic (e.g. turn_start).
        * `source_instance_id: int` (Optional): If different from `instance_id`, or for clarity.
    * **`card_played`**:
        * `player: String`. [cite: 1]
        * `card_id: String`: ID of the card resource played. [cite: 1]
        * `instance_id: int`: `instance_id` of the `CardInZone` that was played.
        * `card_type: String`: "Spell" or "Summon". [cite: 1]
        * `remaining_mana: int`. [cite: 1]
    * **`card_moved`**: A card entity transitions between zones.
        * `player: String`. [cite: 1]
        * `card_id: String`: ID of the card resource moved. [cite: 1]
        * `instance_id: int`: `instance_id` of the card *as it existed in the `from_zone`*.
        * `from_zone: String`. [cite: 1]
        * `from_details: Dictionary` (Optional): e.g., `{"lane": int (1-based), "instance_id": int (ID in from_zone)}`, `{"position": "top" | "bottom"}`. [cite: 1]
        * `to_zone: String`. [cite: 1]
        * `to_details: Dictionary` (Optional): e.g., `{"lane": int (1-based), "instance_id": int (new ID in this zone if changed)}`, `{"position": "top" | "bottom"}`. [cite: 1]
        * `reason: String` (Optional): e.g., "play", "death", "reanimate_ReanimateCardID". [cite: 1]
        * `source_card_id: String` (Optional): Card ID of the effect/entity causing the move.
        * `source_instance_id: int` (Optional): Instance ID of the effect/entity causing the move.
    * **`card_removed`**: A card is removed from a zone (e.g., consumed from graveyard).
        * `player: String`. [cite: 1]
        * `card_id: String`: ID of the card resource removed. [cite: 1]
        * `instance_id: int`: `instance_id` of the card that was removed.
        * `from_zone: String`. [cite: 1]
        * `reason: String` (Optional): Card ID of effect causing removal. [cite: 1]
        * `source_card_id: String` (Optional).
        * `source_instance_id: int` (Optional).
    * **`summon_arrives`**: A `SummonInstance` is created and placed.
        * `player: String`. [cite: 1]
        * `card_id: String`: ID of the summon card resource. [cite: 1]
        * `instance_id: int`: Unique `instance_id` for this new summon on the field.
        * `lane: int` (1-based). [cite: 1]
        * `power: int`, `max_hp: int`, `current_hp: int`. [cite: 1]
        * `is_swift: bool`. [cite: 1]
        * `tags: Array[String]`. [cite: 1]
        * `custom_state_keys: Array[String]` (Optional): For special states like "glassgrafted".
        * `source_card_id: String` (Optional): Card ID of the spell/effect that summoned it. (Replaces `source_effect`). [cite: 1]
        * `source_instance_id: int` (Optional): Instance ID of the spell/effect.
    * **`summon_leaves_lane`**: A `SummonInstance` is removed from a lane (not standard death).
        * `player: String`. [cite: 1]
        * `card_id: String`: ID of the summon card resource. [cite: 1]
        * `instance_id: int`: `instance_id` of the summon that left.
        * `lane: int` (1-based). [cite: 1]
        * `reason: String` (e.g., "bounce_PortalMage"). [cite: 1]
        * `source_card_id: String` (Optional).
        * `source_instance_id: int` (Optional).
    * **`summon_turn_activity`**: A summon starts its action phase.
        * `player: String`. [cite: 1]
        * `card_id: String`: Card ID of the acting summon.
        * `instance_id: int`: `instance_id` of the acting summon.
        * `lane: int` (1-based). [cite: 1]
        * `activity_type: String` (e.g., "attack", "direct_attack", "ability_mana_gen"). [cite: 1]
        * `details: Dictionary` (Optional).
    * **`combat_damage`**:
        * `attacking_player: String`, `attacking_lane: int`, `attacking_card_id: String`, `attacking_instance_id: int`. [cite: 1]
        * `defending_player: String`, `defending_lane: int`, `defending_card_id: String`, `defending_instance_id: int`. [cite: 1]
        * `amount: int`. [cite: 1]
        * `defender_remaining_hp: int`. [cite: 1]
        * `instance_id: int`: `attacking_instance_id` (Attacker is primary subject).
    * **`direct_damage`**:
        * `attacking_player: String`, `attacking_lane: int`, `attacking_card_id: String`, `attacking_instance_id: int`. [cite: 1]
        * `target_player: String`. [cite: 1]
        * `amount: int`. [cite: 1]
        * `target_player_remaining_hp: int`. [cite: 1]
        * `instance_id: int`: `attacking_instance_id` (Attacker is primary subject).
    * **`effect_damage`**: Damage to a player from a non-combat card effect.
        * `source_player: String`. [cite: 1]
        * `source_card_id: String`. [cite: 1]
        * `source_instance_id: int`.
        * `target_player: String`. [cite: 1]
        * `amount: int`. [cite: 1]
        * `target_player_remaining_hp: int`. [cite: 1]
        * `instance_id: int`: `source_instance_id` (The card causing damage is primary subject).
    * **`hp_change`**: Player's main HP.
        * `player: String`. [cite: 1]
        * `amount: int`. [cite: 1]
        * `new_total: int`. [cite: 1]
        * `source_card_id: String` (Optional): Card ID of source. [cite: 1] (Was "source").
        * `instance_id: int`: Instance ID of card causing change, or `-1`.
        * `source_instance_id: int` (Optional).
    * **`creature_hp_change`**: Summon's HP.
        * `player: String` (owner). [cite: 1]
        * `lane: int`. [cite: 1]
        * `card_id: String`: Card ID of the summon.
        * `instance_id: int`: `instance_id` of the summon whose HP changed.
        * `amount: int`. [cite: 1]
        * `new_hp: int`, `new_max_hp: int`. [cite: 1]
        * `source_card_id: String` (Optional): Card ID of source. [cite: 1] (Was "source").
        * `source_instance_id: int` (Optional).
    * **`stat_change`**: Summon's Power/MaxHP.
        * `player: String` (owner). [cite: 1]
        * `lane: int`. [cite: 1]
        * `card_id: String`: Card ID of the summon.
        * `instance_id: int`: `instance_id` of the summon whose stat changed.
        * `stat: String` ("power" or "max_hp"). [cite: 1]
        * `amount: int` (modifier value). [cite: 1]
        * `new_value: int` (new calculated total). [cite: 1]
        * `source_card_id: String` (Optional): Card ID of source. [cite: 1] (Was "source").
        * `source_instance_id: int` (Optional).
    * **`status_change`**: Summon gains/loses a dynamic tag.
        * `player: String` (owner). [cite: 1]
        * `lane: int`. [cite: 1]
        * `card_id: String`: Card ID of the summon.
        * `instance_id: int`: `instance_id` of the summon.
        * `status: String`. [cite: 1]
        * `gained: bool`. [cite: 1]
        * `source_card_id: String` (Optional): Card ID of source. [cite: 1] (Was "source").
        * `source_instance_id: int` (Optional).
    * **`creature_defeated`**:
        * `player: String` (owner). [cite: 1]
        * `lane: int`. [cite: 1]
        * `card_id: String`: ID of the defeated creature's card resource. [cite: 1]
        * `instance_id: int`: `instance_id` of the summon that was defeated.
        * (**TODO:** Consider adding `source_card_id` and `source_instance_id` for what *caused* the death, if `SummonInstance.die()` is enhanced).
    * **`visual_effect`**:
        * `effect_id: String`. [cite: 1]
        * `instance_id: int`: `instance_id` of primary card instance subject/causing this visual, or `-1`.
        * `card_id: String` (Optional): Card resource ID of `instance_id` if applicable.
        * `target_locations: Array[String]`. [cite: 1]
        * `details: Dictionary` (Optional). [cite: 1]
        * `source_card_id: String` (Optional).
        * `source_instance_id: int` (Optional).
    * **`log_message`**:
        * `message: String`. [cite: 1]
        * `instance_id: int`: `instance_id` of card instance related to log, or `-1`.
        * `card_id: String` (Optional).
        * `source_card_id: String` (Optional).
        * `source_instance_id: int` (Optional).
    * **`battle_end`**:
        * `outcome: String`. [cite: 1]
        * `winner: String`. [cite: 1]
        * `instance_id: -1`.

* **Instance ID Generation:** `Battle._generate_new_card_instance_id()` is the sole source for `instance_id`s for `CardInZone` and `SummonInstance`.
* **Source Fields:** Standardized to `source_card_id` (String, `CardResource.id`) and `source_instance_id` (int, battle-specific instance ID).

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

* **Event Handlers:** Will need to utilize the richer `instance_id`, `source_card_id`, `source_instance_id`, and `*_details.instance_id` fields to accurately update visuals and trace card lineage if necessary. E.g., `handle_card_moved` will need to check `event.instance_id` for the card in `from_zone` and `event.to_details.instance_id` for its new ID in `to_zone`. [cite: 1]

## 7. Other Components (Briefly)
(No significant changes anticipated from this refactor here, but ensure `GameManager` correctly passes initial deck lists of `CardResource` to `Battle.setup()`). [cite: 1]

## 8. Testing Strategy
* **Logic (GUT):** Update tests to reflect new `CardInZone` usage in `Combatant`, new method signatures, and to assert correct `instance_id`, `source_card_id`, and `source_instance_id` values in generated events. [cite: 1]
* **Battle Replay:** Manual testing with known event sequences, verifying visual output and handling of new event fields. [cite: 1]

## 9. Constants & Configuration
(No changes from this refactor). [cite: 1]

## 10. Future Considerations / Potential Refactors
* **Event Sourcing for `creature_defeated`:** As noted in Section 5, `SummonInstance.die()` could be enhanced to accept and log the source/cause of death. [cite: 1]
* **Event Validation in `Battle.add_event()`:** Add assertions for core event fields (e.g., presence and type of `instance_id`).
* **`initial_library_state` Event:** Review if it should log an array of `{"card_id": String, "instance_id": int}` for full tracking from turn 0.
* **`Combatant.pay_mana` sourcing:** Confirm if `p_source_card_id` / `p_source_instance_id` are truly needed for its event or if `card_played` context is enough.
* **`Combatant.add_card_to_graveyard` signature:** Implement the proposed signature change `(..., p_reason_card_id: String, p_reason_instance_id: int)` in code to allow its `card_moved` event to be sourced by the ultimate cause (e.g., a spell effect or a summon's death ability).