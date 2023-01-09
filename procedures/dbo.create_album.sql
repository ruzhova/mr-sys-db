---------------------------------------------
-- назначение: процедура создания альбома  --
---------------------------------------------

create or alter procedure dbo.create_album (
  @title nvarchar(200),  -- для упрощения использования БД для пользователя --
  @artist nvarchar(255), -- в процедурах указываются текстовые значения --
  @release_date date,
  @username nvarchar(255), -- в том числе юзернейм, а не id пользователя --
  @description nvarchar(400) = null,
  @genre nvarchar(255) = null,
  @format nvarchar(255) = null
)
as
if exists (select 1 from dbo.users where username = @username) and @artist is not null and @title is not null
begin try
  begin tran
    declare @user_added_id int = (select id from dbo.users where username = @username)
      
    if @genre is not null -- если жанр указан, то выполняем процедуру --
      begin
        exec dbo.create_genre @genre, @username -- если жанр существует, то он не будет создан повторно --
      end
    -- по аналогии с остальными параметрами --
    declare @genre_id int = (select id from dbo.genres where name = @genre)

    if @format is not null
      begin
        exec dbo.create_format @format, @username
      end
    
    declare @format_id int = (select id from dbo.formats where title = @format)
    
    if not exists (select 1 from dbo.artists where name = @artist)
      begin
        exec dbo.create_artist @artist, @username, null
      end
    
    declare @artist_id int = (select id from dbo.artists where name = @artist)
    
    if not exists (select 1 from dbo.albums where title = @title)
      begin 
        insert into dbo.albums (title, genre, format, release_date, description, user_added_id)
        values (@title, @genre_id, @format_id, @release_date, @description, @user_added_id)
      end
    
    declare @album_id int = (select id from dbo.albums where title = @title)
      
    if not exists (select 1 from dbo.artist_album where artist_id  = @artist_id and album_id = @album_id)
      begin 
        insert into dbo.artist_album (artist_id, album_id)
        values (@artist_id, @album_id)
      end
  commit tran
end try
begin catch
  rollback
  select
    error_message()
end catch; 
