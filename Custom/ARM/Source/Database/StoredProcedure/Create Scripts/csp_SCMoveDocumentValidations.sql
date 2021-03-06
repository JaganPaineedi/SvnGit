/****** Object:  StoredProcedure [dbo].[csp_SCMoveDocumentValidations]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCMoveDocumentValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCMoveDocumentValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCMoveDocumentValidations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create   procedure [dbo].[csp_SCMoveDocumentValidations]              
(  
 @DocumentId int,  
 @ClientIdTo int,  
 @ClientIdFrom int,  
 @StaffId  int   
)      
  
/*********************************************************************              
-- Stored Procedure: dbo.[csp_SCMoveDocumentValidations]              
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
  
  
  --Verify the service is not signed.  
If Exists (Select * from Documents Where DocumentId = @DocumentId and Status in (22) and isnull(RecordDeleted, ''N'')= ''N'')  
Begin   
 insert into #Errors (Error) values (''Signed document can not be moved'')   
   
End  
return
' 
END
GO
