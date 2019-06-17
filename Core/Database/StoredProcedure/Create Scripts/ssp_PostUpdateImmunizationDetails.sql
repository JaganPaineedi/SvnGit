
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateImmunizationDetails]    Script Date: 06/13/2015 17:23:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateImmunizationDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateImmunizationDetails]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateImmunizationDetails]    Script Date: 06/13/2015 17:23:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[ssp_PostUpdateImmunizationDetails]                                                 
                  
@ScreenKeyId int,                  
@StaffId int,                  
@CurrentUser varchar(30),                  
@CustomParameters xml                   
as                                                
/*********************************************************************/                                                
/* Stored Procedure: dbo.ssp_PostUpdateImmunizationDetails           */                                                
/* Creation Date:    16/05/2011                                      */                                                
/*                                                                   */                                                
/* Purpose:	To insert record into HL7OutgoingMessages if user updates Immunization details */                                                
/*                                                                   */                                                 
/* Input Parameters:												 */                                                
/*                                                                   */                                                
/* Output Parameters:                                                */                                                
/*                                                                   */                                                
/* Return Status:                                                    */                                                
/*                                                                   */                                                
/* Called By:       */                                                
/*                                                                   */                                                
/* Calls:                                                            */                                                
/*                                                                   */                                                
/* Data Modifications:                                               */                                                
/*                                                                   */                                                
/* Updates:                                                          */                                                
/*   Date                   Author      Purpose                      */                                                 
/*********************************************************************/                                             
  
BEGIN  
   Declare @ClientId int  
 Begin TRY     
  
	--Get @ClientId based on ClientImmunizationId                                  
                              
	SELECT @ClientId=ClientId                                  
	FROM ClientImmunizations                                
	WHERE ClientImmunizationId=@ScreenKeyId  
	  
	--Insert Into HL7OutgoingMessages
   INSERT INTO HL7OutgoingMessages
           (CreatedBy
           ,CreatedDate
           ,ModifiedBy
           ,ModifiedDate
           ,MessageType
           ,ClientId
           ,RecordId) 
     VALUES
           (@CurrentUser
           ,getdate()
           ,@CurrentUser
           ,getdate()
           ,6343
           ,@ClientId
           ,@ScreenKeyId)
 
 END TRY  
 BEGIN CATCH  
    
  DECLARE @Error varchar(8000)                                
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())   
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PostUpdateImmunizationDetails')   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())    
  + '*****' + Convert(varchar,ERROR_STATE())   
  RAISERROR                                                                                               
  (                                                               
   @Error, -- Message text.   
   16, -- Severity.   
   1 -- State.   
  );      
 END CATCH  
END
GO

