IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetDrugCategory]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetDrugCategory] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER OFF 

GO 

CREATE PROCEDURE [dbo].[ssp_GetDrugCategory]
@MedicationNameId BIGINT
AS 
/************************************************************************/ 
/* Stored Procedure: dbo.[ssp_GetDrugCategory]							*/ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC				*/ 
/* Creation Date:    02/Nov/2016										*/ 
/* Created By   :    Nandita S		                                    */
/* Purpose: Get all Staff DEA License and Degrees for a Particular Staff*/
/*																		*/ 
/* Input Parameters: MedicationNameId												*/ 
/*																		*/ 
/* Output Parameters:   drugcategory											*/ 
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
  
	SELECT DISTINCT  [dbo].[ssf_SCClientMedicationC2C5Drugs](MedicationId) AS drugcategory
	FROM     dbo.MDMedications
	WHERE    MedicationNameId = @MedicationNameId 
                                             
END 

