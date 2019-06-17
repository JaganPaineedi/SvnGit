IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCWarningDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCWarningDocument]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCWarningDocument]    Script Date: 06/05/2014 19:55:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
            
CREATE PROCEDURE [dbo].[scsp_SCWarningDocument]                          
@CurrentUserId int,                                         
@DocumentId int ,              
@CustomWarningStoreProcedureName varchar(100)                                     
AS        
Begin                                     
/*******************************************************************************************************************/                                        
/* This stored procedure is used for custom warning of the documents within SmartCare.  A stored procedure     */                                        
/* should be created using the naming convention "csp_validateTableName" where TableName is                        */                                        
/* the name of the custom document table.            */                                        
/*                 */                                        
/* The stored procedure should insert the following 3 fields into #validationDocumentTable:      */                                        
/* Field1 TableName - the name of the document table          */                                        
/* Field2 ColumnName - the name of the column being validated         */                                        
/* Field3 ErrorMessage - the message to return to the user         */                                        
/*                 */                                        
  
/*******************************************************************************************/                                   
             
     BEGIN TRY                                    
                                        
                                                                             
Create Table #warningReturnTable                                        
(TableName  varchar(200),                                        
ColumnName  varchar(200),                                        
ErrorMessage    varchar(200),                                        
PageIndex       int,            
TabOrder int,            
ValidationOrder int                                    
)                                        
                   
declare @documentVersionId int                
                                    
Select @documentVersionId=InProgressDocumentVersionId              
from Documents              
where DocumentId=@DocumentId                   
                   
if(@CustomWarningStoreProcedureName<>'')                       
exec @CustomWarningStoreProcedureName @documentVersionId                             
                 
  
                                
                                          
select TableName, ColumnName, ErrorMessage,PageIndex from #warningReturnTable                                        
order by  TabOrder,ValidationOrder, PageIndex, ErrorMessage                                        
                                        
return                                        
                  
END TRY                     
 BEGIN CATCH                        
 DECLARE @Error varchar(8000)                                          
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[scsp_SCWarningDocument]')                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())       
    + '*****' + Convert(varchar,ERROR_STATE())                                          
    RAISERROR (@Error,16,1);                           
 End CATCH                          
 END    