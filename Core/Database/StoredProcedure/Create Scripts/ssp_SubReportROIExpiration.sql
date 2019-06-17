IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SubReportROIExpiration]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ROI] 
  END 

go 

/********************************************************************************                                                    
-- Stored Procedure: ssp_SubReportROIExpiration     550
--     
-- Copyright: Streamline Healthcare Solutions     
--     
-- Purpose:RDL     
--     
-- Author:  Alok Kumar 
-- Date:    22 November 2017  
-- Ref:		Task#2013 Spring River - Customizations

Modified Date      Modified By      Description 

*********************************************************************************/ 
CREATE PROCEDURE [ssp_SubReportROIExpiration] @DocumentVersionId INT  
AS 

  BEGIN 
      BEGIN try 
          SELECT --RE.ROIExpirationId, 
						--RE.DocumentVersionId,
						--RE.Expiration,
						--GC.GlobalCodeId,
						GC.CodeName
			FROM   ROIExpirations RE 
			INNER JOIN DocumentReleaseOfInformations DRRI ON RE.DocumentVersionId = DRRI.DocumentVersionId
			INNER JOIN GlobalCodes GC On GC.GlobalCodeId = RE.Expiration
				AND GC.Category = 'ROIEXPIRATION' 
				AND ISNULL(GC.Active, 'N') = 'Y' AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			Where RE.DocumentVersionId = @DocumentVersionId 
				AND ISNULL(RE.RecordDeleted, 'N') = 'N' AND ISNULL(DRRI.RecordDeleted, 'N') = 'N'
					
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SubReportROIExpiration' ) 
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