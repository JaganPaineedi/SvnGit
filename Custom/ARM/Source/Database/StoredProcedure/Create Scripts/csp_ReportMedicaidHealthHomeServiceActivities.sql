/****** Object:  StoredProcedure [dbo].[csp_ReportMedicaidHealthHomeServiceActivities]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportMedicaidHealthHomeServiceActivities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportMedicaidHealthHomeServiceActivities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ReportMedicaidHealthHomeServiceActivities]
    @DocumentVersionId INT
AS /******************************************************************************
**		File: 
**		Name: csp_ReportMedicaidHealthHomeServiceActivities
**		Desc: Pulls data for Medicaid Health Home Service Activity Interim Note report
**
**		Return values:	<type_YorN>		- IdentificationOfEligibility
**						<type_YorN>		- InitiatedOutreache
**						<type_YorN>		- ProvidedServiceOrientation
**						<type_YorN>		- ReviewedPatientHealthProfiles
**						<type_YorN>		- AssistanceObtainingHealthcare
**						<type_YorN>		- ProvisionOfHealthEducation
**						<type_YorN>		- CoordinationWithProviders
**						<type_YorN>		- SupportRelationshipProviders
**						<type_YorN>		- ReferralCommunitySupports
**						<type_Comment2> - Narrative
** 
**		Called by:   Medicaid Health Home Service Activity Interim Note
**              
**		Parameters:
**		Input							Output
**		@DocumentVersionId						
**
**		Auth: Chuck Blaine
**		Date: Oct 21 2012
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**     Nov/13/2015     Hemant Kumar    Added Ser.OtherPersonsPresent to show the Other persons present on PDFs 
                                       (A Renewed Mind - Support #386)
	
*******************************************************************************/

    BEGIN TRY
        SELECT  main.DocumentVersionId ,
                IdentificationOfEligibility ,
                InitiatedOutreache ,
                ProvidedServiceOrientation ,
                ReviewedPatientHealthProfiles ,
                AssistanceObtainingHealthcare ,
                ProvisionOfHealthEducation ,
                CoordinationWithProviders ,
                SupportRelationshipProviders ,
                ReferralCommunitySupports ,
                Narrative ,
                c.ClientId ,
                ISNULL(c.FirstName + '' '', '''') + ISNULL(LEFT(c.MiddleName, 1)
                                                       + ''.'' + '' '', '''')
                + ISNULL(c.LastName, '''') AS ClientName ,
                ISNULL(s.FirstName + '' '', '''') + ISNULL(s.LastName, '''') + ISNULL('', '' + s.SigningSuffix, '''') AS StaffName ,
                d.EffectiveDate,
                SE.OtherPersonsPresent 
        FROM    [dbo].[CustomDocumentMedicaidHealthHomeServiceActivities] main
				JOIN dbo.DocumentVersions dv ON dv.DocumentVersionId = main.DocumentVersionId
                JOIN dbo.Documents d ON d.DocumentId = dv.DocumentId
                JOIN dbo.Staff s ON s.StaffId = d.AuthorId
                JOIN dbo.Clients c ON c.ClientId = d.ClientId
                left join Services SE on d.ServiceId=SE.ServiceId 
        WHERE   main.DocumentVersionId = @DocumentVersionId
                AND ISNULL(main.RecordDeleted, ''N'') = ''N''
    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000)
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     ''csp_ReportMedicaidHealthHomeServiceActivities'')
            + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****''
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****''
            + CONVERT(VARCHAR, ERROR_STATE())
		
        RAISERROR 
	(
		@Error, -- Message text.
		16, -- Severity.
		1 -- State.
	);

    END CATCH
' 
END
GO
