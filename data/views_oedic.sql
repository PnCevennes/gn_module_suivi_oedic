-- views_oedic.sql

CREATE OR REPLACE VIEW monitoring_oedic.v_sites_oedic AS
    SELECT s.id_base_site AS id,
        s.base_site_name,
        s.base_site_code,
        s.base_site_description,
        s.geom
        FROM gn_monitoring.t_base_sites AS s
        ORDER BY s.id_base_site DESC;

CREATE OR REPLACE VIEW monitoring_oedic.v_visites_oedic AS
    SELECT v.id_base_visit AS id,
        v.id_base_visit,
        v.comments,
        v.visit_date_min,
        v.visit_date_max,
        vi.nb_ind_obs_min,
        vi.nb_ind_obs_max,
        vi.id_nomenclature_meteo_ciel,
        vi.id_nomenclature_meteo_vent
        FROM gn_monitoring.t_base_visits AS v
        JOIN monitoring_oedic.t_visite_informations vi ON v.id_base_visit = vi.id_base_visit
        JOIN gn_monitoring.t_base_sites s ON v.id_base_site = s.id_base_site
        ORDER BY v.visit_date_min DESC;

CREATE OR REPLACE VIEW monitoring_oedic.v_observations_oedic AS
    SELECT o.id_visite_observation,
        o.id_base_visit,
        o.id_nomenclature_nature_observation,
        o.nb_oiseaux,
        o.date_observation
        FROM monitoring_oedic.t_visite_observations as o
        ORDER BY date_observation
