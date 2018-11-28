from flask import request

from geonature.utils.env import DB
from geonature.utils.utilssqlalchemy import json_resp, GenericQuery

from pypnusershub import routes as fnauth

from ..blueprint import blueprint


@blueprint.route('/observations/<id_base_visit>', methods=['GET'])
@fnauth.check_auth(3)
@json_resp
def get_all_observations_oedic(id_base_visit):

    limit = int(request.args.get('limit', 1000))
    offset = int(request.args.get('offset', 0))

    data = GenericQuery(
        DB.session, 'v_observations_oedic', 'monitoring_oedic', None,
        {"id_base_visit": id_base_visit}, limit, offset
    ).return_query()

    data["total"] = data["total_filtered"]

    return data


@blueprint.route('/observation/<id_visite_observation>', methods=['GET'])
@fnauth.check_auth(3)
@json_resp
def get_observation_oedic(id_visite_observation):

    limit = int(request.args.get('limit', 1000))
    offset = int(request.args.get('offset', 0))

    data = GenericQuery(
        DB.session, 'v_observations_oedic', 'monitoring_oedic', None,
        {"id_visite_observation": id_visite_observation}, limit, offset
    ).return_query()

    data["total"] = data["total_filtered"]

    return data
