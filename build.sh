#!/bin/zsh
# Construit dist/studio-silo-artifact.html : index.html avec polices et images embarquées (un seul fichier).
set -e
cd "$(dirname "$0")"
mkdir -p dist
perl -pe '
  BEGIN { use MIME::Base64;
    sub inl { my ($f,$m)=@_; open(my $h,"<",$f) or die "$f: $!"; binmode $h; local $/; my $d=<$h>; close $h; return "data:$m;base64,".encode_base64($d,""); }
    %map = (
      "assets/fonts/NeueMontreal-Regular.woff2" => inl("assets/fonts/NeueMontreal-Regular.woff2","font/woff2"),
      "assets/fonts/NeueMontreal-Italic.woff2"  => inl("assets/fonts/NeueMontreal-Italic.woff2","font/woff2"),
      "assets/fonts/NeueMontreal-Medium.woff2"  => inl("assets/fonts/NeueMontreal-Medium.woff2","font/woff2"),
      "assets/fonts/NeueMontreal-Bold.woff2"    => inl("assets/fonts/NeueMontreal-Bold.woff2","font/woff2"),
      "assets/img/perroquet-1200.webp"        => inl("assets/img/perroquet-1200.webp","image/webp"),
      "assets/img/perroquet.webp"             => inl("assets/img/perroquet.webp","image/webp"),
    );
    for my $g (glob("assets/img/gallery/*.webp"), glob("assets/img/hero-*.webp"), glob("assets/img/infirmiere-*.webp"), glob("assets/img/portrait-*.webp"), glob("assets/img/studio-*.webp"), glob("assets/img/fond-*.webp"), glob("assets/img/carte-*.webp")) { $map{$g} = inl($g, "image/webp"); }
  }
  s/^<link rel="preload"[^\n]*\n//;         # inutile quand les polices sont embarquées
  s/ srcset="[^"]*" sizes="[^"]*"//;          # une seule image embarquée (1200 px)
  for my $k (sort { length($b) <=> length($a) } keys %map) { my $q=quotemeta($k); s/$q/$map{$k}/g; }
' index.html > dist/studio-silo-artifact.html
ls -la dist/studio-silo-artifact.html

# Version « page » pour l'artefact Claude : même fichier sans doctype / html / head / body
# (l'artefact fournit lui-même cette enveloppe).
perl -0777 -CSD -Mutf8 -pe 's/^\s*<!doctype html>\s*//i; s/^\s*<html[^>]*>\s*//i; s/<\/html>\s*$//i; s/^\s*<head>\s*//i; s/\s*<\/head>\s*//i; s/<body[^>]*>\s*//i; s/\s*<\/body>\s*$//i' dist/studio-silo-artifact.html > dist/studio-silo-artifact-page.html
echo "→ dist/studio-silo-artifact-page.html ($(du -h dist/studio-silo-artifact-page.html | cut -f1))"
