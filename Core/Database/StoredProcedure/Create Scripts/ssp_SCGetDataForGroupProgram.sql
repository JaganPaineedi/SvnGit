/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataForGroupProgram]    Script Date: 11/18/2011 16:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataForGroupProgram]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataForGroupProgram]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataForGroupProgram]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_SCGetDataForGroupProgram]                   
                   
AS                  
/******************************************************************************                        
**  File: GroupService List Page                        
**  Name:       
**  Desc:        
**                        
**  This template can be customized:                        
**                                      
**  Return values:                        
**                         
**  Called by: WebSharedTable.cs                         
**                                      
**  Parameters:                        
**  Input    Output                        
**               
**                  
**                    
**                  
**  Auth:  Pradeep                
**  Date: July 7,2009                    
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:  Author:    Description:                        
**  --------  --------    ----------------------------------------------------                        
**  09/04/2017	Neelima	  Copied this ssp from 3.5 and added StaffId column and join with StaffPrograms as per task Engineering Improvement Initiatives- NBL(I) #201             
*******************************************************************************/                      
BEGIN                  
BEGIN TRY                  
     
 --------------Program associated with groups-----  
SELECT Programs.[ProgramId]  
      ,Programs.[ProgramCode]    
      ,Programs.[ProgramName]    
      ,Programs.[Active]    
      ,Programs.[ProgramType]    
      ,Programs.[IntakePhone]    
      ,Programs.[IntakePhoneText]    
      ,Programs.[ProgramManager]    
      ,Programs.[Capacity]    
      ,Programs.[Comment]    
      ,Programs.[Address]    
      ,Programs.[City]    
      ,Programs.[State]    
      ,Programs.[ZipCode]    
      ,Programs.[AddressDisplay]    
      ,Programs.[NationalProviderId]
      ,SP.StaffId     -- Added by Neelima
        
  FROM [Programs]  
  JOIN StaffPrograms SP ON SP.ProgramId = Programs.ProgramId		 -- Added by Neelima
  where exists(select * from Groups where   Programs.ProgramId=Groups.ProgramId and ISNULL(Groups.RecordDeleted,''N'')=''N'' and Groups.Active=''Y'') and ISNULL(Programs.RecordDeleted,''N'')=''N'' 
  and ISNULL(SP.RecordDeleted,''N'')=''N''		 -- Added by Neelima
  and Programs.Active=''Y''    
           
END TRY                    
                  
BEGIN CATCH                     
DECLARE @Error varchar(8000)                      
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[ssp_SCGetDataForGroupProgram]'')                       
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                        
    + ''*****'' + Convert(varchar,ERROR_STATE())                      
                                               
                  
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16, -- Severity.                      
  1 -- State.                      
 );                      
                      
END CATCH                   
END
' 
END
GO
