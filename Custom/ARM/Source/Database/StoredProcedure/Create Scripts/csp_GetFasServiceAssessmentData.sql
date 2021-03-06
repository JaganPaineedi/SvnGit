/****** Object:  StoredProcedure [dbo].[csp_GetFasServiceAssessmentData]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetFasServiceAssessmentData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetFasServiceAssessmentData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetFasServiceAssessmentData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================  
-- Author:  Mahesh   
-- Create date: 11 October 2010  
-- Description: To Select the Records received from FasServices in the Desired Format.  
-- Form Called: SHS.DataServices.HRMAssessment.cs  
-- =============================================  
CREATE PROCEDURE [dbo].[csp_GetFasServiceAssessmentData] --218,''JSCOBY'',''10/13/2010 6:13:09 PM'',''10/19/2010 9:26:00 AM''  
 @FasRequestID int,  
 @CreatedBy Varchar(30),  
 @CreatedDate datetime,  
 @ModifiedDate datetime  
AS  
BEGIN  
Declare @DocumentVersionID int  
--Declare @CafasInterval int  
----Declare @IsProcessed bit  
--set @CafasInterval=0  
  
if (exists(Select CAFASAssessmentId from CustomFASCAFASAssessments where FASRequestId=@FasRequestID))  
Begin  
--set @IsProcessed=1  
Select   
  
DocumentVersionID as DocumentVersionId,  
--Null as CafasDate,  
convert(int,isnull(EmployeeId,0)) as RaterClinician,  
--@CafasInterval AS CAFASInterval,  
convert(int,isnull(YouthSchoolScore,0)) as SchoolPerformance,  
YouthSchoolExplanation as SchoolPerformanceComment,  
convert(int,isnull(YouthHomeScore,0)) as HomePerformance,  
YouthHomeExplanation as HomePerfomanceComment,  
convert(int,isnull(YouthCommunityScore,0)) as CommunityPerformance,  
YouthCommunityExplanation as CommunityPerformanceComment,  
convert(int,isnull(YouthBehaviorScore,0)) as BehaviorTowardsOther,  
YouthBehaviorExplanation as BehaviorTowardsOtherComment,  
convert(int,isnull(YouthMoodsScore,0)) as MoodsEmotion,  
YouthMoodsExplanation as MoodsEmotionComment,  
convert(int,isnull(YouthSelfHarmScore,0)) as SelfHarmfulBehavior,  
YouthSelfHarmExplanation as SelfHarmfulBehaviorComment,  
convert(int,isnull(YouthSubUseScore,0)) as SubstanceUse,  
YouthSubUseExplanation as SubstanceUseComment,  
convert(int,isnull(YouthThinkingScore,0)) as Thinkng,  
YouthThinkingExplanation as ThinkngComment,  
convert(int,isnull(TotalScore,0)) as YouthTotalScore,  
convert(int,isnull(CaregiverPrimaryMaterialScore,0)) as PrimaryFamilyMaterialNeeds,  
CaregiverPrimaryMaterialExplanation as PrimaryFamilyMaterialNeedsComment,  
convert(int,isnull(CaregiverPrimarySocialScore,0)) as PrimaryFamilySocialSupport,  
CaregiverPrimarySocialExplanation as PrimaryFamilySocialSupportComment,  
convert(int,isnull(CaregiverNonCustodialMaterialScore,0)) as NonCustodialMaterialNeeds,  
CaregiverNonCustodialMaterialExplanation as NonCustodialMaterialNeedsComment,  
convert(int,isnull(CaregiverNonCustodialSocialScore,0)) as NonCustodialSocialSupport,  
CaregiverNonCustodialSocialExplanation as NonCustodialSocialSupportComment,  
convert(int,isnull(CaregiverSurrogateMaterialScore,0)) as SurrogateMaterialNeeds,  
CaregiverSurrogateMaterialExplanation as SurrogateMaterialNeedsComment,  
convert(int,isnull(CaregiverSurrogateSocialScore,0)) as SurrogateSocialSupport,  
CaregiverSurrogateSocialExplanation as SurrogateSocialSupportComment,  
@CreatedDate as CreatedDate,  
@CreatedBy as CreatedBy,  
@ModifiedDate as ModifiedDate,  
@CreatedBy as ModifiedBy  
--@IsProcessed as IsProcessed  
  
  
from CustomFASCAFASAssessments where FASRequestId=@FasRequestID  
End  
Else  
Begin  

--Added By Mahesh on 6 Dec 2010

declare @idoc int
declare @PreviousRequestXML varchar(max)
declare @ErrorCode varchar(50)
declare @ErrorMessage varchar(500)
declare @ISError bit

select @PreviousRequestXML= convert(varchar(max),ResponseXML) from CustomFASRequestLog where FasRequestID=@FasRequestID
exec sp_xml_preparedocument @idoc output, @PreviousRequestXML

select @ISError = ErrorReceived
from openxml(@idoc, ''response'', 2)
with (ErrorReceived  bit  ''@error'')


if(@ISError=1)
Begin

select @ErrorCode = ErrorCode
from openxml(@idoc, ''response/error'',2)
with (ErrorCode  varchar(50)  ''@code'')

if(@ErrorCode=999 or @ErrorCode=-1)
set @ErrorMessage=''Error: External web service error logged to CustomFASRequestLog. Please contact a system administrator''
else
Begin
select @ErrorMessage=ErrorCode
from openxml(@idoc, ''response/error'',2)
with (ErrorCode  varchar(50)  ''@msg'')
set @ErrorMessage=''Error:''+@ErrorMessage
--select @ErrorMessage as ErrorMessage,@ErrorCode as ErrorCode
End

exec sp_xml_preparedocument @idoc output, @PreviousRequestXML

End


if(@ErrorMessage is  null)
set @ErrorMessage=''Unable to find CAFAS for the current client, please goto online CAFAS''

select @ErrorMessage as MessageText

End  
  
  
END  ' 
END
GO
