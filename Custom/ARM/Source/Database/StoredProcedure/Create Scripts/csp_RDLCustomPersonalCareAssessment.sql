/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPersonalCareAssessment]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPersonalCareAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPersonalCareAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPersonalCareAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create	PROCEDURE   [dbo].[csp_RDLCustomPersonalCareAssessment] 
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010   
)            
AS            
      
Begin      
/***********************************************************************/                                            
/* Stored Procedure: [csp_RDLCustomPersonalCareAssessment]		       */                                 
/* Copyright: 2006 Streamline SmartCare								   */                                  
/* Creation Date: May 14, 2007                                         */                                            
/*                                                                     */                                            
/* Purpose: Gets Data from CustomPersonalCareAssessment,               */                                           
/*          SystemConfigurations,Staff,Documents                       */                                          
/* Input Parameters: DocumentID,Version								   */                                          
/*                                                                     */                                             
/* Output Parameters:												   */                                            
/* Purpose: Use For Rdl Report										   */                                  
/* Calls:                                                              */                                            
/* Author: Rupali Patil                                                */                                            
/*********************************************************************/              
SELECT	(select OrganizationName from SystemConfigurations) as OrganizationName
		,C.LastName + '', '' + C.FirstName as ClientName
		,Documents.ClientID
		,Documents.EffectiveDate      
		,S.FirstName + '' '' + S.LastName + '',  '' + ISNull(GC.CodeName,'''') as ClinicianName  
		,CPCA.[DateOfNotice] as [DateOfNotice]
		,case when CPCA.[PersonalCareHouseKeeping] = ''Y'' then ''Yes'' when CPCA.[PersonalCareHouseKeeping] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareHouseKeeping]
		,case when CPCA.[PersonalCareEatingOrFeeding] = ''Y'' then ''Yes'' when CPCA.[PersonalCareEatingOrFeeding] = ''N'' then ''No'' else ''N/A''end as [PersonalCareEatingOrFeeding]
		,case when CPCA.[PersonalCareToileting] = ''Y'' then ''Yes'' when CPCA.[PersonalCareToileting] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareToileting]
		,case when CPCA.[PersonalCareBathing] = ''Y'' then ''Yes'' when CPCA.[PersonalCareBathing] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareBathing]
		,case when CPCA.[PersonalCareDressing] = ''Y'' then ''Yes'' when CPCA.[PersonalCareDressing] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareDressing]
		,case when CPCA.[PersonalCareGrooming] = ''Y'' then ''Yes'' when CPCA.[PersonalCareGrooming] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareGrooming]
		,case when CPCA.[PersonalCareTransferring] = ''Y'' then ''Yes'' when CPCA.[PersonalCareTransferring] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareTransferring]
		,case when CPCA.[PersonalCareAmbulation] = ''Y'' then ''Yes'' when CPCA.[PersonalCareAmbulation] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareAmbulation]
		,case when CPCA.[PersonalCareMedication] = ''Y'' then ''Yes'' when CPCA.[PersonalCareMedication] = ''N'' then ''No'' else ''N/A'' end as [PersonalCareMedication]
		,CPCA.[AveragePersonalCareHoursPerDay] as [AveragePersonalPerDiemRate]
		,CPCA.[PersonalCarePerDiemRate] as [PersonalCareDiemRate]
		,case when CPCA.[CLSMealPreperation] = ''Y'' then ''Yes'' when CPCA.[CLSMealPreperation] = ''N'' then ''No'' else ''N/A'' end as [CLSMealPreparation]
		,case when CPCA.[CLSLaundry] = ''Y'' then ''Yes'' when CPCA.[CLSLaundry] = ''N'' then ''No'' else ''N/A'' end as [CLSLaundry]
		,case when CPCA.[CLSHouseholdmaintenance] = ''Y'' then ''Yes'' when CPCA.[CLSHouseholdmaintenance] = ''N'' then ''No'' else ''N/A'' end as [CLSHouseholdmaintenance]
		,case when CPCA.[CLSDailyLiving] = ''Y'' then ''Yes'' when CPCA.[CLSDailyLiving] = ''N'' then ''No'' else ''N/A'' end as [CLSDailyLiving]
		,case when CPCA.[CLSShopping] = ''Y'' then ''Yes'' when CPCA.[CLSShopping] = ''N'' then ''No'' else ''N/A'' end as [CLSShopping]
		,case when CPCA.[CLSMoneyManagement] = ''Y'' then ''Yes'' when CPCA.[CLSMoneyManagement] = ''N'' then ''No'' else ''N/A'' end as [CLSMoneyManagement]
		,case when CPCA.[CLSSocializing] = ''Y'' then ''Yes'' when CPCA.[CLSSocializing] = ''N'' then ''No'' else ''N/A'' end as [CLSSocializing]
		,case when CPCA.[CLSTransportation] = ''Y'' then ''Yes'' when CPCA.[CLSTransportation] = ''N'' then ''No'' else ''N/A'' end as [CLSTransportation]
		,case when CPCA.[CLSLeisureChoice] = ''Y'' then ''Yes'' when CPCA.[CLSLeisureChoice] = ''N'' then ''No'' else ''N/A'' end as [CLSLeisureChoice]
		,case when CPCA.[CLSMedicalAppointments] = ''Y'' then ''Yes'' when CPCA.[CLSMedicalAppointments] = ''N'' then ''No'' else ''N/A'' end as [CLSMedicalAppointments]
		,case when CPCA.[CLSMonitoringAndProtection] = ''Y'' then ''Yes'' when CPCA.[CLSMonitoringAndProtection] = ''N'' then ''No'' else ''N/A'' end as [CLSMonitoringAndProtection]
		,case when CPCA.[CLSMonitoringSelfAdministration] = ''Y'' then ''Yes'' when CPCA.[CLSMonitoringSelfAdministration] = ''N'' then ''No'' else ''N/A'' end as [CLSMonitoringSelfAdministration]
		,CPCA.[AverageCLSHoursPerDay] as [AverageCLSHoursPerDay]
		,CPCA.[CLSPerDiemRate] as [CLSPerDiemRate]		
FROM [CustomPersonalCareAssessment] CPCA 
join DocumentVersions dv on dv.DocumentVersionId=CPCA.DocumentVersionId
--join Documents ON  CPCA.DocumentId = Documents.DocumentId and isnull(Documents.RecordDeleted,''N'')<>''Y''               
join Documents ON  Documents.DocumentId = dv.DocumentId and isnull(Documents.RecordDeleted,''N'')<>''Y''  --Modified by Anuj Dated 03-May-2010   
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''      
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''  
Left Join GlobalCodes GC On GC.GlobalCodeId = S.Degree and isNull(GC.RecordDeleted,''N'')<>''Y''
--where CPCA .DocumentId = @DocumentId  
--and CPCA.Version = @Version      
where CPCA.DocumentVersionId= @DocumentVersionId  --Modified by Anuj Dated 03-May-2010      
--Checking For Errors                                            
If (@@error!=0)                                            
	Begin                                            
		RAISERROR  20006   ''[csp_RDLCustomAdequateNotice] : An Error Occured''                                             
		Return                                            
	End                                                     
End
' 
END
GO
