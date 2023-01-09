------------------------------------------------------
-- назначение: вывод списка альбомов,               --
-- которым пользователь поставил наивысший рейтинг  --
------------------------------------------------------

create or alter function dbo.favorite_album(
  @username nvarchar(255)
)
returns @albums table (
  album nvarchar(200) not null
)
as 
begin 
  declare @user_id int = (select id from dbo.users where username = @username)
  
  insert into @albums (album)
  select distinct a1.title
  from dbo.user_rating_album ura join dbo.albums a1 on ura.album_id = a1.id 
  where ura.user_id = @user_id 
  and ura.rating in (select max(rating) from dbo.user_rating_album where user_id = @user_id);

  return;
end
