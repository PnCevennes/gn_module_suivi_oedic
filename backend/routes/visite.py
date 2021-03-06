from flask import request

from geonature.utils.env import DB
from geonature.utils.utilssqlalchemy import json_resp, GenericQuery

from pypnusershub import routes as fnauth

from ..blueprint import blueprint


@blueprint.route('/visites/<id_base_site>', methods=['GET'])
@fnauth.check_auth(3)
@json_resp
def get_all_visites_oedic(id_base_site):

    limit = int(request.args.get('limit', 1000))
    offset = int(request.args.get('offset', 0))

    data = GenericQuery(
        DB.session, 'v_visites_oedic', 'monitoring_oedic', None,
        {"id_base_site": id_base_site}, limit, offset
    ).return_query()

    data["total"] = data["total_filtered"]

    return data


@blueprint.route('/visite/<id_base_visit>', methods=['GET'])
@fnauth.check_auth(3)
@json_resp
def get_visite_oedic(id_base_visit):

    limit = int(request.args.get('limit', 1000))
    offset = int(request.args.get('offset', 0))

    data = GenericQuery(
        DB.session, 'v_visites_oedic', 'monitoring_oedic', None,
        {"id_base_visit": id_base_visit}, limit, offset
    ).return_query()

    if not data.get('items', None):

        return None

    out = data['items'][0]

    return out
