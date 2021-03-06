/****** Object:  StoredProcedure [dbo].[csp_DWPMGetCallInformation]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetCallInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMGetCallInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMGetCallInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */                
/* Stored Procedure: dbo.csp_DWPMGetCallInformation      */                
/* Copyright: 2007 Provider Access Application        */                
/* Creation Date:  20th-Aug-2007            */                
/*                   */                
/* Purpose: This stored procedure is the First Retrieve Stored Procedure and is used for Access Center */               
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
/*  20th-Aug-2007   Jatinder Singh             First SP for Access Center   */   
/*  13th-Sep-2007   Pratap Singh              added conditions for clientid & Previous information */                 
/****************************************************************************/                

CREATE procedure [dbo].[csp_DWPMGetCallInformation]--128,153,0,1,0,0,100,Null      
	@UserId int,      
	@DataWizardInstanceId int,      
	@PreviousDataWizardInstanceId int,      
	@NextStepId int,      
	@NextWizardId int,      
	@EventId int,      
	@ClientID int,      
	@ClientSearchGUID type_GUID      
as      
	Declare @TestGuid type_guid  
	Declare @PreviousInformation varchar(8000)  
Begin Try    
	set @TestGuid=newid()  
	
	--All 5 queries are for dropdowns      
	--First Query is to fill the Relation Dropdown      
		select 0 as GlobalCodeId,'''' as CodeName      
		union all      
		Select GlobalCodeId,CodeName from globalCodes where Category=''RELATIONSHIP''  and isnull(RecordDeleted,''N'')=''N''   
		AND Active=''Y''  

	--Second Query is to fill the State Dropdown      
		select 0 as StateFIPS,'''' as StateName      
		union all      
		Select StateFIPS,StateName from States      

	--Third Query is to fill the County (COFR) Dropdown      
	--if the state value does not exists in the EventScreens table then do not select any County      
	IF(not exists (select state from EventScreens where EventId=@EventId and isnull(RecordDeleted,''N'')=''N'' ))      
		Select CountyFIPS,CountyName from counties where StateFIPS=0      
	ELSE --else If the State value exists in the EventScreens for selected Event then select the county on that basis      
		select 0 as CountyFIPS,'''' as CountyName      
		union all      
		Select CountyFIPS,CountyName from counties where StateFIPS=(select state from EventScreens
		where EventId=@EventId)      

	--Fourth Query is to fill the Client Sex Dropdown      
		select ''0'' as CodeName,'''' as CodeName      
		union all      
		Select CodeName,CodeName from globalCodes where Category=''SEX''  and isnull(RecordDeleted,''N'')=''N''
		AND Active=''Y''    

	

	--Fifth Query is to fill the Reason Dropdown      
		select 0 as GlobalCodeId,'''' as CodeName      
		union all      
		Select GlobalCodeId,CodeName from globalCodes where Category=''ACCESSREASON''   and isnull(RecordDeleted,''N'')=''N'' 
		AND Active=''Y''    
	--Till here      


	IF exists( SELECT  EventId FROM    EventScreens   where EventId = @EventId  and isnull(RecordDeleted,''N'')=''Y'')    
		Begin    
			RAISERROR     
			(    
				''Record Has been Deleted.'', -- Message text.    
				16, -- Severity.    
				1 -- State.    
			);    
		End    
	--select convert(varchar,(isnull((select max(admitdate) from clienthospitalizations where Clientid=999999),Null)),101)

	Set @PreviousInformation=(select 
			char(13)+ 
			''Current Status: ''+ 
			isnull((select g.CodeName from globalcodes g inner join
										clientepisodes ce  on g.globalcodeid=ce.status 
											and isnull(ce.RecordDeleted,''N'')<>''Y'' --av to correct if a client episode is deleted
										where ce.clientid=@ClientId
											and not exists (select * from ClientEpisodes as ce2 --axv added for 512 error returning more than one result set
											where ce2.ClientId = @ClientId and ce2.EpisodeNumber > ce.EpisodeNumber
											and isnull(ce2.RecordDeleted, ''N'') <> ''Y'') ),'' '')+
			char(13)+ 
			''Admit Date: ''+
			isnull(convert(varchar,(isnull((select max(admitdate) from clienthospitalizations 
											where Clientid=@ClientId),Null)),101),'''')+
			char(13)+  
			''Discharge Date: ''+isnull(convert(varchar,(isnull((select max(dateofservice) from services 
																where Status in (71,75) and DateOfService < GetDate() 
																and clientid=@ClientId),Null)),101),'''')+
			char(13)+ 
			--''Program: ''+p.programname+char(13)+  
			''Primary Clinician: ''+
			(RTRIM(ISNULL((select s.lastname from staff s 
							inner join Clients c on s.staffid=c.primaryclinicianid
							where c.ClientId=@ClientId), '''')))+  '', '' + RTRIM(ISNULL((select s.firstName from staff s 
																						inner join Clients c on s.staffid=c.primaryclinicianid
																						where c.ClientId=@ClientId), ''''))+
			char(13)+ 
			''Last Appointment: ''+
			isnull(convert(varchar,(isnull((select max(dateofservice) from services 
											where Status in (71,75) and DateOfService < GetDate() 
											and clientid=@ClientId),Null)),101),'''')+
			char(13)+
			''Next Appointment: ''+
			isnull(convert(varchar,(isnull((select min(dateofservice) from services 
											where Status=70 and DateOfService > GetDate() 
											and clientid=@ClientId),Null) ),101),'''')+
			char(13)+
			''Axis I/II: ''+isnull((select max(Di.DSMCode) from DiagnosesIandII Di 
									inner join documents d  on di.DocumentVersionId=D.CurrentDocumentVersionId   
									and d.Clientid=@ClientId),'' '')+
			char(13)+char(13)+
			''Coverage : ''+
			isnull((select Top 1 CoveragePlanName from CoveragePlans cp 
					inner join ClientCoveragePlans ccp on cp.CoveragePlanid=ccp.CoveragePlanid 
					where ccp.Clientid=@ClientId ),'' ''))


	--select * from globalCodes
	IF(isnull(@PreviousInformation,'''')='''' or isnull(@ClientId,0)=0)  
		set @PreviousInformation=''No Previous Information found''  

		print @PreviousInformation

	--Last query will always be for displaying the data  
	-- Condition for clientid to display previous information of client   
	IF (isnull(@clientid,0)<>0 and isnull(@ClientSearchGUID,@TestGuid)=@TestGuid) 
		Begin 
			IF(isnull(@EventId,0)<>0)  
			   Begin  
						IF(exists (Select EventId from EventScreens where EventId=@EventId) and (@ClientId=(Select ClientId 
									from Events where EventId=@EventId)))  
										Begin  
											SELECT  EventId, CallerFirstName, CallerLastName, CallBackPhoneNumber,   
											 CallerRelation,@PreviousInformation as PreviousInformation, ClientFirstName, ClientLastName,	
											 Address1, Address2, City, State, Zip, CountyOfResidence,    
											 ClientSex,(select Convert(varchar,ClientDOB,101)) as ClientDOB,   
											 ClientSSN, ClientHomePhone,ClientWorkPhone, ClientCellPhone,   
											 CallReason, CallReasonDescription, EligibleForTreatment   
											 from EventScreens where EventId = @EventId   
									    End  
                
		         
	               			ELSE  
								Begin  
	                  
									SELECT  e.EventId, e.CallerFirstName, e.CallerLastName, e.CallBackPhoneNumber,   
									 e.CallerRelation, @PreviousInformation as PreviousInformation, c.FirstName, c.LastName,
									 e.Address1, e.Address2, e.City, e.State, e.Zip, e.CountyOfResidence,    
									 c.Sex,(select Convert(varchar,c.DOB,101)) as ClientDOB,   
									 c.SSN, e.ClientHomePhone,e.ClientWorkPhone, e.ClientCellPhone,   
									 e.CallReason, e.CallReasonDescription, e.EligibleForTreatment from EventScreens e  
									 right outer join Clients c on c.ClientId=@ClientID where e.EventId = @EventId   
								End  
				End  
			ELSE  
					Begin  
						SELECT  '''' as EventId, '''' as CallerFirstName,'''' as CallerLastName, '''' as CallBackPhoneNumber,   
						 '''' as CallerRelation, @PreviousInformation as PreviousInformation, c.FirstName, c.LastName, --av corrected lastname
						 '''' as Address1, '''' as Address2, '''' as City, '''' as State, '''' as Zip, c.CountyOfResidence,    
						 c.Sex, (select Convert(varchar,c.DOB,101)) as ClientDOB,   
						 c.SSN, '''' as ClientHomePhone,'''' as ClientWorkPhone, '''' as ClientCellPhone,       
						 '''' as CallReason, '''' as CallReasonDescription, '''' as EligibleForTreatment from Clients c 
						 where c.ClientId=@ClientId  
					End  
	End

	-- Data will fetch from EventScreen & ClientsearchData tables    
	IF (isnull(@clientid,0)=0 and isnull(@ClientSearchGUID,@TestGuid )<> @TestGuid)  
		Begin  
			SELECT  EventId, CallerFirstName, CallerLastName, CallBackPhoneNumber, CallerRelation,    
			@PreviousInformation as PreviousInformation ,  
			(select FirstName from clientsearchdata where ClientSearchDataId=@ClientSearchGUID),  
			(select LastName from clientsearchdata where ClientSearchDataId=@ClientSearchGUID),  		
			(select Address1 from clientsearchdata where ClientSearchDataId=@ClientSearchGUID),    
			(select Address2 from clientsearchdata where ClientSearchDataId=@ClientSearchGUID),  
			 e.City, e.State, e.Zip, e.CountyOfResidence,e.ClientSex,
			(select Convert(varchar,DOB,101) from clientsearchdata where ClientSearchDataId=@ClientSearchGUID ) 
			 as ClientDOB,
			(select SSN from clientsearchdata where ClientSearchDataId=@ClientSearchGUID),  
			 (select PhoneNumber from clientsearchdata where ClientSearchDataId=@ClientSearchGUID),
			 e.ClientWorkPhone, e.ClientCellPhone,e.CallReason, e.CallReasonDescription,
			 e.EligibleForTreatment from EventScreens e where e.EventId = @EventId   
		End  


	IF (isnull(@clientid,0)=0 and isnull(@ClientSearchGUID,@TestGuid)= @TestGuid and isnull(@EventId,0)=0)   
		Begin  
				
			SELECT '''' as EventId, '''' as CallerFirstName, '''' as CallerLastName, '''' as CallBackPhoneNumber, '''' as	CallerRelation,    
			@PreviousInformation as PreviousInformation, '''' as ClientFirstName, '''' as ClientLastName, 
			'''' as Address1, '''' as Address2, '''' as City, '''' as State, '''' as Zip, '''' as CountyOfResidence,
			'''' as ClientSex, '''' as ClientDOB, '''' as ClientSSN,
			'''' as ClientHomePhone, '''' as ClientWorkPhone, '''' as ClientCellPhone,       
			'''' as CallReason, '''' as CallReasonDescription, '''' as EligibleForTreatment  
			    
		End -- Data will fetch from EventScreen tables    
	ELSE IF (isnull(@clientid,0)=0 and isnull(@ClientSearchGUID,@TestGuid)= @TestGuid)   
		Begin  
				
			SELECT  EventId, CallerFirstName, CallerLastName, CallBackPhoneNumber, CallerRelation,    
			@PreviousInformation as PreviousInformation, ClientFirstName, ClientLastName, 
			Address1, Address2, City, State, Zip, CountyOfResidence,
			ClientSex, (select Convert(varchar,ClientDOB,101)) as ClientDOB, ClientSSN,
			ClientHomePhone, ClientWorkPhone, ClientCellPhone,       
			CallReason, CallReasonDescription, EligibleForTreatment  
			FROM EventScreens where EventId = @EventId      
		End  
	


End Try    
Begin Catch    
	declare @Error varchar(8000)    
	set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())     
	+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMGetCallInformation'')     
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
