create table raw as select * 
from read_csv('data/intermediate/tenders/lic_*.csv', nullstr='NA', decimal_separator=',', union_by_name=true, ignore_errors=true, normalize_names=true, filename=true);

create table suppliers as select 
    distinct on (codigosucursalproveedor, codigoproveedor)
    codigosucursalproveedor as supplier_branch_id,
    codigoproveedor as supplier_id,
    rutproveedor as supplier_rut,
    nombreproveedor as supplier_name,
    razonsocialproveedor as supplier_business_name,
    descripcionproveedor as supplier_description,
from raw order by supplier_branch_id;

CREATE TABLE buyers AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY codigounidad, comunaunidad) AS office_id,  
    codigounidad AS buyer_unit_id,          
    comunaunidad AS buyer_unit_commune,     
    MAX(codigoorganismo) AS buyer_organization_id,  
    MAX(nombreorganismo) AS buyer_organization_name, 
    MAX(sector) AS buyer_sector,                  
    MAX(rutunidad) AS buyer_unit_rut,            
    MAX(nombreunidad) AS buyer_unit_name,         
    MAX(direccionunidad) AS buyer_unit_address,   
    MAX(regionunidad) AS buyer_unit_region        
FROM raw
GROUP BY codigounidad, comunaunidad
ORDER BY office_id, codigounidad, comunaunidad;

create table item as select 
    distinct on (codigoitem)
    codigoitem as item_id,
    correlativo as item_sequential_number,
    codigoproductoonu as item_unspsc_id,
    rubro1 as item_category_1,
    rubro2 as item_category_2,
    rubro3 as item_category_3,
    nombre_producto_generico as product_generic_name,
    nombre_producto_genrico as product_generic_name_1,
    nombre_linea_adquisicion as acquisition_line_name,
    descripcion_linea_adquisicion as acquisition_line_description,
    unidadmedida as item_unit_of_measure,
    cantidad as item_quantity,
    unidadmedida1 as item_secondary_unit_measure,
from raw order by item_id;

create table bids as select 
    distinct on (codigo, codigoitem, codigosucursalproveedor)
    codigo as tender_id,
    codigoitem as item_id,
    codigosucursalproveedor as supplier_branch_id,
    estadopublicidadofertas as is_tech_bid_published,
    justificacionpublicidad as tech_bid_publication_justification,
    nombre_de_la_oferta as bid_name,
    estado_oferta as bid_status,
    cantidad_ofertada as bid_offered_items_quantity,
    moneda_de_la_oferta as bid_currency,
    montounitariooferta as bid_unit_price,
    valor_total_ofertado as bid_total_price,
    cantidadadjudicada as awarded_items_quantity,
    montolineaadjudica as acquisition_line_description,
    fechaenviooferta as bid_submission_date,
    estado_final_oferta as bid_final_status,
    oferta_seleccionada as is_bid_awarded,
from raw order by codigo, codigoitem, supplier_branch_id;

create table tenders as select 
    distinct on (codigo)
    codigo as tender_id,
    link as tender_link,
    codigoexterno as tender_external_id,
    nombre as tender_name,
    descripcion as tender_description,
    tipodeadquisicion as tender_type_description,
    codigoestado as tender_id_status,
    estado as tender_status,
    informada as is_tender_informed,
    codigotipo as is_public_or_private,
    tipo as tender_type,
    tipoconvocatoria as is_open_or_closed_call,
    codigomoneda as tender_currency_id,
    monedaadquisicion as tender_currency_name,
    etapas as tender_stages,
    estadoetapas as status_stages,
    tomarazon as is_tender_with_compt_approv,
    estadocs as contract_signing_status,
    contrato as contract_mode,
    obras as is_it_construction,
    cantidadreclamos as complaints_count,
    fechacreacion as creation_date,
    fechacierre as closing_date,
    fechainicio as forum_start_date,
    fechafinal as forum_close_date,
    fechapubrespuestas as answers_publication_date,
    fechaactoaperturatecnica as tech_open_date,
    fechaactoaperturaeconomica as econ_open_date,
    fechapublicacion as publication_date,
    fechaadjudicacion as award_date,
    fechaestimadaadjudicacion as award_est_date,
    fechasoportefisico as physical_doc_date,
    fechatiempoevaluacion as pre_evaluation_time,
    unidadtiempoevaluacion as pre_evaluation_time_unit,
    fechaestimadafirma as est_contract_signing_date,
    fechasusuario as user_additional_date,
    estimacion as amount_estimation_type_id,
    fuentefinanciamiento as funding_source,
    visibilidadmonto as is_estimated_amount_public,
    montoestimado as estimated_amount,
    tiempo as final_evaluation_time,
    unidadtiempo as final_evaluation_time_unit,
    modalidad as payment_method_contract,
    tipopago as payment_type_contract,
    prohibicioncontratacion as prohibited_conditions_contract,
    subcontratacion as is_subcontracting_allowed,
    unidadtiempoduracioncontrato as contract_duration_unit,
    tiempoduracioncontrato as contract_duration,
    tipoduracioncontrato as contract_duration_type,
    justificacionmontoestimado as estimated_amount_justification,
    observacioncontrato as contract_notes,
    extensionplazo as is_submission_deadline_extended,
    esbasetipo as is_standard_created,
    unidadtiempocontratolicitacion as unit_time_contract,
    valortiemporenovacion as renewal_time_contract,
    periodotiemporenovacion as renewal_period_contract,
    esrenovable as is_contract_renewable,
    tipoaprobacion as contract_adjudication_act_type,
    numeroaprobacion as contract_adjudication_number,
    fechaaprobacion as contract_adjudication_date,
    numerooferentes as number_of_bidders,
    codigoestadolicitacion as tender_id_status_2,
    montoestimadoadjudicado as awarded_estimated_amount,
from raw order by codigo;

alter table item rename column product_generic_name to product_generic_name_2;
alter table item add column product_generic_name varchar(255);
update item set product_generic_name = coalesce(product_generic_name_1, '') || coalesce(product_generic_name_2, '');
alter table item drop column product_generic_name_1;
alter table item drop column product_generic_name_2;
