-----------------------------------------------------------
-- назначение: процедура удаления или изменения рейтинга --
-----------------------------------------------------------

create or alter procedure dbo.update_or_delete_rating (
  @username nvarchar(255),
  @album_title nvarchar(200),
  @rating numeric(5,2) = null,  -- если рейтинг is null, то запись удаляется, --
  @comment nvarchar(400) = null -- иначе редактируется --
) 
as
if @username is not null and @album_title is not null and (@rating is null or @rating <= 100)
begin 
  declare @user_id int = (select id from dbo.users where username = @username)
  declare @album_id int = (select id from dbo.albums where title = @album_title)
  if @user_id is not null and @album_id is not null
    if exists (select 1 from dbo.user_rating_album where user_id = @user_id and album_id = @album_id)
      begin
        if @rating is not null
          update dbo.user_rating_album
          set rating = @rating, comment = @comment
          where user_id = @user_id and album_id = @album_id
        if @rating is null
          delete dbo.user_rating_album
          where user_id = @user_id and album_id = @album_id 
      end
end
