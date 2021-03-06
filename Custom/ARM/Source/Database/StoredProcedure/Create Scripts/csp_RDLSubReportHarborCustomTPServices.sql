/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHarborCustomTPServices]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHarborCustomTPServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
  
  
/************************************************************************/                                                      
/* Stored Procedure: csp_RDLSubReportHarborCustomTPServices        */                                             
/*        */                                                      
/* Creation Date:  22 June 2011           */                                                      
/*                  */                                                      
/* Purpose: Gets Data for csp_RDLSubReportHarborCustomTPServices       */                                                     
/* Input Parameters: GoalId        */                                                    
/* Output Parameters:             */                                                      
/* Purpose: Use For Rdl Report           */                                            
/* Calls:                */                                                      
/*                  */                                                      
/* Author: Davinder Kumar             */                                                      
/*********************************************************************/    
CREATE PROCEDURE [dbo].[csp_RDLSubReportHarborCustomTPServices]  
 @TPGoalId as int  
AS  
BEGIN  
 SELECT   
 CTS.AuthorizationCodeId  
 ,CTS.FrequencyType  
 ,CTS.ServiceNumber  
 ,CTS.Status  
 ,CTS.TPGoalId  
 ,CTS.TPServiceId  
 ,CTS.Units AS Units  
 ,AC.AuthorizationCodeName  
 ,GC.CodeName AS AuthorizationUnitType   
 FROM CustomTPServices AS CTS   
 LEFT JOIN AuthorizationCodes AC ON CTS.AuthorizationCodeId=AC.AuthorizationCodeId AND ISNULL(AC.RecordDeleted,''N'')=''N''  
 Inner Join GlobalCodes GC ON GC.GlobalCodeId=CTS.FrequencyType   
   WHERE CTS.TPGoalId=@TPGoalId AND ISNULL(CTS.RecordDeleted,''N'')=''N'' AND ISNULL(GC.RecordDeleted,''N'')=''N''  
       
   
   
END  ' 
END
GO
