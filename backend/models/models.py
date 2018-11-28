from sqlalchemy import ForeignKey

from geonature.utils.env import DB
from geonature.utils.utilssqlalchemy import (
    serializable,
)

from geonature.core.gn_monitoring.models import TBaseVisits, TBaseSite


@serializable
class TVisiteInformation(DB.Model):

    __tablename__ = 't_visite_informations'
    __table_args__ = {'schema': 'monitoring_oedic'}

    id_base_visit = DB.Column(
        DB.Integer,
        ForeignKey(TBaseVisits.id_base_visit),
        primary_key=True
    )
    id_base_visit = DB.Column(DB.Integer, ForeignKey(TBaseSite.id_base_visit))
    nb_ind_obs_min = DB.Column(DB.Integer)
    nb_ind_obs_max = DB.Column(DB.Integer)
    id_nomenclature_meteo_vent = DB.Column(DB.Integer)
    id_nomenclature_meteo_ciel = DB.Column(DB.Integer)
    time_start = DB.Column(DB.DateTime)
    time_end = DB.Column(DB.DateTime)


@serializable
class TVisiteObservation(DB.Model):

    __tablename__ = 't_visite_observations'
    __table_args__ = {'schema': 'monitoring_oedic'}

    id_visite_observation = DB.Column(DB.Integer, primary_key=True)
    id_base_visit = DB.Column(DB.Integer, ForeignKey(TVisiteInformation.id_base_visit))
    time_observation = DB.Column(DB.DateTime)
    nb_oiseaux = DB.Column(DB.Integer)
    remarque_observation = DB.Column(DB.Text)
    id_nomenclature_nature_observation = DB.Column(DB.Integer)


TVisiteInformation.observations = DB.relationship(lambda: TVisiteObservation, cascade="save-update, merge, delete, delete-orphan")
