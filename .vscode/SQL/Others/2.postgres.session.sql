DROP TABLE IF EXISTS public.tender_data_flexible;
CREATE TABLE public.tender_data_flexible_new (
    subject TEXT,                       -- Предмет тендера
    search_query TEXT,                  -- Поиск
    tender_number TEXT,                 -- Номер тендера
    region TEXT,                        -- Регион
    delivery_location TEXT,             -- Место поставки
    start_price_raw TEXT,               -- Начальнаяцена,руб (Импортируем как текст)
    advance_payment TEXT,               -- Аванс
    bid_security TEXT,                  -- Обеспечение заявки, руб
    contract_security_raw TEXT,         -- Обеспечение контракта, руб (Импортируем как текст)
    customer_name TEXT,                 -- Заказчик
    customer_tin TEXT,                  -- ИНН заказчика
    contact_person TEXT,                -- Контактное лицо
    contact_phone TEXT,                 -- Телефон
    contact_email TEXT,                 -- Электронная почта
    contact_fax TEXT,                   -- Факс
    source_link TEXT,                   -- Ссылка на источник
    eis_number TEXT,                    -- Номер ЕИС
    etp_number TEXT,                    -- Номер ЭТП
    purchase_type TEXT,                 -- Тип закупки
    placement_method TEXT,              -- Способ размещения
    stage TEXT,                         -- Этап
    publication_date TEXT,              -- Дата публикации (Импортируем как текст)
    change_date TEXT,                   -- Дата изменения (Импортируем как текст)
    bidding_end_date TEXT,              -- Дата окончания (Импортируем как текст)
    bidding_end_proposal_date TEXT,     -- Окончание подачи (Импортируем как текст)
    bidding_start_time TEXT,            -- Начало торгов (Импортируем как текст)
    bidding_closing_time TEXT,          -- Завершение торгов (Импортируем как текст)
    results_date TEXT,                  -- Подведение итогов (Импортируем как текст)
    bids_count TEXT,                    -- Количество заявок
    rejected_bids_count TEXT,           -- Количество отклонённых
    min_price_raw TEXT,                 -- Минимальнаязаявленнаяцена (Импортируем как текст)
   winner_name TEXT,                   -- Победитель
    winner_tin TEXT,                    -- ИНН победителя
    winner_phone TEXT,                  -- Телефон победителя
    winner_email TEXT,                  -- Электронная почта победителя
    winner_price_raw TEXT,              -- Ценапобедителя,руб (Импортируем как текст)
    contract_price_raw TEXT,            -- Ценаконтракта,руб (Импортируем как текст)
    tags TEXT,                          -- Метки
    last_comment TEXT,                  -- Последний комментарий
    industries TEXT                     -- Отрасли
);
-- Удаляем старые таблицы для чистого старта
DROP TABLE IF EXISTS public.tender_data_flexible;
DROP TABLE IF EXISTS public.tender_data_new_attempt;

CREATE TABLE public.tender_data_new_attempt (
    col_1 TEXT, col_2 TEXT, col_3 TEXT, col_4 TEXT, col_5 TEXT, 
    col_6 TEXT, col_7 TEXT, col_8 TEXT, col_9 TEXT, col_10 TEXT, 
    col_11 TEXT, col_12 TEXT, col_13 TEXT, col_14 TEXT, col_15 TEXT, 
    col_16 TEXT, col_17 TEXT, col_18 TEXT, col_19 TEXT, col_20 TEXT, 
    col_21 TEXT, col_22 TEXT, col_23 TEXT, col_24 TEXT, col_25 TEXT, 
    col_26 TEXT, col_27 TEXT, col_28 TEXT, col_29 TEXT, col_30 TEXT, 
    col_31 TEXT, col_32 TEXT, col_33 TEXT, col_34 TEXT, col_35 TEXT, 
    col_36 TEXT, col_37 TEXT, col_38 TEXT, col_39 TEXT, col_40 TEXT
);