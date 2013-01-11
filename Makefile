HOMEDIR=.
CURRENTDIR=$(HOMEDIR)
include $(HOMEDIR)/common.mk

cleanold:
	@rm -rf changelog-local pions/autrereligion.pdf pions/compte-tr.pdf pions/colonies.pdf pions/orthodoxe.pdf pions/figure-1.pdf pions/figure-2.pdf pions/list-counters.txt pions/sunnite.pdf pions/monarque.pdf pions/colonialspain.pdf pions/catholique.pdf pions/chiite.pdf pions/etoile.pdf pions/compte.pdf pions/compte-revenu.pdf pions/protestant.pdf rules/figures rules/images rules/tables rotw/plain.ps rotw/fonddecarte.pdf carte/plain.ps carte/fonddecarte.pdf carte/template.map carte/europesmall.pdf carte/full.map blasons/Shield-hollande.png blasons/Shield_francec.pnm blasons/Shield_croises.pnm blasons/Shield-papaute.png blasons/Shield_revolutionnaires.pnm blasons/Shield-moldavie.png blasons/Shield-neutre.png blasons/Shield_lorraine.pnm blasons/Shield_irlande.pnm blasons/Shield_montferrat.pnm blasons/Shield-iroquois.png blasons/Shield_siberie.pnm blasons/Shield_wurtemberg.pnm blasons/Shield-palatinat.png blasons/Shield_thuringe.pnm blasons/Shield_tordesillas.pnm blasons/Shield_damas.pnm blasons/Shield-tordesillas.png blasons/Shield_aceh.pnm blasons/Shield_ryazan.pnm blasons/Shield-belgique.png blasons/Shield_grenade.pnm blasons/Shield_ligue.pnm blasons/Shield_brunswick.pnm blasons/Shield_alliance.pnm blasons/Shield_astrakhan.pnm blasons/Shield_mogol.pnm blasons/Shield_mysore.pnm blasons/Shield-japon.png blasons/Shield_berg.pnm blasons/Shield-afghans.png blasons/Shield-modene.png blasons/Shield-treves.png blasons/Shield_steppes.pnm blasons/Shield-baviere.png blasons/Shield-tunisie.png blasons/Shield_soudan.pnm blasons/Shield-espagne.png blasons/Shield_pommeranie.pnm blasons/Shield-oman.png blasons/Shield-pskov.png blasons/Shield_valachie.pnm blasons/Shield_arabie.pnm blasons/Shield_lucca.pnm blasons/Shield-blanc.png blasons/Shield-montferrat.png blasons/Shield-wurtemberg.png blasons/Shield-bourgogne.png blasons/Shield_parme.pnm blasons/Shield_kazan.pnm blasons/Shield_hesse.pnm blasons/Shield-milan.png blasons/Shield_balkans.pnm blasons/Shield-mazovie.png blasons/Shield-russie.png blasons/Shield-inca.png blasons/Shield-habsbourg.png blasons/Shield_cologne.pnm blasons/Shield-oresund.png blasons/Shield-ecosse.png blasons/Shield-naples.png blasons/Shield-lithuanie.png blasons/Shield_oman.pnm blasons/Shield-pommeranie.png blasons/Shield_norvege.pnm blasons/Shield_flandrebrabant.pnm blasons/Shield-france.png blasons/Shield_francep.pnm blasons/Shield-azteque.png blasons/Shield-sienne.png blasons/Shield_catalogne.pnm blasons/Shield-bretagne.png blasons/Shield_eastprussia.pnm blasons/Shield-gujarat.png blasons/Shield-hanse.png blasons/Shield_japon.pnm blasons/Shield-boheme.png blasons/Shield-saxe.png blasons/Shield_inca.pnm blasons/Shield-eastprussia.png blasons/Shield-crimee.png blasons/Shield-brunswick.png blasons/Shield_georgie.pnm blasons/Shield-astrakhan.png blasons/Shield_liflandie.pnm blasons/Shield_usa.pnm blasons/Shield-danemark.png blasons/Shield_royalistes.pnm blasons/Shield-usa.png blasons/Shield_neutre.pnm blasons/Shield_hanovre.pnm blasons/Shield_pskov.pnm blasons/Shield_pologne.pnm blasons/Shield-toscane.png blasons/Shield-saint-empire.png blasons/Shield-rebelles.png blasons/Shield-ukraine.png blasons/Shield-turquie.png blasons/Shield_blanc.pnm blasons/Shield-revolutionnaires.png blasons/Shield-lorraine.png blasons/Shield-mayence.png blasons/Shield-tripoli.png blasons/Shield_hongrie.pnm blasons/Shield-thuringe.png blasons/Shield_mercenaires.pnm blasons/Shield-chine.png blasons/Shield_milan.pnm blasons/Shield_saxe.pnm blasons/Shield-alsace.png blasons/Shield-mercenaires.png blasons/Shield_cyrenaique.pnm blasons/Shield_modene.pnm blasons/Shield_pirates.pnm blasons/Shield-pise.png blasons/Shield_treves.pnm blasons/Shield-algerie.png blasons/Shield-alliance.png blasons/Shield-natives.png blasons/Shield_huguenots.pnm blasons/Shield_oldenburg.pnm blasons/Shield-corse.png blasons/Shield_hyderabad.pnm blasons/all blasons/Shield_angleterre.pnm blasons/Shield_saint-empire.pnm blasons/Shield_portugal.pnm blasons/Shield-sainte-ligue.png blasons/Shield_papaute.pnm blasons/Shield-royalistes.png blasons/Shield-francec.png blasons/Shield_courlande.pnm blasons/Shield-suede.png blasons/Shield-croises.png blasons/Shield-suisse.png blasons/Shield-valachie.png blasons/Shield-irlande.png blasons/Shield-siberie.png blasons/Shield_mamelouks.pnm blasons/Shield_hanse.pnm blasons/Shield-savoie.png blasons/Shield_pise.pnm blasons/Shield-bade.png blasons/Shield-catalogne.png blasons/Shield_afghans.pnm blasons/Shield-maroc.png blasons/Shield_russie.pnm blasons/Shield-grenade.png blasons/Shield_baviere.pnm blasons/Shield-cyrenaique.png blasons/Shield-teutoniques1.png blasons/Shield_tunisie.pnm blasons/Shield_finlande.pnm blasons/Shield_ecosse.pnm blasons/Shield_espagne.pnm blasons/Shield_naples.pnm blasons/Shield_chevaliers.pnm blasons/Shield_sainte-ligue.pnm blasons/Shield_hollande.pnm blasons/Shield-perse.png blasons/Shield-transylvanie.png blasons/Shield-prusse.png blasons/Shield-steppes.png blasons/Shield_france.pnm blasons/Shield-irak.png blasons/Shield-liflandie.png blasons/Shield-angleterre.png blasons/Shield_moldavie.pnm blasons/Shield-venise.png blasons/Shield_iroquois.pnm blasons/Shield_sienne.pnm blasons/Shield_cosaquesdon.pnm blasons/Shield_chine.pnm blasons/Shield_bade.pnm blasons/Shield-cosaquesdon.png blasons/Shield_belgique.pnm blasons/Shield-liege.png blasons/Shield_boheme.pnm blasons/Shield_crimee.pnm blasons/Shield_teutoniques1.pnm blasons/Shield-genes.png blasons/Shield_mazovie.pnm blasons/Shield_corse.pnm blasons/Shield-ryazan.png blasons/Shield_transylvanie.pnm blasons/Shield_oresund.pnm blasons/Shield-balkans.png blasons/Shield_irak.pnm blasons/Shield-mysore.png blasons/Shield-huguenots.png blasons/Shield-oldenburg.png blasons/Shield-hyderabad.png blasons/Shield_vijayanagar.pnm blasons/Shield-chevaliers.png blasons/Shield-cologne.png blasons/Shield-soudan.png blasons/Shield-vijayanagar.png blasons/Shield_suede.pnm blasons/Shield-norvege.png blasons/Shield_palatinat.pnm blasons/Shield_azteque.pnm blasons/Shield-courlande.png blasons/Shield-francep.png blasons/Shield_alsace.pnm blasons/Shield_brandebourg.pnm blasons/Shield-arabie.png blasons/Shield-damas.png blasons/Shield_gujarat.pnm blasons/Shield_maroc.pnm blasons/Shield-brandebourg.png blasons/Shield-mamelouks.png blasons/Shield-ligue.png blasons/Shield_perse.pnm blasons/Shield-aden.png blasons/Shield-teutoniques2.png blasons/Shield-mogol.png blasons/Shield-georgie.png blasons/Shield_toscane.pnm blasons/Shield_ukraine.pnm blasons/Shield_turquie.pnm blasons/Shield-portugal.png blasons/Shield-hanovre.png blasons/Shield-pologne.png blasons/Shield_suisse.pnm blasons/Shield-flandrebrabant.png blasons/Shield_mayence.pnm blasons/Shield_tripoli.pnm blasons/Shield_liege.pnm blasons/Shield_savoie.pnm blasons/Shield_bretagne.pnm blasons/Shield_bourgogne.pnm blasons/Shield-lucca.png blasons/Shield_genes.pnm blasons/Shield-hongrie.png blasons/Shield_aden.pnm blasons/Shield_teutoniques2.pnm blasons/Shield_algerie.pnm blasons/Shield-aceh.png blasons/Shield_natives.pnm blasons/Shield_habsbourg.pnm blasons/Shield-parme.png blasons/Shield-kazan.png blasons/Shield-hesse.png blasons/Shield-pirates.png blasons/Shield_prusse.pnm blasons/Shield_danemark.pnm blasons/Shield_lithuanie.pnm blasons/Shield-berg.png blasons/Shield-finlande.png blasons/Shield_venise.pnm blasons/Shield_rebelles.pnm
	@echo "These files are not known for the repository:"; svn status; echo "If you do not know what they are, you should inspect or delete them."; printf "Now, use \"make conf\" to parameterise your installation,\n and \"make all\" to build everything.\n"
	
.PHONY: cleanold
