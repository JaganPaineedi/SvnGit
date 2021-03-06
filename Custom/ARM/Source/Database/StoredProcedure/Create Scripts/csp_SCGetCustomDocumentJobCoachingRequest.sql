/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentJobCoachingRequest]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentJobCoachingRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentJobCoachingRequest]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentJobCoachingRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE	PROCEDURE	 [dbo].[csp_SCGetCustomDocumentJobCoachingRequest]
		@DocumentVersionId int
AS

SELECT	[DocumentVersionId],
		[CreatedBy],
		[CreatedDate],
		[ModifiedBy],
		[ModifiedDate],
		[RecordDeleted],
		[DeletedBy],
		[DeletedDate],
		
		[LastName],
		[FirstName],
		[DOB],
		[Address],
		[City],
		[State],
		[Zip],
		
		[PhoneNumber],
		[LegalGuardian],
		
		[AuthorizedService],
		[AuthorizedHours],
		[AuthorizedDOS],
		[ReferralSource],
		

		[Position],
		[CompanyName],
		[CompanyAddress],
		[CompanyCity],
		[CompanyState],
		[CompanyZip],

		[CompanyContactName],
		[CompanyPhoneNumber],
		
		[JobDescriptionAvailableYN],
		[JobDescription],
		[BackgroundCheckYN],
		[ClientWorkSchedule],
		[DressCodeClient],
		[DressCodeCoach],
		[PreviousWorkHistoryYN],
		[PreviousWorkHistory],
		[LearningStyle],
		[Issues],
		[CPRReferralFormYN],
		[HealthSafetyRisks],
		[Comments],
		[JobDeveloper],
		[ContactInfo],
		[JobDeveloperPresentYN],
		
		
		[CoachAssigned]
		
FROM	CustomDocumentJobCoachingRequest
WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
AND		([DocumentVersionId] = @DocumentVersionId)  


' 
END
GO
