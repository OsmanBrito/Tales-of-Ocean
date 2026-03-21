# Tales of the Ocean - Art Bible v1

## Scope
This v1 locks the first production slice:
- `Lisboa Ribeira` key art direction
- `Pembah` portrait + full body + battler direction
- `Joao` portrait + full body + battler direction

This document is optimized for:
- low cost
- fast production
- consistent visual language between world and combat

## Era And Tone
- Historical anchor: `c. 1490-1505` (Portuguese maritime expansion period)
- Tone words: `Solar`, `Maritimo`, `Historico`, `Epico`
- Style: historical realism with controlled stylization

## Locked Visual Decisions
- Style: `HD-2D pixel art look`
- Camera: `3/4 oblique`
- World and combat: same visual language
- Hero map directions: `4 directions`
- Combat units: `full battlers` (not icon tokens)
- Hero scale: `semi-realistic compact`
- Animation: clean and elegant (not exaggerated)
- UI: hybrid (readable modern layout + historical skin)
- City production: modular tiles + reusable props

## Lisbon Identity (Core Rule)
Lisbon must feel like a living maritime-scientific capital in rise:
- active docks, trade, rope, crates, sails, timber and stone wear
- transition read is clear: sea -> sand/edge -> quay -> urban core
- social density: sailors, merchants, clergy, guards, craft workers
- signs of maritime knowledge: charts, tools, navigation objects

Avoid:
- over-symmetric streets
- sterile plazas with no cargo traces
- generic fantasy medieval village look

## Palette (Solar Atlantic Base)
- Warm stone: `#D9C8A8`
- Lime white plaster: `#E8DEC8`
- Terracotta roof: `#A86645`
- Salt wood: `#775238`
- Linen canvas: `#D7C59B`
- Atlantic blue: `#2D677A`
- Deep sea blue: `#183C4E`
- Coastal green: `#71845D`
- Warm shadow: `#3D2B22`
- Gold accent: `#E1BB63`

Lighting:
- key light from upper-left
- warm daylight, medium contrast
- short soft shadows, no cold gray wash

## Materials
Primary:
- light stone
- salt-worn timber
- linen/canvas

Secondary:
- rope
- darkened iron
- bronze accents
- brown leather

## Character Locks
### Pembah
- Age: 19
- Hair: black
- Skin: fair Portuguese
- Weapon: sword
- Core identity: humble origin, spiritual ambition, explorer destiny
- Mandatory feature: heterochromia (one light blue eye, one brown eye)

Visual read:
- practical traveler garments, not noble courtwear
- worn burgundy shoulder cloth + deep blue tunic + leather straps
- youthful but resilient expression

### Joao
- Age: 20
- Role: noble/devout youth linked to Order of Christ
- Weapon: long spear
- Silhouette: upright, disciplined, more vertical than Pembah
- Garment direction: noble but austere period clothing, white/off-white with red cross symbol and brown leather

Visual read:
- honorable, composed, devout
- noble restraint over flamboyance

## Historical Guardrail (Weapons)
- Keep period coherence for `1490-1505`
- Prefer swords, spears, polearms, and matchlock-era hints only if needed
- Do not use classic flintlock look for this slice

## Animation Language
World:
- idle breath, short walk cadence, clear interaction pose

Combat:
- grounded guard, short committed steps, clean attack arcs
- clarity first, spectacle second

No rubbery squash/stretch style.

## Technical Output Spec (v1)
- Runtime internal target recommendation: `960x540`, scale to `1920x1080`
- Final runtime sprite format: `PNG RGBA`
- Keep `SVG` for icons/UI only
- Character frame targets:
  - world: `96x96`
  - battler: `160x160`
  - bosses later: `224x224` or `256x256`
- Keep 2-4 px transparent padding around each frame in sheets

## Godot Integration Guardrail
- Import filter for pixel assets: `Nearest`
- Mipmaps: off for characters/UI assets
- Keep stable pivots:
  - world sprites at foot center
  - battlers at ground contact center

## Slice 01 Success Criteria
The slice is approved when:
- Lisbon reads instantly as historical coastal trade hub
- Pembah and Joao are recognizable at first glance in both portrait and battler view
- world/combat style feels from the same game
- composition is clear on first read without visual noise
