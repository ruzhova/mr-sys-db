---------------------------------------
-- назначение: создание таблиц в БД  --
---------------------------------------

create or alter procedure dbo.tables_creation 
as 
begin try -- блок try-catch --
  begin tran -- начало транзакции --
    if not exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'users'
    )
    begin
      create table dbo.users(
        id int not null identity(1,1),  -- identity - тип автоматической генерации значений (от 1; шаг 1) --
        username nvarchar(255) not null,
        password nvarchar(255) not null,
        email nvarchar(255) not null,
        additional_info nvarchar(400) null,
        registration_date date not null,
        rating_amount int default 0,
        constraint username_unique unique (username), -- уникальные значения --
        constraint users_pk primary key (id), -- первичный ключ --
        constraint email_unique unique (email), -- уникальные значения --
        constraint users_email check (email like '%[a-z0-9][@][a-z0-9]%[.][a-z]%') -- регулярное выражение --
      );
    end  

    if not exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'artists'
    )
	  begin
	    create table dbo.artists(
        id int not null identity(1,1),
        name nvarchar(255) not null,
        additional_info nvarchar(400) null,
        user_added_id int null,
        constraint artist_pk primary key (id), 
        constraint artist_name_unique unique (name),
        constraint user_added_artist_fk foreign key (user_added_id) -- внешний ключ --
        references users (id) on delete set null -- при удалении ставим null, чтобы заведенные артисты остались --
      );
    end

    if not exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'genres'
    )
    begin
      create table dbo.genres(
        id int not null identity(1,1),
        name nvarchar(255) not null,
        user_added_id int null,
        constraint genre_pk primary key (id),
        constraint genre_name_unique unique (name),
        constraint user_added_genre_fk foreign key (user_added_id) 
        references users (id) on delete set null
      );
    end    

    if not exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'formats'
    )
    begin
      create table dbo.formats(
        id int not null identity(1,1), 
        title nvarchar(20) not null,
        description nvarchar(255) null,
        user_added_id int null,
        constraint format_unique unique (title),
        constraint formats_pk primary key (id),
        constraint user_added_format_fk foreign key (user_added_id) 
        references users (id) on delete set null
      );
    end        
    
	if not exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'albums'
    )
	begin
	  create table dbo.albums(
        id int not null identity(1, 1),
        title nvarchar(200) not null,
        genre int null,
        format int null,
        release_date date null,
        description nvarchar(400) null,
        user_added_id int null,
        constraint album_title_unique unique (title),
        constraint album_pk primary key (id),
        constraint user_added_album_fk foreign key (user_added_id) 
        references users (id) on delete set null
      );
    end
    
    alter table dbo.albums -- изменение таблицы --
    add 
    constraint fk_album_genre foreign key (genre) references genres (id),
    constraint fk_album_format foreign key (format) references formats (id);

	if not exists (
	  select 1
	  from INFORMATION_SCHEMA.TABLES
	  where TABLE_NAME = 'artist_album'
	)
	begin -- таблица для связи артиста с альбомом. у одного альбома может быть много исполнителей, --
	  create table dbo.artist_album( -- а у одного исполнителя - много альбомов --
		artist_id int not null,
		album_id int not null,
		constraint fk_art_alb foreign key (artist_id) -- внешний ключ --
        references artists (id) on delete cascade, 
		constraint fk_alb_art foreign key (album_id) --  при удалении записи в таблице альбомов --
        references albums (id) on delete cascade, -- удаляем и связку с артистом --
		constraint artist_album_pk primary key (artist_id, album_id) -- составной первичный ключ --
      );
    end

    if not exists (
      select 1
      from INFORMATION_SCHEMA.TABLES
      where TABLE_NAME = 'user_rating_album'
    )
    begin
      create table dbo.user_rating_album(
        user_id int not null,
        album_id int not null,
        rating numeric(5,2) not null,
        comment nvarchar(400) null,
        constraint fk_art foreign key (user_id) references users (id) on delete cascade,
        constraint fk_alb foreign key (album_id) references albums (id) on delete cascade,
        constraint rating_less_than_100 check (rating <= 100), -- проверка, что рейтинг не более 100 --
        constraint user_rated_album_pk primary key (user_id, album_id)
      );
    end    

  commit tran
end try
begin catch -- в случае возникновения ошибки --
  rollback -- откат транзакции --
  select error_message() -- вывод сообщения об ошибке --
end catch;
 