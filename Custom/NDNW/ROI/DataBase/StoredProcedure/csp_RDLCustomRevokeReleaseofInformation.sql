IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomRevokeReleaseofInformation]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_RDLCustomRevokeReleaseofInformation] 
  END 

GO 

/********************************************************************************                                                    
-- Stored Procedure: csp_RDLCustomRevokeReleaseofInformation  343314    
--      
-- Copyright: Streamline Healthcare Solutions      
--      
-- Purpose: RDL for Custom RDLRevokeReleaseofInformation.      
--      
-- Author:  Atul Pandey
-- Date:    18/Jan/2013 
   
Modified Date            Name             Description
18/Jan/2013          Atul Pandey          Created
/* 15 Feb 2019 K.Soujanya   Added ClientUnableToGiveWrittenConsent and RevokeROSComments in select statement as per the requirement, Why:New Directions - Enhancements,#22   */ 
*********************************************************************************/ 
CREATE PROCEDURE [dbo].[csp_RDLCustomRevokeReleaseofInformation] 
(
@DocumentVersionId INT
) 
AS 
  BEGIN Try 
   DECLARE       
             @Address varchar(250)      
            ,@MainPhone Varchar(50)      
            ,@FaxNumber Varchar(50)      
    Select top 1 @Address=AddressDisplay,@MainPhone=MainPhone,@FaxNumber=FaxNumber from Agency    
       
  --  DECLARE @AddressString varchar(max)         
  --  SET @AddressString=''      
  --   IF @Address IS NOT NULL AND @Address <> ''      
  --   BEGIN      
  --  SET @AddressString +='('+@Address +')'   
  --END      
    
  --IF @MainPhone IS NOT NULL AND @MainPhone <> ''      
  --   BEGIN      
  --  SET @AddressString +='('+@MainPhone +')'      
  --END    
  
  --IF @FaxNumber IS NOT NULL AND @FaxNumber <> ''      
  --   BEGIN      
  --  SET @AddressString +='('+@FaxNumber +')'      
  --END        
   SELECT 
        
         
          (SELECT TOP 1 AgencyName FROM Agency) AS AgencyName
          ,ISNULL(@Address,'')+','+ISNULL(@MainPhone,'')+','+ISNULL(@FaxNumber,'')   AS AgencyAddressPhoneFax
          ,C.ClientId 
          ,ISNULL( C.LastName,'') +', '+ISNULL( C.FirstName,'') As ClientName
          ,CONVERT(VARCHAR(10),D.EffectiveDate,101) as EffectiveDate
          ,CONVERT(VARCHAR(10),C.DOB,101) AS DOB  
          ,CASE when (CIR.ReleaseToId is null) then 'O'
				else ('C')
				end										As ContactType
          ,CIR.ReleaseToName as OrganizationName
          ,ISNULL( CC.LastName,'') +', '+ISNULL( CC.FirstName,'') ClientContactName
          ,LTRIM(RTRIM(SUBSTRING(cir.Comment, 0, CHARINDEX('|', cir.Comment))))  as OrganizationAddress 
          ,LTRIM(RTRIM(SUBSTRING(cir.Comment, CHARINDEX('|', cir.Comment)+1, 8000))) as  OrganizationPhoneNumber
          ,CCA.Display As ClientContactAddress
          ,Case when LTRIM(RTRIM(SUBSTRING(cir.Comment, 0, CHARINDEX('|', cir.Comment)))) is not null or cca.Display is not null then 'Y' else 'N' end IsClientContactAddressExists
          ,CCP.PhoneNumber As  ClientContactPhoneNumber
          ,Case when LTRIM(RTRIM(SUBSTRING(cir.Comment, CHARINDEX('|', cir.Comment)+1, 8000))) is not null  or CCP.PhoneNumber is not null then 'Y' else 'N' end IsPhoneNumberExists 
          ,CONVERT(DATE,CIR.StartDate,101) AS StartDate
          ,CONVERT(DATE,CIR.EndDate,101) AS EndDate
          ,RROI.[DocumentVersionId]
		  ,RROI.[CreatedBy]
		  ,RROI.[CreatedDate]
		  ,RROI.[ModifiedBy]
		  ,RROI.[ModifiedDate]
		  ,RROI.[RecordDeleted]
		  ,RROI.[DeletedDate]
		  ,RROI.[DeletedBy]
		  ,RROI.[ClientInformationReleaseId]
		  ,RROI.[StaffId]
		  ,RROI.[RevokeEndDate]
		  ,CONVERT(DATE,getdate(),101) AS RevokeDate
		  ,RROI.[ClientUnableToGiveWrittenConsent]
		  ,RROI.[RevokeROSComments]
  FROM [dbo].[CustomDocumentRevokeReleaseOfInformations] RROI
  inner join ClientInformationReleases CIR on RROI.ClientInformationReleaseId=CIR.ClientInformationReleaseId
  left  join ClientContacts CC on CIR.ReleaseToId=CC.ClientContactId  --AS  ReleaseToId stores the ClientContactId for Documents which are released to any entity or organization.
  inner join DocumentVersions DV on dv.DocumentVersionId=RROI.DocumentVersionId 
  inner join Documents D on D.DocumentId=Dv.DocumentId 
  inner join Clients C on D.ClientId=C.ClientId
  left join ClientContactAddresses CCA on CCA.ClientContactId=CC.ClientContactId 
  left join ClientContactPhones CCP on CCP.ClientContactId=CC.ClientContactId
  Where RROI.[DocumentVersionId]=@DocumentVersionId
  and ISNULL( RROI.RecordDeleted,'N')='N'
  and ISNULL( CIR.RecordDeleted,'N')='N'
  and ISNULL( CC.RecordDeleted,'N')='N'
  and ISNULL( DV.RecordDeleted,'N')='N'
  and ISNULL( D.RecordDeleted,'N')='N'
  and ISNULL( C.RecordDeleted,'N')='N'
  and ISNULL( CCA.RecordDeleted,'N')='N'
  and ISNULL( CCP.RecordDeleted,'N')='N'
 
 /* and CIR.ReleaseToId is not null  */   /*Releasetoold is null when no contact is selected from  'Releaseto' dropdown in tab 'Release of Information Log' 
                                        ,the release to name is typed into the dropdown */

  
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + 
                              CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
                  + 
                              isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                              'csp_RDLCustomRevokeReleaseofInformation') + 
                              '*****' + CONVERT(VARCHAR, ERROR_LINE()) + 
                  '*****ERROR_SEVERITY=' + 
                              CONVERT(VARCHAR, ERROR_SEVERITY()) + 
                  '*****ERROR_STATE=' 
                  + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR (@Error /* Message text*/,16 /*Severity*/,1/*State*/ ) 
  END CATCH 