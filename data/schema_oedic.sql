-- CREATE OR REPLACE VIEW public.active_locks AS 
--  SELECT t.schemaname,
--     t.relname,
--     l.locktype,
--     l.page,
--     l.virtualtransaction,
--     l.pid,
--     l.mode,
--     l.granted
--    FROM pg_locks l
--    JOIN pg_stat_all_tables t ON l.relation = t.relid
--   WHERE t.schemaname <> 'pg_toast'::name AND t.schemaname <> 'pg_catalog'::name
--   ORDER BY t.schemaname, t.relname;

-- SELECT pg_terminate_backend(pid) FROM active_locks;


DROP SCHEMA IF EXISTS monitoring_oedic CASCADE;

CREATE SCHEMA monitoring_oedic;


CREATE TABLE  monitoring_oedic.t_visite_informations
(
	id_base_visit INTEGER NOT NULL,
	nb_ind_obs_min INTEGER,
	nb_ind_obs_max INTEGER,
	id_nomenclature_meteo_vent INTEGER NOT NULL,
  id_nomenclature_meteo_ciel INTEGER NOT NULL,
  time_start TIME NOT NULL,
  time_end TIME NOT NULL,

  uuid_oedic_t_visite_informations UUID DEFAULT public.uuid_generate_v4(),


	CONSTRAINT t_visite_informations_pkey PRIMARY KEY (id_base_visit),

  CONSTRAINT t_visite_informations_id_base_visit_fkey FOREIGN KEY (id_base_visit)
    	REFERENCES gn_monitoring.t_base_visits (id_base_visit) MATCH SIMPLE
    	ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT t_visite_informations_id_nomenclature_meteo_vent_fkey FOREIGN KEY (id_nomenclature_meteo_vent)
    	REFERENCES ref_nomenclatures.t_nomenclatures (id_nomenclature) MATCH SIMPLE
    	ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT check_t_visite_informations_meteo_vent CHECK (ref_nomenclatures.check_nomenclature_type_by_mnemonique(
        id_nomenclature_meteo_vent, 'OED_METEO_VENT')) NOT VALID,

   CONSTRAINT t_visite_informations_id_nomenclature_meteo_ciel_fkey FOREIGN KEY (id_nomenclature_meteo_ciel)
    	REFERENCES ref_nomenclatures.t_nomenclatures (id_nomenclature) MATCH SIMPLE
    	ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT check_t_visite_informations_meteo_ciel CHECK (ref_nomenclatures.check_nomenclature_type_by_mnemonique(
        id_nomenclature_meteo_ciel, 'OED_METEO_CIEL')) NOT VALID
);


CREATE TABLE monitoring_oedic.t_visite_observations
(
	id_visite_observation SERIAL NOT NULL,
	id_base_visit INTEGER NOT NULL,
	time_observation TIME NOT NULL,
	nb_oiseaux INTEGER NOT NULL,
	remarque_observation text,
	id_nomenclature_nature_observation INTEGER,

  uuid_oedic_t_visite_observations UUID DEFAULT public.uuid_generate_v4(),

	CONSTRAINT t_visite_observation_pkey PRIMARY KEY (id_visite_observation),

  CONSTRAINT t_visite_observations_id_base_visit_fkey FOREIGN KEY (id_base_visit)
    	REFERENCES gn_monitoring.t_base_visits (id_base_visit) MATCH SIMPLE
    	ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT t_visite_observations_id_nomenclature_nature_observation_fkey FOREIGN KEY (id_nomenclature_nature_observation)
    	REFERENCES ref_nomenclatures.t_nomenclatures (id_nomenclature) MATCH SIMPLE
    	ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT check_t_visite_observations_nature_observation CHECK (ref_nomenclatures.check_nomenclature_type_by_mnemonique(id_nomenclature_nature_observation, 'OED_NAT_OBS')) NOT VALID

);
