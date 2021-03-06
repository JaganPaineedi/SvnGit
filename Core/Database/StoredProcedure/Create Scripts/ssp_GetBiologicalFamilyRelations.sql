/****** Object:  StoredProcedure [dbo].[ssp_GetBiologicalFamilyRelations]    Script Date: 02/03/2015 01:57:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetBiologicalFamilyRelations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetBiologicalFamilyRelations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
        
  /*********************************************************/                                        
/* Stored Procedure: dbo.ssp_GetBiologicalFamilyRelations        */                                        
/* Creation Date:  03/12/2012          */                                       
/* Purpose: To Bind Foster Placement BiologicalFamily            */                                     
/* Input Parameters: @FosterReferralId      */                                                                    
/*  Date                  Author                 Purpose   */                                        
/* 12/18/2012             MSuma               Created    */   
/* History               */   
/* 01/07/2013     MSuma    Added Client Contacts*/      
/* 10/26/2016     Neelima    Added missing columns into Client Contacts table as per task Pathway - Support Go Live #291*/                                   
/*****************************************************************/                   
CREATE Procedure [dbo].[ssp_GetBiologicalFamilyRelations]    
 @FosterReferralId int     ,  
 @ClientId int                  
AS                      
BEGIN                      
BEGIN TRY          
  ------------------TO Bind End Placements          
            
       
  select   
  
    
    CFR.FosterRelationId,   
    CFR.CreatedBy,   
    CFR.CreatedDate,   
    CFR.ModifiedBy,   
    CFR.ModifiedDate,   
    CFR.RecordDeleted,   
    CFR.DeletedBy,   
  CFR.DeletedDate,   
  CFR.FosterReferralId,  
  CFR.RelationWithChild,  
  GCP.GlobalCodeId as ParentingExpectation,  
  CFR.FirstName,  
  CFR.LastName,  
  CFR.HasTransport,  
  CFR.Removal,  
  CFR.Phone,  
  CFR.Comment,  
  CFR.[Address],  
  CFR.City,  
  CFR.[State],  
  CFR.ZipCode,  
  CFR.AddressDisplay  
--  'FosterRelation' as RelationFrom  
    
FROM    
   FosterRelations CFR  
  LEFT JOIN GlobalCodes GCP On GCP.GlobalCOdeId = CFR.ParentingExpectation   and GCP.Category = 'XParentingTime'    
  LEFT JOIN GlobalCodes GCR On GCR.GlobalCOdeId = CFR.RelationWithChild   
 WHERE      
   CFR.FosterReferralId = @FosterReferralId  
   and ISNULL(CFR.RecordDeleted,'N')='N'  
   and ISNULL(GCP.RecordDeleted,'N')='N'       
   and ISNULL(GCR.RecordDeleted,'N')='N'    
    
  -- and GCR.Category = 'XFosterRelation'     
     
   --Get all the contacts for all the Children in the referral     
--UNION ALL  
    
  SELECT     FosterChildId,  
 CFC.CreatedBy,   
 CFC.CreatedDate,  
  CFC.ModifiedBy,  
   CFC.ModifiedDate,   
   CFC.RecordDeleted,   
   CFC.DeletedBy,   
   CFC.DeletedDate,   
   CFC.FosterReferralId,   
   CFC.FirstName,   
   CFC.MiddleName,   
   CFC.LastName,   
   CFC.ClientId,   
   CFC.ReferralStatus,   
   CFC.SSN,   
   CFC.DOB,   
   CFC.CaseWorker,   
   CFC.Sex,   
   CFC.Race,   
   CFC.Medicaid,   
   CFC.DHS,   
   CFC.CourtCase,   
   CFC.AttorneyFirstName,   
   CFC.AttorneyLastName,   
   CFC.AttorneyPhoneNumber,   
   CFC.SWSSLog,   
   CFC.AggressiveBehaviour,   
   CFC.SexualActingOut,   
   CFC.OtherProblemBehaviour,   
   CFC.SchoolName,   
   CFC.Grade,   
   CFC.SpecialEd,   
   CFC.Previousplacement,   
   CFC.PreviousplacementsWhen,   
   CFC.PreviousplacementsWhere,   
   CFC.JuvenileCourtHx,   
 CFC.JuvenileCourtHxSpecify,   
   CFC.Drug,   
   CFC.DrugsSpecify,   
   CFC.Alcohol,   
   CFC.AlcoholSpecify,   
   CFC.Medication,   
   CFC.MedicationsSpecify,   
   CFC.Allergy,   
   CFC.AllergiesSpecify,   
   CFC.MedicalIssue,   
   CFC.MedicalIssuesSpecify,   
   CFC.Tobacco,   
   CFC.TobaccoSpecify,  
    CFC.MentalHealthIssue,   
    CFC.MentalHealthIssuesSpecify,   
    CFC.IndianChildWelfare,   
   CFC.IndianChildWelfareSpecify,   
   CFC.CurrentVersion,   
   CFC.Email,   
   CFC.DHSFirstName,   
   CFC.DHSLastName  
 FROM          FosterChildren CFC WHERE     
 ISNULL(CFC.RecordDeleted,'N')='N'  and CFC.FosterReferralId = @FosterReferralId  
   
  
-- Select  FosterChildRelations  
   SELECT     CFCR.FosterChildRelationId,   
     CFCR.CreatedBy,   
     CFCR.CreatedDate,   
                 CFCR.ModifiedBy,   
                 CFCR.ModifiedDate,   
                 CFCR.RecordDeleted,   
                 CFCR.DeletedBy,   
                 CFCR.DeletedDate,   
      CFCR.FosterRelationId,   
                 CFCR.FosterChildId,   
                 CFCR.ClientContactId  
  FROM           
    FosterChildRelations CFCR   
   INNER JOIN  FosterRelations CFR ON CFCR.FosterRelationId = CFR.FosterRelationId  
  WHERE       
   (CFR.FosterReferralId = @FosterReferralId)   
    and ISNULL(CFR.RecordDeleted,'N')='N'    
    and ISNULL(CFCR.RecordDeleted,'N')='N'    
      
      
-- Get the client contacts for the foster child   
SELECT Distinct   
  
ClientContactId,   
CreatedBy,   
CreatedDate,   
ModifiedBy,   
ModifiedDate,   
RecordDeleted,   
DeletedBy,   
DeletedDate,   
ListAs,  
ClientId,  
Relationship,  
FirstName,  
LastName,  
MiddleName,  
Prefix,  
Suffix,  
FinanciallyResponsible,  
Organization,  
SSN,  
DOB,  
Guardian,  
EmergencyContact,   
Email,   
 '' as Comment,  
LastNameSoundex,  
FirstNameSoundex,  
Sex,  
HouseholdMember,  
Active 
,MailingName,			--Added by Neelima
CareTeamMember,			--Added by Neelima
ProfessionalSuffix,		--Added by Neelima
AssociatedClientId		--Added by Neelima
  
FROM (  
  
select Distinct  
  CC.ClientContactId,   
  CC.CreatedBy,   
  CC.CreatedDate,   
  CC.ModifiedBy,   
  CC.ModifiedDate,   
  CC.RecordDeleted,   
  CC.DeletedBy,   
  CC.DeletedDate,   
  CC.ListAs,  
  CC.ClientId,  
  CC.Relationship,  
  CC.FirstName,  
  CC.LastName,  
  CC.MiddleName,  
  CC.Prefix,  
  CC.Suffix,  
  CC.FinanciallyResponsible,  
  CC.Organization,  
  CC.SSN,  
  CC.DOB,  
  CC.Guardian,  
  CC.EmergencyContact,   
  CC.Email,   
   '' as Comment,-- CC.Comment,   
  CC.LastNameSoundex,   
  CC.FirstNameSoundex,  
  CC.Sex,  
  CC.HouseholdMember,  
  CC.Active 
  ,CC.MailingName,		--Added by Neelima
  CC.CareTeamMember,	--Added by Neelima
  CC.ProfessionalSuffix,--Added by Neelima
  CC.AssociatedClientId --Added by Neelima
   
      FROM         FosterChildren CFC   
      JOIN        Clients C on C.ClientId = CFC.ClientId  
      LEFT JOIN    FosterChildRelations CFCR  ON CFC.FosterChildId = CFCR.FosterChildId  
      LEFT JOIN    FosterRelations CFR ON CFR.FosterRelationId  = CFCR.FosterRelationId  
      INNER JOIN  ClientContacts CC on CC.Clientid = C.ClientId  
      LEFT JOIN   GlobalCodes GCP On GCP.GlobalCOdeId = CFR.ParentingExpectation    
      LEFT JOIN   dbo.ssf_RecodeValuesCurrent('BIORELATION') as rel on rel.IntegerCodeId = cc.Relationship  
WHERE      
  CFR.FosterReferralId = @FosterReferralId  
  and ISNULL(CFR.RecordDeleted,'N')='N'  
  and ISNULL(GCP.RecordDeleted,'N')='N'       
   
 UNION ALL  
   
 SELECT   
  CC.ClientContactId,   
    CC.CreatedBy,   
    CC.CreatedDate,   
    CC.ModifiedBy,   
    CC.ModifiedDate,   
    CC.RecordDeleted,   
    CC.DeletedBy,   
  CC.DeletedDate,   
  CC.ListAs,  
  CC.ClientId,  
  CC.Relationship,  
  CC.FirstName,  
  CC.LastName,  
  CC.MiddleName,  
  CC.Prefix,  
  CC.Suffix,  
  CC.FinanciallyResponsible,  
  CC.Organization,  
  CC.SSN,  
  CC.DOB,  
  CC.Guardian,  
  CC.EmergencyContact,   
  CC.Email,   
  CC.Comment,   
  CC.LastNameSoundex,   
  CC.FirstNameSoundex,  
   --'NewClientContact' as RelationFrom  
   CC.Sex,  
   CC.HouseholdMember,  
   CC.Active 
   ,CC.MailingName,			--Added by Neelima
  CC.CareTeamMember,		--Added by Neelima	
  CC.ProfessionalSuffix,	--Added by Neelima
  CC.AssociatedClientId		--Added by Neelima
   
FROM        Clients C  
JOIN        ClientContacts CC on CC.Clientid = C.ClientId  
AND               C.ClientId =@ClientId  
INNER JOIN        dbo.ssf_RecodeValuesCurrent('BIORELATION') as rel on rel.IntegerCodeId = cc.Relationship  
   
WHERE       ISNULL(C.RecordDeleted,'N')='N'   
AND               ISNULL(CC.RecordDeleted,'N')='N'  
) A  
  
   
   
   
  SELECT       
        CFC.FosterChildId,  
        CFC.FirstName+', ' +CFC.LastName as 'ChildName',  
        FLOOR((CAST (GetDate() AS INTEGER) - CAST(CFC.DOB AS INTEGER)) / 365.25) AS AGE,  
        GC.COdeName as Gender,  
        CPF.FamilyName,  
        CFP.Comment,  
        CFC.ClientID  
  FROM       
    Fosterchildren CFC  
   LEFT JOIN  FosterPlacements CFP ON CFC.FosterChildId  = CFP.FosterChildId  
   LEFT JOIN  PlacementFamilies CPF ON CPF.PlacementFamilyId = CFP.PlacementFamilyId  
   LEFT JOIN GlobalCodes GC on GC.GlobalCodeId =  CFC.Sex  
  WHERE      
   CFC.FosterReferralId = @FosterReferralId  
   and ISNULL(CFC.RecordDeleted,'N')='N'       
   and ISNULL(CFP.RecordDeleted,'N')='N'    
   and ISNULL(CPF.RecordDeleted,'N')='N'    
   and ISNULL(GC.RecordDeleted,'N')='N'    
   AND CFP.PlacementEnd IS NULL     
   
--Client Contact Address for the Client ID    
 SELECT   
  CCA.ContactAddressId,  
  CCA.ClientContactId,  
  CCA.AddressType,  
  CCA.Address,  
  CCA.City,  
  CCA.State,  
  CCA.Zip,  
  CCA.Display,  
  CCA.Mailing,  
  CCA.RowIdentifier,  
  CCA.ExternalReferenceId,  
  CCA.CreatedBy,  
  CCA.CreatedDate,  
  CCA.ModifiedBy,  
  CCA.ModifiedDate,  
  CCA.RecordDeleted,  
  CCA.DeletedDate,  
  CCA.DeletedBy,       
  CCA.AddressType,  
  CCA.Address,  
  CCA.City,  
  CCA.State,  
  CCA.Zip,  
  CCA.Display,  
  CCA.CreatedBy,  
  CCA.CreatedDate,  
  CCA.ModifiedBy,  
  CCA.ModifiedDate,  
  CCA.RecordDeleted,  
  CCA.DeletedDate,  
  CCA.DeletedBy,CC.ClientId,  
     CC.Relationship  
  
 FROM        ClientContactAddresses CCA  
 JOIN        ClientContacts CC on CCA.ClientContactId = CC.ClientContactId  
 AND               CC.ClientId = @ClientId  
 AND      CCA.AddressType = 90  
 INNER JOIN        dbo.ssf_RecodeValuesCurrent('BIORELATION') as REL on REL.IntegerCodeId = CC.Relationship    
   
   
  END TRY                                    
 BEGIN CATCH                                  
   RAISERROR  20006  'ssp_GetBiologicalFamilyRelations: An Error Occured'                                         
   Return                                      
 END CATCH        
 END  
   
  
  GO
