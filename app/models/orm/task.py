from app.models.orm.base import Base

from sqlalchemy import Column, VARCHAR, Integer, ForeignKey, Text, TIMESTAMP


class Task(Base):
    task_name = Column(VARCHAR(255), nullable=False)
    project_id = Column(Integer, ForeignKey('project.id'), nullable=False)
    description = Column(Text)
    start_date = Column(TIMESTAMP)
    end_data = Column(TIMESTAMP)


class Status(Base):
    status_name = Column(VARCHAR(128), unique=True, nullable=False)


class TaskStatus(Base):
    task_id = Column(Integer, ForeignKey('task.id'), nullable=False)
    status_id = Column(Integer, ForeignKey('status.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('user.id'), nullable=False)
