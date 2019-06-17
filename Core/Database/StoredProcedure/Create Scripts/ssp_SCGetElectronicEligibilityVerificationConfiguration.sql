IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetElectronicEligibilityVerificationConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationConfiguration]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetElectronicEligibilityVerificationConfiguration]
AS 
    BEGIN                                    
	/************************************************************************************/                                                                                
	 /* Stored Procedure: [ssp_SCGetElectronicEligibilityVerificationConfigurations]     */                                                                       
	 /* Creation Date:  20/01/2012														*/                                                                                
	 /* Purpose: To get The Data of ElectronicEligibilityVerificationConfigurations      */                                                                              
	 /* Input Parameters:																*/          
	 /* Output Parameters:																*/   
	 /* Returns data of  ElectronicEligibilityVerificationConfigurations Table			*/                                                                                
	 /* Called By:																		*/                                                                      
	 /* Data Modifications:																*/                                                                                
	 /* Updates:																		*/                                                                                
	 /*  Date            Author														*/                                                                                
	 /*  20/Jan/2012     Deej    Created												*/ 
	 /*	 2013.02.27		JJN																*/ 
	 /*  12/10/2013		PradeepA	Added DateRange Column	*/                  
	 
	 -- 27/03/2017   Lakshmi What: Added ElectronicEligibilityVerificationConfigurationId to select statement
      --				     Why:  Woods - Support Go Live #170                                                           
	 /***********************************************************************************/                                      
                                  
        BEGIN TRY        
            BEGIN     
                               
				SELECT  [AllowableHoursSinceLastVerified] ,
						[RequestTimeoutSeconds] ,
						[WebServiceURL] ,
						[PayerListStoredProcedureName] ,
						[InquiryVerificationHistoryStoredProcedureName] ,
						[ValidateScreenSpecificStoredProcedureName] ,
						[ValidateEligibilityRequestStoredProcedureName] ,
						[UpdateEligibilityStoredProcedureName] ,
						[GetEligibilityTextResponseStoredProcedureName] ,
						[UpdateClientCoveragePlanProcedureName] ,
						[CreateElectronicEligibilityVerificationBatchIdStoredProcedureName] ,
						[QueryElectronicEligibilityBatchVerificationDataStoredProcedureName] ,
						[DefaultServiceStartDateDaysBackFromCurrentDate] = 
							ISNULL(b.DaysBackFromCurrentDate, a.DefaultServiceStartDateDaysBackFromCurrentDate) ,
						[DefaultServiceEndDateDaysForwardFromCurrentDate] = 
							ISNULL(b.DaysForwardFromCurrentDate, a.DefaultServiceEndDateDaysForwardFromCurrentDate) 
						,[SourceName]
						,[DateRange]
						,[ElectronicEligibilityVerificationConfigurationId]
				FROM    [dbo].[ElectronicEligibilityVerificationConfigurations] a
				CROSS APPLY ( 
					SELECT 
						  DaysBackFromCurrentDate
						, DaysForwardFromCurrentDate
					FROM dbo.scfn_SCGetElectronicEligibilityVerificationConfigurations_DefaultDates(
						  a.DefaultServiceStartDateDaysBackFromCurrentDate
						, a.DefaultServiceEndDateDaysForwardFromCurrentDate
						) 
					) AS b
					
            END      
        END TRY        
        BEGIN CATCH                                                                                   
            
            DECLARE @Error VARCHAR(8000)                                                       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_SCGetElectronicEligibilityVerificationConfigurations')
                + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                                                                    
                                                                                                  
                                                                                
            RAISERROR                                                                                     
 (                                                       
  @Error, -- Message text.                                                                 
  16, -- Severity.                                                                                    
  1 -- State.                                                                                    
 ) ;                                                                                    
                                                        
        END CATCH                                      
                            
                            
    END 

GO


