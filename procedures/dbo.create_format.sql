-----------------------------------------------------
-- назначение: процедура создания формата альбома  --
-----------------------------------------------------

create or alter procedure dbo.create_format (
  @title nvarchar(20),
  @username nvarchar(255),
  @description nvarchar(255) = null
)
as
if not exists (select 1 from dbo.formats where title = @title) and exists (select 1 from dbo.users where username = @username) and @description is not null
  begin 
    declare @user_added_id int = (select id from dbo.users where username = @username)
    insert into dbo.formats (title, description, user_added_id)
    values (@title, @description, @user_added_id)
  end;  
 