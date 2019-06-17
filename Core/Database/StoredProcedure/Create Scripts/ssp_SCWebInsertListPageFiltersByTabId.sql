
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebInsertListPageFiltersByTabId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebInsertListPageFiltersByTabId]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebInsertListPageFiltersByTabId]             
(              
   @StaffId Int,            
   @ScreenId int,              
   @FilterValue varchar(MAX),    
   @UserCode varchar(100),  
   @ClientId  int,
   @TabId int        
)                          
AS                              
/******************************************************************************                                    
**  File:                                  
**  Name:                   
**  Desc: Stored Procedure Used to store the Filter Value BY ClientId and TabId                
**  Return values:                                     
**  Called by:                                     
**  Parameters: @StaffId,@ScreenId,@FilterValue,@UserCode,@ClientId,@TabId            
**  Auth:  Hemant                    
                            
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                    
**  --------    --------        ----------------------------------------------------                                    

*******************************************************************************/                                  
BEGIN                              
BEGIN TRY    
  
    declare @return nvarchar(4000) --Added by Lakshmi on 07/01/2017
    select @return = 
    REPLACE(  
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(@FilterValue,'&', '&amp;')
                ,'<', '&lt;')
            ,'>', '&gt;')
        ,'"', '&quot;')
    ,'''', '&#39;')

set @FilterValue=''
set @FilterValue=@return
   
  If EXISTS(Select  * From StaffScreenFilters where StaffId= @StaffId and ScreenId = @ScreenId and ClientId=@ClientId and TabId = @TabId)      
  Begin            
  Update StaffScreenFilters Set FiltersXML = @FilterValue, ModifiedBy = @UserCode, ModifiedDate = GETDATE() where ScreenId = @ScreenId and StaffId = @StaffId  and ClientId=@ClientId  and TabId = @TabId        
  End             
  Else            
  Begin            
  Insert Into StaffScreenFilters (StaffId,ScreenId,ClientId,FiltersXML,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,TabId)            
  Values(@StaffId,@ScreenId,@ClientId,@FilterValue,@UserCode,GETDATE(),@UserCode,GETDATE(),@TabId)            
  End     
    
END TRY                                
BEGIN CATCH                                 
DECLARE @Error varchar(8000)                                  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebInsertListPageFiltersByTabId')                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                    
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


