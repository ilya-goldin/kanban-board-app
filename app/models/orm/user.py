from sqlalchemy import Boolean, Column, VARCHAR, Integer, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship

from app.models.orm.base import Base
from app.services import security


class User(Base):
    username = Column(VARCHAR(length=64), index=True, unique=True, nullable=False)
    hashed_password = Column(VARCHAR(length=64), nullable=False)
    salt = Column(VARCHAR(length=64), nullable=False)
    email = Column(VARCHAR(length=255), unique=True, nullable=False)
    first_name = Column(VARCHAR(length=64), nullable=False)
    last_name = Column(VARCHAR(length=64), nullable=False)
    is_active = Column(Boolean(), default=True)
    is_project_manager = Column(Boolean(), default=False)

    team = relationship('Team', secondary='team_user_role')
    role = relationship('Role', secondary='team_user_role')
    project = relationship('Project', secondary='project_user')

    def change_password(self, password: str) -> None:
        self.salt = security.generate_salt()
        self.hashed_password = security.get_password_hash(self.salt + password)

    def check_password(self, password: str) -> bool:
        return security.verify_password(self.salt + password, self.hashed_password)


class Team(Base):
    team_name = Column(VARCHAR(length=64), index=True, unique=True, nullable=False)

    users = relationship('User', secondary='team_user_role')


class Role(Base):
    role_name = Column(VARCHAR(length=64), index=True, unique=True, nullable=False)


class TeamUserRole(Base):
    team_id = Column(Integer, ForeignKey('team.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('user.id'), nullable=False)
    role_id = Column(Integer, ForeignKey('role.id'), nullable=False)

    __tablename__ = 'team_user_role'
    __table_args__ = (UniqueConstraint('team_id', 'user_id', 'role_id'),)
