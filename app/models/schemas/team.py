from pydantic import BaseModel


class Team(BaseModel):
    id: int
    team_name = str


class TeamOut(Team):
    class Config:
        orm_mode = True
