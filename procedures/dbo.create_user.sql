--------------------------------------------------
-- назначение: процедура создания пользователя  --
--------------------------------------------------

create procedure dbo.create_user (
  @username nvarchar(255), -- юзернейм --
  @password nvarchar(255), -- пароль --
  @additional_info nvarchar(400) = null -- доп. информация (как статус вконтакте:) )
)
as
if not exists (select 1 from dbo.users where username = @username) -- проверка наличия юзернейма в таблице --
  begin 
    insert into dbo.users(username, password, additional_info, registration_date)
    values (@username, @password, @additional_info, getdate())
  end;