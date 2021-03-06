/****** Object:  StoredProcedure [dbo].[SP_HELPTEXT ssp_RDLClinicalSummaryEducationResource]    Script Date: 06/09/2015 04:09:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryEducationResource]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryEducationResource]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryEducationResource]    Script Date: 06/18/2015 12:36:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryEducationResource]      
	(
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
/**************************************************************  
Created By   : Veena S Mani 
Created Date : 28-02-2014  
Description  : Used to Get Education list data 
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18    
** 02/03/2016	 Ravichandra		 what: Column name renamed ICDCode as  ICD9Code in Educationresourcediagnoses
									 why :Meaningful Use Stage 2 Tasks#48 Clinial Summary - PDF Issues   								        

**************************************************************/
	BEGIN TRY
		DECLARE @DOS DATETIME = NULL

		IF (@ClientId IS NULL	AND @ServiceId <> 0	)
		BEGIN
			SELECT @ClientId = ClientId
				,@DOS = dateofservice
			FROM services
			WHERE serviceid = @ServiceId
		END
		--Select 'Recommended Patient Decision Aids:' as PatientAid 
		--,' Vendor Supplied' as Vender
		
		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
		END
		ELSE IF (@ServiceId IS NULL	AND @DocumentVersionId IS NOT NULL)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
			
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId 
			AND ISNULL(RecordDeleted,'N')='N'
		END
		
	
-- Declare @ClientId INT
 --Set @ClientId=14652
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
     WHEN 'U'  
      THEN 'URL'  
     WHEN 'P'  
      THEN 'PDF'  
     END AS 'DocumentType'  
    ,CASE   
     WHEN CER.documenttype = 'U'  
      AND Isnull(resourceurl, '') != ''  
      THEN Replace(Replace(resourceurl, '<MedicationNameID>', MDMName.medicationnameid), '<MedicationName>', MDMName.medicationname)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM clientmedications CMed  
   INNER JOIN mdmedicationnames MDMName ON CMed.medicationnameid = MDMName.medicationnameid  
   CROSS JOIN Educationresources CER  
   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   WHERE CMed.clientid = @ClientId  and CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  
    AND Isnull(CMed.discontinued, 'N') = 'N'  
    AND (  
     CER.informationtype = -1  
     OR -1 = '-1'  
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
    LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   WHERE CMed.clientid = @ClientId  and CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  
  
    AND Isnull(CMed.discontinued, 'N') = 'N'  
    AND (  
     CER.informationtype = -1  
     OR -1 = '-1'  
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
   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   
   
   --ON CER.healthdatacategoryid = HDC.healthdatacategoryid  
   WHERE (  
     CER.informationtype = -1  
     OR -1 = '-1'  
     )  
     AND
    CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND Isnull(CHD.recorddeleted, 'N') = 'N'  
    AND CHD.clientid = @ClientId  
   -- AND CHD.HealthRecordDate >= @LabVitalsDataAfterdatetime  
    AND Isnull(HD.recorddeleted, 'N') = 'N'  
   -- paramtertype 6310  
     
   UNION  
     
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
      THEN DIICodes.icdcode  
     ELSE DICDCodes.icddescription  
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
      THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DICDCodes.icddescription), '<DiagnosisId>', DIICodes.icdcode)  
     ELSE ''  
     END AS ResourceURL  
    ,  
    --ClientEducationResourceId,                  
    CER.Educationresourceid  
   FROM documents Doc  
   INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid  
   INNER JOIN diagnosesiiicodes DIICodes ON DIICodes.documentversionid = Doc.currentdocumentversionid  
   INNER JOIN diagnosisicdcodes DICDCodes ON (DIICodes.icdcode = DICDCodes.icdcode)  
   CROSS JOIN Educationresources CER  
   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   WHERE (  
     CER.informationtype = -1  
     OR -1 = '-1'  
     )  
    --AND CER.ParameterType IN ( 6305, 6306 )       
    AND Isnull(CER.alldiagnoses, 'N') = 'Y'  
    AND Doc.clientid = @ClientId  
    --AND Doc.DocumentCodeId = 5       
    AND Isnull(Doc.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND  CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT *  
     FROM documents Doc2  
     INNER JOIN documentcodes DC2 ON Doc2.documentcodeid = DC2.documentcodeid  
     WHERE Doc2.clientid = @ClientId  
      AND DC2.diagnosisdocument = 'Y'  
      --  AND Doc2.DocumentCodeId = 5                
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
     
   --5.) Those Record which has  InformationType='D' AND AllDiagnosis= 'Y' for DSM Code                                                
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
     WHEN CER.parametertype = 6304  
      THEN DiaIAndII.dsmcode  
     ELSE DiaDSMDesc.dsmdescription  
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
      THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DiaDSMDesc.dsmdescription), '<DiagnosisId>', DiaDSMDesc.dsmcode)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM documents Doc  
   INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid  
   INNER JOIN diagnosesiandii DiaIAndII ON DiaIAndII.documentversionid = Doc.currentdocumentversionid  
   INNER JOIN diagnosisdsmdescriptions DiaDSMDesc ON DiaDSMDesc.dsmcode = DiaIAndII.dsmcode  
    AND DiaDSMDesc.dsmnumber = DiaIAndII.dsmnumber  
   CROSS JOIN Educationresources CER  
   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   WHERE (  
     CER.informationtype = -1  
     OR -1 = '-1'  
     )  
    AND Isnull(CER.alldiagnoses, 'N') = 'Y'  
    AND Doc.clientid = @ClientId  
    AND DC.diagnosisdocument = 'Y' 
    AND   CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'   
    --  AND Doc.DocumentCodeId = 5                
    AND Isnull(Doc.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT *  
     FROM documents Doc2  
     INNER JOIN documentcodes DC2 ON Doc2.documentcodeid = DC2.documentcodeid  
     WHERE Doc2.clientid = @ClientId  
      AND DC2.diagnosisdocument = 'Y'  
      --  AND Doc2.DocumentCodeId = 5                
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
     
   --6.) Those Record which has  InformationType='D'  AND AllDiagnosis= 'N' for ICD Code                                                
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
      THEN DIICodes.icdcode  
     ELSE DICDCodes.icddescription  
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
      THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DICDCodes.icddescription), '<DiagnosisId>', DIICodes.icdcode)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   FROM documents Doc  
   INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid  
   INNER JOIN diagnosesiiicodes DIICodes ON DIICodes.documentversionid = Doc.currentdocumentversionid  
   INNER JOIN diagnosisicdcodes DICDCodes ON (DIICodes.icdcode = DICDCodes.icdcode)  
   INNER JOIN Educationresourcediagnoses CERD ON CERD.ICD9Code = DICDCodes.icdcode        --02/03/2016 Ravichandra
   INNER JOIN Educationresources CER ON CERD.Educationresourceid = CER.Educationresourceid 
   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid 
   WHERE (  
     CER.informationtype = -1  
     OR -1 = '-1'  
     )  
    --AND CER.ParameterType IN ( 6305, 6306 )       
    AND Isnull(CER.alldiagnoses, 'N') = 'N'  
    AND Doc.clientid = @ClientId  
    AND DC.diagnosisdocument = 'Y'  
    --  AND Doc.DocumentCodeId = 5                
    AND Isnull(Doc.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT *  
     FROM documents Doc2  
     INNER JOIN documentcodes DC2 ON Doc2.documentcodeid = DC2.documentcodeid  
     WHERE Doc2.clientid = @ClientId  
      AND DC2.diagnosisdocument = 'Y'  
      --  AND Doc2.DocumentCodeId = 5                
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
    LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   INNER JOIN Documents D ON D.DocumentId = CO.DocumentId  
    AND Isnull(D.recorddeleted, 'N') = 'N' AND D.[Status]=22  
   --ON CER.healthdatacategoryid = HDC.healthdatacategoryid  
   WHERE (  
     CER.informationtype = -1  
     OR -1 = '-1'  
     )  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND CO.clientid = @ClientId
    AND   CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'    
    --AND D.EffectiveDate >= @LabVitalsDataAfterdatetime  
     
   UNION  
     
   --7.) Those Record which has  InformationType='D' AND AllDiagnosis = 'N' for DSM Code                         
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
     WHEN CER.parametertype = 6304  
      THEN DiaIAndII.dsmcode  
     ELSE DiaDSMDesc.dsmdescription  
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
      THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DiaDSMDesc.dsmdescription), '<DiagnosisId>', DiaDSMDesc.dsmcode)  
     ELSE ''  
     END AS ResourceURL  
    ,CER.Educationresourceid  
   --,ResourceReportId,ParameterType                                  
   FROM documents Doc  
   INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid  
   INNER JOIN diagnosesiandii DiaIAndII ON DiaIAndII.documentversionid = Doc.currentdocumentversionid  
   INNER JOIN diagnosisdsmdescriptions DiaDSMDesc ON DiaDSMDesc.dsmcode = DiaIAndII.dsmcode  
    AND DiaDSMDesc.dsmnumber = DiaIAndII.dsmnumber  
   INNER JOIN Educationresourcediagnoses CERD ON CERD.dsmcode = DiaDSMDesc.dsmcode  
   INNER JOIN Educationresources CER ON CERD.Educationresourceid = CER.Educationresourceid  
   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid
   WHERE (  
     CER.informationtype = -1  
     OR -1 = '-1'  
     )  
    --AND CER.ParameterType IN ( 6304, 6306 )       
    AND Isnull(CER.alldiagnoses, 'N') = 'Y'  
    AND Doc.clientid = @ClientId  
    AND DC.diagnosisdocument = 'Y'  
    --  AND Doc.DocumentCodeId = 5                
    AND Isnull(Doc.recorddeleted, 'N') = 'N'  
    AND Isnull(CER.recorddeleted, 'N') = 'N'  
    AND   CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  
    AND NOT EXISTS (  
     SELECT *  
     FROM documents Doc2  
     INNER JOIN documentcodes DC2 ON Doc2.documentcodeid = DC2.documentcodeid  
     WHERE Doc2.clientid = @ClientId  
      AND DC2.diagnosisdocument = 'Y'  
      --  AND Doc2.DocumentCodeId = 5                
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
						THEN DIICodes.ICD9Code
					ELSE DICDCodes.icddescription
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
						THEN Replace(Replace(resourceurl, '<DiagnosisDescription>', DICDCodes.icddescription), '<DiagnosisId>', DIICodes.ICD9Code)
					ELSE ''
					END AS ResourceURL
				,CER.Educationresourceid
			FROM documents Doc
			INNER JOIN documentcodes DC ON Doc.documentcodeid = DC.documentcodeid AND Isnull(DC.recorddeleted, 'N') = 'N'
			INNER JOIN DocumentDiagnosisCodes DIICodes ON DIICodes.documentversionid = Doc.currentdocumentversionid AND Isnull(DIICodes.recorddeleted, 'N') = 'N'
			INNER JOIN diagnosisicdcodes DICDCodes ON (DIICodes.ICD9Code = DICDCodes.icdcode)   --02/03/2016 Ravichandra
			INNER JOIN Educationresourcediagnoses CERD ON CERD.ICD9Code = DICDCodes.icdcode  AND Isnull(CERD.recorddeleted, 'N') = 'N'
			INNER JOIN Educationresources CER ON CERD.Educationresourceid = CER.Educationresourceid
			   LEFT JOIN ClientEducationresources CCER on CER.Educationresourceid=CCER.Educationresourceid

			WHERE  Isnull(CER.alldiagnoses, 'N') = 'N'
				AND Doc.clientid = @ClientId
				AND DC.diagnosisdocument = 'Y'
				--  AND Doc.DocumentCodeId = 5              
				AND Isnull(Doc.recorddeleted, 'N') = 'N'
				AND Isnull(CER.recorddeleted, 'N') = 'N'
				AND NOT EXISTS (
					SELECT *
					FROM documents Doc2
					INNER JOIN documentcodes DC2 ON Doc2.documentcodeid = DC2.documentcodeid
					WHERE Doc2.clientid = @ClientId
						AND DC2.diagnosisdocument = 'Y'
						    AND   CCER.Clientid=@ClientId AND (CAST(CCER.SharedDate AS DATE) = CAST(@DOS AS DATE))  AND Isnull(CCER.recorddeleted, 'N') = 'N'  

						--  AND Doc2.DocumentCodeId = 5              
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
 
				
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryEducationResource') + '*****'
		+ Convert(VARCHAR, ERROR_LINE()) + '*****'
		 + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' 
		 + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                      
				16
				,-- Severity.                                                                                                      
				1 -- State.                                                                                                      
				);
	END CATCH
 
END
GO
