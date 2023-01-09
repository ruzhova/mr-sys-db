--------------------------------------------------------
-- назначение: процедура создания музыкального жанра  --
--------------------------------------------------------

create or alter procedure dbo.create_genre (
  @name nvarchar(255),
  @username nvarchar(255)
)
as
begin
  if not exists (select 1 from dbo.genres where name = @name) and exists (select 1 from dbo.users where username = @username)
    begin 
      declare @user_added_id int = (select id from dbo.users where username = @username)
      insert into dbo.genres (name, user_added_id) -- добавляем id пользователя, добавившего жанр --
      values (@name, @user_added_id)
    end
end;
 