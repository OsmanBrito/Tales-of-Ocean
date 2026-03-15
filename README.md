# Tales of the Ocean MVP

This repository contains a Godot 4 vertical slice for **Tales of the Ocean** based on the provided game design document.

## Included in this MVP

- Main menu with `Novo Jogo` and `Continuar`
- Lisboa exploration with WASD movement
- Reusable interaction system driven by JSON for NPCs, dialogues, and encounters
- Captain Duarte quest dialogue in Portuguese (PT-PT tone)
- One combat encounter against a bandit scout
- Inventory panel
- Pause menu with save/load
- Data-driven JSON files for items, skills, enemies, quests, and world interactions

## Controls

- `WASD`: Move
- `E`: Interact
- `I`: Toggle inventory
- `ESC`: Pause menu

## Project Structure

- `scenes/`: UI, world, and combat scenes
- `scripts/`: gameplay logic and autoloads
- `data/`: JSON definitions for content
- `assets/`: placeholder project icon

## Run

Open the folder in Godot 4.5+ and run the main scene, or use:

```bash
HOME="$PWD" /Applications/Godot.app/Contents/MacOS/Godot --path "$PWD"
```

Using `HOME="$PWD"` helps keep Godot's writable `user://` data inside the project when running from a restricted environment.
