# Mettre le site en ligne

Le site est un seul fichier `index.html` avec ses ressources dans `assets/`. Rien à installer, rien à compiler.

## Qui sert le site

**Vercel**, pas GitHub Pages — le dépôt GitHub sert uniquement de source. Vercel le surveille : chaque `git push` déclenche une mise en ligne, prête en une à deux minutes.

L'adresse servie est **`https://www.studiosilo.fr`**. L'apex `studiosilo.fr` redirige dessus (308). Toutes les métadonnées du site (canonical, og:url, JSON-LD, sitemap) pointent sur la version `www` : c'est l'adresse réelle, il ne faut pas la remettre sur l'apex.

DNS (chez Squarespace) : `studiosilo.fr` → A `216.198.79.1`, `www` → CNAME `cname.vercel-dns.com`.

## Publier une nouvelle version

Le site de référence reste dans le Drive (`Claude Code/Website v1`). Pour publier :

```bash
~/Sites/studiosilo/publier.sh "Ce qui a changé"
```

Le script recopie les fichiers du Drive vers le dépôt, enregistre une version et la pousse. **Donnez-lui toujours un message** : sans argument il écrit « Mise à jour du site », qui ne dit rien six mois plus tard.

## Les fichiers de configuration

### `vercel.json` — en-têtes de sécurité et de cache

Envoyé avec chaque réponse. Deux rôles.

**Sécurité.** `Content-Security-Policy` (le navigateur refuse tout script, style, image, police ou requête venant d'ailleurs que du site), `X-Frame-Options: DENY` et `frame-ancestors 'none'` (le site ne peut pas être encadré dans une autre page), `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy` (caméra, micro, position… refusés), `Strict-Transport-Security`.

> **Si vous ajoutez un service tiers** (mesure d'audience, vidéo hébergée ailleurs, prise de rendez-vous en iframe), il sera **bloqué** tant que son domaine n'est pas ajouté à la bonne directive : `connect-src` pour un appel réseau, `media-src` pour une vidéo, `frame-src` pour une iframe, `script-src` pour un script. C'est voulu : rien n'entre sans décision.

**Cache.** Les polices sont mises en cache un an (`immutable` : elles ne changent jamais). Les images sont fraîches un jour, puis servies telles quelles pendant une semaine le temps d'être revérifiées en arrière-plan. Sans ces règles, Vercel demandait au navigateur de revalider **chaque image et chaque police à chaque visite**.

> **Conséquence à connaître :** si vous remplacez une image **en gardant le même nom**, les visiteurs déjà venus peuvent voir l'ancienne pendant quelques jours. Changez le nom du fichier (`carte-support-2.webp`) quand le contenu change vraiment.

### `.vercelignore` — ce qui ne part pas sur le serveur

Vercel sert à la racine tout ce qu'il reçoit : sans cette liste, `studiosilo.fr/publier.sh` renvoyait le script de publication, chemins locaux compris. Y figurent `build.sh`, `publier.sh`, `chat-worker.js`, `DEPLOIEMENT.md`, `README.md`.

### `.gitignore` — ce qui ne part pas sur GitHub

Les dossiers de travail (`Sources plans`, `ref`, `dist`, `Logo`, `Neue Montreal`), et les doublons JPEG des images WebP : depuis le passage au WebP, plus rien ne les référence. Les originaux restent dans le Drive.

### `404.html`

Page d'erreur aux couleurs du site, servie automatiquement par Vercel sur une adresse inconnue.

### `.well-known/security.txt`

Dit où signaler une faille (RFC 9116). **Contient une date d'expiration** : à repousser une fois par an, sinon le fichier n'est plus considéré comme valide.

## Fabriquer l'artefact d'un seul fichier

```bash
./build.sh
```

Produit `dist/studio-silo-artifact.html` : le site entier avec polices, images et base de connaissance embarquées en base64. Sert à montrer le site sans serveur.

Deux pièges quand vous modifiez `index.html` :

- `build.sh` remplace **toutes** les occurrences d'un chemin de ressource par son contenu encodé. N'écrivez jamais un chemin comme `assets/…` dans un commentaire : il serait remplacé lui aussi, et l'artefact gonflerait d'autant.
- Toute nouvelle image doit entrer dans l'un des motifs listés dans `build.sh`, sinon elle manquera dans l'artefact.

## À faire côté DNS (pas encore fait)

- **DMARC.** SPF et DKIM sont en place, mais il n'y a aucun enregistrement `_dmarc`. Sans lui, n'importe qui peut écrire des courriels signés `@studiosilo.fr` sans qu'aucune messagerie n'ait de consigne. Créer chez Squarespace un TXT sur `_dmarc.studiosilo.fr` :
  `v=DMARC1; p=none; rua=mailto:schmidt.basile@studiosilo.fr; adkim=r; aspf=r`
  Commencer par `p=none` (on observe, rien n'est rejeté), puis passer à `p=quarantine` après quelques semaines de rapports sans anomalie.
- **CAA** (facultatif). Un enregistrement CAA sur `studiosilo.fr` limite les autorités qui peuvent émettre un certificat pour le domaine : `0 issue "letsencrypt.org"` (Vercel) — à vérifier avant, un CAA trop strict empêche le renouvellement.

## À savoir

- Le dépôt est public : les polices Neue Montreal (`assets/fonts`) y sont visibles. Vérifier que la licence Pangram Pangram couvre l'usage web ; sinon passer le dépôt en privé (Vercel sait déployer un dépôt privé).
- EB Garamond est servie par le site (licence OFL, texte dans `assets/fonts/EBGaramond-OFL.txt`) : plus aucune requête vers Google Fonts, donc plus aucune adresse IP de visiteur transmise à un tiers.
- Les images sources et les plans originaux restent dans le Drive.
