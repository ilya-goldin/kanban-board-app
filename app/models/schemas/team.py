from app.models.schemas.base import BaseSchema


class Team(BaseSchema):
    team_name: str


class TeamInCreate(Team):
    ...


class TeamInResponse(Team):
    id_: int
