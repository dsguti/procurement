copy (
    select comunaunidad as commune, year(fechacreacion) as t, count(distinct codigo) as n 
    from raw
    where commune is not null and commune != '' 
    group by commune, t 
    order by commune, t
) to 'data/intermediate/dashboard/count-commune-year.parquet';
