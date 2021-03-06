/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientMedicationData]    Script Date: 11/18/2011 16:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientMedicationData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientMedicationData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientMedicationData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[ssp_SCGetClientMedicationData]
(
 @ClientId int
)
as
/*********************************************************************/
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationData]                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    11/Sep/07                                         */
/*                                                                   */
/* Purpose:  To retrieve MedicationData   */
/*                                                                   */
/* Input Parameters: none        @ClientId */
/*                                                                   */
/* Output Parameters:   None                           */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                               */
/*       */
/* Calls:      */
/*   */
/* Data Modifications:                          */
/*    */   /* Updates:  */
/*   Date     Author  Purpose                  */
/*  11/Sep/07    Rishu    Created      */
/*  27/Feb/07 Sonia Modified toget interactions of Non order medications*/
/*  11th April Sonia Modified
(Following changes implemented)
--CM.OrderStatus,CM.OrderStatusDate,CM.OrderDate removed from Selection list
-- Condition removed CM.OrderStatus = ''A''  removed
--In ClientMedicationInstructions Following removed from selection list
--mincmi.StartDate, cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock, cmi.Refills,cmi.EndDate, removed




--Condtion removed  cm.OrderStatus = ''A''
--In ClientMedicationInteractions
--Condtion removed  cm.OrderStatus = ''A''
--Data retrieval from ClientMedicationScriptDrugs added
--In ClientMedicationInteractionDetails
--Condition removed cm.OrderStatus = ''A''      */
/*  26/May/08 Sonia Modified  reference Task #39 MM#1.5.1
--Logic of Initialization changed as per New requirement of Task #39 MM 1.5.1*/
/*28/May/08 Sonia Modified to replace the NULL DrugCategory with 0*/
/*Reference Task #47 MM1.5*/
/*Modified by Chandan 19th Nov 2008 for getting MedicationInteraction Name in the Interaction table*/
/*Task #82 - MM -1.6.5          */
/*Modified by Chandan 15th Dec 2008 for getting StartDate and End Date from Drugs in Instruction table*/
/*Task #74 - MM -1.7          */
/*  11/April/2009 Loveena Modified  reference Task # MM#1.9
--Logic of retreiving these fileds*/
/* Modified by Loveena in ref to Task#2547 as ref to Javed-Comment Null to store in DSMCode
   so each Global Code DrigPurpose will have sane DxId so to set unique DxId DSMDescription is concatenated with DSMNumber.  */
/* Modified By Pradeep as to select ClientMedication.PermitChangesByOtherUsers as per task#31 */
/* Modified By Loveena in ref to Task#19 as per the datamodel changes */
/* Modified By Loveena in ref to Task#85*/
/* Modified 3/25/2015 Steczynski Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 */
/*********************************************************************/
begin

--Added on 22 Dec,2009 for task ref #3
declare @VerbalOrdersRequireApproval char(1)
select @VerbalOrdersRequireApproval = ISNULL(VerbalOrdersRequireApproval,''N'')
from SystemConfigurations
--Ended over here
--print @VerbalOrdersRequireApproval

 select * from (
select distinct
CM.ClientMedicationId, CM.ClientId, CM.Ordered,
--CM.OrderDate, removed
CM.MedicationNameId, CM.DrugPurpose, CM.DSMCode, CM.DSMNumber,
CM.NewDiagnosis, CM.PrescriberId, CM.PrescriberName, CM.ExternalPrescriberName, CM.SpecialInstructions, CM.DAW, CM.Discontinued,
CM.DiscontinuedReason, CM.DiscontinueDate, CM.RowIdentifier, CM.CreatedBy, CM.CreatedDate, CM.ModifiedBy, CM.ModifiedDate, CM.RecordDeleted,
CM.DeletedDate,CM.DeletedBy,
CM.MedicationStartDate,
CM.MedicationEndDate,
--CM.OrderStatus, CM.OrderStatusDate,
--Modified by Loveena in ref to Task#2547 dated 25-Aug-2009
--rtrim(ltrim(isnull(DSMCode,''0'')))+ ''_'' + rtrim(ltrim(isnull(cast(DSMNumber as varchar),''0''))) as DxId ,MDN.MedicationName  as MedicationName
DrugPurpose + ''_'' + rtrim(ltrim(isnull(cast(DSMNumber as varchar),''0''))) as DxId ,MDN.MedicationName  as MedicationName
--Changes by sonia
--*Reference Task #47 MM1.5 as in some cases DEACode is not found for some medications
--,MDDrugs.DEACODE as DrugCategory,CM.DEACode,--commented by sonia
,ISNULL(MDDrugs.DEACODE,''0'') as DrugCategory,CM.DEACode,--added by sonia
Case when CM.Ordered = ''Y'' then 0 else 1 end as CMOrder,
CM.TitrationType, --Added by Chandan
CM.DateTerminated,
CAST(A.ClientMedicationScriptId as Varchar) as MedicationScriptId, -- Added by Ankesh Bharti in ref to task # 2409
CM.OffLabel, --Added by Loveena in ref to Task# MM-1.9 to retrieve these fields
CM.DesiredOutcomes,
CM.Comments,
CM.DiscontinuedReasonCode,
CM.PermitChangesByOtherUsers,--Added By Pradeep as per task#31
CM.IncludeCommentOnPrescription,--Added By Pradeep as per task#12
ClientMedicationConsentId as ClientMedicationConsentId,
--Case when  isnull(ClientMedicationConsentId,0) = 0 then 0 else 1 end  as ClientMedicationConsentId
Case when  SignatureOrder=1 then 1
       when  SignatureOrder >1 then 2
       when  SignatureOrder= 0 then 0
       when  SignatureOrder is null then 0
 end  as SignedByMD
--,case when IsClient= ''Y'' then 0 else 1 end as SignedByMD
--end
--Added by Chandan for Verbal Order task#3 Venture FY-10 Venture (Conditione modified on 22 dec as sent By javed)
----Followin Changes by Chandan Ref Ticket #3 (Dated 27th December 2009)
--, Case when  isnull(CMS.WaitingPrescriberApproval,''N'')=''Y''  then 2 --Show Button A
--when  @VerbalOrdersRequireApproval = ''Y'' and isnull(CMS.VerbalOrderApproved,''N'')=''N''
-- and cm.CreatedBy <> s.UserCode then 1 --Show Button V
--       else 0 --No Button
-- end  as VerbalOrder
--,Case when  CM.PrescriberId=s.StaffId and isnull(CMS.WaitingPrescriberApproval,''N'')=''Y'' and @VerbalOrdersRequireApproval<>''Y''  then 2 --Show Button A
--when  CMS.CreatedBy <> s.UserCode and CM.PrescriberId=s.StaffId and @VerbalOrdersRequireApproval=''Y'' and isnull(CMS.VerbalOrderApproved,''N'')=''N'' then 1 --Show Button V
--       else 0 --No Button
-- end  as VerbalOrder
--Modified By Anuj for task ref 2859 (Medication Management)
,Case when  CM.PrescriberId=s.StaffId and isnull(CMS.WaitingPrescriberApproval,''N'')=''Y'' and isnull(CMS.VerbalOrderApproved,''N'')=''N''  then 2 --Show Button A
when  CMS.CreatedBy <> s.UserCode and CM.PrescriberId=s.StaffId and @VerbalOrdersRequireApproval=''Y'' and isnull(CMS.WaitingPrescriberApproval,''N'')=''N'' and isnull(CMS.VerbalOrderApproved,''N'')=''N'' then 1 --Show Button V
 else 0 --No Button
 end  as VerbalOrder,
 --Ended over here
 --Added in ref to Task#2983
 ''N'' as AllowAllergyMedications
--End Added by Chandan for Verbal Order task#3 Venture FY-10    Venture
from ClientMedications CM
join MDMedicationNames MDN on CM.MedicationNameId=MDN.MedicationNameId
left outer JOIN  ClientMedicationInstructions ON ClientMedicationInstructions.ClientMedicationId = CM.ClientMedicationId and isnull(ClientMedicationInstructions.Active,''Y'') = ''Y'' and isnull(ClientMedicationInstructions.RecordDeleted, ''N'') <> ''Y''




















--Added on 22 Dec,2009 for task ref #3
left outer join Staff s ON (cm.PrescriberId = s.StaffId)
--Ended over here
left outer JOIN  MDMedications on MDMedications.MedicationId = ClientMedicationInstructions.StrengthId AND ISNULL(dbo.ClientMedicationInstructions.RecordDeleted, ''N'') <> ''Y'' and ISNULL(dbo.MDMedications.RecordDeleted, ''N'') <> ''Y''




















left outer JOIN  MDDrugs ON dbo.MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, ''N'') <> ''Y''
--Added by Loveena in ref to To Task#2465 to display CheckBoxIcon on MedicationList if record exists in
-- ClientMedicationConsents
left outer  join
--Modified By anuj on 3 Nov,2009 in ref task#18 to show the the medication signd by (MD) or by Client
--Modified by Loveena in ref to Task#19 as per the datamodelchanges
(
select ClientMedicationConsentId, ClientMedicationInstructionId,MedicationNameId,CMCD.SignedByPrescriber,CMCD.SignedByClientRepresentative,
  Case when CMCD.SignedByPrescriber=''Y'' and ISNULL(CMCD.SignedByClientRepresentative,''N'')=''N'' then 1
  when CMCD.SignedByPrescriber=''Y'' and CMCD.SignedByClientRepresentative=''Y'' then 2
  when ISNULL(CMCD.SignedByPrescriber,''N'')=''N'' and ISNULL(CMCD.SignedByClientRepresentative,''N'')=''N'' then 0
  end as SignatureOrder
  from ClientMedicationConsents CMC
inner join ClientMedicationConsentDocuments as CMCD  on CMCD.DocumentVersionId=CMC.DocumentVersionId
--Modified By Anuj on 29Dec,2009
inner join DocumentVersions as DV on CMCD.DocumentVersionId=DV.DocumentVersionId
inner join Documents as D on D.DocumentId=DV.DocumentId
and D.ClientId=@ClientId and CMC.ConsentEndDate is  null and ISNULL(CMC.RecordDeleted,''N'')=''N''
--Ended over here
where (isnull(CMC.ConsentEndDate,dateadd(yy, 1, ISNULL(CMCD.ConsentStartDate,convert(varchar, getdate(), 101)))) >= convert(datetime, convert(varchar, getdate(), 101)))
)B on ((B.ClientMedicationInstructionId=ClientMedicationInstructions.ClientMedicationInstructionId and CM.OffLabel = ''Y'') or (B.MedicationNameId=CM.MedicationNameId and isnull(CM.OffLabel,''N'') = ''N''))
--Ended over here
left outer join(Select ClientMedicationInstructionId,MAX(ClientMedicationScriptId) as ClientMedicationScriptId from ClientMedicationScriptDrugs
group by ClientMedicationInstructionId) A on A.ClientMedicationInstructionId = ClientMedicationInstructions.ClientMedicationInstructionId

--Added by Chandan for Verbal Order task#3 Venture FY-10 Venture
left outer join ClientMedicationScriptDrugs cmsd on cmsd.ClientMedicationInstructionId = A.ClientMedicationInstructionId
left outer join ClientMedicationScripts CMS on CMS.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
--End Added by Chandan for Verbal Order task#3 Venture FY-10 Venture

where CM.ClientId=@ClientId
--and A.ClientMedicationScriptId Is not null
--and CM.OrderStatus = ''A'' column removed
AND isnull(CM.discontinued,''N'') <> ''Y''
and IsNull(CM.RecordDeleted,''N'')<>''Y''
and IsNull(MDN.RecordDeleted,''N'')<>''Y''
) T
Where (isnull(Ordered,''N'') = ''Y'' AND MedicationScriptID IS NOT NULL) OR (isnull(Ordered,''N'')=''N'')
order by Case when Ordered = ''Y'' then 0 else 1 end ,T.SignedByMD desc,T.ClientMedicationConsentId desc


--******** Get Data From ClientMedicationInstructions ******* --

select cmi.ClientMedicationInstructionId,
cmi.ClientMedicationId,
cmi.StrengthId,
cmi.Quantity,
cmi.Unit,
cmi.Schedule,
cmi.Active, -- Field added by Ankesh Bharti
--mincmi.StartDate, removed
--cmi.Days, cmi.Pharmacy, cmi.Sample, cmi.Stock, cmi.Refills, removed
--cmi.EndDate, removed
cmi.RowIdentifier,
cmi.CreatedBy,
cmi.CreatedDate,
cmi.ModifiedBy,
cmi.ModifiedDate,
cmi.RecordDeleted,
cmi.DeletedDate,
cmi.DeletedBy,
(MD.StrengthDescription + '' '' + dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + '' '' + Convert(varchar,GC.CodeName) + '' ''+ Convert(varchar,GC1.CodeName))  as Instruction,
MDM.MedicationName  as MedicationName,
'''' as InformationComplete, --''InformationComplete'' field added by Ankesh Bharti with ref to Task # 77.
--convert(varchar,CMSD.StartDate,101) as StartDate,
--convert(varchar,CMSD.EndDate,101) as EndDate ,
CMSD.StartDate,
CMSD.EndDate,
cmi.TitrationStepNumber, --Added by Chandan
CMSD.Days,
CMSD.Pharmacy,
CMSD.Sample,
CMSD.Stock,
MD.StrengthDescription as TitrateSummary,
''Y'' as DBdata,
CAST(CMSD.ClientMedicationScriptId as varchar) as MedicationScriptId
--Added By Anuj 0n 26dec,2009
--CM.MedicationNameId
--Ended over here
FROM ClientMedicationInstructions CMI
Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)
LEFT JOIN GlobalCodes GC on (GC.GlobalCodeID = CMI.Unit) and isnull(gc.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN GlobalCodes GC1 on (GC1.GlobalCodeId = CMI.Schedule) and isnull(gc1.RecordDeleted, ''N'') <> ''Y''
Join MDMedicationNames MDM on (CM.MedicationNameId=MDM.MedicationNameId)
Join MDMedications MD on (MD.MedicationID = CMI.StrengthId)
join     ClientMedicationScriptDrugs CMSD on   CMI.ClientMedicationInstructionId  =  CMSD.ClientMedicationInstructionId   and isnull(CMSD.RecordDeleted, ''N'') <> ''Y''
where cm.ClientId = @ClientId
--Ref Task #127
and CMSD.ModifiedDate=
(
Select max(ModifiedDate)
from ClientMedicationScriptDrugs  CMSD1
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId and  isnull(CMSD1.RecordDeleted, ''N'') <> ''Y''         )
--removed and cm.OrderStatus = ''A''
and isnull(cmi.Active,''Y'')=''Y''
AND isnull(cm.discontinued,''N'') <> ''Y''
and isnull(cmi.RecordDeleted, ''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''
and isnull(mdm.RecordDeleted, ''N'') <> ''Y''
and isnull(md.RecordDeleted, ''N'') <> ''Y''
order by MDM.MedicationName asc
--********************************************************************** --


--Get Data From ClientMedicationScriptDrugs
select CMSD.*
FROM ClientMedicationScriptDrugs CMSD
join ClientMedicationInstructions CMI on (CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId) and isnull(CMSD.RecordDeleted, ''N'') <> ''Y'' and isnull(CMI.Active, ''Y'') <> ''N''









Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)
where cm.ClientId = @ClientId
--Logic of Initialization changed as per New requirement of Task #38 MM 1.5.1
--Old logic Commented
/*--and CMSD.StartDate in
(
Select max(startdate)
from ClientMedicationScriptDrugs  CMSD1
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
and isnull(CMSD1.RecordDeleted, ''N'') <> ''Y'' and isnull(CMI.RecordDeleted, ''N'') <> ''Y''
 */
--New Logic
and CMSD.ModifiedDate=
(
Select max(ModifiedDate)
from ClientMedicationScriptDrugs  CMSD1
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
)

AND isnull(cm.discontinued,''N'') <> ''Y''
and isnull(cmi.RecordDeleted, ''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''

order by CMSD.ClientMedicationScriptDrugId,CMI.ClientMedicationId DESC



----ClientMedicationInteractions

--Select distinct cma.ClientMedicationInteractionId, cma.ClientMedicationId1, cma.ClientMedicationId2, cma.InteractionLevel,
--cma.PrescriberAcknowledgementRequired, cma.PrescriberAcknowledged, cma.RowIdentifier, cma.CreatedBy, cma.CreatedDate,
--cma.ModifiedBy, cma.ModifiedDate, cma.RecordDeleted, cma.DeletedDate, cma.DeletedBy
--from ClientMedications CM
--join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,''N'')<>''Y'')
--inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,''N'')<>''Y'')

--where cm.ClientId = @ClientId
----and cm.OrderStatus = ''A''
--AND isnull(cm.discontinued,''N'') <> ''Y''
--and isnull(cm.RecordDeleted, ''N'') <> ''Y''

--Added By Chandan on 19th Nov 2008
Select distinct cma.ClientMedicationInteractionId, cma.ClientMedicationId1, cma.ClientMedicationId2, cma.InteractionLevel,
cma.PrescriberAcknowledgementRequired, cma.PrescriberAcknowledged, cma.RowIdentifier, cma.CreatedBy, cma.CreatedDate,
cma.ModifiedBy, cma.ModifiedDate, cma.RecordDeleted, cma.DeletedDate, cma.DeletedBy,CM1.MedicationNameId ,CM2.MedicationNameId,MDN1.MedicationName as ClientMedicationId1Name,MDN2.MedicationName  as ClientMedicationId2Name









from ClientMedications CM
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,''N'')<>''Y'')
inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,''N'')<>''Y'')




inner join ClientMedications CM1 on (cma.ClientMedicationId1=CM1.ClientMedicationId)
inner join ClientMedications CM2 on (cma.ClientMedicationId2=CM2.ClientMedicationId)
inner join MDMedicationNames MDN1 on (MDN1.MedicationNameId=CM1.MedicationNameId)
inner join MDMedicationNames MDN2 on (MDN2.MedicationNameId=CM2.MedicationNameId)
where cm.ClientId = @ClientId
--and cm.OrderStatus = ''A''
AND isnull(cm.discontinued,''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''


Select distinct cmid.ClientMedicationInteractionDetailId, cmid.ClientMedicationInteractionId, cmid.DrugDrugInteractionId,
cmid.RowIdentifier, cmid.CreatedBy, cmid.CreatedDate, cmid.ModifiedBy, cmid.ModifiedDate, cmid.RecordDeleted,
cmid.DeletedDate, cmid.DeletedBy,
MDDI.SeverityLevel as InteractionLevel,MDDI.InteractionDescription,MDDI.DrugInteractionMonographId
from ClientMedications CM
join ClientMedicationInstructions CMI on (CM.ClientMedicationId=CMI.ClientMedicationId and IsNull(CMI.RecordDeleted,''N'')<>''Y'')
inner join ClientMedicationInteractions CMA on ((clientmedicationId1=CM.ClientMedicationId or clientmedicationid2=CM.ClientMedicationId) and IsNull(CMA.RecordDeleted,''N'')<>''Y'')




inner join ClientMedicationInteractionDetails CMID on (CMID.ClientMedicationInteractionId=CMA.ClientMedicationInteractionId and IsNull(CMID.RecordDeleted,''N'')<>''Y'')
inner join MDDrugDrugInteractions MDDI on (CMID.DrugDrugInteractionId=MDDI.DrugDrugInteractionId and IsNull(MDDI.RecordDeleted,''N'')<>''Y'')
where cm.ClientId = @ClientId
--and cm.OrderStatus = ''A''
AND isnull(cm.discontinued,''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''
order by CMID.ClientMedicationInteractionId

exec ssp_SCGetClientDrugAllergyInteraction @ClientId

--****** Get Data From ClientConsents table
--Added By Anuj on 24 October,2009 For Task Ref #1 Fy-10 Venture
--Modified by Loveena in ref to Task#19 as per the datamodel changes
select CMC.ClientMedicationConsentId,CMC.DocumentVersionId,CMC.MedicationNameId,CMC.ClientMedicationInstructionId,
CMC.ConsentEndDate,CMC.RevokedByClientRepresentative,CMC.RowIdentifier,CMC.CreatedBy,
CMC.CreatedDate,CMC.ModifiedBy,CMC.ModifiedDate,CMC.RecordDeleted,CMC.DeletedDate,CMC.DeletedBy
from ClientMedicationConsents as CMC inner join ClientMedicationInstructions as CMI on CMC.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
inner join ClientMedications as CM on CMI.ClientMedicationId = CM.ClientMedicationId
where CM.ClientId=@ClientId and ISNULL(CMC.RecordDeleted,''N'')<>''Y'' and  ISNULL(CMI.RecordDeleted,''N'')<>''Y'' and  ISNULL(CM.Discontinued,''N'')<>''Y''

--Added by Loveena in ref to Task#85
-----Get Data From ClientMedicationScriptDrugsStrength----
select Distinct CMSDS.ClientMedicationScriptDrugStrengthId,
CMSDS.ClientMedicationScriptId,
CMSDS.ClientMedicationId,
CMSDS.StrengthId,
CMSDS.Pharmacy,
CMSDS.PharmacyText,
CMSDS.Sample,
CMSDS.Stock,
CMSDS.Refills,
CMSDS.SpecialInstructions,
CMSDS.RowIdentifier,
CMSDS.CreatedBy,
CMSDS.CreatedDate,
CMSDS.ModifiedBy,
CMSDS.ModifiedDate,
CMSDS.RecordDeleted,
CMSDS.DeletedDate,
CMSDS.DeletedBy,
CMSDS.ReadyToSign  
FROM ClientMedicationScriptDrugStrengths CMSDS
join ClientMedicationScriptDrugs CMSD on ISNULL(CMSD.ClientMedicationScriptId,0)  =  ISNULL(CMSDS.ClientMedicationScriptId,0)
and isnull(CMSD.RecordDeleted, ''N'') <> ''Y''
join ClientMedicationInstructions CMI on (CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId) and isnull(CMSD.RecordDeleted, ''N'') <> ''Y'' and isnull(CMI.Active, ''Y'') <> ''N''





Join ClientMedications CM on (CMI.clientmedicationId=CM.clientMedicationid)
where cm.ClientId = @ClientId
and CMSD.ModifiedDate=
(
Select max(ModifiedDate)
from ClientMedicationScriptDrugs  CMSD1
where CMSD1.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId
)

AND isnull(cm.discontinued,''N'') <> ''Y''
and isnull(cmi.RecordDeleted, ''N'') <> ''Y''
and isnull(cm.RecordDeleted, ''N'') <> ''Y''
and ISNULL(CMSDS.RecordDeleted,''N'')<>''Y''
---End Over Here

IF (@@error!=0)
    BEGIN
        RAISERROR  20002 ''ssp_SCGetClientMedicationData : An error  occured''

        RETURN(1)

    END

end

' 
END
GO
