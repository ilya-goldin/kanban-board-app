from pydantic import EmailStr

from app.models.schemas.base import BaseSchema


class UserBase(BaseSchema):
    username: str
    email: EmailStr | None = None
    first_name: str
    last_name: str


class UserCreate(UserBase):
    email: EmailStr
    password: str


class UserUpdate(UserBase):
    password: str | None = None


class UserOut(UserBase):
    pass
