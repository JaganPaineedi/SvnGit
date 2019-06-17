/****** Object:  StoredProcedure [ssp_InsertValidateBatchClaims]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_InsertValidateBatchClaims]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_InsertValidateBatchClaims]
GO

/****** Object:  StoredProcedure [ssp_InsertValidateBatchClaims]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
--This is the Stored Procedure  
CREATE PROCEDURE [dbo].[ssp_InsertValidateBatchClaims]  
(  
-- which accepts one table value parameter.   
-- It should be noted that the parameter is readonly  
@ClaimsDataTable As [dbo].[BatchClaimType] Readonly  ,
@FileName varchar(500),
@StaffId int,
@ProviderId int
)  
/*********************************************************************/                                              
-- Stored Procedure: dbo.ssp_InsertValidateBatchClaims                                                              
-- Copyright: Streamline Healthcate Solutions                                                            
-- Creation Date:  08/22/2016                                                                               
--                                                                                                                 
-- Purpose: It will Validate and insert uploaded excel data                                                   
--                                                                                                               
-- Input Parameters:                                                     
--                                                                                                               
-- Output Parameters:                                                                             
--                                                                                                                
-- Return:  */                                              
--                                                                                                                 
-- Called By:                                                                                                     
--                                                                                                                 
-- Calls:                                                                                                          
--                                                                                                                 
-- Data Modifications:                                                                                            
--                                                                                                                 
-- Updates:                                                                                                        
-- Date         Author			Purpose                                                                               
-- 05/08/2016   Varun/gautam    Created ,Ref #73  Network180-Customizations.    
-- 07/13/2018   jcarlson    Partner Solutions SGL 53 - Added missing place of service validation  
-- 09/07/2018	Nandita		 Partner Solutions- Customizations Task #28 > Batch Claim Upload: Need to add additional fields to support BH Redesign               
/*********************************************************************/ 
AS  
  Begin  
  Begin Try
  
  Declare @StatusWarning int,@StatusValid int,@ClaimBatchUploadId int
  DEclare @InsurerId int,@Usercode varchar(100)
  Declare  @IsDiagnosis1 char(1),  
  @IsDiagnosis2 char(1),  
  @IsDiagnosis3 char(1),  
  @Diagnosis1 varchar(10),  
  @Diagnosis2 varchar(10),  
  @Diagnosis3 varchar(10), 
  @DiagnosisAdmission varchar(10),  
  @DiagnosisPrincipal varchar(10),  
  @DOSFrom datetime,   
 @ClaimType int,
 @RowId int

         
  Select top 1 @Usercode=UserCode from Staff where StaffId=@StaffId
  Select top 1 @StatusWarning=GlobalCodeId from GlobalCodes where Category='BatchClaimBtchStatus' AND Code='WARNING' 
															and ISNULL(RecordDeleted,'N')='N'
  Select top 1 @StatusValid=GlobalCodeId from GlobalCodes where Category='BatchClaimBtchStatus' AND Code='VALID' 
															and ISNULL(RecordDeleted,'N')='N'
declare @Diagnoses table (  
  DiagnosisCode varchar(20),  
  IsValid char(1),  
  LevelOfImportance char(1),  
  ValidationType varchar(10))  
  															
-- We simply insert values into the DB table from the parameter  
-- The table value parameter can be used like a table with only read rights  
Create Table #TempClaimBatchDirect
(	RowId Int identity(1,1),
    CreatedBy	varchar(30),
    CreatedDate	datetime,
    ModifiedBy	varchar(30),
    ModifiedDate datetime,		
    ClaimLineId	int,
	InsurerId	int	,
	SiteId	int	,
	ClientId int,
	RenderingProviderId	int	,
	FromDate datetime,
	ToDate	datetime,
	StartTime	datetime,
	EndTime	datetime	,
	BillingCode varchar(20),
	BillingCodeId int,
	BillingCodeModifier1 varchar(10),  
    BillingCodeModifier2 varchar(10), 
    BillingCodeModifier3 varchar(10), 
    BillingCodeModifier4 varchar(10), 
	Units decimal(18,2),
	Charge	 	[money],
	PlaceOfService	int,
	Diagnosis1 varchar(10),  
    Diagnosis2 varchar(10),
    Diagnosis3 varchar(10),
	RenderingProviderName	varchar(100),
	PreviousPayer1	varchar(100),
	AllowedAmount1	[money],
	PaidAmount1	[money],
	AdjustmentAmount1	[money],
	AdjustmentGroupCode1 int,
	AdjustmentReason1	int,
	PreviousPayer2	varchar(100),
	AllowedAmount2	[money],
	PaidAmount2	 	[money],
	AdjustmentAmount2	[money],
	AdjustmentGroupCode2 int,
	AdjustmentReason2	int,
	Warning	   varchar(500),
	BatchStatus	INT,
	OrderingProviderId INT,
	SupervisingProviderId INT,
	OrderingProviderNPI VARCHAR(10),
	SupervisingProviderNPI VARCHAR(10),
	NDC VARCHAR(35),
	NDCUnit DECIMAL,
	NDCUnitType VARCHAR(15)
	)

	
Insert Into #TempClaimBatchDirect(
		[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[ClaimLineId]  
      ,[InsurerId]  
      ,[SiteId]  
      ,[ClientId]  
      ,[RenderingProviderId]  
      ,[FromDate]  
      ,[ToDate]  
      ,[StartTime]  
      ,[EndTime]  
      ,BillingCode
      ,BillingCodeId
      ,[BillingCodeModifier1]  
      ,[BillingCodeModifier2]  
      ,[BillingCodeModifier3]  
      ,[BillingCodeModifier4]  
      ,[Units]  
      ,[Charge]  
      ,[PlaceOfService]  
      ,Diagnosis1 
    ,Diagnosis2 
    ,Diagnosis3 
      ,[RenderingProviderName]  
      ,[PreviousPayer1]  
      ,[AllowedAmount1]  
      ,[PaidAmount1]  
      ,[AdjustmentAmount1]  
      ,[AdjustmentGroupCode1]  
      ,[AdjustmentReason1]  
      ,[PreviousPayer2]  
      ,[AllowedAmount2]  
      ,[PaidAmount2]  
      ,[AdjustmentAmount2]  
      ,[AdjustmentGroupCode2]  
      ,[AdjustmentReason2]
		,OrderingProviderNPI
		,SupervisingProviderNPI
		,NDC 
		,NDCUnit 
		,NDCUnitType)  
  
Select C.[CreatedBy]  
      ,C.[CreatedDate]  
      ,C.[ModifiedBy]  
      ,C.[ModifiedDate]   
      ,C.[ClaimLineId]  
      ,C.[InsurerId]  
      ,C.[SiteId]  
      ,C.[ClientId]  
      ,C.[RenderingProviderId]  
      ,C.[FromDate]  
      ,C.[ToDate]  
      ,C.[StartTime]  
      ,C.[EndTime]  
      ,C.BillingCode
      ,P.BillingCodeId
      ,C.[BillingCodeModifier1]  
      ,C.[BillingCodeModifier2]  
      ,C.[BillingCodeModifier3]  
      ,C.[BillingCodeModifier4]  
      ,C.[Units]  
      ,C.[Charge]  
      ,C.[PlaceOfService]  
      ,C.Diagnosis1 
		,C.Diagnosis2 
		,C.Diagnosis3 
      ,C.[RenderingProviderName]  
      ,C.[PreviousPayer1]  
      ,C.[AllowedAmount1]  
      ,C.[PaidAmount1]  
      ,C.[AdjustmentAmount1]  
      ,C.[AdjustmentGroupCode1]  
      ,C.[AdjustmentReason1]  
      ,C.[PreviousPayer2]  
      ,C.[AllowedAmount2]  
      ,C.[PaidAmount2]  
      ,C.[AdjustmentAmount2]  
      ,C.[AdjustmentGroupCode2]  
      ,C.[AdjustmentReason2] 
	  ,C.OrderingProviderNPI
	  ,C.SupervisingProviderNPI
	  ,C.NDC
	  ,C.NDCUnit
	  ,C.NDCUnitType  
       From @ClaimsDataTable C 
		Left Join BillingCodes P On C.BillingCode= P.BillingCode AND isnull(P.RecordDeleted,'N')  ='N'  


UPDATE TCB SET TCB.OrderingProviderId=S.ProviderId FROM #TempClaimBatchDirect TCB
JOIN dbo.Sites S ON s.NationalProviderId=TCB.OrderingProviderNPI
JOIN dbo.Providers P ON P.ProviderId=S.ProviderId
WHERE ISNULL(s.RecordDeleted,'N')='N' AND ISNULL(P.RecordDeleted,'N')='N'

UPDATE TCB SET TCB.SupervisingProviderId=S.ProviderId FROM #TempClaimBatchDirect TCB
JOIN dbo.Sites S ON s.NationalProviderId=TCB.SupervisingProviderNPI
JOIN dbo.Providers P ON P.ProviderId=S.ProviderId
WHERE ISNULL(s.RecordDeleted,'N')='N' AND ISNULL(P.RecordDeleted,'N')='N'
 
  -- warning for siteIds in the upload is related to the selected Provider @ProviderID
  Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'SiteId in the uploaded file is not related to the selected Provider' else
							TCB.[Warning] + ', SiteId in the uploaded file is not related to the selected Provider' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[SiteId],'') <> '' 
  and not exists(Select 1 from Sites C where C.SiteId=TCB.[SiteId] and c.ProviderId=@ProviderID and Isnull(C.RecordDeleted,'N')='N')
  
  
 -- If Claim is already saved in Claims & ClaimLines 
 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Claim already entered for this InsurerId, SiteId, BillingCode for this date of service' else
							TCB.[Warning] + ', Claim already entered for this InsurerId, SiteId, BillingCode for this date of service' end
								, TCB.[BatchStatus]  =@StatusWarning
								, TCB.ClaimLineId= CL1.ClaimLineId
 From #TempClaimBatchDirect TCB  join Claims C1 on C1.Clientid = TCB.Clientid        
					INNER JOIN ClaimLines CL1 ON C1.ClaimId = CL1.ClaimId  
  Where  TCB.[Warning] is null and
		C1.SiteId = TCB.SiteID    
	  AND C1.InsurerId = TCB.InsurerId  
	 AND CL1.billingcodeid = TCB.BillingCodeID    
				   AND CL1.RenderingProviderId = TCB.RenderingProviderId 
				   AND TCB.FromDate BETWEEN CL1.Fromdate     
				   AND isnull(CL1.Todate, getdate())     
				   AND TCB.ToDate BETWEEN CL1.Fromdate AND isnull(CL1.Todate, getdate())     
				   AND isnull(C1.Recorddeleted, 'N') = 'N' AND isnull(CL1.Recorddeleted, 'N')='N'
  and exists(Select 1 from Claims C     
					INNER JOIN ClaimLines CL ON C.ClaimId = CL.ClaimId  
				WHERE C.Clientid = TCB.Clientid     
				   AND C.SiteId = TCB.SiteID    
				   AND C.InsurerId = TCB.InsurerId 
				   AND CL.billingcodeid = TCB.BillingCodeID    
				   AND CL.RenderingProviderId = TCB.RenderingProviderId 
				   AND TCB.FromDate BETWEEN CL.Fromdate     
				   AND isnull(CL.Todate, getdate())     
				   AND TCB.ToDate BETWEEN CL.Fromdate AND isnull(CL.Todate, getdate())     
				   AND isnull(C.Recorddeleted, 'N') = 'N' AND isnull(CL.Recorddeleted, 'N')='N' )   
				   
 -- Update duplicate warning if data is already uploaded
 Update TCBD
 Set TCBD.[Warning]='Duplicate - Records Already Uploaded',TCBD.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCBD join ( 
  Select RowId,[InsurerId] ,[SiteId],[ClientId] ,[FromDate] ,[ToDate]  
      ,[StartTime] ,[EndTime] ,BillingCode,[BillingCodeModifier1],[BillingCodeModifier2],[BillingCodeModifier3],[BillingCodeModifier4]
  From #TempClaimBatchDirect  TCB
  where  TCB.[Warning] is null and
     exists(Select 1 from ClaimBatchDirectEntries CBD where ISNULL(CBD.RecordDeleted,'N')='N' and
							isnull(TCB.[InsurerId],'')=isnull(CBD.[InsurerId],'') and isnull(TCB.[SiteId],'')=isnull(CBD.[SiteId],'') and
							isnull(TCB.[ClientId],'')=isnull(CBD.[ClientId],'') and isnull(TCB.[FromDate],'')=isnull(CBD.[FromDate],'')
							and ISnull(TCB.[ToDate],'')=isnull(CBD.[ToDate],'') and isnull(TCB.[StartTime],'')=isnull(CBD.[StartTime] ,'')
							 and isnull(TCB.[EndTime],'')=isnull(CBD.[EndTime],'')and isnull(TCB.[BillingCode],'')=isnull(CBD.[BillingCode],'') and 
							isnull(TCB.[BillingCodeModifier1],'')=isnull(CBD.[BillingCodeModifier1],'') and
							isnull(TCB.[BillingCodeModifier2],'')=isnull(CBD.[BillingCodeModifier2],'') 
							and isnull(TCB.[BillingCodeModifier3],'')=isnull(CBD.[BillingCodeModifier3],'')
							and isnull(TCB.[BillingCodeModifier4],'')=isnull(CBD.[BillingCodeModifier4],'')))TCTemp
	on TCBD.RowId=TCTemp.RowId
 
  

  -- Update Warnings if any excel entry is duplicate
 Update TCB
 Set TCB.[Warning]= 'Duplicate Entry', TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  Join ( 
	Select RowId, [RankOrder] from (
  Select RowId,[InsurerId] ,[SiteId],[ClientId] ,[FromDate] ,[ToDate]  
      ,[StartTime] ,[EndTime] ,BillingCode,[BillingCodeModifier1],[BillingCodeModifier2],[BillingCodeModifier3],[BillingCodeModifier4],
      row_number() OVER ( PARTITION BY [InsurerId] ,[SiteId],[ClientId] ,[FromDate] ,[ToDate]  
      ,[StartTime] ,[EndTime] ,BillingCode,[BillingCodeModifier1],[BillingCodeModifier2],[BillingCodeModifier3],[BillingCodeModifier4]
       order by [InsurerId] ,[SiteId],[ClientId]) as [RankOrder]
  From #TempClaimBatchDirect  ) TCBTemp where [RankOrder]>= 2) TCBTemp2  on TCB.RowId=TCBTemp2.RowId
  Where TCB.[Warning] is null
  
   -- Update Warnings if ClientId,[InsurerId],[SiteId],[FromDate] ,[ToDate]
 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'ClientId Missing' else
							TCB.[Warning] + ', ClientId Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[ClientId],'') ='' 
  
 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'Place Of Service Missing' else
							TCB.[Warning] + ', Place Of Service Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[PlaceOfService],'') ='' 
  
 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'InsurerId Missing' else
							TCB.[Warning] + ', InsurerId Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[InsurerId],'') =''  

 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'SiteId Missing' else
							TCB.[Warning] + ', SiteId Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[SiteId],'') =''  

 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'FromDate Missing' else
							TCB.[Warning] + ', FromDate Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[FromDate],'') =''
  
 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'ToDate Missing' else
							TCB.[Warning] + ', ToDate Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.ToDate,'') =''

 Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'Diagnosis Missing' else
							TCB.[Warning] + ', Diagnosis Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[Diagnosis1],'') ='' and ISNULL(TCB.[Diagnosis2],'') ='' and ISNULL(TCB.[Diagnosis3],'') =''
 
  Update TCB
 Set TCB.[Warning]=  case when TCB.[Warning] is null then 'BillingCode Missing' else
							TCB.[Warning] + ', BillingCode Missing' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where ISNULL(TCB.[BillingCode],'') ='' 
  
Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'ClientId is not valid' else
							TCB.[Warning] + ', ClientId is not valid' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where (ISNULL(TCB.[ClientId],'') <> '' 
  and not exists(Select 1 from Clients C where C.ClientId=TCB.[ClientId] and Isnull(C.RecordDeleted,'N')='N'))
 
 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Place Of Service is not valid' else
							TCB.[Warning] + ', Place Of Service is not valid' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where (ISNULL(TCB.[PlaceOfService],'') <> '' 
  and not exists(Select 1 
				 from GlobalCodes gc 
				 where gc.GlobalCodeId = TCB.[PlaceOfService]
					and gc.Category = 'PCMPLACEOFSERVICE'
					and Isnull(gc.RecordDeleted,'N')='N'))
  
 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'InsurerId is not valid' else
							TCB.[Warning] + ', InsurerId is not valid' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where (ISNULL(TCB.[InsurerId],'') <> '' 
  and not exists(Select 1 from Insurers C where C.InsurerId=TCB.[InsurerId] and Isnull(C.RecordDeleted,'N')='N'))
           	
 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'SiteId is not valid' else
							TCB.[Warning] + ', SiteId is not valid' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where (ISNULL(TCB.[SiteId],'') <> '' 
  and not exists(Select 1 from Sites C where C.SiteId=TCB.[SiteId] and Isnull(C.RecordDeleted,'N')='N'))
 
 
 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'RenderingProviderId is not valid' else
							TCB.[Warning] + ', RenderingProviderId is not valid' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where (ISNULL(TCB.[RenderingProviderId],'') <> '' 
  and not exists(Select 1 from Providers C where C.ProviderId=TCB.[RenderingProviderId] and Isnull(C.RecordDeleted,'N')='N'))
  
 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'From Date should not be greater than To Date' else
							TCB.[Warning] + ', From Date should not be greater than To Date' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  Where DateDiff(D,TCB.[ToDate], TCB.[FromDate]) >= 1
    
   
 ---- -- Validate diagnosis codes  
 -- DECLARE cur_BatchesProcessValidateClaims CURSOR FAST_FORWARD FOR
	--		SELECT Row,InsurerId,FromDate,DiagnosisPrincipal,DiagnosisAdmission,isnull(Diagnosis1, 'N'),
	--				isnull(Diagnosis2, 'N'),isnull(Diagnosis3, 'N'),Diagnosis1, Diagnosis2,Diagnosis3 
	--		FROM #TempClaimBatchDirect 
	--		where ISNULL(InsurerId,'') <> '' and isnull(FromDate,'') <> '' 
	--			and (ISNULL(Diagnosis1,'') <> '' or ISNULL(Diagnosis2,'') <> '' or ISNULL(Diagnosis3,'') <> '')

	--		OPEN cur_BatchesProcessValidateClaims

	--		FETCH cur_BatchesProcessValidateClaims
	--		INTO  
	--		@Row,@InsurerId, @DOSFrom ,@IsDiagnosis1,@IsDiagnosis2,@IsDiagnosis3 ,@Diagnosis1, @Diagnosis2,  @Diagnosis3,  
 --             @DiagnosisAdmission, @DiagnosisPrincipal

	--		WHILE @@FETCH_STATUS = 0
	--		BEGIN
				
	--			 insert  into @Diagnoses  
 --             (DiagnosisCode,  
 --              IsValid,  
 --              LevelOfImportance,  
	--			ValidationType)  
 --             exec dbo.ssp_CMValidateClaimLineDiagnosisCodes   
 --               @InsurerId = @InsurerId,  
 --               @FromDate = @DOSFrom,  
 --               @ClaimType = 2221,  
 --               @DiagnosisPrincipal = @DiagnosisPrincipal,  
 --               @DiagnosisAdmission = @DiagnosisAdmission,  
 --               @Diagnosis1 = @Diagnosis1,  
 --               @Diagnosis2 = @Diagnosis2,  
 --               @Diagnosis3 = @Diagnosis3,  
 --               @IsDiagnosis1 = @IsDiagnosis1,  
 --               @IsDiagnosis2 = @IsDiagnosis2,  
 --               @IsDiagnosis3 = @IsDiagnosis3  
                
 --               if exists ( select  *  
 --                     from    @Diagnoses  
 --                     where   IsValid = 'N' )   
	--				Begin
	--					Update TCB
	--					Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Diagnosis is not valid' else
	--							TCB.[Warning] + ', Diagnosis is not valid' end
	--								, TCB.[BatchStatus]  =@StatusWarning
	--					From #TempClaimBatchDirect TCB  
	--					Where Row=@Row
	--				end
					
					--delete from @Diagnoses
					
	--			FETCH cur_BatchesProcessValidateClaims
	--			INTO @Row,@InsurerId, @DOSFrom ,@IsDiagnosis1,@IsDiagnosis2,@IsDiagnosis3 ,@Diagnosis1, @Diagnosis2,  @Diagnosis3,  
	--				@DiagnosisAdmission, @DiagnosisPrincipal
	--		END

		

	--CLOSE cur_BatchesProcessValidateClaims

	--DEALLOCATE cur_BatchesProcessValidateClaims
	
    
                
 --exec ssp_CMValidateClaimLineDiagnosisCodes @InsurerId=1,@FromDate=N'2/14/2015 12:00:00 AM',@ClaimType=2221,@DiagnosisPrincipal=NULL,@DiagnosisAdmission=NULL,@Diagnosis1=N'317',@Diagnosis2=NULL,@Diagnosis3=NULL,@IsDiagnosis1=N'Y',@IsDiagnosis2=N'',@IsDiagnosis3=N''


 -- update rest of the record with Valid status
 Update TCB
 Set TCB.[BatchStatus]  =@StatusValid
 From #TempClaimBatchDirect TCB  
 Where ISNULL(TCB.[Warning],'') = ''

  Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Ordering Provider is not associated to the billing provider' else
							TCB.[Warning] + ', Ordering Provider is not associated to the billing provider' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB join Sites s on s.SiteId = TCB.SiteId  
  Where ISNULL(TCB.[SiteId],'') <> ''  AND TCB.OrderingProviderId IS NOT NULL
  and not exists(select  1 FROM   ProviderAffiliates pa
				WHERE   isnull(pa.RecordDeleted, 'N') = 'N' AND  pa.ProviderId = s.ProviderId AND pa.AffiliateProviderId = TCB.OrderingProviderId)

 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Ordering Provider cannot be found' else
							TCB.[Warning] + ', Ordering Provider cannot be found' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB   
  Where ISNULL(TCB.OrderingProviderNPI,'') <> '' AND tcb.OrderingProviderId IS NULL

   
  Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Supervising Provider is not associated to the billing provider' else
							TCB.[Warning] + ', Supervising Provider is not associated to the billing provider' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB join Sites s on s.SiteId = TCB.SiteId  
  Where ISNULL(TCB.[SiteId],'') <> '' AND TCB.SupervisingProviderId IS NOT NULL
  and not exists(select  1 FROM   ProviderAffiliates pa
				WHERE   isnull(pa.RecordDeleted, 'N') = 'N' AND  pa.ProviderId = s.ProviderId AND pa.AffiliateProviderId = TCB.SupervisingProviderId)


 Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'Supervising Provider cannot be found' else
							TCB.[Warning] + ', Supervising Provider cannot be found' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB   
  Where ISNULL(TCB.SupervisingProviderNPI,'') <> '' AND tcb.SupervisingProviderId IS NULL

   Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'NDC is not a valid drug' else
							TCB.[Warning] + ', NDC is not a valid drug' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  WHERE EXISTS(Select 1 from dbo.ClaimLineDrugs C where C.ClaimLineId=TCB.ClaimLineId AND c.NationalDrugCode= TCB.NDC AND Isnull(C.RecordDeleted,'N')='N' AND TCB.NDC IS NOT NULL)
    and not exists ( select *
                        from   ClaimLineDrugs C
                        where  C.ClaimLineId = TCB.ClaimLineId
                               and C.NationalDrugCode = TCB.NDC
                               and isnull(C.RecordDeleted, 'N') = 'N'
                               and TCB.NDC is not null )


  Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'NDC Unit is not a valid entry' else
							TCB.[Warning] + ', NDC Unit is not a valid entry' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  WHERE exists(Select 1 from dbo.ClaimLineDrugs C where C.ClaimLineId=TCB.ClaimLineId AND c.Units= TCB.NDCUnit AND Isnull(C.RecordDeleted,'N')='N' AND TCB.NDCUnit IS NOT NULL)
   and not exists ( select *
                        from   ClaimLineDrugs C
                        where  C.ClaimLineId = TCB.ClaimLineId
                               and C.Units = TCB.NDCUnit
                               and isnull(C.RecordDeleted, 'N') = 'N'
                               and TCB.NDCUnit is not null )


  Update TCB
 Set TCB.[Warning]=  Case when TCB.[Warning] is null then 'NDC Unit Type is not a valid entry' else
							TCB.[Warning] + ', NDC Unit Type is not a valid entry.' end
								, TCB.[BatchStatus]  =@StatusWarning
 From #TempClaimBatchDirect TCB  
  WHERE NOT exists(SELECT GlobalCodeId FROM dbo.GlobalCodes WHERE CodeName=TCB.NDCUnitType AND Category='MEDICATIONUNIT')
 
 
 Insert Into ClaimBatchUploads( [CreatedBy] 
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,UploadedFileName
	  ,UploadedDate
	  ,UploadedBy
	  ,ProviderId)
Select @UserCode  
      ,getdate()
      ,@UserCode  
      ,getdate()
     ,@FileName
     ,GetDate()
     ,@StaffId
     ,@ProviderId
 
 SET @ClaimBatchUploadId = SCOPE_IDENTITY()	
        	
Insert Into ClaimBatchDirectEntries([CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
   --,[RecordDeleted]  
   --   ,[DeletedBy]  
   --   ,[DeletedDate]  
      ,[ClaimLineId]  
      ,[InsurerId]  
      ,[SiteId]  
      ,[ClientId]  
      ,[RenderingProviderId]  
      ,[FromDate]  
      ,[ToDate]  
      ,[StartTime]  
      ,[EndTime]  
      ,BillingCode
      ,[BillingCodeModifier1]  
      ,[BillingCodeModifier2]  
      ,[BillingCodeModifier3]  
      ,[BillingCodeModifier4]  
      ,[Units]  
      ,[Charge]  
      ,[PlaceOfService]  
      ,Diagnosis1 
    ,Diagnosis2 
    ,Diagnosis3 
      ,[RenderingProviderName]  
      ,[PreviousPayer1]  
      ,[AllowedAmount1]  
      ,[PaidAmount1]  
      ,[AdjustmentAmount1]  
      ,[AdjustmentGroupCode1]  
      ,[AdjustmentReason1]  
      ,[PreviousPayer2]  
      ,[AllowedAmount2]  
      ,[PaidAmount2]  
      ,[AdjustmentAmount2]  
      ,[AdjustmentGroupCode2]  
      ,[AdjustmentReason2]  
      ,[Warning]  
      ,[BatchStatus]
      ,ClaimBatchUploadId
	  ,OrderingProviderId 
	  ,SupervisingProviderId
	  ,OrderingProviderNPI
	  ,SupervisingProviderNPI
	  ,NDC
	  ,NDCUnit
	  ,NDCUnitType)  
  
Select [CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
   --,[RecordDeleted]  
   --   ,[DeletedBy]  
   --   ,[DeletedDate]  
      ,[ClaimLineId]  
      ,[InsurerId]  
      ,[SiteId]  
      ,[ClientId]  
      ,[RenderingProviderId]  
      ,[FromDate]  
      ,[ToDate]  
      ,[StartTime]  
      ,[EndTime]  
      ,BillingCode
      ,[BillingCodeModifier1]  
      ,[BillingCodeModifier2]  
      ,[BillingCodeModifier3]  
      ,[BillingCodeModifier4]   
      ,[Units]  
      ,[Charge]  
      ,[PlaceOfService]  
      ,Diagnosis1 
    ,Diagnosis2 
    ,Diagnosis3 
      ,[RenderingProviderName]  
      ,[PreviousPayer1]  
      ,[AllowedAmount1]  
      ,[PaidAmount1]  
      ,[AdjustmentAmount1]  
      ,[AdjustmentGroupCode1]  
      ,[AdjustmentReason1]  
      ,[PreviousPayer2]  
      ,[AllowedAmount2]  
      ,[PaidAmount2]  
      ,[AdjustmentAmount2]  
      ,[AdjustmentGroupCode2]  
      ,[AdjustmentReason2]  
      ,[Warning]  
      ,[BatchStatus]  
      ,@ClaimBatchUploadId
	  ,OrderingProviderId 
	  ,SupervisingProviderId
	  ,OrderingProviderNPI
	  ,SupervisingProviderNPI
	  ,NDC
	  ,NDCUnit
	  ,(SELECT GlobalCodeId FROM dbo.GlobalCodes WHERE CodeName=NDCUnitType AND Category='MEDICATIONUNIT') 
       From #TempClaimBatchDirect  
   
   select @ClaimBatchUploadId
  END TRY  
  
   BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_InsertValidateBatchClaims')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 

      
GO
