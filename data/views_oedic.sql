-- views_oedic.sql
DROP VIEW IF EXISTS monitoring_oedic.v_sites_oedic;

CREATE OR REPLACE VIEW monitoring_oedic.v_sites_oedic AS
    SELECT s.id_base_site AS id,
        s.id_base_site,
        s.base_site_name,
        LPAD(s.base_site_code, 2, '0') as base_site_code,
        s.base_site_description,
        s.id_nomenclature_type_site,
        s.geom,
        ( SELECT max(v.visit_date_min) AS max
           FROM gn_monitoring.t_base_visits v
          WHERE v.id_base_site = s.id_base_site) AS dern_obs,
        ( SELECT count(*) AS count
           FROM gn_monitoring.t_base_visits v
          WHERE v.id_base_site = s.id_base_site) AS nb_obs,
        ROUND(ST_LENGTH(geom::geography)/1000*10)/10 as longueur
        FROM gn_monitoring.t_base_sites AS s
        JOIN gn_monitoring.cor_site_application csa ON s.id_base_site = csa.id_base_site AND csa.id_application =  (SELECT id_application FROM utilisateurs.t_applications WHERE nom_application = 'suivi_oedic')
        ORDER BY s.id_base_site DESC;


DROP VIEW IF EXISTS monitoring_oedic.v_visites_oedic;

CREATE OR REPLACE VIEW monitoring_oedic.v_visites_oedic AS
    SELECT v.id_base_visit AS id,
        v.id_base_visit,
        v.comments,
        v.visit_date_min,
        v.visit_date_max,
        vi.time_start,
        vi.time_end,
        vi.nb_ind_obs_min,
        vi.nb_ind_obs_max,
        vi.id_nomenclature_meteo_ciel,
        vi.id_nomenclature_meteo_vent,
        s.base_site_name,
        -- (SELECT STRING_AGG(u, ', ')
        (SELECT ARRAY_AGG(u)
            FROM
            (
            SELECT CONCAT(r.nom_role, ' ',r.prenom_role) as u, v.id_base_visit
                FROM utilisateurs.t_roles r,
                    gn_monitoring.cor_visit_observer cvo
                WHERE r.id_role = cvo.id_role
                    AND v.id_base_visit = cvo.id_base_visit
            )a
            GROUP BY id_base_visit) as observateurs
        FROM gn_monitoring.t_base_visits AS v
        JOIN monitoring_oedic.t_visite_informations vi ON v.id_base_visit = vi.id_base_visit
        JOIN gn_monitoring.t_base_sites s ON v.id_base_site = s.id_base_site
        ORDER BY v.visit_date_min DESC;


DROP VIEW IF EXISTS monitoring_oedic.v_observations_oedic;

CREATE OR REPLACE VIEW monitoring_oedic.v_observations_oedic AS
    SELECT o.id_visite_observation as id,
        o.id_visite_observation,
        o.id_base_visit,
        o.id_nomenclature_nature_observation,
        o.nb_oiseaux,
        o.time_observation,
        o.remarque_observation
        FROM monitoring_oedic.t_visite_observations as o
        ORDER BY time_observation;
