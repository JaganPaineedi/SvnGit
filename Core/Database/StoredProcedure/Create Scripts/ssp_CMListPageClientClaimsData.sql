/****** Object:  StoredProcedure [dbo].[ssp_CMListPageClientClaimsData]    Script Date: 11/18/2011 16:25:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMListPageClientClaimsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMListPageClientClaimsData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  
CREATE  Procedure [dbo].[ssp_CMListPageClientClaimsData]        
(      
 @InsurerID int,      
 @Status type_GlobalCode,      
 @Provider int,      
 @Site int,      
 @EnteredFrom varchar(10),      
 @EnteredTo varchar(10),      
 @DOSEffectiveFrom varchar(10),      
 @DOSEffectiveTo varchar(10),      
 @ClientId int      
, @PageNumber            INT 
, @PageSize              INT 
, @OtherFilter           INT 
,@SortExpression varchar(50)   
,@LoggedInStaffId      INT
)      
AS
      
BEGIN      
/*********************************************************************/                                            
-- Stored Procedure: dbo.ssp_CMListPageClientClaimsData                                                            
-- Copyright: 2005 Provider Claim Management System                                                        
-- Creation Date:  5/01/2006                                                                                
--                                                                                                               
-- Purpose: It will get the MemberClaims Data                                                        
--                                                                                                             
-- Input Parameters: @InsurerID,@Status,@Provider,@Site,@EnteredFrom,@EnteredTo,@DOSEffectiveFrom,@DOSEffectiveTo                                                     
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
--  Date        Author       Purpose                                                                             
-- 06/06/2014   Shruthi.S    Created Ref#26 CM to SC.                   
-- 10/11/2014   Shruthi.S    Added permission based data retrieval for Providers and Insurers.Ref : #89 Care Management to SmartCare Env. Issues Tracking
-- 12/11/2014   Shruthi.S    For status set the original globalcodeid for subcodes.Ref #89 Care Management to SmartCare Env. Issues Tracking                                           
-- 09.Feb.2014  Rohith Uppin Status modified for Pended(2025 used instead of 2027) & Commented line removed. Task#450 CM to SC issues tracking.
-- 01.July.2016  Basudev Sahu Modified to Get Organisation  As ClientName for task #684	Network 180 Environment Issues Tracking.
-- 10.Auf.2016  Kiran Kumar   Modified to get claims of all slave clients when the select client is master record = 'Y'
-- 16.Nov.2016  Neelima       Added @InsurerID and AProviderId conditions since Insurers and Providers dropdowns are not filtering data in the claims list page as per AspenPointe - Support Go Live #43
-- 08.Mar.2017  Vijeta S      Added @CareManagementClientId while filtering claims table with CareManagementClientId instead of ClientId. CEI - Support Go Live #577
-- 03.May.2017  Msood		What: Replaced NULL values with 'N'  for @AllStaffInsurer and @AllStaffProvider
--							Why: Allegan - Support Task#965 for not displaying the records in list page if Staff.AllProviders and Staff.AllInsurers is NULL
-- 01 Aug 2017  PradeepT   What:Added Condition to filter status for "Partially Approved" Claim status
--                          Why: As per task #KCMHSAS - Support-#900.83
--28-Nov-2017   Pavani      What : Added Condition to check ISNULL for recorddeleted
 --                         Why : KCMHSAS - Support: #960.2
--04-Apr-2018	Alok Kumar	Modified query to return one more column 'Authorizations' from table 'ProviderAuthorizations' to display on the listpage. Ref: Task#23 SWMBH - Enhancements.
-- 18 June 2018    PradeepT  What: Retrieve ClaimLines.PaidAmount to show in list Page Grid
--                         Why: Requirement given in #KCMHSAS - Support-#960.75. Due to miss to commit in svn, accomdating the changes on 3 July 2018
--05-Nov-2018   Hemant      What:Added the null check for the "PayableAmount" Field to return 0 if the value is null and included the billing code check to return Procedure. 
--                          Why: Valley - Support Go Live #1621
--11/15/2018	Msood		What: Increased the Variable length (Authorization) from Varchar(500) to Varchar(Max)
--							Why: SWMBH - Support Task #1481
--20/12/2018    Lakshmi     What: The 'Payable Amount' column in claims list page under clients tab will display blank value when the value in NULL. 
--							Why:   As per the QA it should display ‘0’, Core Bugs #2644

/*********************************************************************/    
BEGIN TRY
	DECLARE @CustomFiltersApplied CHAR(1)
	CREATE TABLE #CustomFilters(DocumentId Int)
	SET @CustomFiltersApplied = 'N'
	DECLARE @Tobeworked int
	DECLARE @MasterRecord CHAR(1) 
	SET @Tobeworked = 6186 -- globalsubcodeid
    DECLARE @CareManagementClientId INT  ------ vsinha                                  
    SELECT  @CareManagementClientId = isnull(CareManagementId,ClientId)    
    FROM    [dbo].[Clients]    
    WHERE   clientid = @ClientId  
	--GET CUSTOM FILTERS           
	Declare @SQLStr as NVarchar(max)      
 
	DECLARE @AllStaffInsurer  CHAR(1)
	DECLARE @AllStaffProvider CHAR(1)
	 -- Msood 05/03/2017
	SELECT  @AllStaffInsurer = ISNULL(AllInsurers,'N') FROM staff WHERE staffid=@LoggedInStaffId
	SELECT  @AllStaffProvider = ISNULL(AllProviders, 'N') From Staff where staffid=@LoggedInStaffId
	
  
	---To set the original globalcodeid's for claimline status
  
	  IF(@Status =6180)
		SET @Status =2021
	  IF(@Status =6181)
		SET @Status =2022
	  IF(@Status =6182)
		SET @Status =2023
	  IF(@Status =6183)
		SET @Status =2024
	  IF(@Status =6184)
		SET @Status =2027
	  IF(@Status =6185)
		SET @Status =2026
	  IF(@Status =6187)
		SET @Status =2028  
      IF(@Status =6265)------Pradeep,28July2017
	    SET @Status =2025                                                         
	IF @OtherFilter > 10000       
		BEGIN   
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters(DocumentId)
			
			EXEC scsp_ListPageCMClientClaimsData 
			@InsurerID = @InsurerID,
			@Status = @Status,
			@Provider = @Provider,
			@Site = @Site,
			@EnteredFrom = @EnteredFrom,
			@EnteredTo = @EnteredTo,
			@DOSEffectiveFrom = @DOSEffectiveFrom,
			@DOSEffectiveTo = @DOSEffectiveTo,      
			@ClientId = @ClientId,
			@OtherFilter = @OtherFilter		   
		END		
		select @MasterRecord= ISNULL(MasterRecord,'N') from Clients where ClientId = @ClientId
			CREATE TABLE #ResultSet
			(		
		        ClaimLine           INT,
				ClientId			INT, 
                ProviderName	    Varchar(100),
                DOS				    Date,
                [Status]	        Varchar(250),
                PayableAmount    	money,
                PaidAmount          Money,--PradeepT 18 Jan 20187
                InsurerName         Varchar(100),
                [Procedure]	        Varchar(250), 
			    ProviderId          int,
			    ClientName          varchar(300),
				--Msood 11/15/2018
			    Authorizations		varchar(Max)		--04-Apr-2018	Alok Kumar
			)   
-- 01.July.2016  Basudev Sahu
	SET @SQLStr='select claimlines.ClaimLineId as ClaimLine,Claims.ClientId,Providers.ProviderName as ProviderName,ClaimLines.FromDate as DOS,    
				 GlobalCodes.CodeName as Status,Claimlines.PayableAmount as PayableAmount,Claimlines.PaidAmount as PaidAmount ,Insurers.InsurerName as Insurer,
				 coalesce(B.BillingCode + '''' + isnull(claimlines.Modifier1, '''') + '''' + isnull(claimlines.Modifier2, '''') + '''' + isnull(claimlines.Modifier3, '''') + '''' + isnull(claimlines.Modifier4, ''''), claimlines.ProcedureCode, claimlines.RevenueCode) AS [Procedure],-- Hemant 11/05/2018 
				 Providers.ProviderId As ProviderId,
				 CASE           
      WHEN ISNULL(Clients.ClientType, ''I'') = ''I''      
       THEN ISNULL(Clients.LastName, '''') + '', '' + ISNULL(Clients.FirstName, '''')      
      ELSE ISNULL(Clients.OrganizationName, '''')      
      END  As ClientName
      ,Null AS Authorizations
      
				 from Claimlines inner join claims on Claimlines.claimId=claims.claimid       
				 inner join Insurers on Claims.Insurerid=Insurers.InsurerId      
				 inner join GlobalCodes on GlobalCodes.GlobalCodeId=Claimlines.Status      
				 inner join Sites on claims.siteid=Sites.Siteid      
				 inner join Providers on Sites.ProviderID = Providers.ProviderId 
				 inner join Clients on Claims.ClientId = Clients.ClientId
				 left join BillingCodes B on ClaimLines.BillingCodeId=B.BillingCodeID and IsNull(B.RecordDeleted,''N'') <>''Y'' and IsNull(Claimlines.RecordDeleted,''N'') <>''Y''

				 where 
				(
				 ISNULL(Clients.RecordDeleted,'''')<>''Y'' and ( Claims.ClientId='+  Cast(@CareManagementClientId as nvarchar) +''
				 
				 if @MasterRecord='Y'
					 SET @SQLStr = @SQLStr +' or exists (Select PC.ClientId from ProviderClients PC Join StaffClients SC On PC.ClientId= SC.ClientId and SC.StaffId= '+  Cast(@LoggedInStaffId as nvarchar) + '  where Claims.ClientId = PC.ClientId and ISNULL(PC.RecordDeleted,''N'')=''N'' and PC.MasterClientId=' + Cast(@ClientId as nvarchar) +')'
				 
				SET @SQLStr = @SQLStr +') and (Claimlines.RecordDeleted =''N'' Or Claimlines.RecordDeleted is null)  and (Claims.RecordDeleted =''N'' Or Claims.RecordDeleted  
				 
				is null) and      
				(Insurers.RecordDeleted =''N'' Or Insurers.RecordDeleted is null)  and (GlobalCodes.RecordDeleted =''N'' Or GlobalCodes.RecordDeleted is null)  and (Sites.RecordDeleted =''N'' Or Sites.RecordDeleted is null)  and    
				 (Providers.RecordDeleted =''N'' Or Providers.RecordDeleted is null) 
				 
				and cast(Claims.ReceivedDate as date)>='''+ISNULL(@EnteredFrom,'01/01/1900') +''' and cast(Claims.ReceivedDate as date)<='''+ISNULL(@EnteredTo,'01/01/2999')+''''
	 
	 
	IF(@CustomFiltersApplied = 'Y')
		BEGIN
			SET @SQLStr = @SQLStr + 'and exists(select * from #CustomFilters cf where cf.DocumentId = p.ClaimLineId)'
		END
	ELSE
		BEGIN
	 
			IF(@InsurerID='' or @InsurerID=-1)      
				BEGIN      
					SET @SQLStr = @SQLStr + N'and (Claims.Insurerid in (	               
											SELECT SI.InsurerId
											FROM StaffInsurers SI
											WHERE isnull(SI.RecordDeleted, ''N'') <> ''Y''
												AND SI.StaffId = '''+convert(varchar(10),@LoggedInStaffId)+'''
												AND (Claims.InsurerId = SI.InsurerId)
												AND '''+convert(varchar(10),@AllStaffInsurer)+''' = ''N''
												)
											OR Claims.Insurerid in (
												SELECT IU.InsurerId
												FROM Insurers IU
												WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''
													AND (Claims.InsurerId = IU.InsurerId )
													AND '''+convert(varchar(10),@AllStaffInsurer)+''' = ''Y''
												) )'      
				END      
			ELSE
				BEGIN      
					SET @SQLStr = @SQLStr + N'and (Claims.Insurerid in (
													SELECT SI.InsurerId
													FROM StaffInsurers SI
													WHERE isnull(SI.RecordDeleted, ''N'') <> ''Y'' 
														AND SI.StaffId = '''+convert(varchar(10),@LoggedInStaffId)+'''
														AND (Claims.InsurerId = SI.InsurerId)
														AND '''+convert(varchar(10),@AllStaffInsurer)+''' = ''N''
														AND SI.InsurerId = '''+convert(varchar(10),@InsurerID) +'''
													)
												OR Claims.Insurerid in (
													SELECT IU.InsurerId
													FROM Insurers IU
													WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''
														AND (Claims.InsurerId = IU.InsurerId )
														AND '''+convert(varchar(10),@AllStaffInsurer)+''' = ''Y''
														AND '''+Convert(varchar(10),@InsurerID)+'''=IU.InsurerId	--Added by Neelima
													)) '         
				END
				        
			IF(@Status='' or @Status='-1' or @Status='6186')      
				BEGIN      
					SET @SQLStr = @SQLStr       
				END
			ELSE       
				BEGIN      
					SET @SQLStr = @SQLStr + 'and Claimlines.Status = '''+Cast(@Status as nvarchar)+''''      
				END
				        
			IF(@Provider='' or @Provider='-1')      
				BEGIN      
					 SET @SQLStr = @SQLStr  + N'and (Sites.ProviderID in (
													SELECT SP.ProviderId 
													FROM StaffProviders SP
													WHERE isnull(RecordDeleted, ''N'') <> ''Y''
													AND SP.StaffId = '''+convert(varchar(10),@LoggedInStaffId)+'''
													AND Sites.ProviderId = SP.ProviderId
													AND '''+convert(varchar(10),@AllStaffProvider)+''' = ''N''
												)
												OR  Sites.ProviderID in(
													SELECT ProviderId P
													FROM Providers P
													WHERE isnull(RecordDeleted, ''N'') <> ''Y''
													AND Sites.ProviderId = P.ProviderId
													AND '''+convert(varchar(10),@AllStaffProvider)+''' = ''Y''
												))  '     
				END      
			ELSE       
				BEGIN      
					SET @SQLStr = @SQLStr + N'and (Sites.ProviderID in  
												(
													SELECT SP.ProviderId 
													FROM StaffProviders SP 
													WHERE isnull(RecordDeleted, ''N'') <> ''Y'' --Pavani 28-Nov-2017
													AND SP.StaffId = '''+convert(varchar(10),@LoggedInStaffId)+'''
													AND Sites.ProviderId = SP.ProviderId
													AND '''+convert(varchar(10),@AllStaffProvider)+''' = ''N''
													AND '''+Convert(varchar(10),@Provider)+'''=SP.ProviderId
												)
												OR Sites.ProviderID in (
													SELECT ProviderId P
													FROM Providers P
													WHERE isnull(RecordDeleted, ''N'') <> ''Y''
													AND Sites.ProviderId = P.ProviderId
													AND '''+convert(varchar(10),@AllStaffProvider)+''' = ''Y''
													AND '''+Convert(varchar(10),@Provider)+'''=P.ProviderId		--Added by Neelima
												))  '
				END        
			
			IF(@Site='' or @Site='-1')      
				 BEGIN      
					SET @SQLStr = @SQLStr       
				 END      
			ELSE       
				 BEGIN      
					SET @SQLStr = @SQLStr + N' and claims.siteid = '+ Cast(@Site as nvarchar)      
				 END        
	     
	     
				SET @SQLStr = @SQLStr + ' and  cast(ClaimLines.FromDate as date)>='''+ISNULL(@DOSEffectiveFrom,'01/01/1900') +''''  
	        
	      
				SET @SQLStr = @SQLStr + ' and cast(ClaimLines.ToDate as date)<='''+ISNULL(@DOSEffectiveTo,'01/01/2999') +''''  
	       
			 IF (@Status=@Tobeworked)   -- To be worked             
				BEGIN   
					SET @SQLStr = @SQLStr + ' and IsNull(ClaimLines.NeedsToBeWorked,''N'')=''Y'' '  
				END   
				
				SET @SQLStr = @SQLStr + ')' 
	     
		END
	--select  @SQLStr 
	Insert Into #ResultSet  
	Execute SP_EXECUTESQL @SQLStr    
	--print @SQLStr
	
	
	--04-Apr-2018	Alok Kumar
    update  RS
    set     RS.Authorizations = isnull(replace(replace(stuff((select distinct
                                                                ', ' + PA.AuthorizationNumber
                                                         from   ClaimLineAuthorizations CA
                                                                JOIN ProviderAuthorizations PA ON CA.ProviderAuthorizationId = PA.ProviderAuthorizationId
                                                         where  CA.ClaimLineId = RS.ClaimLine
                                                                and isnull(CA.RecordDeleted, 'N') = 'N' and isnull(PA.RecordDeleted, 'N') = 'N'
                                                        for
                                                         xml path('')), 1, 1, ''), '&lt;', '<'), '&gt;', '>'), '')
    from    #ResultSet RS


	;With counts 
		   AS (SELECT Count(*) AS TotalRows FROM   #ResultSet), 
		   RankResultSet AS (SELECT 
					ClaimLine           ,
					ClientId			, 
					ProviderName	    ,
					DOS				    ,
					[Status]	       ,
					PayableAmount    	,
					PaidAmount,--PradeepT 18 Jan 2018
					InsurerName  ,
					[Procedure]	,
					ProviderId,
					ClientName,
					Authorizations,		--04-Apr-2018	Alok Kumar
					Count(*) 
								  OVER ( )   AS TotalCount 
							  , Rank() 
								 OVER( ORDER BY
								  CASE WHEN @SortExpression = 'ClaimLine' THEN ClaimLine END, 
								  CASE WHEN @SortExpression = 'ClaimLine desc' THEN ClaimLine END DESC, 							                               
								  CASE WHEN @SortExpression = 'ClientName' THEN ClientName END, 
								  CASE WHEN @SortExpression = 'ClientName desc' THEN ClientName END DESC, 
								  CASE WHEN @SortExpression = 'ProviderName' THEN ProviderName END, 
								  CASE WHEN @SortExpression = 'ProviderName desc' THEN ProviderName END DESC, 
								  CASE WHEN @SortExpression = 'DOS' THEN DOS END, 
								  CASE WHEN @SortExpression = 'DOS desc' THEN DOS END DESC, 
								  CASE WHEN @SortExpression = 'Status' THEN [Status] END, 
								  CASE WHEN @SortExpression = 'Status desc' THEN [Status] END DESC, 
								  CASE WHEN @SortExpression = 'PayableAmount' THEN PayableAmount END,
								  CASE WHEN @SortExpression = 'PayableAmount desc' THEN PayableAmount END DESC, 
								  CASE WHEN @SortExpression = 'PaidAmount' THEN PaidAmount END, -- Added By Narayana 
								  CASE WHEN @SortExpression = 'PaidAmount desc' THEN PaidAmount END DESC,  -- Added By Narayana 
								  CASE WHEN @SortExpression = 'InsurerName' THEN InsurerName END, 
								  CASE WHEN @SortExpression = 'InsurerName desc' THEN InsurerName END DESC, 
								  CASE WHEN @SortExpression = 'Procedure' THEN [Procedure] END, 
								  CASE WHEN @SortExpression = 'Procedure desc' THEN [Procedure] END DESC, 
								  CASE WHEN @SortExpression = 'Authorizations' THEN [Authorizations] END,			--04-Apr-2018	Alok Kumar
								  CASE WHEN @SortExpression = 'Authorizations desc' THEN [Authorizations] END DESC,
								  ProviderId,
								  ClientId,
								  ClaimLine) 
								  AS RowNumber 
							FROM   #ResultSet) 
	  
	 
	 
	         
		  SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(Totalrows, 0) FROM Counts) ELSE (@PageSize) END) 
			  ClaimLine  ,
			  ClientId	, 
			  ProviderName ,
			  Convert(varchar,DOS,101) As DOS,	
			  [Status],
			  Isnull(PayableAmount,0) As PayableAmount, -- Hemant 11/05/2018
			  --PaidAmount,-- Narayana  --PradeepT 18 Jan 2018
			  isnull(PaidAmount, 0) AS PaidAmount ,
			  InsurerName ,
			  [Procedure],
			  TotalCount ,
			  RowNumber , 
			  ProviderId,
			  ClientName,
			  Authorizations		--04-Apr-2018	Alok Kumar
		  INTO   #FinalResultSet 
		  FROM   RankResultSet 
		  WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 

		  IF (SELECT Isnull(Count(*), 0) 
				FROM   #FinalResultSet) < 1 
				BEGIN 
					SELECT 0   AS PageNumber 
						   , 0 AS NumberOfPages 
						   , 0 NumberOfRows 
				END 
		  ELSE 
				BEGIN 
					SELECT TOP 1 @PageNumber AS PageNumber 
								 , CASE ( TotalCount % @PageSize ) 
									 WHEN 0 THEN Isnull(( TotalCount / @PageSize ),0) 
									 ELSE Isnull(( TotalCount / @PageSize ), 0) + 1 
								   END NumberOfPages 
								 , Isnull(TotalCount, 0) AS NumberOfRows 
					FROM   #FinalResultSet 
				END
		  
		  SELECT
					ClaimLine           ,
					ClientId			, 
					ProviderName	    ,
					CONVERT(VARCHAR,DOS,101) AS DOS,
					[Status]	        ,
					'$' + CONVERT(VARCHAR, ISNULL(PayableAmount,'0.00'), 10) AS PayableAmount , -- Modified by Lakshmi on 20/12/2018
					'$' + CONVERT(VARCHAR, PaidAmount, 10) AS PaidAmount ,--PradeepT 18 Jan2018
					
					InsurerName         ,
					[Procedure]         ,
					ProviderId ,
					ClientName,
					Authorizations			--04-Apr-2018	Alok Kumar
		  FROM   #FinalResultSet 
		  ORDER  BY Rownumber 
END TRY
BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_CMListPageClientClaimsData')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.  
    16,  -- Severity.  
    1  -- State.  
    );
  END CATCH                 
                  
 END     