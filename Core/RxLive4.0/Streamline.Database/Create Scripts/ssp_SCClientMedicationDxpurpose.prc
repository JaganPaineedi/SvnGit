ALTER procedure [dbo].[ssp_SCClientMedicationDxpurpose]                                      
(                                            
 @ClientId int                                               
)                                            
as                                            
/*********************************************************************/                                                    
/* Stored Procedure: dbo.[ssp_SCClientMedicationDxpurpose]                */                                                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                    
/* Creation Date:    28/Sep/07                                         */                                                   
/*                                                                   */                                                    
/* Purpose:  To retrieve DxPurpose   */                                                    
/*                                                                   */                                                  
/* Input Parameters: none        @ClientId */                                                  
/*                                                                   */                                                    
/* Output Parameters:   None                           */                                                    
/*                                                                   */                                                    
/* Return:  0=success, otherwise an error number                     */                                                    
/*                                                                   */                                                    
/* Called By:                                                        */                                                    
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/* Updates:                                                          */                                                    
/*   Date     Author       Purpose                                    */                                                    
/*  28/Sep/07    Rishu    Created                                    */      
/*-- TER Modified    
-- Include any Axis III codes/descriptions defined in the dx document*/     
/* 06/06/2008 Sonia Modified*/
/* Ref Task #48 MM 1.5*/
/* While retrieving records from DiagnosisIandII no join with documents table is required*/                                             
/*********************************************************************/                                               
declare  @varDocumentid int,                    
@varVersion int          
          
select top 1 @varDocumentid = a.DocumentId, @varVersion = a.CurrentVersion                  
from Documents a                  
where a.ClientId = @ClientId                  
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate() ,101))                  
and a.Status = 22                  
and a.DocumentCodeId =5                  
 and isNull(a.RecordDeleted,'N')<>'Y'   order by a.EffectiveDate desc,a.ModifiedDate desc            
              
SELECT distinct         
DSM.DSMCode,        
DSM.DSMNumber,        
DSM.DSMDescription,        
DSM.Axis,        
case DSM. Axis when 1 then 'Axis I' else 'Axis II' end AxisName ,         
rtrim(ltrim(isnull(DSM.DSMCode,'0')))+ '_' + rtrim(ltrim(isnull(cast(DSM.DSMNumber as varchar),'0'))) as DxId        
,D.DiagnosisOrder       
--Following commented by sonia as due to this join records of a old version were also being retrieved for same document Id
/*from  DiagnosisDSMDescriptions DSM                     
join DiagnosesIandII D on DSM.DSMCODE=D.DSMCODE  and IsNull(D.RecordDeleted,'N')='N' and DSM.DSMNumber=D.DSMNumber              
join documents Doc on D.DocumentId=Doc.DocumentId          
and @varDocumentid=Doc.DocumentId and @varVersion=Doc.CurrentVersion          
where (Doc.clientid=@ClientId AND IsNull(Doc.RecordDeleted,'N')='N')  */ 

--Following added by sonia as join with Documents table is not required just 
--Ref Task #48 MM 1.5.3
from DiagnosisDSMDescriptions DSM 
join DiagnosesIandII as D  on DSM.DSMCODE=D.DSMCODE  and IsNull(D.RecordDeleted,'N')='N' and DSM.DSMNumber=D.DSMNumber   
where D.DocumentId=@varDocumentid and D.Version=@varVersion
            
union         
select        
dx.ICDCode1,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode1 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode1        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union         
select        
dx.ICDCode2,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode2 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode2        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union         
select        
dx.ICDCode3,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode3 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode3        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode4,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode4 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode4        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode5,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode5 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode5        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode6,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode6 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode6        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode7,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode7 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode7        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode8,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode8 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode8        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode9,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode9 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode9        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode10,     
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode10 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode10        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode11,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode11 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode11        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
union        
select        
dx.ICDCode12,        
1 as DSMNumber,        
icd.ICDDescription,        
3 as Axis,        
'Axis III' as AxisName,        
dx.ICDCode12 + '_1' as DxId,        
9 as DiagnosisOrder        
from DiagnosesIII as dx        
join DiagnosisICDCodes as icd on icd.ICDCode = dx.ICDCode12        
where dx.DocumentId = @varDocumentId        
and dx.Version = @varVersion        
and isnull(dx.RecordDeleted, 'N') <> 'Y'        
                                
IF (@@error!=0)           
    BEGIN                                                    
        RAISERROR  20002 'ssp_SCClientMedicationDxpurpose : An error  occured'                                                    
                                                       
        RETURN(1)                                                    
                                       
    END 