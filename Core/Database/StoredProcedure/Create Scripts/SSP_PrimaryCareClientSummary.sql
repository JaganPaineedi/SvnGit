/****** Object:  StoredProcedure [dbo].[SSP_PrimaryCareClientSummary]    Script Date: 02/25/2015 17:22:44 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PrimaryCareClientSummary]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_PrimaryCareClientSummary]
GO

/****** Object:  StoredProcedure [dbo].[SSP_PrimaryCareClientSummary]    Script Date: 02/25/2015 17:22:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[SSP_PrimaryCareClientSummary]     
 @clientId int,  
 @staffid int  
AS    
/************************************************************************************/                            
/* Stored Procedure: dbo.[SSP_PrimaryCareClientSummary]12,93      */                            
/* Copyright: 2012 Streamline Healthcare Solutions,  LLC       */                            
/* Creation Date:   25/07/2012                 */                                                         
/*                        */                          
/* Input Parameters: @clientId,@staffid           */                          
/*                     */                            
/* Output Parameters:   None              */                            
/*                     */                            
/* Return:  0=success, otherwise an error number         */                            
/*                     */                            
/* Called By:                  */                            
/*                     */                            
/* Calls:                   */                            
/*                     */                            
/* Data Modifications:                */                            
/*                     */                            
/* Updates:                   */                            
/*  Date       Author                   Purpose          */                            
/* 25-7-2012   Anil Kumar chaturvedi    Created          */   
/* 04-10-2012  Sunil Kh                 Modify Add Clientproblem data    */                    
/************************************************************************************/   
BEGIN   
  
-- "MostRecentLab", "medication", "diagnosis", "Allergy", "Dashboard", "Visits", "HealthMaintenanceNeeded","ClientProblem"   
 BEGIN TRY   
 EXEC SSP_PrimaryCareMostRecentLab @clientId,@staffid  
 EXEC SSP_PrimaryCareMedication @clientId,@staffid  
 --EXEC SSP_PrimaryCareDiagnosis @clientId,@staffid  
 EXEC SSP_PrimaryCareAllergy @clientId,@staffid  
 EXEC SSP_PrimaryCareDashboard @clientId,@staffid  
 EXEC SSP_PrimaryCareVisits @clientId,@staffid  
 --EXEC SSP_PrimaryCareHealthMaintenanceNeeded @clientId,@staffid  
 EXEC ssp_PCSummaryHealthMaintenance @clientId,@staffid  
 EXEC SSP_PrimaryCareClientProblem @clientId,@staffid  
 END TRY  
   
 BEGIN CATCH                                                                      
  DECLARE @Error varchar(8000)            
  SET @Error = convert(VARCHAR, ERROR_NUMBER()) + '*****' + convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_PrimaryCareClientSummary') + '*****' + convert(VARCHAR, ERROR_LINE()) + '*****' +         
  convert(VARCHAR, ERROR_SEVERITY()) + '*****' + convert(VARCHAR, ERROR_STATE())                                                                                        
            
   RAISERROR          
   (          
   @Error, -- Message text.          
   16, -- Severity.          
   1 -- State.          
   )          
 End CATCH    
 END 