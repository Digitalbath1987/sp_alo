
CREATE PROCEDURE [dbo].[SP_MIGRAR_GESTIONES_X_EJECUTIVO_TECNOCOB_HACIA_ALO]                         @USUARIO      VARCHAR(50) = 'jvidal'              ,@CEDENTE      VARCHAR(3)  =  'AVN'    As Begin SET ROWCOUNT 0 SET NOCOUNT ON SET ANSI_NULLS OFF   /*----
-------------------------------------------------------------*/    
/*------------------------- Begin User Code -----------------------*/    
/*-----------------------------------------------------------------*/    
/*-----------------------------------------------------------------*/    
/*                      DATOS DEL SERVICIO                         */    
/*-----------------------------------------------------------------*/    
/* OBJETIVO        : MIGRAR GESTIONES DESDE TECNOCOB DE EJECUTIVOS */   
/*                   NO EXISTENTES EN ALO                          */    
/*-----------------------------------------------------------------*/    
/* PROGRAMADOR     : MARIO ROSALES FIGUEROA                        */    
/*-----------------------------------------------------------------*/      /*-----------------------------------------------------------------*/    
/*                    DECLARACION DE VARIABLES                     */    
/*-----------------------------------------------------------------*/  
 DECLARE  @FECHA_INICIO DATETIME    =  GETDATE()       /*-----------------------------------------------------------------*/    
/*            ELIMINA Y CREA TABLA TMP EN TECNOCOB                 */    
/*-----------------------------------------------------------------*/   IF OBJECT_ID('TMP_GESTIONES_CARGA_TECNOCOB_ALO_TELEFONOS', 'U') IS NOT NULL  
    BEGIN  
    DROP TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO_TELEFONOS  
 END   IF OBJECT_ID('TMP_GESTIONES_CARGA_TECNOCOB_ALO', 'U') IS NOT NULL  
    BEGIN  
    DROP TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 END  
 IF OBJECT_ID('TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS', 'U') IS NOT NULL  
    BEGIN  
    DROP TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
 END  
  
 CREATE TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS(  
    ID_GESTION_ALO     INT NULL,  
    ID_GESTION_TECNO   INT NULL,  
    fld_cod_usu        VARCHAR(8) NULL,  
    fld_id_usuario     INT NULL,  
    fld_rut_cli        VARCHAR(11) NULL,  
    fld_tip_comp       VARCHAR(25) NULL,  
    fld_num_tel        VARCHAR(25) NULL,  
    fld_est_comp       VARCHAR(15) NULL,  
    fld_fec_ing        DATETIME NULL,  
    fld_fec_ges        DATETIME NULL,  
    fld_cod_emp        VARCHAR(3) NULL,  
    ID_TIPO_COMPROMISO INT NULL,  
    FECHA_COMPROMISO   DATETIME NULL,  
    ID_ESTADO_COMPROMISO_PAGO INT NULL,  
    MONTO_COMPROMISO   NUMERIC(21, 4) NULL,  
 )    CREATE TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO(  
    FLD_RUT_CLI          VARCHAR(11) NULL,  
    FLD_COD_EMP          VARCHAR(3) NULL,  
    FLD_TIP_GES          INT NULL,  
    FLD_COD_GES          INT NULL,  
    FLD_COD_RES          INT NULL,  
    FLD_RES_CLI          INT NULL,  
    FLD_TIP_CON          INT NULL,  
    FLD_CAN_GES          INT NULL,  
    FLD_COD_USU          VARCHAR(8) NULL,  
    FLD_FEC_GES          DATETIME NULL,  
    FLD_NUM_TEL          VARCHAR(15) NULL,  
    FLD_COMENTA          VARCHAR(250) NULL,  
    FLD_COD_ACC          INT NULL,  
    FLD_NOM_CAM          VARCHAR(50) NULL,  
    FLD_FECHA_VISITA     DATETIME NULL,  
    FLD_ID_GESTION       INT NOT NULL,  
    FLD_ID_TELEFONO      INT NULL,  
    FLD_ID_USUARIO       INT NULL,  
    FLD_ID_SUB_RESPUESTA INT NULL,  
    FLD_ID_CLIENTE_ALO   INT NULL,  
    FLD_NUM_TEL_DEP      VARCHAR(50) NULL,  
    FLD_TIPO_ACCION      VARCHAR(100) NULL,  
    FLD_ID_TIPO_ACCION   INT NULL,  
    FLD_ID_CONTRATO_ALO  INT NULL,  
    ID_TELEFONO_ALO      INT NULL,  
    ID_GESTION_ALO       INT NULL,  
 )       /*-----------------------------------------------------------------*/    
/*     EXTRAE E INSERTA LOS DATOS DE LAS GESTIONES DESDE TECNOCOB  */    
/*-----------------------------------------------------------------*/   INSERT INTO TMP_GESTIONES_CARGA_TECNOCOB_ALO  
      (FLD_RUT_CLI,  
    FLD_COD_EMP,  
    FLD_TIP_GES,  
    FLD_COD_GES,  
    FLD_COD_RES,  
    FLD_RES_CLI,  
    FLD_TIP_CON,  
    FLD_CAN_GES,  
    FLD_COD_USU,  
    FLD_FEC_GES,  
    FLD_NUM_TEL,  
    FLD_COMENTA,  
    FLD_COD_ACC,  
    FLD_NOM_CAM,  
    FLD_FECHA_VISITA,  
    FLD_ID_GESTION,  
    FLD_ID_TELEFONO,  
    FLD_ID_USUARIO,  
    FLD_ID_SUB_RESPUESTA,  
    FLD_ID_CLIENTE_ALO,  
    FLD_NUM_TEL_DEP,  
    FLD_TIPO_ACCION,  
    FLD_ID_TIPO_ACCION,  
    FLD_ID_CONTRATO_ALO,  
    ID_TELEFONO_ALO,  
    ID_GESTION_ALO)  SELECT  
      TEL.FLD_RUT_CLI  
     ,TEL.FLD_COD_EMP  
     ,TEL.FLD_TIP_GES  
     ,TEL.FLD_COD_GES  
     ,TEL.FLD_COD_RES  
     ,TEL.FLD_RES_CLI  
     ,TEL.FLD_TIP_CON  
     ,TEL.FLD_CAN_GES  
     ,TEL.FLD_COD_USU  
     ,TEL.FLD_FEC_GES  
     ,TEL.FLD_NUM_TEL  
     ,TEL.FLD_COMENTA  
     ,TEL.FLD_COD_ACC  
     ,TEL.FLD_NOM_CAM  
     ,TEL.FLD_FECHA_VISITA  
     ,TEL.FLD_ID_GESTION  
     ,''  
     ,''  
     ,''  
     ,''  
     ,''  
     ,''  
     ,''  
     ,''  
     ,''  
     ,''  
   FROM   TBL_TELEFONIA_GESTIONES          TEL    WITH(NOLOCK)  
   WHERE  TEL.FLD_COD_EMP                = 'AVN'  
      AND    CAST(TEL.FLD_FEC_GES AS DATE)  >= REPLACE(CAST(@FECHA_INICIO AS DATE),'-','')  
   AND    TEL.FLD_COD_USU            in ('elianasa','sebagopa' ,'jvidal')          /*-----------------------------------------------------------------*/    
/*     OBTIENTE EL ID_CLIENTE_ALO DESDE IBR ALO                    */    
/*-----------------------------------------------------------------*/     UPDATE           TMP_GESTIONES_CARGA_TECNOCOB_ALO  
   SET              FLD_ID_CLIENTE_ALO                 = CLI.ID_CLIENTE   
   FROM             TMP_GESTIONES_CARGA_TECNOCOB_ALO     GES WITH(NOLOCK)  
   INNER JOIN       IBR_ALO..CLIENTE                     CLI WITH(NOLOCK)  
   ON               GES.FLD_RUT_CLI                    = RIGHT('00000000000'+LTRIM(RTRIM(CLI.IDENTIFICADOR)),11)  
   AND              CLI.ID_CEDENTE                     = 9  
 /*-----------------------------------------------------------------*/    
/*     OBTIENTE EL ID_USUARIO_ALO DESDE IBR ALO                    */    
/*-----------------------------------------------------------------*/     UPDATE          TMP_GESTIONES_CARGA_TECNOCOB_ALO  
   SET             FLD_ID_USUARIO                      = USU.ID_USUARIO   
   FROM            TMP_GESTIONES_CARGA_TECNOCOB_ALO      GES WITH(NOLOCK)  
   INNER JOIN      IBR_ALO..USUARIO                      USU WITH(NOLOCK)  
   ON              GES.FLD_COD_USU                     = USU.LOGIN   /*-----------------------------------------------------------------*/    
/*     OBTIENTE EL ID_CONTRATO_ALO DESDE IBR ALO                   */    
/*-----------------------------------------------------------------*/      UPDATE        TMP_GESTIONES_CARGA_TECNOCOB_ALO  
    SET           FLD_ID_CONTRATO_ALO                     = CON.ID_CONTRATO  
    FROM          TMP_GESTIONES_CARGA_TECNOCOB_ALO          GES WITH(NOLOCK)  
    INNER JOIN    IBR_ALO..CONTRATO                         CON WITH(NOLOCK)  
    ON            GES.FLD_ID_CLIENTE_ALO                  = CON.ID_CLIENTE  /*-----------------------------------------------------------------*/    
/*     OBTIENTE EL ID_TELEFONO_ALO DESDE IBR ALO                   */    
/*-----------------------------------------------------------------*/   
  UPDATE         TMP_GESTIONES_CARGA_TECNOCOB_ALO            
  SET            ID_TELEFONO_ALO = TEL.ID_TELEFONO   
  FROM           TMP_GESTIONES_CARGA_TECNOCOB_ALO   GES WITH(NOLOCK)  
  INNER JOIN     IBR_ALO..TELEFONO                  TEL WITH(NOLOCK)  
  ON             GES.FLD_ID_CONTRATO_ALO = TEL.ID_CONTRATO  
  AND            RIGHT(RTRIM(LTRIM(GES.FLD_NUM_TEL)),7) = RIGHT(RTRIM(LTRIM(TEL.FONO)),7)       /*-----------------------------------------------------------------*/    
/*     OBTIENTE TELEFONOS QUE NO EXISTEN EN ALO                    */    
/*-----------------------------------------------------------------*/  
  
 SELECT          *  
    INTO            TMP_GESTIONES_CARGA_TECNOCOB_ALO_TELEFONOS  
 FROM            (SELECT ROW_NUMBER() OVER(PARTITION BY TEL.FLD_RUT_CLI, TEL.fld_num_tel ORDER BY TEL.FLD_RUT_CLI DESC) AS vof  
     ,TEL.*  
     ,GES.FLD_ID_CONTRATO_ALO  
     ,GES.FLD_ID_CLIENTE_ALO  
 FROM            TMP_GESTIONES_CARGA_TECNOCOB_ALO         GES WITH(NOLOCK)  
 INNER JOIN      TBL_TELEFONOS                            TEL  WITH(NOLOCK)  
 ON              GES.FLD_RUT_CLI                        = TEL.FLD_RUT_CLI  
 AND             RIGHT(RTRIM(LTRIM(GES.FLD_NUM_TEL)),7) = RIGHT(RTRIM(LTRIM(TEL.FLD_NUM_TEL)),7)   
 WHERE           GES.ID_TELEFONO_ALO                    = 0) as c  
 WHERE           c.vof                                  = 1  /*-------------------------------------------------------------------------*/    
/*     ADD IDENTITY EN TABLA TMP_GESTIONES_CARGA_TECNOCOB_ALO_TELEFONOS    */    
/*-------------------------------------------------------------------------*/     
 ALTER TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO_TELEFONOS ADD REGISTRO INT IDENTITY(1,1)  /*-------------------------------------------------------------------------*/    
/*    DECLARACION DE VARIABLES PARA EL CURSOR DE TELEFONOS                 */    
/*-------------------------------------------------------------------------*/  DECLARE      @TEL_ID_CONTRATO                             INT              ,@TEL_FONO_ENVIADO                            VARCHAR(20)              ,@TEL_PREFIJO           VARCHA
R(4)              ,@TEL_FONO                                    VARCHAR(20)              ,@TEL_FONO_DISCAR                             VARCHAR(30)              ,@TEL_ID_TIPO_TELEFONO                        INT           
             ,@TEL_ID_TIPO_DIRECCION                       INT              ,@TEL_ESTADO                                  BIT              ,@TEL_ID_USUARIO                              INT              ,@TEL_FECHA_CARGA          DATETIME              ,@TE
L_FECHA_REFRESCO                          DATETIME              ,@TEL_ORIGEN_ANFITRION                        VARCHAR(07)              ,@TEL_NRO_CARGA                               INT              ,@TEL_REGISTRO                                INT        
      ,@TEL_FILE_ID_TELEFONO         INT  /*---------------------------------------------------------------------------------------------------------------------------*/    
/*                       CURSOR PARA TRASPASAR TELEFONOS INEXISTENTES DESDE TECNOCOB HACIA ALO                               */    
/*---------------------------------------------------------------------------------------------------------------------------*/    DECLARE RECORRE_TELEFONO CURSOR FOR  
        
  
/*-------------------------------------------------------------------------*/    
/*           SELECT PARA LLAMAR TELEFONOS A TRASPASAR                      */    
/*-------------------------------------------------------------------------*/  
  
   SELECT      
           FLD_ID_CONTRATO_ALO               -- ID DE CONTRATO  
       ,FLD_COD_AREA + FLD_NUM_TEL     -- FONO ENVIADO  
       ,FLD_COD_AREA                      -- PREFIJO  
       ,FLD_NUM_TEL                       -- FONO     
       ,FLD_NUM_TEL_DEP                   -- FONO DISCAR   
       ,CASE   
               WHEN FLD_COD_AREA = '9'    -- TIPO DE TELEFONO ? CELULAR : 2 FIJO : 1  
       THEN 2  
               ELSE 1  
        END  
       ,1                                 -- TIPO DE DIRECCION    
       ,1                                 -- ESTADO  
       ,1                                 -- ID USUARIO  
       ,GETDATE()                         -- FECHA CARGA  
       ,GETDATE()                         -- FECHA REFRESCO  
       ,fld_fte_dir                      -- ORIGEN ANFITRION  
       ,'1209'                            -- NRO CARGA   
       ,REGISTRO                          -- NRO REGISTRO   
       ,1                                 -- FILE ID TELEFONO  
       FROM             TMP_GESTIONES_CARGA_TECNOCOB_ALO_TELEFONOS  
       WHERE            REGISTRO > 0  
       AND           REGISTRO <= 5000  
    AND              FLD_ID_CONTRATO_ALO != 0     
    AND              FLD_NUM_TEL != NULL  
       ORDER BY REGISTRO ASC  
     
  
   OPEN RECORRE_TELEFONO  
   FETCH NEXT FROM RECORRE_TELEFONO  
           INTO        @TEL_ID_CONTRATO                                          ,@TEL_FONO_ENVIADO                                          ,@TEL_PREFIJO                         ,@TEL_FONO                                                  ,@TEL_FONO_DISC
AR                                           ,@TEL_ID_TIPO_TELEFONO                                   
             ,@TEL_ID_TIPO_DIRECCION                                     ,@TEL_ESTADO                                                ,@TEL_ID_USUARIO                                            ,@TEL_FECHA_CARGA                        ,@TEL_FECHA_REFRESCO 
                                       ,@TEL_ORIGEN_ANFITRION                                      ,@TEL_NRO_CARGA                                             ,@TEL_REGISTRO                                          ,@TEL_FILE_ID_TELEFONO          
  
   WHILE @@FETCH_STATUS = 0    
      BEGIN  
  
         EXEC  IBR_ALO.DBO.SP_CREATE_TELEFONO                  @TEL_ID_CONTRATO                                          ,@TEL_FONO_ENVIADO                                          ,@TEL_PREFIJO                         ,@TEL_FONO                          
                        ,@TEL_FONO_DISCAR                                           ,@TEL_ID_TIPO_TELEFONO                                   
             ,@TEL_ID_TIPO_DIRECCION                                     ,@TEL_ESTADO                                                ,@TEL_ID_USUARIO                                            ,@TEL_FECHA_CARGA                        ,@TEL_FECHA_REFRESCO 
                                       ,@TEL_ORIGEN_ANFITRION                                      ,@TEL_NRO_CARGA                                             ,@TEL_REGISTRO                                          ,@TEL_FILE_ID_TELEFONO  
  
          
  
         FETCH NEXT FROM RECORRE_TELEFONO  
           INTO  @TEL_ID_CONTRATO                                          ,@TEL_FONO_ENVIADO                                          ,@TEL_PREFIJO                         ,@TEL_FONO                                                  ,@TEL_FONO_DISCAR     
                                      ,@TEL_ID_TIPO_TELEFONO                                   
             ,@TEL_ID_TIPO_DIRECCION                                     ,@TEL_ESTADO                                                ,@TEL_ID_USUARIO                                            ,@TEL_FECHA_CARGA                        ,@TEL_FECHA_REFRESCO 
                                       ,@TEL_ORIGEN_ANFITRION                                      ,@TEL_NRO_CARGA                                             ,@TEL_REGISTRO                                          ,@TEL_FILE_ID_TELEFONO   
  
      END  
CLOSE RECORRE_TELEFONO  
DEALLOCATE RECORRE_TELEFONO   
/*---------------------------------------------------------------------------------------------------------------------------*/    
/*                                      FIN CURSOR DE TRASPASO TELEFONOS                                                     */    
/*---------------------------------------------------------------------------------------------------------------------------*/     /*-----------------------------------------------------------------*/    
/*     OBTIENTE ID_TELEFONO DE LOS TELEFONO RECIEN TRASPASADOS    */    
/*-----------------------------------------------------------------*/   UPDATE        TMP_GESTIONES_CARGA_TECNOCOB_ALO            
 SET           ID_TELEFONO_ALO                            = TEL.ID_TELEFONO   
 FROM          TMP_GESTIONES_CARGA_TECNOCOB_ALO             GES  WITH(NOLOCK)  
 INNER JOIN    IBR_ALO..TELEFONO                            TEL  WITH(NOLOCK)  
 ON            GES.fld_id_contrato_alo                    = TEL.ID_CONTRATO  
 AND           RIGHT(RTRIM(LTRIM(GES.FLD_NUM_TEL)),7)     = RIGHT(RTRIM(LTRIM(TEL.FONO)),7)   
 WHERE         GES.ID_TELEFONO_ALO                        = 0   
/*-----------------------------------------------------------------*/    
/*                     OBTIENTE FLD_ID_SUB_RESPUESTA               */    
/*-----------------------------------------------------------------*/   UPDATE        TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 SET           FLD_ID_SUB_RESPUESTA                       = HOM.ID_SUB_RESPUESTA  
 FROM          TMP_GESTIONES_CARGA_TECNOCOB_ALO             GES    WITH(NOLOCK)  
 INNER JOIN    IBR_ALO..HOMOLOGACION_GESTION                HOM   WITH(NOLOCK)  
 ON            GES.fld_cod_res                            = HOM.FLD_COD_RES   
 AND           GES.fld_res_cli                            = HOM.FLD_RES_CLI  
 AND           GES.fld_tip_con                            = HOM.FLD_TIP_CON  
 WHERE         HOM.CEDENTE                                = @CEDENTE    /*-----------------------------------------------------------------*/    
/*                     OBTIENTE FLD_ACCION                         */    
/*-----------------------------------------------------------------*/     
 UPDATE       TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 SET          FLD_TIPO_ACCION                              = ACC.fld_accion  
 FROM         TMP_GESTIONES_CARGA_TECNOCOB_ALO               GES   WITH(NOLOCK)  
 INNER JOIN   TBL_TELEFONIA_ACCION                           ACC   WITH(NOLOCK)  
 ON           GES.FLD_COD_ACC                              = ACC.FLD_COD_ACC   
 AND          ACC.FLD_COD_EMP                              = @CEDENTE  
  
  
/*-----------------------------------------------------------------*/    
/*                     OBTIENTE TIPO ACCION                        */    
/*-----------------------------------------------------------------*/  
  
  
 UPDATE      TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 SET         FLD_ID_TIPO_ACCION                             =  TIP.ID_TIPO_ACCION  
 FROM        TMP_GESTIONES_CARGA_TECNOCOB_ALO                    GES  WITH(NOLOCK)  
 INNER JOIN  IBR_ALO.DBO.TIPO_ACCION                             TIP  WITH(NOLOCK)  
 ON          GES.FLD_TIPO_ACCION                            =  TIP.TIPO_ACCION             
 AND         GES.FLD_ID_SUB_RESPUESTA                       =  TIP.ID_SUB_RESPUESTA      
 UPDATE      TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 SET         FLD_TIPO_ACCION                                = 'Sin Gestion'  
 WHERE       FLD_ID_TIPO_ACCION                             = 0   /*-----------------------------------------------------------------*/    
/*                     OBTIENTE TIPO ACCION HOMOLOGADOS            */    
/*-----------------------------------------------------------------*/      UPDATE      TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 SET         FLD_ID_TIPO_ACCION                             =    TIP.ID_TIPO_ACCION  
 FROM        TMP_GESTIONES_CARGA_TECNOCOB_ALO                    GES  WITH(NOLOCK)  
 INNER JOIN  IBR_ALO.DBO.TIPO_ACCION                             TIP  WITH(NOLOCK)  
 ON          GES.FLD_TIPO_ACCION                            =    TIP.TIPO_ACCION             
 AND         GES.FLD_ID_SUB_RESPUESTA                       =    TIP.ID_SUB_RESPUESTA  WHERE       GES.FLD_ID_TIPO_ACCION                         =    0  /*-----------------------------------------------------------------*/    
/*        OBTIENTE LAS GESTIONES ENCONTRADAS EN IBR_ALO            */    
/*-----------------------------------------------------------------*/   
 UPDATE                 TMP_GESTIONES_CARGA_TECNOCOB_ALO  
 SET                    ID_GESTION_ALO                      =    b.ID_GESTION  
 FROM                   TMP_GESTIONES_CARGA_TECNOCOB_ALO         A  
 INNER JOIN             IBR_ALO..GESTION                         B WITH(NOLOCK)  
 ON                     A.fld_id_cliente_alo                =    b.ID_CLIENTE  
 AND                    A.fld_id_usuario                    =    b.ID_USUARIO    
 AND                    A.fld_fec_ges                       =    b.FECHA_GESTION   AND                    A.fld_nom_cam                       =    b.INTERACCION_DISCADOR  /*-----------------------------------------------------------------*/    
/*        ELIMINA LAS GESTIONES ENCONTRADAS EN IBR_ALO             */    
/*-----------------------------------------------------------------*/  
  
  
 DELETE FROM TMP_GESTIONES_CARGA_TECNOCOB_ALO WHERE ID_GESTION_ALO != 0   /*-------------------------------------------------------------------------*/    
/*     ADD IDENTITY EN TABLA TMP_GESTIONES_CARGA_TECNOCOB_ALO              */    
/*-------------------------------------------------------------------------*/     
 ALTER TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO ADD REGISTRO INT IDENTITY(1,1)     /*-------------------------------------------------------------------------*/    
/*    DECLARACION DE VARIABLES PARA EL CURSOR DE GESTIONES                 */    
/*-------------------------------------------------------------------------*/   
   DECLARE @GES_ID_CLIENTE                              INT  
    ,@GES_ID_USUARIO                              INT           ,@GES_ID_SUB_RESPUESTA                        INT           ,@GES_ID_TIPO_ACCION                          INT           ,@GES_COMENTARIO                              VARCHAR(100)           ,@
GES_INTERACCION_DISCADOR                    CHAR(25)     ,@GES_NRO_DEPENDIENTE                         INT         ,@GES_ID_GESTION                              INT  
    ,@GES_ID_GESTION_TECNO                        INT     
          ,@GES_REGISTRO                                INT  
    ,@GES_FECHA_GESTION                           DATETIME    
     
/*---------------------------------------------------------------------------------------------------------------------------*/    
/*                       CURSOR PARA TRASPASAR GESTIONES INEXISTENTES DESDE TECNOCOB HACIA ALO                               */    
/*---------------------------------------------------------------------------------------------------------------------------*/  
  
  DECLARE RECORRE_GESTION CURSOR FOR  
    
  
/*-------------------------------------------------------------------------*/    
/*           SELECT PARA LLAMAR TELEFONOS A TRASPASAR                      */    
/*-------------------------------------------------------------------------*/  
  
  
    SELECT  fld_id_cliente_alo                  -- id del cliente       ,fld_id_usuario                      -- id del usuario        ,FLD_ID_SUB_RESPUESTA                -- sub respuesta      ,fld_id_tipo_accion                  -- tipo de accion      ,f
ld_comenta                         -- comentario de la llamada      ,fld_nom_cam                         -- interaccion del discador        ,ID_TELEFONO_ALO                     -- NRO_DEPENDIENTE DE ALO       ,fld_fec_ges                         -- FECHA 
DE GESTION          ,fld_id_gestion                      -- id de la gestion  
     ,REGISTRO  
    FROM  TMP_GESTIONES_CARGA_TECNOCOB_ALO  
    WHERE  REGISTRO > 0  
   AND  REGISTRO <= 100000  
   AND ID_TELEFONO_ALO != 0  
   AND fld_id_cliente_alo != 0  
  ORDER BY REGISTRO ASC  
  
  
  OPEN RECORRE_GESTION  
  FETCH NEXT FROM RECORRE_GESTION  
           INTO       @GES_ID_CLIENTE                   
                           ,@GES_ID_USUARIO                                                         ,@GES_ID_SUB_RESPUESTA                                                   ,@GES_ID_TIPO_ACCION                                                     ,@GES_COM
ENTARIO                                                         ,@GES_INTERACCION_DISCADOR                                               ,@GES_NRO_DEPENDIENTE             ,@GES_FECHA_GESTION                                                      ,@GES_ID_GE
STION_TECNO  
                           ,@GES_REGISTRO    
  
  
  
  
  WHILE @@FETCH_STATUS = 0    
  BEGIN  
    
/*-------------------------------------------------------------------------*/    
/*              EJECUTA SP PARA MIGRAR GESTIONES HACIA ALO                 */    
/*-------------------------------------------------------------------------*/  
  
  EXEC  tecnocob.dbo.SP_MIGRACION_ALO_SP_CREATE_GESTION_ALO              
                                                 @GES_ID_CLIENTE                   
                      ,@GES_ID_USUARIO                                                    ,@GES_ID_SUB_RESPUESTA                                              ,@GES_ID_TIPO_ACCION                                                ,@GES_COMENTARIO             
                                       ,@GES_INTERACCION_DISCADOR                                          ,@GES_NRO_DEPENDIENTE             ,@GES_FECHA_GESTION                                                 ,@GES_ID_GESTION OUTPUT                     
         
  
/*-------------------------------------------------------------------------*/    
/*              INSERTA COMPROMISOS DE PAGOS ASOCIADOS                     */    
/*-------------------------------------------------------------------------*/  
   
  INSERT INTO TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
           (ID_GESTION_ALO  
           ,ID_GESTION_TECNO  
            )  
     VALUES  
           (@GES_ID_GESTION  
           ,@GES_ID_GESTION_TECNO  
            )  
      
    
  FETCH NEXT FROM RECORRE_GESTION  
  INTO    @GES_ID_CLIENTE                   
      ,@GES_ID_USUARIO                                    ,@GES_ID_SUB_RESPUESTA                                 ,@GES_ID_TIPO_ACCION                                ,@GES_COMENTARIO                                    ,@GES_INTERACCION_DISCADOR            
              ,@GES_NRO_DEPENDIENTE     ,@GES_FECHA_GESTION                                ,@GES_ID_GESTION_TECNO  
   ,@GES_REGISTRO    
  END  
  
 CLOSE RECORRE_GESTION  
 DEALLOCATE RECORRE_GESTION  
   /*---------------------------------------------------------------------------------------------------------------------------*/    
/*                                      FIN CURSOR DE TRASPASO GESTIONES                                                     */    
/*---------------------------------------------------------------------------------------------------------------------------*/   /*-------------------------------------------------------------------------*/    
/*              Actualiza datos necesarios para Compromisos                */    
/*-------------------------------------------------------------------------*/   UPDATE                          TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
 SET                             fld_rut_cli             =       B.fld_rut_cli  
           ,fld_cod_usu             =       B.fld_cod_usu  
           ,fld_id_usuario          =       B.fld_id_usuario  
           ,fld_num_tel             =       B.fld_num_tel  
           ,fld_cod_emp             =       B.fld_cod_emp  
           ,fld_fec_ges             =       B.fld_fec_ges  
 FROM                            TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS      A WITH(NOLOCK)  
 INNER JOIN                      TMP_GESTIONES_CARGA_TECNOCOB_ALO                  B WITH(NOLOCK)  
 ON                              B.fld_id_gestion        =       A.ID_GESTION_TECNO  
 /*-------------------------------------------------------------------------*/    
/*              Actualiza fecha y monto de compromiso                      */    
/*-------------------------------------------------------------------------*/   UPDATE                         TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
 SET                            FECHA_COMPROMISO         =       A.fld_fec_com  
                   ,MONTO_COMPROMISO         =       A.fld_mon_com  
                   ,fld_tip_comp             =       A.fld_tip_com  
                   ,fld_est_comp             =       A.fld_est_com  
 FROM                           tbl_telefonia_comp_pago                          A WITH(NOLOCK)  
 INNER JOIN                     TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS     B WITH(NOLOCK)  
 ON                             CAST(a.fld_fec_ing AS DATE) =    CAST(b.fld_fec_ges AS DATE)  
 AND                            A.fld_cod_usu            =       b.fld_cod_usu  
 AND                            A.fld_rut_cli            =       b.fld_rut_cli  
 WHERE                          A.fld_cod_emp            =       @CEDENTE  
  /*-------------------------------------------------------------------------*/    
/*              Homologar Tipo de compromiso con los de IBR_ALO            */    
/*-------------------------------------------------------------------------*/   
 UPDATE TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
 SET    ID_TIPO_COMPROMISO  =  CASE   
           WHEN fld_tip_comp = '1'    
             THEN 1   
           WHEN fld_tip_comp = '2'    
             THEN 4   
           WHEN fld_tip_comp = '3'    
             THEN 9  
           WHEN fld_tip_comp = '4'    
             THEN 3  
           WHEN fld_tip_comp = '6'    
             THEN 6  
           WHEN fld_tip_comp = '7'    
             THEN 7  
           WHEN fld_tip_comp = '8'    
             THEN 8  
           END  
  
 /*-------------------------------------------------------------------------*/    
/*              Homologar ID_ESTADO con los de IBR_ALO                     */    
/*-------------------------------------------------------------------------*/  
  
UPDATE TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
SET ID_ESTADO_COMPROMISO_PAGO =   CASE   
           WHEN fld_tip_comp = '1'    
             THEN 1   
                                      WHEN fld_tip_comp = '2'    
             THEN 2   
              WHEN fld_tip_comp = '3'    
             THEN 5   
           WHEN fld_tip_comp = '4'    
             THEN 4  
           WHEN fld_tip_comp = '5'    
             THEN 3   
           WHEN fld_tip_comp = '6'    
             THEN 6  
           WHEN fld_tip_comp = '7'    
             THEN 7  
                                   END  
  
/*-------------------------------------------------------------------------*/    
/*              Agrega Identity a la tabla de Compromisos                  */    
/*-------------------------------------------------------------------------*/  
  
ALTER TABLE TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  ADD REGISTRO INT IDENTITY(1,1)  
 /*-------------------------------------------------------------------------*/    
/*              DECLARACION DE VARIABLES PARA MIGRAR COMPROMISOS           */    
/*-------------------------------------------------------------------------*/  
   DECLARE   @COMP_ID_GESTION                INT            
    ,@COMP_ID_TIPO_COMPROMISO        INT                        ,@COMP_FECHA_COMPROMISO          DATETIME                ,@COMP_MONTO_COMPROMISO          DECIMAL(18,0)    ,@COMP_ID_ESTADO_COMPROMISO_PAGO INT    ,@COMP_REGISTRO                  INT       /
*---------------------------------------------------------------------------------------------------------------------------*/    
/*                       CURSOR PARA TRASPASAR COMPROMISOS DE PAGO DE TECNOCOB HACIA ALO                                   */    
/*---------------------------------------------------------------------------------------------------------------------------*/  
   
   DECLARE RECORRE_COMPROMISO CURSOR FOR    
   SELECT                   ID_GESTION_ALO              -- ID DE GESTION  
            ,ID_TIPO_COMPROMISO          -- TIPO COMPROMISO  
            ,FECHA_COMPROMISO            -- FECHA DE COMPROMISO   
            ,MONTO_COMPROMISO            -- MONTO COMPROMISO  
            ,ID_ESTADO_COMPROMISO_PAGO   -- ESTADO COMPROMISO    
                        ,REGISTRO  
   FROM                     TMP_GESTIONES_CARGA_TECNOCOB_ALO_COMPROMISOS  
   WHERE                    FECHA_COMPROMISO IS NOT NULL  
   AND                      REGISTRO     > 0  
   AND                      REGISTRO    <= 1000000  
   ORDER BY                 REGISTRO     ASC    OPEN RECORRE_COMPROMISO  
  FETCH NEXT FROM RECORRE_COMPROMISO  
     INTO    @COMP_ID_GESTION                        
    ,@COMP_ID_TIPO_COMPROMISO                                ,@COMP_FECHA_COMPROMISO                          ,@COMP_MONTO_COMPROMISO              ,@COMP_ID_ESTADO_COMPROMISO_PAGO     ,@COMP_REGISTRO                        
   
  
  WHILE @@FETCH_STATUS = 0    
  BEGIN  
    
  EXEC  SP_MIGRACION_ALO_CREATE_COMPROMISO_PAGO_ALO       @COMP_ID_GESTION                        
                                                      ,@COMP_ID_TIPO_COMPROMISO                                                                                   ,@COMP_FECHA_COMPROMISO                                                                      
       ,@COMP_MONTO_COMPROMISO                                                                 ,@COMP_ID_ESTADO_COMPROMISO_PAGO      
  
  FETCH NEXT FROM RECORRE_COMPROMISO  
  INTO       @COMP_ID_GESTION                        
    ,@COMP_ID_TIPO_COMPROMISO                                ,@COMP_FECHA_COMPROMISO                          ,@COMP_MONTO_COMPROMISO              ,@COMP_ID_ESTADO_COMPROMISO_PAGO     ,@COMP_REGISTRO                        
  END  
  
  CLOSE RECORRE_COMPROMISO  
  
  DEALLOCATE RECORRE_COMPROMISO  
 /*-----------------------------------------------------------------*/ /*------------------------- End User Code -------------------------*/ /*-----------------------------------------------------------------*/ End 