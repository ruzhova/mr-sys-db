---------------------------------------------------------
-- назначение: вывести наименования альбомов, средний  --
-- рейтинг которых больше 80-ти (must hear)            --
---------------------------------------------------------

create or alter view avg_more_than_80 
as
  select 
    avg(ura.rating) as average_rating,
    a.title
  from dbo.user_rating_album as ura 
  join dbo.albums as a on a.id = ura.album_id 
  group by a.title
  having avg(ura.rating) > 80;
 