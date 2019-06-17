/****** Object:  StoredProcedure [dbo].[ssp_validateClientOrders]    Script Date: 11/28/2013 18:04:12 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateClientOrders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_validateClientOrders]
GO


/****** Object:  StoredProcedure [dbo].[ssp_validateClientOrders]    Script Date: 11/28/2013 18:04:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 Create PROCEDURE [dbo].[ssp_validateClientOrders]  
 @DocumentVersionId INT  
AS  
/************************************************************************************/  
/* Stored Procedure: dbo.[ssp_validateClientOrders]   171     */  
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */  
/* Creation Date:   18/Oct/2013             */  
/* Purpose:To validate 'Client Order' document    */  
/*                     */  
/* Input Parameters:  @DocumentVersionId      */  
/*                     */  
/* Output Parameters:   None              */  
/*                     */  
/* Return:  0=success, otherwise an error number         */  
/*                     */  
/* Called By:                  */  
/*                     */  
/* Calls:                   */  
/*       Exec ssp_validateClientOrders    1097          */  
/* Data Modifications:                */  
/*                     */  
/* Updates:                   */  
/*  Date          Author             Purpose            */  
/* 18/Oct/2013    Gautam            created  */  
/* 08/Apr/2014    Prasan            Added Rationale text as mandatory for medication orders  */  
/* 11/Apr/2014    Prasan            modified format of message to "order name – error message"  */  
/* 19/Feb/2015    Gautam   The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table  
         and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */  
/* 16/Mar/2015   Revathi   what:Added validation for Sensitive orders and  Signature required Orders  
         why:task #844 & #873 Woods-Customization */  
/* 25 May 2015   Chethan N   What: Added new column 'RationaleOtherText'  
         Why:  Philhaven Development task # 252 */  
/* 05 Jun 2015   Chethan N   What: Drug - Drug Interaction acknowledgement validation based on the systemconfigurationkeys value  
         Why:  Philhaven Development task # 295 */  
/* 19 Jan 2017   Chethan N   What: Added validation for Day Supply when order is not Discontinued.  
         Why:  Renaissance - Dev Items task #5 */  
/* 31 Mar 2017   Chethan N   What: exec custom SP for the Custom Validations.  
         Why:  Key Point - Customizations task #41 */ 

/* 28 Dec 2017   Mohammed Junaid   What : Added validation for Lab when LaboratoryId is empty
         Why:  Woods - Support Go Live #796    */
/* 8 Feb 2018   Vijeta Sinha   What : Added validation for A diagnosis that is not valid for FY
         Why:  	AspenPointe - Support Go Live #702    */
 /* 28 Feb 2018   Sunil.Dasari   What : Modified code to hide lab validation based on configuration key(HideLabValidatiOnClientOrderSign) 
							Added By (28 Dec 2017   Mohammed Junaid Woods - Support Go Live #796  )
         Why:   kalamazoo getting lab validation as they don't have labs unable to sign client orders
				We fixed this issue based on configuration key(HideLabValidatiOnClientOrderSign) if this key value set to 'Y' then hiding the lab validation. */
/* 19 April 2018	Ponnin   Modified the Lab validations by using OrderLabs table instead of Laboratories table. Allegan - Support #1336*/
-- 11 July 2018		Vithobha	Removed the validation for Day Supply Must Be Specified, because logic was implemented in JS. StarCare - SmartCareIP: #9
/************************************************************************************/  
BEGIN  
 BEGIN TRY  
  --    
  ------ Added by  Revathi 16/mar/2015  
  DECLARE  @AuthorId INT  
  SET @AuthorId=(SELECT AuthorId FROM Documents WHERE InProgressDocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N')  
       
     DECLARE @Level1 INT  
     DECLARE @Level2 INT  
     DECLARE @Level3 INT  
       
     SET @Level1 = CASE (SELECT dbo.ssf_GetSystemConfigurationKeyValue('SeverityLevel1RequiresAcknowledment'))  
       WHEN 'Y' THEN 1 ELSE -1 END  
     SET @Level2 = CASE (SELECT dbo.ssf_GetSystemConfigurationKeyValue('SeverityLevel2RequiresAcknowledment'))  
       WHEN 'Y' THEN 2 ELSE -1 END  
     SET @Level3 = CASE (SELECT dbo.ssf_GetSystemConfigurationKeyValue('SeverityLevel3RequiresAcknowledment'))  
       WHEN 'Y' THEN 3 ELSE -1 END  
       
     DECLARE @LabSoftEnabled CHAR(1)  
       
     SELECT @LabSoftEnabled = dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTENABLED') 
          
     Declare @EffectiveDate DATETIME 
     select  @EffectiveDate = Documents.EffectiveDate      
    FROM    Documents  
    WHERE   InProgressDocumentVersionId = @DocumentVersionId   
    
     DECLARE @EnforceICD10FiscalYearValidation CHAR(1) = 'Y'
      SELECT @EnforceICD10FiscalYearValidation = Value  
        FROM SystemConfigurationKeys SCK  
        WHERE [Key] = 'EnforceICD10FiscalYearValidation'  
            AND ISNULL(RecordDeleted, 'N') = 'N'  
  --Create Temp Tables              
  ------             
  CREATE TABLE #ClientOrders (  
   ClientOrderId INT  
   ,OrderId INT  
   ,OrderedBy INT  
   ,OrderingPhysician INT  
   ,OrderMode INT  
   ,OrderStatus INT  
   ,OrderStartDateTime DATETIME  
   ,OrderEndDateTime DATETIME  
   ,OrderDiscontinued CHAR(1)  
   ,OrderType INT  
   ,MedicationOtherDosage INT  
   ,MedicationOrderStrengthId INT  
   ,MedicationDosage DECIMAL(18, 2)  
   ,MedicationUnits INT  
   ,MedicationOrderRouteId INT  
   ,OrderFrequencyId INT  
   ,OrderPriorityId INT  
   ,OrderName VARCHAR(500)  
   ,RationaleText VARCHAR(max)  
   ,RationaleOtherText VARCHAR(max)  
   ,MedicationDaySupply INT
   ,LaboratoryId    INT  
   )  
  
  INSERT INTO #ClientOrders (  
   ClientOrderId  
   ,OrderId  
   ,OrderedBy  
   ,OrderingPhysician  
   ,OrderMode  
   ,OrderStatus  
   ,OrderStartDateTime  
   ,OrderEndDateTime  
   ,OrderDiscontinued  
   ,OrderType  
   ,MedicationOtherDosage  
   ,MedicationOrderStrengthId  
   ,MedicationDosage  
   ,MedicationUnits  
   ,MedicationOrderRouteId  
   ,OrderFrequencyId  
   ,OrderPriorityId  
   ,OrderName  
   ,RationaleText  
   ,RationaleOtherText  
   ,MedicationDaySupply  
   ,LaboratoryId
   )  
  SELECT CO.ClientOrderId  
   ,CO.OrderId  
   ,CO.OrderedBy  
   ,CO.OrderingPhysician  
   ,CO.OrderMode  
   ,CO.OrderStatus  
   ,CO.OrderStartDateTime  
   ,CO.OrderEndDateTime  
   ,CO.OrderDiscontinued  
   ,O.OrderType  
   ,CO.MedicationOtherDosage  
   ,CO.MedicationOrderStrengthId  
   ,CO.MedicationDosage  
   ,CO.MedicationUnits  
   ,CO.MedicationOrderRouteId  
   ,CO.OrderTemplateFrequencyId  
   ,CO.OrderPriorityId  
   ,O.OrderName  
   ,CO.RationaleText  
   ,CO.RationaleOtherText  
   ,CO.MedicationDaySupply  
   ,CO.LaboratoryId
   
  FROM ClientOrders CO  
  INNER JOIN Orders O ON CO.OrderId = O.OrderId  
  WHERE CO.DocumentVersionId = @documentVersionId  
   AND isnull(CO.RecordDeleted, 'N') = 'N'  
   AND isnull(O.RecordDeleted, 'N') = 'N'  
  
  CREATE TABLE #validationReturnTable (  
   TableName VARCHAR(100)  
   ,ColumnName VARCHAR(100)  
   ,ErrorMessage VARCHAR(max)  
   ,TabOrder INT  
   ,ValidationOrder INT  
   )  
  
  INSERT INTO #validationReturnTable (  
   TableName  
   ,ColumnName  
   ,ErrorMessage  
   )  
  SELECT 'ClientOrders'  
   ,'EnteredBy'  
   ,OrderName + ' - Entered By Must Be Specified'  
  FROM #ClientOrders  
  WHERE ISNULL(OrderedBy, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderingPhysician'  
   ,OrderName + ' - Ordering Physician Must Be Specified'  
  FROM #ClientOrders  
  WHERE ISNULL(OrderingPhysician, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderMode'  
   ,OrderName + ' - Order Mode Must Be Specified'  
  FROM #ClientOrders  
  WHERE ISNULL(OrderMode, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderStatus'  
   ,OrderName + ' - Order Status Must Be Specified'  
  FROM #ClientOrders  
  WHERE ISNULL(OrderStatus, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderEndDateTime'  
   ,OrderName + ' - EndDateTime Should  Be Greater Than StartDateTime'  
  FROM #ClientOrders  
  WHERE OrderStartDateTime IS NOT NULL  
   AND OrderEndDateTime IS NOT NULL  
   AND OrderDiscontinued <> 'Y'  
   AND OrderEndDateTime < OrderStartDateTime  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'MedicationOtherDosage'  
   ,OrderName + ' - Strength Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND (ISNULL(MedicationOtherDosage, '') = '')  
   AND (ISNULL(MedicationOrderStrengthId, '') = '')  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'MedicationDosage'  
   ,OrderName + ' - Dose Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(MedicationDosage, 0) = 0  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'MedicationUnits'  
   ,OrderName + ' - Unit Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(MedicationUnits, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'MedicationOrderRouteId'  
   ,OrderName + ' - Route Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(MedicationOrderRouteId, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderFrequencyId'  
   ,OrderName + ' - Frequency Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(OrderFrequencyId, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderPriorityId'  
   ,OrderName + ' - Priority Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(OrderPriorityId, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderStartDateTime'  
   ,OrderName + ' - StartDateTime Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND OrderStartDateTime IS NULL  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'RationaleText'  
   ,OrderName + ' - Rationale Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(RationaleText, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'RationaleOtherText'  
   ,OrderName + ' - Rationale Other Text Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 8501 -- Medication      
   AND ISNULL(RationaleOtherText, '') = '' AND ISNULL(RationaleText, '') = 'Other'  
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderFrequencyId'  
   ,OrderName + ' - Frequency Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 6481 -- Lab      
   AND ISNULL(OrderFrequencyId, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrders'  
   ,'OrderPriorityId'  
   ,OrderName + ' - Priority Must Be Specified'  
  FROM #ClientOrders  
  WHERE OrderType = 6481 -- Lab      
   AND ISNULL(OrderPriorityId, '') = ''  
    
  UNION  
    
  SELECT 'ClientOrdersDiagnosisIIICodes'  
   ,'DiagnosisIIICodes'  
   ,CO.OrderName + ' - Atleast One Diagnosis Must Be Specified' --COLLATE DATABASE_DEFAULT        
  FROM #ClientOrders CO  
  INNER JOIN Orders ORD ON ORD.OrderId = CO.OrderId  
   AND ISNULL(ORD.RecordDeleted, 'N') != 'Y'  
   AND ISNULL(ORD.NeedsDiagnosis, 'N') = 'Y'  
  WHERE CO.OrderType = 6481 -- Lab      
   AND NOT EXISTS (  
    SELECT *  
    FROM ClientOrdersDiagnosisIIICodes COD  
    WHERE COD.ClientOrderId = CO.ClientOrderId  
     AND ISNULL(COD.RecordDeleted, 'N') = 'N'  
    )  
    
    
    UNION  All
   -- 28 Dec 2017   Mohammed Junaid 
  SELECT 'LaboratoryId'  
   ,'Laboratories'  
   ,CO.OrderName + ' - Lab Must Be Specified' --COLLATE DATABASE_DEFAULT        
  FROM #ClientOrders CO  
  INNER JOIN Orders ORD ON ORD.OrderId = CO.OrderId  
   AND ISNULL(ORD.RecordDeleted, 'N')  = 'N' AND ISNULL(CO.LaboratoryId, -1)  = -1  
  WHERE CO.OrderType = 6481 -- Lab      
   AND EXISTS (  
    SELECT *  
    FROM OrderLabs OL  
    WHERE OL.OrderId = CO.OrderId  
     AND ISNULL(OL.RecordDeleted, 'N') = 'N'  
    )   
     AND NOT EXISTS (  
     SELECT 1 FROM systemconfigurationkeys where [KEY]='HideLabValidatiOnClientOrderSign' and isnull(Value,'N')='Y'
    )   
    
    
    
    
    
  UNION ALL  
    
  SELECT 'ClientOrdersInteractionDetails'  
   ,'ClientOrderId1'  
   ,'Acknowledge Is Required Between ' + O.OrderName COLLATE DATABASE_DEFAULT + ' And  ' + O1.OrderName --COLLATE DATABASE_DEFAULT        
  FROM ClientOrdersInteractionDetails COID  
  INNER JOIN ClientOrders CO ON COID.ClientOrderId1 = CO.ClientOrderId  
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
  INNER JOIN ClientOrders CO1 ON COID.ClientOrderId2 = CO1.ClientOrderId  
   AND ISNULL(CO1.RecordDeleted, 'N') = 'N'  
  INNER JOIN Orders O ON CO.OrderId = O.OrderId  
   AND isnull(O.RecordDeleted, 'N') = 'N'  
  INNER JOIN Orders O1 ON CO1.OrderId = O1.OrderId  
   AND isnull(O1.RecordDeleted, 'N') = 'N'  
  WHERE COID.DocumentVersionId = @documentVersionId  
   AND isnull(CO.RecordDeleted, 'N') = 'N'  
   AND ISNULL(COID.RecordDeleted, 'N') = 'N'  
   AND COID.InteractionLevel  IN (@Level1, @Level2, @Level3)  
   AND ISNULL(COID.PrescriberAcknowledged, 'N') = 'N'  
  ------ Added by  Revathi 16/mar/2015  
    
  UNION ALL  
    
  SELECT TOP 1 'ClientOrder'  
   ,'Sensitive'  
   ,'Sensitive orders can''t be placed with any other order types'  
  FROM ClientOrders CO  
  WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'  
   AND CO.DocumentversionId = @DocumentVersionId  
   AND EXISTS  
    (  
     SELECT 1  
     FROM ClientOrders CO1  
     INNER JOIN Orders OS1 ON CO1.OrderId = OS1.OrderId  
     WHERE ISNULL(CO1.RecordDeleted, 'N') = 'N'  
      AND ISNULL(OS1.RecordDeleted, 'N') = 'N'  
      AND CO1.DocumentversionId = @DocumentVersionId  
      AND ISNULL(OS1.Sensitive, 'N') = 'N'  
     )   
    AND EXISTS (  
     SELECT 1  
     FROM ClientOrders CO2  
     INNER JOIN Orders OS2 ON CO2.OrderId = OS2.OrderId  
     WHERE ISNULL(CO2.RecordDeleted, 'N') = 'N'  
      AND ISNULL(OS2.RecordDeleted, 'N') = 'N'  
      AND CO2.DocumentversionId = @DocumentVersionId  
      AND ISNULL(OS2.Sensitive, 'N') = 'Y'  
     )  
    
  UNION ALL  
    
  SELECT DISTINCT 'ClientOrder'  
   ,'Role'  
   ,'Order - ' + OS.OrderName + ' requires role to sign order,change author to the user who has the required role'  
  FROM ClientOrders CO  
  INNER JOIN Orders OS ON CO.OrderId = OS.OrderId  
  INNER JOIN OrderAcknowledgments OA ON OA.OrderId = OS.OrderId  
  WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'  
   AND ISNULL(OS.RecordDeleted, 'N') = 'N'  
   AND ISNULL(OA.NeedsSignature, 'N') = 'Y'  
   AND CO.DocumentversionId = @DocumentVersionId  
   AND (  
    SELECT COUNT(SR.RoleId)  
    FROM StaffRoles SR  
    INNER JOIN OrderAcknowledgments OA ON SR.RoleId = OA.RoleId  
    WHERE SR.RoleId = OA.RoleId  
     AND OA.OrderId = OS.OrderId  
     AND ISNULL(OA.NeedsSignature, 'N') = 'Y'  
     AND ISNULL(OA.RecordDeleted, 'N') = 'N'  
     AND ISNULL(SR.RecordDeleted, 'N') = 'N'  
     AND SR.StaffId = @AuthorId  
    ) = 0  
   AND ISNULL(OA.RecordDeleted, 'N') = 'N'  
   AND ISNULL(OS.RecordDeleted, 'N') = 'N'  
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
    
  IF ISNULL(@LabSoftEnabled,'') ='Y'  
  BEGIN  
   INSERT INTO #validationReturnTable (  
   TableName  
   ,ColumnName  
   ,ErrorMessage  
   )  
    EXEC  scsp_validateClientOrders  @DocumentVersionId  
     
  END  
  
  IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'csp_validateClientOrders')  
  BEGIN  
   INSERT INTO #validationReturnTable (  
    TableName  
    ,ColumnName  
    ,ErrorMessage  
    )  
     EXEC  csp_validateClientOrders  @DocumentVersionId  
  END  
  
  --------------vsinha
      IF EXISTS ( SELECT 1  
                    FROM Documents D  
                        JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId  
                    WHERE D.InProgressDocumentVersionId = @DocumentVersionId    
                        AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                        AND ISNULL(DC.RecordDeleted, 'N') = 'N' )  
        BEGIN  
            --#############################################################################  
            -- Check ICD10 validity with respect to Fiscal Year  
            --#############################################################################   
            IF @EnforceICD10FiscalYearValidation = 'Y'  
                AND @EffectiveDate >= '10/1/2015' -- FY16  
                BEGIN  
                    -- CMS Fiscal year begins 92 days before end of current calendar year  
                    DECLARE @FiscalYear INTEGER   
                    SELECT @FiscalYear = YEAR(DATEADD(dd, 92, @EffectiveDate))  
  
      INSERT INTO #validationReturnTable (  
      TableName  
      ,ColumnName  
      ,ErrorMessage  
      )  
     SELECT 'ClientOrdersDiagnosisIIICodes'  
      ,'ICD10CodeId'  
      ,'A Billable ICD10 Code ''' + DICD.ICD10Code + ''' is not valid for FY' + CAST(@FiscalYear AS VARCHAR)       
      FROM [dbo].[ClientOrdersDiagnosisIIICodes] cod  
	  INNER JOIN ClientOrders CL ON CL.ClientOrderId = cod.ClientOrderId  
	   AND CL.DocumentVersionId = @documentVersionId  
	  JOIN DiagnosisICD10Codes DICD ON DICD.ICD10CodeId=cod.ICD10CodeId    
	  WHERE ISNULL(cod.RecordDeleted, 'N') = 'N'     
      AND NOT EXISTS (  
       SELECT 1  
       FROM ICD10FiscalYearAvailability IFYA  
       WHERE DICD.ICD10Code = IFYA.ICD10Code  
        AND IFYA.CMSFiscalYear = @FiscalYear  
        AND ISNULL(IFYA.RecordDeleted, 'N') = 'N'  
       )  
  
   END  
         
  END  
  
  
  SELECT TableName  
   ,ColumnName  
   ,ErrorMessage  
   ,TabOrder  
   ,ValidationOrder  
  FROM #validationReturnTable  
   END TRY            
  Begin CATCH                             
  declare @Error varchar(8000)                                                        
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_validateClientOrders')                                                         
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                          
  + '*****' + Convert(varchar,ERROR_STATE())                                                                        
  End CATCH            
 End   