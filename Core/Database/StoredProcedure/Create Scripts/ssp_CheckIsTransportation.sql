
/****** Object:  StoredProcedure [dbo].[ssp_CheckIsTransportation]    Script Date: 01/29/2016 16:45:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckIsTransportation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CheckIsTransportation]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CheckIsTransportation]    Script Date: 01/29/2016 16:45:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure  [dbo].[ssp_CheckIsTransportation]   --1                 
@GroupId INT                                 
AS            
/******************************************************************************                                
**  File:                               
**  Name: Stored_Procedure_Name                                
**  Desc:This is used to get group information against passed parameter                                 
**                                          
**  Return values:                                
**                                 
**  Called by:GroupSerice.cs                                   
**                                              
**  Parameters:                                
**  Input       Output                     
**  @GroupId    None                            
**     ----------       -----------                                
**                                
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:  Author:    Description:   
	28/03/2017      Venkatesh        Check whether Group is Transportation or not.                             
**  --------  --------    -------------------------------------------                                
*******************************************************************************/                  
BEGIN                  
  BEGIN TRY         
    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_CheckIsTransportation]') AND type in (N'P', N'PC'))
BEGIN
	EXEC scsp_CheckIsTransportation @GroupId
END
ELSE
BEGIN
	Select 0
END


  END TRY                  
  BEGIN CATCH                  
    DECLARE @Error varchar(8000)                              
          SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****'                                            
          + Convert(varchar(4000),ERROR_MESSAGE())                                                   
          + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                            
          '[ssp_CheckIsTransportation]')                                
          + '*****' + Convert(varchar,ERROR_LINE())                                            
          + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                  
          + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                  
      RAISERROR                                                   
          (                                                   
            @Error, -- Message text.                       
            16, -- Severity.                                                   
            1 -- State.                                                   
          )                   
  END CATCH                  
END 
GO


