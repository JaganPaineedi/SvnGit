
GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRMessageService]    Script Date: 06/09/2015 02:35:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRMessageService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRMessageService]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRMessageService]    Script Date: 06/09/2015 02:35:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Kneale Alpers
-- Create date: December 20, 2011
-- Description:	Retrieves CCR Message
/*
	author		modified date	Reason
	avoss		05.18.2012		modified To display "Client Medical Record" for source

*/


-- =============================================
CREATE PROCEDURE [dbo].[ssp_CCRMessageService]
    @ServiceId BIGINT ,
    @StaffId BIGINT
AS 
    BEGIN
        DECLARE @ClientId BIGINT
        SELECT  @ClientId = ClientId
        FROM    services
        WHERE   ServiceId = @ServiceId
			
        SET NOCOUNT ON ;
	
        SELECT  CAST(NEWID() AS VARCHAR(50)) AS CCRDocumentObjectID ,
                'English' AS Language ,
                'V1.0' AS Version ,
                'CCR Creation DateTime' AS [DateTime_Type] ,
                SUBSTRING(CONVERT(VARCHAR(50), GETDATE(), 127), 1, 22) AS DateTime_ApproximateDateTime ,
                'Patient.' + CAST(@ClientId AS VARCHAR(100)) AS ActorID ,
                'Patient' AS ActorRole ,
                'For the patient' AS Purpose_Description ;
          
        SELECT  'Staff.' + CAST(@StaffId AS VARCHAR(100)) AS ActorID ,
                CAST(@StaffId AS VARCHAR(100)) AS ID1_ActorID ,
                'Provider' AS ActorRole ,
                ISNULL(LastName, '') AS Current_Family ,
                ISNULL(FirstName, '') AS Current_Given ,
                ISNULL(MiddleName, '') AS Current_Middle ,
                CASE WHEN lastname IS NULL THEN ''
                     ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
                END AS Current_DisplayName ,
                '' AS From_Actor_Title ,
                ISNULL(CONVERT(VARCHAR(10), DOB, 21), '') AS DOB_ApproximateDateTime ,
                CASE sex
                  WHEN 'F' THEN 'Female'
                  WHEN 'M' THEN 'Male'
                  ELSE 'Unknown'
                END AS Gender ,
                ISNULL(Email, '') AS CT1_Email_Value ,
                '' AS ActorSpecialty ,
                'Staff ID' AS ID1_IDType ,
                'SmartcareWeb' AS ID1_Source_ActorID ,
                'SmartcareWeb' AS SLRCGroup_Source_ActorID ,
                'EHR' AS ID1_Source_ActorRole
        FROM    staff
        WHERE   StaffId = @StaffId ;
        
        SELECT TOP ( 1 )
                REPLACE(OrganizationName, ' ', '_') AS ActorID ,
                OrganizationName AS DisplayName ,
                'Organization' AS ActorRole ,
                'SmartcareWeb' AS SLRCGroup_Source_ActorID
        FROM    dbo.SystemConfigurations ;
        
        SELECT  'SmartcareWeb' AS ActorID ,
                'Client Medical Record' AS DisplayName ,
                'InformationSystem' AS ActorRole ,
                'SmartcareWeb' AS SLRCGroup_Source_ActorID
        
        SELECT TOP ( 0 )
                '' AS ActorID ,
                '' AS ActorRole ;
		
        EXEC ssp_CCRGetClientInfo @ClientId
		
        EXEC ssp_CCRGetMedicationListServiceSummary @ClientId, @ServiceId
		
        EXEC ssp_CCRGetMedicationAlertServiceSummary @ClientId, @ServiceId		     
		
        EXEC ssp_CCRGetLabResultsServiceSummary @ClientId, @ServiceId
		
        EXEC ssp_CCRGetProblemListSummary @ClientId		
    
    END





GO

