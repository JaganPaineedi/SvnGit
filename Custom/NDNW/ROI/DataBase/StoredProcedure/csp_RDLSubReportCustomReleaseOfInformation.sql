IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomReleaseOfInformation]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_RDLSubReportCustomReleaseOfInformation] 
  END 

GO 

/********************************************************************************                                                    
-- Stored Procedure: csp_RDLSubReportCustomReleaseOfInformation   159
--      
-- Copyright: Streamline Healthcare Solutions      
--      
-- Purpose: For report  RDLCustomReleaseOfInformation.      
--      
-- Author:  Atul Pandey
-- Date:    22/Jan/2013 
   
Modified Date            Name             Description
22/Jan/2013          Atul Pandey          Created
07/May/2013          Bernardin            Selecting top 1 to avoid duplication of records
*********************************************************************************/ 
CREATE PROCEDURE [dbo].[csp_RDLSubReportCustomReleaseOfInformation] --1
(
@ReleaseOfInformationId INT
) 
AS 
  BEGIN Try 
         DECLARE       
             @Address varchar(500)      
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
    
  SELECT top 1	 ReleaseOfInformationId
			,CDR.DocumentVersionId
			,OldDocumentVersionID
			,ReleaseOfInformationOrder
			,GetInformationFrom
			,ReleaseInformationFrom
			,ReleaseToReceiveFrom
			,ReleaseEndDate
			,ReleaseContactType
			,ReleaseAddress
			,ReleaseCity
			,ReleasedState
			,ReleasePhoneNumber
			,ReleasedZip
			,AssessmentEvaluation
			,PersonPlan
			,ProgressNote
			,PsychologicalTesting
			,PsychiatricTreatment
			,TreatmentServiceRecommendation
			,EducationalDevelopmental
			,DischargeTransferRecommendation
			,InformationBenefitInsurance
			,WorkRelatedInformation
			,ReleasedInfoOther
			,ReleasedInfoOtherComment
			,TransmissionModesWritten
			,TransmissionModesVerbal
			,TransmissionModesElectronic
			,TransmissionModesAudio
			,TransmissionModesPhoto
			,TransmissionModesReleaseInOther
			,TransmissionModesReleaseInOtherComment
			,TransmissionModesToProvideCaseCoordination
			,TransmissionModesToDetermineEligibleService
			,TransmissionModesAtRequestIndividual
			,TransmissionModesInOther
			,TransmissionModesOtherComment
			,AlcoholDrugAbuse
			,AIDSRelatedComplex
			,CONVERT(VARCHAR(10),D.EffectiveDate,101) as EffectiveDate
		    ,(SELECT TOP 1 AgencyName FROM Agency) AS AgencyName  
            ,ISNULL(@Address,'')+','+ISNULL(@MainPhone,'')+','+ISNULL(@FaxNumber,'')  AS AgencyAddressPhoneFax  
            ,ISNULL( C.LastName,'') +', '+ISNULL( C.FirstName,'') As ClientName  
	        ,CONVERT(VARCHAR(10),C.DOB,101) AS DOB  		
	        ,c.ClientId
	        ,Case When ReleaseContactType='C' then ISNULL( CO.LastName,'') +', '+ISNULL( CO.FirstName,'') else ReleaseName end As ClientOrganizationContactName
	        ,case when ReleaseContactType='C' then  cca.Address else ReleaseAddress end as ClientOrganizationContactAddress
	        ,case when ReleaseContactType='C' then cca.City else ReleaseCity end as ClientOrganizationContactCity
	        ,case when ReleaseContactType='C' then St1.StateName else st.StateName end as ClientOrganizationContactState
	        ,case when ReleaseContactType='C' then cca.Zip else ReleasedZip end as ClientOrganizationContactZip
	        ,case when ReleaseContactType='C' then ccp.PhoneNumber else ReleasePhoneNumber end as ClientOrganizationContactPhoneNumber
  FROM CustomDocumentReleaseOfInformations CDR		
  inner join DocumentVersions DV on dv.DocumentVersionId=CDR.DocumentVersionId   
  inner join Documents D on D.DocumentId=Dv.DocumentId   
  inner join Clients C on D.ClientId=C.ClientId  
  left  join ClientContacts CO on CDR.ReleaseToReceiveFrom=CO.ClientContactId	
  left join ClientcontactAddresses cca on 	CO.ClientContactId	=cca.ClientContactId and cca.AddressType=90
  left join ClientContactPhones ccp on ccp.ClientContactId	=cca.ClientContactId
  left join [States] st on CDR.ReleasedState=st.StateAbbreviation
  left join [States] St1 on cca.State=St1.StateAbbreviation
	WHERE	CDR.ReleaseOfInformationId=@ReleaseOfInformationId	
	AND ISNULL(CDR.RecordDeleted,'N')='N'
	AND ISNULL(DV.RecordDeleted,'N')='N'
	AND ISNULL(D.RecordDeleted,'N')='N'
	AND ISNULL(C.RecordDeleted,'N')='N'
	AND ISNULL(CO.RecordDeleted,'N')='N'
	AND ISNULL(CCA.RecordDeleted,'N')='N'
	AND ISNULL(CCP.RecordDeleted,'N')='N'

  
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + 
                              CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
                  + 
                              isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                              'csp_RDLSubReportCustomReleaseOfInformation') + 
                              '*****' + CONVERT(VARCHAR, ERROR_LINE()) + 
                  '*****ERROR_SEVERITY=' + 
                              CONVERT(VARCHAR, ERROR_SEVERITY()) + 
                  '*****ERROR_STATE=' 
                  + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR (@Error /* Message text*/,16 /*Severity*/,1/*State*/ ) 
  END CATCH 