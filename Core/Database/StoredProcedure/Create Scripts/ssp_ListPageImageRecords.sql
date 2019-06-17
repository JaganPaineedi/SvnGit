
/****** Object:  StoredProcedure [dbo].[ssp_ListPageImageRecords]    Script Date: 4/26/2018 9:40:15 AM ******/
if object_id('ssp_ListPageImageRecords', 'P') is not null
	DROP PROCEDURE [dbo].[ssp_ListPageImageRecords]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageImageRecords]    Script Date: 4/26/2018 9:40:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_ListPageImageRecords]  
  @SessionId VARCHAR(30)  
 ,@InstanceId INT  
 ,@PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(20)  
 ,@LoggedInStaffId INT  
 ,@AssociatedWithFilter INT  
 ,@AssociatedWithIdFilter INT  
 ,@AssociatedIdFilter INT  
 ,@ScannedOrUploadedFilter CHAR(1)  
 ,@ScannedByFilter INT  
 ,@ScannedStatusFilter INT  
 ,@EffectiveFromDateFilter DATETIME  
 ,@EffectiveToDateFilter DATETIME  
 ,@ScannedFromDateFilter DATETIME  
 ,@ScannedToDateFilter DATETIME  
 ,@OtherFilter INT  
 ,@CoveragePlanId INT  
 ,@ProviderId INT  
 /********************************************************************************                                                                                                                          
-- Stored Procedure: dbo.ssp_ListPageImageRecords                                                                                                                            
--                                                                                                                          
-- Copyright: Streamline Healthcate Solutions                                                                                                                          
--                                                                                                                          
-- Purpose: retrieves records form Scanning list page                          
--                                                                                                                          
-- Updates:                                                                                                                                                                                 
-- Date    Author   Purpose                                                                                                                      
-- 08.26.2010  SFarber   Created.                          
-- 09.25.2010  SFarber   Fixed logic that excludes Appeals & Tasks                     
-- 05.09.2011  KaranGarg  Added check for coveragePlanId         
-- 07.27.2012  Rakesh Garg  Made changes for show logged in User Scanned Documents in Case Staff.AllProvidrs = null or N                  
  
-- 07.27.2012  Vaibhav   Made changes for Client order records for showing client id and Name   
-- 04.25.2014  Vichee   Modified- Changed table user to staff CM to SC #18  
-- 08.12.2015  Revathi   what:ListPageImageRecords table Removed and BatchId column added in  Resultset  
            why:task #620 Network 180 - Customizations   
              
-- 26.10.2015  Rajesh   what: Added a condition to fetch all records When Effective date is null and AssociatedWith is Not Associated and All Association.        
            why:task #620 Network 180 - Customizations    - AssociatedFilter is not working when Not Associatd and All Associations are selected  
-- 22-12-2015  Basudev Sahu   Modified For Task #609 Network180 Customization to get Client Name and Organization name   
-- 23-02-2016  Alok Kumar    Added one more parameter ProviderId and filtered based on the selection for #601 SWMBH - Support  
-- 03-03-2016  Alok Kumar    Fixed AssociatedFilter filter issue for Provider and AllAssociations selection for #601.09 SWMBH - Support  
-- 13-07-2016  Shivanand S    Fixed AssociatedFilter filter issue for 'Client(Events)' selection for #AspenPointe-Environment Issues #12  
-- 21-07-2016  Shivanand S    Added AssociatedWithId(5829) to Filter 'Provider Authorisation - Documents' for #AspenPointe-Environment Issues #12  
-- 27-Sep-2016 Gautam               Modify code for Performance issue,Network 180 Environment Issues Tracking ,#339  
-- 20-Nov-2016 Lakshmi Kanth         Added new logic to Access All Scanned Documents, Ionia - Support #370   
-- 04-21-2017 Suhail Ali	Split logic and insert just imageids into temp db first and then perform the remaining logic to improve sp performance!
-- 05-10-2017 Gautam       Added conditions to not display the Clients records if denied in Staff details screen, Task #1198 SWMBH - Support
-- 05-17-2017 MSood		   What: Added the logic to display the Scanned documents based on the selection of Providers and Allow Access to Scan Documents
--						   Why: SWMBH - Support Task# 1198
-- 07-17-2017 Gautam/MSood		   What: Added the logic to display the Scanned documents based on Scanned by as it was not filtering the records on list page
--						   Why: New Direction - Support Task# 675

-- -- 07-17-2017  Sachin	What : When Documentcodes(View)are Denied then, it should not show the records on Scanned List Page, Only Granted Records should show.
                            Why : Camino - Support Go Live #442
-- 13-DEC-2017 Akwinass 	What : Modified SSP to display records for 5821
                            Why : Engineering Improvement Initiatives- NBL(I) 589
-- 29-Jan-2018 Arjun K R    What : ProviderName and InsurerName are added in select statement.
--                          Why : Task #14 SWMBH Enhancement.
-- 26-APR-2018 tremisoski 	What : Modified logic to display records for 5821 - removed lookup into the Services table
--                          Why : ; Bradford SGL #638
-- 28-JUN-2018 tremisoski 	What: Merged changes from Laksshmi -We have implemnted a logic to display scanned documents for customers do not use providers.
--							Why:   MFS - Support Go Live #340
-- 27-JULY-2018 Lakshmi     What: Scanning list page filter issue has been fixed. Please verify the same. 
							Why:  KCMHSAS - Support #1129.1
-- 15-OCT-2018  Lakshmi     What: below logic has been implemented as per the approve from core committee.

							IF Allow Access to All  Scanned Documents is checked :
							Allow access to all scanned documents even if the staff is not associated with the program in the staff details								however  it should still look at the staff client access and deny access to clients that the staff doesn't have								access to view

							IF Allow Access to All Scanned Documents is NOT checked :
							Allow access to Scanned documents based on the Programs associated Section of the Staff Details  screen										however it should still look at the staff client access and deny access to client that the staff doesn't have								access to view

							Why: MFS - Support Go Live #340
-- 03-DEC-2018 Himmat      What: Scanning list page filter perfomanance issue has been fixed. Please verify the same. 
							Why:  Harbor Build Cycle Tasks#54		
-- 07-Mar-2019 Bibhu       What: Rearranged the Code and Parameter Sniffing to improve perfomanance . 
							Why:  AspenPointe - Support Go Live#915					
*********************************************************************************/  
AS  
BEGIN  

Declare  @VarPageNumber INT  =@PageNumber      
 , @VarPageSize INT    = @PageSize
 , @VarSortExpression VARCHAR(20) =@SortExpression        
 , @VarLoggedInStaffId  INT  =@LoggedInStaffId     
 , @VarAssociatedWithFilter INT =@AssociatedWithFilter       
 , @VarAssociatedWithIdFilter INT   =@AssociatedWithIdFilter     
 , @VarAssociatedIdFilter  INT  =@AssociatedIdFilter     
 , @VarScannedOrUploadedFilter CHAR(1)  =@ScannedOrUploadedFilter     
 , @VarScannedByFilter INT =@ScannedByFilter 
 , @VarScannedStatusFilter INT = @ScannedStatusFilter         
 , @VarEffectiveFromDateFilter DATETIME  =@EffectiveFromDateFilter      
 , @VarEffectiveToDateFilter DATETIME  =@EffectiveToDateFilter      
 , @VarScannedFromDateFilter DATETIME =@ScannedFromDateFilter       
 , @VarScannedToDateFilter DATETIME =@ScannedToDateFilter        
 , @VarOtherFilter  INT =@OtherFilter      
 , @VarCoveragePlanId INT =@CoveragePlanId       
 , @VarProviderId  INT =@ProviderId  
 
 BEGIN TRY  

  CREATE TABLE #ResultSetIds (  
	ImageRecordId INT NOT NULL
  );

  ALTER TABLE #ResultSetIds ADD CONSTRAINT PK_ResultSetIds PRIMARY KEY CLUSTERED (ImageRecordId);

  CREATE TABLE #ResultSet (  
   ImageRecordId INT  NOT NULL
   ,AssociatedWith VARCHAR(100)  
   ,AssociatedWithId INT  
   ,AssociatedWithName VARCHAR(100)  
   ,AssociatedWithScreenId INT  
   ,AssociatedId INT  
   ,AssociatedIdName VARCHAR(300)  
   ,ScannedDate DATETIME  
   ,EffectiveDate DATETIME  
   ,ScannedBy INT  
   ,ScannedByName VARCHAR(100)  
   ,StatusName VARCHAR(50)  
   ,ImageServerId INT  
   ,ScannedOrUploaded CHAR(1)  
   ,BatchId INT  
   ,ProviderId INT  
   ,ImageRecProviderId INT  
   ,IrAssociatedWith INT  
   )  
  
  CREATE TABLE #CustomFilters (ImageRecordId INT)  
  
  DECLARE @Today DATETIME  
  DECLARE @ApplyFilterClicked CHAR(1)  
  DECLARE @CustomFiltersApplied CHAR(1)  
  --Added By Rakesh Get  values for All provider base from Staff based @LoggedInStaffId                        
  DECLARE @AllowAccessToAllScannedDocuments AS CHAR(1)
  
  --table name changed by vichee to staff 04-25-2014  
  SELECT @AllowAccessToAllScannedDocuments = Isnull(AllowAccessToAllScannedDocuments, 'N') ----20-Nov-2016 Lakshmi Kanth  
  FROM Staff  
  WHERE StaffId = @VarLoggedInStaffId  
   AND Isnull(RecordDeleted, 'N') = 'N'  
  
  -- JHB 8/8/2012 If Staff is not set up then assume that each user has access to all providers  
  IF NOT EXISTS (  
    SELECT *  
    FROM Staff  
    WHERE StaffId = @VarLoggedInStaffId  
     AND Isnull(RecordDeleted, 'N') = 'N'  
    )  
   SELECT @AllowAccessToAllScannedDocuments = 'Y'  
  
    
  SET @Today = convert(CHAR(10), getdate(), 101)  
  SET @CustomFiltersApplied = 'N'  
  
  
   --  -- Sachin     
  CREATE TABLE #DocumentCodeViewPermissions (DocumentCodeId INT)    
  INSERT INTO #DocumentCodeViewPermissions    
  SELECT PermissionItemId    
  FROM ViewStaffPermissions    
  WHERE StaffId = @VarLoggedInStaffId    
  AND PermissionTemplateType=5924   
  
 ---- end 
 
  -- Get custom filters                                                
  IF @VarOtherFilter > 10000  
   OR @VarScannedStatusFilter > 10000  
  BEGIN  
   IF OBJECT_ID('dbo.scsp_ListPageImageRecords', 'P') IS NOT NULL  
   BEGIN  
    SET @CustomFiltersApplied = 'Y'  
  
    INSERT INTO #CustomFilters (ImageRecordId)  
    EXEC scsp_ListPageImageRecords @LoggedInStaffId = @VarLoggedInStaffId  
     ,@AssociatedWithFilter = @VarAssociatedWithFilter  
     ,@AssociatedWithIdFilter = @VarAssociatedWithIdFilter  
     ,@AssociatedIdFilter = @VarAssociatedIdFilter  
     ,@ScannedOrUploadedFilter = @VarScannedOrUploadedFilter  
     ,@ScannedByFilter = @VarScannedByFilter  
     ,@ScannedStatusFilter = @VarScannedStatusFilter  
     ,@EffectiveFromDateFilter = @VarEffectiveFromDateFilter  
     ,@EffectiveToDateFilter = @VarEffectiveToDateFilter  
     ,@ScannedFromDateFilter = @VarScannedFromDateFilter  
     ,@ScannedToDateFilter = @VarScannedToDateFilter  
     ,@OtherFilter = @VarOtherFilter  
   END  
  END  
  

     
  INSERT INTO #ResultSetIds (
   ImageRecordId  
  )
  SELECT ir.ImageRecordId  
  FROM ImageRecords ir  
  WHERE ((@CustomFiltersApplied = 'Y'  
     AND EXISTS (SELECT *  
      FROM #CustomFilters cf  
      WHERE cf.ImageRecordId = ir.ImageRecordId)  
     )  
    OR (@CustomFiltersApplied = 'N'  
     AND isnull(ir.CoveragePlanId, 0) = @VarCoveragePlanId -- Check for Coverage Plan Id                    
     AND isnull(ir.AssociatedWith, 0) NOT IN (5817,5818) -- Exclude Appeals & Tasks                          
     AND isnull(ir.RecordDeleted, 'N') = 'N'  
     AND (ir.EffectiveDate >= @VarEffectiveFromDateFilter  
      OR @VarEffectiveFromDateFilter IS NULL  
      OR @VarEffectiveFromDateFilter = ''  
      OR ((isnull(@VarAssociatedWithFilter, 0) = -1 OR isnull(@VarAssociatedWithFilter, 0) = 0)  AND ir.EffectiveDate is null)) -- Added by Rajesh - AssociatedFilter is not working when Not Associatd and All Associations are selected  
     AND (ir.EffectiveDate < dateadd(dd, 1, @VarEffectiveToDateFilter)  
      OR @VarEffectiveToDateFilter IS NULL  
      OR @VarEffectiveToDateFilter = ''  
      OR ((isnull(@VarAssociatedWithFilter, 0) = -1 OR isnull(@VarAssociatedWithFilter, 0) = 0)  AND ir.EffectiveDate is null))    
     AND (ir.CreatedDate >= @VarScannedFromDateFilter  
      OR @VarScannedFromDateFilter IS NULL  
      OR @VarScannedFromDateFilter = '')  
     AND (ir.CreatedDate < dateadd(dd, 1, @VarScannedToDateFilter)  
      OR @VarScannedToDateFilter IS NULL  
      OR @VarScannedToDateFilter = '')  
     AND (ir.ScannedOrUploaded = @VarScannedOrUploadedFilter  
      OR isnull(@VarScannedOrUploadedFilter, '') = '')    
     AND (ir.AssociatedId = @VarAssociatedIdFilter OR isnull(@VarAssociatedIdFilter, 0) <= 0)  
     AND (@VarScannedStatusFilter = '130'  
       OR -- All Statuses                                                                                        
        (@VarScannedStatusFilter = '131'  
         AND -- Completed                          
         ((ir.AssociatedWith IN (5811,5812,5813,5820)  
          AND ir.ClientId IS NOT NULL  
          AND ir.EffectiveDate IS NOT NULL  
          AND ir.AssociatedId IS NOT NULL  
          )  
         OR (ir.AssociatedWith = 5814  
          AND ir.StaffId IS NOT NULL  
          AND ir.EffectiveDate IS NOT NULL  
          AND ir.AssociatedId IS NOT NULL)  
         OR (ir.AssociatedWith = 5815  
          AND ir.ProviderId IS NOT NULL  
          AND ir.EffectiveDate IS NOT NULL  
          AND ir.AssociatedId IS NOT NULL)  
         OR (ir.AssociatedWith = 5816  
          AND ir.EffectiveDate IS NOT NULL  
          AND ir.AssociatedId IS NOT NULL ) 
         OR (ir.AssociatedWith = 5821 and ir.ServiceId is not null)
         ))  
      OR (@VarScannedStatusFilter = '132'  
       AND -- Not Completed                          
       (ir.AssociatedWith IS NULL  
        OR   
        (ir.AssociatedWith IN (5811,5812,5813,5820)  
         AND (ir.ClientId IS NULL  
          OR ir.EffectiveDate IS NULL  
          OR ir.AssociatedId IS NULL)  
         )  
        OR (ir.AssociatedWith = 5814  
         AND (ir.StaffId IS NULL  
          OR ir.EffectiveDate IS NULL  
          OR ir.AssociatedId IS NULL)  
         )  
        OR (ir.AssociatedWith = 5815  
         AND (ir.ProviderId IS NULL  
          OR ir.EffectiveDate IS NULL  
          OR ir.AssociatedId IS NULL)  
         )  
        OR (ir.AssociatedWith = 5816  
         AND (ir.EffectiveDate IS NULL  
          OR ir.AssociatedId IS NULL)  
         )
		 OR (ir.AssociatedWith = 5821 AND ir.ServiceId is null)
        )  
       )  
      )  
     AND ((isnull(@VarAssociatedWithFilter, 0) = 0) -- All Associations  
       --AND ir.AssociatedWith IS NOT NULL) -Commented by Rajesh - AssociatedFilter is not working when Not Associatd and All Associations are selected  
      OR                           
      (isnull(@VarAssociatedWithFilter, 0) = -1 -- Not Associated Yet  
       AND ir.AssociatedWith IS NULL)  
      OR                           
      (@VarAssociatedWithFilter IN (5811,5812,5813,5820,5829,5821) -- 21-07-2016  Shivanand S   
       AND ir.AssociatedWith = @VarAssociatedWithFilter  
       AND (ir.ClientId = @VarAssociatedWithIdFilter  
        OR isnull(@VarAssociatedWithIdFilter, 0) <= 0)  
       )  
      OR (@VarAssociatedWithFilter = 5814  
       AND ir.AssociatedWith = @VarAssociatedWithFilter  
       AND (ir.StaffId = @VarAssociatedWithIdFilter  
        OR isnull(@VarAssociatedWithIdFilter, 0) <= 0)  
       )  
      OR (@VarAssociatedWithFilter = 5815  AND ir.AssociatedWith=@VarAssociatedWithFilter --29-Jan-2018 Arjun K R
		AND (ir.ProviderId = @VarProviderId  
        OR isnull(@VarProviderId, 0) <= 0)
       )           
      )  
     )  
    )  

     
  /* SA 5/17/2017 - Take ImageRecordIds and add information displayed by list page. Additionally moved a predicate WHERE clause from above query 
				    that checks ProviderStaff table into this query because it was for some strange reason running slowly in the above query. */
    ;  
   with ResultSet as (
	  SELECT ir.ImageRecordId  
	   ,AssociatedWith = isnull(gcaw.CodeName, 'Not Associated')  
	   ,AssociatedWithId = CASE  WHEN ir.AssociatedWith IN (5811 ,5812,5813,5820,5828,5821)  
		 THEN ir.ClientId  
		WHEN ir.AssociatedWith = 5814  
		 THEN s.StaffId  
		WHEN ir.AssociatedWith = 5815  
		 THEN p.ProviderId  
		ELSE NULL  
		END  
	   ,AssociatedWithName = CASE   
		WHEN ir.AssociatedWith IN (5811 ,5812,5813,5820,5828,5821)  
		 THEN  
		 CASE WHEN ISNULL(ir.ClientId,0) <> 0 THEN   
		 CASE       
		 WHEN ISNULL(C.ClientType, 'I') = 'I'  
		  THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  
		 ELSE ISNULL(C.OrganizationName, '')  
		 END ELSE '' END  
		 --c.LastName + ', ' + c.FirstName  
		WHEN ir.AssociatedWith = 5814  
		 THEN s.LastName + ', ' + s.FirstName  
		WHEN ir.AssociatedWith = 5815  
		 THEN p.ProviderName + CASE   
		   WHEN len(p.FirstName) > 0  
			THEN ', ' + p.FirstName  
		   ELSE ''  
		   END  
		ELSE NULL  
		END  
	   ,AssociatedWithScreenId = CASE WHEN ir.AssociatedWith IN (5811,5812)  
		 THEN 19  
		ELSE NULL  
		END  
	   ,ir.AssociatedId  
	   ,AssociatedIdName =CASE   
		WHEN ir.AssociatedWith IN (5811)  
		 THEN dc.DocumentName  
		WHEN ir.AssociatedWith IN (5813)  
		 THEN et.EventName  
		ELSE gcan.CodeName  
		END + CASE   
		WHEN ir.RecordDescription IS NOT NULL  
		 THEN ' (' + ir.RecordDescription + ')'  
		ELSE ''  
		END  
	   ,ScannedDate = ir.CreatedDate  
	   ,ir.EffectiveDate  
	   ,ir.ScannedBy  
	   ,ScannedByName = sb.LastName + ', ' + sb.FirstName 
	   ,StatusName = CASE   
		WHEN (ir.AssociatedWith IN (5811,5812,5813,5820)  
		  AND ir.ClientId IS NOT NULL  
		  AND ir.EffectiveDate IS NOT NULL  
		  AND ir.AssociatedId IS NOT NULL )  
		 OR (ir.AssociatedWith = 5814  
		  AND ir.StaffId IS NOT NULL  
		  AND ir.EffectiveDate IS NOT NULL  
		  AND ir.AssociatedId IS NOT NULL)  
		 OR (ir.AssociatedWith = 5815  
		  AND ir.ProviderId IS NOT NULL  
		  AND ir.EffectiveDate IS NOT NULL  
		  AND ir.AssociatedId IS NOT NULL)  
		 OR (ir.AssociatedWith = 5816  
		  AND ir.EffectiveDate IS NOT NULL  
		  AND ir.AssociatedId IS NOT NULL)
		 OR (ir.AssociatedWith = 5821 and ir.ServiceId is not null)
		 THEN 'Completed'  
		ELSE 'Not Completed'  
		END  
	   ,ir.ImageServerId  
	   ,ir.ScannedOrUploaded  
	   ,Ir.BatchId  
	   ,P.ProviderId  
	   ,P.ProviderName     
	   ,ImageRecProviderId = ir.ProviderId  
	   ,IrAssociatedWith = ir.AssociatedWith  
	   ,INS.InsurerId
	   ,INS.InsurerName
	  FROM #ResultSetIds ids INNER JOIN ImageRecords ir  ON
		ids.ImageRecordId = ir.ImageRecordId
	  LEFT JOIN GlobalCodes gcaw ON 
		gcaw.GlobalCodeId = ir.AssociatedWith  
	  LEFT JOIN Clients c ON 
		c.ClientId = ir.ClientId  
	  LEFT JOIN StaffClients sc ON 
		sc.StaffId = @VarLoggedInStaffId AND 
		sc.ClientId = ir.ClientId  
	  LEFT JOIN Staff s ON 
		s.StaffId = ir.StaffId  
	  LEFT JOIN Providers p ON 
		p.ProviderId = ir.ProviderId AND 
		p.UsesProviderAccess = 'Y' AND 
		isnull(p.RecordDeleted, 'N')= 'N' AND 
		p.Active = 'Y'
	  LEFT JOIN DocumentCodes dc ON 
	   dc.DocumentCodeId = ir.AssociatedId AND
	   ir.AssociatedWith IN (5811)  
	  LEFT JOIN EventTypes et ON 
	   et.EventTypeId = ir.AssociatedId AND 
	   ir.AssociatedWith = 5812  
	  LEFT JOIN Staff sb ON 
	   sb.StaffId = ir.ScannedBy  
	  LEFT JOIN GlobalCodes gcan ON 
	   gcan.GlobalCodeId = ir.AssociatedId  
	   AND ir.AssociatedWith NOT IN (5811,5812 )  
	  LEFT JOIN Insurers INS ON INS.InsurerId=ir.InsurerId AND INS.Active ='Y' AND ISNULL(INS.RecordDeleted,'N')='N'
				AND ir.AssociatedWith IN (5812)    --29-Jan-2018 Arjun K R
	WHERE 
	 -- MSood 5/17/2017 -- msood 7/17/2017
		(ir.ScannedBy = @VarScannedByFilter OR isnull(@VarScannedByFilter, 0) <= 0)  
    --AND (isnull(@AllowAccessToAllScannedDocuments, 'N') = 'Y'
    AND (isnull(@AllowAccessToAllScannedDocuments, 'N') = 'Y' 
     AND (ir.ClientId IS NULL OR exists(Select 1 From StaffClients sc WHERE sc.StaffId = @VarLoggedInStaffId AND sc.ClientId = ir.ClientId))  -- -- 07-Mar-2019 Bibhu
      
    
		OR (EXISTS( SELECT DocumentCodeId FROM #DocumentCodeViewPermissions DCV WHERE ir.AssociatedId =DCV.DocumentCodeId 
		  AND IR.ScannedBy=@VarLoggedInStaffId AND EXISTS (SELECT 1 FROM staffprograms stp inner join clientprograms clp 
		  ON stp.programid=clp.programid WHERE clp.clientid=ir.clientid and stp.staffid = @VarLoggedInStaffId 
		  and ir.scannedby=@VarLoggedInStaffId and ISNULL(stp.recorddeleted, 'n') = 'n' 
		  and isnull(clp.recorddeleted, 'n') = 'n') OR (ir.ClientId IS NULL and ir.scannedby=@VarLoggedInStaffId))
		  AND (ir.ClientId IS NULL OR EXISTS (SELECT 1 FROM StaffClients sc WHERE sc.StaffId = @VarLoggedInStaffId     
		  AND sc.ClientId = ir.ClientId ))) -- 07-Mar-2019 Bibhu  
	
       OR (EXISTS(SELECT DocumentCodeId FROM #DocumentCodeViewPermissions DCV WHERE ir.AssociatedId =DCV.DocumentCodeId AND EXISTS (SELECT 1             FROM staffprograms stp inner join clientprograms clp ON stp.programid=clp.programid 
		WHERE clp.clientid=ir.clientid and stp.staffid = @VarLoggedInStaffId and isnull(stp.recorddeleted, 'n') = 'n' 
		and isnull(clp.recorddeleted, 'n') = 'n'))AND EXISTS(SELECT 1 FROM StaffClients sc WHERE sc.StaffId = @VarLoggedInStaffId 
		AND sc.ClientId = ir.ClientId)) --Modified by Lakshmi on 27-07-2018		 	
       
   OR ( EXISTS( Select 1 From Staff   
      WHERE StaffId = @VarLoggedInStaffId AND isnull(AllProviders, 'N') = 'Y'   
      AND isnull(Active, 'N') = 'Y' and isnull(RecordDeleted, 'N') <> 'Y')AND IR.ScannedBy=@VarLoggedInStaffId)
   
   OR ( EXISTS( Select * From StaffProviders SP   
                 Join Providers P On P.ProviderId= sp.ProviderId   
     Join Staff S On S.StaffId= sp.StaffId   
      WHERE S.StaffId = @VarLoggedInStaffId AND   
      IR.ScannedBy=@VarLoggedInStaffId and  
      isnull(S.AllProviders, 'N') = 'N'   
      AND isnull(sp.RecordDeleted, 'N') = 'N'  
      AND isnull(S.Active, 'N') = 'Y' AND isnull(S.RecordDeleted, 'N') = 'N'))     
      
  --    OR (EXISTS(Select 1 From StaffClients sc WHERE  --Added by Lakshmi on 27-03-2018  
		--sc.StaffId = @VarLoggedInStaffId AND 
		--sc.ClientId = ir.ClientId AND IR.ScannedBy=@VarLoggedInStaffId AND EXISTS (select 1 from staffprograms stp inner join clientprograms clp on stp.programid=clp.programid where clp.clientid=ir.clientid and stp.staffid = @VarLoggedInStaffId and ir.scannedby=@VarLoggedInStaffId and isnull(stp.recorddeleted, 'n') = 'n' and isnull(clp.recorddeleted, 'n') = 'n')))--Modified by Lakshmi on 27-07-2018
     )
   ), ImageDetails as  
  ( Select P.ImageRecordId  
   ,P.AssociatedWith  
   ,P.AssociatedWithId  
   ,P.AssociatedWithName  
   ,P.AssociatedWithScreenId  
   ,P.AssociatedId  
   ,P.AssociatedIdName  
   ,P.ScannedDate  
   ,P.EffectiveDate  
   ,P.ScannedBy  
   ,P.ScannedByName  
   ,P.StatusName  
   ,P.ImageServerId  
   ,P.ScannedOrUploaded  
   ,P.BatchId  
   ,P.ProviderId   
   ,P.ProviderName ---29-Jan-2018 Arjun K R
   ,P.ImageRecProviderId  
   ,P.IrAssociatedWith  
   ,P.InsurerId    ----29-Jan-2018 Arjun K R
   ,P.InsurerName
  From ResultSet P  
  Where (isnull(@VarAssociatedWithFilter, 0) in (-1 ,5829,5814)  
   OR (isnull(@VarAssociatedWithFilter, 0) in (0,5811 ,5812,5813,5820,5828,5821) -- 05-10-2017 Gautam 
       And not exists(Select 1 from StaffPermissionExceptions SP where SP.PermissionTemplateType=5741
					and SP.Allow='N' and SP.StaffId=@VarLoggedInStaffId and SP.PermissionItemId=P.AssociatedWithId
					and isnull(SP.RecordDeleted, 'N') ='N')
       )
   OR (@VarAssociatedWithFilter = 5815  
       AND P.IrAssociatedWith = @VarAssociatedWithFilter  
       AND (P.ImageRecProviderId = @VarAssociatedWithIdFilter  
        OR isnull(@VarAssociatedWithIdFilter, 0) <= 0)  
       )  
     or (@VarAssociatedWithFilter = 5815  AND isnull(@VarProviderId, 0) > 0 AND isnull(@VarAssociatedWithFilter, 0) <> 0    
      AND EXISTS (    
     SELECT 1 FROM StaffProviders ST WHERE ST.ProviderId = p.ProviderId    
      AND ST.StaffId = @VarLoggedInStaffId AND isnull(ST.RecordDeleted, 'N') ='N'  )  
       AND p.ProviderId = @VarProviderId    
       )  
   or (@VarAssociatedWithFilter = 5815  AND isnull(@VarProviderId, 0) = 0    
    AND EXISTS (    
       SELECT 1 FROM StaffProviders SP WHERE SP.ProviderId = P.ImageRecProviderId    
        AND isnull(SP.RecordDeleted, 'N') ='N' AND SP.StaffId = @VarLoggedInStaffId    
        )    
        )     
     )
)    
,Counts AS (  
   SELECT Count(*) AS TotalRows  
   FROM ImageDetails  
   )  
   ,RankResultSet  
  AS (  
   SELECT ImageRecordId  
    ,AssociatedWith  
    ,AssociatedWithId  
    ,AssociatedWithName  
    ,AssociatedWithScreenId  
    ,AssociatedId  
    ,AssociatedIdName  
    ,ScannedDate  
    ,EffectiveDate  
    ,ScannedBy  
    ,ScannedByName  
    ,StatusName  
    ,ImageServerId  
    ,ScannedOrUploaded
    --29-Jan-2018 Arjun K R 
    ,ProviderName  
    ,InsurerName  
    ,Count(*) OVER () AS TotalCount  
    ,row_number() OVER (ORDER BY CASE WHEN @VarSortExpression = 'AssociatedWith' THEN AssociatedWith END  
    ,CASE WHEN @VarSortExpression = 'AssociatedWith desc' THEN AssociatedWith END DESC  
    ,CASE WHEN @VarSortExpression = 'AssociatedWithId'   THEN AssociatedWithId END  
    ,CASE WHEN @VarSortExpression = 'AssociatedWithId desc' THEN AssociatedWithId END DESC  
    ,CASE WHEN @VarSortExpression = 'AssociatedWithName'    THEN AssociatedWithName END  
    ,CASE WHEN @VarSortExpression = 'AssociatedWithName desc' THEN AssociatedWithName END DESC  
    ,CASE WHEN @VarSortExpression = 'AssociatedIdName' THEN AssociatedIdName  END  
    ,CASE WHEN @VarSortExpression = 'AssociatedIdName DESC' THEN AssociatedIdName END DESC  
    ,CASE WHEN @VarSortExpression = 'ScannedDate' THEN ScannedDate END  
    ,CASE WHEN @VarSortExpression = 'ScannedDate desc' THEN ScannedDate END DESC  
    ,CASE WHEN @VarSortExpression = 'EffectiveDate' THEN EffectiveDate END  
    ,CASE WHEN @VarSortExpression = 'EffectiveDate desc' THEN EffectiveDate END DESC  
    ,CASE WHEN @VarSortExpression = 'ScannedBy' THEN ScannedByName END  
    ,CASE WHEN @VarSortExpression = 'ScannedBy desc' THEN ScannedByName END DESC  
    ,CASE WHEN @VarSortExpression = 'StatusName' THEN StatusName END  
    ,CASE WHEN @VarSortExpression = 'StatusName desc' THEN StatusName END DESC  
    ,CASE WHEN @VarSortExpression = 'BatchId' THEN BatchId END  
    ,CASE WHEN @VarSortExpression = 'BatchId desc' THEN BatchId END DESC  
    ,CASE WHEN @VarSortExpression = 'ProviderName' THEN ProviderName END  
    ,CASE WHEN @VarSortExpression = 'ProviderName desc' THEN ProviderName END DESC
    ,CASE WHEN @VarSortExpression = 'InsurerName' THEN InsurerName END  
    ,CASE WHEN @VarSortExpression = 'InsurerName desc' THEN InsurerName END DESC
    ,AssociatedWithName  
    ,AssociatedIdName  
    ,ScannedDate DESC  
    ,ImageRecordId  
    ) AS RowNumber  
    ,BatchId  
   FROM ImageDetails  
   )  
  SELECT TOP (CASE WHEN (@VarPageNumber = - 1)  
      THEN (SELECT Isnull(TotalRows, 0)  
        FROM Counts)  
     ELSE (@VarPageSize)  
     END  
    ) ImageRecordId  
   ,AssociatedWith  
   ,AssociatedWithId  
   ,AssociatedWithName  
   ,AssociatedWithScreenId  
   ,AssociatedId  
   ,AssociatedIdName  
   ,ScannedDate  
   ,EffectiveDate  
   ,ScannedBy  
   ,ScannedByName  
   ,StatusName  
   ,ImageServerId  
   ,ScannedOrUploaded  
   ,BatchId
   --29-Jan-2018 Arjun K R
   ,ProviderName 
   ,InsurerName  
   ,TotalCount  
   ,RowNumber  
  INTO #FinalResultSet  
  FROM RankResultSet  
  WHERE RowNumber > ((@VarPageNumber - 1) * @VarPageSize)  
  
  IF (SELECT Isnull(Count(*), 0)  
    FROM #FinalResultSet) < 1  
  BEGIN  
   SELECT 0 AS PageNumber  
    ,0 AS NumberOfPages  
    ,0 NumberofRows  
  END  
  ELSE  
  BEGIN  
   SELECT TOP 1 @VarPageNumber AS PageNumber  
    ,CASE (Totalcount % @VarPageSize)  
     WHEN 0  
      THEN Isnull((Totalcount / @VarPageSize), 0)  
     ELSE Isnull((Totalcount / @VarPageSize), 0) + 1  
     END AS NumberOfPages  
    ,Isnull(Totalcount, 0) AS NumberofRows  
   FROM #FinalResultSet  
  END  
  
  SELECT ImageRecordId  
   ,AssociatedWith  
   ,AssociatedWithId  
   ,AssociatedWithName  
   ,AssociatedWithScreenId  
   ,AssociatedId  
   ,AssociatedIdName  
   ,ScannedDate  
   ,EffectiveDate  
   ,ScannedBy  
   ,ScannedByName  
   ,StatusName  
   ,ImageServerId  
   ,ScannedOrUploaded  
   ,BatchId  
   --29-Jan-2018 Arjun K R
   ,ProviderName    
   ,InsurerName
  FROM #FinalResultSet  
  ORDER BY RowNumber  
 END TRY  
  
  
  BEGIN CATCH  
          DECLARE @error VARCHAR(8000)  
  
          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'  
                      + CONVERT(VARCHAR(4000), Error_message())  
                      + '*****'  
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),  
                      'ssp_ListPageImageRecords')  
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


