    
      
      
      
CREATE PROCEDURE  [dbo].[ssp_CreateLoginToken]        
(        
 @UserGuid char(36),        
 @UserId int=null,      
 @StaffId int = null,      
 @StaffUserCode varchar(20)='sa'      
)        
As        
BEGIN TRY      
             
/*********************************************************************/          
/* Stored Procedure: dbo.ssp_CreateLoginToken                        */          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */          
/* Creation Date:  10 nov 2007                                        */          
/*                                                                   */          
/* Purpose: Create a login token                                     */         
/*                                                                   */        
/* Input Parameters: @UserGuid,@UserId,@StaffId,@StaffUserCode       */        
/*                                                                   */          
/* Return: null               */          
/*                                                                   */          
/* Called By:                                                        */          
/*                                                                   */          
/* Calls:                                                            */          
/*                                                                   */          
/* Data Modifications:                                               */          
/*                                                                   */          
/* Updates:                                                          */          
/*  Date        Author         Purpose                          */          
/* 11/10/2007    Jatinder Singh       Created            */       
/*********************************************************************/           
       
      
 Insert  into ValidateLogins      
 (UserGUID,UserId,StaffId,RowIdentifier,      
 CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)      
 values      
 (@UserGuid,@UserId,@StaffId,NewId(),      
 @StaffUserCode,getdate(),@StaffUserCode,getdate())      
       
 Select @@identity      
      
END TRY      
BEGIN CATCH      
 declare @Error varchar(8000)      
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CreateLoginToken')       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())        
    + '*****' + Convert(varchar,ERROR_STATE())      
        
 RAISERROR       
 (      
  @Error, -- Message text.      
  16, -- Severity.      
  1 -- State.      
 );      
      
END CATCH      
      
     