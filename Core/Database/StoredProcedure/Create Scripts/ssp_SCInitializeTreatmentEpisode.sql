

/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeTreatmentEpisode]    Script Date: 09/28/2015 15:55:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInitializeTreatmentEpisode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInitializeTreatmentEpisode]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeTreatmentEpisode]    Script Date: 09/28/2015 15:55:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCInitializeTreatmentEpisode]
    (
      @ClientID INT ,
      @StaffID INT ,
      @CustomParameters XML  
    )
AS
 /*********************************************************************/
/* Stored Procedure: [ssp_SCInitializeTreatmentEpisode] 2398,550,null             */
/* Date              Author                  Purpose                 */
/* 4/17/2015        Sunil.D             SC: Treatment Episode New Screen and Banner not Client Episode
											Thresholds - Support  #828                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */ 
    BEGIN  
        BEGIN TRY  
            --DECLARE @LatestDocumentVersionID INT  
            --SET @LatestDocumentVersionID = ( SELECT TOP 1     CurrentDocumentVersionId
            --                                          FROM      Documents a   INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
            --                                          WHERE     a.ClientId = @ClientID   AND a.[Status] = 22
            --                                                    AND Dc.DiagnosisDocument = 'Y'    AND a.EffectiveDate <= CAST(GETDATE() AS DATE)
            --                                                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
            --                                                    AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
            --                                          ORDER BY  a.EffectiveDate DESC ,
            --                                                    a.ModifiedDate DESC)   
								SELECT 'TreatmentEpisodes' AS TableName  
								,- 1 AS TreatmentEpisodeId  
								,'Admin' AS CreatedBy  
								,GETDATE() AS CreatedDate  
								,'Admin' AS ModifiedBy  
								,GETDATE() AS ModifiedDate       END TRY  
  
        BEGIN CATCH  
            DECLARE @Error VARCHAR(MAX)  
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInitializeTreatmentEpisode') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '
*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
            RAISERROR (  
    @Error  
    ,  
    -- Message text.                                                                                   
    16  
    ,  
    -- Severity.                                                                                   
    1  
    -- State.                                                                                   
    );  
        END CATCH  
    END  
  

GO


