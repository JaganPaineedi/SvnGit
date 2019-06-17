 /****** Object:  StoredProcedure [dbo].[ssp_SCGetMedicationDetails]    Script Date: 07/03/2017 11:19:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetMedicationDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetMedicationDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetMedicationDetails]    Script Date: 07/03/2017 11:19:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetMedicationDetails] 
	 
	 @ClientId INT
	,@StartDate date = ''
	,@EndDate date = ''

	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_SCGetMedicationDetails										*/
	/* Creation Date: 07/03/2017															*/
	/*																						*/
	/* Purpose: To display Mars detail														*/
	/*  exec ssp_SCGetMedicationDetails 275,'2017-05-20','2017-06-20'					        */
	/*                                                                                      */
/* Updates:                                                          */                  
/* Date			Author			Purpose                                   */                  
/* 07/03/2017   Alok Kumar		Created    Ref: AspenPointe-Customizations #103                                  */ 

/* 07/21/2017   Alok Kumar		Modified   Replaced ScheduledDate to @StartDate and @EndDate to get the records when @EndDate is empty. 
											Added MedAdminRecordId in order by clause to get the records in sorted order.		Ref: AspenPointe-Customizations #103		*/
/* 31/08/2017  Aravind          Modified    Logic added to  calculate total quantity column 
                                           	Task #103 AspenPointe-Customizations(As per Courtney's Latest comments */
										 
/*********************************************************************/
AS  
BEGIN  
  
  
 BEGIN TRY  
 -- Update MAR ClientOrderId for RX Order where ClientOrderid is null
 -- Aravind - #103 Changes Starts here
 Declare @CountDay INT
 If ISNULL(@StartDate,'')<>'' and ISNULL(@EndDate,'') <>'' 
	SET @CountDay = (Select DATEDIFF (day, @StartDate , @EndDate )+ 1)
 ELSE
	SET @CountDay =1
-- ENDs here

	Update MAR
	Set MAR.ClientOrderId=(select Top 1 MA.ClientOrderid From MedAdminRecords MA Where MA.ClientMedicationId=
								MAR.ClientMedicationId and MA.ClientOrderid is not null)
	From MedAdminRecords  MAR
	Where MAR.ClientOrderId is null  AND (ISNULL(RecordDeleted, 'N') = 'N')  

  -- Update the Not Given status for MAR Schedule based on "MARoverdueLookbackHours" System configurations                
  EXEC [ssp_SCUpdateMARNotGivenStatus] @ClientId  

  
  CREATE TABLE #ListAdministered (  
   ClientOrderId INT  
   ,ScheduleCount INT  
   ,AdministeredCount INT  
   )  

  CREATE TABLE #ListMedRecords (  
   MedAdminRecordId INT  
   ,ClientOrderId INT  
   ,ScheduledDate DATE  
   ,ScheduledTime TIME(0)  
   ,DualSignRequired CHAR(1)  
   ,AdministeredDate VARCHAR(10)  
   ,AdministeredTime VARCHAR(5)  
   ,AdministeredBy INT  
   ,[Status] INT  
   ,AdministeredDose VARCHAR(25)  
   ,IsDiscontinuedOrCompleted CHAR(1)  
   ,OrderStartDateTime DATETIME  
   ,OrderName VARCHAR(500)  
   ,Strength VARCHAR(25)  
   ,StrengthUnitOfMeasure VARCHAR(25)  
   ,MedicineDisplayAlternate VARCHAR(100)  
   ,MedicationFrequency VARCHAR(50)  
   ,IsSelfAdministered CHAR(1)  
   ,MedicationDosage VARCHAR(30)  
   ,MedicationUnit VARCHAR(30)  
   ,ClientMedicationId INT  
   ,AcknowedgePending CHAR(1)  
   ,ConsentIsRequired CHAR(1)   
   ,InboundMedicationId INT    
   )  
  
  
  INSERT INTO #ListMedRecords 
  SELECT MedAdminRecordId  
   ,ClientOrderId  
   ,ScheduledDate  
   ,ScheduledTime  
   ,DualSignRequired  
   ,AdministeredDate  
   ,AdministeredTime  
   ,AdministeredBy  
   ,STATUS  
   ,AdministeredDose  
   ,IsDiscontinuedOrCompleted  
   ,OrderStartDateTime  
   ,OrderName  
   ,Strength  
   ,StrengthUnitOfMeasure  
   ,MedicationName  
   ,MedicationFrequency  
   ,IsSelfAdministered  
   ,MedicationDosage  
   ,MedicationUnit  
   ,ClientMedicationId  
   ,AcknowedgePending  
   ,ConsentIsRequired  
   ,InboundMedicationId
  FROM (  
   SELECT MA.MedAdminRecordId  
    ,MA.ClientOrderId  
    ,MA.ScheduledDate  
    ,MA.ScheduledTime  
    ,'N' AS DualSignRequired  
    ,CONVERT(VARCHAR(10), MA.AdministeredDate, 101) AS AdministeredDate  
    ,CONVERT(VARCHAR(5), MA.AdministeredTime, 108) AS AdministeredTime  
    ,MA.AdministeredBy  
    ,MA.STATUS  
    ,MA.AdministeredDose  
    ,CASE   
     WHEN isnull(CM.Discontinued, 'N') = 'Y'  
      THEN 'Y'  
     ELSE 'N'  
     END AS 'IsDiscontinuedOrCompleted'  
    ,CM.MedicationStartDate AS OrderStartDateTime  
    ,MN.MedicationName AS OrderName  
    ,ISNULL(MM.Strength, '') AS Strength  
    ,MM.StrengthUnitOfMeasure  
    ,'(' + MN.MedicationName + ')' AS MedicationName  
    ,GC4.CodeName AS 'MedicationFrequency'             
    ,'N' AS IsSelfAdministered  
   -- ,CMI.Quantity AS 'MedicationDosage'
    -- Aravind - #103 Changes Starts here
      ,CASE   
     WHEN  ISNULL(@EndDate,'') = ''
      THEN (CMI.Quantity*OTF.TimesPerDay)    
     ELSE (CMI.Quantity*OTF.TimesPerDay*@CountDay)  
     END --                
    AS 'MedicationDosage'
    -- Ends here  
    ,ISNULL(GC3.CodeName, '') AS 'MedicationUnit'  
    ,MA.ClientMedicationId  
    ,'N' AS AcknowedgePending  
    ,'N' AS ConsentIsRequired  
    ,NULL AS InboundMedicationId
   FROM MedAdminRecords AS MA  
   INNER JOIN ClientMedications AS CM ON MA.ClientMedicationId = CM.ClientMedicationId  
    AND ISNULL(CM.RecordDeleted, 'N') = 'N'  
    AND (ISNULL(MA.RecordDeleted, 'N') = 'N')  
   INNER JOIN ClientMedicationInstructions AS CMI ON CM.ClientMedicationId = CMI.ClientMedicationId  
    AND ISNULL(CMI.RecordDeleted, 'N') = 'N' AND ISNULL(CMI.Active,'Y') ='Y' 
   INNER JOIN Clients AS C ON C.ClientId = CM.ClientId  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
   INNER JOIN MDMedicationNames MN ON CM.MedicationNameId = MN.MedicationNameId  
    AND ISNULL(MN.RecordDeleted, 'N') = 'N'  
   INNER JOIN OrderTemplateFrequencies OTF ON  OTF.RxFrequencyId = CMI.Schedule					
						AND ISNULL(OTF.RecordDeleted, 'N') = 'N' 	
   LEFT JOIN Staff AS S ON S.StaffId = CM.PrescriberId  
    AND ISNULL(S.RecordDeleted, 'N') = 'N'  
   INNER JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId  
    AND ISNULL(MM.RecordDeleted, 'N') = 'N' --and MM.Status =4881 --select * from GlobalCodes where GlobalCodeId in (4882,4881,4884)                  
   LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = CMI.Unit  
    AND ISNULL(GC3.RecordDeleted, 'N') = 'N'  
   LEFT JOIN Orders AS O ON CM.MedicationNameId = O.MedicationNameId  
    AND ISNULL(O.RecordDeleted, 'N') = 'N'  
    AND ISNULL(O.Active, 'Y') = 'Y'  
   LEFT JOIN GlobalCodes AS GC4 ON GC4.GlobalCodeId = OTF.RxFrequencyId  
    AND ISNULL(GC4.RecordDeleted, 'N') = 'N'  
   WHERE   
    (CM.ClientId = @ClientId)  
	and ( not exists (select 1 from OrderTemplateFrequencies O 
											where O.RxFrequencyId = CMI.Schedule and ISNULL(O.IsDefault,'N')='Y' AND ISNULL(O.RecordDeleted, 'N') = 'N'  )
			or (exists (select 1 from OrderTemplateFrequencies O1 
											where O1.RxFrequencyId = CMI.Schedule and ISNULL(O1.IsDefault,'N')='Y' AND ISNULL(O1.RecordDeleted, 'N') = 'N' )) and 
						 ISNULL(OTF.IsDefault,'N')='Y')               
    AND ( (MA.ScheduledDate >= @StartDate)
			--OR (@StartDate is null)			--07/21/2017   Alok Kumar
			AND ((MA.ScheduledDate <= @EndDate)
				OR ISNULL(@EndDate,'') = '')		--07/21/2017   Alok Kumar
		)               
     
   UNION ALL  
     
   SELECT MA.MedAdminRecordId  
    ,MA.ClientOrderId  
    ,MA.ScheduledDate  
    ,MA.ScheduledTime  
    ,O.DualSignRequired  
    ,CONVERT(VARCHAR(10), MA.AdministeredDate, 101) AS AdministeredDate  
    ,CONVERT(VARCHAR(5), MA.AdministeredTime, 108) AS AdministeredTime  
    ,MA.AdministeredBy  
    ,MA.STATUS  
    ,MA.AdministeredDose  
    ,CASE   
     WHEN CO.OrderStatus = 6508  
      THEN 'Y'  
     ELSE CO.OrderDiscontinued  
     END --  6508 Order Complete                  
    AS 'IsDiscontinuedOrCompleted'  
    ,CO.OrderStartDateTime  
    ,CASE   
     WHEN IM.ClientOrderId IS NOT NULL  
      THEN REPLACE(REPLACE(REPLACE(IM.DrugNDCDescription, 'DELAY.', 'DELAYED'), 'DOCUSATE SOD.', 'DOCUSATE SOD. '), '. ', '. - ')  
     ELSE O.OrderName  
     END OrderName  
    ,ISNULL(MM.Strength, '') AS Strength  
    ,MM.StrengthUnitOfMeasure  
    ,CASE   
     WHEN IM.ClientOrderId IS NOT NULL  
      THEN CASE   
        WHEN ISNULL(O.AlternateOrderName1, '') <> ''  
         THEN '(' + REPLACE(REPLACE(O.AlternateOrderName1, 'DELAY.', 'DELAYED'), '. ', '. - ') + ')'  
        ELSE '' --'(' + O.OrderName + ')'  
        END  
     ELSE CASE   
       WHEN ISNULL(O.AlternateOrderName1, '') <> ''  
        THEN ' (' + O.AlternateOrderName1 + ')'  
       ELSE ''--'(' + O.OrderName + ')'  
       END  
     END AS MedicationName  
    ,GC1.CodeName AS 'MedicationFrequency'                  
    ,ISNULL(CO.MaySelfAdminister, 'N') AS IsSelfAdministered  
    --,CASE   
    -- WHEN IM.ClientOrderId IS NULL  
    --  THEN CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT) / 100  
    -- ELSE IM.Dose  
    -- END AS 'MedicationDosage'
        -- Aravind - #103 Changes Starts here
      ,CASE   
     WHEN IM.ClientOrderId IS NULL  
      THEN 
      CASE WHEN  ISNULL(@EndDate,'') = ''
      THEN (CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT)*OTF.TimesPerDay) / 100 
      ELSE (CAST(CAST((ROUND(CO.MedicationDosage, 2) * 100) AS INT) AS FLOAT)*OTF.TimesPerDay*@CountDay) / 100 
     END --
    ELSE  CASE WHEN IM.ClientOrderId IS NOT NULL
    THEN
      CASE WHEN  ISNULL(@EndDate,'') = ''
     THEN IM.Dose*OTF.TimesPerDay  
      ELSE IM.Dose*OTF.TimesPerDay*@CountDay 
     END -- 
     END  
     END AS 'MedicationDosage' 
 ---     -- Aravind - #103 Changes Starts here     
    ,CASE   
     WHEN IM.ClientOrderId IS NULL  
      THEN GC3.CodeName  
     ELSE IM.GiveUnit  
     END AS 'MedicationUnit'  
    ,MA.ClientMedicationId     
    ,ISNULL(CO.OrderPendAcknowledge, 'N') AS AcknowedgePending  
    ,ISNULL(CO.ConsentIsRequired, 'N') AS ConsentIsRequired  
    ,IM.InboundMedicationId AS InboundMedicationId
   FROM MedAdminRecords AS MA  
   INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId  
    AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
    AND (ISNULL(MA.RecordDeleted, 'N') = 'N')  
   INNER JOIN Clients AS C ON C.ClientId = CO.ClientId  
    AND ISNULL(C.RecordDeleted, 'N') = 'N'  
   INNER JOIN Orders AS O ON CO.OrderId = O.OrderId  
    AND ISNULL(O.RecordDeleted, 'N') = 'N'  
    AND ISNULL(O.Active, 'Y') = 'Y'            
   LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId  
    AND ISNULL(OTF.RecordDeleted, 'N') = 'N'  
   LEFT JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = OTF.FrequencyId                
    AND ISNULL(GC1.RecordDeleted, 'N') = 'N'                
   INNER JOIN Staff AS S ON S.StaffId = CO.OrderingPhysician  
    AND ISNULL(S.RecordDeleted, 'N') = 'N'  
   LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId  
    AND ISNULL(OS.RecordDeleted, 'N') = 'N'  
   LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId  
    AND ISNULL(MM.RecordDeleted, 'N') = 'N'  
   LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId  
    AND ISNULL(IM.RecordDeleted, 'N') = 'N'  
   LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = OS.MedicationUnit  
    AND ISNULL(GC3.RecordDeleted, 'N') = 'N'   
   WHERE MA.ClientMedicationId IS NULL
    AND (CO.ClientId = @ClientId)  
    AND ( (MA.ScheduledDate >= @StartDate)
			--OR (@StartDate is null)		--07/21/2017   Alok Kumar
			AND ((MA.ScheduledDate <= @EndDate)
				OR ISNULL(@EndDate,'') = '')		--07/21/2017   Alok Kumar
		) 
    AND (  
     CO.DiscontinuedDateTime IS NULL  
     )  
   ) AllData  
   
  ORDER BY AllData.ScheduledDate, AllData.MedAdminRecordId		--07/21/2017   Alok Kumar
  
  
  
  
  INSERT INTO #ListAdministered  
  SELECT ClientOrderId  
   ,Count(ScheduledTime)  
   ,COUNT(AdministeredTime)  
  FROM #listmedrecords  
  GROUP BY ClientOrderId  
  
  INSERT INTO #ListAdministered  
  SELECT ClientMedicationId  
   ,Count(ScheduledTime)  
   ,COUNT(AdministeredTime)  
  FROM #listmedrecords  
  GROUP BY ClientMedicationId  
  
  UPDATE R  
  SET R.IsDiscontinuedOrCompleted = 'Y'  
  FROM #listmedrecords R  
  INNER JOIN #ListAdministered L ON R.ClientOrderId = L.ClientOrderId  
  INNER JOIN ClientOrders CO ON CO.ClientOrderId = R.ClientOrderId  
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
   AND cast(CO.OrderEndDateTime AS DATE) = R.ScheduledDate  
  WHERE L.ScheduleCount = L.AdministeredCount  
   AND L.ScheduleCount > 0  
  
  UPDATE R  
  SET R.IsDiscontinuedOrCompleted = 'Y'  
  FROM #listmedrecords R  
  INNER JOIN ClientMedications CO ON CO.ClientMedicationId = R.ClientMedicationId  
   AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
  --and cast(CO.OrderEndDateTime as DATE)=R.ScheduledDate                  
  WHERE CO.Discontinued = 'Y'  ;

  
  WITH CTE  
  AS (  
   SELECT *  
    ,ROW_NUMBER() OVER (  
     PARTITION BY MedAdminRecordId ORDER BY InboundMedicationId DESC  
     ) AS Rn  
   FROM #ListMedRecords  
   )  
  DELETE  
  FROM CTE  
  WHERE Rn > 1  


  --Select Orders Information                   
  SELECT ClientOrderId  
   ,MedicineDisplay + ' ' + Strength + StrengthUnitOfMeasure AS Medications
   ,MedicationFrequency AS Frequency
   ,MedicationDosage AS Quantity
   ,Scheduledtime AS DispenseTimes
   ,MedAdminRecordIds
  FROM (  
   SELECT DISTINCT isnull(ClientMedicationId, ClientOrderId) AS 'ClientOrderId'  
    ,OrderName AS 'MedicineDisplay'  
    ,MedicineDisplayAlternate AS 'MedicineDisplayAlternate'  
    ,max(IsDiscontinuedOrCompleted) AS IsDiscontinuedOrCompleted  
    ,DualSignRequired  
    ,OrderStartDateTime  
    ,max(ScheduledDate) AS ScheduledDate  
    ,ISNULL(STUFF((SELECT ', ' + ISNULL(cast(convert(VARCHAR(5), L1.Scheduledtime, 108) as Varchar), '') From  #ListMedRecords L1 where L1.ScheduledDate= max(LstMed.ScheduledDate) AND isnull(L1.ClientMedicationId, L1.ClientOrderId) = isnull(LstMed.ClientMedicationId, LstMed.ClientOrderId) FOR XML PATH('') ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '')  AS Scheduledtime
    ,ISNULL(STUFF((SELECT '#' + ISNULL(cast(L2.MedAdminRecordId as Varchar), '') From  #ListMedRecords L2 where  isnull(L2.ClientMedicationId, L2.ClientOrderId) = isnull(LstMed.ClientMedicationId, LstMed.ClientOrderId) FOR XML PATH('') ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '')  AS MedAdminRecordIds
    ,max(AdministeredDate) AS AdministeredDate  
    ,max(AdministeredTime) AS AdministeredTime 
    ,Strength  
    ,StrengthUnitOfMeasure  
    ,MedicationFrequency  
    ,IsSelfAdministered  
    ,MedicationDosage  
    ,MedicationUnit  
    ,AcknowedgePending  
    ,ConsentIsRequired            

   FROM #ListMedRecords AS LstMed  
   Where IsNull(DualSignRequired,'N') <> 'Y' And IsNull(IsDiscontinuedOrCompleted,'N') <> 'Y' 
			And AdministeredDate is null --and AdministeredTime Is Null and AdministeredBy Is Null
   GROUP BY ClientOrderId  
    ,ClientMedicationId  
    ,OrderName  
    ,MedicineDisplayAlternate  
    ,DualSignRequired  
    ,OrderStartDateTime  
    ,Strength  
    ,StrengthUnitOfMeasure  
    ,MedicationFrequency  
    ,IsSelfAdministered  
    ,MedicationDosage  
    ,MedicationUnit  
    ,AcknowedgePending  
    ,ConsentIsRequired         
   ) OrderData  
  ORDER BY ScheduledDate    
  

  
  
  DROP TABLE #listmedrecords  
  
  DROP TABLE #ListAdministered  
  
 END TRY  
  
 BEGIN catch 
        DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'ssp_SCGetMedicationDetails') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error,-- Message text.             
                    16,-- Severity.             
                    1 -- State.             
        ); 
    END catch 
END