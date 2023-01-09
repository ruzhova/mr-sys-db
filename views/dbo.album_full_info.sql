------------------------------------------------------------------------
-- назначение: представление для вывода полной информации об альбомах --
------------------------------------------------------------------------

create or alter view dbo.album_full_info
as
  select 
    a1.title as album,
    string_agg(a2.name, ', ') as artist, 
    g.name as genre,
    f.title as format,
    a1.release_date,
    a1.description
  from dbo.albums as a1 
  join dbo.artist_album as aa on a1.id = aa.album_id 
  join dbo.artists as a2 on a2.id = aa.artist_id 
  left join dbo.genres as g on g.id = a1.genre   -- левое внешнее соединение, тк у альбома --
  left join dbo.formats as f on f.id = a1.format -- может не быть жанра и формата --
  group by a1.title, g.name, f.title, a1.release_date, a1.description;
 