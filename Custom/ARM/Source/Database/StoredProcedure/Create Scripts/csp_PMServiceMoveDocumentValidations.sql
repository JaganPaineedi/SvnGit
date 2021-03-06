/****** Object:  StoredProcedure [dbo].[csp_PMServiceMoveDocumentValidations]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMServiceMoveDocumentValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PMServiceMoveDocumentValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PMServiceMoveDocumentValidations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   procedure [dbo].[csp_PMServiceMoveDocumentValidations]       
(          
        
@ServiceIdTo int ,        
@ServiceIdFrom int,        
@StaffId int,         
@DocumentIdTo int,          
@DocumentCodeIdTo int,        
@ClientIdTo int,        
@AuthorIdTo int,         
@DocumentIdFrom int,         
@DocumentCodeIdFrom int,          
@ClientIdFrom int ,         
@AuthorIdFrom  int            
)              
          
/*********************************************************************                      
-- Stored Procedure: dbo.[ssp_PMServiceMoveDocumentValidations]                      
--                      
-- Copyright: 2010 Streamline Healthcare Solutions                      
--                      
-- Purpose: Validation Move of ServiceId from one DocumentId to another.                      
--                      
--                      
-- Updates:                       
--                      
**********************************************************************/            
          
as         
  begin       
        
           
Insert into #validationReturnTable          
(         
TableName ,                
ColumnName ,                
ErrorMessage                
               
)      
values      
(      
 ''ValidationReturn'',                
 ''ValidateColumn'',                
 ''This is an invalid service''        
)       
    
          
Insert into #validationReturnTable          
(         
TableName ,                
ColumnName ,                
ErrorMessage                
               
)      
values      
(      
 ''ValidationReturn'',                
 ''ValidateColumn'',                
 ''This is an invalid fgfservice''        
)      
        
      
        
        
  end
' 
END
GO
