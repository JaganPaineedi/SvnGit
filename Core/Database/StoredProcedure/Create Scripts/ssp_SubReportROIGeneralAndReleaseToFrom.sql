IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SubReportROIGeneralAndReleaseToFrom]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_SubReportROIGeneralAndReleaseToFrom] 
  END 

go 

/********************************************************************************                                                    
-- Stored Procedure: ssp_SubReportROIGeneralAndReleaseToFrom     668
--     
-- Copyright: Streamline Healthcare Solutions     
--     
-- Purpose:RDL     s
--     
-- Author:  Alok Kumar 
-- Date:    22 November 2017  
-- Ref:		Task#2013 Spring River - Customizations

Modified Date      Modified By      Description 

*********************************************************************************/ 
CREATE PROCEDURE [ssp_SubReportROIGeneralAndReleaseToFrom] @DocumentVersionId INT  
AS 

  BEGIN 
      BEGIN try 
      
      DECLARE @OrganizationOrContactName VARCHAR(MAX)
      
      
      
          SELECT ReleaseToFromContactId,
					ReleaseToFromOrganization,
					CONVERT(VARCHAR(10), RecordsStartDate, 101) AS RecordsStartDate,
					CONVERT(VARCHAR(10), RecordsEndDate, 101) AS RecordsEndDate,
					(SELECT TOP 1 [Value] FROM SystemConfigurationKeys WHERE [KEY] = 'DISPLAYROITEXT' AND ISNULL(RecordDeleted, 'N') = 'N') as DISPLAYROITEXT,
					ReleaseType,
					ReleaseTo,
					ObtainFrom,
					CASE 
						WHEN ReleaseType= 'C' then (Select Isnull(cc.lastname + ', ', '') + cc.firstname from ClientContacts cc Where ClientContactId = ReleaseToFromContactId)
						WHEN ReleaseType= 'O' then (Select Isnull(ProviderName , '') from Providers Where ProviderId = ReleaseToFromOrganization)
					END AS OrganizationOrContactName,
					dbo.ssf_GetGlobalCodeNameById(ReleaseContactType) AS ReleaseContactType,
					Organization,
					ReleaseName,
					ReleaseAddress,
					ReleaseCity,
					(SELECT Top 1 StateName from States where StateAbbreviation = ReleaseState)  AS ReleaseState,
					ReleasePhoneNumber,
					ReleaseZip
			FROM   DocumentReleaseOfInformations DRRI 
			Where DRRI.DocumentVersionId = @DocumentVersionId AND ISNULL(DRRI.RecordDeleted, 'N') = 'N'
					
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SubReportROIGeneralAndReleaseToFrom' ) 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT( VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                                                                    
                      16, 
                      -- Severity.                                                                                                                                                                                                                         
                      1 
          -- State.                                                                                                                                                                                                                                             
          ); 
      END catch 
  END 