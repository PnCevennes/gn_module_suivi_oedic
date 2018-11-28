# data_sample.sh

. ~/geonature/config/settings.ini


echo "
DELETE FROM gn_monitoring.t_base_visits
    WHERE comments = 'test_sample';" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO gn_monitoring.t_base_visits(visit_date_min, visit_date_max, comments,
    id_digitiser, id_base_site)
    SELECT '2018-01-07', '2018-01-07', 'test_sample',
        r.id_role, s.id_base_site
        FROM utilisateurs.t_roles r, gn_monitoring.t_base_sites s
        WHERE r.identifiant = 'admin'
            AND s.base_site_code = '28'
;" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO gn_monitoring.cor_visit_observer(id_base_visit, id_role)
    SELECT v.id_base_visit, r.id_role
        FROM utilisateurs.t_roles r, gn_monitoring.t_base_visits v
        WHERE r.identifiant = 'admin'
            AND v.comments = 'test_sample'
;" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO gn_monitoring.cor_visit_observer(id_base_visit, id_role)
    SELECT v.id_base_visit, r.id_role
        FROM utilisateurs.t_roles r, gn_monitoring.t_base_visits v
        WHERE r.identifiant = 'agent'
            AND v.comments = 'test_sample'
;" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO monitoring_oedic.t_visite_informations(
    time_start,
    time_end,
    id_base_visit,
    id_nomenclature_meteo_ciel,
    id_nomenclature_meteo_vent,
    nb_ind_obs_min,
    nb_ind_obs_max
    )
    SELECT
        '2018-01-07 20:00:00',
        '2018-01-07 23:00:00',
        v.id_base_visit,
        ref_nomenclatures.get_id_nomenclature('OED_METEO_CIEL', 'CLA'),
        ref_nomenclatures.get_id_nomenclature('OED_METEO_VENT', 'FAI'),
        1,
        4
        FROM gn_monitoring.t_base_visits v
        WHERE v.comments = 'test_sample'
;" | psql -h $db_host -U $user_pg -d $db_name


echo "
INSERT INTO monitoring_oedic.t_visite_observations(
    id_base_visit,
    time_observation,
    id_nomenclature_nature_observation,
    nb_oiseaux,
    remarque_observation
    )
    SELECT
        v.id_base_visit,
        '2018-01-07 21:00:00',
        ref_nomenclatures.get_id_nomenclature('OED_NAT_OBS', 'CRI'),
        1,
        'Un très beau spécimen!!!'
        FROM gn_monitoring.t_base_visits v
        WHERE v.comments = 'test_sample'
;" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO monitoring_oedic.t_visite_observations(
    id_base_visit,
    time_observation,
    id_nomenclature_nature_observation,
    nb_oiseaux,
    remarque_observation
    )
    SELECT
        v.id_base_visit,
        '2018-01-07 21:30:00',
        ref_nomenclatures.get_id_nomenclature('OED_NAT_OBS', 'CRI'),
        2,
        'Un très beau couple!!!'
        FROM gn_monitoring.t_base_visits v
        WHERE v.comments = 'test_sample'
;" | psql -h $db_host -U $user_pg -d $db_name
