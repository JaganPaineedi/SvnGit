IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffAsscoiatedInsurerss]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetStaffAsscoiatedInsurerss]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****************************************************************************************************/  
/* Stored Procedure: [ssp_GetStaffAsscoiatedInsurerss]                                              */  
/*       Date              Author                  Purpose                                          */  
/*      24-Jan-2018       Arjun K R         To Get Insurer Associated with Staff                    */ 
/*      30-Jan-2019       Venkatesh MR      What: Added a query to get All Active Insurers when the 'AllInsurers' is Y*/  
										  /*Why : If the All Insurer field is checked for that staff in Care Management tab, then should get all the  Active Insures Ref Task: AspenPointe - Support Go Live #811*/  
/****************************************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_GetStaffAsscoiatedInsurerss]  
(@StaffId INT)
      
AS  
BEGIN  
 BEGIN TRY  
 IF ((SELECT AllInsurers FROM Staff WHERE Staffid=@StaffId and IsNull(RecordDeleted,'N') = 'N')='Y')      
 Begin      
   SELECT InsurerId, InsurerName FROM Insurers WHERE Active='Y'  and IsNull(Insurers.RecordDeleted,'N')<>'Y'  
   ORDER BY InsurerName   
 END
 ELSE
 BEGIN
   SELECT InsurerId,InsurerName
   FROM Insurers  
   WHERE isnull(RecordDeleted, 'N') <> 'Y'   
      AND Active = 'Y'  
      AND EXISTS (  
      SELECT InsurerId  
      FROM StaffInsurers  
      WHERE StaffId = @StaffId  
      AND isnull(RecordDeleted, 'N') <> 'Y'  
      AND StaffInsurers.InsurerId = Insurers.InsurerId  
     )
  END  
END TRY  
  
 BEGIN CATCH  
  If (@@error!=0)                                                
	Begin                                                
		RAISERROR('[ssp_GetStaffAsscoiatedInsurerss] : An Error Occured',16,1)
		Return                                                
	End   
 END CATCH  
END  
GO


