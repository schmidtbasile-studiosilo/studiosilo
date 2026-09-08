#!/bin/zsh
# Construit dist/studio-silo-artifact.html : index.html avec polices et images embarquées (un seul fichier).
set -e
cd "$(dirname "$0")"
mkdir -p dist
perl -pe '
  BEGIN { use MIME::Base64;
    sub inl { my ($f,$m)=@_; open(my $h,"<",$f) or die "$f: $!"; binmode $h; local $/; my $d=<$h>; close $h; return "data:$m;base64,".encode_base64($d,""); }
    %map = (
      "assets/fonts/NeueMontreal-Regular.otf" => inl("assets/fonts/NeueMontreal-Regular.otf","font/otf"),
      "assets/fonts/NeueMontreal-Italic.otf"  => inl("assets/fonts/NeueMontreal-Italic.otf","font/otf"),
      "assets/fonts/NeueMontreal-Medium.otf"  => inl("assets/fonts/NeueMontreal-Medium.otf","font/otf"),
      "assets/fonts/NeueMontreal-Bold.otf"    => inl("assets/fonts/NeueMontreal-Bold.otf","font/otf"),
      "assets/img/perroquet-1200.jpg"         => inl("assets/img/perroquet-1200.jpg","image/jpeg"),
      "assets/img/perroquet.jpg"              => inl("assets/img/perroquet.jpg","image/jpeg"),
    );
    for my $g (glob("assets/img/gallery/*.jpg"), glob("assets/img/hero-*.jpg"), glob("assets/img/infirmiere-*.jpg"), glob("assets/img/portrait-*.jpg"), glob("assets/img/studio-*.jpg")) { $map{$g} = inl($g, "image/jpeg"); }
  }
  s/^<link rel="preload"[^\n]*\n//;         # inutile quand les polices sont embarquées
  s/ srcset="[^"]*" sizes="[^"]*"//;          # une seule image embarquée (1200 px)
  for my $k (sort { length($b) <=> length($a) } keys %map) { my $q=quotemeta($k); s/$q/$map{$k}/g; }
' index.html > dist/studio-silo-artifact.html
ls -la dist/studio-silo-artifact.html
