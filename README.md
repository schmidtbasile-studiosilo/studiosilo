# Studio Silo — site one page

## Fichiers
- `index.html` — le site complet (HTML, CSS, JS). Aucune dépendance de build.
- `assets/fonts/` — Neue Montreal (Regular, Italic, Medium, Bold). Vérifiez votre licence web Pangram Pangram avant mise en ligne publique.
- `assets/img/` — logo officiel (SVG et PNG), perroquets en filigrane derrière « Le quotidien » (deux images, deux tailles), photo du studio derrière « Derrière Studio Silo », image de partage `og-studiosilo.jpg` (1200 × 630).
- `chat-worker.js` — proxy Cloudflare Worker pour l'assistant IA (clé API côté serveur).
- `build.sh` — génère `dist/studio-silo-artifact.html`, version « un seul fichier » (polices et images embarquées) pour partage ou prévisualisation.

## Mise en ligne
1. Déposez `index.html` et `assets/` à la racine de `https://studiosilo.fr/` (Netlify, Vercel, OVH, o2switch…). Les balises `canonical`, Open Graph et JSON-LD pointent vers cette racine ; adaptez-les si le site vit ailleurs.
2. Ouvrez `index.html` et renseignez `window.SILO_CONFIG` :
   - `bookingUrl` : lien Cal.com / Calendly → affiche le bouton « Choisir un créneau ».
   - `formEndpoint` : endpoint de formulaire (Formspree, Netlify Forms, votre API). Sans lui, le formulaire ouvre la messagerie du visiteur avec la demande pré-remplie.
   - `chatEndpoint` : URL du worker (voir `chat-worker.js`). Sans lui, l'assistant répond en « mode guidé » (réponses issues des dossiers, sans IA générative).
3. Les mentions légales : remplacez le lien `#` (id `legal-link`) par votre page.
4. Photo de fond de la section « Derrière Studio Silo » : `assets/img/studio-schmidt.jpg` et `studio-schmidt-1200.jpg` (16:9, affichée en filigrane, Schmidt cadré à droite via `object-position`) ; remplacez les deux fichiers pour changer la photo. `portrait-schmidt-basile.jpg` ne sert plus qu’aux données structurées.

## Performance
- Pas de framework, une seule requête HTML, polices locales préchargées, image responsive, panneaux recouverts non dessinés (au plus deux ou trois couches actives), effets désactivés avec `prefers-reduced-motion`.
- Pour aller plus loin : convertir les OTF en WOFF2 (environ 40 % plus légers) et servir le site en HTTP/2 avec compression Brotli ou gzip.

## Personnalisation
- Accueil : la photo de fond est `assets/img/hero-silo-2400.jpg` (et `-1200.jpg` pour les petits écrans), teinte kraft harmonisée depuis « Sources plans/silo background hero.png » (image étalonnée par Schmidt ; CoreImage : monochrome #CFB498 à 50 %, saturation 1,12, contraste 1,02, exposition +0,55 EV, gamma 0,9). Pour la changer, remplacez ces deux fichiers (JPEG, ratio 3:2 environ, 2400 px de large) ; le logo, la tagline et le bouton « Explorer » restent centrés par-dessus.
- Carte « Chez vous » (`#intro`) : la question en titre, la phrase manifeste en chapeau (elle s’adapte au parcours choisi) et les cinq parcours en cartes avec leur description (textes dans le HTML de la section, à garder cohérents avec `SILO.parcours`).
- Réalisations confidentielles : bloc « Vous voulez voir nos réalisations ? » sous la grille de plans, avec un bouton qui pré-remplit le formulaire (« Je souhaite voir des extraits… ») et un lien e-mail ; la FAQ du chat (`SILO.faq`, première entrée) et la base `SILO.kb` répondent aussi à « où sont vos réalisations ? ».
- Plans arrêtés (section « Derrière Studio Silo », bloc « La qualité comme signature ») : déposez vos captures dans `assets/img/gallery/` (JPEG, 1600 px de large suffisent) et renseignez `SILO.gallery` dans `index.html` : `src`, `w` et `h` (dimensions en pixels, elles fixent le ratio), `tag` (parcours) et `alt` (description). Un `src` vide affiche un emplacement. Les tuiles se répartissent en rangées justifiées ; un clic ouvre le plan en grand.
- Question d'entrée : le choix du parcours est mémorisé (localStorage) et adapte titre, journée type (frise « aujourd’hui » `day` et frise « colmatée » `dayAfter` dans `SILO.parcours`), calculette, chiffres, matrice, formulaire et assistant.
- Chiffres : `SILO.stats` dans `index.html` — chaque entrée porte `big`, `claim`, `scope`, `source`, `url`, `strength`, `parcours`.
- Base de connaissance de l'assistant : `SILO.kb` (texte) et `SILO.faq` (mode guidé).
