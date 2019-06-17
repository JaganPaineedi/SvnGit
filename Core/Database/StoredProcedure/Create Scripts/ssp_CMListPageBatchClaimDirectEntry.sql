/****** Object:  StoredProcedure [dbo].[ssp_CMListPageBatchClaimDirectEntry]    Script Date: 08/22/2016 14:01:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMListPageBatchClaimDirectEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.ssp_CMListPageBatchClaimDirectEntry
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMListPageBatchClaimDirectEntry]    Script Date: 08/22/2016 14:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure dbo.ssp_CMListPageBatchClaimDirectEntry          
(   
  @PageNumber            INT   
 ,@PageSize              INT   
 ,@SortExpression varchar(50)  
 ,@BatchStatus int  
 ,@SortBy int  
 ,@OtherFilter int  
 ,@FromDate	Datetime=null
 ,@ToDate Datetime =null
 ,@ClaimBatchUploadId int
)        
 AS  
   BEGIN   
     BEGIN TRY       
/*********************************************************************/                                              
-- Stored Procedure: dbo.ssp_CMListPageBatchClaimDirectEntry                                                              
-- Copyright: Streamline Healthcate Solutions                                                            
-- Creation Date:  08/22/2016                                                                               
--                                                                                                                 
-- Purpose: It will list the Batch Claim data                                                      
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
-- Date         Author       Purpose                                                                               
-- 05/08/2016   Shruthi.S    Created to display records in Batch Claim Entry list page.Ref #73  Network180-Customizations.                     
-- 24/08/2016   Gautam       Added code for sorting and others  Ref #73  Network180-Customizations.   
-- 09/07/2018	Nandita		 Partner Solutions- Customizations Task #28 > Batch Claim Upload: Need to add additional fields to support BH Redesign
/*********************************************************************/    
  
--Variable to store GlobalCodeId from database   
Declare @AllClaims int  
DEclare @Submitted int  
Declare @Valid int  
Declare @Warning int
Declare @ShowWarning int
DECLARE @ValidSubmitted int  
Declare @SortSelected Varchar(300)=''


select @Valid = GlobalCodeId from GlobalCodes where Code='VALID' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N' 
select @Warning = GlobalCodeId from GlobalCodes where Code='WARNING' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N'  
select @Submitted = GlobalCodeId from GlobalCodes where Code='SUBMITTED' and Category='BatchClaimBtchStatus' and  isnull(RecordDeleted,'N') = 'N'  

  
select @AllClaims = GlobalCodeId from GlobalCodes where Code='SHOWALLCLAIMLINES' and Category='BatchClaimStatus' and  isnull(RecordDeleted,'N') = 'N' 
select @ShowWarning = GlobalCodeId from GlobalCodes where Code='SHOWCLAIMSWITHWARNING' and Category='BatchClaimStatus' and  isnull(RecordDeleted,'N') = 'N'  
select @ValidSubmitted = GlobalCodeId from GlobalCodes where Code='SHOWVALIDSUBMITTEDCLAIMS' and Category='BatchClaimStatus' and  isnull(RecordDeleted,'N') = 'N'  

	
If @SortBy > 0
Begin
Select @SortSelected = case when @SortBy = (select GlobalCodeId from GlobalCodes where Code='CLIENTNAMEDATEBILLINGCODE' and Category='BatchClaimSortBy' ) then
								'ClientName,FromDate,BillingCodeModifier1,BillingCodeModifier2,BillingCodeModifier3,BillingCodeModifier4,ClaimBatchDirectEntryId '
							when @SortBy = (select GlobalCodeId from GlobalCodes where Code='CLIENTNAMEBILLINGCODEDATE' and Category='BatchClaimSortBy' ) then
								'ClientName,BillingCodeModifier1,BillingCodeModifier2,BillingCodeModifier3,BillingCodeModifier4,FromDate,ClaimBatchDirectEntryId '
							when @SortBy = (select GlobalCodeId from GlobalCodes where Code='BILLINGCODEDATECLIENTNAME' and Category='BatchClaimSortBy' ) then
								'BillingCodeModifier1,BillingCodeModifier2,BillingCodeModifier3,BillingCodeModifier4,FromDate,ClientName,ClaimBatchDirectEntryId '
							when @SortBy = (select GlobalCodeId from GlobalCodes where Code='BILLINGCODECLIENTNAMEDATE' and Category='BatchClaimSortBy' ) then
								'BillingCodeModifier1,BillingCodeModifier2,BillingCodeModifier3,BillingCodeModifier4,ClientName,FromDate,ClaimBatchDirectEntryId ' end
end

If @SortSelected = ''
			Begin    
				set @SortSelected='ClientName,ClaimBatchDirectEntryId '               
			end  

IF @SortExpression <> ''
	  set @SortSelected=@SortExpression + ',' + @SortSelected
	  
--Temp table to insert records for Batch Claim List page  
      CREATE TABLE #ResultSet   
         (   
       ClaimBatchDirectEntryId int,  
    ClaimLineId int, 
    ClaimStatus varchar(250), 
    InsurerId int,  
    SiteId int,  
    ClientId int,  
    RenderingProviderId int,  
    ClientName varchar(110),  
    FromDate date,  
    ToDate date,  
    StartTime varchar(5),  
    EndTime varchar(5),  
    BillingCode Varchar(20),
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
    BatchStatus varchar(200),  
    BatchMessage varchar(50),
    ClaimBatchUploadId int  ,
    ProviderName varchar(100),
	OrderingProviderNPI VARCHAR(10),
	SupervisingProviderNPI VARCHAR(10),
	NDC VARCHAR(35),
	NDCUnit DECIMAL,
	NDCUnitType INT
         )    
           
          --Insert data into temp table which is fetched below by appling filter.       
            
          --Logic for insertion   
        
    INSERT INTO #ResultSet  
    (  
       ClaimBatchDirectEntryId,  
    ClaimLineId,  
    ClaimStatus,
    ProviderName,
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
    ClaimBatchUploadId,
	OrderingProviderNPI ,
	SupervisingProviderNPI ,
	NDC,
	NDCUnit,
	NDCUnitType
    )  
      Select  
       CB.ClaimBatchDirectEntryId,  
    CB.ClaimLineId,  
    GC1.CodeName as ClaimStatus,
    P.ProviderName,
    CB.InsurerId,  
    CB.SiteId,  
    CB.ClientId,  
    CB.RenderingProviderId,  
    CASE WHEN ISNULL(c.ClientType , 'I') = 'I' and CB.ClientId is not null THEN ISNULL(c.LastName , '') + ', ' + ISNULL(c.FirstName , '')
                             ELSE ISNULL(c.OrganizationName , '')
                        END ,
    cast(CB.FromDate as date) as FromDate,  
    cast(CB.ToDate as date) as ToDate,  
	CONVERT(VARCHAR(5), CB.StartTime, 114) as StartTime, 
	CONVERT(VARCHAR(5), CB.EndTime, 114) as  EndTime,
    --case when CB.StartTime is not null and len(CB.StartTime)>4 then substring(cast(cast(CB.StartTime as time(0)) as varchar),1,5) else '' end as StartTime,  
    --case when CB.EndTime is not null and len(CB.EndTime)>4 then substring(cast(cast(CB.EndTime as time(0)) as varchar),1,5)  else '' end as EndTime,  
    CB.BillingCode,
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
    GC.CodeName as BatchStatus,  
    ''  
	,@ClaimBatchUploadId 
	,CB.OrderingProviderNPI
    ,CB.SupervisingProviderNPI
	,CB.NDC
	,CB.NDCUnit
	,CB.NDCUnitType				
      From ClaimBatchDirectEntries CB 
		join GlobalCodes GC On GC.GlobalCodeId= CB.BatchStatus 
		Left join ClaimBatchUploads CBU on CBU.ClaimBatchUploadId=CB.ClaimBatchUploadId and isnull(CBU.RecordDeleted,'N') ='N'
		Left Join Providers P On P.ProviderId= CBU.ProviderId 
       Left join Clients C on C.ClientId = CB.ClientId and isnull(C.RecordDeleted,'N') ='N'  
       Left Join Claimlines cl On CB.ClaimLineId=cl.ClaimLineId and isnull(cl.RecordDeleted,'N') ='N' 
      Left join GlobalCodes GC1 On GC1.GlobalCodeId= cl.Status 
      
      WHERE  
		CB.ClaimBatchUploadId=@ClaimBatchUploadId and
          isnull(CB.RecordDeleted,'N') = 'N'  and
       --For Dropdown 
       ((@BatchStatus=@AllClaims  ) or
       (@BatchStatus=@ShowWarning and CB.BatchStatus = @Warning) or
       (@BatchStatus=@ValidSubmitted and ( CB.BatchStatus = @Valid or CB.BatchStatus = @Submitted))) and

        --(@BatchStatus = @AllClaims or CB.BatchStatus = @BatchStatus)  and
        ((@FromDate is null or cast(CB.FromDate as date)>= cast(@FromDate as date) ) and
         (@ToDate is null or cast(CB.ToDate as date) <= cast(@ToDate as date)   ))
         
   Declare @strSQL NVarchar(max)=  '; WITH  Counts  
                          AS ( SELECT   COUNT(*) AS TotalRows  
                               FROM     #ResultSet  
                             ) ,  
                        ListBanners  
                          AS ( SELECT DISTINCT  
                                            ClaimBatchDirectEntryId,  
           ClaimLineId,ClaimStatus,ProviderName,InsurerId, SiteId,ClientId,RenderingProviderId,ClientName,FromDate, ToDate,  
           StartTime,EndTime,BillingCode,BillingCodeModifier1, BillingCodeModifier2, BillingCodeModifier3,
			BillingCodeModifier4,  Units, Charge,PlaceOfService,  Diagnosis1, Diagnosis2,Diagnosis3,   
           RenderingProviderName, PreviousPayer1, AllowedAmount1, PaidAmount1, AdjustmentAmount1,  
           AdjustmentGroupCode1,AdjustmentReason1,PreviousPayer2, AllowedAmount2, PaidAmount2,  
           AdjustmentAmount2,AdjustmentGroupCode2, AdjustmentReason2,Warning,BatchStatus, ClaimBatchUploadId, 
			COUNT(*) OVER ( ) AS TotalCount ,  
							RANK() OVER ( ORDER BY '
		   
		 set @strSQL= @strSQL + '  ' + cast(@SortSelected as varchar(200))  + ''                   
		set @strSQL= @strSQL + '  ) AS RowNumber  FROM    #ResultSet )  ' 
       	
       	--select @strSQL
       	--print @strSQL
       	--drop table #ResultSet
       			
		
                  
        set @strSQL= @strSQL + ' SELECT TOP ( CASE WHEN ( ' + Convert(varchar(100), @PageNumber) + '  = -1 ) THEN ( SELECT   ISNULL(TotalRows, 0)  
                                                                   FROM     Counts  
                                                                 )  
                                  ELSE ( ' + convert(varchar(100) , @PageSize ) + ' )  
                             END )  
                            ClaimBatchDirectEntryId,  
       ClaimLineId,  
       ClaimStatus,
       ProviderName,
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
       ClaimBatchUploadId,
                         TotalCount ,  
                         RowNumber  
                INTO    #FinalResultSet  
                FROM    ListBanners 
                 
            WHERE   RowNumber > ( (  ' + convert(varchar(100) , @PageNumber ) + ' - 1 ) *  ' + convert(varchar(100) , @PageSize ) + ' ) '  
  
              
  --select @strSQL
           
  
   set @strSQL= @strSQL + ' IF ( SELECT ISNULL(COUNT(*), 0)  
                 FROM   #FinalResultSet  
               ) < 1   
                BEGIN   
                    SELECT  0 AS PageNumber ,  
                            0 AS NumberOfPages ,  
                            0 NumberOfRows   
                END   
            ELSE   
                BEGIN   
                    SELECT TOP 1  
                            ' + convert(varchar(100) , @PageNumber ) + '  AS PageNumber ,  
                            CASE ( TotalCount %   ' + convert(varchar(100) , @PageSize ) + '  )  
                              WHEN 0 THEN ISNULL(( TotalCount / ' + convert(varchar(100) , @PageSize ) + '  ), 0)  
                              ELSE ISNULL(( TotalCount / ' + convert(varchar(100) , @PageSize ) + '  ), 0) + 1  
                            END AS NumberOfPages ,  
                            ISNULL(totalcount, 0) AS NumberOfRows  
                    FROM    #FinalResultSet   
                END   
                
                 SELECT      
                ClaimBatchDirectEntryId,  
    ClaimLineId,  
    ClaimStatus,
    ProviderName,
    InsurerId,  
    SiteId,  
    ClientId,  
    RenderingProviderId,  
    ClientName,  
    Convert(varchar(10),FromDate, 101 ) as FromDate,  
    Convert(varchar(10),ToDate, 101 ) as ToDate,
    StartTime,  
    EndTime,  
    BillingCode,
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
    BatchStatus ,
    ClaimBatchUploadId 
            FROM    #FinalResultSet  
            ORDER BY RowNumber '  
            
exec sp_executeSQL  @strSQL   
							
             drop table #ResultSet
           
    END TRY           
  BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_CMListPageBatchClaimDirectEntry')
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
   
 