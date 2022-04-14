from app.models.common import DateTimeModelMixin, IDModelMixin
from app.models.domain.base import BaseDomainModel


class Team(BaseDomainModel):
    team_name: str


class TeamInDB(IDModelMixin, DateTimeModelMixin, Team):
    ...
