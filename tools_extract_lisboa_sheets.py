from PIL import Image
from collections import deque
import math, json, os

SHEETS = {
    'buildings': 'assets/world/lisboa_ribeira_buildings_sheet_v1.png',
    'quay': 'assets/world/lisboa_ribeira_quay_tiles_v1.png',
    'props': 'assets/world/lisboa_ribeira_harbor_props_v1.png',
    'ships': 'assets/world/lisboa_ribeira_ships_v1.png',
    'crowd': 'assets/world/lisboa_ribeira_crowd_v1.png',
}
OUT_DIR = 'assets/world/extracted'
META_PATH = 'assets/world/extracted/lisboa_sheet_meta.json'
os.makedirs(OUT_DIR, exist_ok=True)

def dist(a,b):
    return math.sqrt(sum((a[i]-b[i])**2 for i in range(3)))

def remove_bg(path):
    img = Image.open(path).convert('RGBA')
    w,h = img.size
    pix = img.load()
    visited = [[False]*w for _ in range(h)]
    bg = [[False]*w for _ in range(h)]
    q = deque()
    for x in range(w):
        q.append((x,0)); q.append((x,h-1))
    for y in range(h):
        q.append((0,y)); q.append((w-1,y))
    while q:
        x,y = q.popleft()
        if visited[y][x]:
            continue
        visited[y][x] = True
        p = pix[x,y]
        bg[y][x] = True
        for nx,ny in ((x+1,y),(x-1,y),(x,y+1),(x,y-1)):
            if 0 <= nx < w and 0 <= ny < h and not visited[ny][nx]:
                n = pix[nx,ny]
                d = dist(p,n)
                lum = (n[0]+n[1]+n[2])/3
                sat = max(n[:3]) - min(n[:3])
                if d <= 24 or (d <= 36 and sat < 65) or (lum < 55 and sat < 60):
                    q.append((nx,ny))
    out = img.copy()
    op = out.load()
    for y in range(h):
        for x in range(w):
            if bg[y][x]:
                op[x,y] = (op[x,y][0], op[x,y][1], op[x,y][2], 0)
            else:
                bg_neighbors = 0
                total = 0
                for ny in range(max(0,y-1), min(h,y+2)):
                    for nx in range(max(0,x-1), min(w,x+2)):
                        if nx == x and ny == y:
                            continue
                        total += 1
                        if bg[ny][nx]:
                            bg_neighbors += 1
                if bg_neighbors >= max(2, total//2):
                    a = max(0, op[x,y][3] - 48)
                    op[x,y] = (op[x,y][0], op[x,y][1], op[x,y][2], a)
    return out

def components(img, min_pixels=500):
    w,h = img.size
    pix = img.load()
    visited = [[False]*w for _ in range(h)]
    boxes = []
    for y in range(h):
        for x in range(w):
            if visited[y][x]:
                continue
            visited[y][x] = True
            if pix[x,y][3] < 16:
                continue
            q = deque([(x,y)])
            minx=maxx=x
            miny=maxy=y
            count=0
            while q:
                cx,cy = q.popleft()
                count += 1
                minx=min(minx,cx); maxx=max(maxx,cx)
                miny=min(miny,cy); maxy=max(maxy,cy)
                for nx,ny in ((cx+1,cy),(cx-1,cy),(cx,cy+1),(cx,cy-1)):
                    if 0 <= nx < w and 0 <= ny < h and not visited[ny][nx]:
                        visited[ny][nx] = True
                        if pix[nx,ny][3] >= 16:
                            q.append((nx,ny))
            if count >= min_pixels:
                boxes.append({'x':minx,'y':miny,'w':maxx-minx+1,'h':maxy-miny+1,'pixels':count})
    boxes.sort(key=lambda b:(b['y'],b['x']))
    return boxes

meta = {}
for key,path in SHEETS.items():
    cleaned = remove_bg(path)
    out_path = os.path.join(OUT_DIR, f'{key}_clean.png')
    cleaned.save(out_path)
    meta[key] = components(cleaned)
    print(key, len(meta[key]))
    for i,b in enumerate(meta[key][:20]):
        print(' ', i, b)
with open(META_PATH,'w') as f:
    json.dump(meta,f,indent=2)
print('meta written', META_PATH)
