IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateNewOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateNewOrder]
GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE ssp_ValidateNewOrder
@StaffId int 

/*========================================================================
Stored Procedure: ssp_ValidateNewOrder
Created Date:08/10/2017
Purpose: Returns ValidationMessage for performing validation.
Author: PranayB
Data Modification:
Data            Author                 Purpose


===========================================================================*/

AS 
BEGIN 

DECLARE	@ValidationMessage NVARCHAR(MAX)
DECLARE @StreamlineStaff CHAR(1) 
BEGIN TRY
  SELECT @StreamlineStaff = sp.StreamlineStaff FROM Staff s 
       LEFT JOIN dbo.StaffPreferences sp ON  sp.StaffId = s.StaffId
	   WHERE s.StaffId=@StaffId
	   AND ISNULL(s.RecordDeleted,'N')<>'Y'
  
 
 IF(@StreamlineStaff ='Y')
    SET @ValidationMessage='You are not authorized to prescribe.'
 
SELECT @ValidationMessage AS ValidationMessage
 END TRY
   BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_ValidateNewOrder]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                   
				16
				,-- Severity.                                                                                                    
				1 -- State.                                                                                                   
				);
	END CATCH
END

GO