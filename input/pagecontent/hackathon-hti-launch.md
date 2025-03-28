## 🧰 Technisch Stappenplan: HTI Launch Flow (Platform = Welldata)

---

### 🔑 1. **Genereer Keypair**
- Genereer een **asymmetrisch keypair** (RSA of EC), bijvoorbeeld via:
  ```bash
  openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048
  openssl rsa -pubout -in private.pem -out public.pem
  ```
- Dit keypair wordt gebruikt om **JWTs te ondertekenen** bij het starten van de launch.

---

### 🌐 2. **Publiceer OpenID Config + JWKS**
- Maak een `.well-known/openid-configuration` endpoint aan op je platform base URL (bijv. `https://myplatform.example/.well-known/openid-configuration`) met:
  ```json
  {
    "issuer": "https://myplatform.example",
    "jwks_uri": "https://myplatform.example/.well-known/jwks.json"
  }
  ```
- Zorg dat `jwks_uri` een geldig JWKS bevat met je publieke sleutel:
  - Gebruik bijv. [mkjwk.org](https://mkjwk.org/) of een tool als `jose` om dit JSON formaat te genereren.

---

### 🚀 3. **Prepareer de Launch (JWT genereren)**
Stel een JWT samen met minimaal deze claims:

| Claim       | Waarde / Uitleg                                        |
|-------------|---------------------------------------------------------|
| `sub`       | WebID van de gebruiker (bv. `https://solid.example/user#me`) |
| `resource`  | De instantie waar het om gaat (bv. een specifieke patiënt of casus) |
| `definition`| De module die gelanceerd wordt (bv. `https://modules.gids.org/selfcare`) |
| `aud`       | De URL van het doelplatform dat deze JWT moet accepteren |
| `iss`       | Je eigen issuer base URL (bv. `https://myplatform.example`) |
| `exp`       | Expiratietijd (kort, bv. 5 min)                         |

➡️ JWT wordt gesigned met je private key.

---

### 📤 4. **Redirect de gebruiker via een HTML form**
- Maak een auto-submitting HTML form met de JWT als POST parameter:
```html
<form method="post" action="https://target-module.example/launch" id="htiLaunch">
  <input type="hidden" name="launch_token" value="eyJhbGciOi...">
</form>
<script>document.getElementById('htiLaunch').submit();</script>
```

---

### 📥 5. **Ontvangen van Launch (in de module)**

- De module ontvangt `launch_token` als POST.
- Valideer JWT:
  1. Parse de `iss` uit de token.
  2. Haal de publieke sleutel op via: `GET https://<issuer>/.well-known/openid-configuration` → `jwks_uri`.
  3. Gebruik de JWKS om de JWT te valideren.

---

### 🔓 6. **Start toegang tot de POD**

- Gebruik `sub` (WebID) als sleutel voor toegang tot de data van de gebruiker.
- Indien Solid+UMA:
  - Vraag een **Access Grant** op basis van de WebID en resource.
  - Gebruik de Grant om te lezen/schrijven via de POD APIs.

---

Laat me weten of je dit stappenplan ook als slide deck of visueel diagram wil!
