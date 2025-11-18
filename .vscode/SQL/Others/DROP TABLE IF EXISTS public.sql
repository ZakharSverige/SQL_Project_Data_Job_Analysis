DROP TABLE IF EXISTS public.tender_data_clean;
CREATE TABLE public.tender_data_clean (
    subject TEXT,                       
    tender_number VARCHAR(50),          
    region VARCHAR(100),                
    delivery_location TEXT,             
    start_price NUMERIC(15, 2),         
    customer_name TEXT,                 
    customer_tin VARCHAR(50),           -- УВЕЛИЧЕНО до 50
    contact_person TEXT,                
    contact_phone TEXT,                 
    contact_email TEXT,                 
    source_link TEXT,                   
    placement_method VARCHAR(100),      
    stage VARCHAR(50),                  
    publication_date TIMESTAMP,         
    change_date TIMESTAMP,              
    bidding_end_date TIMESTAMP,         
    bidding_end_proposal_date TIMESTAMP,
    bidding_start_time TIMESTAMP,       
    bidding_closing_time TIMESTAMP,     
    results_date TIMESTAMP,             
    bids_count INTEGER,                 
    rejected_bids_count INTEGER,        
    min_price_offered NUMERIC(15, 2),   
    winner_name TEXT,                   
    winner_tin VARCHAR(50),             -- УВЕЛИЧЕНО до 50
    winner_phone TEXT,                  
    winner_email TEXT,                  
    winner_price NUMERIC(15, 2),        
    contract_price_final NUMERIC(15, 2),
    tags TEXT,                          
    last_comment TEXT,                  
    industries TEXT                     
);
INSERT INTO public.tender_data_clean
SELECT
    -- Текстовые столбцы
    subject,
    tender_number,
    region,
    delivery_location,
    
    -- Числовые столбцы: Начальная цена
    NULLIF(TRIM(REPLACE(SPLIT_PART(start_price_raw, CHR(10), 1), ' ', '')), '')::NUMERIC,
    
    -- Текстовые столбцы
    customer_name,
    customer_tin,
    contact_person,
    contact_phone,
    contact_email,
    source_link,
    placement_method,
    stage,
    
    -- Столбцы с датами (без изменений)
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(publication_date), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(publication_date), 'DD.MM.YYYY'), NULL)),
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(change_date), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(change_date), 'DD.MM.YYYY'), NULL)),
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(bidding_end_date), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(bidding_end_date), 'DD.MM.YYYY'), NULL)),
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(bidding_end_proposal_date), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(bidding_end_proposal_date), 'DD.MM.YYYY'), NULL)),
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(bidding_start_time), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(bidding_start_time), 'DD.MM.YYYY'), NULL)),
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(bidding_closing_time), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(bidding_closing_time), 'DD.MM.YYYY'), NULL)),
    COALESCE(NULLIF(TO_TIMESTAMP(TRIM(results_date), 'DD.MM.YYYY HH24:MI:SS'), NULL), NULLIF(TO_TIMESTAMP(TRIM(results_date), 'DD.MM.YYYY'), NULL)),
    
    -- Столбцы с количеством (без изменений)
    NULLIF(TRIM(bids_count), '')::INTEGER,
    NULLIF(TRIM(rejected_bids_count), '')::INTEGER,
    
    -- Остальные числовые столбцы (Выделение первого числа и очистка от пробелов)
    NULLIF(TRIM(REPLACE(SPLIT_PART(min_price_raw, CHR(10), 1), ' ', '')), '')::NUMERIC,
    winner_name,
    winner_tin,
    winner_phone,
    winner_email,
    NULLIF(TRIM(REPLACE(SPLIT_PART(winner_price_raw, CHR(10), 1), ' ', '')), '')::NUMERIC, -- <-- Исправлено
    NULLIF(TRIM(REPLACE(SPLIT_PART(contract_price_raw, CHR(10), 1), ' ', '')), '')::NUMERIC,
    tags,                          
    last_comment,                  
    industries                     
FROM 
    public.tender_data_flexible_new;
SELECT *
FROM tender_data_clean
SELECT 
    CASE 
        WHEN bids_count IS NOT NULL AND bids_count >= 0 THEN 'Завершён (есть данные)'
        ELSE 'Не завершён / Нет данных (NULL)'
    END AS status,
    COUNT(*)
FROM 
    public.tender_data_clean
GROUP BY 
    status;
-- Шаг не ебу какой
ALTER TABLE public.tender_data_clean
ADD COLUMN bidding_duration_days INTEGER;

UPDATE public.tender_data_clean
SET bidding_duration_days = 
    EXTRACT(DAY FROM (bidding_end_date - publication_date));
    ALTER TABLE public.tender_data_clean
ADD COLUMN publication_day_of_week VARCHAR(10);

UPDATE public.tender_data_clean
SET publication_day_of_week = 
    TO_CHAR(publication_date, 'Day');

SELECT 
    bids_count,                     -- Y (Целевая переменная)
    start_price,                    -- X1 (Цена)
    bidding_duration_days,          -- X2 (Длительность)
    publication_day_of_week,        -- X3 (День недели публикации)
    placement_method,               -- X4 (Способ размещения)
    region                          -- X5 (Регион)
FROM 
    public.tender_data_clean
WHERE 
    bids_count IS NOT NULL AND start_price IS NOT NULL;
    --Шаг 2 после не ебу какой
select *
from tender_data_clean
--ШАГ 3 эксопрт
SELECT 
    bids_count,                     -- Для модели N
    winner_price,                   -- Y (Целевая переменная: Фактическая цена контракта)
    start_price,                    -- X (Начальная цена торгов)
    bidding_duration_days,          -- X (Длительность)
    publication_day_of_week,        -- X (День недели)
    placement_method,               -- X (Способ размещения)
    region                          -- X (Регион)
FROM 
    public.tender_data_clean
WHERE 
    bids_count IS NOT NULL 
    AND start_price IS NOT NULL
    AND winner_price IS NOT NULL; -- Все ключевые данные заполнены