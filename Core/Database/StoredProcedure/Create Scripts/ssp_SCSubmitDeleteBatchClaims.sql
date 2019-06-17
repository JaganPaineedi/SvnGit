/****** Object:  StoredProcedure [dbo].[ssp_SCSubmitDeleteBatchClaims]    Script Date: 08/22/2016 14:01:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSubmitDeleteBatchClaims]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSubmitDeleteBatchClaims]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSubmitDeleteBatchClaims]    Script Date: 08/22/2016 14:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_SCSubmitDeleteBatchClaims]          
(   
  @PageNumber            INT   
 ,@PageSize              INT   
 ,@SortExpression varchar(50)  
 ,@BatchStatus int  
 ,@SortBy int  
 ,@OtherFilter int  
 ,@FromDate	Datetime=null
 ,@ToDate Datetime =null
 ,@Action varchar(50) 
 ,@StaffId Int 
 ,@ClaimBatchUploadId int
)        
 AS  
   BEGIN   
     BEGIN TRY       
/*********************************************************************/                                              
-- Stored Procedure: dbo.ssp_SCSubmitDeleteBatchClaims                                                              
-- Copyright: Streamline Healthcate Solutions                                                            
-- Creation Date:  08/22/2016                                                                               
--                                                                                                                 
-- Purpose: It will submit/ delete Batch Claim data                                                      
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
-- Date				Author    Purpose                                                                               
-- 25/Aug/2016		Gautam    Created ,Ref #73  Network180-Customizations.                     
-- 09/07/2018		Nandita	  Partner Solutions- Customizations Task #28 > Batch Claim Upload: Need to add additional fields to support BH Redesign
/*********************************************************************/    
--Variable to store GlobalCodeId from database   
Declare @AllClaims int  
DEclare @Submitted int  
Declare @Valid int  
Declare @Warning int
Declare @ShowWarning int
DECLARE @ValidSubmitted int  
Declare @SortSelected Varchar(300)=''
DECLARE @UserCode varchar(50)
DECLARE @ClaimsId Int
DECLARE @ClaimLineId Int
DECLARE @ClaimBatchDirectEntryId int
declare @CustomClaimsTableExists Varchar(1)='Y'
DECLARE @ClaimLineDrugId INT

select @UserCode= UserCode from Staff where StaffId=@StaffId
select top 1 @Valid = GlobalCodeId from GlobalCodes where Code='VALID' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N' 
select top 1 @Warning = GlobalCodeId from GlobalCodes where Code='WARNING' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N'  
select top 1 @Submitted = GlobalCodeId from GlobalCodes where Code='SUBMITTED' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N'  

IF not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomClaims')
				BEGIN
					set @CustomClaimsTableExists='N'
				END
  
select top 1 @AllClaims = GlobalCodeId from GlobalCodes where Code='SHOWALLCLAIMLINES' and Category='BatchClaimStatus' and  isnull(RecordDeleted,'N') = 'N' 
select top 1 @ShowWarning = GlobalCodeId from GlobalCodes where Code='SHOWCLAIMSWITHWARNING' and Category='BatchClaimStatus' and  isnull(RecordDeleted,'N') = 'N'  
select top 1 @ValidSubmitted = GlobalCodeId from GlobalCodes where Code='SHOWVALIDSUBMITTEDCLAIMS' and Category='BatchClaimStatus' and  isnull(RecordDeleted,'N') = 'N'  

--Temp table to insert records for Batch Claim List page  
 CREATE TABLE #ResultSetTemp   
         (   
       ClaimBatchDirectEntryId int,
       )
       
      CREATE TABLE #ResultSet   
         (   
       ClaimBatchDirectEntryId int,  
    ClaimLineId int,  
    InsurerId int,  
    SiteId int,  
    ClientId int,  
    RenderingProviderId int,  
    ClientName varchar(110),  
    FromDate datetime,  
    ToDate datetime,  
    StartTime datetime,  
    EndTime datetime,  
    BillingCode varchar(20), 
    BillingCodeId Int, 
    BillingCodeModifier1 varchar(10),  
    BillingCodeModifier2 varchar(10), 
    BillingCodeModifier3 varchar(10), 
    BillingCodeModifier4 varchar(10), 
    Units decimal(18,2),  
    Charge money,  
    PlaceOfService int,  
    Diagnosis1 varchar(10),  
    Diagnosis2 varchar(10),
    Diagnosis3 varchar(10),
    RenderingProviderName varchar(100),  
    PreviousPayer1 varchar(100),  
    AllowedAmount1 money,  
    PaidAmount1 money,  
    AdjustmentAmount1 money,  
    AdjustmentGroupCode1 int,  
    AdjustmentReason1 int,  
    PreviousPayer2 varchar(100),  
    AllowedAmount2 money,  
    PaidAmount2 money,  
    AdjustmentAmount2  money,  
    AdjustmentGroupCode2 int,  
    AdjustmentReason2 int,  
    Warning varchar(max),  
    BatchStatus int,  
    BatchMessage varchar(50)  ,
	OrderingProviderId Int,
	SupervisingProviderId int,
	NDC VARCHAR(35),
	NDCUnit DECIMAL,
	NDCUnitType int
         )    

    INSERT INTO #ResultSet  
    (  
    ClaimBatchDirectEntryId,  
    ClaimLineId,  
    InsurerId,  
    SiteId,  
    ClientId,  
    RenderingProviderId,  
    ClientName,  
    FromDate,  
    ToDate,  
    StartTime,  
    EndTime,  
    BillingCode,
    BillingCodeId,
    BillingCodeModifier1, 
    BillingCodeModifier2,
    BillingCodeModifier3,
    BillingCodeModifier4, 
    Units,  
    Charge,  
    PlaceOfService,  
    Diagnosis1,  
    Diagnosis2, 
    Diagnosis3, 
    RenderingProviderName,  
    PreviousPayer1,  
    AllowedAmount1,  
    PaidAmount1,  
    AdjustmentAmount1,  
    AdjustmentGroupCode1,  
    AdjustmentReason1,  
    PreviousPayer2,  
    AllowedAmount2,  
    PaidAmount2,  
    AdjustmentAmount2,  
    AdjustmentGroupCode2,  
    AdjustmentReason2,  
    Warning,  
    BatchStatus,  
    BatchMessage,  
	OrderingProviderId ,
	SupervisingProviderId ,
	NDC ,
	NDCUnit,
	NDCUnitType  
    )  
      Select  
    CB.ClaimBatchDirectEntryId,  
    CB.ClaimLineId,  
    CB.InsurerId,  
    CB.SiteId,  
    CB.ClientId,  
    CB.RenderingProviderId,  
    CASE WHEN ISNULL(c.ClientType , 'I') = 'I' and CB.ClientId is not null THEN ISNULL(c.LastName , '') + ', ' + ISNULL(c.FirstName , '')
                             ELSE ISNULL(c.OrganizationName , '')
                        END ,
    CB.FromDate,  
    CB.ToDate,  
	CB.StartTime,  
    CB.EndTime,  
    CB.BillingCode,
    P.BillingCodeId,
    CB.BillingCodeModifier1, 
    CB.BillingCodeModifier2,
    CB.BillingCodeModifier3,
    CB.BillingCodeModifier4,  
    CB.Units,  
    CB.Charge,  
    CB.PlaceOfService,  
    CB.Diagnosis1,  
    CB.Diagnosis2, 
    CB.Diagnosis3, 
    CB.RenderingProviderName,  
    CB.PreviousPayer1,  
    CB.AllowedAmount1,  
    CB.PaidAmount1,  
    CB.AdjustmentAmount1,  
    CB.AdjustmentGroupCode1,  
    CB.AdjustmentReason1,  
    CB.PreviousPayer2,  
    CB.AllowedAmount2,  
    CB.PaidAmount2,  
    CB.AdjustmentAmount2,  
    CB.AdjustmentGroupCode2,  
    CB.AdjustmentReason2,  
    CB.Warning,  
    CB.BatchStatus as BatchStatus,  
    '',
	CB.OrderingProviderId ,
	  CB.SupervisingProviderId,
	  CB.NDC,
	  CB.NDCUnit,
	  CB.NDCUnitType     
    From ClaimBatchDirectEntries CB 
    Left join Clients C on C.ClientId = CB.ClientId and isnull(C.RecordDeleted,'N') ='N'  
    Left Join BillingCodes P On CB.BillingCode= P.BillingCode	and isnull(P.RecordDeleted,'N')  ='N'  
    WHERE  
          isnull(CB.RecordDeleted,'N') = 'N'  and  CB.ClaimBatchUploadId=@ClaimBatchUploadId and 
       --For Dropdown 
       ((@BatchStatus=@AllClaims  ) or
       (@BatchStatus=@ShowWarning and CB.BatchStatus = @Warning) or
       (@BatchStatus=@ValidSubmitted and ( CB.BatchStatus = @Valid or CB.BatchStatus = @Submitted))) and
        ((@FromDate is null or cast(CB.FromDate as date)>= cast(@FromDate as date) ) and
         (@ToDate is null or cast(CB.ToDate as date) <= cast(@ToDate as date)   ))
    
    IF @Action='Submit'
    Begin
		If exists(Select 1 FROM    #ResultSet )--2221 Professional
		Begin 
			Insert into #ResultSetTemp    
			SELECT ClaimBatchDirectEntryId FROM #ResultSet where BatchStatus = @Valid
			
			DECLARE cur_BatchesProcessClaims CURSOR FAST_FORWARD
			FOR
			SELECT ClaimBatchDirectEntryId FROM #ResultSetTemp 

			OPEN cur_BatchesProcessClaims

			FETCH cur_BatchesProcessClaims
			INTO @ClaimBatchDirectEntryId

			WHILE @@FETCH_STATUS = 0
			BEGIN
				
				BEGIN TRY
				BEGIN TRAN

				INSERT INTO [Claims] ([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate],[ClientId], [InsurerId], [SiteId], 
									[ReceivedDate], [CleanClaimDate], [ClaimType], PatientAccountNumber,OtherInsured,[Diagnosis1], [Diagnosis2],
									[Diagnosis3], [BalanceDue],[BillingProviderInfo])    
				SELECT  @UserCode, getdate(),@UserCode, GetDate(), ClientId,InsurerId,SiteId,GetDate(),GetDate(),2221,
						[ClientId], 'N', Diagnosis1,  Diagnosis2,  Diagnosis3,Charge,'Site Name'
				FROM    #ResultSet  where ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId	
				
				SET @ClaimsId = SCOPE_IDENTITY()	
				
				INSERT INTO [ClaimLines] ([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [ClaimId], [RenderingProviderId], [BillingCodeId], 
								[Status], [FromDate], [ToDate], [PlaceOfService], [ProcedureCode], [Modifier1], [Modifier2], [Modifier3], [Modifier4], 
								[Diagnosis1], [Diagnosis2], [Diagnosis3], [Charge], [Units], [ClaimedAmount], [RenderingProviderName], 
								[AuthorizationExistsAtEntry], [StartTime], [EndTime],OrderingProviderId,SupervisingProviderId)	
				SELECT  Top 1 @UserCode, getdate(),@UserCode, GetDate(), @ClaimsId,R.[RenderingProviderId], R.BillingCodeId, 2022 -- Entry Complete
						,R.[FromDate],R.[ToDate],R.[PlaceOfService],R.BillingCode,R.BillingCodeModifier1,R.BillingCodeModifier2,
						R.BillingCodeModifier3,R.BillingCodeModifier4,
						case when R.Diagnosis1 is null then 'N' else 'Y' end,
						case when R.Diagnosis2 is null then 'N' else 'Y' end,
						case when R.Diagnosis3 is null then 'N' else 'Y' end,
						 R.Charge ,R.Units ,
						R.Charge, R.RenderingProviderName,'N',R.[StartTime], R.[EndTime],R.[OrderingProviderId],R.[SupervisingProviderId]
				FROM    #ResultSet  R 
				where R.ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId	
				
				SET @ClaimLineId = SCOPE_IDENTITY() 
				
				INSERT INTO [ClaimLineHistory] ([CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate],[ClaimLineId],
							 [Activity], [ActivityDate], [Status], [ActivityStaffId]) --2001(Data entry)					
				SELECT  Top 1 @UserCode, getdate(),@UserCode, GetDate(), @ClaimLineId,2001,  GetDate(),2022,@StaffId
				
				INSERT INTO [OpenClaims] ([ClaimLineId], [CreatedBy], [CreatedDate], [ModifiedBy], 
				[ModifiedDate])
				Select @ClaimLineId,@UserCode, getdate(),@UserCode, GetDate()

				DECLARE @DrugId INT

				SELECT TOP 1 @DrugId=MD.DrugId FROM dbo.MDDrugs MD 
				JOIN #ResultSetTemp RsTemp ON MD.NationalDrugCode=RsTemp.NDC AND ISNULL(MD.RecordDeleted,'N')='N'

				INSERT INTO dbo.ClaimLineDrugs 
				        ( ClaimLineId ,
				          DrugId ,
				          NationalDrugCode ,
				          Units ,
				          UnitType
				        )
				SELECT @ClaimLineId,@DrugId,Res.NDC,Res.NDCUnit,Res.NDCUnitType FROM #ResultSetTemp Res WHERE R.ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId

				IF @CustomClaimsTableExists='Y'
				BEGIN
					INSERT INTO [CustomClaims] ([ClaimId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate])
					Select @ClaimsId,@UserCode, getdate(),@UserCode, GetDate()
				END
				-- Need to insert in table ClaimLineCOBPaymentAdjustments (Popup table)
				If exists (select 1 FROM    #ResultSet  R where R.ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId
								and ( ISNULL(R.PreviousPayer1,'') <> '' or ISNULL(R.PaidAmount1,'') <> ''  or
								ISNULL(R.AdjustmentGroupCode1,'') <> '' or ISNULL(R.AdjustmentReason1,'') <> '' or
								ISNULL(R.AdjustmentAmount1,'') <> '' or ISNULL(R.PaidAmount1,'') <> ''))
				BEGIN
					INSERT INTO [ClaimLineCOBPaymentAdjustments] ([CreatedBy], [CreatedDate], [ModifiedBy],
						 [ModifiedDate], [ClaimLineId], [PayerName], [PaidAmount], [AdjustmentGroupCode],
						  [AdjustmentReason], [AdjustmentAmount])
					Select @UserCode, getdate(),@UserCode, GetDate(),@ClaimLineId,PreviousPayer1,PaidAmount1,
							AdjustmentGroupCode1,AdjustmentReason1, AdjustmentAmount1
					From #ResultSet where ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId
					
					If exists (select 1 FROM    #ResultSet  R where R.ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId
								and ( ISNULL(R.PreviousPayer2,'') <> '' or ISNULL(R.PaidAmount2,'') <> ''  or
								ISNULL(R.AdjustmentGroupCode2,'') <> '' or ISNULL(R.AdjustmentReason2,'') <> '' or
								ISNULL(R.AdjustmentAmount2,'') <> '' or ISNULL(R.PaidAmount2,'') <> ''))
					Begin
						INSERT INTO [ClaimLineCOBPaymentAdjustments] ([CreatedBy], [CreatedDate], [ModifiedBy],
						 [ModifiedDate], [ClaimLineId], [PayerName], [PaidAmount], [AdjustmentGroupCode],
						  [AdjustmentReason], [AdjustmentAmount])
						Select @UserCode, getdate(),@UserCode, GetDate(),@ClaimLineId,PreviousPayer2,PaidAmount2,
							AdjustmentGroupCode2,AdjustmentReason2, AdjustmentAmount2
						From #ResultSet where ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId
					end
					
				END
				
				update C
				set C.BatchStatus=@Submitted,C.ClaimLineId =@ClaimLineId
				From ClaimBatchDirectEntries C
				where C.ClaimBatchDirectEntryId=@ClaimBatchDirectEntryId
				
				COMMIT TRAN
				END TRY

				BEGIN CATCH
					IF @@trancount > 0
						ROLLBACK TRANSACTION
						
				END CATCH
				FETCH cur_BatchesProcessClaims
			INTO @ClaimBatchDirectEntryId
		END

		
	END

	CLOSE cur_BatchesProcessClaims

	DEALLOCATE cur_BatchesProcessClaims
	
	END
	
	IF @Action='Delete'
    Begin
		If exists(Select 1 FROM    #ResultSet )
		Begin 
			Update CB
			Set CB.RecordDeleted='Y', CB.DeletedBy=@UserCode ,CB.DeletedDate=getdate()
			From ClaimBatchDirectEntries CB 
			where exists(Select 1 from #ResultSet R where R.ClaimBatchDirectEntryId= CB.ClaimBatchDirectEntryId and R.BatchStatus <> @Submitted)
			and ISNULL(CB.RecordDeleted,'N')='N' and CB.BatchStatus <> @Submitted
			and CB.ClaimBatchUploadId=@ClaimBatchUploadId
			
			Update CB
			Set CB.RecordDeleted='Y', CB.DeletedBy=@UserCode ,CB.DeletedDate=getdate()
			From claimbatchuploads CB 
			where CB.ClaimBatchUploadId=@ClaimBatchUploadId
			and not exists(Select 1 from ClaimBatchDirectEntries CB1 where CB1.ClaimBatchUploadId
									=CB.ClaimBatchUploadId and CB1.BatchStatus = @Submitted)
		End
	End	
	--MIDemoSmartCare
    
    END TRY           
  BEGIN CATCH
          DECLARE @error VARCHAR(8000)
		
		 if cursor_status('global', 'cur_BatchesProcessClaims') >= 0   
		begin  
		  close cur_BatchesProcessClaims  
		  deallocate cur_BatchesProcessClaims  
		end   
    
          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCSubmitDeleteBatchClaims')
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
   
 