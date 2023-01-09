-------------------------------------------------
-- назначение: процедура создания исполнителя  --
-------------------------------------------------

create or alter procedure dbo.create_artist (
  @name nvarchar(255),
  @username nvarchar(255),
  @additional_info nvarchar(400) = null
)
as
if not exists (select 1 from dbo.artists where name = @name) and exists (select 1 from dbo.users where username = @username)
  begin 
    declare @user_added_id int = (select id from dbo.users where username = @username)
    insert into dbo.artists(name, additional_info, user_added_id)
    values (@name, @additional_info, @user_added_id)
  end;