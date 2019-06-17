

/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeImplantableDevices]    Script Date: 09/28/2015 15:55:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInitializeImplantableDevices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInitializeImplantableDevices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitializeImplantableDevices]    Script Date: 09/28/2015 15:55:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCInitializeImplantableDevices]
    (
      @ClientID INT ,
      @StaffID INT ,
      @CustomParameters XML  
    )
AS
 /*********************************************************************/
/* Stored Procedure: [ssp_SCInitializeImplantableDevices] 124467,550,null             */
/* Date              Author                  Purpose                 */
/*12/07/2017        Sunil.D                SC: Implantable devices  ssp_SCInitializeImplantableDevices SP
											  Meaningful use -  #24                       */
/*********************************************************************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */ 
    BEGIN  
        BEGIN TRY   
								SELECT 'ImplantableDevices' AS TableName  
								,- 1 AS ImplantableDeviceId  
								,'Admin' AS CreatedBy  
								,GETDATE() AS CreatedDate  
								,'Admin' AS ModifiedBy  
								,GETDATE() AS ModifiedDate       END TRY   
        BEGIN CATCH  
            DECLARE @Error VARCHAR(MAX)  
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInitializeImplantableDevices') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '
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


