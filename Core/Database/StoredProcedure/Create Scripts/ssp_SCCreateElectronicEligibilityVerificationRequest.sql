IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCreateElectronicEligibilityVerificationRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCreateElectronicEligibilityVerificationRequest]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCCreateElectronicEligibilityVerificationRequest]
    @BatchId AS INT ,
    @ElectronicPayerId AS VARCHAR(25) ,
    @SubscriberInsuredId AS VARCHAR(25) ,
    @SubscriberFirstName AS type_FirstName ,
    @SubscriberLastName AS type_LastName ,
    @SubscriberSSN AS type_SSN ,
    @SubscriberDOB AS DATETIME ,
    @SubscriberSex AS type_Sex ,
    @DependentRelationshipCode AS [dbo].[type_GlobalCode] ,
    @DependentFirstName AS type_FirstName ,
    @DependentLastName AS type_LastName ,
    @DependentDOB AS DATETIME ,
    @DependentSex AS type_Sex ,
    @DateOfServiceStart AS DATE ,
    @DateOfServiceEnd AS DATE ,
	@ElectronicEligibilityVerificationPayerId AS INT = NULL,
	@UserCode AS VARCHAR(30) = NULL,
	@ClientId AS INT =NULL
AS 
-- =============================================
-- Author:		Suhail Ali
-- Create date: 1/3/2012
-- Description:	Store 270 eligibility verification request data and return with an Id to the request record
-- 2/20/2014		NJain		Modified to Set Quoted Identifier ON
-- 01/08/2019		PradeepA	What:Modified to add RecordDeleted Check in ElectronicEligibilityVerificationPayers to ignore deleted Payers.
--								Why: AHN-Support Go Live: #396.1
-- 03/12/2019		Vijay		What:"Electronic Payer" Dropdown is loading with ElectronicPayerId as a value but we are storing duplicate values in this ElectronicEligibilityVerificationPayers table - ElectronicPayerId column. 
--								So we changed the code to get ElectronicEligibilityVerificationPayerId(PrimaryKey) as a dropdown value and ElectronicPayerId as a attribute.
--								Why: Bradford - Support Go Live - #742
-- 03/14/2019		PradeepA	What: Added @UserCode and @ClientId parameter to log the UserCode who request the Eligibility Request and ClientId who make this eligibility request against. 
--								Why: Renaissance - Current Project Tasks #22
-- =============================================
    BEGIN
        SET NOCOUNT ON ;

		IF ISNULL(@ElectronicEligibilityVerificationPayerId, 0) = 0
		BEGIN
			SELECT TOP 1 @ElectronicEligibilityVerificationPayerId = ElectronicEligibilityVerificationPayerId 
			FROM dbo.ElectronicEligibilityVerificationPayers WHERE ElectronicPayerId = @ElectronicPayerId 
			AND ISNULL(RecordDeleted,'N') = 'N'
		END
        INSERT  INTO [dbo].[ElectronicEligibilityVerificationRequests]
                ( [SubscriberInsuredId] ,
                  [SubscriberFirstName] ,
                  [SubscriberLastName] ,
                  [SubscriberSSN] ,
                  [SubscriberDOB] ,
                  [SubscriberSex] ,
                  [DependentRelationshipCode] ,
                  [DependentFirstName] ,
                  [DependentLastName] ,
                  [DependentDOB] ,
                  [DependentSex] ,
                  [DateOfServiceStart] ,
                  [DateOfServiceEnd] ,
                  [ElectronicEligibilityVerificationBatchId] ,
                  [ElectronicEligibilityVerificationPayerId],
				  [UserCode],
				  [ClientId]
                )
        VALUES  ( @SubscriberInsuredId ,
                  @SubscriberFirstName ,
                  @SubscriberLastName ,
                  @SubscriberSSN ,
                  @SubscriberDOB ,
                  @SubscriberSex ,
                  @DependentRelationshipCode ,
                  @DependentFirstName ,
                  @DependentLastName ,
                  @DependentDOB ,
                  @DependentSex ,
                  @DateOfServiceStart ,
                  @DateOfServiceEnd ,
                  @BatchId ,
                  @ElectronicEligibilityVerificationPayerId,
				  @UserCode,
				  @ClientId
                )
        SELECT  SCOPE_IDENTITY()
        
        RETURN SCOPE_IDENTITY()
    END

GO


