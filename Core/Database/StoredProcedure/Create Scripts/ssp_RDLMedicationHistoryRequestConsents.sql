/****** Object:  StoredProcedure [dbo].[ssp_RDLMedicationHistoryRequestConsents]    Script Date: 11/06/2015 11:49:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMedicationHistoryRequestConsents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLMedicationHistoryRequestConsents]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLMedicationHistoryRequestConsents]    Script Date: 11/06/2015 11:49:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE   [dbo].[ssp_RDLMedicationHistoryRequestConsents]           
(                           
@DocumentVersionId  int 
)                      
AS                      
                
Begin                
/************************************************************************/                                                      
/* Stored Procedure: [ssp_RDLMedicationHistoryRequestConsents]			*/ 
 /*   Updates:                                                        */                                               
 /*       Date              Author                  Purpose           */                            
 /*       07/02/2012        Wasif Butt              To Retrieve Data for RDL  */    
 /*       11/Nov/2015        Vithobha				Added Alias SystemConfig.OrganizationName*/                                  /*        22-DEC-2015      Basudev Sahu			Modified For Task #609 Network180 Customization to Get Organisation  As																ClientName*/  
/************************************************************************/                        

select top 1 d.DocumentId,dv.DocumentVersionID, SystemConfig.OrganizationName, 
CASE       
      WHEN ISNULL(C.ClientType, 'I') = 'I'  
       THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  
      ELSE ISNULL(C.OrganizationName, '')  
      END AS ClientName,  
--c.LastName + ', ' + c.FirstName as ClientName,
C.ClientId, 
convert(varchar(10), c.DOB, 101) as DOB, convert(varchar(10), d.EffectiveDate, 101) as EffectiveDate, s.LastName + ', ' + s.FirstName as ClinicianName, 
convert(varchar(10), mhrc.StartDate, 101) as StartDate, convert(varchar(10), mhrc.EndDate, 101) as EndDate 
, SignerName, convert(varchar(10), SignatureDate, 101) as SignatureDate, ClientSignedPaper
from Documents as d
join Staff S on d.AuthorId = S.StaffId          
join Clients C on d.ClientId= C.ClientId and isnull(C.RecordDeleted,'N')<>'Y'            
join DocumentVersions dv on dv.DocumentId = d.DocumentId   
join dbo.DocumentSignatures as ds on d.DocumentId = ds.DocumentId
left join MedicationHistoryRequestConsents as mhrc  ON  mhrc.DocumentVersionId = dv.DocumentVersionID
and isnull(mhrc.RecordDeleted,'N')<>'Y' and mhrc.DocumentVersionId = @DocumentVersionId
Cross Join SystemConfigurations as SystemConfig            
where dv.DocumentVersionId = @DocumentVersionId
and isnull(d.RecordDeleted,'N')='N'          
and IsClient = 'Y'
              
--Checking For Errors                          
If (@@error!=0)                                                      
 Begin                                                      
  RAISERROR  20006   '[ssp_RDLMedicationHistoryRequestConsents] : An Error Occured'                                                       
  Return                                                      
 End                                                               
End                
                

GO


