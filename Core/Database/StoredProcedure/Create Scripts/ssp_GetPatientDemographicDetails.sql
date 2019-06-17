/****** Object:  StoredProcedure [dbo].[ssp_GetPatientDemographicDetails]    Script Date: 09/24/2017 12:38:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPatientDemographicDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPatientDemographicDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPatientDemographicDetails]    Script Date: 09/24/2017 12:38:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_GetPatientDemographicDetails] @ClientId INT = NULL      
 ,@Type VARCHAR(10) = NULL      
 ,@DocumentVersionId INT = NULL      
 ,@FromDate DATETIME = NULL      
 ,@ToDate DATETIME = NULL      
 ,@JsonResult VARCHAR(MAX) = NULL OUTPUT      
AS      
-- =============================================              
-- Author:  Vijay              
-- Create date: July 24, 2017              
-- Description: Retrieves Patient details 
-- Task:   MUS3 - Task#25.4, 30, 31 and 32
/*              
 Author   Modified Date   Reason             
*/      
-- =============================================              
BEGIN      
 BEGIN TRY      
  SET NOCOUNT ON      
      
  IF @ClientId IS NOT NULL      
  BEGIN      
     SELECT @JsonResult = dbo.smsf_FlattenedJSON((      
         SELECT  DISTINCT c.ClientId
			--,'Patient' AS ResourceType
			--,c.SSN AS Identifier
			,CASE c.Active
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'No'
				END as Active
			,CASE c.Sex
				WHEN 'M'
					THEN 'Male'
				WHEN 'F'
					THEN 'Female'
				WHEN 'U' THEN 'Unknown'
				ELSE ''
				END AS Gender
			,CONVERT(varchar(10),c.DOB,101) AS BirthDate
			,ISNULL(STUFF((SELECT ',' + ISNULL(dbo.ssf_GetGlobalCodeNameById(CR.RaceId) , '')
				FROM ClientRaces CR WHERE CR.ClientId= C.ClientId FOR XML PATH('') ,type ).value('.', 'nvarchar(max)'), 1, 1, ''), '')
				 AS Race	--Note: Not in Patient Model
			,ISNULL(STUFF((SELECT ',' + ISNULL(dbo.ssf_GetGlobalCodeNameById(CE.EthnicityId) , '')
				FROM ClientEthnicities CE WHERE CE.ClientId= C.ClientId AND ISNULL(CE.RecordDeleted,'N')='N'  FOR XML PATH('')
				,type ).value('.', 'nvarchar(max)'), 1, 1, ''), '') AS Ethnicity	--Note: Not in Patient Model	
			,DBO.csf_getglobalcodeNameById(CDI.value) AS SmokingStatus
			--,CASE WHEN C.DeceasedOn IS NOT NULL THEN 'Yes' ELSE 'No' END AS DeceasedBoolean
			,CONVERT(varchar(10),C.DeceasedOn,101) AS DeceasedDateTime
			--,ca.ClientAddressId AS [Address]
			--,''  AS MaritalStatus
			--,'' AS MultipleBirthBoolean
			,'' AS MultipleBirthInteger
			--,'' AS Photo
			--,'' AS AnimalSpecies	--388445009 	horse
			--,'' AS AnimalBreed		--41706005 	Perendale sheep (organism)
			--,'' AS AnimalGenderStatus  --neutered	Neutered
			--,dbo.ssf_GetGlobalCodeNameById(c.PrimaryLanguage) AS CommunicationLanguage	--RDL+FHIR  en	English
			,'True' AS Preferred
			,'' AS GeneralPractitioner	--Reference
			,'' AS ManagingOrganization	--Reference
			,'' AS LinkOther	--Reference
			,'' AS LinkType
			FROM Clients c
			LEFT JOIN ClientHealthDataAttributes CDI ON CDI.ClientId = c.ClientId and CDI.Value is not null and CDI.HealthDataAttributeId in(select HealthDataAttributeId from HealthDataAttributes  WHERE NAME = 'Smoking Status')
			LEFT JOIN [Services] s ON (s.ClientId = c.ClientId AND (s.DateOfService >= @FromDate and s.EndDateOfService <= @ToDate))
			WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)		
			AND c.Active = 'Y' 
			AND ISNULL(c.RecordDeleted,'N')='N'      
        FOR XML path      
         ,ROOT      
        ))         
  END      
  ELSE      
   IF @DocumentVersionId IS NOT NULL      
   BEGIN      
    DECLARE @RDLFromDate DATE      
    DECLARE @RDLToDate DATE      
      
    SELECT TOP 1 @RDLFromDate = cast(FromDate AS DATE)      
     ,@RDLToDate = cast(ToDate AS DATE)      
     ,@Type = TransitionType      
    FROM TransitionOfCareDocuments      
    WHERE ISNULL(RecordDeleted, 'N') = 'N'      
     AND DocumentVersionId = @DocumentVersionId      
      
    SELECT DISTINCT c.ClientId      
     ,CASE       
      WHEN ISNULL(C.ClientType, 'I') = 'I'      
       THEN ISNULL(C.FirstName, '') + ' ' + ISNULL(C.MiddleName, '') + ' ' + ISNULL(C.LastName, '')     
      ELSE ISNULL(C.OrganizationName, '')      
      END + ' ' + ISNULL(c.Suffix, '') AS ClientName      
     ,CASE       
      WHEN Ca.ClientAliasId IS NULL      
       THEN 'None'      
      ELSE ISNULL(CA.LastName, '') + ',' + ISNULL(CA.FirstName, '')      
      END AS PreviousName --RDL        
     ,ISNULL(STUFF((      
        SELECT ',' + ISNULL(dbo.ssf_GetGlobalCodeNameById(CR.RaceId), '')      
        FROM ClientRaces CR      
        WHERE CR.ClientId = C.ClientId      
        FOR XML PATH('')      
         ,type      
        ).value('.', 'nvarchar(max)'), 1, 1, ''), '') AS Race --RDL     
     ,(SELECT Top 1 dbo.ssf_GetGlobalCodeNameById(CR.RaceId) FROM ClientRaces CR WHERE CR.ClientId = C.ClientId) AS RaceForCCDS    --CCDS                
     ,ISNULL(STUFF((      
        SELECT ',' + ISNULL(dbo.ssf_GetGlobalCodeNameById(CR.RaceId), '')      
        FROM ClientRaces CR      
        LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CR.RaceId      
         AND GC.ExternalCode2 IS NOT NULL      
        WHERE CR.ClientId = C.ClientId      
        FOR XML PATH('')      
         ,type      
        ).value('.', 'nvarchar(max)'), 1, 1, ''), '') AS MoreGranularRaceCode --RDL    
     ,(SELECT Top 1 GC.ExternalCode1 FROM ClientRaces CR     
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CR.RaceId WHERE CR.ClientId = C.ClientId) AS MoreGranularRaceCodeForCCDS    --CCDS        
     ,ISNULL(STUFF((      
        SELECT ',' + ISNULL(dbo.ssf_GetGlobalCodeNameById(CE.EthnicityId), '')      
        FROM ClientEthnicities CE      
        WHERE CE.ClientId = C.ClientId      
         AND ISNULL(CE.RecordDeleted, 'N') = 'N'      
        FOR XML PATH('')      
         ,type      
        ).value('.', 'nvarchar(max)'), 1, 1, ''), '') AS Ethnicity --RDL    
     ,(SELECT Top 1 dbo.ssf_GetGlobalCodeNameById(CE.EthnicityId) FROM ClientEthnicities CE WHERE CE.ClientId = C.ClientId) AS EthnicityForCCDS    --CCDS    
     ,(SELECT Top 1 GC.ExternalCode1 FROM ClientEthnicities CE     
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.EthnicityId WHERE CE.ClientId = C.ClientId) AS EthnicityCodeForCCDS         
     ,dbo.ssf_GetGlobalCodeNameById(c.PrimaryLanguage) AS CommunicationLanguage --RDL +FHIR        
     ,CD.Display AS ClientAddress      
     --,'Patient' AS ResourceType        
     --,c.SSN AS Identifier        
     ,CASE c.Active      
      WHEN 'Y'      
       THEN 'Yes'      
      WHEN 'N'      
       THEN 'No'      
      END AS Active      
     ,(      
      SELECT TOP 1 PhoneNumber      
      FROM ClientPhones      
      WHERE PhoneType IN (      
        30 -- home      
        ,34 -- Mobile      
        )      
      ORDER BY PhoneType ASC      
      ) AS PhoneNumber      
     ,CASE c.Sex      
      WHEN 'M'      
       THEN 'Male'      
      WHEN 'F'      
       THEN 'Female'      
      WHEN 'U'      
       THEN 'Unknown'      
      ELSE ''      
      END AS Gender      
     ,CONVERT(VARCHAR(10), c.DOB, 101) AS BirthDate      
     --FOR CCDS    
     ,c.SSN     
  ,gc.ExternalCode1 AS LanguageCode    
  ,c.FirstName AS ClientFirstName    
  ,c.MiddleName AS ClientMiddleName    
  ,c.LastName AS ClientLastName    
  ,c.Sex as GenderCode    
  ,dbo.ssf_GetGlobalCodeNameById(c.MaritalStatus) AS ClientMaritalStatus    
 ,CASE dbo.ssf_GetGlobalCodeNameById(c.MaritalStatus)    
  WHEN 'Divorced/Annulled'    
   THEN 'A'    
  WHEN 'Divorced'    
   THEN 'D'    
  WHEN 'Interlocutory'    
   THEN 'I'    
  WHEN 'Separated'    
   THEN 'L'    
  WHEN 'Married'    
   THEN 'M'    
  WHEN 'Remarried'    
   THEN 'P'    
  WHEN 'Never married'    
   THEN 'S'    
  WHEN 'Domestic partner'    
   THEN 'T'    
  WHEN 'Single / Never Married'    
   THEN 'U'    
  WHEN 'Widowed'    
   THEN 'W'    
  ELSE 'UNK'    
  END  AS ClientMaritalStatusCode    
 ,cd.[Address] AS ClientAddressLine    
 ,cd.City AS ClientCity    
 ,cd.[State] AS ClientState    
 ,cd.Zip AS ClientZip    
 ,CASE WHEN ISNULL(cp.PhoneNumber,'') <> ''        
   THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')'       
    + ' '       
    + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 4, 3)        
    + '-'       
    + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 7, 4)        
    ELSE ''      
    END AS ClientPhoneNumber    
  ,A.AgencyName       
     ,A.Address AS AgencyAddress       
     ,A.City AS AgencyCity       
     ,A.State AS AgencyState       
     ,A.ZipCode AS AgencyZipCode    
     ,CASE WHEN ISNULL(A.MainPhone,'') <> ''        
   THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')'       
    + ' '       
    + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 4, 3)        
    + '-'       
    + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 7, 4)        
    ELSE ''      
    END AS [AgencyPhone]    
     ,A.CreatedDate AS [AgencyDate]         
    FROM Clients c      
    LEFT JOIN ClientAliases CA ON CA.ClientId = C.ClientId      
     AND dbo.ssf_GetGlobalCodeNameById(CA.AliasType) = 'Previous Name'      
     AND ISNULL(CA.RecordDeleted, 'N') = 'N'      
     LEFT JOIN ClientAddresses CD ON CD.ClientId = C.ClientId AND CD.AddressType = 90 AND ISNULL(CD.RecordDeleted, 'N') = 'N' -- 90 home      
     LEFT JOIN ClientPhones cp ON cp.ClientId = c.ClientId and cp.PhoneType = 30  AND ISNULL(cp.RecordDeleted, 'N') = 'N' --FOR CCDS      
     LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = c.PrimaryLanguage --FOR CCDS    
     CROSS JOIN  Agency A  --FOR CCDS    
    WHERE  exists( Select 1 from Documents d  join DocumentVersions DV on d.DocumentId= DV.DocumentId where d.ClientId = c.ClientId      
         and DV.DocumentVersionId = @DocumentVersionId      
         AND D.EffectiveDate >= @RDLFromDate      
         AND D.EffectiveDate <= @RDLToDate      
      )      
           
   END      
 END TRY      
      
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
      
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPatientDemographicDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT
  
(    
VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())      
      
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
