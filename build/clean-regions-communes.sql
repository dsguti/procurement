create temporary table if not exists mapping_comunas as select * from 'data/support/mapping_comunas.csv';
create temporary table if not exists mapping_regions as select * from 'data/support/mapping_regions.csv';

ALTER TABLE raw ADD COLUMN region VARCHAR(255);

UPDATE raw
SET region = trim(mapping_regions.region_normalizada, ' ')
FROM mapping_regions
WHERE raw.regionproveedor = mapping_regions.regionproveedor;

ALTER TABLE raw ADD COLUMN comuna VARCHAR(255);

UPDATE raw
SET comuna = trim(mapping_comunas.matched_comuna, ' ')
FROM mapping_comunas
WHERE raw.comunaproveedor = mapping_comunas.supplier_comuna;

