
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageClaimDenials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageClaimDenials]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  

CREATE PROCEDURE [dbo].[ssp_SCListPageClaimDenials]    


 /*********************************************************************/        
 /* Author : Shruthi.S                                                */
 /* Date   : 06/07/2015                                               */
 /* Purpose: To display the records of Claim Denials list page.Ref #603 Network 180 Customizations.*/
 
--Modified : Basudev Sahu
--Date     : 29/04/2016   
--Purpose  : Modified for Task New.Ref #56 Network 180 -Customizations.  
-- 25/08/2016	Suneel N.	To display SiteName as 'All Sites' while selecting "All Sites" for a provider in ProviderSite popup --#329 N180 Env. Issues
 /*********************************************************************/        
 
 @ProviderId INT,
 @SiteId INT,
 @InsurerId INT,
 @BillingCodeMod varchar(max),
 @CreatedDate varchar(20),
 @Status varchar(2),
 @OtherFilter INT,
 @ClientId INT,
 @StartDate varchar(20),
 @EndDate varchar(20),
 @SortExpression VARCHAR(100),
 @PageNumber			INT,
 @PageSize				INT,
 @StaffId               INT
 
 AS
   BEGIN 
     BEGIN TRY 
     ---To get AllInsurer and AllProvider flag.
        DECLARE @AllStaffInsurer VARCHAR(1)
	    DECLARE @AllStaffProvider VARCHAR(1)
        SELECT @AllStaffInsurer =AllInsurers  FROM staff WHERE staffid=@StaffId   
        SELECT @AllStaffProvider=AllProviders FROM staff WHERE staffId=@StaffId 
        
   
     
     --To split the billingcodemodid 
     declare @BillingCodeId varchar(30) 
     declare @BillingCodeModId varchar(30)
     set @BillingCodeId=''
     if(@BillingCodeMod != '' )
     BEGIN
     if(@BillingCodeMod != '-1')
		 begin
		 select @BillingCodeId = SUBSTRING(@BillingCodeMod,1,CHARINDEX('_',@BillingCodeMod,0)-1)
		 select @BillingCodeModId = SUBSTRING(@BillingCodeMod,CHARINDEX('_',@BillingCodeMod,0)+1,LEN(@BillingCodeMod))
		 end 
     END
    
     --  
      --Declare table to get data if Other filter exists -------  
      --  
			CREATE TABLE #CustomFilters 
			( 
			   ClaimDenialOverrideId INT 
			) 
        
         DECLARE @CustomFiltersApplied CHAR(1)='N' 
         CREATE TABLE #ResultSet 
         ( 
			  ClaimDenialOverrideId INT,
			  Provider varchar(max),
			  SiteName varchar(max),
			  Insurer varchar(max),
			  CreatedDate datetime,
			  StartDate datetime,
			  EndDate datetime,
			  DenialReasons varchar(max),
			  PersonCreated varchar(max)
         )
         
         
        IF ISNULL(@SortExpression, '') = ''
	    SET @SortExpression = 'Provider'
	    
	    
	     --Get custom filters   
      --                                              
      IF @OtherFilter > 10000 
        BEGIN 
        SET @CustomFiltersApplied = 'Y'
        
            INSERT INTO #CustomFilters 
            
            EXEC scsp_SCListPageClaimDenials
					 @ProviderId = @ProviderId,
					 @SiteId = @SiteId,
					 @InsurerId=@InsurerId,
					 @BillingCodeMod = @BillingCodeMod,
					 @CreatedDate = @CreatedDate,
					 @Status = @Status,
					 @OtherFilter = @OtherFilter,
					 @ClientId = @ClientId,
					 @StartDate = @StartDate,
					 @EndDate =@EndDate
            END 
      --     
	    
	     --                                  
      --Insert data in to temp table which is fetched below by appling filter.     
      --   
         INSERT INTO #ResultSet
         (
             
			  ClaimDenialOverrideId ,
			  Provider ,
			  SiteName ,
			  Insurer,
			  CreatedDate ,
			  StartDate ,
			  EndDate ,
			  DenialReasons ,
			  PersonCreated
         )
         Select 
         distinct C.ClaimDenialOverrideId,
         P.ProviderName as Provider,
         CASE WHEN ISNULL(S.SiteName, '') = '' THEN 'All Sites' ELSE S.SiteName end as SiteName, -- 25/08/2016	Suneel N.
         I.InsurerName as InsurerName,
         C.CreatedDate,
         C.StartDate,
         C.EndDate,
         'Denial' as DenialReasons,
         CS.LastName + ' ,'+CS.FirstName as PersonCreated
         from ClaimDenialOverrides C 
         JOIN Staff CS on Cs.UserCode=C.CreatedBy and ISNULL(CS.RecordDeleted,'N') <> 'Y' and Cs.Active='Y' and ISNULL(c.RecordDeleted,'N')<>'Y'
         LEFT JOIN ClaimDenialOverrideDenialReasons CD on CD.ClaimDenialOverrideId = C.ClaimDenialOverrideId and ISNULL(CD.RecordDeleted,'N')<>'Y'
         LEFT JOIN ClaimDenialOverrideBillingCodes CB on CD.ClaimDenialOverrideId = CB.ClaimDenialOverrideId and ISNULL(CB.RecordDeleted,'N')<>'Y'
         LEFT JOIN  BillingCodes BC on CB.BillingCodeId = BC.BillingCodeId and ISNULL(BC.RecordDeleted,'N') <> 'Y'
         LEFT JOIN ClaimDenialOverrideProviderSites CPS on CPS.ClaimDenialOverrideId=C.ClaimDenialOverrideId
         LEFT JOIN ClaimDenialOverrideInsurers CI on CI.ClaimDenialOverrideId=C.ClaimDenialOverrideId
         LEFT JOIN Sites S on s.SiteId=CPS.SiteId and ISNULL(S.RecordDeleted,'N') <> 'Y'
         LEFT JOIN Providers P on P.ProviderId = CPS.ProviderId
         and p.Active='Y' and ISNULL(P.RecordDeleted,'N') <> 'Y'
         LEFT JOIN Insurers I on I.InsurerId = CI.InsurerId
         and I.Active='Y' and ISNULL(I.RecordDeleted,'N') <> 'Y'
         LEFT JOIN GlobalSubCodes GS on GS.GlobalSubCodeId = CD.DenialReasonId 
         LEFT JOIN BillingCodeModifiers BM on BM.BillingCodeId = CB.BillingCodeId and ISNULL(BM.RecordDeleted,'N') <> 'Y'
         where 
         ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM #CustomFilters CF WHERE CF.ClaimDenialOverrideId = C.ClaimDenialOverrideId))OR (@CustomFiltersApplied = 'N'))
         AND (BM.BillingCodeModifierId = @BillingCodeModId OR @BillingCodeModId = '' OR @BillingCodeMod ='-1' OR @BillingCodeMod ='')
         AND ( @BillingCodeMod ='-1' OR @BillingCodeMod ='' OR  BC.BillingCodeId = @BillingCodeId)
         AND ( @ProviderId = -1 OR
									EXISTS (
										SELECT SP.ProviderId 
										FROM StaffProviders SP
										WHERE ISNULL(RecordDeleted,'N') <> 'Y'
										AND SP.StaffId = @StaffId
										AND SP.ProviderId =   CPS.ProviderId
										AND SP.ProviderId= @ProviderId
										AND @AllStaffProvider = 'N'
									)
									OR EXISTS (
										SELECT ProviderId P
										FROM Providers P
										WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
										AND P.ProviderId =  CPS.ProviderId
										AND P.ProviderId= @ProviderId
										AND @AllStaffProvider = 'Y'
									)      
						
						) 
						
	      AND (@SiteId = -1 OR CPS.SiteId = @SiteId)
	      AND (@InsurerId = -1 OR CI.insurerid = @InsurerId)
	      --AND (@ClientId = 0 OR @ClientId = C.ClientId)
	      AND (@StartDate is null OR (cast(C.StartDate as DATE) > =  cast(@StartDate as date) ))
	      AND (@EndDate is null OR (cast(C.EndDate as DATE) <= cast(@EndDate as date)  ))
	     AND (@CreatedDate is null OR (cast(C.CreatedDate as DATE) = cast(@CreatedDate as date)  ))
	     AND (@Status = '-1' OR @Status = '0' OR C.Active = @Status )
     --  order by 
     --            C.ClaimDenialOverrideId,
				 --P.ProviderName ,
				 --S.SiteName ,
				 --I.InsurerName,
				 --C.CreatedDate,
				 --C.StartDate,
				 --C.EndDate,
				 --DenialReasons,
     --            PersonCreated
         
         ---------------To update Denial reasons.Since, a claim line can have multiple denial reasons.
                     
                            
            --UPDATE  R
            --SET     R.DenialReasons = T.CodeName 
            --FROM    #ResultSet R Join ( Select R2.ClaimDenialOverrideId,Replace(Replace( 
            --                         Stuff((SELECT DISTINCT ', ' + 
            --                               SE.CodeName
            --                                FROM   #ResultSet R1 join ClaimDenialOverrideDenialReasons CD on CD.ClaimDenialOverrideId = R1.ClaimDenialOverrideId 
            --                                Left Join GlobalCodes SE On  CD.DenialReasonId = SE.GlobalCodeId and ISNULL(Se.RecordDeleted, 'N') <> 'Y'
            --                                where R2.ClaimDenialOverrideId = R1.ClaimDenialOverrideId
            --         FOR xml path('')), 1, 1, ''), '&lt;', '<'), 
            --         '&gt;', '>')
            --         'DenialReasons'
            --         From #ResultSet R2 ) T on T.ClaimDenialOverrideId=R.ClaimDenialOverrideId
            
               UPDATE  R        
            SET     R.DenialReasons = Replace(Replace(STUFF((SELECT  ', ' +         
                                           GC.CodeName        
                                                 
                                           FROM GlobalCodes GC JOIN       
       ClaimDenialOverrideDenialReasons CD ON CD.DenialReasonId=GC.GlobalCodeId and ISNULL(CD.RecordDeleted,'N')<>'Y'     
                                           where  CD.ClaimDenialOverrideId=R.ClaimDenialOverrideId  FOR xml path('')), 1, 1, ''), '&lt;', '<'),         
                     '&gt;', '>')        
                     FROM #ResultSet R JOIN ClaimDenialOverrides CD1       
                     ON CD1.ClaimDenialOverrideId=R.ClaimDenialOverrideId  and ISNULL(CD1.RecordDeleted,'N')<>'Y'      
            
         ;WITH counts 
	  AS (SELECT COUNT(*) AS TotalRows 
	  FROM   #ResultSet),
	  
	   RankResultSet 
	  AS (SELECT  ClaimDenialOverrideId,
				  Provider ,
				  SiteName ,
				  Insurer,
				  CreatedDate,
				  StartDate,
				  EndDate,
				  DenialReasons,
                  PersonCreated
	  ,COUNT(*) 
	  OVER () AS TotalCount, 
	  ROW_NUMBER()  OVER (ORDER BY CASE WHEN @SortExpression= 'ClaimDenialOverrideId' THEN ClaimDenialOverrideId  END, 
						  CASE WHEN @SortExpression= 'ClaimDenialOverrideId desc' THEN ClaimDenialOverrideId END DESC, 
						  CASE WHEN @SortExpression= 'Provider' THEN Provider END, 
						  CASE WHEN @SortExpression= 'Provider desc' THEN Provider END DESC,
						  CASE WHEN @SortExpression= 'SiteName' THEN SiteName END, 
						  CASE WHEN @SortExpression= 'SiteName desc' THEN SiteName END DESC, 
						    CASE WHEN @SortExpression= 'Insurer' THEN Insurer END, 
						  CASE WHEN @SortExpression= 'Insurer desc' THEN Insurer END DESC, 
						  CASE WHEN @SortExpression= 'CreatedDate' THEN CreatedDate END,
						  CASE WHEN @SortExpression= 'CreatedDate desc' THEN CreatedDate END DESC,
						  CASE WHEN @SortExpression= 'StartDate' THEN StartDate END, 
						  CASE WHEN @SortExpression= 'StartDate desc' THEN StartDate END DESC,
						  CASE WHEN @SortExpression= 'EndDate' THEN EndDate END, 
						  CASE WHEN @SortExpression= 'EndDate desc' THEN EndDate END DESC, 
						  CASE WHEN @SortExpression= 'DenialReasons' THEN DenialReasons END, 
						  CASE WHEN @SortExpression= 'DenialReasons desc' THEN DenialReasons END  DESC,
						  CASE WHEN @SortExpression= 'PersonCreated' THEN PersonCreated END, 
						  CASE WHEN @SortExpression= 'PersonCreated desc' THEN PersonCreated END  DESC,
						 ClaimDenialOverrideId ) AS RowNumber 
	  FROM   #ResultSet) 
	  
	  SELECT TOP (CASE WHEN (@PageNumber = - 1)THEN (SELECT ISNULL(TotalRows, 0) 
	  FROM Counts) 
	  ELSE (@PageSize)END)ClaimDenialOverrideId,
				  Provider ,
				  SiteName ,
				  Insurer,
				  CreatedDate,
				  StartDate,
				  EndDate,
				  DenialReasons,
                  PersonCreated
			,TotalCount 
			,RowNumber 
	  INTO   #FinalResultSet 
	  FROM   RankResultSet 
	  WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
	  
	  

	  IF (SELECT ISNULL(COUNT(*), 0) 
	  FROM   #FinalResultSet) < 1 
	  BEGIN 
			SELECT 0 AS PageNumber, 
			0 AS NumberOfPages, 
			0 NumberofRows 
	  END 
	  ELSE 
	  BEGIN 
		  SELECT TOP 1 @PageNumber           AS PageNumber, 
		  CASE ( Totalcount % @PageSize ) 
		  WHEN 0 THEN ISNULL(( Totalcount / @PageSize ), 0) 
		  ELSE ISNULL((Totalcount / @PageSize), 0) + 1 
		  END                   AS NumberOfPages, 
		  ISNULL(Totalcount, 0) AS NumberofRows
		  FROM   #FinalResultSet 
	  END  
      
      SELECT 
      ClaimDenialOverrideId,
				  Provider ,
				  SiteName ,
				  Insurer,
				  Convert(varchar,CreatedDate,101) as CreatedDate,
				  Convert(varchar,StartDate,101) as StartDate,
				  Convert(varchar,EndDate,101) as EndDate,
				  DenialReasons,
                  PersonCreated
      FROM   #FinalResultSet 
	  ORDER  BY RowNumber    
        
     END TRY
  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_SCListPageClaimDenials')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END		
GO 
 