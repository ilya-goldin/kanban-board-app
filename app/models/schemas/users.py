from typing import List
from pydantic import EmailStr

from app.models.domain.users import User, Team, Role
from app.models.schemas.rwschema import RWSchema


class UserInCreateUpdate(RWSchema):
    username: str
    email: EmailStr
    first_name: str
    last_name: str
    is_project_manager: bool = False
    photo: str | None


class UserInResponse(RWSchema):
    user: User


class UserInResponseTeamRole(UserInResponse):
    teams: List[Team]
    roles: List[Role]
