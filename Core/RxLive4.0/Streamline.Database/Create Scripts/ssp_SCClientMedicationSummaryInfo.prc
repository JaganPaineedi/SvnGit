Create procedure [dbo].[ssp_SCClientMedicationSummaryInfo]                          
@ClientRowIdentifier varchar(150),                          
@StaffRowIdentifier varchar(150)                          
as                        
/**********************************************************************/                            
/* Stored Procedure: dbo.ssp_SCClientMedicationSummaryInfo            */                            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC              */                            
/* Creation Date:    08/23/2007                                       */                            
/*                                                                    */                            
/* Purpose:Used to fill the values in Medication Tab                  */                           
/*                                                                    */                          
/* Input Parameters: @varClientId, @varClinicianId                    */                          
/*                                                                    */                            
/* Output Parameters:   None                                          */                            
/*                                                                    */                            
/* Return:  0=success, otherwise an error number                      */                            
/*                                                                    */                            
/* Called By: DownloadClientMedicationSummary() in MSDE               */                            
/*                                                                    */                            
/* Calls:                                                             */                            
/*                                                                    */                            
/* Data Modifications:                                                */                            
/*                                                                    */                            
/* Updates:                                                           */                            
/*    Date        Author       Purpose                                */                            
/* 08/23/2007   Rohit Verma    Created                                */        
/* 12/23/2007 Sonia Dhamija Modified to retrive data related to Allergy interactions and to get DiagnosisIII codes*/                        
/* 12/04/2008 Rohit Verma   Modified to get the patient information as final html text*/
/* 12/26/2008 Loveena Sukhija Modified to get ClientPharmacies*/                        
/**********************************************************************/                             
                        
BEGIN                          
                        
Declare @varClinicianId as int                              
Declare @varClientId as int                              
                          
set @varClinicianId=(SELECT StaffId FROM  Staff where RowIdentifier=@StaffRowIdentifier  )                                     
                          
set @varClientId=(SELECT ClientId FROM  Clients where RowIdentifier=@ClientRowIdentifier and ISNULL(RecordDeleted,'N')='N')                               
                        
--get the Details of the client      
/*--commented by Rohit MM #81                    
select a.LastName,a.FirstName ,a.dob as DOB , case when a.Sex ='F' then 'Female' when a.Sex='M' then 'Male'  else '' end                         
as SEX  ,  case when (select count(ClientId) from ClientRaces where ClientRaces.ClientId = @varClientId and IsNull(ClientRaces.RecordDeleted,'N')='N') >1 then 'Multi-Racial' else                        
ltrim(rtrim(e.CodeName)) end as ClientRace ,a.SSN ,c.StaffId, d.*,                          
dbo.getFeeArrangement(@varClientId)   from                           
Clients a                          
left join ClientRaces CR on CR.Clientid = a.ClientId and IsNull(CR.RecordDeleted,'N')='N'                        
left join GlobalCodes e on e.GlobalCodeID = CR.RaceId                         
left join Staff c on c.StaffId= a.PrimaryClinicianId                         
left join ClientAddresses d on a.ClientId=d.ClientId  and d.Addresstype=90  and IsNull(d.RecordDeleted,'N')='N'                        
where  isNull(a.RecordDeleted,'N')<>'Y' and  a.ClientId=@varClientId                          
*/
                        
/*for calculate maximum documenid and version for diagnosis*/             
--***************************************************************                           
declare  @varDocumentid int,@varVersion int                          
--set @varDocumentid =(select max(documentid) from documents where clientid=@varClientId and documentcodeid=5 and SignedByAuthor='Y' and Authorid=@varClinicianId and SignedByAll=''Y'' and isNull(RecordDeleted,''N'')<>''Y'')                           
-- JHB                          
-- The Most current Diagnosis should  be based on the EffectiveDate not the DocumentID                          
-- The document need not be signed and it could have been done by any Clinician                           
select @varDocumentId = a.DocumentId, @varVersion = a.CurrentVersion                          
from Documents a                          
where a.ClientId  = @varClientId                          
and a.DocumentCodeId = 5                          
and a.Status = 22                          
and ISNULL(a.RecordDeleted,'N')='N'                        
and not exists                          
(select * from Documents b                           
where  b.ClientId  = @varClientId                          
and b.DocumentCodeId = 5                          
and b.Status = 22                          
and b.EffectiveDate > a.EffectiveDate  and ISNULL(b.RecordDeleted,'N')='N')                          
                          
--******************************************************************                          
                          
/*--commented by Rohit MM #81  
--get the Diagnosis I and II codes                          
select DSMCode,DSMNumber,@varDocumentid as DocumentId,@varVersion as Version,    (case RuleOut when 'Y' then 'R/O' else '' end) As RuleOut           
from  DiagnosesIandII       
where documentid = @varDocumentid and version = @varVersion and isNull(RecordDeleted,'N')      
<>'Y'  order by DiagnosisOrder ASC                          
      */
   /*                         
--get the diagnosis III values                          
select Specification,@varDocumentid as DocumentId,@varVersion as Version        
from DiagnosesIII       
where documentid = @varDocumentid and version = @varVersion and isNull(RecordDeleted,'N')<>'Y'                           
                          
/* for AxisV*/                          
-- JHB                          
-- The Most current document should  be based on the EffectiveDate not the DocumentID                          
                          
declare  @AxisVDocumentCodeId int                          
declare @AxisvarDocumentId int                          
declare @AxisvarVersion int                          
                          
set @AxisvarDocumentId = null                          
set @AxisvarVersion = null                          
                          
select @AxisvarDocumentId = a.DocumentId, @AxisvarVersion = a.CurrentVersion, @AxisVDocumentCodeId = a.DocumentCodeId                          
from Documents a                          
where a.ClientId  = @varClientId                          
and a.DocumentCodeId in (5, 6)                          
and a.Status = 22                          
and ISNULL(a.RecordDeleted,'N')='N'                        
and not exists                          
(select * from Documents b                           
where  b.ClientId  = @varClientId                          
and b.DocumentCodeId in (5, 6)                          
and b.Status = 22                          
and b.EffectiveDate > a.EffectiveDate  and ISNULL(b.RecordDeleted,'N')='N')                          
                          
if @AxisVDocumentCodeId = 6    
begin                          
 select AxisV,  1 as 'Id', DocumentId, Version                          
 from Notes                          
 where DocumentId = @AxisvarDocumentId                          
 and  Version = @AxisvarVersion   and ISNULL(RecordDeleted,'N')='N'                        
end                          
else                          
begin                          
 select AxisV,  2 as 'Id', DocumentId, Version                          
 from DiagnosesV                          
 where DocumentId = @AxisvarDocumentId                          
 and  Version = @AxisvarVersion   and ISNULL(RecordDeleted,'N')='N'                          
end                          
                          
----------AxisIV--------------------                     
select CASE WHEN PrimarySupport like 'Y%' THEN 'Problems with primary support group, ' ELSE '' END +                          
CASE WHEN SocialEnvironment like 'Y%' THEN 'Problems related to social environment, ' ELSE '' END +                          
CASE WHEN Educational like 'Y%' THEN 'Educational problems, ' ELSE '' END +                          
CASE WHEN Occupational like 'Y%' THEN 'Occupational problems, ' ELSE '' END +                          
CASE WHEN Housing like 'Y%' THEN 'Housing problems, ' ELSE '' END +               
CASE WHEN Economic like 'Y%' THEN 'Economic problems, ' ELSE '' END +                          
CASE WHEN HealthcareServices like 'Y%' THEN 'Problems with access to health care services, ' ELSE '' END +                          
CASE WHEN Legal like 'Y%' THEN 'Problems related to interaction with the legal system/crime, ' ELSE '' END +                          
CASE WHEN Other like 'Y%' THEN 'Other psychosocial and environmental problems' ELSE '' END  as "AxisIV",@varDocumentid as DocumentId,@varVersion as Version  from diagnosesIV  where documentid=@varDocumentid and version=@varVersion         
and ISNULL(RecordDeleted,'N')='N'                        
----------end AxisIV--------------------                          
 */      
      
             /*        --commented by Rohit MM #81   
/*========= Last Medication Visit =========*/                        
select top 1 a.DateOfService, z.DocumentId, IsNull(s.FirstName,'')+' '+ IsNull(s.LastName,'') as StaffName,                    
p.DisplayAs as ProcedureName                    
from Services a                          
JOIN Documents  z ON (a.ServiceId = z.ServiceId and IsNull(z.RecordDeleted,'N')='N')                     
JOIN Staff s On (s.StaffId = a.ClinicianID)                     
JOIN ProcedureCodes p on (p.ProcedureCodeId = a.ProcedureCodeId and Isnull(MedicationCode,'N')= 'Y')                     
where a.clientid=@varClientId                           
and convert(varchar(10),a.dateOfService,101)<=Convert(varchar(10),getDate(),101)                           
and a.Status in (71, 75)                          
and IsNull(a.RecordDeleted,'N')='N'                           
and not exists                        
(select * from Services  b                          
where b.clientid=@varClientId                           
and convert(varchar(10),b.dateOfService,101)<=Convert(varchar(10),getDate(),101)                           
and b.Status in (71, 75)                          
and b.DateOfService > a.DateOfService and IsNull(b.RecordDeleted,'N')='N')                          
/*========= END Last Medication Visit =========*/                        
              */          
             /*           
--commented by Rohit MM #81  
/*========= Next Medication Visit =========*/                          
select top 1 DateOfService,d.Documentid from services s join documents d  on d.serviceid=s.Serviceid and IsNull(d.RecordDeleted,'N')='N'                           
 where s.status=70 and s.clientid=@varClientId and convert(varchar(10),s.DateOfService,101)>=Convert(varchar(10),getDate(),101) and IsNull(s.RecordDeleted,'N')='N'                        
and s.ProcedureCodeId in (select ProcedureCodeId from procedurecodes                        
where Isnull(MedicationCode,'N')= 'Y')                     
 order by DateOfService                          
/*========= END Next Medication Visit =========*/                        
                  */      
                        
/*========= Client Allergies =========*/                        
/*Commented by Sonia and added the following line as the same stored procedure is being used to get ClientAllergies*/                
/*select ca.ClientAllergyId, md.AllergenConceptId, md.ExternalConceptId, md.ConceptIdType, md.ConceptDescription                        
from ClientAllergies ca                        
JOIN MDAllergenConcepts md ON (ca.AllergenConceptId = md.AllergenConceptId)                          
where ca.clientid=@varClientId and (Isnull(ca.RecordDeleted,'N')<> 'Y')   */                
                
exec ssp_SCGetClientAllergiesData @varClientId                   
                     
/*========= END Client Allergies =========*/                        
                        
/*========= Medication Information =========*/                        
 EXEC ssp_SCGetClientMedicationData @varClientId            
/*========= END Medication Information =========*/           
        
--Added as per Task 2373 SC-Support        
/*========= Diagnosis Information for Axis I,II and III=========*/                        
   EXEC ssp_SCClientMedicationDiagnosisAxisCodes @varClientId                      
/*========= END Medication Information =========*/                      
                
/*========= Get Formated html text of clinet Information=========start*/                  
   EXEC scsp_SCClientMedicationClientInformation @varClientId     --added by Rohit MM #81                         
/*========= Get Formated html text of clinet Information =========end*/

/*========= Get ClientPharmacies===================================start*/
	EXEC ssp_MMGetClientPharmacies @varClientId --added by Loveena MM#1.7
/*====================End ClientPharmacies===========================*/
        
                        
    IF (@@error!=0)                          
    BEGIN                          
        RAISERROR  20002 'Client Medication Summary: An Error Occured '                          
        RETURN(1)                          
    END                          
    RETURN(0)                          
END 


