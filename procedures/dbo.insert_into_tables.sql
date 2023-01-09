------------------------------------------------------
-- назначение: наполнение таблиц в БД               --
-- тестовыми данными для проверки работоспособности --
------------------------------------------------------

create or alter procedure dbo.insert_into_tables
as
begin try
  begin tran
    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'users'
    )
    begin
      if (select count(*) from dbo.users) = 0 -- если есть записи в таблице, то не наполняем ее тестовыми значениями --
        insert into dbo.users(username, password, email, additional_info, registration_date)
        values
        ('admin', 'admin', 'admin12@admin23.ru', 'i am admin of this database', getdate()),
        ('bilbo_baggins', 'theshire', 'bilbo4@6aggins.com', null, dateadd(day, 13, getdate())) -- функция для добавления --
    end                                                                                        -- дней/месяцев/лет к дате --
  
    -- объявление переменной для дальнейшего использования id; --
    -- пишем id, а не top 1 id или max(id), т.к. на уровне таблицы --
    -- есть обеспечение уникальности столбца username --
    declare @admin int = (select top 1 id from dbo.users where username = 'admin')
    declare @bilbo_baggins int = (select top 1 id from dbo.users where username = 'bilbo_baggins')

    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'artists'
    )
    begin
      if (select count(*) from dbo.artists) = 0 
      insert into dbo.artists(name, additional_info, user_added_id)
      values
      ('Arctic Monkeys', null, @admin),
      ('Kate Bush', null,  @admin),
      ('Big Thief', null, @bilbo_baggins),
      ('Tamino', 'talented artist', @admin),
      ('Nagham Zikrayat Orchestra', null, @bilbo_baggins);
    end
  
    declare @arctic_monkeys int = (select id from dbo.artists where name = 'Arctic Monkeys')
    declare @kate_bush int = (select id from dbo.artists where name = 'Kate Bush')
    declare @big_thief int = (select id from dbo.artists where name = 'Big Thief')
    declare @tamino int = (select id from dbo.artists where name = 'Tamino')
    declare @nzo int = (select id from dbo.artists where name = 'Nagham Zikrayat Orchestra')

    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'genres'
    )
    begin
      if (select count(*) from dbo.genres) = 0
      insert into dbo.genres(name, user_added_id)
      values
      ('indie', @admin),
      ('alternative', @bilbo_baggins),
      ('rock', @admin),
      ('pop', @admin);
    end
    
    declare @indie int = (select id from dbo.genres where name = 'indie')
    declare @alternative int = (select id from dbo.genres where name = 'alternative')
    declare @rock int = (select id from dbo.genres where name = 'rock')
    declare @pop int = (select id from dbo.genres where name = 'pop')    

    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'formats'
    )
    begin
      if (select count(*) from dbo.formats) = 0
      insert into dbo.formats(title, description, user_added_id)
      values
      ('LP', 'The LP originally contained space for 23 minutes on each side for a maximum of 46 minutes', @admin),
      ('EP', 'Extended-play albums are typically feature 4-5 tracks with a playtime of 25 to 30 minutes', @admin),
      ('single', 'The single release usually represents an artist’s best single piece of work', @admin),
      ('mixtape', 'The mixtape was a fresh, light-hearted and affordable format for releasing tracks', @admin);
    end
    
    declare @lp int = (select id from dbo.formats where title = 'LP')
    declare @ep int = (select id from dbo.formats where title = 'EP')
    declare @single int = (select id from dbo.formats where title = 'single')
    declare @mixtape int = (select id from dbo.formats where title = 'mixtape')

    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'albums'
    )
    begin
      if (select count(*) from dbo.albums) = 0
      insert into dbo.albums(title, genre, format, release_date, description, user_added_id)
      values
      ('AM', @rock, @ep,'2013-09-09', null, @admin),
      ('Amir',@indie, @lp, '2018-10-19', 'Communion Records LLC', @bilbo_baggins),
      ('Hounds Of Love',@pop, @ep, '1985-08-16', null, @admin),
      ('Dragon New Warm Mountain I Believe In You', @alternative, @lp, '2022-02-11', null, @admin);
    end
    
    declare @am int = (select id from dbo.albums where title = 'AM')
    declare @amir int = (select id from dbo.albums where title = 'Amir')
    declare @hounds int = (select id from dbo.albums where title = 'Hounds Of Love')
    declare @dragon int = (select id from dbo.albums where title = 'Dragon New Warm Mountain I Believe In You')
    
    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'artist_album'
    )
    begin
      if (select count(*) from dbo.artist_album) = 0
      insert into dbo.artist_album(artist_id, album_id)
      values
      (@arctic_monkeys, @am),
      (@tamino, @amir),
      (@nzo, @amir),
      (@kate_bush, @hounds),
      (@big_thief, @dragon);
    end    
 
    if exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'user_rating_album'
    )
    begin
      if (select count(*) from dbo.user_rating_album) = 0
      insert into dbo.user_rating_album(user_id, album_id, rating, comment)
      values
      (@admin, @am, 99.9, 'awesome'),
      (@admin, @amir, 70.55, 'nice, but not very catchy'),
      (@bilbo_baggins, @amir, 100, 'best album ever!'),
      (@admin, @hounds, 85, null);
    end   
  commit tran
end try
begin catch
  rollback
  select error_message()
end catch;
 