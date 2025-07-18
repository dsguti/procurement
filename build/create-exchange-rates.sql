create temporary table exchange_rates_raw as
  select 
    split_part(time_period, '-', 1)::integer as y, 
    split_part(time_period, '-', 2) as q,
    case when q = 'Q1' then 1 when q = 'Q2' then 4 when q = 'Q3' then 7 else 10 end as m,
    make_date(y, m, 1) as date,
    obs_value as rate
  from read_csv('data/support/imf-exchange-rates.csv', ignore_errors = true)
  where country = 'Chile' 
  and indicator = 'US Dollar per domestic currency' 
  and frequency = 'Quarterly' 
  and type_of_transformation = 'Period average';

  create table exchange_rate as 
  select date, rate from exchange_rates_raw;