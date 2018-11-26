INSERT INTO gn_commons.bib_tables_location(table_desc, schema_name, table_name, pk_field, uuid_field_name)
VALUES
('Informations de visite d''un circuit oedicneme', 'monitoring_oedic', 't_visite_informations', 'id_base_visit', 'uuid_oedic_t_visite_informations' ),
('Observation durant une visite', 'monitoring_oedic', 't_visite_observations', 'id_visite_observation', 'uuid_oedic_t_visite_observations')
;


-- ###########################
-- Nomenclatures
-- ###########################

-- Nouveaux types


DELETE FROM ref_nomenclatures.t_nomenclatures WHERE id_type=ref_nomenclatures.get_id_nomenclature_type('TYPE_SITE') and cd_nomenclature='OEDIC';
DELETE FROM ref_nomenclatures.t_nomenclatures WHERE id_type= ref_nomenclatures.get_id_nomenclature_type('OED_NAT_OBS');
DELETE FROM ref_nomenclatures.t_nomenclatures WHERE id_type= ref_nomenclatures.get_id_nomenclature_type('OED_METEO_VENT');
DELETE FROM ref_nomenclatures.t_nomenclatures WHERE id_type= ref_nomenclatures.get_id_nomenclature_type('OED_METEO_CIEL');
DELETE FROM ref_nomenclatures.bib_nomenclatures_types WHERE  mnemonique in ('OED_NAT_OBS', 'OED_METEO_VENT', 'OED_METEO_CIEL');


SELECT setval('ref_nomenclatures.bib_nomenclatures_types_id_type_seq', COALESCE((SELECT MAX(id_type)+1 FROM ref_nomenclatures.bib_nomenclatures_types), 1), false);


INSERT INTO ref_nomenclatures.bib_nomenclatures_types (mnemonique, label_default, definition_default, label_fr, definition_fr, source) VALUES
('OED_NAT_OBS', 'Nature de l''observation', 'Nature de l''observation', 'Nature de l''observation', 'Nature de l''observation', 'monitoring_oedic'),
('OED_METEO_VENT', 'Description vent meteo', 'Description vent meteo', 'Description vent meteo', 'Description vent meteo', 'monitoring_oedic'),
('OED_METEO_CIEL', 'Description de ciel méteo', 'Description de ciel méteo', 'Description de ciel méteo', 'Description de ciel méteo', 'monitoring_oedic');


SELECT setval('ref_nomenclatures.t_nomenclatures_id_nomenclature_seq', COALESCE((SELECT MAX(id_nomenclature)+1 FROM ref_nomenclatures.t_nomenclatures), 1), false);

-- CREATION NOMENCLATURES
INSERT INTO ref_nomenclatures.t_nomenclatures(
	id_type, cd_nomenclature,
	mnemonique, label_default, label_fr,
	source, statut, id_broader, active
)
VALUES
(ref_nomenclatures.get_id_nomenclature_type('OED_NAT_OBS'),'CRI','Cris','Cris','Cris','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_NAT_OBS'),'SOL','Sol','Observation au sol','Observation au sol','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_NAT_OBS'),'VOL','Vol','Observation en vol','Observation en vol','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_NAT_OBS'),'COU','Couple','Couple','Couple','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_VENT'),'NUL','Nul','Nul','Nul','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_VENT'),'FAI','Faible','Faible','Faible','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_VENT'),'MOD','Modéré','Modéré','Modéré','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_VENT'),'FOR','Fort','Fort','Fort','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_CIEL'),'CLA','Clair','Clair','Clair','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_CIEL'),'MON','Moy. nuag.','Moyennement nuageux','Moyennement nuageux','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('OED_METEO_CIEL'),'NUA','nuag.','Nuageux','Nuageux','monitoring_oedic','Validation en cours', 0, TRUE),
(ref_nomenclatures.get_id_nomenclature_type('TYPE_SITE'),'OEDIC','cir. oed.','Circuit oedicnème','Circuit oedicnème','monitoring_oedic','Validation en cours', 0, TRUE);
