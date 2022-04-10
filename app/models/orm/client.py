from sqlalchemy import Column, VARCHAR
from sqlalchemy.orm import relationship

from app.models.orm.base import Base


class Client(Base):
    client_name = Column(VARCHAR(64), unique=True, nullable=False)

    project = relationship('Project', back_populates='client')
