---------------------------------------------------------------------
-- назначение: представление для вывода среднего рейтинга альбомов --
-- с выводом всех артистов этого альбома в строку                  --
---------------------------------------------------------------------

create or alter view dbo.avg_rating
as
with albums_artists as (
  select distinct
    a1.title as album,
    a2.name as artist, 
    avg(ura.rating) as rating
  from dbo.albums as a1 
  join dbo.artist_album as aa on a1.id = aa.album_id 
  join dbo.artists as a2 on a2.id = aa.artist_id 
  join dbo.user_rating_album as ura on ura.album_id = a1.id
  group by a1.title, a2.name
)
select 
  album,
  string_agg(artist, ', ') as artist, 
  cast(avg(rating) as numeric(5,2)) as rating -- преобразование numeric(5,2) для округления --
  from albums_artists
  group by album;
