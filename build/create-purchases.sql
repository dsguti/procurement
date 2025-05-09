create table raw as select * 
from read_csv('data/intermediate/purchases/*.csv', nullstr='NA', decimal_separator=',', union_by_name=true, normalize_names=true);

create table suppliers as select 
    distinct on (codigosucursal, codigoproveedor)
    codigosucursal as supplier_branch_id,
    codigoproveedor as supplier_id,
    rutsucursal as supplier_branch_rut,
    sucursal as supplier_branch_name,
    nombreproveedor as supplier_name,
    actividadproveedor as supplier_activity,
    comunaproveedor as supplier_commune,
    regionproveedor as supplier_region,
    paisproveedor as supplier_country,
from raw order by supplier_branch_id;

CREATE TABLE buyers AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY codigounidadcompra, ciudadunidadcompra) AS office_id,  
    codigounidadcompra AS buyer_unit_id,          
    ciudadunidadcompra AS buyer_unit_city,     
    MAX(rutunidadcompra) AS buyer_unit_rut,  
    MAX(unidadcompra) AS buyer_unit_name, 
    MAX(codigoorganismopublico) AS buyer_organization_id,                  
    MAX(organismopublico) AS buyer_organization_name,            
    MAX(sector) AS buyer_sector,         
    MAX(actividadcomprador) AS buyer_activity,   
    MAX(regionunidadcompra) AS buyer_unit_region,  
    MAX(paisunidadcompra) AS buyer_unit_country,      
FROM raw
GROUP BY codigounidadcompra, ciudadunidadcompra
ORDER BY office_id, codigounidadcompra, ciudadunidadcompra;

create table item as select 
    distinct on (iditem)
    iditem as item_id,
    codigocategoria as item_category_id,
    codigoproductoonu as item_un_id,
    rubron1 as item_category_1,
    rubron2 as item_category_2,
    rubron3 as item_category_3,
    cantidad as item_quantity,
    unidadmedida as item_unit_measure,
    monedaitem as item_currency,
    precioneto as item_net_price,
    totalcargos as item_total_charges,
    totaldescuentos as item_total_discounts,
    totalimpuestos as item_total_taxes,
    totallineaneto as acquired_items_net_total,
from raw order by iditem;


create table purchases as select 
    distinct on (id)
    id as purchase_id,
    codigo as purchase_external_id,
    link as purchase_link,
    nombre as purchase_name,
    descripcionobervaciones as purchase_description,
    tipo as purchase_type,
    procedenciaoc as purchase_source,
    estratodirecto as is_direct_procurement,
    escompraagil as is_agile_procurement,
    codigotipo as purchase_type_id,
    codigoabreviadotipooc as purchase_type_abbreviated_id,
    descripciontipooc as purchase_type_description,
    idplandecompra as procurement_plan_id,
    codigoestado as purchase_status_id,
    estado as purchase_status,
    codigoestadoproveedor as purchase_supplier_status_id,
    estadoproveedor as purchase_supplier_status,
    fechacreacion as purchase_creation_date,
    fechaenvio as purchase_sending_date,
    fechasolicitudcancelacion as purchase_cancellation_request_date,
    fechaultimamodificacion as purchase_last_modification_date,
    fechaaceptacion as purchase_accepted_date,
    fechacancelacion as purchase_cancellation_date,
    tieneitems as is_a_purchase_with_items,
    promediocalificacion as purchase_supplier_average_rating,
    cantidadevaluacion as supplier_evaluations_count,
    montototaloc as purchase_total_amount,
    tipomonedaoc as purchase_currency_type,
    montototaloc_pesoschilenos as purchase_total_amount_clp,
    impuestos as purchase_taxes,
    tipoimpuesto as purchase_tax_type,
    descuentos as purchase_discounts,
    cargos as purchase_charges,
    totalnetooc as purchase_net_total,
    financiamiento as purchase_funding,
    porcentajeiva as purchase_vat_percentage,
    pais as purchase_country,
    tipodespacho as purchase_shipping_type,
    formapago as purchase_payment_method,
    codigolicitacion as purchase_tender_id,
    codigo_conveniomarco as purchase_framework_agreement_id, 
from raw order by id;

