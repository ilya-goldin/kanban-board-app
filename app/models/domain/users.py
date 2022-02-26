from datetime import datetime

from app.models.domain.rwmodel import RWModel
from app.services import security


class User(RWModel):
    username: str
    email: str
    created_at: datetime
    last_login: datetime
    first_name: str
    last_name: str
    is_project_manager: bool
    photo: str | None
    team: str
    role: str


class UserInDB(User):
    salt: str = ""
    hashed_password: str = ""

    def check_password(self, password: str) -> bool:
        return security.verify_password(self.salt + password, self.hashed_password)

    def change_password(self, password: str) -> None:
        self.salt = security.generate_salt()
        self.hashed_password = security.get_password_hash(self.salt + password)
