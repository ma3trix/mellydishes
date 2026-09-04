# mellydishes

Static marketing site for **Melly Dishes** — Nigerian home cooking and catering, Ottawa ON.
Built by BIYISANDBOX STUDIOS. Private repo: `git@github.com:ma3trix/mellydishes.git`

- **Live target:** `mellydishes.com` — registered on Wix, currently **not connected to any site**
- **Client Instagram:** [@melly_dishes](https://www.instagram.com/melly_dishes/)
- **DoorDash store:** https://www.doordash.com/store/melly-dishes-ottawa-2279123

## Stack

Plain HTML + CSS. No build step, no dependencies, no framework. Deploys as-is to GitHub Pages,
Cloudflare Pages or Netlify.

```
index.html              one page: hero, menu, catering, gallery, about, order
assets/css/style.css    all styling, CSS custom properties, mobile breakpoints at 900/720px
assets/img/*.jpg        16 client photos, 1080px, sourced from her Instagram grid
CNAME                   mellydishes.com
```

## Local preview

```bash
cd ~/Developer/biyisandbox/mellydishes
python3 -m http.server 8000
open http://localhost:8000
```

## Content provenance

Every claim on the page traces to the client's own material — nothing invented:

| On the site | Source |
|---|---|
| 4.5 ★ · 20+ ratings | DoorDash store listing |
| Certified food handler · Ottawa | Instagram bio |
| Open 1:00–8:00 pm | "We are OPEN" post |
| 20% off orders over $25 | Uber Eats / DoorDash promo post |
| CA$20 jollof + peppered chicken, CA$19 fried rice, CA$5 poundo-yam | DoorDash menu |
| BigFest Toronto | Instagram highlight |
| 159 posts · 1,100+ followers | Instagram profile |

## Open items before launch

- [ ] **Uber Eats URL** — the order card points at `ubereats.com` root. Needs the direct store link. Marked with `data-todo` in `index.html`.
- [ ] **Phone / email** — not published anywhere public. Confirm with client, add to the order section and the schema.org block.
- [ ] **Suya price** — shown as "Market"; the grills prices weren't visible on DoorDash. Confirm.
- [ ] **Photo sign-off** — get written confirmation of which grid photos may be used.
- [ ] **Delivery radius / order minimum** — state it if one exists.
- [ ] **Domain** — `mellydishes.com` sits on Wix unconnected. Either point DNS at the host, or move the domain. Client controls the Wix account.

## Deploy

GitHub Pages on a **private** repo needs a paid plan. On the free tier: either flip the repo
public at launch, or deploy to **Cloudflare Pages / Netlify**, which both serve private repos free.

DNS for `mellydishes.com` → GitHub Pages:

```
A     @   185.199.108.153
A     @   185.199.109.153
A     @   185.199.110.153
A     @   185.199.111.153
CNAME www ma3trix.github.io
```

Then Settings → Pages → Source `main` / root, custom domain `mellydishes.com`, Enforce HTTPS.
