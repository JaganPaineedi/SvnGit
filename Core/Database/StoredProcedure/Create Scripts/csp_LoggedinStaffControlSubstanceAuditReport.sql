/****** Object:  StoredProcedure [dbo].[csp_LoggedinStaffControlSubstanceAuditReport]    ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_LoggedinStaffControlSubstanceAuditReport]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_LoggedinStaffControlSubstanceAuditReport];
GO

/****** Object:  StoredProcedure [dbo].[csp_LoggedinStaffControlSubstanceAuditReport]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[csp_LoggedinStaffControlSubstanceAuditReport] 

AS

/******************************************************************************
* Creation Date:  6/DEC/2016
*
* Purpose: Gather data for Control Substance Audit Report - EPCS #32
* 
* Customer: EPCS
*
* Called By: Control Substance Audit Report
*
* Calls:
*
* Dependent Upon:
*
* Depends upon this: Report Days to Service
*
* Modifications:
* Date			Author			Purpose
* 09/26/2018    vkumar          Modified the Stored procedure to display All the  prescribers in the prescriber list.
*
*****************************************************************************/
BEGIN
BEGIN TRY

  SELECT  StaffId , Lastname +  ', ' + Firstname as Staffname
   from Staff  
  Where ISNULL(Prescriber,'N')='Y' and ISNULL(RecordDeleted,'N')='N' 
  
END TRY
 BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_LoggedinStaffControlSubstanceAuditReport')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  
  RAISERROR                                                                                     
  (                                                       
   @Error, -- Message text.                                                                                    
   16, -- Severity.                                                                                    
   1 -- State.                                                                                    
   );         
 END CATCH

END


GO
