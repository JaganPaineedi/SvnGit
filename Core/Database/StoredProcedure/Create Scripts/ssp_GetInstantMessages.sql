/****** Object:  StoredProcedure [dbo].[ssp_GetInstantMessages]    Script Date: 11/18/2011 16:25:40 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_GetInstantMessages]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_GetInstantMessages];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE [dbo].[ssp_GetInstantMessages] @LoggedInStaffId INT, @SessionId VARCHAR(30)
AS /******************************************************************************        
**  File: dbo.ssp_GetInstantMessages    
**  Name: ssp_GetInstantMessages    
**  Desc: SmartCare polls this stored procedure periodically and returns the    
**        InstantMessages.Message text which is then displayed in a popup    
**             
**  Auth: Ryan Noble       
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:        Author:      Description:        
**  -----------  ------------ ---------------------------------------        
**  13-Aug-2010  RJN          Created  
**  03/06/2018	 jcarlson	  Modified to update StaffLoginHistory.LastRequestDate to current datetime
*******************************************************************************/  
    SET NOCOUNT ON;   
    SELECT  [Message]
    FROM    InstantMessages
    WHERE   StaffId = @LoggedInStaffId;    
    
    DELETE  FROM InstantMessages
    WHERE   StaffId = @LoggedInStaffId;
	
	UPDATE dbo.StaffLoginHistory
	SET LastRequest = GETDATE()
	WHERE StaffId = @LoggedInStaffId
	AND SessionId = @SessionId
	AND LogoutTime IS NULL
	 
    SET NOCOUNT OFF;
 

GO