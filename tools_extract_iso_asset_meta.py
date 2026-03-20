from PIL import Image
from collections import deque
import json, os

SHEETS = {
    'ground': 'assets/world/iso/lisboa_ribeira_ground_v2_iso.png',
    'buildings': 'assets/world/iso/lisboa_ribeira_buildings_v2_iso.png',
    'harbor_props': 'assets/world/iso/lisboa_ribeira_harbor_props_v2_iso.png',
    'ships': 'assets/world/iso/lisboa_ribeira_ships_v2_iso.png',
    'crowd': 'assets/world/iso/lisboa_ribeira_crowd_v2_iso.png',
    'battle_grid': 'assets/world/iso/battle_grid_v2_iso.png',
}
OUT_PATH = 'assets/world/iso/iso_asset_meta_v2.json'


def components(path, min_pixels=120):
    img = Image.open(path).convert('RGBA')
    w, h = img.size
    pix = img.load()
    visited = [[False] * w for _ in range(h)]
    boxes = []
    for y in range(h):
        for x in range(w):
            if visited[y][x]:
                continue
            visited[y][x] = True
            if pix[x, y][3] < 12:
                continue
            q = deque([(x, y)])
            minx = maxx = x
            miny = maxy = y
            count = 0
            while q:
                cx, cy = q.popleft()
                count += 1
                minx = min(minx, cx)
                maxx = max(maxx, cx)
                miny = min(miny, cy)
                maxy = max(maxy, cy)
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < w and 0 <= ny < h and not visited[ny][nx]:
                        visited[ny][nx] = True
                        if pix[nx, ny][3] >= 12:
                            q.append((nx, ny))
            if count >= min_pixels:
                boxes.append({'x': minx, 'y': miny, 'w': maxx - minx + 1, 'h': maxy - miny + 1, 'pixels': count})
    boxes.sort(key=lambda b: (b['y'], b['x']))
    return boxes

meta = {}
for key, path in SHEETS.items():
    if os.path.exists(path):
        meta[key] = components(path)
        print('\n', key, len(meta[key]))
        for i, box in enumerate(meta[key][:30]):
            print(i, box)
with open(OUT_PATH, 'w') as fh:
    json.dump(meta, fh, indent=2)
print('\nwritten', OUT_PATH)
