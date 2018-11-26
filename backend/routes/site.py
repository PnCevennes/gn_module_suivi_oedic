from pypnusershub import routes as fnauth

from ..blueprint import blueprint

from geonature.utils.utilssqlalchemy import json_resp, GenericQuery

from flask import request

from geonature.utils.env import DB


@blueprint.route('/sites', methods=['GET'])
@fnauth.check_auth(3)
@json_resp
def get_sites_chiro():
    '''
    Retourne la liste des sites chiro
    '''
    limit = int(request.args.get('limit', 1000))
    offset = int(request.args.get('offset', 0))

    data = GenericQuery(
        DB.session, 'v_sites_chiro', 'monitoring_chiro', "geom",
        {}, limit, offset
    ).return_query()

    data["total"] = data["total_filtered"]
    return data
