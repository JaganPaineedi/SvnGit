/****** Object:  StoredProcedure [dbo].[csp_InitCustomAuthorizationDetailsStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAuthorizationDetailsStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomAuthorizationDetailsStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAuthorizationDetailsStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomAuthorizationDetailsStandardInitialization]                 
(                                        
 @ClientId int,          
 @StaffID int,        
 @CustomParameters xml                                                      
)                                                                
As                                                                  
Begin                                                    
          
Begin try  
declare @usercode varchar(100);
select @usercode =usercode from Staff where StaffId=@StaffID                                  
            
SELECT 
		''AuthorizationDocuments'' as TableName, 
		-1 as [AuthorizationDocumentId]
		,NEWID() as [RowIdentifier]
		,@usercode as [CreatedBy]
		,GETDATE() as [CreatedDate]
		,@usercode as [ModifiedBy]
		,GETDATE() as [ModifiedDate]  
			                   
	                 

		                          
                                        
end try                                                    
                                                                                           
BEGIN CATCH        
DECLARE @Error varchar(8000)                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                               
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_InitCustomAuthorizationDetailsStandardInitialization]'')                                                                                   
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
