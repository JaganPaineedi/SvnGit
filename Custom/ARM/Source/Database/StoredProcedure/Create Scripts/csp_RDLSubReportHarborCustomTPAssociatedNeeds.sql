/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHarborCustomTPAssociatedNeeds]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPAssociatedNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPAssociatedNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPAssociatedNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/************************************************************************/                                                    
/* Stored Procedure: csp_RDLSubReportHarborCustomTPNeeds        */                                           
/*        */                                                    
/* Creation Date:  22 June 2011           */                                                    
/*                  */                                                    
/* Purpose: Gets Data for csp_RDLSubReportHarborCustomTPNeeds       */                                                   
/* Input Parameters: DocumentVersionId        */                                                  
/* Output Parameters:             */                                                    
/* Purpose: Use For Rdl Report           */                                          
/* Calls:                */                                                    
/*                  */                                                    
/* Author: Davinder Kumar             */
/* 02.06.2012 - RohitK      - Changed TargetDate format as MM/DD/YYYY. */                                                     
/*********************************************************************/  
CREATE PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPAssociatedNeeds]
	@TPGoalId as INT
AS
BEGIN
	SELECT 
	CONVERT(VARCHAR(10),CTGN.DateNeedAddedToPlan,101) AS DateNeedAddedToPlan
	,CTGN.NeedId
	,CTGN.TPGoalId
	,CTGN.TPGoalNeeds
	,CTN.NeedText AS NeedText
	FROM CustomTPGoalNeeds AS CTGN INNER JOIN
	 CustomTPNeeds AS CTN ON CTN.NeedId = CTGN.NeedId
	 WHERE CTGN.TPGoalId=@TPGoalId  AND (ISNULL(CTGN.RecordDeleted, ''N'') = ''N'')
			  
	
	
END

' 
END
GO
