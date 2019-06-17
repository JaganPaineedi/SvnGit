IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeClientMedicationHeaderInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ViewModeClientMedicationHeaderInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
create PROCEDURE   [dbo].[csp_ViewModeClientMedicationHeaderInfo]  
(@ClientId int)  
  
  
as  
/*  
Created Date: 3/17/2008  
Created By: avoss  
  
Purpose: Header info for client medication history and current medications  
  
exec csp_ViewModeClientMedicationHeaderInfo 36168  
select * from clientMedicationScripts  
exec ssp_RDLClientPrescriptionMain 167, 'p'  
exec csp_RDLClientPrescriptionAllergies 167, 'p'  
exec csp_RDLClientPrescriptionDrugs 167, 'p'  
exec csp_RDLClientPrescriptionSignature 167, 'p'  
  
--Testing  
declare @ClientId int  
set @ClientId = 36194  
  
sp_helptext csp_ViewModeClientMedicationHeaderInfo 682910  
Modified Date			Modified By			Purpose
17/Aug/2015				Malathi Shiva		ICD 10 Changes
21/Apr/2016    Malathi Shiva  New Directions - Support Go Live 332 -  When there is diagnosis details, Client details were updated in the temp table where as when there is no diagnosis details the 
							  temp table was null and was not inserting the client details

			
*/  
/*Header Info */  
create Table #ClientHeaderInfo (  
Row int identity,  
ClientId int,   
ClientName varchar(60),  
ClientDOB datetime,  
ClientSex char(1),  
DSMCode varchar(20),   
DSMNumber int,   
DSMDescription varchar(200),   
Axis int,   
AxisName varchar(30),   
DxId varchar(250),  
DiagnosisOrder int,  
RuleOut varchar(4)  
)  
  
declare @ClientName varchar(60), @ClientDOB datetime, @ClientSex char(1),  
  @DocumentId int, @Version int, @CurrentDocumentVersionId int    
  
select @ClientName = rtrim(c.LastName + ', ' +c.FirstName),  
  @ClientDOB = c.DOB,  
  @ClientSex = c.Sex  
from Clients as c   
where c.ClientId = @ClientId  
and isnull(c.RecordDeleted,'N')<>'Y'  

DECLARE @DSM5DOC CHAR(1) 
     
    SELECT TOP 1  
            @CurrentDocumentVersionId = D.CurrentDocumentVersionId, @DSM5DOC=ISNULL(DC.DSMV,'N') 
    FROM    Documents D  
    INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = D.DocumentCodeid 
    WHERE   D.ClientId = @ClientId  
            AND D.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))  
            AND D.Status = 22  
            -- Modified by Malathi Shiva, included DocumentCodeId which points to the active diagnosis  
            --AND D.DocumentCodeId in (5,1601)
            AND Dc.DiagnosisDocument = 'Y'  
            AND ISNULL(D.RecordDeleted, 'N') <> 'Y'  
    ORDER BY D.EffectiveDate DESC ,  
            D.ModifiedDate DESC 
            
    
 IF EXISTS (select 1 from DiagnosesIandII where DocumentVersionId = @CurrentDocumentVersionId)
     BEGIN
		SET @DSM5DOC = 'N'
     END
     IF EXISTS (select 1 from DocumentDiagnosisCodes where DocumentVersionId = @CurrentDocumentVersionId)
     BEGIN
		SET @DSM5DOC = 'Y'
	 END
	  
   if(@DSM5DOC = 'N')
   begin  
--Diagnosis I, II, III codes              
Insert into #ClientHeaderInfo  
(DSMCode, DSMNumber,  DSMDescription, Axis, AxisName, DxId, DiagnosisOrder, RuleOut)        
select distinct  
DSM.DSMCode,  
DSM.DSMNumber,  
rtrim(DSM.DSMDescription),  
DSM.Axis,  
case DSM.Axis when 1 then 'Axis I' else 'Axis II' end as AxisName,   
rtrim(ltrim(isnull(DSM.DSMCode,'0')))+ '_' + rtrim(ltrim(isnull(cast(DSM.DSMNumber as varchar),'0'))) as DxId,  
D.DiagnosisOrder,  
case d.RuleOut when 'Y' then 'R/O' else '' end as RuleOut  
from  DiagnosisDSMDescriptions DSM               
join DiagnosesIandII D on DSM.DSMCODE=D.DSMCODE  and IsNull(D.RecordDeleted,'N')='N' and DSM.DSMNumber=D.DSMNumber        
join documents Doc on D.DocumentVersionId=Doc.CurrentDocumentVersionId    
where (Doc.CurrentDocumentVersionId=@CurrentDocumentVersionId AND IsNull(Doc.RecordDeleted,'N')='N'  
and ISNULL(d.RecordDeleted, 'N')= 'N')        
union   
select iii.ICDCode, 1 as DSMNumber, icd.ICDDescription, 3 as Axis, 'Axis III' as AxisName,  
iii.ICDCode + '_1' as DxId,  
9 as DiagnosisOrder,  
'' as RuleOut  
from DiagnosesIII as dx  
join dbo.DiagnosesIIICodes III on III.DocumentVersionId = dx.DocumentVersionId  
join DiagnosisICDCodes as icd on icd.ICDCode = iii.ICDCode  
join documents Doc on Dx.DocumentVersionId=Doc.CurrentDocumentVersionId    
Where doc.CurrentDocumentVersionId = @CurrentDocumentVersionId  
and ISNULL(dx.RecordDeleted, 'N') ='N'  
and ISNULL(doc.RecordDeleted, 'N')= 'N'  
  end
else 
   begin    
   Insert into #ClientHeaderInfo  
(DSMCode, DSMNumber,  DSMDescription, Axis, AxisName, DxId, DiagnosisOrder, RuleOut)        
SELECT  DISTINCT  
            D.ICD10Code,  
            '1' ,  
            DSM.ICDDescription,  
            '10',  
            'ICD 10 Code',  
            ICDDescription + '_'  
            + RTRIM(LTRIM(ISNULL(CAST('1' AS VARCHAR), '0'))) ,  
            D.DiagnosisOrder, 
            NULL 
            FROM  DocumentDiagnosisCodes AS D INNER JOIN                  
       DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId       
 WHERE (D.DocumentVersionId = @CurrentDocumentVersionId) AND (ISNULL(D.RecordDeleted, 'N') = 'N')       

   end
  
  
  
If exists (select 1 from #ClientHeaderInfo)
begin
--Update with Client Info    
Update #ClientHeaderInfo    
Set ClientId = @ClientId,     
 ClientName = @ClientName,     
 ClientDOB = @ClientDOB,    
 ClientSex = @ClientSex   
end
else
begin
Insert into #ClientHeaderInfo    
( ClientId, ClientName, ClientDOB, ClientSex)
values
(@ClientId, @ClientName,  @ClientDOB, @ClientSex )   
end

  
select   
 Row,  
 ClientId,   
 ClientName,  
 ClientDOB,  
 ClientSex,  
 rtrim(AxisName +': ' + DSMCode + ' - ' + DSMDescription + ' ' + isnull(RuleOut,'')) as DiagnosisLine,  
 DSMCode,   
 DSMNumber,   
 Axis,   
 DSMDescription,   
 RuleOut  
from #ClientHeaderInfo  
order by axis, dsmcode  
drop Table #ClientHeaderInfo  
  
  
GO


