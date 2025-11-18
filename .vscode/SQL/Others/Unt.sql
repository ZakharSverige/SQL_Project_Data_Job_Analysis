SELECT *
FROM 
    public.tender_data_flexible_new 
DELETE FROM 
    public.tender_data_flexible_new
WHERE 
    subject IS NULL 
    OR TRIM(subject) = '';
ALTER TABLE public.tender_data_flexible_new
drop column search_query;
alter table public.tender_data_flexible_new
drop column advance_payment,
drop column bid_security,
drop column contract_security_raw,
drop column contact_fax,
drop column eis_number,
drop column etp_number,
drop column purchase_type;
