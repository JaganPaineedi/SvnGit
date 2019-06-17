/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices]    Script Date: 06/07/2013 14:56:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices]
GO

USE [ARMSmartcareTest]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices]    Script Date: 06/07/2013 14:56:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices]  
 @DocumentVersionId int,  
 @TabOrder int = 1  
/******************************************************************************                                        
**  File: csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices                                    
**  Name: csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices                
**  Desc: For Validation  on Referrals from diagnosistic assessment document  
**  Return values: Resultset having validation messages                                        
**  Called by: csp_ValidateCustomDocumentDiagnosticAssessments                                        
**  Parameters:                    
**  Auth:  T. Remisoski                      
**  Date:  February 9, 2011                                    
*******************************************************************************                                        
**  Change History                                        
*******************************************************************************                                        
**  Date:       Author:       Description:                                        
**  --------    --------        ----------------------------------------------------                                        
** 2012.02.09 TER    Revised based on Harbor's rules  
** 2012.06.13 AMIT KUMAR SRIVASTAVA Referral Service modified to Recommended Svcs, #1774, Diagnostic Assessment:Validation tabs are not matching,  PM Web Bugs  
*******************************************************************************/                                      
as  
  
declare @referralTransferServices table (  
 AuthorizationCodeId int  
)  
insert into @referralTransferServices values  
(1),  
(2),  
(3),  
(4),  
(5),  
(6),  
(7),  
(8),  
(9),  
(10),  
(11),  
(12),  
(13),  
(14),  
(15),  
(16),  
(17),  
(18)  
  
declare @txPlanReferralTransferServices table (  
 AuthorizationCodeId int  
)  
insert into @txPlanReferralTransferServices   
        (AuthorizationCodeId)  
values  
(1),  
(2),  
(9),  
(12),  
(13)  
  
declare @referralTxCodes table (  
 ReferralCodeId int,  
 TxPlanId int  
)  
  
insert into @referralTxCodes  
        (ReferralCodeId, TxPlanId)  
values    
(1,1),  
(2,2),  
(3,1),  
(4,1),  
(5,2),  
(6,2),  
(7,2),  
(8,2),  
(9,9),  
(12,12),  
(13,13)  
  
Insert into #validationReturnTable (  
 TableName,    
 ColumnName,    
 ErrorMessage,    
 TabOrder,    
 ValidationOrder    
)  
select 'CustomDocumentAssessmentReferrals', 'DeletedBy', 'Recommended Svcs: Client participation required for all services.', @TabOrder, 1  
where exists (  
 select *  
 from dbo.CustomDocumentAssessmentReferrals as ar  
 where ar.DocumentVersionId = @DocumentVersionId  
 and ISNULL(ar.ClientParticipatedReferral, 'N') <> 'Y'  
 and ISNULL(ar.RecordDeleted, 'N') <> 'Y'  
)  
  
declare @AutoApproveReferralAuthorizationCodes table (  
 AuthorizationCodeId int  
)  
insert into @AutoApproveReferralAuthorizationCodes  
        (AuthorizationCodeId) -- from AuthorizationCodes table  
values   
 (10), -- Developmental Pediatric Consultation  
 (11), -- Integrated Primary Care  
 (13), -- Pharmacologic Management  
 (14), -- Psychiatric Evaluation  
 (15) -- Psychological Testing  
  
declare @ClientId int  
declare @mostRecentTxPlan int  
  
select @ClientId = clientid   
from dbo.Documents as d  
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId  
where dv.DocumentVersionId = @DocumentVersionId  
  
select @mostRecentTxPlan = @DocumentVersionId  
  
-- if treatment plan does not yet exist, return  
--if @mostRecentTxPlan is null return  
  
-- do not validate tx plan if this is an update  
if not exists (select * from dbo.CustomDocumentDiagnosticAssessments as cd where cd.DocumentVersionId = @DocumentVersionId and cd.InitialOrUpdate = 'U')  
begin  
 Insert into #validationReturnTable (  
  TableName,    
  ColumnName,    
  ErrorMessage,    
  TabOrder,    
  ValidationOrder    
 )  
 select 'CustomDocumentAssessmentReferrals' as TableName, 'DeletedBy' as ColumnName, LEFT('Service not on tx plan: ' + ac.DisplayAs, 100), @TabOrder, 2  
 from dbo.CustomDocumentAssessmentReferrals as rs  
 join dbo.AuthorizationCodes as ac on ac.AuthorizationCodeId = rs.ServiceRecommended  
 where rs.DocumentVersionId = @DocumentVersionId  
 and ISNULL(rs.RecordDeleted, 'N') <> 'Y'  
 and not exists (  
  select *  
  from dbo.CustomTPServices as tps  
  join dbo.CustomTPGoals as tpg on tpg.TPGoalId = tps.TPGoalId  
  join @referralTxCodes as r on r.TxPlanId = tps.AuthorizationCodeId  
  where tpg.DocumentVersionId = @mostRecentTxPlan  
  and ISNULL(tps.RecordDeleted, 'N') <> 'Y'  
  and ISNULL(tpg.RecordDeleted, 'N') <> 'Y'  
  and r.ReferralCodeId = rs.ServiceRecommended  
 )  
 -- and it needs to be validated  
 and exists (  
  select *  
  from @referralTxCodes as r  
  where r.ReferralCodeId = rs.ServiceRecommended  
 )  
end  
  
GO


