from typing import List
from datetime import datetime

from app.models.domain.rwmodel import RWModel
from app.models.domain.tasks import Task
from app.models.domain.users import User


class Project(RWModel):
    project_name: str
    client: str
    planned_start_date: datetime
    planned_end_date: datetime
    actual_start_date: datetime
    actual_end_date: datetime
    description: str
    users: List[User]
    tasks: List[Task]
