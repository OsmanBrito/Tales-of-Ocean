# Tales of the Ocean - Prompt Pack v1

## Use Case
This pack covers exactly the current next 3 production goals:
1. `Lisboa Ribeira` key art direction
2. `Pembah` portrait + full body + battler
3. `Joao` portrait + full body + battler

Use this with image generators that support style/reference images and optional transparent outputs.

## 5. Ribeira Crowd Set

### Prompt
```text
Lisbon Ribeira crowd sheet, late 15th century Portuguese harbor townsfolk, sailors, merchants, dock workers, clergy, guards, fish sellers, scribes, 3/4 oblique small character set, separate isolated figures on transparent background, lively but readable silhouettes, warm maritime palette, HD-2D pixel art look
```

### Target
```text
1536x1024 PNG with transparency
```

### Must Include
```text
12 to 16 isolated NPC figures, no combat poses, everyday harbor activity
```
## Global Prompt Prefix
Use this prefix in all prompts:

```text
late 15th century Portuguese maritime fantasy, circa 1490-1505, HD-2D pixel art look, 3/4 oblique camera, semi-realistic compact proportions, warm Atlantic sunlight, historical realism with controlled stylization, readable tactical RPG silhouettes, coherent world and battle visual language, game-ready
```

## Global Negative Prompt
Use this negative block in all prompts:

```text
chibi, super deformed proportions, modern clothing, steampunk, neon sci-fi glow, dark grim palette, generic medieval village symmetry, blurry face, extra fingers, extra limbs, cropped feet, heavy armor fantasy pauldrons, text, logo, watermark
```

## Output Targets
- Portrait generation: `1024x1536`, PNG
- Full body concept: `1024x1024`, PNG
- Battler concept: `1024x1024`, PNG
- Key environment art: `1536x1024` or `1792x1024`, PNG
- Prefer transparent background for isolated characters

## Generator Notes
- Always generate 4 variations per prompt, then pick the best one for edit/refine.
- Keep subject consistency by reusing the best prior image as reference for the next stage.
- Do not request final sprite sheet yet; only key art and locked character views.

## 1) Lisboa Ribeira Key Art
### Prompt A - Wide district identity
```text
Lisbon Ribeira district at peak maritime activity, major Atlantic trade and navigation center, clear transition from sea to sand edge to stone quay to dense whitewashed urban blocks, terracotta roofs, dock planks, ropes, barrels, crates, market awnings, sailors, merchants, clerics, guards, chart tables and navigation tools, sunlit atmosphere, lively but readable composition, no text
```

### Prompt B - Port market readability
```text
oblique view of Lisbon harbor marketplace, bright solar Atlantic palette, ships moored on timber docks, cargo handling zones, fish and rope stalls, cloth shades, irregular but legible street flow, historical Portuguese architecture and materials, scene clarity first, no text
```

### Prompt C - Combat-friendly dock zone
```text
tactical RPG friendly dock plaza in Lisbon Ribeira, 3/4 oblique composition with readable walkable stone terraces and dock levels, water edges, steps, cargo props, clear combat sight lines, historical maritime details, no text
```

## 2) Pembah (Portrait, Full Body, Battler)
### Prompt A - Portrait lock
```text
Pembah portrait, age 19, black hair, fair Portuguese skin, heterochromia with one light blue eye and one brown eye, humble origin but resolute expression, deep blue tunic, worn burgundy shoulder cloth, leather straps, practical seafaring attire, youthful and resilient face, no background, no text
```

### Prompt B - Full body neutral
```text
Pembah full body reference, 19 year old Portuguese navigator, black hair, fair skin, heterochromia visible, sword at hip, deep blue tunic, worn burgundy shoulder cloth, brown leather belts and boots, practical traveler silhouette, neutral standing pose, transparent background, no text
```

### Prompt C - Battler stance
```text
Pembah full body combat battler, tactical RPG 3/4 oblique stance, sword drawn, grounded and elegant posture, same face and same costume as character reference, readable silhouette and hand placement, transparent background, no text
```

## 3) Joao (Portrait, Full Body, Battler)
### Prompt A - Portrait lock
```text
Joao portrait, age 20, young noble and devout warrior linked to Order of Christ, upright composed expression, fair Iberian skin, dark blond to light brown hair, off-white and ivory garments with red cross symbol, brown leather straps, austere noble look, no background, no text
```

### Prompt B - Full body neutral
```text
Joao full body reference, 20 year old noble-devout spear warrior, upright disciplined silhouette, long spear, white/off-white historical garments with red cross emblem, travel cloak and brown leather gear, restrained period elegance, neutral standing pose, transparent background, no text
```

### Prompt C - Battler stance
```text
Joao full body combat battler, tactical RPG 3/4 oblique stance with long spear, disciplined guard posture, same face and same costume as reference, readable silhouette, historical maritime-Order aesthetic, transparent background, no text
```

## Optional Add-on Prompts (if needed in same run)
### Bandit portrait
```text
bandit scout portrait, rough late 15th century roadside raider, worn hooded clothing, dirt and salt-weathered fabrics, lean threatening expression, earthy palette, no background, no text
```

### Bandit battler
```text
bandit scout full body battler, tactical RPG 3/4 oblique stance, light blade, ragged hooded clothing, grounded mobility-focused silhouette, transparent background, no text
```

### VFX starter board
```text
tactical RPG VFX board, clean elegant style, slash arc, hit spark, dust burst, guard shimmer, heal pillar, water splash, bleed hit mark, transparent background, no text
```

## Acceptance Checklist For Each Generated Asset
- Subject is readable at small scale
- Lighting matches upper-left warm daylight
- No modern objects or wrong era cues
- Character proportions match semi-realistic compact rule
- Palette matches solar Atlantic base
- No watermark/text/logo artifacts

