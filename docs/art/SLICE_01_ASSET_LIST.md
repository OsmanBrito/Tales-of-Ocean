# Slice 01 Asset List - Lisboa Ribeira

## Goal
Deliver a playable visual upgrade pack for:
- Lisboa Ribeira identity
- Pembah
- Joao
- one enemy archetype
- base VFX

## Runtime Target Paths
Use these target paths for integrated assets:

- `assets/portraits/pembah_portrait_v1.png`
- `assets/portraits/joao_portrait_v1.png`
- `assets/portraits/bandit_portrait_v1.png`
- `assets/characters/pembah_world_v1.png`
- `assets/characters/joao_world_v1.png`
- `assets/combat/pembah_battler_v1.png`
- `assets/combat/joao_battler_v1.png`
- `assets/combat/bandit_battler_v1.png`
- `assets/world/lisboa_ribeira_keyart_v1.png`
- `assets/world/lisboa_ribeira_tileset_v1.png`
- `assets/world/lisboa_ribeira_props_v1.png`
- `assets/vfx/vfx_pack_slice01_v1.png`
- `assets/ui/dialogue_frame_v1.png`

## Required Deliverables
1. Lisboa Ribeira key art
- 3 variants generated
- 1 selected master

2. Pembah pack
- portrait lock
- full body neutral lock
- battler stance lock

3. Joao pack
- portrait lock
- full body neutral lock
- battler stance lock

4. Bandit starter pack
- portrait
- battler

5. VFX starter board
- slash
- impact
- dust
- heal
- splash
- bleed

6. Dialogue frame concept
- left speaker slot
- large text area
- historical maritime ornament

## Naming Convention
Use this pattern:

`<subject>_<type>_v###.png`

Examples:
- `pembah_portrait_v001.png`
- `joao_battler_v001.png`
- `lisboa_ribeira_keyart_v001.png`
- `vfx_pack_slice01_v001.png`

## Technical Checks Before Import
- PNG RGBA
- transparent background for isolated characters/VFX
- clean silhouette at 25% zoom
- no watermark/text artifacts
- no era-breaking elements

## Integration Checklist (Project)
1. Add generated files under `assets/` paths listed above.
2. Set import to nearest filter for pixel-style runtime assets.
3. Wire portrait textures in UI scripts/scenes.
4. Wire battler textures in combat scene logic.
5. Replace or layer Lisbon visual assets in world scene.
6. Run quick smoke test:
- main menu
- lisboa world entry
- one combat

