----------------------------------------------
-- назначение: процедура создания рейтинга  --
----------------------------------------------

create or alter procedure dbo.create_rating (
  @username nvarchar(255),
  @album_title nvarchar(200),
  @rating numeric(5,2),
  @comment nvarchar(400) = null
) 
as
if @username is not null and @album_title is not null and @rating is not null and @rating <= 100
begin 
  declare @user_id int = (select id from dbo.users where username = @username)
  declare @album_id int = (select id from dbo.albums where title = @album_title)
  if @user_id is not null and @album_id is not null
    begin
      if not exists (select 1 from dbo.user_rating_album where user_id = @user_id and album_id = @album_id)
      begin
        insert into dbo.user_rating_album (user_id, album_id, rating, comment)
        values (@user_id, @album_id, @rating, @comment)
      end
    end
end
 