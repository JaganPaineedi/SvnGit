/****** Object:  StoredProcedure [dbo].[ssp_SCGetSfaffValidation]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSfaffValidation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSfaffValidation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSfaffValidation]  1003433    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                   
**  File: ssp_SCGetSfaffValidation                                            
**  Name: ssp_SCGetSfaffValidation                        
** 
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Vandana Ojha                              
**  Date:  Mar 29 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                    
*******************************************************************************/                                    
CREATE PROCEDURE  [dbo].[ssp_SCGetSfaffValidation]                                                     
(                                                                                                                                                           
  @ClientID int                                                                       
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY    
    Create Table #ResultSet( IsStaff char(1))  
    declare @IsStaff varchar(1)
    If exists(select 1 from Staff where tempclientid= @ClientID  AND isnull(Active ,'Y')='Y'  AND isnull(Recorddeleted ,'N')='N')
    Begin
    Set @IsStaff='Y'
    End
    Else 
    Set @IsStaff='N'
    Select @IsStaff as IsStaffAssociatedToClient
    
    
   	END TRY                                        
                                                           
  BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetSfaffValidation]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                           
End 

GO








