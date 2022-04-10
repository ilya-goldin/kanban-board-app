from app.models.orm.base import Base

from sqlalchemy import Column, VARCHAR, Integer, ForeignKey, TIMESTAMP, func, Text, Boolean, UniqueConstraint


class Project(Base):
    project_name = Column(VARCHAR(128), unique=True, nullable=False)
    client_id = Column(Integer, ForeignKey('client.id'), nullable=False)
    planned_start_date = Column(TIMESTAMP, default=func.now())
    planned_end_date = Column(TIMESTAMP, default=func.now())
    actual_start_date = Column(TIMESTAMP, default=func.now())
    actual_end_date = Column(TIMESTAMP, default=func.now())
    description = Column(Text)


class ProjectUser(Base):
    project_id = Column(Integer, ForeignKey('project.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('user.id'), nullable=False)
    is_responsible = Column(Boolean, nullable=False)

    __tablename__ = 'project_user'
    __table_args__ = (UniqueConstraint('project_id', 'user_id'),)
