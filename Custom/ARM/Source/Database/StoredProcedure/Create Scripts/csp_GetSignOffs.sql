/****** Object:  StoredProcedure [dbo].[csp_GetSignOffs]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetSignOffs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetSignOffs]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetSignOffs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_GetSignOffs]          
        
AS          
/*********************************************************************/                        
/* Stored Procedure: dbo.csp_GetSignOffs				             */                        
/* Copyright: 2012 Smart Management System					         */                        
/* Creation Date:  03/14/2012	                                     */                        
/*                                                                   */                        
/* Purpose: It will retrieve the StaffId and Name of sign offs	     */                       
/*                                                                   */                      
/* Input Parameters:									             */                      
/*                                                                   */                        
/* Output Parameters:												 */                        
/*                                                                   */                        
/*                                                                   */                        
/* Called By: Coverage Custom Fields - MD/PhD Sign Off				 */                        
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/* Updates:                                                          */                        
/* Date          Author      Purpose                                 */     
/* ----------------------------------------------------------------  */                   
/* 03/14/2012    Jeff Riley  Created                                 */                        
/*********************************************************************/    

BEGIN
	
	DECLARE @Results TABLE(
		StaffId int,
		StaffName varchar(100)
	)
	
	INSERT INTO @Results(
		StaffId,
		StaffName
	)
	SELECT 0,''Not Needed''

	INSERT INTO @Results(
		StaffId,
		StaffName
	)
	SELECT StaffId AS ValueField, LastName + '', '' + FirstName AS TextField
	FROM Staff
	WHERE StaffId IN (152,167,185,445,480,587,1262,681) AND
	      ISNULL(RecordDeleted,''N'') = ''N''
	ORDER BY TextField ASC

	INSERT INTO @Results(
		StaffId,
		StaffName
	)
	SELECT 99999999,''Unknown''
	
	SELECT * FROM @Results
	
END' 
END
GO
