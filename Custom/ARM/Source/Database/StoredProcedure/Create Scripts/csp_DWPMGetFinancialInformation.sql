/****** Object:  StoredProcedure [dbo].[csp_DWPMGetFinancialInformation]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetFinancialInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMGetFinancialInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetFinancialInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */              
/* Stored Procedure: dbo.csp_DWPMGetFinancialInformation      */              
/* Copyright: 2007 Provider Access Application        */              
/* Creation Date:  20th-Aug-2007            */              
/*                   */              
/* Purpose: This stored procedure is the Second Retrieve Stored Procedure and is used for Access Center-Financial Information */             
/*                    */            
/* Input Parameters: @UserId ,@DataWizardInstanceId, @PreviousDataWizardInstanceId, @NextStepId,     
     @NextWizardId, @EventId, @ClientID, @ClientSearchGUID */              
/* Output Parameters:              */              
/*                   */              
/* Return:                 */              
/*                      */              
/* Called By:                */              
/*                      */              
/* Calls:                    */              
/*                      */              
/* Data Modifications:                                                      */              
/*                      */              
/*  Updates:                   */              
/*  Date   Author        Purpose                      */              
/*  20th-Aug-2007   Jatinder Singh             SP for Access Center-Financial Information   */              
/****************************************************************************/              
    
CREATE procedure [dbo].[csp_DWPMGetFinancialInformation]    
 @UserId int,    
 @DataWizardInstanceId int,    
 @PreviousDataWizardInstanceId int,    
 @NextStepId int,    
 @NextWizardId int,    
 @EventId int,    
 @ClientID int,    
 @ClientSearchGUID type_GUID    
as    
Declare @PreviousInformation varchar(8000)  
  
Begin Try    
 --All 3 queries are for dropdowns  
 Select 0 as GlobalCodeId,''Select type...'' as CodeName  
 Union All  
 Select GlobalCodeId,CodeName from globalCodes where Category=''ACCESSPLANS'' and isnull(RecordDeleted,''N'')=''N''
 and Active=''Y''     
  
 Select 0 as GlobalCodeId,''Select type...'' as CodeName  
 Union All  
 Select GlobalCodeId,CodeName from globalCodes where Category=''ACCESSPLANS'' and isnull(RecordDeleted,''N'')=''N''
 and Active=''Y''     
  
 Select 0 as GlobalCodeId,''Select type...'' as CodeName  
 Union All  
 Select GlobalCodeId,CodeName from globalCodes where Category=''ACCESSPLANS'' and isnull(RecordDeleted,''N'')=''N''
 and Active=''Y''     
 --Till here    
  
 --Last query will always be for the values in the table    
 IF Exists(select EventId from   CustomRiverwoodAccessCenter 
			where CustomRiverwoodAccessCenter.EventId = @EventId and isnull(RecordDeleted,''N'')=''Y'')    
 Begin    
  RAISERROR     
  (    
   ''Record Has been Deleted.'', -- Message text.    
   16, -- Severity.    
   1 -- State.    
  );    
 End    
  
 set @PreviousInformation=(select 
							char(13)
							+''Current Status: ''+ isnull((
													select g.CodeName from globalcodes g inner join
													clientepisodes ce  on g.globalcodeid=ce.status 
													where ce.clientid=@ClientId
												--
													and not exists (select 1 from ClientEpisodes as ce2 --axv added for 512 error returning more than one result set
																	where ce2.ClientId = @ClientId 
																	and ce2.EpisodeNumber > ce.EpisodeNumber
																	and isnull(ce2.RecordDeleted, ''N'') <> ''Y'') ),'' '')
							+char(13)
							+''Admit Date: ''+isnull(convert(varchar,(isnull((select max(admitdate) from clienthospitalizations 
																			where Clientid=@ClientId),Null)),101),'''')
							+char(13)
							+''Discharge Date: ''+isnull(convert(varchar,(isnull((select max(dateofservice) from services 
																				where Status in (71,75) and DateOfService < GetDate() 
																				and clientid=@ClientId),Null)),101),'''')
							+char(13)
							--+''Program: ''+p.programname
							--+char(13) 
							+''Primary Clinician: ''+(RTRIM(ISNULL((select s.lastname from staff s 
																inner join Clients c on s.staffid=c.primaryclinicianid
																where c.ClientId=@ClientId), '''')))
											+  '', '' + RTRIM(ISNULL((select s.firstName from staff s 
																inner join Clients c on s.staffid=c.primaryclinicianid
																where c.ClientId=@ClientId), ''''))
							+char(13)
							+''Last Appointment: ''+isnull(convert(varchar,(isnull((select max(dateofservice) from services 
																				where Status in (71,75) and DateOfService < GetDate() 
																				and clientid=@ClientId),Null)),101),'''')
							+char(13)
							+''Next Appointment: ''+isnull(convert(varchar,(isnull((select min(dateofservice) from services 
																				where Status=76 and DateOfService > GetDate() 
																				and clientid=@ClientId),Null) ),101),'''')
							+char(13)
							+''Axis I/II: ''+isnull((select max(Di.DSMCode) from DiagnosesIandII Di 
													inner join documents d on di.DocumentVersionId=d.CurrentDocumentVersionId
													and d.Clientid=@ClientId),'' '')
							+char(13)+char(13)
							+''Coverage : ''+isnull((select Top 1 CoveragePlanName from CoveragePlans cp 
													inner join ClientCoveragePlans ccp on cp.CoveragePlanid=ccp.CoveragePlanid 
													where ccp.Clientid=@ClientId ),'' ''))



	if(isnull(@PreviousInformation,'''')='''' or isnull(@ClientId,0)=0)  
		set @PreviousInformation=''No Previous Information found''  
  
 if exists(SELECT  EventId FROM CustomRiverwoodAccessCenter where CustomRiverwoodAccessCenter.EventId =@EventId)  
	Begin  
			  SELECT  EventId,    
			  ClientHasNoCoverage,    
			  FirstInsuranceType,     
			  FirstInsuranceName,     
			  FirstPolicyHolderName,     
			  FirstGroupNumber,     
			  FirstInsuredId,    
			  FirstInsuredPhone,    
			  @PreviousInformation as PreviousInformation,    
			  SecondInsuranceType,    
			  SecondInsuranceName,     
			  SecondPolicyHolderName,    
			  SecondGroupNumber,       
			  SecondInsuredId,    
			  SecondInsuredPhone,     
			  ThirdnsuranceType,    
			  ThirdInsuranceName,    
			  ThirdPolicyHolderName,    
			  ThirdGroupNumber,     
			  ThirdInsuredId,    
			  ThirdInsuredPhone,    
			  (Select EligibleForTreatment from eventscreens where EventId=@EventId) as EligibleForTreatment    
			  FROM    CustomRiverwoodAccessCenter     
			  where CustomRiverwoodAccessCenter.EventId =@EventId    
	End  
 Else  if exists(select EventId from eventscreens where EventId=@EventId )
	Begin  
			  SELECT  '''' as EventId,    
			  ''N'' as ClientHasNoCoverage,     --srf reset to ''N'' 10/1/2007
			  '''' as FirstInsuranceType,     
			  '''' as FirstInsuranceName,     
			  '''' as FirstPolicyHolderName,     
			  '''' as FirstGroupNumber,     
			  '''' as FirstInsuredId,    
			  '''' as FirstInsuredPhone,    
			  @PreviousInformation as PreviousInformation,    
			  '''' as SecondInsuranceType,    
			  '''' as SecondInsuranceName,     
			  '''' as SecondPolicyHolderName,    
			  '''' as SecondGroupNumber,       
			  '''' as SecondInsuredId,    
			  '''' as SecondInsuredPhone,     
			  '''' as ThirdnsuranceType,    
			  '''' as ThirdInsuranceName,    
			  '''' as ThirdPolicyHolderName,    
			  '''' as ThirdGroupNumber,     
			  '''' as ThirdInsuredId,    
			  '''' as ThirdInsuredPhone,    
			  EligibleForTreatment  
				  from eventscreens where EventId=@EventId  
    
	End  
  else if(isnull(@EventId,0)=0)
      Begin
			SELECT  '''' as EventId,    
			  ''N'' as ClientHasNoCoverage,    --srf reset to ''N'' 10/1/2007
			  '''' as FirstInsuranceType,     
			  '''' as FirstInsuranceName,     
			  '''' as FirstPolicyHolderName,     
			  '''' as FirstGroupNumber,     
			  '''' as FirstInsuredId,    
			  '''' as FirstInsuredPhone,    
			  @PreviousInformation as PreviousInformation,    
			  '''' as SecondInsuranceType,    
			  '''' as SecondInsuranceName,     
			  '''' as SecondPolicyHolderName,    
			  '''' as SecondGroupNumber,       
			  '''' as SecondInsuredId,    
			  '''' as SecondInsuredPhone,     
			  '''' as ThirdnsuranceType,    
			  '''' as ThirdInsuranceName,    
			  '''' as ThirdPolicyHolderName,    
			  '''' as ThirdGroupNumber,     
			  '''' as ThirdInsuredId,    
			  '''' as ThirdInsuredPhone,    
			  '''' as EligibleForTreatment  
	  End

End Try    
    
Begin Catch    
 declare @Error varchar(8000)                
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                 
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMGetFinancialInformation'')                 
 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                  
 + ''*****'' + Convert(varchar,ERROR_STATE())                
               
 RAISERROR                 
 (                
  @Error, -- Message text.                
  16, -- Severity.                
  1 -- State.                
 );  
    
End Catch
' 
END
GO
