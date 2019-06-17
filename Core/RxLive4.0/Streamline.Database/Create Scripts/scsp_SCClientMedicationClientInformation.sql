      
Create PROCEDURE [dbo].[scsp_SCClientMedicationClientInformation]       
(      
 @ClientId INT      
)
      
As  
/******************************************************************************      
      
** File: Order Pages      
      
** Name: scsp_SCClientMedicationClientInformation      
      
** Desc: The stored procedure will return client information in HTML format.       
      
** This template can be customized:      
      
** Return values: HTML text      
      
**       
      
** Called by:  ssp_SCClientMedicationSummaryInfo      
      
** Parameters:      
      
** Input Output      
      
** ---------- -----------      
      
** @ClientId INT,      
      
** Auth: Rohit Verma      
      
** Date: Dec 02, 2008       
      
*******************************************************************************      
      
** Change History      
      
*******************************************************************************      
      
** Date: Author: Description:      
      
** -------- -------- -------------------------------------------      
      
*******************************************************************************/      
      
BEGIN      
      
declare @ClientName varchar(15)      
declare @Dob datetime      
declare @Sex varchar(1)      
declare @Race nvarchar(1000)      
declare @Diagnosis nvarchar(1000)      
declare @AxisIII nvarchar(100)      
declare @LastMedicationVisit nvarchar(100)      
declare @NextMedicationVisit nvarchar(100)      
      
      
set @ClientName =''      
set @Dob =''      
set @Sex  =''      
set @Race  =''      
set @Diagnosis =''       
set @AxisIII  =''      
set @LastMedicationVisit =''       
set @NextMedicationVisit  =''      
      
                          
select @ClientName=left(clients.LastName +', '+ clients.FirstName,15) ,@Dob=clients.dob, @Sex= clients.Sex                             
, 
 @Race=
 case when (select count(ClientId) from ClientRaces where ClientRaces.ClientId = @ClientId and IsNull(ClientRaces.RecordDeleted,'N')='N') >1 then 
     'Multi-Racial'
   else 
     left( ltrim(rtrim(gc.CodeName)),20) 
 end        
from                               
Clients clients                              
left join ClientRaces CR on CR.Clientid = clients.ClientId and IsNull(CR.RecordDeleted,'N')='N'                            
left join GlobalCodes gc on gc.GlobalCodeID = CR.RaceId                             
left join Staff staff on staff.StaffId= clients.PrimaryClinicianId                             
left join ClientAddresses clientAdd on clients.ClientId=clientAdd.ClientId  and clientAdd.Addresstype=90  and IsNull(clientAdd.RecordDeleted,'N')='N'                            
where  isNull(clients.RecordDeleted,'N')<>'Y' and  clients.ClientId=@ClientId          
    
      
      
      
      
--/******************************Get Diagnosis Info***********************************start/      
/*for calculate maximum documenid and version for diagnosis*/                 
--***************************************************************                               
declare  @Documentid int,@Version int                              
--set @Documentid =(select max(documentid) from documents where clientid=@ClientId and documentcodeid=5 and SignedByAuthor='Y' and Authorid=@varClinicianId and SignedByAll=''Y'' and isNull(RecordDeleted,''N'')<>''Y'')                                                        
-- The Most current Diagnosis should  be based on the EffectiveDate not the DocumentID                              
-- The document need not be signed and it could have been done by any Clinician                               
select @Documentid = docs1.DocumentId, @Version = docs1.CurrentVersion                              
from Documents docs1                              
where docs1.ClientId  = @ClientId                              
and docs1.DocumentCodeId = 5                              
and docs1.Status = 22                          
and ISNULL(docs1.RecordDeleted,'N')='N'                            
and not exists                              
(select * from Documents docs2                               
where  docs2.ClientId  = @ClientId                   
and docs2.DocumentCodeId = 5                              
and docs2.Status = 22                              
and docs2.EffectiveDate > docs1.EffectiveDate  and ISNULL(docs2.RecordDeleted,'N')='N')                              
                                  
      
/*========= Last Medication Visit =========start*/       
select top 1 @LastMedicationVisit=convert(varchar(10),services1.dateOfService,101) +' ' + convert(varchar(10),services1.dateOfService,108) + ' '+  procCodes.DisplayAs  + ' '+  IsNull(staff.FirstName,'')+' '+ IsNull(staff.LastName,'')       
      
from Services services1                              
JOIN Documents  docs ON (services1.ServiceId = docs.ServiceId and IsNull(docs.RecordDeleted,'N')='N')                         
JOIN Staff staff On (staff.StaffId = services1.ClinicianID)                         
JOIN ProcedureCodes procCodes on (procCodes.ProcedureCodeId = services1.ProcedureCodeId and Isnull(MedicationCode,'N')= 'Y')                         
where services1.clientid=@ClientId                               
and convert(varchar(10),services1.dateOfService,101)<=Convert(varchar(10),getDate(),101)                               
and services1.Status in (71, 75)                              
and IsNull(services1.RecordDeleted,'N')='N'                               
and not exists                            
(select * from Services  services2                              
where services2.clientid=@ClientId                               
and convert(varchar(10),services2.dateOfService,101)<=Convert(varchar(10),getDate(),101)                               
and services2.Status in (71, 75)                              
and services2.DateOfService > services1.DateOfService and IsNull(services2.RecordDeleted,'N')='N')                            
/*========= END Last Medication Visit =========end*/         
           
      
/*========= Next Medication Visit =========start*/         
Select top 1 @NextMedicationVisit=convert(varchar(10),dateOfService,101) +' ' + convert(varchar(10),dateOfService,108)      
from services services join documents docs  on docs.serviceid=services.Serviceid and IsNull(docs.RecordDeleted,'N')='N'                               
 where services.status=70 and services.clientid=@ClientId and convert(varchar(10),services.DateOfService,101)>=Convert(varchar(10),getDate(),101) and IsNull(services.RecordDeleted,'N')='N'                            
and services.ProcedureCodeId in (select ProcedureCodeId from procedurecodes                            
where Isnull(MedicationCode,'N')= 'Y')                               
 order by DateOfService                              
      
/*========= END Next Medication Visit =========end*/         
 
     
Declare @ClientInfoHtml as nvarchar(4000)      
select  @ClientInfoHtml=MedicationPatientOverviewTemplate  from SystemConfigurations      
      
/* html template to be stored in SystemConfigurations.MedicationPatientOverviewTemplate
<div id="clientSummaryInfo" style="overflow-x:none;overflow-y:auto;height:107px;width:100%;" > 
<table border="0" cellpadding="0" cellspacing="0" style="width: 96%;"  > 
<tr style="height:20px"> <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top" 
width="30%">Name:&nbsp;<a id="HyperLinkPatientName" runat="server" class="LinkLabel" >HyperLinkPatientNameText</a>
</td><td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                          width="25%">                          DOB/Age:&nbsp;<a id="HyperLinkPatientDOB" runat="server" class="LinkLabel" >HyperLinkPatientDOBText</a>                      </td>                      <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                          width="20%">                          Race:&nbsp; <a id="HyperLinkRace" runat="server" class="LinkLabel" >HyperLinkRaceText</a>                      </td>                      <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap; width: 25%;"                          valign="top">                         &nbsp; Sex:&nbsp; <a id="HyperLinkSex" runat="server" class="LinkLabel">HyperLinkSexText</a>                      </td>                  </tr>                                 <tr >                <td colspan="4" >                   <table style="height:30px;width:100%" >                  <tr >                      <td class="SumarryLabel" valign="top" align="left" style="width:7%">                          Diagnosis:</td>                      <td class="SumarryLabel" valign="top" align="left" style="width:93%">                         
 <a id="HyperlinkDiagnosis" runat="server" class="LinkLabel" >HyperlinkDiagnosisText</a>                      </td>                  </tr>              </table>                 </td>                </tr>               <tr >                <td colspan="4" >                   <table style="height:30px;width:100%" >                  <tr >                      <td class="SumarryLabel" valign="top" align="left" style="width:7%">                          Axis III:</td>                      <td class="SumarryLabel" valign="top" align="left" style="width:93%">                         <a id="HyperLinkAxisIII" runat="server" class="LinkLabel"                              >HyperLinkAxisIIIText</a>                      </td>                  </tr>              </table>                 </td>                </tr>                               <tr >                <td colspan="4"  >                   <table border="0" cellpadding="0" cellspacing="0" style="height:20px;width: 100%">                                        <tr>                      <td class="SumarryLabel" nowrap="nowrap"  style="width: 50%;">                          Last Medication Visit:&nbsp;<a id="HyperLinkLastMedicationVisit" runat="server" class="LinkLabel"                              >HyperLinkLastMedicationVisitText</a>                      </td>                      <td class="SumarryLabel" nowrap="nowrap" >                          Next Medication Visit:&nbsp;<a id="HyperLinkNextMedicationVisit" runat="server" class="LinkLabel"                              >HyperLinkNextMedicationVisitText</a>                      </td>                  </tr>                                                </table>                </td>                </tr>                                               </table>                            </div>
*/

      
if(@ClientInfoHtml is null)      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkPatientNameText','')  
else      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkPatientNameText',@ClientName)        
      
if(@Dob is null)     
  set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkPatientDOBText','')             
else       
  set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkPatientDOBText', convert(varchar(10),@dob,101)+ ' (' + convert(varchar(4), DateDiff("d",@dob,getdate())/365) + ')')       
      
if(@Race is null)      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkRaceText','')        
else      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkRaceText',@Race)        
      
if(@Sex is null)         
  set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperlinkSexText','')        
else      
  begin      
   if(@Sex ='M')         
     set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperlinkSexText','Male')      
    else if(@Sex ='F')       
     set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperlinkSexText','Female')      
  end      
      
if(@Diagnosis is null)      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperlinkDiagnosisText','')        
else      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperlinkDiagnosisText',@Diagnosis)        
      
      
if(@AxisIII is null)      
set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkAxisIIIText','')        
else      
set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkAxisIIIText',@AxisIII)        
      
if(@LastMedicationVisit is null)      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkLastMedicationVisitText','')        
else      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkLastMedicationVisitText',@LastMedicationVisit)        
      
      
if(@NextMedicationVisit is null)      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkNextMedicationVisitText','')        
else      
 set @ClientInfoHtml=replace(@ClientInfoHtml,'HyperLinkNextMedicationVisitText',@NextMedicationVisit)        
      
Select @ClientInfoHtml    
  
select @ClientName as ClientName,@Dob as Dob,@Sex as Sex,@Race as ClientRace    
IF (@@error!=0)          
   BEGIN          
    RAISERROR  20002 'scsp_SCClientMedicationClientInformation: An Error Occured'             
   END       
END

