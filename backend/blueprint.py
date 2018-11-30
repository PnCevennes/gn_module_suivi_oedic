'''
point d'entrée du module chiro
'''

# from sqlalchemy.orm.exc import NoResultFound


from flask import Blueprint, request  # , current_app

from geonature.utils.env import get_module_id, DB
from geonature.utils.utilssqlalchemy import json_resp

from geonature.core.gn_monitoring.models import TBaseSites, TBaseVisits

from .models.models import TVisiteObservation


try:
    ID_MODULE = get_module_id('suivi_oedic')
except Exception as e:
    # @TODO gérer erreur lors de l'installation
    ID_MODULE = -1


blueprint = Blueprint('gn_module_suivi_oedic', __name__)

# def base_breadcrumb(type):
#     if type == 'site':
#        return {'id': None, 'link': '#/suivi_chiro/site', 'label': 'Sites'}
#     elif type == 'inventaire':
#         return {'id': None, 'link': '#/suivi_chiro/inventaire', 'label': 'Inventaire'}
#     else:
#         return {}


def load_site(id_site):

    result = DB.session.query(TBaseSites).filter_by(id_base_site=id_site).first()

    if not result:

        return None

    return [
        {
            'id': id_site,
            'link': '#/g/suivi_chiro/site/%s' % id_site,
            'label': result.base_site_code + '-' + result.base_site_name
        }
    ]


def load_visite(id_visit):

        visit = DB.session.query(TBaseVisits).filter_by(id_base_visit=id_visit).first()

        if not visit:

            return None

        return [
            {
                'id': id_visit,
                'link': '#/g/suivi_chiro/visit/%s' % id_visit,
                'label': 'Visite du ' + str(visit.visit_date_min)
            }
        ]


def load_observation(id_visite_observation):

        data = DB.session.query(TVisiteObservation).filter(TVisiteObservation.id_visite_observation == id_visite_observation).first()

        print(data)

        if not data:

            return None

        return [
            {
                'id': id_visite_observation,
                'link': '#/g/suivi_chiro/observation/%s' % id_visite_observation,
                'label': ""
            }
        ]

# def load_visite(id_visite):
#     result = DB.session.query(
#         TBaseVisits
#     ).filter_by(id_base_visit=id_visite).one()

#     bread = load_site(result.id_base_site)

#     if len(bread) == 1:
#         link = "inventaire"
#     else:
#         link = "observation"
#     bread.append({
#         'id': id_visite,
#         'link': '#/suivi_chiro/{}/{}'.format(link, id_visite),
#         'label': str(result.visit_date_min)
#     })
#     return bread


# def load_taxon(id_taxon):
#     result = DB.session.query(
#         ContactTaxon
#     ).filter_by(id_contact_taxon=id_taxon).one()

#     bread = load_visite(result.id_base_visit)
#     bread.append({
#         'id': id_taxon,
#         'link': '#/suivi_chiro/taxons/%s' % id_taxon,
#         'label': str(result.nom_complet)
#     })
#     return bread


# def load_biometrie(id_biometrie):
#     result = DB.session.query(
#         Biometrie
#     ).filter_by(id_biometrie=id_biometrie).one()

#     bread = load_taxon(result.id_contact_taxon)
#     bread.append({
#         'id': id_biometrie,
#         'link': '#/suivi_chiro/biometrie/%s' % id_biometrie,
#         'label': str(result.id_biometrie)
#     })
#     return bread


# @blueprint.route('/config/<string:view>/<string:type>', defaults={'id_obj': None})
# @blueprint.route('/config/<string:view>/<string:type>/<string:id_obj>')
# @json_resp
# def config(view, type, id_obj):

#     if view == 'site':

#             if not id_obj:

#                 # return {'id': None, 'link': '#/g/suivi_oedic/site/list', 'label': 'Sites'}
#                 return {'id': None, 'link': '/config', 'label': 'Sites'}

#             return load_site(id_obj)

#     if not id_obj:

#         return None

#     if view == 'visite':

#         return load_visite(id_obj)

#     return view


@blueprint.route('/config/breadcrumb')
@json_resp
def breadcrumb():
    view = request.args.get('view')
    id_obj = request.args.get('id', None)

    if view == 'site':

        if not id_obj:

            return {'id': None, 'link': '#/suivi_oedic/site', 'label': 'Sites'}

        return load_site(id_obj)

    if not id_obj:

        return None

    if view == 'visite':

        return load_visite(id_obj)

    if view == 'observation':

        return load_observation(id_obj)

    #     out = []

#     if id_obj:
#         if view == 'site':
#             out = load_site(id_obj)
#         elif view == 'observation' or view == 'inventaire':
#             out = load_visite(id_obj)
#         elif view == 'taxons':
#             out = load_taxon(id_obj)
#         elif view == 'biometrie':
#             out = load_biometrie(id_obj)
#     else:
#         out = [base_breadcrumb(view)]

    return


from .routes import (
    site,
    visite,
    observation
    # contact_taxon,
    # biometrie
)
