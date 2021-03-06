file_shp=$1

if [ ! -f "$file_shp" ]
then

echo shp file $1 not found
exit 1;

fi

. ~/geonature/config/settings.ini

echo "DELETE FROM gn_monitoring.t_base_sites WHERE id_nomenclature_type_site = ref_nomenclatures.get_id_nomenclature('TYPE_SITE', 'OEDIC');" | psql -h $db_host -U $user_pg -d $db_name

echo "DROP TABLE IF EXISTS temp;" | psql -h $db_host -U $user_pg -d $db_name

shp2pgsql  -W LATIN1 -s 2154 -D -I $1 temp | psql -h $db_host -U $user_pg -d $db_name

echo "SELECT n_circuit, nom FROM temp;" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO gn_monitoring.t_base_sites(base_site_name, base_site_code, geom, id_nomenclature_type_site) \
    SELECT nom, n_circuit, ST_TRANSFORM(geom, 4326), a.id_nomenclature_type_site \
    FROM temp, ( SELECT id_nomenclature as id_nomenclature_type_site \
        FROM ref_nomenclatures.t_nomenclatures \
        WHERE id_type = ref_nomenclatures.get_id_nomenclature_type('TYPE_SITE') \
            AND cd_nomenclature='OEDIC')a;" | psql -h $db_host -U $user_pg -d $db_name

echo "DROP TABLE IF EXISTS temp;" | psql -h $db_host -U $user_pg -d $db_name

echo "
INSERT INTO gn_monitoring.cor_site_application(id_base_site, id_application)
    SELECT s.id_base_site, a.id_application
        FROM utilisateurs.t_applications as a, gn_monitoring.t_base_sites as s
        WHERE a.nom_application = 'suivi_oedic'
            AND s.id_nomenclature_type_site = ref_nomenclatures.get_id_nomenclature('TYPE_SITE', 'OEDIC');" | psql -h $db_host -U $user_pg -d $db_name
