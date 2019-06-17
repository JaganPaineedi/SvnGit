IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_RxGetFailedElectronicPrescriptions]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxGetFailedElectronicPrescriptions] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER OFF 

GO 

CREATE PROC [dbo].[ssp_RxGetFailedElectronicPrescriptions] @ClientId         INT 
                                                           ,@LoggedInStaffId INT 
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_RxGetFailedElectronicPrescriptions                   */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    28/Dec/2015                                      */ 
/* Created By   :    Malathi Shiva                                                                  */
/* Purpose: Checks all the Client Prescriptions that failed Electronically, OrderDate which lie between the start date specified in the system configuration Key 'ResendFaxFromStartDateToTilldate' to till date*/
/*                                                                   */ 
/* Input Parameters: none                     */ 
/*                                                                    */ 
/* Output Parameters:   None                                 */ 
/*                                                                   */ 
/* Return:  0=success, otherwise an error number                     */ 
/*                                                                   */ 
/* Called By:                                                        */ 
/*                                                                   */ 
/* Calls:                                                            */ 
/*                                                                   */ 
/* Data Modifications:                                               */ 
/*                                                                   */ 
/* Updates:                                                          */ 
/*  Date     Modified By       Purpose                                    */ 
/*                                    */ 
  /*********************************************************************/ 
  BEGIN 
      DECLARE @ResendFaxFromStartDateToTilldate DATETIME 

      SET @ResendFaxFromStartDateToTilldate = 
      (SELECT TOP 1 Value 
       FROM   SystemConfigurationKeys 
       WHERE  [Key] = 'ResendFaxFromStartDateToTilldate') 

      SELECT * 
      FROM   ClientMedicationScriptActivities CMSA 
             JOIN ClientMedicationScripts CMS 
               ON CMS.ClientMedicationScriptId = CMSA.ClientMedicationScriptId 
      WHERE  NOT EXISTS (SELECT 1 
                         FROM   ClientMedicationScriptActivities 
                         WHERE  Method = 'P' 
                                AND ClientMedicationScriptId = CMSA.ClientMedicationScriptId) 
	  AND CMSA.Method = 'E' 
	  AND [Status] = 5564 
	  AND Cast(CMS.OrderDate AS DATE)>=  CAST(ISNULL(@ResendFaxFromStartDateToTilldate,GETDATE()) as DATE)
	  AND Cast(CMS.OrderDate AS DATE)<=  CAST(GETDATE() as DATE)
	AND CMS.ClientId = @ClientId 
	AND OrderingPrescriberId = @LoggedInStaffId 

IF ( @@error != 0 ) 
BEGIN 
RAISERROR 20002 
'ssp_RxGetFailedElectronicPrescriptions: An Error Occured' 

RETURN( 1 ) 
END 

RETURN( 0 ) 
END 

GO 
