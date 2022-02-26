from datetime import datetime

from app.models.domain.rwmodel import RWModel


class Status(RWModel):
    status_name: str
    updated_at: datetime
