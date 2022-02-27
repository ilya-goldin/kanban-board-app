from app.db.errors import EntityDoesNotExist
from app.db.queries.queries import queries
from app.db.repositories.base import BaseRepository
from app.models.domain.users import User, UserInDB


class UsersRepository(BaseRepository):
    async def get_user_by_email(self, *, email: str) -> UserInDB:
        user_row = await queries.get_user_by_email(self.connection, email=email)
        if user_row:
            return UserInDB(**user_row)

        raise EntityDoesNotExist("user with email {0} does not exist".format(email))

    async def get_user_by_username(self, *, username: str) -> UserInDB:
        user_row = await queries.get_user_by_username(
            self.connection,
            username=username,
        )
        if user_row:
            return UserInDB(**user_row)

        raise EntityDoesNotExist(
            "user with username {0} does not exist".format(username),
        )

    async def create_user(
        self,
        *,
        username: str,
        email: str,
        first_name: str,
        last_name: str,
        is_project_manager: bool,
        photo: bytes | None
    ) -> User:
        user = User(
            username=username,
            email=email,
            first_name=first_name,
            last_name=last_name,
            is_project_manager=is_project_manager,
            photo=photo
        )

        async with self.connection.transaction():
            user_row = await queries.create_new_user(
                self.connection,
                username=user.username,
                email=user.email,
                first_name=user.first_name,
                last_name=user.last_name,
                is_project_manager=user.is_project_manager,
                photo=user.photo
            )

        return user.copy(update=dict(user_row))

    async def update_user(
        self,
        *,
        user: User,
        username: str,
        email: str,
        first_name: str,
        last_name: str,
        is_project_manager: bool,
        photo: bytes | None
    ) -> User:
        user_in_db = await self.get_user_by_username(username=user.username)

        user_in_db.username = username or user_in_db.username
        user_in_db.email = email or user_in_db.email
        user_in_db.first_name = first_name or user_in_db.first_name
        user_in_db.last_name = last_name or user_in_db.last_name
        user_in_db.is_project_manager = is_project_manager or user_in_db.is_project_manager
        user_in_db.photo = photo or user_in_db.photo

        async with self.connection.transaction():
            user_in_db.updated_at = await queries.update_user_by_username(
                self.connection,
                username=user.username,
                new_username=user_in_db.username,
                new_email=user_in_db.email,
                new_first_name=user_in_db.first_name,
                new_last_name=user_in_db.last_name,
                new_is_project_manager=user_in_db.is_project_manager,
                new_photo=user_in_db.photo,
            )

        return user_in_db
