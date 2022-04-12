from app.models.schemas.base import BaseSchema


class Team(BaseSchema):
    id: int
    team_name = str


class TeamOut(Team):
    class Config:
        orm_mode = True
