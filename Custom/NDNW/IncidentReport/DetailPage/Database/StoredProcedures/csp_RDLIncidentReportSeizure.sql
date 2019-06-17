IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIncidentReportSeizure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIncidentReportSeizure]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLIncidentReportSeizure]    Script Date: 11/27/2013 16:30:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLIncidentReportSeizure]  
(                                                                                                                                                                                        
  @IncidentReportSeizureDetailId int                                                                                                                                                        
)                                                     
AS 

/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RDLIncidentReportSeizure]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:   06-May-2015                                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomIncidentReportSeizures Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @IncidentReportSeizureId           */                                                                                                                                    
/*                                                                   */                                                                                                                                      
/* Output Parameters:   None                   */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/*                                                                   */                  
/* Calls:                        */                       
/* */                                         
/* Data Modifications:   */                                          
/*      */                                                                                     
/* Updates:                                          
 Date			Author			Purpose       
 ----------		---------		--------------------------------------                                                                               
 07-May-2015	Ravichandra		what:Use For Rdl Report  
								why:task #818 Woods – Customizations                                    
*/                                                                                                           
/*********************************************************************/                                                                                                                              
                                                                                                                                                                                                                                 
BEGIN
BEGIN TRY  
		
		SELECT
			cast(ROW_NUMBER() OVER (ORDER BY IncidentReportSeizureId) AS INT) AS NoOfSeizure
			,(right('0' + LTRIM(SUBSTRING(CONVERT(varchar, TimeOfSeizure, 100), 13, 2)),2)+ ':' + SUBSTRING(CONVERT(varchar, TimeOfSeizure, 100), 16, 2) + ' ' + SUBSTRING(CONVERT(varchar,TimeOfSeizure, 100), 18, 2))as TimeOfSeizure
			,CAST(DurationOfSeizureMin as varchar)+' '+'minute'+' '+CAST(DurationOfSeizureSec as varchar)+'seconds' as DurationOfSeizure
			FROM CustomIncidentReportSeizures 
			WHERE IncidentReportSeizureDetailId = @IncidentReportSeizureDetailId AND isnull(RecordDeleted, 'N') = 'N'  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIncidentReportSeizure') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 
			