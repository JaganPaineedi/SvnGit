/****** Object:  StoredProcedure [dbo].[csp_GetCSPStaff]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCSPStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCSPStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCSPStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE [dbo].[csp_GetCSPStaff]          
        
AS          
/*********************************************************************/                        
/* Stored Procedure: dbo.csp_GetCSPStaff				             */                        
/* Copyright: 2012 Smart Management System					         */                        
/* Creation Date:  03/09/2012	                                     */                        
/*                                                                   */                        
/* Purpose: It will retrieve the StaffId and Name of CSP Staff	     */                       
/*                                                                   */                      
/* Input Parameters:									             */                      
/*                                                                   */                        
/* Output Parameters:												 */                        
/*                                                                   */                        
/*                                                                   */                        
/* Called By: Client Information Custom Fields - CSP Staff Assigned  */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/* Date          Author      Purpose                                 */     
/* ----------------------------------------------------------------  */                   
/* 03/09/2012    Jeff Riley  Created                                 */                        
/*********************************************************************/    

BEGIN
	
	SELECT StaffId AS ValueField, LastName + '', '' + FirstName AS TextField
	FROM Staff
	WHERE StaffId IN (352,131,458,586,625,741,744,1020,1047,1048) AND
	      ISNULL(RecordDeleted,''N'') = ''N''
	ORDER BY TextField ASC
	
END' 
END
GO
