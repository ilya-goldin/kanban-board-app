from pydantic import BaseModel


class Role(BaseModel):
    id: int
    role_name = str


class RoleOut(Role):
    class Config:
        orm_mode = True
