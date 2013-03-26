# About various HRE provinces and countries

## History of Cologne (done)

Interesting case study: Cologne is one of the main cities of the
Hanseatic League, an electorate, and a duchy (united with Berg/Cleves).
The electorate ended up controlled by the Duke of Westfalia, a Catholic,
after a religious war (prelude to TYW).

### Timeline of the archbishopric

1582: The elector tries to secularize the electorate and to go
Protestant at the same time. Armed intervention of Spain (including
Farnese), Italian mercenaries and Bavaria.

From that time, the fate of the Prince-Bishopric of Münster is merged
with the fate of the Archbishopric.

However, the Archbishopric is represented as a minor without any
territory if this rule is acceptable.

### Timeline of Jülich

The duchy is united with Berg and Cleve at the beginning of pII (1521),
and allied before. So the *Jülich* province should in fact belong to Berg.

### The Cologne city

The case of the City of Cologne is easy: this is an Hanseatic Kontor as
long as it is not destroyed. It will be if Hansa is destroyed. As long
as the Kontor is there, the territory is only useful as strategic point
(no income).

### Event: War of the Jülich succession

This event may degenerate in TYW.  This is a religious civil
war. Authorized to intervene: pretty much everyone? HOL, FRA, ANG, AUS,
SPA, Bavaria, Palatinate, Brandenburg, Münster, Hesse, etc.

Historically, HOL, Brandenburg, ANG, Protestant Union against SPA,
Catholic League (esp. Bavaria) against AUS (played by VEN).

* Statu quo: partition of Berg in two provinces, the minor
Archbishopric of Köln gets territory (usual minor
now).^[Design note: this reflects the fact that the Duchy would have fallen in the hands of two Wittelbach lines and would have been allied. This avoids creating a minor that owns just the Jülich territory with no power.]
* Win for protestant: Berg remains intact (and that is one more
Protestant province for the Protestant Union).
* Win for Catholic League (historical result): partition of Berg in two
provinces, Münster becomes Catholic and gets the *Jülich* province.
* Win for AUS: The Duchy of Jülich is annexed by AUS.

### Event: Conversion of the Archbishop of Köln

This is a religious civil war. Authorized to intervene: HOL, AUS?, SPA,
Bavaria (as a minor), Palatinate (as a minor).

Roll 1d10 on this table:
1-2: Not coming
3-4: LD G
5-7: A- G
8-9: A- LD G
10+: A+ G

Add +3 for Bavaria, +1 for Palatinate if Palatinate is not at war. No
reinforcement roll. 50 D$ will by a +1 for Bavaria/Palatinate. The
General is considered rank A and may command allied troops.

A forteress level 2 is placed in the *Jülich* province.

Win: The controller of *Jülich* province and the new Fortress is the same,
and the Fortress is level 2 (HOL/Palatinate) or level 1 (SPA/Bavaria) at
the end of the turn wins.

Statu quo: Any other solution.

SPA and HOL intervene as they see fit.

Free passage granted in the HRE for the course of
the war. The Emperor has to intervene.

* HOL/Palatinate wins: The Archbishopric becomes
protestant. Archbishopric goes to MA (unless already better) of HOL
if HOL did intervene, else neutral.
* Statu quo: The Archbishopric is neutral, and may vote for anyone.
Archbishopric goes to neutral.
* SPA/Bavaria wins: The Archbishopric remains catholic (historical:
Ernst of Bavaria, also Duke of Westfalia, becomes Archbishop).
Archbishopric goes to MA (unless already better) of SPA
if HOL did intervene, else goes to MA (unless already better) of
AUS (if major), else goes to neutral.

## History of Palatinate and Bavaria (done)

Palatinate is in fact up to four lines:

* Duchy of Zweibrücken
* Palatinate of the Rhine
* Palatinate Neuburg
* Palatinate Sulzbach

These lines are cousin to the Bavarian lines of the Wittelsbach, and
indeed in 1799, all territories became Bavarian (well, sort of: the
*Palatinate province* aka *Pfalz*, on the left bank of the Rhine, was
French by that time).

The first line went on as kings of Sweden, but dominated few other
territories. Waged the Landshut War of Succession over the Electoral
Palatinate. Besides giving a claim of Sweden on Bavaria, nothing much.

The second line became extinct in 1685. It converted in 1559 (end of
pII) to protestantism, and probably represents best the *Palatinate
minor*. It became extinct in 1685 (T40). Fragmented territory,
mostly Mannheim.

The third line joined the Protestant in 1608. However, it remained
strictly neutral. Mainly noted for inheriting Jülich and Cleves (aka
province of *Jülich*) just before TYW, it remained strictly neutral during
TYW. It was merged with the fourth in 1742 (T51) and Bavaria in 1777
(T58). This should intervene in the *War of Bavarian Succession*.

The fourth line had not many powers, but finally received all others,
including Bavaria, and started the *War of Bavarian Succession*.

### Event: Extinction of Palatinate
This event (hist. turn 40) gives *Pfalz* to Bavaria. Palatinate is no
more. If *OberPfalz* still belonged to Pfalz, then the resulting Bavaria
is neutral (and amend event *War of Bavarian Succession*, maybe). The resulting
country has 3 A counters.

### Event: War of Bavarian Succession
Historic setting: Bavaria has now merged with Palatinate and possibly
Jülich. Prussia and Saxony are against *Bavaria province* being given to
Austria (in exchange for Belgian provinces, originally, but it could
have been anything that allowed the ruler of Bavaria to give territories
to his illegitimate heirs).

Win for AUS: Bavaria annexed, Palatinate may be reinstated in full force
(OberPfalz+Pfalz+Jülich+2 A). Possibility to exchange provinces of AUS
in Belgium against provinces of Palatinate. The Bavarian A is fully
usable by AUS.

Win for PRU: Statu quo, possibly gaining one province over one of the
belligerants.

Medium (historical): Bavaria and Palatinate united, nothing gained by
AUS nor by PRU. Basic forces low (strictly lower than the sum of
Palatinate and Bavaria, at least).

Historically, FRA chose to abandon AUS, ANG would have helped PRU but
was busy somewhere else, and RUS was not willing to overcommit in Europe
this time.

### Minors


    minorcountry{palatinat}{Electorate of Pfalz}{Palatinatus}
    minorreligion{palatinat}{protestant}
    minordiplo{palatinat}{10}{40}{2}{3}{4}{*}{*}
    minorpref{palatinat}{\FRA, \HOL, \PRU, \POL, \ENG, \HIS, \AUS, \VEN, \POR, \RUS, \SUE, \TUR}
    minorfid{palatinat}{9}
    minorcapital{palatinat}{Pfalz}7
    minorprovince{palatinat}{OberPfalz}7
    minorbasicforces{palatinat}{\ARMY\faceplus}
    minorbasicrenforts{palatinat}{\LD}
    minorarmyclass{palatinat}{Latin}{III}
    minorHRE[Elector]{palatinat}
    minorforces{palatinat}{2 \ARMY, 2 \LD}
    minorspecial{palatinat}{Electorat of the \HRE.}
    minorspecial{palatinat}{May lose its second \ARMY,
    province{OberPfalz} and the electorate after \eventref{pIV:TYW}.}
    
    minorcountry{baviere}{Duchy of Bavaria}{Bavaria}
    minorHRE{baviere}
    minorreligion{baviere}{catholique}
    minordiplo{baviere}{10}{20}{2}{4}{6}{*}{*}
    minorfid{baviere}{16}
    minorgeo{baviere}{FRA+1}
    minorpref{baviere}{\SPA, \FRA, \HOL, \VEN, \POR, \ENG, \SUE, \AUS, \RUS, \TUR, \PRU}
    minorcapital{baviere}{Bayern}9
    minorbasicforces{baviere}{\ARMY\facemoins, \LD}
    minorbasicrenforts{baviere}{\LD}
    minorarmyclass{baviere}{Latin}{III}
    minorforces{baviere}{\ARMY, 3 \LD}
    minorspecial{baviere}{After dynastic action \shortdynasticaction{C}{4} has been played, \HAB\ has a +1 geopolitic bonus for diplomatic actions on Bavaria.}
    minorspecial{baviere}{May use two \ARMY\ during \eventref{pIV:TYW} and \eventref{pIV:Bohemian Revolt}.}
    minorspecial{baviere}{May permanently gain a second \ARMY, \province{OberPfalz} and an electorate as a consequence of \eventref{pIV:TYW}.}

## History of Trier (done)

The Archbishopric of Trier mostly had a territorial base. As such, it
was run over and the city pillaged several times over the period (mostly
by French, but also by Englishmen chasing French). Except for being run
over, no noticeable facts. It was catholic, but the Sponheim county,
part of the *Trier* province, was protestant (on the border of the
Palatinate).

(left as-is)

    minorcountry{treves}{Archbishopric of Trier}{Trevorum}
    minorreligion{treves}{catholique}
    minordiplo{treves}{8}{30}{1}{4}{5}{*}{*}
    minorpref{treves}{\SPA, \AUS, \FRA, \POL, \HOL, \VEN, \PRU, \ENG, \POR, \RUS, \SUE, \TUR}
    minorfid{treves}{14}
    minorcapital{treves}{Trier}4
    minorbasicforces{treves}{\LD}
    minorarmyclass{treves}{Latin}{III}
    minorHRE[Elector]{treves}
    minorforces{treves}{\LD}
    minorspecial{treves}{Electorate of the \HRE.}

## History of Mainz (done)

The territory of Mainz was very fragmented (from Erfurt to Mainz, and,
in fact, very little territory around Mainz). Most of it is more or less
the eastern half of the current province. Many losses incurred during
the reformation, compensated (partially) during the TYW. No military
action beyond being burned once, apparently.

I propose to include the Archbishopric of Mainz in the Franconia minor
(other bishoprics). The territory is reaffected to Hesse (Darmstadt
house).

However, the Archbishopric is represented as a minor without any
territory if this rule is acceptable.

    minorcountry{mayence}{Archbishopric of Mainz}{Mogentium}
    minorreligion{mayence}{catholique}
    minordiplo{mayence}{6}{40}{3}{2}{5}{*}{*}
    minorpref{mayence}{\FRA, \AUS, \SPA, \POL, \PRU, \HOL, \VEN, \POR, \ENG, \RUS, \SUE, \TUR}
    minorfid{mayence}{10}
    minorfixedincome{mayence}0{Prince-Bishopric}{5}
    minorbasicforces{mayence}{}
    minorarmyclass{mayence}{Latin}{III}
    minorHRE{mayence}
    minorspecial{mayence}{Electorat of the \HRE.}
    minorforces{mayence}{\LD}


## History of Turingia and Saxonia (done)

### Ernest and Albert

Thuringia mostly occupies the Ernestine Saxony, and the rest is the
Albertine Saxony. If the provinces are modified as proposed, *Anhalt*
province is more or less historical Anhalt plus the Ernestine lands
given to the Albertine branch after the capitulation of Wittenberg.

The elder Ernestine branch will be represented by the minor
**Turingia**, the younger Albertine branch by the minor **Saxonia**.

At game start, **Saxonia** and **Turingia** are in defensive
alliance. This alliance ends with the creation of the Schmalkaldic
league, of which **Saxonia** is not part.

Schmalkaldic league event allows HAB to break the Saxon alliance:

  * HAB gets the help of the intervention of Maurice of Wettin. Maurice
comes to his help with 1 LD of veteran troops anywhere in the HRE during
the first turn of the LoS war. The Saxony division has to be part of the
peace agreement.

At the peace phase:

  * For two positive conditions of peace for LoS over HRE, Saxony is
    reunited which means that **Turingia** is dissolved as a minor, the
    Electorate goes to **Saxonia** as well as all **Turingia**
    provinces, and Saxonia will enter TYW on the side of protestants
    with no modifier instead of -4.
  * For one positive condition of peace for LoS over HRE, Saxony is
    reunited which means that **Turingia** is dissolved as a minor, the
    Electorate goes to **Saxonia** as well as all **Turingia**
    provinces. However, **Saxonia** will have the -4 malus to enter TYW.
  * Else, **Turingia** keeps the electorate, *Anhalt* and the alliance
    still runs after the LoS is broken, which means that Saxonia will
    enter the TYW with **Turingia** (no separate test for **Saxonia**).
    **Saxonia** gains *Altmark*.
  * For one positive condition of peace of HRE over LoS, or if
    **Turingia** is pushed out of the LoS by HRE, **Turingia** loses its
    electorate, the territory of *Anhalt* becomes part of **Saxonia** and
    the alliance is broken.
  * For two positive conditions of peace of HRE over LoS, **Turingia**
    loses its electorate, the territory of *Anhalt* becomes part of
    **Saxonia** and the alliance is broken. Moreover, **Saxonia** will
    not intervene in the TYW on the side of the the Protestant League,
    but on the side of the Catholic Alliance with a modifier of -6.

### Modifications to TYW

See above for the influence of the War of LoS on the position of
**Saxonia**. Remove the ruling about **Saxonia** used as
mercenaries. Replace the change of position at Prague of **Saxonia** by
the following: **Saxonia** may be recruited by the HRE at the peace of
Prague by giving it the ownership of the province of
*Lausitz*. Withdrawal of all League troops has to be made from
**Saxonia** territories.

### Modifications to other events

TODO?

### Minors

**Turingia** may possibly use the a simple black on top and yellow at bottom coat of arms.

    minorcountry{thuringe}{Ernestine line of the Wettin House}{Turingia}
    minorreligion{thuringe}{protestant}
    minordiplo{thuringe}{4}{60}{1}{3}{4}{*}{*}
    minorpref{thuringe}{\PRU,\SPA, \HOL, \ENG, \AUS, \SUE, \VEN, \POL, \FRA, \POR, \RUS, \TUR}
    minorfid{thuringe}{14}
    minorcapital{thuringe}{Thüringen}7
    minorprovince{thuringe}{Franken}6
    minorbasicforces{thuringe}{\LD}
    minorarmyclass{thuringe}{Latin}{III}
    minorHRE[Elector]{thuringe}
    minorforces{thuringe}{2\LD}
    minorspecial{thuringe}{Begins as an Electorate of the HRE. May lose it to \payssaxe.}

    minorcountry{saxe}{Duchy of Saxony}{Saxonia}
    minorreligion{saxe}{protestant}
    minordiplo{saxe}{6}{30}{1}{3}{4}{*}{*}
    minorpref{saxe}{\POL, \FRA, \ENG, \SUE, \HOL, \RUS, \VEN, \POR, \SPA, \AUS, \PRU, \TUR}
    minorfid{saxe}{11}
    minorcapital{saxe}{Sachsen}9
    minorprovince{saxe}{Anhalt}8
    minorbasicforces{saxe}{\ARMY\faceplus, 1 \LeaderG}
    minorbasicrenforts{saxe}{\LD}
    minorarmyclass{saxe}{Latin}{IIIM}
    minorHRE[Potential elector]{saxe}
    minorforces{saxe}{\ARMY, 2 \LD}
    minorbonusrenforts{saxe}{+2 \EUminorremark{during periods \period{I} to \period{IV}.}{(pI--pIV)}}
    minorspecial{saxe}{Electorate of the \HRE.}
    minorspecial{saxe}{May become a special vassal of \POL\ after \eventref{pV:Saxon King Poland}.}
    minorgeo{\HAB +1}

## History of Brunswick (done)

Provinces: Braunschweig, Hannover.

It is possible to split *Hanover* and *Braunschweig* in three provinces:

* _Calenberg_ (city Hanover)
* _Luneburg_ (city Luneburg or Celle)
* _Braunschweig_ (city Brunswick)

All these three provinces were occupied by different branches of the
House of Brunswick. The main division is between Brunswick-Lüneburg and
Brünswick-Wolfenbuttel, but it seems that these lines never warred
against one another, and mostly participated on the same sides of the
war.

One decision could be to unite all of these lines in the same minor
country (**Brunsvicum**) and to change the Vassalization of Hanovere by
the annexation of the *Calenberg* and *Luneburg* provinces.

Another decision is to leave as-is the Hanover minor. It starts with a
capital in *Luneburg* and gains *Hanover* at the peace of Prague (free
CB for the owner till the peace of Westphalia).

Two possible implementations of the minor Brunsvicum. The first one
implies redistributing one protestant army somewhere (suggestion: Berg
minor before annexation by PRU).

    BRUNSVICUM
    Control: ANG, HOL, DAN, SUE, FRA, HIS, AUS, VEN, PRU, POL, RUS, POR, TUR.
    Member of the HRE, Protestant (first wave).
    Income: ~22.
    
    RM: 10, SUB: 30, MA: 4, EC: 3, EW: 3, VA: 8. Fidelity 15.
    Basic forces: A+, 1G.
    Counter limits: A, 3 LD.
    Basic reinforcements: 1 LD.
    Military doctrine: Latin, class III.
    
    ANG gets one Army counter available marked Hanover after the
    annexation of *Luneburg* and *Calenberg*.

Other view:

    BRUNSVICUM
    Control: ANG, HOL, DAN, SUE, FRA, HIS, AUS, VEN, PRU, POL, RUS, POR, TUR.
    Member of the HRE, Protestant (first wave).
    Income: ~22.
    
    RM: 10, SUB: 20, MA: 2, EC: 2, EW: 2, Fidelity 14.
    RM: 8, SUB: 40, MA: 4, EC: 4, EW: 4, Fidelity 8. (used after annexation
    by ANG)
    Basic forces: A-, LD, 1G. (only LD after annexation by ANG).
    Counter limits: 2A, 2 LD. (only A, LD after annexation by ANG).
    Basic reinforcements: 1 LD. (None after annexation by ANG).
    Military doctrine: Latin, class III.

Third view (statu quo):

    minorcountry{brunswick}{Duchy of Brunswick-Wolfenbuttel}{Brunsvicum}
    minorreligion{brunswick}{protestant}
    minordiplo{brunswick}{8}{40}{4}{3}{3}{*}{*}
    minorpref{brunswick}{\FRA, \SPA, \AUS, \POL, \PRU, \HOL, \VEN, \POR, \SUE, \ENG, \RUS, \TUR}
    minorfid{brunswick}{14}
    minorcapital{brunswick}{Braunschweig}{11}
    minorbasicforces{brunswick}{\ARMY\facemoins}
    minorarmyclass{brunswick}{Latin}{III}
    minorHRE{brunswick}
    minorforces{brunswick}{\ARMY, \LD}
    
    minorcountry{hanovre}{Duchy of Brunswick-Luneburg (later called Electorate of Hanover)}{Hanovere}
    minorreligion{hanovre}{protestant}
    minordiplo{hanovre}{12}{20}{1}{2}{3}{6}{*}
    minorpref{hanovre}{\ENG, \HOL, \SUE, \FRA, \AUS, \RUS, \POL, \PRU, \POR, \VEN, \SPA, \TUR}
    minorfid{hanovre}{15}
    minorgeo{hanovre}{\ENG +1 in periods \period{VI} and \period{VII}}
    minorprovince{hanovre}{Osnabruck}7
    minorcapital{hanovre}{Hannover}{11}
    minorbasicforces{hanovre}{\ARMY\facemoins, \LD, 1 \LeaderG}
    minorarmyclass{hanovre}{Latin}{III}
    minorHRE{hanovre}
    minorforces{hanovre}{\ARMY, 2 \LD}

An Elector is added with the event *Annexation of Hanover*, and goes to
**Brunsvicum** as long as the Annexation is not effective (in case of
pre-conditions not fulfilled). Modify the text of the annexation.

In the statu quo situation, the Electorate is given to **Hanover**.

# Rules proposal

## Delocalized Archbishoprics

The Minor countries **Archbishopric of Cologne** and **Archbishopric of
Mainz** may not deserve a territorial implantation. The **Archbishopric
of Trier** was run over a sufficient number of times to deserve a place
(for being run over).

These Minor countries cannot be warred against, but they do have no
military counters. They have an income of 4, to be used for all purposes
(e.g. vassalization). A specific declaration of war may be done to
include a fortress for them (the fortress of level 2 will be placed in
the *Köln* province or in the *Mainz* province). Reducing this fortress
to level 1 will pillage the minor for 2 turns (at which point the
fortress is removed from the map until the end of the war).

The LD usually dedicated to these minors should be redistributed on
other minor countries of the HRE.

## League of Schmalkalde

This league comprised many protestant countries. Currently, this is a
defensive alliance between Thuringia, Saxony, Hesse, Wurtemberg. It was
also joined at the time by the Hansa and (officially at least) the
Palatinate.

TODO

## Notes on geography

### Around Saxony

Altmark should go a bit below and along the river. Slezsko should end up
almost touching Neumark (but we do not want contact). Lausitz is smaller
and rounder. Anhalt should touch Oberpfalz (and not Sachsen touch
Thüringen).

### Other

See in the summary.

# Summary
## Envisioned minors

* .c.D Münster
* .ce* Bavaria
* .c.d Alsace
* .c.D Lorraine
* .c.D Franconia
* xcE. Mainz
* xcE. Cologne
* .cEd Trier
* .~.D Baden
* .~E* Palatinate
* .~eA Saxonia
* .XEA Bohemia
* .peA Luneburg
* .p.A Brunswick
* .p.A Hesse
* .p.A Hansa
* .p. Berg
* .p. Nassau         **New**
* .p. Ansbach        **New**
* .p. Württemberg
* .pÊ Thuringia
* .pE Brandenburg

Legend:

* . → minor / x → minor without any territory
* c → catholic / p → protestant / ~ → protestant or catholic / X ~ not relevant
* E → Elector / Ê → loses electorate / e → late Elector / . → nothing
* A → Army / * → Several armies / D → several LD / d → 1 LD / . → no troops

## Territory modifications

Ansbach-Bayreuth province created on top of Oberpfalz.

* Oberpfalz → Sachsen, Thüringen, Franken removed
* Ansbach → Sachsen, Franken, Schwaben, Cechy, Württemberg, Anhalt

Anhalt moved vertically:

* Sachsen → Thüringen removed
* Anhalt → Franken, Ansbach (new) added

Silesia connected with Neumark:

* Lausitz → Wielkopolska removed
* Slezsko → Neumark added

Mainz renamed to Darmstadt

Köln renamed to Jülich

Osnabrück renamed to Minden

Hanover split in two:

* Kalesnberg → Bremen, Lüneburg, Braunschweig, Cassel (form. Hesse),
Westfalia (form. part of Nassau), Minden (form. Osnabrück), Münster,
Oldenburg
* Lüneburg → Bremen, Holstein, Mecklenburg, Brandenburg, Altmark,
Braunschweig, Kalenberg
* Bremen → Osnabrück removed (or not: incl. county of Hoya in
Bremen/Minden?)
* Mecklenburg → Altmark removed

Redistributing lands of Hesse-Nassau in four provinces: Hesse, Cassel,
Nassau, Westfalia

* Westfalia → Minden (form. Osnabrück), Kalenberg (form. Hanover),
Cassel, Nassau, Berg, Münster.
* Cassel → Kalenberg, Braunschweig, Thüringen, Franken, Hesse, Nassau,
Westfalia
* Hesse → Cassel, Franken, Darmstadt (form. Mainz), Nassau
* Nassau → Darmstadt (form. Mainz), Pfalz, Trier, Berg, Westfalia,
Cassel, Hesse

Trier now touches Lorraine

* Trier → Lorraine added
* Pfalz → Luxemburg removed

# Quick notes

Baden: union of Baden (split in two, one catholic, the largest?, one
protestant)+Breisgau/Friburg (catholic)+Fuerstenberg (catholic).

Ansbach+Bayreuth: minor branches of Hohenzollern, Protestant. Not
necessarily on the side of the Protestant, though.

Hesse: Darmstadt and Cassel, one Calvinist, one Lutherean. Darmstadt
with the Emperor, Cassel against.

Nassau: very divided. Protestant.

Liège: I have doubts on the real vassal status. And it did touch the
Rhine, instead of Limburg. Rename Utrecht to Staats/Breda and use Breda
as a city. Perhaps cut this province in two, include Maastricht as a
simple extension of Luxemburg, and rename Limburg to Staats.