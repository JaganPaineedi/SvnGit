/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHarborCustomTPGoals]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPGoals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/************************************************************************/                                                          
/* Stored Procedure: csp_RDLSubReportHarborCustomTPGoals        */                                                 
/*        */                                                          
/* Creation Date:  22 June 2011           */                                                          
/*                  */                                                          
/* Purpose: Gets Data for csp_RDLSubReportHarborCustomTPGoals       */                                                         
/* Input Parameters: DocumentVersionId        */                                                        
/* Output Parameters:             */                                                          
/* Purpose: Use For Rdl Report           */                                                
/* Calls:                */                                                          
/*                  */                                                          
/* Author: Davinder Kumar             */ 
/* 02.06.2012 - RohitK      - Changed TargetDate format as MM/DD/YYYY. */                                                         
/*********************************************************************/        
      
      
CREATE PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPGoals]   
 @DocumentVersionId as int      
AS      
BEGIN      
 SELECT       
  isnull(CTG.Active,''Y'') as Active        
 ,CTG.DocumentVersionId      
 ,CTG.GoalNumber      
 ,CTG.GoalText      
 ,CTG.TPGoalId      
 ,CTG.ProgressTowardsGoal      
 ,CTG.CreatedBy      
 ,CTG.CreatedDate      
 ,CTG.ModifiedDate      
 ,CONVERT(VARCHAR(10),CTG.TargeDate,101) AS TargetDate      
 ,D.DocumentCodeId,
 DC.DocumentName
 FROM CustomTPGoals AS CTG INNER JOIN DocumentVersions DV on CTG.DocumentVersionId=DV.DocumentVersionId
 inner join Documents AS D ON D.DocumentId=DV.DocumentId and isnull(D.RecordDeleted,''N'')<>''Y''
 inner join dbo.DocumentCodes as dc on dc.DocumentCodeId = d.DocumentCodeId     
 -- CTG.DocumentVersionId = D.CurrentDocumentVersionId       
  WHERE CTG.DocumentVersionId=@DocumentVersionId AND (ISNULL(CTG.RecordDeleted, ''N'') = ''N'')      
       
       
END 
' 
END
GO
