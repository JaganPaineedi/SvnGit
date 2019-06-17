IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetStaffIdOfAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetStaffIdOfAppointment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SSP_SCGetStaffIdOfAppointment]   
(    
@AppointmentId INT    
) 
/****** Object:  StoredProcedure [dbo].[ssp_GetAuthorizationDefaultDetails]    Script Date: 08/09/2015 
-- Created:           
-- Date			Author				Purpose 
  
  21-03-2017   Vaibhav			For geiing the staffid for appointment
 									*********************************************************************************/  
AS                                   
 BEGIN    
   
  BEGIN TRY 
  DECLARE @StaffID INT
  
  SELECT @StaffID =staffid FROM Appointments where AppointmentId=@AppointmentId
  
  SELECT ISNULL(@StaffID,0)
  END TRY  
BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAuthorizationDefaultDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.      
    16  
    ,-- Severity.      
    1 -- State.      
    );  
 END CATCH  
END  
