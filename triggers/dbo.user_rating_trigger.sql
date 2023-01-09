---------------------------------------------
-- назначение: триггер добавления счетчика --
-- общих рейтингов в таблице users         --
---------------------------------------------

create or alter trigger dbo.user_rating_trigger
on dbo.user_rating_album  -- при вставке значений в таблицу --
after insert              -- рейтингов альбомов пользователей --
as
begin 
declare @tmp int = @@rowcount;
-- запрещаем вывод количества строк, на которые влияет триггер -- 
set nocount on;
  -- если количество вставленных строк > 1, то --
  if @tmp > 1
    begin 
      -- update на 1+ строк --
      update dbo.users
      set rating_amount = rating_amount + (select count(*) from inserted where dbo.users.id = inserted.user_id)
      where id in (select user_id FROM inserted)
    end
  else
    -- если количество вставленных строк = 1, то --
    if @tmp = 1
      begin 
        -- update на 1 строку --
        update dbo.users
        set rating_amount = rating_amount + 1
        from inserted 
        where id in (select user_id from inserted)
    end
end