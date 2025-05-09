
create table awards as select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2018_0.xlsx');
insert into awards select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2019_0.xlsx');
insert into awards select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2020_0.xlsx');
insert into awards select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2021_0.xlsx');
insert into awards select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2022_0.xlsx');
insert into awards select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2023_0.xlsx');
insert into awards select * from read_xlsx('data/raw/peru/awards/CONOSCE_ADJUDICACIONES2024_0.xlsx');
--------------------------------------------------------------------------------------------------------------------
create table bidders as select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2018_0.xlsx');
insert into bidders select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2019_0.xlsx');
insert into bidders select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2020_0.xlsx');
insert into bidders select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2021_0.xlsx');
insert into bidders select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2022_0.xlsx');
insert into bidders select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2023_0.xlsx');
insert into bidders select * from read_xlsx('data/raw/peru/bidders/CONOSCE_POSTOR2024_0.xlsx');
--------------------------------------------------------------------------------------------------------------------
For contracts:
create table contracts as select * from read_xlsx('data/raw/peru/contracts/CONOSCE_CONTRATOS2018_0.xlsx');
insert into contracts select * from read_xlsx('data/raw/peru/contracts/CONOSCE_CONTRATOS2019_0.xlsx');
insert into contracts select * from read_xlsx('data/raw/peru/contracts/CONOSCE_CONTRATOS2020_0.xlsx');
INSERT INTO contracts
  SELECT 
      CODIGOCONVOCATORIA,
      N_COD_CONTRATO,
      DESCRIPCION_PROCESO,
      FECHA_PUBLICACION_CONTRATO,
      FECHA_SUSCRIPCION_CONTRATO,
      FECHA_VIGENCIA_INICIAL,
      FECHA_VIGENCIA_FINAL,
      FECHA_VIGENCIA_FIN_ACTUALIZADA,
      CODIGO_CONTRATO,
      NUM_CONTRATO,
      TRY_CAST(MONTO_CONTRATADO_TOTAL AS DOUBLE),
      TRY_CAST(MONTO_CONTRATADO_ITEM AS DOUBLE),
      TRY_CAST(MONTO_ADICIONAL AS DOUBLE),
      TRY_CAST(MONTO_REDUCCION AS DOUBLE),
      TRY_CAST(MONTO_PRORROGA AS DOUBLE),
      TRY_CAST(MONTO_COMPLEMENTARIO AS DOUBLE),
      URLCONTRATO,
      CODIGOENTIDAD,
      NUM_ITEM,
      MONEDA,
      RUC_CONTRATISTA,
      RUC_DESTINATARIO_PAGO,
      TIENERESOLUCION
  FROM read_xlsx('data/raw/peru/contracts/CONOSCE_CONTRATOS2021_0.xlsx');
INSERT INTO contracts
  SELECT 
      CODIGOCONVOCATORIA,
      N_COD_CONTRATO,
      DESCRIPCION_PROCESO,
      TRY_CAST(FECHA_PUBLICACION_CONTRATO AS TIMESTAMP),
      TRY_CAST(FECHA_SUSCRIPCION_CONTRATO AS TIMESTAMP),
      TRY_CAST(FECHA_VIGENCIA_INICIAL AS TIMESTAMP),
      TRY_CAST(FECHA_VIGENCIA_FINAL AS TIMESTAMP),
      TRY_CAST(FECHA_VIGENCIA_FIN_ACTUALIZADA AS TIMESTAMP),
      CODIGO_CONTRATO,
      NUM_CONTRATO,
      TRY_CAST(MONTO_CONTRATADO_TOTAL AS DOUBLE),
      TRY_CAST(MONTO_CONTRATADO_ITEM AS DOUBLE),
      TRY_CAST(MONTO_ADICIONAL AS DOUBLE),
      TRY_CAST(MONTO_REDUCCION AS DOUBLE),
      TRY_CAST(MONTO_PRORROGA AS DOUBLE),
      TRY_CAST(MONTO_COMPLEMENTARIO AS DOUBLE),
      URLCONTRATO,
      CODIGOENTIDAD,
      NUM_ITEM,
      MONEDA,
      RUC_CONTRATISTA,
      RUC_DESTINATARIO_PAGO,
      TIENERESOLUCION
  FROM read_xlsx('data/raw/peru/contracts/CONOSCE_CONTRATOS2022_0.xlsx');

  The one of 2022 was the same for 2023 and 2024


-----------------------------------------------------------------------------------------------------------
#### creating table. data from 2018 until 2022 has 18 colums and from 2023 to 2024 19 colums.
Also, the name of  DEPARTAMENTO__ENTIDAD is like that until 2022, but in 2023 and 2024 is just DEPARTAMENTO

CREATE TABLE purchases (
    ENTIDAD                           VARCHAR,
    RUC_ENTIDAD                       VARCHAR,
    FECHA_REGISTRO                    TIMESTAMP,
    FECHA_DE_EMISION                  TIMESTAMP,
    FECHA_COMPROMISO_PRESUPUESTAL     TIMESTAMP,
    FECHA_DE_NOTIFICACION             TIMESTAMP,
    TIPOORDEN                         VARCHAR,
    NRO_DE_ORDEN                      DOUBLE,
    ORDEN                             VARCHAR,
    DESCRIPCION_ORDEN                 VARCHAR,
    MONEDA                            VARCHAR,
    MONTO_TOTAL_ORDEN_ORIGINAL        DOUBLE,
    MONTO_TOTAL_ORDEN_SOLES           DOUBLE,
    OBJETOCONTRACTUAL                 VARCHAR,
    ESTADOCONTRATACION                VARCHAR,
    TIPODECONTRATACION                VARCHAR,
    DEPARTAMENTO__ENTIDAD             VARCHAR,
    RUC_CONTRATISTA                   VARCHAR,
    NOMBRE_RAZON_CONTRATISTA          VARCHAR
);

From 2018 until 2022

INSERT INTO purchases
  SELECT
      ENTIDAD,
      RUC_ENTIDAD,
      TRY_CAST(FECHA_REGISTRO AS TIMESTAMP),
      TRY_CAST(FECHA_DE_EMISION AS TIMESTAMP),
      TRY_CAST(FECHA_COMPROMISO_PRESUPUESTAL AS TIMESTAMP),
      TRY_CAST(FECHA_DE_NOTIFICACION AS TIMESTAMP),
      TIPOORDEN,
      TRY_CAST(NRO_DE_ORDEN AS DOUBLE),
      ORDEN,
      DESCRIPCION_ORDEN,
      MONEDA,
      TRY_CAST(MONTO_TOTAL_ORDEN_ORIGINAL AS DOUBLE),
      NULL AS MONTO_TOTAL_ORDEN_SOLES,  -- Esta columna falta en el archivo, se rellena como NULL
      OBJETOCONTRACTUAL,
      ESTADOCONTRATACION,
      TIPODECONTRATACION,
      DEPARTAMENTO__ENTIDAD,
      RUC_CONTRATISTA,
      NOMBRE_RAZON_CONTRATISTA
  FROM read_xlsx(
      'data/raw/peru/purchases/CONOSCE_ORDENESCOMPRAOCTUBRE2019_0.xlsx',
      ALL_VARCHAR=TRUE
  );

  From 2023 to 2024

  INSERT INTO purchases
  SELECT
      ENTIDAD,
      RUC_ENTIDAD,
      TRY_CAST(FECHA_REGISTRO AS TIMESTAMP),
      TRY_CAST(FECHA_DE_EMISION AS TIMESTAMP),
      TRY_CAST(FECHA_COMPROMISO_PRESUPUESTAL AS TIMESTAMP),
      TRY_CAST(FECHA_DE_NOTIFICACION AS TIMESTAMP),
      TIPOORDEN,
      TRY_CAST(NRO_DE_ORDEN AS DOUBLE),
      ORDEN,
      DESCRIPCION_ORDEN,
      MONEDA,
      TRY_CAST(MONTO_TOTAL_ORDEN_ORIGINAL AS DOUBLE),
      TRY_CAST(MONTO_TOTAL_ORDEN_SOLES AS DOUBLE),
      OBJETOCONTRACTUAL,
      ESTADOCONTRATACION,
      TIPODECONTRATACION,
      DEPARTAMENTO AS DEPARTAMENTO__ENTIDAD,
      RUC_CONTRATISTA,
      NOMBRE_RAZON_CONTRATISTA
  FROM read_xlsx(
      'data/raw/peru/purchases/CONOSCE_ORDENESCOMPRASEPTIEMBRE2024_0.xlsx',
      ALL_VARCHAR=TRUE
  );

  -----------------------------------------------------------------------------------------

