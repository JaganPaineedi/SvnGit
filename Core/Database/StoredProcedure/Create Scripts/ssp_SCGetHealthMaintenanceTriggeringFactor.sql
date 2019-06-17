/****** Object:  StoredProcedure [dbo].[ssp_SCGetHealthMaintenanceTriggeringFactor]    Script Date: 08/07/2012 05:00:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetHealthMaintenanceTriggeringFactor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetHealthMaintenanceTriggeringFactor]-- 1-- 16
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetHealthMaintenanceTriggeringFactor]    Script Date: 03/01/2012 11:37:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure ssp_SCGetHealthMaintenanceTriggeringFactor --9
@HealthMaintenanceTriggeringFactorGroupId INT
AS
BEGIN
/********************************************************************************************/                                                                    
/* Stored Procedure: ssp_SCGetHealthMaintenanceTriggeringFactor          */                                                           
/* Copyright: 2012 Streamline Healthcare Solutions           */                                                                    
/* Creation Date:  18 July 2014                */                                                                    
/* Purpose: Gets Data from PrimaryCate Health Maintenance Template */                                                                   
/* Input Parameters:  @HealthMaintenanceTriggeringFactorGroupId                    */                                                                  
/* Output Parameters:                  */                                                                    
/* Return:                     */  
/* Data Modifications:                  */
/* 18 July 2014     Veena S Mani   Created   */    
/* 7 Oct  2014		Ponnin		   Displaying descriptions for what was selected not all of them Why : For task #31.2 of MeaningFul Use */  
/* 16 Oct	2014	   Ponnin				   show Health Data Element from HealthDataAttributes table. Why : For task #4 of Certification 2014 */     
/* 21 Oct	2014	   Prasan				   show Allergies from MDAllergenConcepts table. Why : For task #4 of Certification 2014 */         
/* 21 Dec	2015	   Ponnin				   show Diagnosis Description from DiagnosisAllCodes table instead of DiagnosisICDCodes.   For task #14 of Diagnosis Changes (ICD10) */  
/* 03 Oct 2017	   Varun			Modified Gender Factor section. For task #58 Meaningful Use-Stage 3 */                                                          
/* 07 Dec	2018	   Jeffin				   Added a new Column DropDownCategory for implementation of Dropdown functionality. Why : For task #38 of Meaningful Use - Stage 3 */
/********************************************************************************************/ 

 BEGIN TRY 
 BEGIN
 DECLARE @TrigerringFactor INT ,@Description VARCHAR(max), @CodeId VARCHAR(max) ,@TriggeringDescription VARCHAR(max)
  
 -- Get HealthMaintenanceTriggeringFactorGroups 
 Select [HealthMaintenanceTriggeringFactorGroupId],
 [CreatedBy], 
 [CreatedDate],
 [ModifiedBy],
 [ModifiedDate],
 [RecordDeleted],
 [DeletedDate],
 [DeletedBy],
 [FactorName],
 [FactorDescription]

 FROM [HealthMaintenanceTriggeringFactorGroups] 
 WHERE (HealthMaintenanceTriggeringFactorGroupId = @HealthMaintenanceTriggeringFactorGroupId) 
 AND ISNULL(RecordDeleted,'N')<>'Y'  
 
CREATE TABLE #TempHealthMaintenanceTriggeringFactors(
HealthMaintenanceTriggeringFactorId int,
CreatedBy	varchar(30),
CreatedDate	datetime,
ModifiedBy	varchar(30),
ModifiedDate	datetime,
RecordDeleted	char(1),
DeletedDate	datetime,
DeletedBy	varchar(30),
HealthMaintenanceTriggeringFactorGroupId	int,
TrigerringFactor	int,
FromTimeYear	int,
FromTimeMonth	int,
ToTimeYear	int,
ToTimeMonth	int,
CodeId	varchar(max),
Gender char(1),
IncludeGenerics	char(1),
TrigerringFactorText varchar(100),
Description varchar(max),
TriggeringDescription varchar(max)
)

INSERT INTO #TempHealthMaintenanceTriggeringFactors(
HealthMaintenanceTriggeringFactorId ,
CreatedBy,
CreatedDate	,
ModifiedBy	,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy,
HealthMaintenanceTriggeringFactorGroupId,
TrigerringFactor,
FromTimeYear,
FromTimeMonth,
ToTimeYear,
ToTimeMonth	,
CodeId,
Gender,
IncludeGenerics,
TrigerringFactorText,
Description,
TriggeringDescription)

SELECT [HealthMaintenanceTriggeringFactorId]
	,[CreatedBy]
	,[CreatedDate]
	,[ModifiedBy]
	,[ModifiedDate]
	,[RecordDeleted]
	,[DeletedDate]
	,[DeletedBy]
	,[HealthMaintenanceTriggeringFactorGroupId]
	,[TrigerringFactor]
	,[FromTimeYear]
	,[FromTimeMonth]
	,[ToTimeYear]
	,[ToTimeMonth]
	,[CodeId]
	,[Gender]
	,[IncludeGenerics]
	,dbo.csf_GetGlobalCodeNameById(TrigerringFactor) as  TrigerringFactorText
	,CASE
				WHEN (TrigerringFactor = 8117)
			THEN 
	--	COALESCE(@Description + ', ' ,'') +  LTRIM(RTRIM(MedicationName)) from MDMedicationNames MN where MN.MedicationNameID in ([fnSplit](CodeId,',')) 
	''
		END AS [Description],
		--For Triggering description
		CASE 
		WHEN (TrigerringFactor = 8120)
			THEN CASE Gender
					WHEN  'A'
						THEN 'Male, Female, Unknown'
						WHEN  'M'
						THEN 'Male'
						WHEN  'F'
						THEN 'Female'
						WHEN  'U'
						THEN 'Unknown'
					END
		  WHEN (TrigerringFactor = 8116)
			THEN 
			CASE 
			when ISNULL(FromTimeYear, '') <> '' and ISNULL(FromTimeMonth, '') <> '' then 'From: ' else '' end +
			CASE 
			when ISNULL(FromTimeYear, '') <> '' then ( cast(FromTimeYear as varchar) + ' Years ' ) else '' end 
			+ case
					when ISNULL(FromTimeMonth, '') <> '' then (cast(FromTimeMonth as varchar) + ' Months ' ) else '' end + 
					CASE 
			when ISNULL(ToTimeYear, '') <> '' and ISNULL(ToTimeMonth, '') <> '' then 'To: ' else '' end +
					case 
					when ISNULL(ToTimeYear, '') <> '' then (cast(ToTimeYear as varchar) + ' Years ' ) else '' end + case
					when ISNULL(ToTimeMonth, '') <> '' then (  cast(ToTimeMonth as varchar) + ' Months ' ) else '' end 
					END as [TriggeringDescription]

FROM [HealthMaintenanceTriggeringFactors]

WHERE (HealthMaintenanceTriggeringFactorGroupId = @HealthMaintenanceTriggeringFactorGroupId)
	AND ISNULL(RecordDeleted, 'N') <> 'Y'

--UPDATE T
--SET T.[Description] = (       
--		 @Description =SELECT COALESCE(@Description + ', ', '') + LTRIM(RTRIM(ICDDescription))
--		FROM diagnosisicdcodes icd
--		INNER JOIN [fnSplit](T.CodeId,',') on icd.ICDCode=item
		
--		WHERE 
--			 T.TrigerringFactor = 8119
--		)
--FROM #TempHealthMaintenanceTriggeringFactors T where T.TrigerringFactor = 8119

-- Modified by Ponnin on 21 Dec 2015 - For task #14 of Diagnosis Changes (ICD10)
UPDATE T  
SET T.[Description] = (         
   SELECT REPLACE(REPLACE(STUFF((SELECT Distinct ', ' + LTRIM(RTRIM(DiagnosisDescription))  
  FROM DiagnosisAllCodes icd  
  INNER JOIN [fnSplit](T.CodeId,',') on icd.DiagnosisCode=item  where icd.IncludeInSearch='Y' and  icd.CodeType in ('ICD10', 'DSM5')
  FOR XML PATH(''))        
          ,1,1,'')        
          ,'&lt;','<'),'&gt;','>') 
  
  WHERE 
    T.TrigerringFactor = 8119
  )
FROM #TempHealthMaintenanceTriggeringFactors T where T.TrigerringFactor = 8119

-- Added by Ponnin Starts Here - Description for Health Data Element.
UPDATE T
SET T.[Description] = (       
   SELECT REPLACE(REPLACE(STUFF((SELECT Distinct ', ' + LTRIM(RTRIM(Name))
  FROM HealthDataAttributes icd
  INNER JOIN [fnSplit](T.CodeId,',') on icd.HealthDataAttributeId=item
  FOR XML PATH(''))      
          ,1,1,'')      
          ,'&lt;','<'),'&gt;','>')
  
  WHERE 
    T.TrigerringFactor = 8121
  )
FROM #TempHealthMaintenanceTriggeringFactors T where T.TrigerringFactor = 8121
-- Added by Ponnin. Ends Here - Description for Health Data Element.



UPDATE T
SET T.[Description] = (       
		--SELECT @Description = COALESCE(@Description + ', ', '') + LTRIM(RTRIM(Description))
		--FROM PCProcedureCodes icd
		--INNER JOIN [fnSplit](T.CodeId,',') on icd.ProcedureCode=item
		
		 SELECT REPLACE(REPLACE(STUFF((SELECT Distinct ', ' + LTRIM(RTRIM(Description))
  FROM PCProcedureCodes icd
  INNER JOIN [fnSplit](T.CodeId,',') on icd.ProcedureCode=item
  FOR XML PATH(''))      
          ,1,1,'')      
          ,'&lt;','<'),'&gt;','>')
  
  
		WHERE 
			 T.TrigerringFactor = 8118
		)
FROM #TempHealthMaintenanceTriggeringFactors T where T.TrigerringFactor = 8118



UPDATE T
SET T.[Description] = (       
		--SELECT @Description = COALESCE(@Description + ', ', '') + LTRIM(RTRIM(MedicationName))
		--FROM MDMedicationNames icd
		--INNER JOIN [fnSplit](T.CodeId,',') on icd.MedicationNameID=item
		
		SELECT REPLACE(REPLACE(STUFF((SELECT Distinct ', ' + LTRIM(RTRIM(MedicationName))
  FROM MDMedicationNames icd
  INNER JOIN [fnSplit](T.CodeId,',') on icd.MedicationNameID=item
  FOR XML PATH(''))      
          ,1,1,'')      
          ,'&lt;','<'),'&gt;','>')
          
		WHERE 
			 T.TrigerringFactor = 8117
		)
FROM #TempHealthMaintenanceTriggeringFactors T where T.TrigerringFactor = 8117


UPDATE T
SET T.[Description] = (       
		SELECT REPLACE(REPLACE(STUFF((SELECT Distinct ', ' + LTRIM(RTRIM(ConceptDescription))
  FROM MDAllergenConcepts MDAC
  INNER JOIN [fnSplit](T.CodeId,',') on MDAC.AllergenConceptId=item
  FOR XML PATH(''))      
          ,1,1,'')      
          ,'&lt;','<'),'&gt;','>')
          
		WHERE 
			 T.TrigerringFactor = 8122
		)
FROM #TempHealthMaintenanceTriggeringFactors T where T.TrigerringFactor = 8122



UPDATE T
SET T.[TriggeringDescription] = Case when T.TrigerringFactor =8116
then (TriggeringDescription)
when T.TrigerringFactor =8117 then ([Description])
when T.TrigerringFactor = 8118 then ([Description])
when T.TrigerringFactor = 8119 then ([Description])
when T.TrigerringFactor = 8121 then ([Description])
when T.TrigerringFactor = 8122 then ([Description])
when T.TrigerringFactor = 8120 then (TriggeringDescription)

end
	
FROM #TempHealthMaintenanceTriggeringFactors T 


Select 
HealthMaintenanceTriggeringFactorId ,
CreatedBy,
CreatedDate	,
ModifiedBy	,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy,
HealthMaintenanceTriggeringFactorGroupId,
TrigerringFactor,
FromTimeYear,
FromTimeMonth,
ToTimeYear,
ToTimeMonth	,
CodeId,
Gender,
IncludeGenerics,
TrigerringFactorText,
Description,
TriggeringDescription
from #TempHealthMaintenanceTriggeringFactors

 Select [HealthMaintenanceTriggeringFactorDetailId],
 PCHMT.[CreatedBy],
 PCHMT.[CreatedDate],
 PCHMT.[ModifiedBy], 
 PCHMT.[ModifiedDate], 
 PCHMT.[RecordDeleted], 
 PCHMT.[DeletedDate], 
 PCHMT.[DeletedBy], 
 PCHMT.[HealthMaintenanceTriggeringFactorId],
 Case WHEN HTP.TrigerringFactor = 8118
 THEN (SELECT top 1 Description  from PCProcedureCodes  where ProcedureCode = PCHMT.CodeId)
 WHEN HTP.TrigerringFactor = 8117
 THEN (SELECT MedicationName  from MDMedicationNames  where MedicationNameId = Cast(PCHMT.CodeId as INT))
 WHEN HTP.TrigerringFactor = 8119
 --THEN (SELECT  DD.DSMDescription FROM DiagnosisDSMDescriptions DD where DD.DSMCode = PCHMT.CodeId and DD.Axis = PCHMT.Axis and DD.DSMNumber = PCHMT.DSMNumber)
 -- Modified by Ponnin on 21 Dec 2015 - For task #14 of Diagnosis Changes (ICD10)
  THEN (SELECT TOP 1 DCHMT.DiagnosisDescription as [Description] FROM DiagnosisAllCodes DCHMT where DCHMT.DiagnosisCode = PCHMT.CodeId and DCHMT.IncludeInSearch='Y' and  DCHMT.CodeType in ('ICD10', 'DSM5')) 
  WHEN HTP.TrigerringFactor = 8121
 THEN (SELECT top 1 Name  from HealthDataAttributes  where HealthDataAttributeId = PCHMT.CodeId)
  WHEN HTP.TrigerringFactor = 8122
 THEN (SELECT top 1 ConceptDescription  from MDAllergenConcepts  where AllergenConceptId = PCHMT.CodeId)
 END as [Description],
 PCHMT.[CodeId],
 PCHMT.[DSMNumber],
 PCHMT.[Axis],
 --Cast(@TrigerringFactor as varchar(15)) as TrigerringFactor
 HTP.TrigerringFactor as TrigerringFactor,
 PCHMT.HealthDataAttributeValue,
 
 Case when HTP.TrigerringFactor = 8121 then (select top 1 DataType  from HealthDataAttributes where HealthDataAttributeId = PCHMT.CodeId)
 ELSE 0 END
 as DataType,
 
  Case when HTP.TrigerringFactor = 8121 then (select top 1 CodeName  from GlobalCodes GC Join HealthDataAttributes HDA on GC.GlobalCodeId = HDA.Units  where HealthDataAttributeId = PCHMT.CodeId)
 ELSE '' END
 as UnitName,
 -- Modified by Jeffin on 07 Dec 2018 - For task #38 of Meaningful Use - Stage 3
  Case when HTP.TrigerringFactor = 8121 then (select top 1 DropDownCategory  from HealthDataAttributes where HealthDataAttributeId = PCHMT.CodeId)  
 ELSE 0 END  
 as DropDownCategory
 From HealthMaintenanceTriggeringFactorDetails PCHMT JOIN HealthMaintenanceTriggeringFactors HTP ON HTP.HealthMaintenanceTriggeringFactorId = PCHMT.HealthMaintenanceTriggeringFactorId
 WHERE HTP.HealthMaintenanceTriggeringFactorGroupId= @HealthMaintenanceTriggeringFactorGroupId AND ISNULL(PCHMT.RecordDeleted,'N')<>'Y' and ISNULL(HTP.RecordDeleted,'N')<>'Y'
 

 
 END
 END TRY                                 
 BEGIN CATCH                                    
 DECLARE @Error varchar(8000)                                                      
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetHealthMaintenanceTriggeringFactor')                                                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                        
    + '*****' + Convert(varchar,ERROR_STATE())                                                      
    RAISERROR (@Error,16,1);                                       
 End CATCH                            
                          
End 

GO


