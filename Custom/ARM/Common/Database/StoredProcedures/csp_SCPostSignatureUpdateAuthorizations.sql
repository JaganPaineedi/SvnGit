
/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateAuthorizations]    Script Date: 09/27/2015 16:18:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCPostSignatureUpdateAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCPostSignatureUpdateAuthorizations]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCPostSignatureUpdateAuthorizations]    Script Date: 09/27/2015 16:18:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
    
CREATE procedure [dbo].[csp_SCPostSignatureUpdateAuthorizations]  
@ScreenKeyId int,                        
@StaffId int,                        
@CurrentUser varchar(30),                        
@CustomParameters xml       
/*********************************************************************              
-- Stored Procedure: dbo.csp_SCPostSignatureUpdateTreatmentPlan    
-- Copyright: Streamline Healthcare Solutions    
--                                                     
-- Purpose: post signature process    
--                                                                                      
-- Modified Date    Modified By    Purpose    
-- 07.15.2011       SFarber        Created.    
-- 09.13.2011       RNoble         Modified to accept AuthorizationDocumentId rather than AuthorizationId  
-- 02.10.2012  RNoble     Modified logic for setting ProviderAuthorizationDocumentID returned from CM.  
-- 02.10.2012  RNoble     Added logic to call csp_SCLinkClientToCMClient for client linking.  
-- 02.10.2012  RNoble     Preventing requested authorizations from being sent due to missing billing code information.  
-- 02.24.2012       SUDHIR SINGH   Add functionality for AssignedPopulation for client form authorization  
-- 03.13.2012       Rakesh Garg    Add Script for Approving an auth creates/updates enrollment KCMHSAS-Other CHanges task 4  
-- 03.27.2012  avoss     added check for authorizationnumber to correct issue in cm  
-- 06.01.2012  dharvey        Modified join to restrict auths created in PCM  
-- 06.18.2012  dharvey        Added Request Status  
-- 06.17.2012       SFarber        Modified to use synonyms 'CM_' istead of directly referencing CM objects  
-- 07.11.2012  Sourabh   Modified to insert FrequencyTypeRequested field in CustomUMStageAthorizations  table wrt#1674 in Kalamazoo Bugs -Go Live  
  
****************************************************************************/               
as            
    
set nocount on    
    
declare @AuthorizationDocumentId int    
declare @ClientId int    
declare @EffectiveDate datetime    
declare @CareManagementClientId int    
declare @InsurerId int    
declare @RequestId uniqueidentifier     
   
---Population tracking  
DECLARE @AssignedPopulation INT   
    
declare @ValidationErrors table (                             
TableName       varchar(200),                                
ColumnName      varchar(200),                                
ErrorMessage    varchar(200),                                
PageIndex       int,    
TabOrder       int,    
ValidationOrder int)    
    
select @AuthorizationDocumentId = @ScreenKeyId    
    
select @ClientId = d.ClientId,    
       @EffectiveDate = d.EffectiveDate,    
       @AuthorizationDocumentId = ad.AuthorizationDocumentId,  
       @AssignedPopulation = ad.AssignedPopulation   
  from AuthorizationDocuments ad    
       join Documents d on d.DocumentId = ad.DocumentId    
 where ad.AuthorizationDocumentId = @AuthorizationDocumentId    
    
-- Try to link the client if it isn't already linked  
--EXEC csp_SCLinkClientToCMClient @ClientId  
  
--      
-- Update Care Management     
--    
  
-- check that a authorization number has been assigned   
-- current bug causing issues in CM when no authorizationNumber has been assigned  
-- avoss 03.27.2012  
  
IF EXISTS ( SELECT  1  
            FROM    Authorizations a  
            WHERE   a.AuthorizationNumber IS NULL  
                    AND a.AuthorizationDocumentId = @AuthorizationDocumentId  
                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'  
                    AND a.ProviderId IS NOT NULL )   
    BEGIN  
   
        UPDATE  a  
        SET     AuthorizationNumber = 'UM-' + CONVERT(VARCHAR(4), DATEPART(YY,  
                                                              GETDATE()), 101)  
                + CASE WHEN DATEPART(MONTH, GETDATE()) < 10  
                       THEN '0' + CONVERT(VARCHAR(2), DATEPART(MONTH,  
                                                              GETDATE()))  
 ELSE CONVERT(VARCHAR(2), DATEPART(MONTH, GETDATE()))  
                  END + CASE WHEN DATEPART(DAY, GETDATE()) < 10  
                             THEN '0' + CONVERT(VARCHAR(2), DATEPART(DAY,  
                                                              GETDATE()))  
                             ELSE CONVERT(VARCHAR(2), DATEPART(DAY, GETDATE()))  
                        END + '-'  
                + CASE WHEN a.TPProcedureId IS NULL  
                       THEN CONVERT(VARCHAR(12), a.AuthorizationId)  
                       ELSE CONVERT(VARCHAR(12), a.TPProcedureId)  
                  END  
        FROM    Authorizations a  
        WHERE   a.AuthorizationNumber IS NULL  
                AND a.AuthorizationDocumentId = @AuthorizationDocumentId  
                AND ISNULL(a.RecordDeleted, 'N') <> 'Y'  
                AND a.ProviderId IS NOT NULL  
   
    END  
  
  
  
    
select @CareManagementClientId = CareManagementId from Clients where ClientId = @ClientId    
select @InsurerId = CareManagementInsurerId from SystemConfigurations    
set @RequestId = newid()    
    
set xact_abort on    
    
-- Populate staging table    
--insert into CM_CustomUMStageAthorizations (    
--       RequestId,    
--       InsurerId,    
--       ProviderId,    
--       SiteId,     
--       ClientId,    
--       BillingCodeId,    
--       Modifier1,    
--       Modifier2,    
--       Modifier3,    
--       Modifier4,    
--       AuthorizationNumber,    
--       AuthorizationId,    
--       AuthorizationDocumentId,    
--       Status,    
--       UnitsRequested,    
--       UnitsApproved,     
--       StartDateRequested,    
--       EndDateRequested,    
--       StartDate,         
--       EndDate,         
--       EffectiveDate,    
--       ProviderAuthorizationId,    
--       ProviderAuthorizationDocumentId,    
--       AuthorizationProviderBillingCodeId,    
--       RequestorComment,    
--       ReviewerComment,    
--       CreatedBy,    
--       CreateDate,    
--       RecordDeleted,  
--       RequestStatus,  
--       FrequencyTypeRequested)    
--select @RequestId,    
--       @InsurerId,    
--       a.ProviderId,    
--       a.SiteId,    
--       @CareManagementClientId,    
--       tppbc.BillingCodeId,    
--       apbc.Modifier1,     
--       apbc.Modifier2,     
--       apbc.Modifier3,     
--       apbc.Modifier4,    
--       a.AuthorizationNumber,    
--       a.AuthorizationId,    
--       a.AuthorizationDocumentId,    
--       a.Status,    
--       a.TotalUnitsRequested,    
--       a.TotalUnits,    
--       a.StartDateRequested,    
--       a.EndDateRequested,    
--       a.StartDate,         
--       a.EndDate,         
--       @EffectiveDate,    
--       a.ProviderAuthorizationId,    
--       ad.ProviderAuthorizationDocumentId,    
--       apbc.AuthorizationProviderBilingCodeId,    
--       ad.RequesterComment,    
--       ad.ReviewerComment,    
--       a.ModifiedBy,    
--       getdate(),    
--       a.RecordDeleted,  
--       NULL ,  
--       FrequencyRequested   
--  from Authorizations a    
--       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId   
--       /* DJH - removed left join to prevent changes on pre-PhaseII auths */  
--       join AuthorizationProviderBilingCodes apbc on apbc.AuthorizationId = a.AuthorizationId and isnull(apbc.RecordDeleted, 'N') = 'N'    
--       left join TPProcedureBillingCodes tppbc on tppbc.TPProcedureBillingCodeId = apbc.TPProcedureBillingCodeId and isnull(tppbc.RecordDeleted, 'N') = 'N'    
-- where ad.AuthorizationDocumentId = @AuthorizationDocumentId    
--   and a.ProviderId is not NULL  
--   AND a.Status <> 4242  
   -- RNoble Feb 10 2012 |  Added filter to prevent processing failure if some "external" authrorizations are being left in a "Requested" status while others are being approved  
   -- As the billingCode detail is being set by UM staff, the details were not available for some auths which caused all processing to fail.  
    
--if @@error <> 0 goto error    
    
---- Send deletes for authorizations that were external, but changed to internal    
--insert into CM_CustomUMStageAthorizations (    
--       RequestId,    
--       InsurerId,    
--       ProviderId,    
--       SiteId,     
--       ClientId,    
--       AuthorizationNumber,    
--       AuthorizationId,    
--       AuthorizationDocumentId,    
--       Status,    
--       UnitsRequested,    
--       UnitsApproved,     
--       StartDateRequested,    
--       EndDateRequested,    
--       StartDate,         
--       EndDate,         
--       EffectiveDate,    
--       ProviderAuthorizationId,    
--       CreatedBy,    
--       CreateDate,    
--       RecordDeleted,  
--       RequestStatus,  
--       FrequencyTypeRequested)    
--select @RequestId,    
--       @InsurerId,    
--       a.ProviderId,    
--       a.SiteId,    
--       @CareManagementClientId,    
--       a.AuthorizationNumber,    
--       a.AuthorizationId,    
--       a.AuthorizationDocumentId,    
--       a.Status,    
--       a.TotalUnitsRequested,    
--       a.TotalUnits,    
--       a.StartDateRequested,    
--       a.EndDateRequested,    
--       a.StartDate,         
--       a.EndDate,         
--       @EffectiveDate,    
--       a.ProviderAuthorizationId,    
--       a.ModifiedBy,    
--       getdate(),    
--       'Y' ,  
--       NULL ,  
--       a.FrequencyRequested  
--  from Authorizations a    
--       join AuthorizationDocuments ad on ad.AuthorizationDocumentId = a.AuthorizationDocumentId    
-- where ad.AuthorizationDocumentId = @AuthorizationDocumentId    
--   and a.ProviderId is null    
--   and a.ProviderAuthorizationId is not null    
    
--if @@error <> 0 goto error    
    
--if not exists(select * from CM_CustomUMStageAthorizations where RequestId = @RequestId)    
--  goto final    
    
-- Get the latest diagnosis document and send it to Care Management       
declare @DiagnosisDocumentVersionId int    
    
select @DiagnosisDocumentVersionId = d.CurrentDocumentVersionId       
  from Documents d     
 where d.ClientId = @ClientId    
   and d.DocumentCodeId = 5    
   and d.Status = 22    
   and isnull(d.RecordDeleted, 'N') = 'N'    
   and not exists (select *    
                     from Documents d2     
                   where d2.ClientId = d.ClientId     
                     and d2.DocumentCodeId = d.DocumentCodeId    
                      and d2.Status = d.Status    
                      and d2.EffectiveDate > d.EffectiveDate    
                      and isnull(d2.RecordDeleted, 'N') = 'N')       
    
--insert into CM_CustomUMStageEventDiagnosesIAndII(    
--       RequestId,    
--       Axis,    
--       DSMCode,    
--       DSMNumber,    
--       DiagnosisType,    
--       RuleOut,    
--       Billable,    
--       Severity,    
--       DSMVersion,    
--       DiagnosisOrder,    
--       Specifier)    
--select @RequestId,    
--       d.Axis,    
--       d.DSMCode,    
--       d.DSMNumber,    
--       d.DiagnosisType,    
--       d.RuleOut,    
--       d.Billable,    
--       d.Severity,    
--       d.DSMVersion,    
--       d.DiagnosisOrder,    
--       d.Specifier    
--  from DiagnosesIAndII d    
-- where d.DocumentVersionId = @DiagnosisDocumentVersionId    
--   and isnull(d.RecordDeleted, 'N') = 'N'    
    
--if @@error <> 0 goto error    
    
--insert into CM_CustomUMStageEventDiagnosesIII(    
--       RequestId,    
--       Specification,    
--       ICDCode,    
--       Billable)    
--select @RequestId,    
--       d.Specification,    
--       dc.ICDCode,    
--       dc.Billable           
--  from DiagnosesIII d    
--       join DiagnosesIIICodes dc on dc.DocumentVersionId = d.DocumentVersionId    
-- where d.DocumentVersionId = @DiagnosisDocumentVersionId    
--   and isnull(d.RecordDeleted, 'N') = 'N'    
--   and isnull(dc.RecordDeleted, 'N') = 'N'    
    
--if @@error <> 0 goto error    
    
--insert into CM_CustomUMStageEventDiagnosesIV(    
--       RequestId,    
--       PrimarySupport,    
--       SocialEnvironment,    
--       Educational,    
--     Occupational,    
--       Housing,    
--       Economic,    
--       HealthcareServices,    
--       Legal,    
--       Other,    
--       Specification)    
--select @RequestId,    
--       d.PrimarySupport,    
--       d.SocialEnvironment,    
--       d.Educational,    
--       d.Occupational,    
--       d.Housing,    
--       d.Economic,    
--       d.HealthcareServices,    
--       d.Legal,    
--       d.Other,    
--       d.Specification    
--  from DiagnosesIV d    
-- where d.DocumentVersionId = @DiagnosisDocumentVersionId    
--   and isnull(d.RecordDeleted, 'N') = 'N'    
    
--if @@error <> 0 goto error    
    
--insert into CM_CustomUMStageEventDiagnosesV(    
--       RequestId,    
--       AxisV)    
--select @RequestId,    
--       d.AxisV           
--  from DiagnosesV d    
-- where d.DocumentVersionId = @DiagnosisDocumentVersionId    
--   and isnull(d.RecordDeleted, 'N') = 'N'    
    
--if @@error <> 0 goto error    
    
--Exec CM_csp_CMUMAuthorizations @RequestId = @RequestId    
    
--if @@error <> 0 goto error    
    
--update a     
--   set ProviderAuthorizationId = case when a.ProviderId is null then null else s.ProviderAuthorizationId end,    
--       UnitsUsed = s.UnitsUsed    
--  from Authorizations a    
--       join CM_CustomUMStageAthorizations s on s.AuthorizationId = a.AuthorizationId    
-- where s.RequestId = @RequestId           
    
--if @@error <> 0 goto error    
    
--update ad     
--   set ProviderAuthorizationDocumentId = s.ProviderAuthorizationDocumentId  
--  from AuthorizationDocuments ad    
--       join CM_CustomUMStageAthorizations s on s.AuthorizationDocumentId = ad.AuthorizationDocumentId    
--       --join Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId    
--       -- RNoble changed above join to exists as this was causing ProviderAuthorizationDocumentId to be set to Null if multiple auths were  
--       -- on one authorization document in which some auths were "external" (providerId not null) and some were not.  
--       WHERE s.RequestId = @RequestId  
--       AND EXISTS(SELECT * FROM Authorizations a  
--     WHERE a.AuthorizationId = s.AuthorizationId  
--     AND a.ProviderId IS NOT NULL  
--     AND ISNULL(a.RecordDeleted,'N') <> 'Y')  
     
--if @@error <> 0 goto error    
    
--update apbc    
--   set ProviderAuthorizationId = s.ProviderAuthorizationId      
--  from AuthorizationProviderBilingCodes apbc    
--       join CM_CustomUMStageAthorizations s on s.AuthorizationProviderBillingCodeId = apbc.AuthorizationProviderBilingCodeId    
-- where s.RequestId = @RequestId         
    
--if @@error <> 0 goto error    
    
--insert into @ValidationErrors (    
--       TableName,    
--       ColumnName,    
--       ErrorMessage)    
--select 'TPGeneral',    
--       'DeletedBy',    
--       ErrorMessage    
--  from CM_CustomUMStageAthorizations           
-- where RequestId = @RequestId    
--   and ErrorMessage is not null    
    
--if @@error <> 0 goto error    
    
--delete from CM_CustomUMStageAthorizations where RequestId = @RequestId    
    
if @@error <> 0 goto error    
  
---Population Tracking by Sudhir Singh  
 IF EXISTS(SELECT 'x' FROM CustomFieldsData WHERE PrimaryKey1 = @ClientId AND DocumentType = 4941)    
 BEGIN  
  update CustomFieldsData set ColumnGlobalCode7 = @AssignedPopulation  
  WHERE PrimaryKey1 = @ClientId AND DocumentType = 4941  
 END   
 ELSE  
 BEGIN  
  INSERT INTO CustomFieldsData(DocumentType,PrimaryKey1,PrimaryKey2,ColumnGlobalCode7)  
  VALUES(4941,@ClientId, 0,@AssignedPopulation)  
 END  
 if @@error <> 0 goto error   
--Population Tracking Changes End here   
  
-- Changes made by Rakesh w.rf to task 4 in KCMHSAS-Other Changes  
--Update EnrolledDate in CLientPrograms  
Update cp set cp.EnrolledDate = a.StartDateRequested  
from ClientPrograms cp join   
CustomExternalServicesSiteMaps ce on cp.ProgramId = ce.ProgramId  
join Authorizations a on a.SiteId = ce.SiteId  
where a.AuthorizationDocumentId = @AuthorizationDocumentId and  
a.ProviderId is not null and a.SiteId is not null  
and Isnull(a.RecordDeleted,'N') = 'N'   
and a.[Status] in (305,4243)   -- 305 Partially Approved , 4243 Approved  
and cp.EnrolledDate > a.StartDateRequested and Isnull(cp.RecordDeleted,'N') = 'N' and cp.[Status] = 4  
  
if @@error <> 0 goto error   
  
-- If recored does exists in CLient Programs Create new Programs for Client  
Insert into ClientPrograms   
(CreatedBy,ModifiedBy,ClientId,ProgramId,[Status],EnrolledDate,PrimaryAssignment)  
select @CurrentUser,@CurrentUser,@ClientId,ce.ProgramId,  
4,a.StartDateRequested,'N' from Authorizations a  
join CustomExternalServicesSiteMaps ce on ce.SiteId = a.SiteId  
 where a.AuthorizationDocumentId = @AuthorizationDocumentId and  
a.ProviderId is not null and a.SiteId is not null  
and Isnull(a.RecordDeleted,'N') = 'N'   
and a.[Status] in (305,4243)   -- 305 Partially Approved , 4243 Approved  
and ce.ProgramId not in   
(select ProgramId from ClientPrograms where ClientId = @ClientId and   
[Status] = 4  and ISNULL(RecordDeleted,'N') = 'N' and      -- Status 4 in Enrolled Status  
ProgramId = ce.ProgramId)  
  
if @@error <> 0 goto error   
  
-- task 4 in KCMHSAS-Other Changes Changes end here  
     
final:    
    
if exists(select * from @ValidationErrors)    
  select * from @ValidationErrors    
    
return    
    
error:    
    
raiserror 50010 'Failed to execute csp_SCPostSignatureUpdateAuthorizations.'    
    
  
GO


