
/****** Object:  StoredProcedure [dbo].[ssp_SCWebInsertListPageFilters]    Script Date: 01/07/2017 13:20:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebInsertListPageFilters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebInsertListPageFilters]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebInsertListPageFilters]    Script Date: 01/07/2017 13:20:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebInsertListPageFilters]             
(              
   @StaffId Int,            
   @ScreenId int,              
   @FilterValue varchar(MAX),    
   @UserCode varchar(100),  
   @ClientId  int        
)                          
AS                              
/******************************************************************************                                    
**  File:                                  
**  Name:                   
**  Desc: Stored Procedure Used to store the Filter Value                   
**  Return values:                                     
**  Called by:                                     
**  Parameters: @UserCode,ScreenId,@FilterValue               
**  Auth:  Munish Singla                     
                            
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                    
**  --------    --------        ----------------------------------------------------                                    
    Modified By Priya Date 9th april 2010   for maintaining ClientId in StaffScreenFiltersTable  
  07/01/2017    Lakshmi kanth					What:Not allowing to insert special charecters in SQL database if the datatype is xml, 
												Why: Woods Support Go live #443
  18-JAN-2019   Akwinass						What: Changed the variable "@return" type and size to save the filter value fully if size is more than 4000
												Why: Since the input parameter "@FilterValue" value is manipulated and reassigned using the variable "@return",  the "@return" variable type and size should be same as input parameter "@FilterValue" (#9 in StarCare-Environment Issues Tracking).
*******************************************************************************/                                  
BEGIN                              
BEGIN TRY    
  
    declare @return varchar(MAX) --Added by Lakshmi on 07/01/2017
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
  
if(@ClientId  = 0)  
Begin    
  --If EXISTS(Select ScreenId From CustomFilters where UserCode= @UserCode)            
 If EXISTS(Select  * From StaffScreenFilters where StaffId= @StaffId and ScreenId = @ScreenId)      
  Begin            
  --Update CustomFilters Set FilterValue = @FilterValue where ScreenId = @ScreenId and UserCode = @UserCode            
  Update StaffScreenFilters Set FiltersXML = @FilterValue, ModifiedBy = @UserCode, ModifiedDate = GETDATE() where ScreenId = @ScreenId and StaffId = @StaffId            
  End             
  Else            
  Begin            
  Insert Into StaffScreenFilters (StaffId,ScreenId,ClientId,FiltersXML,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)            
     --Values(@UserCode,@ScreenId,@FilterValue)            
      Values(@StaffId,@ScreenId,null,@FilterValue,@UserCode,GETDATE(),@UserCode,GETDATE())            
  End    
  End  
  Else  
   Begin  
      If EXISTS(Select  * From StaffScreenFilters where StaffId= @StaffId and ScreenId = @ScreenId and ClientId=@ClientId)      
   Begin            
  --Update CustomFilters Set FilterValue = @FilterValue where ScreenId = @ScreenId and UserCode = @UserCode            
  Update StaffScreenFilters Set FiltersXML = @FilterValue, ModifiedBy = @UserCode, ModifiedDate = GETDATE() where ScreenId = @ScreenId and StaffId = @StaffId  and ClientId=@ClientId          
  End             
  Else            
  Begin            
  Insert Into StaffScreenFilters (StaffId,ScreenId,ClientId,FiltersXML,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)            
     --Values(@UserCode,@ScreenId,@FilterValue)            
      Values(@StaffId,@ScreenId,@ClientId,@FilterValue,@UserCode,GETDATE(),@UserCode,GETDATE())            
  End     
 End     
END TRY                                
BEGIN CATCH                                 
DECLARE @Error varchar(8000)                                  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebInsertListPageFilters')                                   
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


