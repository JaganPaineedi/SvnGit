/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentEnrollment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentEnrollment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentEnrollment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentEnrollment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_SCGetCustomDocumentEnrollment]
	@DocumentVersionId int
AS

SELECT	[DocumentVersionId],   
        [CreatedBy],            
        [CreatedDate],         
        [ModifiedBy],           
        [ModifiedDate],         
        [RecordDeleted],        
        [DeletedDate],         
        [DeletedBy],
        
        [LastName],
        [FirstName],
        [MiddleName],
        [Type],
        [DOB],
        [Sex],
        [RegistrationID],
        
		[Address],
		[Address2],
		[City],
		[State],
		[Zip],
		
		[HomePhoneNumber],
		[BusinessPhoneNumber],
		
		[Race],
		[Ethnic],
		[MaritalStatus],
		
		[MedicareNumber],
		[MedicaidNumber],
		
		[AnnualHouseholdIncome],
		[NumberOfDependents],
		[SSN],
		[CountyOfResidence],
		
		[ClinicianSignature],
		[Agency],
		[Date],
		
		[SuggestedPlanCode],
		[DXAssessmentDate],
		
		[Group],
		[Plan],
		[Riders],
		[Panel],
		
		[UCI],
		
		[EffectiveDate],
		[TerminationDate],
		
		[PrimaryDX],
		[PrimaryAxis],
		[Primary508],
		[SecondaryDX],
		[SecondaryAxis],
		[Secondary508],
		
		[AxisV70OrBelow],

		[HistoryMentalIllness],
		[SymptomsRequireService],
		[GAFPrognosis],
		[GAFHistory],
		[LacksExternalSupports]

FROM	CustomDocumentEnrollment
WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
AND	([DocumentVersionId] = @DocumentVersionId)  

' 
END
GO
