IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RxGetStaffLicenseDegrees]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxGetStaffLicenseDegrees] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER OFF 

GO 

CREATE PROC [dbo].[ssp_RxGetStaffLicenseDegrees] (@StaffId INT) 
AS 
/************************************************************************/ 
/* Stored Procedure: dbo.ssp_RxGetStaffLicenseDegrees					*/ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC				*/ 
/* Creation Date:    05/May/2016										*/ 
/* Created By   :    Malathi Shiva                                      */
/* Purpose: Get all Staff DEA License and Degrees for a Particular Staff*/
/*																		*/ 
/* Input Parameters: none												*/ 
/*																		*/ 
/* Output Parameters:   None											*/ 
/*																		*/ 
/* Return:  0=success, otherwise an error number						*/ 
/*																		*/ 
/* Called By:															*/ 
/*																		*/ 
/* Calls:																*/ 
/*																		*/ 
/* Data Modifications:													*/ 
	/*																		*/ 
/* Updates:																*/ 
/*  Date      Modified By       Purpose   
26th Sep 2017  kavya.N          DEA dropdown should bind with only active DEA's; Added condition startdate and enddate */ 
/* Jan/09/2018 Malathi Shiva	When the start date is null then the DEA number was not retrieving for Staff Which is not fixed as part of Core Bugs 2522 */
/************************************************************************/ 
BEGIN  
  
 BEGIN TRY  
      SELECT StaffLicenseDegreeId 
             ,StaffId 
             ,LicenseTypeDegree 
             ,LicenseNumber 
             ,StartDate 
             ,EndDate 
             ,Billing 
             ,Notes 
             ,LicenseNumber as DEANumber
             ,PrimaryValue
             ,StateFIPS
      FROM   StaffLicenseDegrees SLD 
      WHERE  ISNULL(SLD.RecordDeleted, 'N') = 'N' 
			 AND SLD.LicenseTypeDegree = '9403'  -- DEA# GlobalCode Id
             AND SLD.StaffId = @StaffId 
             AND ISNULL(SLD.StartDate,CAST(getdate() AS DATE)) <= CAST(getdate() AS DATE)
             AND ISNULL(SLD.EndDate,CAST(getdate() AS DATE)) >= CAST(getdate() AS DATE)
	  ORDER BY ISNULL(SLD.PrimaryValue,'N') DESC
	  
 END TRY  
                
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetNonStaffUserDetail')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH   
 RETURN  
END  
  
GO


GO 