/****** Object:  StoredProcedure [dbo].[csp_PostUpdateDisclosureRequestDetails]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateDisclosureRequestDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdateDisclosureRequestDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdateDisclosureRequestDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--select * from dbo.Messages
--exec sys.sp_help ''messages''

CREATE PROCEDURE [dbo].[csp_PostUpdateDisclosureRequestDetails]
/******************************************************************************                                      
**  File: csp_PostUpdateDisclosureRequestDetails                                  
**  Name: csp_PostUpdateDisclosureRequestDetails              
**  Desc: Post update create alerts
**  Return values:                                     
**  Called by: Disclosure/Request Details                                       
**  Parameters:                  
**  Auth:  Wasif Butt
**  Date:  Oct 16 2012                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
**  --------    --------        -----------------------------------------------                                      
** 
*******************************************************************************/

    @ScreenKeyId INT ,
    @StaffId INT ,
    @CurrentUser VARCHAR(30) ,
    @CustomParameters XML
AS 
    DECLARE @ClientDisclosureId INT ,
        @DisclosureStatus INT ,
        @DisclosureDate DATETIME ,
        @DisclosedBy int ,
        @ClientId INT ,
        @msgSubject VARCHAR(700) ,
        @msgBody VARCHAR(3000),
        @CustomClientDisclosureAlertTrackingId INT
        
    SELECT  @ClientDisclosureId = ClientDisclosureId , @DisclosureStatus = DisclosureStatus , @DisclosureDate = DisclosureDate , @DisclosedBy = DisclosedBy, @ClientId = ClientId
	FROM    ClientDisclosures 
	WHERE   ClientDisclosureId = @ScreenKeyId

    IF @DisclosureStatus = 21906 -- Pending Clinician Review
    BEGIN
        INSERT INTO dbo.CustomClientDisclosureAlertTracking
                ( ClientDisclosureId ,
                  CreatedDate ,
                  CreatedBy ,
                  DisclosureDate , 
                  DisclosedBy
                )
                SELECT  @ClientDisclosureId ,
                        GETDATE() ,
                        @CurrentUser , 
                        @DisclosureDate ,
                        @DisclosedBy                    
    END
    
    SET @CustomClientDisclosureAlertTrackingId = @@IDENTITY

    IF NOT EXISTS ( SELECT  1
                    FROM    CustomClientDisclosureAlertTracking
                    WHERE   ClientDisclosureId = @ScreenKeyId
							AND @DisclosedBy = DisclosedBy
                            AND DATEDIFF(day,
                                         CONVERT(VARCHAR(10), ISNULL(AlertDate, DATEADD(day, -10, GETDATE())), 101),
                                         CONVERT(VARCHAR(10), GETDATE(), 101)) <= 7 ) 
        BEGIN
            SET @msgSubject = ''Disclosure Request pending approval.''
            SET @msgBody = ''A disclosure request for client: ''
                + CAST(@ClientId AS VARCHAR)
                + '' has been created or updated and is awaiting your response.''

            INSERT  INTO dbo.Alerts
                    ( ToStaffId ,
                      ClientId ,
                      AlertType ,
                      Unread ,
                      DateReceived ,
                      Subject ,
                      Message 
                            
                    )
                    SELECT  cd.DisclosedBy ,
                            @ClientId ,
                            21911 , --GlobalCode alertType document
                            ''Y'' ,
                            GETDATE() ,
                            @msgSubject ,
                            @msgBody
                    FROM    dbo.ClientDisclosures AS cd
                            JOIN dbo.Staff AS s ON s.StaffId = cd.DisclosedBy
                    WHERE   cd.ClientDisclosureId = @ScreenKeyId
                            AND s.Active = ''Y''
                            AND ISNULL(s.RecordDeleted, ''N'') = ''N''
                                    
            UPDATE  CustomClientDisclosureAlertTracking
            SET     AlertCreated = ''Y'' ,
                    AlertDate = GETDATE()
            WHERE   CustomClientDisclosureAlertTrackingId = @CustomClientDisclosureAlertTrackingId

        END
' 
END
GO
