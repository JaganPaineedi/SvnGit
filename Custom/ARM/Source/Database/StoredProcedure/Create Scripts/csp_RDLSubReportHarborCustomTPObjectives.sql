/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHarborCustomTPObjectives]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPObjectives]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPObjectives]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/************************************************************************/                                                        
/* Stored Procedure: csp_RDLSubReportHarborCustomTPObjectives        */                                               
/*        */                                                        
/* Creation Date:  22 June 2011           */                                                        
/*                  */                                                        
/* Purpose: Gets Data for csp_RDLSubReportHarborCustomTPObjectives       */                                                       
/* Input Parameters: GoalId        */                                                      
/* Output Parameters:             */                                                        
/* Purpose: Use For Rdl Report           */                                              
/* Calls:                */                                                        
/*                  */                                                        
/* Author: Davinder Kumar             */ 
/* 02.06.2012 - RohitK           - Changed TargetDate format as MM/DD/YYYY. */        
/* 02.08.2012 - Jagdeep Hundal   -  Added RecordDeleted check for table CustomTPObjectives */                                                                 
/* 21.08.2012 - T. Remisoski		FIXED INCORRECT JOIN LOGIC.	*/
/*********************************************************************/      
CREATE PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPObjectives]   
 @TPGoalId as INT    
AS    
BEGIN    
 SELECT     
 CTO.ObjectiveNumber   
 ,CTO.ObjectiveText    
 ,CTO.Status    
 ,CTO.TPGoalId    
 ,CTO.TPObjectiveId    
 ,CONVERT(VARCHAR(10),CTO.TargetDate,101) AS TargetDate   
 FROM CustomTPObjectives AS CTO 
 WHERE CTO.TPGoalId=@TPGoalId 
 and ISNULL(CTO.RecordDeleted, ''N'') = ''N''
 order by cto.ObjectiveNumber
 
     
END   
' 
END
GO
