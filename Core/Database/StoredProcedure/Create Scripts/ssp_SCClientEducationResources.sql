

/****** Object:  StoredProcedure [dbo].[ssp_SCClientEducationResources]    Script Date: 08/23/2016 20:57:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCClientEducationResources]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCClientEducationResources]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCClientEducationResources]    Script Date: 08/23/2016 20:57:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCClientEducationResources] (  
 @SessionId VARCHAR(30)  
 ,@InstanceId INT  
 ,@PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@OtherFilter INT  
 ,@ClientId INT  
 ,@LabVitalsDataAfterdatetime DATETIME  
 ,@TypeOfInformation VARCHAR(2)  
 )  
 /********************************************************************************                                                                                     
-- Stored Procedure: dbo.[ssp_SCClientEducationResources]                                                                                       
--                                                                                     
-- Copyright: Streamline Healthcate Solutions                                                                                     
--                                                                                     
-- Purpose: used by Client Documents list page                                                                                     
--                                                                                     
-- Updates:                                                                                                                                            
-- Date        Author             Purpose                                                                                     
-- 05.03.2011  Priyanka GUPTA     Created.                                                                                           
-- 05.23.2011  Devi Dayal Jangra                      
-- 03.15.2012  Saurav Pande Implemented function call [dbo].GetClientEducationValues() w.ref. to task 484 Kalamazoo Bugs.                     
-- 03.29.2012  Maninder      Added column ListPageSCClientEducationResourceId in #ResultSet                   
-- 11.15.2013  Gautam        Added new input parameter @TypeOfInformation to search on Type of Information and removed the                    
--               ListTable concept. Why : Required for the task #5, Core Bugs               
-- 1/21/2014   Shruthi.S     Added logic to bind from clienthealthdataattributes based on paramterttype instead of healthdata.Ref #5 Meaningful Use.                  
-- 10/15/2014  PPOTNURU      Modified logic for health data element and added logic for orders              
-- 11/03/2014  PPOTNURU   Added support for new Diagnosis.              
-- 12/12/2014  Gautam        Added logic to call scsp_SCClientEducationResources for Macon Triage document,               
        why :Task #50.5,Macon County - Design ,Triage Document - Client Education              
-- 03/Sep/2015 Gautam        Commented the ICD9 code and link with DiagnosisICD10Codes table for ICD10 changes. Task#13 ,Diagnosis Changes (ICD10)           
-- 29/Sep/2015 Gautam        Replaced DSMCode with ICD10Code related to table Educationresourcediagnoses,Macon County - Design > Tasks#50.5 > Triage Document - Client Education     
-- 23/Aug/2016 Pradeep Kumar Yadav   Added logic to return value when we selected All Diannosis Radio Button  For Task #359 Woodland-Support                    
-- 07/Jul/2017 Chethan N	 What : Retrieving SharedDate
--							 Why : Meaningful Use - Stage 3 task #46	
-- 10 AUG 2017  Pavani       What :Modified column name from 'DocumentDescription' to 'DocumentDiscription'
                             Why : Because of sorting issue Task: Rear River Go Live #314
-- 17/Jan/2018  Gautam       What: Added @clientId check with table ClientEducationResources in final select.
							 why : It was pulling data for all clients.Harbor - Support,#1578,PROD: Client Education Resources - Multiple Row Display    
-- 24/Apr/2018  Bibhu        What: scsp_SCClientEducationResourcesCHDValue is getting called(The educational materials provided to clients should be based on provider-checked values
							 In the individual client’s flowsheets)
							 why : KCMHSAS - Support: #898 
08/28/2018		Msood		What: Changed the datatype from Int to Varchar(1) where creating #CHDvalue temp table
							Why:   KCMHSAS - Support: #1183  	
09/25/2018		Msood		What: Added ISNULL condition for icddescription & ICD10Code as it was not displaying the ResourceURL
							Why:  Journey - Support Go Live Task #278					                                   
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  SET NOCOUNT ON;  
  
  DECLARE @ApplyFilterClicked CHAR(1)  
  
  IF (@TypeOfInformation = '')  
   SET @TypeOfInformation = - 1  
  IF Isnull(@SortExpression, '') = ''  
  BEGIN  
   SET @SortExpression = 'InformationType desc'  
  END  
  --SET @PageNumber = 1          
  
  -- The table #CustomDocumentTriage is required for Macon custom Document entry if exists               
  Create Table #CustomDocumentTriage          
  (          
  HealthConditions Varchar(500),          
  Value varchar(100))          
-- 24/Apr/2018  Bibhu
	 IF OBJECT_ID('tempdb..#CHDvalue') IS NOT NULL   
     DROP TABLE #CHDvalue
	  -- Msood 08/28/2018
     Create Table #CHDvalue(Value Varchar(1))
       
	 IF object_id('dbo.scsp_SCClientEducationResourcesCHDValue', 'P') IS NOT NULL  
	 EXEC scsp_SCClientEducationResourcesCHDValue
	
	
  IF object_id('dbo.scsp_SCClientEducationResources', 'P') IS NOT NULL  
  EXEC scsp_SCClientEducationResources @OtherFilter,@ClientId,@LabVitalsDataAfterdatetime,@TypeOfInformation,@SortExpression          
          
          
    --1.) Those Record which has  InformationType='M' AND AllMedications='Y'                                                  
    ;  
  
  WITH listeducationresources  
  AS (  
   SELECT DISTINCT CASE informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END AS 'InformationType'  
    ,[dbo].Getclienteducationvalues(CER.informationtype, CER.Educationresourceid, CER.allmedications, CER.alldiagnoses, CER.ParameterType) AS 'Value'  
    ,description  
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'          THEN 'URL'          
     WHEN 'P'  
      THEN 'PDF'  
     END AS 'DocumentType'  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
      THEN Replace(Replace(resourceurl, '<MedicationNameID>', MDMName.medicationnameid), '<MedicationName>', MDMName.medicationname)  
     ELSE ''  
     END AS ResourceURL  
    ,Educationresourceid  
   FROM clientmedications CMed  
   INNER JOIN mdmedicationnames MDMName ON CMed.medicationnameid = MDMName.medicationnameid  
   CROSS JOIN Educationresources CER  
   WHERE CMed.clientid = @ClientId  
    AND Isnull(CMed.discontinued, 'N') = 'N'  
    AND (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    AND Isnull(CER.allmedications, 'N') = 'Y'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND Isnull(CMed.recorddeleted, 'N') = 'N'  
   --2.) Those Record which has  InformationType='M' AND AllMedications='N'                                                  
     
   UNION -- paramtertype =6309              
     
   SELECT DISTINCT CASE informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END  
    ,[dbo].Getclienteducationvalues(CER.informationtype, CER.educationresourceid, CER.allmedications, CER.alldiagnoses, CER.ParameterType) AS 'Value'  
    ,description  
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
      THEN Replace(Replace(resourceurl, '<MedicationNameID>', MDMName.medicationnameid), '<MedicationName>', MDMName.medicationname)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM clientmedications CMed  
   INNER JOIN mdmedicationnames MDMName ON CMed.medicationnameid = MDMName.medicationnameid  
   INNER JOIN Educationresourcemedications CERM ON CERM.medicationnameid = MDMName.medicationnameid  
   INNER JOIN Educationresources CER ON CERM.Educationresourceid = CER.Educationresourceid  
   WHERE CMed.clientid = @ClientId  
    AND Isnull(CMed.discontinued, 'N') = 'N'  
    AND (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    AND Isnull(CER.allmedications, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND Isnull(CMed.recorddeleted, 'N') = 'N'  
   --3.) Those Record which has  InformationType='H'                                                 
     
   UNION  
     
   SELECT DISTINCT CASE informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END  
    ,HD.NAME AS 'value'  
    ,HD.[description]  
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
      THEN Replace(Replace(resourceurl, '<HealthDataCategoryId>', HD.HealthDataAttributeId), '<CategoryName>', HD.NAME)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM ClientHealthDataAttributes CHD  
   INNER JOIN HealthDataAttributes HD ON HD.HealthDataAttributeId = chd.HealthDataAttributeId  
   INNER JOIN EducationResourceHealthDataElements ER ON ER.HealthParameterValue = HD.HealthDataAttributeId  
    AND Isnull(ER.recorddeleted, 'N') = 'N'  
   --INNER JOIN healthdatacategories HDC              
   --ON HD.healthdatacategoryid = HDC.healthdatacategoryid              
   INNER JOIN Educationresources CER ON CER.EducationResourceId = ER.EducationResourceId --AND CER.ParameterType=6309              
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
   --ON CER.healthdatacategoryid = HDC.healthdatacategoryid              
   WHERE (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND Isnull(CHD.recorddeleted, 'N') = 'N'  
    AND CHD.clientid = @ClientId  
    AND CHD.HealthRecordDate >= @LabVitalsDataAfterdatetime  
    AND Isnull(HD.recorddeleted, 'N') = 'N'  
    and (isnull(CHD.value,'N') = (Select Value From #CHDvalue) Or Not Exists(Select 1 From #CHDvalue) ) 
   UNION  
     
   SELECT DISTINCT CASE informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END  
    ,O.OrderName AS 'value'  
    ,CER.[description]  
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
      THEN Replace(Replace(resourceurl, '<HealthDataCategoryId>', O.OrderId), '<CategoryName>', O.OrderName)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM ClientOrders CO  
   --JOIN HealthDataAttributes HD ON HD.HealthDataAttributeId=chd.HealthDataAttributeId              
   INNER JOIN EducationResourceOrders ERO ON CO.OrderId = ERO.OrderId  
    AND Isnull(ERO.recorddeleted, 'N') = 'N'  
   INNER JOIN Orders O ON CO.OrderId = O.OrderId  
    AND Isnull(O.recorddeleted, 'N') = 'N'  
   --INNER JOIN healthdatacategories HDC              
   --ON HD.healthdatacategoryid = HDC.healthdatacategoryid              
   INNER JOIN Educationresources CER ON CER.EducationResourceId = ERO.EducationResourceId --AND CER.ParameterType=6309              
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
   INNER JOIN Documents D ON D.DocumentId = CO.DocumentId  
    AND Isnull(D.recorddeleted, 'N') = 'N' AND D.[Status]=22          
   --ON CER.healthdatacategoryid = HDC.healthdatacategoryid              
   WHERE (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND CO.clientid = @ClientId  
    AND D.EffectiveDate >= @LabVitalsDataAfterdatetime       
     
   UNION  
   -- 23/Aug/2016 Pradeep Kumar Yadav            
   --4.) Those Record which has  InformationType='D'  AND AllDiagnosis= 'Y'  for ICD Code                                                             
   SELECT CASE informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END  
    ,CASE   
     WHEN CER.parametertype = 6305  
      THEN DIICodes.ICD10Code  
     ELSE DICDCodes.ICDDescription  
     END AS 'Value'  
    ,description  
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
	  -- Msood 09/25/2018
     -- THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DICDCodes.icddescription), '<DiagnosisId>', DIICodes.ICD10Code)  
	  THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', isnull(DICDCodes.icddescription,'')), '<DiagnosisId>', isnull(DIICodes.ICD9Code,''))    
     ELSE ''  
     END AS ResourceURL  
    ,  
    --ClientEducationResourceId,                              
    CER.Educationresourceid  
   FROM documents Doc  
   INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid AND Isnull(DC.recorddeleted, 'N') = 'N'          
   INNER JOIN DocumentDiagnosisCodes DIICodes ON DIICodes.documentversionid = Doc.currentdocumentversionid AND Isnull(DIICodes.recorddeleted, 'N') = 'N'          
   INNER JOIN DiagnosisICD10Codes DICDCodes ON (DIICodes.ICD10CodeId = DICDCodes.ICD10CodeId)  
   --INNER JOIN Educationresourcediagnoses CERD ON CERD.ICD10CodeId = DICDCodes.ICD10CodeId  AND Isnull(CERD.recorddeleted, 'N') = 'N'              
   CROSS JOIN Educationresources CER  
   WHERE (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    --AND CER.ParameterType IN ( 6305, 6306 )                   
    AND Isnull(CER.alldiagnoses, 'N') = 'Y'  
    AND Doc.clientid = @ClientId  
    AND Doc.DocumentCodeId = 1601  
    AND Isnull(Doc.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND cast(Doc.EffectiveDate AS DATE) >= cast(@LabVitalsDataAfterdatetime AS DATE)  
     
   UNION  
     
   --8.) Those Record which has  InformationType='D'  AND AllDiagnosis= 'N' for ICD10 Code                                                            
   SELECT CASE informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END  
    ,CASE   
     WHEN CER.parametertype = 6305  
      THEN DIICodes.ICD10Code  
     ELSE DICDCodes.ICDDescription  
     END AS 'Value'  
    ,description  
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
	  --Msood 09/25/2018
      --THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DICDCodes.icddescription), '<DiagnosisId>', DIICodes.ICD9Code)  
	  THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', isnull(DICDCodes.icddescription,'')), '<DiagnosisId>', isnull(DIICodes.ICD9Code,''))    

     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM documents Doc  
   INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid AND Isnull(DC.recorddeleted, 'N') = 'N'          
   INNER JOIN DocumentDiagnosisCodes DIICodes ON DIICodes.documentversionid = Doc.currentdocumentversionid AND Isnull(DIICodes.recorddeleted, 'N') = 'N'          
   INNER JOIN DiagnosisICD10Codes DICDCodes ON (DIICodes.ICD10CodeId = DICDCodes.ICD10CodeId)  
   INNER JOIN Educationresourcediagnoses CERD ON CERD.ICD10CodeId = DICDCodes.ICD10CodeId  AND Isnull(CERD.recorddeleted, 'N') = 'N'          
   INNER JOIN Educationresources CER ON CERD.Educationresourceid = CER.Educationresourceid  
   WHERE (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    --AND CER.ParameterType IN ( 6305, 6306 )                   
    AND Isnull(CER.alldiagnoses, 'N') = 'N'  
    AND Doc.clientid = @ClientId  
    AND DC.diagnosisdocument = 'Y'  
    AND Doc.DocumentCodeId = 1601  
    AND Isnull(Doc.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT *  
     FROM documents Doc2  
     INNER JOIN documentcodes DC2 ON Doc2.documentcodeid = DC2.documentcodeid  
     WHERE Doc2.clientid = @ClientId  
      AND DC2.diagnosisdocument = 'Y'  
      AND Doc2.DocumentCodeId = 1601  
      AND Isnull(Doc2.recorddeleted, 'N') = 'N'  
      AND Doc.documentid <> Doc2.documentid  
      AND (  
       Cast(Doc2.effectivedate AS DATE) > Cast(Doc.effectivedate AS DATE)  
       OR (  
        Doc2.effectivedate = Doc.effectivedate  
        AND Doc2.documentid > doc.documentid  
        )  
       )  
     )  
   UNION  
   --9.) Those Record which has  InformationType='D' for Document Triage                
   SELECT CASE CER.informationtype  
     WHEN 'M'  
      THEN 'Medication'  
     WHEN 'H'  
      THEN 'Health Data Element'  
     WHEN 'D'  
      THEN 'Diagnosis'  
     WHEN 'O'  
      THEN 'Order'  
     END  
    ,CASE   
     WHEN CER.parametertype = 6305  
      THEN DT.Value --DIICodes.ICD9Code              
     ELSE DT.HealthConditions --DICDCodes.icddescription              
     END AS 'Value'  
    ,DT.HealthConditions --description              
    ,CASE CER.documenttype  
     WHEN 'R'  
      THEN 'Report'  
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
      THEN Replace(Replace(resourceurl, '<HealthCondition>', DT.HealthConditions), '<Value>', DT.Value)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM Educationresourcediagnoses CERD  JOIN   #CustomDocumentTriage DT ON CERD.ICD10Code = DT.Value          
   INNER JOIN Educationresources CER ON CERD.Educationresourceid = CER.Educationresourceid  
   WHERE (  
     CER.informationtype = @TypeOfInformation  
     OR @TypeOfInformation = '-1'  
     )  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
   )  
   ,counts  
  AS (  
   SELECT Count(*) AS TotalRows  
   FROM listeducationresources  
   )  
   ,rankresultset  
  AS (  
   SELECT informationtype  
    ,[description]  
    ,documenttype  
    ,resourceurl  
    ,Educationresourceid  
    ,value  
    ,Count(*) OVER () AS TotalCount  
    ,Rank() OVER (  
     ORDER BY CASE   
       WHEN @SortExpression = 'InformationType '  
        THEN informationtype  
       END  
      ,CASE   
       WHEN @SortExpression = 'InformationType desc'  
        THEN informationtype  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Value'  
        THEN value  
       END  
      ,CASE   
       WHEN @SortExpression = 'Value desc'  
        THEN value  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'DocumentDiscription'  
        THEN [description]  
       END  
      ,CASE   
       WHEN @SortExpression = 'DocumentDiscription desc'  
        THEN [description]  
       END DESC  
     ) AS RowNumber  
   FROM listeducationresources  
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT Isnull(totalrows, 0)  
        FROM counts  
        )  
     ELSE (@PageSize)  
     END  
    ) informationtype  
   ,[description]  
   ,documenttype  
   ,resourceurl  
   ,Educationresourceid  
   ,value  
   ,totalcount  
   ,rownumber  
  INTO #resultset  
  FROM rankresultset  
  WHERE rownumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT Isnull(Count(*), 0)  
    FROM #resultset  
    ) < 1  
  BEGIN  
   SELECT 0 AS PageNumber  
    ,0 AS NumberOfPages  
    ,0 NumberOfRows  
  END  
  ELSE  
  BEGIN  
   SELECT TOP 1 @PageNumber AS PageNumber  
    ,CASE (totalcount % @PageSize)  
     WHEN 0  
      THEN Isnull((totalcount / @PageSize), 0)  
     ELSE Isnull((totalcount / @PageSize), 0) + 1  
     END AS NumberOfPages  
    ,Isnull(totalcount, 0) AS NumberOfRows  
   FROM #resultset  
  END  
  
  SELECT @SessionId AS SessionId  
   ,@InstanceId AS InstanceId  
   ,@SortExpression AS SortExpression  
   ,rs.informationtype  
   ,rs.value  
   ,rs.[description] AS [DocumentDiscription]  
   ,rs.documenttype  
   ,rs.resourceurl  
   ,rs.Educationresourceid  
   ,CONVERT(VARCHAR(10), CER.SharedDate, 101) as SharedDate 
  FROM #resultset rs  
  Left JOIN ClientEducationResources CER ON rs.Educationresourceid = CER.Educationresourceid  
			AND CER.Clientid = @ClientId  -- 17/Jan/2018  Gautam  
			AND Isnull(CER.RecordDeleted, 'N') = 'N'  
  ORDER BY rs.rownumber  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCClientEducationResources') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                               
    16  
    ,  
    -- Severity.                                                             
    1 -- State.                                                             
    );  
 END CATCH  
END  
GO


