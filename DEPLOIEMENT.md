# Mettre le site en ligne sur GitHub Pages

Le site est un seul fichier `index.html` avec ses ressources dans `assets/`. Il n'y a rien à installer ni à compiler : GitHub Pages sert ces fichiers tels quels.

## Ce qui part sur GitHub

- `index.html`, `assets/` (polices, images), `chat-worker.js`, `build.sh`, `README.md`, `DEPLOIEMENT.md`
- `.nojekyll` (dit à GitHub de servir les fichiers sans traitement)
- `.gitignore` (exclut les dossiers de travail : `Sources plans`, `ref`, `dist`, `Logo`, `Neue Montreal`)

## Première mise en ligne (une seule fois)

Un dépôt local prêt à pousser a été préparé dans `~/Sites/studiosilo` (hors de Google Drive, qui s'entend mal avec Git). Son contenu est une copie des fichiers ci-dessus, déjà validée (commit) et reliée à `https://github.com/schmidtbasile-studiosilo/studiosilo.git`.

Deux façons de pousser, au choix.

### A. Avec GitHub Desktop (le plus simple)

1. Installez GitHub Desktop (desktop.github.com) et connectez-vous à votre compte.
2. Menu **File → Add Local Repository…**, choisissez le dossier `~/Sites/studiosilo`.
3. Cliquez **Publish repository** (ou **Push origin**). Gardez le nom `studiosilo`.

### B. Dans le Terminal

```bash
cd ~/Sites/studiosilo && git push -u origin main
```

GitHub demande un identifiant et un mot de passe : le mot de passe est un **jeton** (Personal Access Token), pas le mot de passe du compte. Pour le créer : GitHub → photo de profil → **Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token**, cocher `repo`, copier le jeton et le coller à la place du mot de passe.

## Activer GitHub Pages

1. Sur github.com, ouvrez le dépôt `studiosilo` → **Settings → Pages**.
2. Dans **Build and deployment**, source : **Deploy from a branch**, branche `main`, dossier `/ (root)`. Enregistrez.
3. Après une à deux minutes, le site est en ligne à `https://schmidtbasile-studiosilo.github.io/studiosilo/`.

## Mettre à jour le site ensuite

Le site de référence reste dans le Drive (`Claude Code/Website v1`). Pour publier une nouvelle version :

```bash
~/Sites/studiosilo/publier.sh "Ce qui a changé"
```

Le script recopie les fichiers du Drive vers le dépôt, enregistre une version et la pousse. Le site se met à jour tout seul en une ou deux minutes.

## Nom de domaine studiosilo.fr (plus tard)

Dans **Settings → Pages → Custom domain**, saisir `studiosilo.fr`, puis chez le registrar créer les enregistrements DNS indiqués par GitHub (quatre A vers les adresses de GitHub Pages et un CNAME `www`). Cocher **Enforce HTTPS** une fois le certificat émis.

## À savoir

- Un dépôt public rend visibles tous les fichiers, y compris les polices Neue Montreal (`assets/fonts`). Vérifiez que votre licence Pangram Pangram autorise cet usage web ; sinon, passez le dépôt en privé (GitHub Pages sur dépôt privé nécessite un abonnement) ou hébergez ailleurs.
- Les images sources et les plans originaux ne sont pas envoyés (dossiers exclus) : ils restent dans le Drive.
