#!/usr/bin/perl
use POSIX;
# scale: valeur d'échelle utilisée pour les symboles
# En effet, on utilise des bitmaps avec une précision légérement
# supérieure à celle de la carte.
$scale=0.8;

# Pour chaque symbole à disposer sur la carte, on a besoin de dix
# données: offset(x,y) par rapport au coin inférieur gauche du
# bitmap du "point de centrage" du symbole (compté en pixels du
# bitmap en question), et quatres décalages pour les
# points de centrages des textes (dessous, dessus, gauche, droite)
# par rapport au point de centrage du symbole (compté en vrai distance,
# donc généralement relatifs à offset*scale ou (taille-offset)*scale.

%offset=(
	 "capitale2" => [33,24,0,-40,0,29,-22,-4,22,-4],
	 "capitale1" => [36,11,-0.0,-0.0,0,45,-0.0,-0.0,-0.0,-0.0],
	 "capitale1" => [33,18,0,-29,0,32,-15,3,12,3],
	 "ville2" => [33,21,0,-40,0,29,-22,-4,22,-4],
	 "ville1" => [32,6,0,-29,0,36,-15,3,12,3],
	 "villechine1"=> [29,4,0,-29,0,32,-15,3,12,3],
	 "villechine2"=> [45,20,0,0,0,0,-32,0,0,0],
	 "villeinde1" => [29,4,0,-29,0,32,-15,3,12,3],
	 "villeinde2" => [34,3,0,0,0,0,0,0,39,5],
	 "drapeauplaine" => [20,2],
	 "drapeauforet" => [17,2],
	 "rocher" => [3,3],
	 "anchor" => [35,0]
	 );
$offset{'capitale1jaune'}=$offset{'capitale1'};
$offset{'anchor2'}=$offset{'anchor'};
$offset{'anchor3'}=$offset{'anchor'};

$FILENAME=$ARGV[0];

# Syntaxe du fichier noms.utf:
# Chaque region est délimitée par son nom; jusqu'à l'apparition
# du nom suivant (format NOM pos "QQCHOSE" couleur ou pour une capitale
# NOM pos "QQCHOSE" couleur _)
# On relève ensuite toutes les directives (format ^TRUC .*) dans un
# tableau (donc possibilité de plusieurs directives pour une même
# région.
# Effet des directives:
# CITE x y symbole: affiche symbole aux coordonnees (x,y) et retient
# ces coordonnées comme étant celles de la ville (phase 1)
# ECU x y pays: affiche l'écu de pays en (x,y) (phase 2)
# NOM pos "Truc" couleur: affiche le nom de la ville en relatif au
# point d'ancrage de la ville (phase 3)
# NOM pos "Truc" _: idem, mais souligne les noms
# ALTNOM pos "Truc": idem NOM, mais ne change pas de région (noms
# alternatifs ou complémentaires). Un / à la fin de Truc fait utiliser
# l'italique. (phase 3 aussi)
# ALTNOM pos "Truc" _: idem NOM et ALTNOM
# Voir plus loin pour les positions et les couleurs possibles
# PROV x y "Truc" couleur: imprime en plus gros un nom
# de province aux coordonnées x y (phase 4). Retient les coordonnées
# de l'affichage pour les ALTPROV et VALUE
# ALTPROV position "Truc" couleur: affiche relativement aux coordonnées
# du PROV correspondant un autre nom de province.
# PROVCURVE x y r anglestart anglewidth "Truc" couleur: imprime
# un nom de province selon une courbe reposant sur un cercle (centre
# x y et rayon R. Écrit à l'extérieur si anglewidth>0, à l'intérieur
# sinon (prévoir un rayon plus grand) (phase 5)
# VALUE position valeur couleur: affiche la valeur des provinces
# (encore plus gros)(phase 6).
# IMG x y symbole: affiche le symbole aux coordonnées (x,y) pour le
# point de centrage (phase 7).
# RAW trucenpostscript: Insère trucenpostscript comme code exécuté
# directement à la fin du fichier (phase 8).

# Positions possibles (cités):
# Xl x y, Xc x y, Xr x y: positionnement absolu, aligné à gauche,
# centré ou à droite sur x y.
# [hbgd][HBUDLRlruo]*: la première lettre donne à partir d'où on écrit,
# et la direction d'alignement, les autres des décalages successifs.
# HB sont des décalages haut et bas d'une ligne, U et D d'une demie,
# L et R des décalages légers à gauche et à droite.
# ATTENTION: x y désignent toujours le bas de la boîte enveloppante
# du texte, pas la ligne de base.
# Positions possibles (pour les provinces):
# H: vers le haut;
# B: vers le bas.
# Pour les valeurs: idem, sachant qu'il y a ajustement en fonction
# des hauteurs respectives des noms de provinces et des valeurs.

%styles=("Xl","left","Xc","center","Xr","right",
	 'h',["center",4],
	 'b',["center",2],
	 'g',["right",6],
	 'd',["left",8],
	 'H',[0,20],
	 'B',[0,-20],
	 'U',[0,10],
	 'D',[0,-10],
	 'L',[-10,0],
	 'R',[10,0],
	 'l',[-1,0],
	 'r',[1,0],
	 'u',[0,1],
	 'o',[0,-1],
	 );

%stylesprov=(' ',[0,0],
	     'H',[0,30],'B',[0,-30],
	     'R',[10,0],'L',[-10,0],
# Micro déplacements
	     'l',[-1,0],'r',[1,0],
	     'u',[0,1],'o',[0,-1],
	     'v',[0,-6],'a',[0,6],
# Pour les écus
	     'V'=>[0,-42],'A'=>[0,42],
	     'G',[-23,0],'D',[23,0],
	     );
$e="A";
$ee="A";
$tt=0;
$ep=0;
# Couleurs possibles: B=brun, N=noir, W=blanc, J=jaune, R=rouge, G=gris
# L=noir avec liseré blanc.
#open VALUES,">./values.txt";

sub setupcolor {
    my $t=0;
    my $cep=0;
    my $a="";
    $f=$_[0];
    if ($e ne $f) {
        $a="(0 0 0 rg\\n) out\n" if ($f=~/N/);
        $a="(1 1 1 rg\\n) out\n" if ($f=~/W/);
        $a="(1 1 0 rg\\n) out\n" if ($f=~/J/);
        $a="(1 0 0 rg\\n) out\n" if ($f=~/R/);
        $a="(0.5 0.5 0.5 rg\\n) out\n" if ($f=~/G/);
        ($ep,$t,$a)=(0.8,2,"(0 0 0 RG 0.5 0.5 0 rg\\n) out\n") if ($f=~/B/);
        ($ep,$t,$a)=(0.2,2,"(0 0 0 rg 1 1 1 RG\\n) out\n") if ($f=~/L/);
        $e=$f;
	if ($t!=$tt) { print "/TextRenderingMode $t def\n"; $tt=$t; }
	if ($cep!=$ep) { print "($cep w\\n) out\n"; $ep=$cep; }
	print $a;
    }
}
sub setupunderline {
    $f=$_[0];
    if ($ee ne $f) {
        $underlinecolor=" 0.5 0.5 0 RG" if ($f=~/B/);
        $underlinecolor=" 0 0 0 RG" if ($f=~/N/);
        $underlinecolor=" 1 1 1 RG" if ($f=~/W/);
        $underlinecolor=" 1 1 0 RG" if ($f=~/J/);
        $ee=$f;
    }
}
$underlinecolor="(0.1 w\\n) out\n"; 
sub treattext {
    if ($soul eq " _") {
	setupunderline($col);
	$underline="(q 0.1 w".$underlinecolor."\\n) out underlinebbox (Q\\n)out";
	$soul="";
    } else {
	$underline="";
    }
    setupcolor($col);
    $disp=~s/~.*~//g;
    $disp=~s/\(/\\050/g;
    $disp=~s/\)/\\051/g;
    if ($disp=~/\/$/) {chop $disp;$z="-Italic";}
}

open FILE,$FILENAME;
$label="undef";
while(<FILE>) {
    $label=$1 if (/^NOM.*"(.*)"( _)?/);
    if (/^([A-Z]+) /) {
	$var=$1;push @{$$var{$label}},$_;
    }
}
close FILE;

foreach $ville (sort keys %CITE) {
    chomp;
    foreach (@{$CITE{$ville}}) {
	die "Wrong CITE for $_" unless m/CITE +(\d+) +(\d+) +(\w+)/;
	($posx{$ville},$posy{$ville},$type{$ville})=($1,$2,$3);
	printf "(img:%s) %04.1f %04.1f putsymbol\n",
	$type{$ville},
	$posx{$ville}-$scale*$offset{$type{$ville}}[0],
	$posy{$ville}-$scale*$offset{$type{$ville}}[1];
    }
}

foreach $ville (sort keys %NOM) {
    chomp;
    foreach (@{$NOM{$ville}},@{$ALTNOM{$ville}}) {
	$z="";
	if (m/(?:ALT)?NOM +(X[lcr]) +(\d+) +(\d+) "(.+)" ([BNJWRGL])( _)?/) {
	    ($way,$px,$py,$disp,$col,$soul)=($1,$2,$3,$4,$5,$6);
	    $style=$styles{$way};
	    treattext;
	    print "($disp) $px $py 1000 24 (FontArialNarrow${z}) ${style}textbbox$underline\n";
	} else {
	    die "$ville, pas de posx\n" unless defined($posx{$ville});
	    die "$_" unless m/(?:ALT)?NOM +([hbgd][HBUDLRlruo]*) +"(.+)" ([BNJWRGL])( _)?/;
	    ($way,$disp,$col,$soul)=($1,$2,$3,$4,$5,$6);
	    treattext;
	    $baseway=substr $way,0,1;
	    $otherway=substr $way,1;
	    print "%$baseway\n";
	    $style=$styles{$baseway}[0];
	    $px=$posx{$ville}+$offset{$type{$ville}}[$styles{$baseway}[1]];
	    $py=$posy{$ville}+$offset{$type{$ville}}[$styles{$baseway}[1]+1];
	    foreach (0..(length($otherway)-1)) {
		$courant=substr $otherway,$_,1;
		$px+=${$styles{$courant}}[0];
		$py+=${$styles{$courant}}[1];
	    }
	    $disp=~s/^_//;
	    printf "($disp) %4d %4d 1001 24 (FontArialNarrow$z) ${style}textbbox$underline\n",$px,$py;
	}
    }
}
%styles=%stylesprov;

foreach $ville (sort keys %PROV) {
    chomp;
    foreach (@{$PROV{$ville}},@{$ALTPROV{$ville}}) {
	$z="-Bold";
	if (m/(?:ALT)?PROV +([0-9-]+) +([0-9-])+ +"(.+)" ([BNJWRGL])([*])?/) {
	    die unless m/(?:ALT)?PROV +([0-9-]+) +([0-9-]+) +"(.+)" ([BNJWRGL])([*])?/;
	    ($px,$py,$disp,$col,$star)=($1,$2,$3,$4,$5);
	    treattext;
	    if ($star) {$finalname{$ville}=$disp;}
	    $disp=~s/\(/\\050/g;
	    $disp=~s/\)/\\051/g;
	    $provposx{$ville}=$px;
	    $provposy{$ville}=$py;
	    print "(",$disp,") $px $py 1000 36 (FontArialNarrow$z) centertextbbox\n";
	} else {
	    die "Prov error for $_" unless m/(?:ALT)?PROV( +[HBRLavuolr]+)? +"(.+)" ([BNJWRGL])([*])?/;
	    die "Pas de provx!" unless ($provposx{$ville});
	    ($otherway,$disp,$col,$px,$py,$star)=($1,$2,$3,$provposx{$ville},$provposy{$ville},$star);
	    treattext;
	    if ($star) {$finalname{$ville}=$disp;}
	    foreach (0..(length($otherway)-1)) {
		$courant=substr $otherway,$_,1;
		$px+=${$styles{$courant}}[0];
		$py+=${$styles{$courant}}[1];
	    }
	    print "(",$disp,") $px $py 1000 36 (FontArialNarrow$z) centertextbbox\n";
	}
    }
}

foreach $ville (sort keys %PROVCURVE) {
    chomp;
    foreach (@{$PROVCURVE{$ville}}) {
	die unless m/PROVCURVE +([0-9-]+) +([0-9-]+) +([0-9-]+) +([0-9.-]+) +([0-9.-]+) +"(.+)" ([BNJWRGL])([*])?/;
	($px,$py,$r,$as,$w,$disp,$col,$star)=($1,$2,$3,$4,$5,$6,$7,$8);
	$z="-Bold";
	treattext;
	if ($star) {$finalname{$ville}=$disp;}
	print "(",$disp,") ",join(' ',($px,$py,$r,$as,$w,36))," (FontArialNarrow$z) circletextbbox\n";
    }
}

foreach $ville (sort keys %PROVCURVEX) {
    chomp;
    foreach (@{$PROVCURVEX{$ville}}) {
	die unless m/PROVCURVEX +([0-9-]+) +([0-9-]+) +([0-9-]+) +([0-9-]+) +([0-9.-]+) +([0-9.-]+) +"(.+)" ([BNJWRGL])([*])?/;
	($px,$py,$r,$ai,$as,$w,$disp,$col,$star)=($1,$2,$3,$4,$5,$6,$7,$8,$9);
	$z="-Bold";
#angles dans le sens horaire, 0 vers le haut
	$as+=$ai; # Usually, -0.5*$w.
	$ai=90-$ai;
	$px-=$r*cos($ai*3.14159265358979/180);
	$py-=$r*sin($ai*3.14159265358979/180);
	treattext;
	if ($star) {$finalname{$ville}=$disp;}
	print "(",$disp,") ",join(' ',($px,$py,$r,$as,$w,36))," (FontArialNarrow$z) circletextbbox\n";
    }
}

foreach $ville (sort keys %VALUE) {
    chomp;
    foreach (@{$VALUE{$ville}}) {
	if (m/VALUE +X +(\d+) +(\d+) +([^ ]+) ([BNJWRGL])/) {
	    ($px,$py,$disp,$col)=($1,$2,$3,$4);
	    setupcolor($col);
	    $disp=~s/\(/\\050/g;
	    $disp=~s/\)/\\051/g;
	    print "($disp) $px $py 1000 48 (FontArialNarrow) centertextbbox\n";
	} else {
	    die unless m/VALUE( +[HBGDLRlruo]+)? +(\d+) ([BNJWRGL])/;
	    die "Pas de provx!" unless ($provposx{$ville});
	    ($otherway,$disp,$col,$px,$py)=($1,$2,$3,$provposx{$ville},$provposy{$ville});
	    setupcolor($col);
	    $courant="";
	    $py-=12 unless $otherway =~ /H.*/;
	    foreach (0..(length($otherway)-1)) {
		$courant=substr $otherway,$_,1;
		$px+=${$styles{$courant}}[0];
		$py+=${$styles{$courant}}[1];
	    }
	    print "($disp) $px $py 1000 48 (FontArialNarrow) centertextbbox\n";
	}
    }
#    print VALUES "$finalname{$ville}:$disp\n" if ($finalname{$ville});
}

foreach $ville (sort keys %ECU) {
    chomp;
    foreach (@{$ECU{$ville}}) {
	if (m/ECU +X +(\d+) +(\d+) +(\w+)/) {
	    printf "(img:%s) %04d %04d putsymbol\n",
	    $3,$1-19.2+0.5,$2+0.5;
	    ($provposx{$ville},$provposy{$ville})=($1,$2);
	} else {
	    die "Wrong ECU for $_" unless m/ECU +([HBAVDG][HBGDAVavLRlrud]*) +(\w+)/;
	    ($otherway,$ecu,$px,$py)=($1,$2,$provposx{$ville},$provposy{$ville});
	    $courant="";
	    if ($otherway =~ /[HA].*/) {$py+=7;}
	    elsif ($otherway =~ /[VB].*/) {$py-=20;}
	    foreach (0..(length($otherway)-1)) {
		$courant=substr $otherway,$_,1;
		$px+=${$styles{$courant}}[0];
		$py+=${$styles{$courant}}[1];
	    }
	    ($provposx{$ville},$provposy{$ville})=($px,$py);
	    printf "(img:%s) %04d %04d putsymbol\n",$ecu,$px-19.2+0.5,$py+0.5;
	}
    }
}

foreach $ville (sort keys %IMG) {
    chomp;
    foreach (@{$IMG{$ville}}) {
	die unless m/IMG +(\d+) +(\d+) +(\w+)/;
	printf "(img:%s) %04.1f %04.1f putsymbol\n",
	$3,$1-$scale*$offset{$3}[0],$2-$scale*$offset{$3}[1];
    }
}

foreach $ville (sort keys %CITE) {
    foreach (@{$RAW{$ville}}) {
	die unless m/RAW +(.+)/;
	print $1,"\n";
    }
}
print "/TextRenderingMode 0 def\n" if ($tt!=0);
#exit 0
close VALUES;
