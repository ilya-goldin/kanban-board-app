from app.models.common import DateTimeModelMixin, IDModelMixin
from app.models.domain.rwmodel import RWModel


class User(RWModel):
    username: str
    email: str
    first_name: str
    last_name: str
    is_project_manager: bool = False
    photo: str | None


class UserInDB(IDModelMixin, DateTimeModelMixin, User):
    ...


class Team(RWModel):
    id: int
    team_name: str


class TeamInDB(IDModelMixin, DateTimeModelMixin, Team):
    ...


class Role(RWModel):
    id: int
    role_name: str


class RoleInDB(IDModelMixin, DateTimeModelMixin, Role):
    ...
