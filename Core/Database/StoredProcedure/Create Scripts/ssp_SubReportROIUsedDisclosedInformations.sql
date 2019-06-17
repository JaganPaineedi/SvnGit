IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SubReportROIUsedDisclosedInformations]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_SubReportROIUsedDisclosedInformations] 
  END 

go 

/********************************************************************************                                                    
-- Stored Procedure: ssp_SubReportROIUsedDisclosedInformations     550
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
CREATE PROCEDURE [ssp_SubReportROIUsedDisclosedInformations] @DocumentVersionId INT  
AS 

  BEGIN 
      BEGIN try 
          SELECT --RUDI.ROIUsedDisclosedInformationId, 
						--RUDI.DocumentVersionId,
						--RUDI.UsedOrDisclosed,
						--GC.GlobalCodeId,
						GC.CodeName
			FROM   ROIUsedDisclosedInformations RUDI 
			INNER JOIN DocumentReleaseOfInformations DRRI ON RUDI.DocumentVersionId = DRRI.DocumentVersionId
			INNER JOIN GlobalCodes GC On GC.GlobalCodeId = RUDI.UsedOrDisclosed
				AND GC.Category = 'ROIINFORMATIONUSED' 
				AND ISNULL(GC.Active, 'N') = 'Y' AND ISNULL(GC.RecordDeleted, 'N') = 'N'
			Where RUDI.DocumentVersionId = @DocumentVersionId 
				AND ISNULL(RUDI.RecordDeleted, 'N') = 'N' AND ISNULL(DRRI.RecordDeleted, 'N') = 'N'
					
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SubReportROIUsedDisclosedInformations' ) 
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