# Slice 01 Import Map (Applied)

This file records how the latest generated images were mapped into runtime assets.

## Runtime Assets
- `assets/world/lisboa_ribeira_keyart_v1.png`
- `assets/world/lisboa_ribeira_keyart_alt_combat_v1.png`
- `assets/world/lisboa_ribeira_tileset_v1.png`
- `assets/world/lisboa_ribeira_props_v1.png`
- `assets/world/lisboa_ribeira_buildings_sheet_v1.png`
- `assets/world/lisboa_ribeira_quay_tiles_v1.png`
- `assets/world/lisboa_ribeira_harbor_props_v1.png`
- `assets/world/lisboa_ribeira_ships_v1.png`
- `assets/world/lisboa_ribeira_crowd_v1.png`
- `assets/world/extracted/buildings_clean.png`
- `assets/world/extracted/quay_clean.png`
- `assets/world/extracted/props_clean.png`
- `assets/world/extracted/ships_clean.png`
- `assets/world/extracted/crowd_clean.png`
- `assets/portraits/pembah_portrait_v1.png`
- `assets/characters/pembah_world_v1.png`
- `assets/combat/pembah_battler_v1.png`
- `assets/portraits/joao_portrait_v1.png`
- `assets/characters/joao_world_v1.png`
- `assets/combat/joao_battler_v1.png`
- `assets/portraits/bandit_portrait_v1.png`
- `assets/combat/bandit_battler_v1.png`
- `assets/vfx/vfx_pack_slice01_v1.png`
- `assets/ui/dialogue_frame_v1.png`

## Source Backups
The same approved assets were copied into:
- `source_art/characters/pembah/`
- `source_art/characters/joao/`
- `source_art/enemies/bandit/`
- `source_art/tiles/lisboa_ribeira/`
- `source_art/vfx/`
- `source_art/ui/`

## Notes
- `lisboa_ribeira_tileset_v1.png` and `lisboa_ribeira_props_v1.png` are now distinct crops from the same master board:
  - tileset crop: `960x960` (terrain and dock floor focus)
  - props crop: `900x900` (props and set-dressing focus)
- The Ribeira modular pass now also includes dedicated sheets for:
  - buildings and gate silhouettes
  - quay/ground tiles
  - harbor props and stalls
  - ships and dock modules
  - crowd life / port workers
- A cleanup pass now removes the generated sheet background before runtime composition:
  - tool: `tools_extract_lisboa_sheets.py`
  - metadata: `assets/world/extracted/lisboa_sheet_meta.json`
- Existing SVG assets remain as fallback in scripts for safety.
