

/****** Object:  StoredProcedure [dbo].[ssp_ListPageInquiryDetailsFilter]    Script Date: 09/01/2017 11:15:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageInquiryDetailsFilter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageInquiryDetailsFilter]
GO



/****** Object:  StoredProcedure [dbo].[ssp_ListPageInquiryDetailsFilter]    Script Date: 09/01/2017 11:15:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageInquiryDetailsFilter] 
                                                  
@OrganizationId int,                                                        
@ClientId int,                                                        
@CategoryId int,                                                        
@FromDate datetime,                                                        
@ToDate datetime,                          
@ProviderId int,                                                           
@StaffId int,                                                        
@StatusFilter int,                                                          
@Inquiry char,  --Takes value B,Y,N                                                                                            
@OtherFilter int,
@LoggedInStaffId int    

    
/******************************************************************************                                                          
**  File:                                                           
**  Name: ssp_ListPageInquiryDetailsFilter                                                          
**  Desc: This storeProcedure will return information regarding InquiryListPage based on filters                                                     
**                                                                        
**  Parameters:                                                          
**  Input  Filters                                       
                                                            
**  Output     ----------       -----------                                                          
**  Inquiries Data                                        
                                                        
**  Auth:  Vikas Vyas                                                      
**  Date:  10 may 2010                                                        
*******************************************************************************                                                          
**  Change History                                                          
*******************************************************************************                                                          
**  Date:   Author:     Description:                                                          
**  --------  --------    -------------------------------------------                                                          
**  07 Sep 2010     Jitender Kumar Kamboj  Removed logic of @SessionId,@InstanceId,@PageNumber,@PageSize, @SortExpression                                                     
**  06 Jan 2014     Revathi                what: Added join with StaffClients table to display associated Clients for Login staff
                                           why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter                                                                              
	18 May 2015		Vithobha				Changed the Filter value from GlobalSubCodes to GlobalCodes of CategoryId Philhaven - Customization Issues Tracking #1269                                         
    02 June 2015	Vithobha				Added one more Filter GrievanceType and Implemented the Custom logic based on SystemConfigurationKeys - Philhaven Development: #250                                       
    16 Oct 2015		Revathi					what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName. 
  											why:task #609, Network180 Customization  
  											 
** 01 Sept 2017    PradeepT               What: Added Clients.Active check as it was showing records for InActive client also while on dashboard we are only showing records for Active client which is mismatch
                                          Also removed the commented text and added try/catch.
                                          Why: KCMHSAS - Support-#853    
** 11-May- 2018	  Ponnin				Condition added to check Grievances.InquiryStatus is null to consider Close status on listpage filter. Why : For Philhaven-Support task #355.
** 14-August- 2018	  Neelima			WHAT: Increased the length of 'About' column in temp table, since its throwing error while trying to open the Inquiries list page WHY: SWMBH - Support #1453                      
******************************************************************************/                                        
                                                                                                  
as                    
BEGIN
    BEGIN TRY                                                            
declare @ResultSet table(                      
GrievanceId     int,                                                                                                                                                                                                         
DateReceived     datetime,                                                                               
ClientId        int,                                                         
ClientName      varchar(100),                                                        
DaysLeft        int,                                                                
ComplainantName varchar(50),                                              
Category        varchar(100),                         
About           varchar(400),                                                        
Status      varchar(100),                                                        
OrganizationId  int,                                   
OrganizationName varchar(100),                                                        
 GrievanceType varchar(10),   
Screenid int       
)                                                
                                    
declare @CustomFilters table (GrievanceId int)                               
declare @CustomFiltersApplied char(1)                      
                              
set @CustomFiltersApplied = 'N'                      
                                                         
--Below logic Added by Vithobha for Philhaven Development: #250                                         
Declare @OtherCustomProgram varchar(1)
set @OtherCustomProgram = (select [dbo].[ssf_GetSystemConfigurationKeyValue] ('ShowProgramInOtherDropdown')) 

if @OtherCustomProgram='Y'                    
begin                                      
                              
 set @CustomFiltersApplied = 'Y'                         
                                              
 insert into @CustomFilters (GrievanceId)                                                            
   exec scsp_ListPageGrievancesDetailsFilter    @OrganizationId = @OrganizationId,                                                      
            @ClientId = @ClientId,                                                      
            @CategoryId = @CategoryId,                                                      
            @FromDate = @FromDate,                                                      
            @ToDate = @ToDate,                                                      
            @ProviderId = @ProviderId,                                                         
            @StaffId = @StaffId,                                                      
            @StatusFilter = @StatusFilter,                                                        
            @Inquiry = @Inquiry,                                                                                        
            @OtherFilter =  @OtherFilter                                                               
end
else if @StatusFilter > 10000 or @OtherFilter > 10000 
begin                                                                             
	 set @CustomFiltersApplied = 'Y'           
	                                                                  
	 insert into @CustomFilters (GrievanceId)                                                                                
	   exec scsp_ListPageGrievancesDetailsFilter    @OrganizationId = @OrganizationId,                                                                          
			   @ClientId = @ClientId,                                                            
			   @CategoryId = @CategoryId,                                                                          
			   @FromDate = @FromDate,                                                                          
			   @ToDate = @ToDate,                                                                          
			   @ProviderId = @ProviderId,                                                                             
			   @StaffId = @StaffId,                                                                          
			   @StatusFilter = @StatusFilter,                                                                            
			   @Inquiry = @Inquiry,                                                                                                            
			   @OtherFilter =  @OtherFilter                                                                                   
end                                 
                              
begin                      
  insert into @ResultSet(                      
    GrievanceId,                                                                                
     DateReceived,                                                                                
     ClientId,                                                         
     ClientName,                                                                               
     DaysLeft,                                                                                
     ComplainantName,                                         
     Category,                                                                     
     About,                                                         
     Status,                                                         
     OrganizationId,                                                        
  OrganizationName,
  GrievanceType,
  Screenid                                                                          
   )                                                   
                  
SELECT                                                         
    GrievanceId                                                        
      ,Grievances.[DateReceived]                                                                            
      ,Grievances.[ClientId]                                                         
      --Added by Revathi  16 Oct 2015    
		,CASE 
			WHEN ISNULL(Clients.ClientType, 'I') = 'I'
				THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
			ELSE ISNULL(Clients.OrganizationName, '')
			END AS ClientName                                                          
      ,60- DATEDIFF(day,DateReceived, GETDATE()) as DaysLeft                                                                  
      ,case when Grievances.ComplainantRelationToClient = 5661 and isnull(Grievances.ComplainantName,'') = ''                                                                  
      THEN CASE --Added by Revathi  16-Oct-2015    
						WHEN ISNULL(Clients.ClientType, 'I') = 'I'
							THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
						ELSE ISNULL(Clients.OrganizationName, '')
						END 
      else ComplainantName end as ComplainantName                                                       
      ,GC1.CodeName as  [ComplaintCategory]                                                        
      ,GC2.CodeName + ': ' + GrievanceAboutName  as about                                                 
      , case when InquiryStatus='O' then                                
        'Open'                                
        else                              
        'Close'                                
        end as Status                                                                               
      ,@OrganizationId as 'OrganizationId'                                                                        
      ,(select OrganizationName from SystemDatabases where SystemDatabaseId=@OrganizationId) as 'OrganizationName'                                                          
      --Below logic Added by Vithobha for Philhaven Development: #250  
       ,case when Grievances.Inquiry='Y' then                                  
        'Inquiry'                                  
        when Grievances.Inquiry='N' then   
           'Grievances'                            
        end      
		,case when Grievances.Inquiry='Y' then                                  
        73                                  
        when Grievances.Inquiry='N' then   
           71                           
        end                                                                       
       FROM [Grievances]                                   
                                                  
   left Join Clients on Grievances.ClientId=Clients.ClientId 
   --Added by Revathi on 06 Jan 2014 for task #77 Engineering Improvement Initiatives- NBL(I)
   join Staffclients sc on sc.ClientId=clients.ClientId and sc.StaffId=@LoggedInStaffId                                                          
   Left OUTER JOIN                                                                
   GlobalCodes GC1 ON  GC1.GlobalCodeId=Grievances.ComplaintCategory                                                                
   Left OUTER JOIN                                                                
   GlobalCodes GC2 ON  GC2.GlobalCodeId=Grievances.GrievanceAboutCategory                                                    
 where                                                    
     ISNULL(Clients.RecordDeleted,'N')<>'Y'                                                                       
   and ISNULL(Grievances.RecordDeleted,'N')<>'Y' and (@ClientId=0 or Grievances.ClientId=@ClientId) and                                                     
   --(@CategoryId=10391 or  
  --18 May 2015		Vithobha				Changed the Filter value from GlobalSubCodes to GlobalCodes to GlobalCodes for Philhaven - Customization Issues Tracking #1269
    (ISNULL(@CategoryId,0) = 0 OR Grievances.ComplaintCategory=@CategoryId)      
                  
   and (@StatusFilter=438 or   
    (@StatusFilter=437 and (Grievances.InquiryStatus='C' or Grievances.InquiryStatus is null) )                                                                                   
     or                                 
     (@StatusFilter=436 and Grievances.InquiryStatus='O')                                            
                                     
   )                                                     
   and(                                                  
          
    (@ProviderId=0 and @StaffId=0)      
      or      
     (GrievanceAboutProviderId=@ProviderId and GrievanceAboutStaffId  is null)      
      or      
     (GrievanceAboutStaffId=@StaffId and GrievanceAboutProviderId is  null)      
     or      
     (@ProviderId=0 and  GrievanceAboutProviderId is Not null )      
     or      
     (@StaffId=0 and  GrievanceAboutStaffId is Not null )                                               
   )                                                    
     --Below logic Added by Vithobha for Philhaven Development: #250                                                      
   and (ISNULL(Grievances.Inquiry,'B')=@Inquiry OR ISNULL(@Inquiry,'B')='B')
   and ((@CustomFiltersApplied = 'Y' and exists(SELECT * FROM @CustomFilters cf WHERE cf.GrievanceId = Grievances.GrievanceId))
    OR (@CustomFiltersApplied = 'N')   )                                                                   
and (@FromDate is null or Grievances.DateReceived >= @FromDate)                                                                     
 and (@ToDate is null or Grievances.DateReceived <dateadd(dd, 1, @ToDate)) 
 AND ISNULL(Clients.Active,'Y') = 'Y'---01 Sept 2017    PradeepT                     
               
end                      
                 
                      
select       GrievanceId,                                                                                
     DateReceived,                                                                                
     ClientId,                                                         
     ClientName,                                                                               
     DaysLeft,                                                                                
     ComplainantName,                                         
     Category,                                                                     
     About,                                                         
     Status,                                                         
     OrganizationId,                                                        
 OrganizationName,
 GrievanceType,
 Screenid                                                                    
  from @ResultSet                       
 order by DateReceived desc                      
END TRY
  BEGIN CATCH
  DECLARE @Error varchar(8000)                                                                          
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageInquiryDetailsFilter')                                                
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                            
		+ '*****' + Convert(varchar,ERROR_STATE())                                                                          
	                                                        
		RAISERROR                                                                           
		(                                         
		  @Error, -- Message text.                                                                          
		  16, -- Severity.                                                                          
		  1 -- State.                                                                          
		); 

END CATCH
END
GO

