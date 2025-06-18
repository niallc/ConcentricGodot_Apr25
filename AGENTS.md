# AGENTS.md

## Project Description

This is a Godot 4.x project written in GDScript.  
It implements a turn-based deterministic deck-building auto-battler, focused on:
- Core battle simulation logic
- Event-driven battle replay system
- Card definitions and effects
- For project details consult SPECIFICATION.md

## Tasks You May Perform

You may:
- Refactor and improve GDScript code
- Improve readability, comments, and documentation
- Improve code style consistency
- Apply consistent style to card effect scripts (`res://logic/card_effects/`)
- Improve replay scene visuals (UI code only, not gameplay logic)
- Add helper functions for clarity or maintainability

## Tasks You Must Not Perform

You must not:
- Attempt to install or run Godot Engine
- Attempt to run tests (GUT is present but not configured for this environment)
- Attempt to launch the game or scenes
- Modify `.import/` directories or any generated binary resources
- Modify asset paths or artwork files
(as the relevant Godot binaries are not installed)

## Coding Conventions

Follow these conventions:
- Tabs-only for indentation in `.gd` files
- No chat suffixes, markdown citations, or `//` comments in GDScript code
- Prefer static typing and type hints where practical
- Follow existing naming conventions in the project
