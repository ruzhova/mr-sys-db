----------------------------------------------------------------------
-- назначение: представление для вывода никем не оцененных альбомов --
----------------------------------------------------------------------

create or alter view dbo.albums_not_rated
as
  select 
    a.title 
  from dbo.albums as a
  except
  select 
    a2.title 
  from dbo.user_rating_album as ura 
  join dbo.albums as a2 on a2.id = ura.album_id;

-- вариант 2 - с использованием вложенного подзапроса --
create or alter view dbo.albums_not_rated
as
select 
    a.title 
  from (
    select 
      a2.title 
    from dbo.albums as a2 
    left join dbo.user_rating_album as ura on a2.id = ura.album_id
    where ura.album_id is null
  ) as a;
