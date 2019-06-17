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
/*  Date      Modified By       Purpose                                 */ 
/************************************************************************/ 
  BEGIN 
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
	  ORDER BY ISNULL(SLD.PrimaryValue,'N') DESC
	  
      IF ( @@error != 0 ) 
        BEGIN 
            RAISERROR 20002 'ssp_RxGetStaffLicenseDegrees: An Error Occured' 

            RETURN( 1 ) 
        END 

      RETURN( 0 ) 
  END 

GO 