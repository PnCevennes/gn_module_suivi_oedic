from flask import request

from geonature.utils.env import DB
from geonature.utils.utilssqlalchemy import json_resp, GenericQuery

from pypnusershub import routes as fnauth

from ..blueprint import blueprint

from ..models.models import TVisiteObservation

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

    print(data)

    if data:

        data = data['items'][0]

    return data


@blueprint.route('/observation', defaults={'id_visite_observation': 0}, methods=['POST', 'PUT'])
@blueprint.route('/observation/<id_visite_observation>', methods=['POST', 'PUT'])
@fnauth.check_auth(3)
@json_resp
def edit_observation_oedic(id_visite_observation):

    data = request.get_json()

    obs = None

    if id_visite_observation:

        obs = DB.session.query(TVisiteObservation).filter(TVisiteObservation.id_visite_observation == id_visite_observation).first()

        if not obs:

            return None

    else:

        obs = TVisiteObservation()
        DB.session.add(obs)

    for field in data:
            if hasattr(obs, field):
                setattr(obs, field, data[field])

    DB.session.commit()

    return data
