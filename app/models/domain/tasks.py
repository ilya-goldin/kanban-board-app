from datetime import datetime

from app.models.domain.rwmodel import RWModel
from app.models.domain.statuses import Status


class Task(RWModel):
    task_name: str
    project_id: int
    description: str
    start_date: datetime
    end_date: datetime
    current_status: Status
