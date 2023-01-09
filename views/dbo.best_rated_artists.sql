
/* назначение: представление для вывода лучших по 
   среднему рейтингу исполнителей; в случае, если 
   артисты делят первое место между собой, они 
   будут выведены через запятую                  */

create or alter view dbo.best_rated_artists
as
with ordered_artists as (
  select 
    -- оконная функция для использования агрегатной функции от агрегатной функции --
    max(avg(ura.rating)) over(partition by a.name order by avg(ura.rating) desc) as max_rating,
    dense_rank() over(order by avg(ura.rating) desc) as dr, -- ранк для вывода всех альбомов -- 
    a.name as artist                                        -- с рейтингом = максимальному --
  from dbo.artists as a
  join dbo.artist_album as aa on aa.artist_id = a.id
  join dbo.user_rating_album as ura on ura.album_id = aa.album_id
  group by a.name
)
select string_agg(artist, ', ') as artist, max_rating as rating
from ordered_artists
where dr = 1
group by max_rating;
 