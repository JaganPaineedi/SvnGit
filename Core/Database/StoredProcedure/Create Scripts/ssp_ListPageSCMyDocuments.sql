 if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_ListPageSCMyDocuments]')
                    and type in (N'P', N'PC') ) 
    drop procedure [dbo].[ssp_ListPageSCMyDocuments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
 CREATE procedure [dbo].[ssp_ListPageSCMyDocuments]              
@SessionId varchar(30),                                                          
@InstanceId int,                                                          
@PageNumber int,                                                              
@PageSize int,                                                              
@SortExpression varchar(100),                                                          
@LoggedInStaffId int,                 
@StaffId int,                 
@ClientsFilter varchar(50),                                                         
@DocumentNavigationIdFilter int,                                          
@DocumentStatusFilter int,                                      
@DueDaysFilter int,                                                                                                               
@OtherFilter int, 
@DosFrom datetime='', -- 20.12.2016	Ravichandra
@DosTo datetime=''    -- 20.12.2016	Ravichandra                                               
/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_ListPageSCMyDocuments                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: used by  Attach/Review My Documents list page                                                          
--                                                          
-- Updates:                                                                                                                 
-- Date        Author      Purpose                                                          
-- 01.25.2010  Ankesh      Created.                                                                
-- 05.11.2010  Mahesh      Add ServiceId and Alter the table ListPageSCMyDocuments for add ServiceId column                  
-- 06.25.2010  SFarber     Modified custom filters logic.  Added StaffClients.  Added @DocumentNavigationIdFilter              
-- 07.07.2010  SFarber     Modified to use ssp_GetDocumentNavigationDocumentCodes              
-- 07.09.2010  SFarber     Added logic to support Supervisor view (@LoggedInStaffId).              
-- 07.14.2010  SFarber     Modified To Co-Sign logic.              
-- 07.21.2010  SFarber     Optimized performance.              
-- 06.02.2011  Damanpreet  Add To Acknowlage ref: Task#177 Document Acknowledgement and Comment       
-- 30oct2011   Pradeep     Added Primary key in #ResultSet and getting rownumber based on it as per task#30(HuneyBager)            
-- 14Oct2011  Shifali    Changes by Shifali in ref to task# 11 (To Be Reviewed Document Status)    
-- 23Dec2011  Shifali    Modified in ref to remove Shared Column as per DM changes    
-- 28Dec2011  Rakesh Garg  Modifiedin ref to remove Shared Column as per DM changes & Get Author Value    
-- 02.05.2012 Vikas        Added CustomLogic w.r.t. Task#10 Threshold Phase III       
-- 02.29.2012 avoss  match dashboard and listpage review changes and proxy changes    
-- 06.22.2012  Sanjayb/Amit Kumar Srivastava, #1721,  Harbor Go Live Issues,       
                The My Document banner has no "To co-sign" in th filter drop down. The co-signed document is not showing up when filtering       
                by this. In the dashboard the widget Documents is not showing the "To Co-sign" document. See attached video.        
--19 Nov 2012 Vikas Kashyap What: Optimaization SP Remove '*' sign    
--         Why:More Exicution Time   
--13 Dec 2012  Maninder    Made changes in Column ClientToSign to show relevent message: Task#7 in Development Phase IV(Offshore)  
--08-Feb 2013  Rakesh Garg  Changed "or" to "and" for the Due-In filters for due  within 14 days, 5 & 3 weeks w.rf to task 2707 list pages; to do documents in threshold Bugs/Features   
--JHB 2/12/2013 In case there is an in progress document for a To Do document for same client, document code, author  
 -- then link to In Progress document   
-- 06.17.2013  SFarber Replaced table variables with temp tables to improve performance     
-- 06.24.2014  Gautam      What : Removed the table ListPageSCMyDocuments from SP and call csp_ListPageSCMyDocuments in place of scsp_ListPageSCMyDocuments  
         why : Ace task#107,Engineering Improvement Initiatives- NBL(I)    
-- 002.06.2015  Vamsi    What:Need To display procedure code behind the service note type.    
--                     Why:Valley - Customizations #924      
--17-DEC-2015    Basudev Sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName   
-- JUNE-13-2016 Akwinass  What: Included HasMoreThanOneVersion column
                          Why: To display whether the document has more than one version or not (Task #383 in Philhaven Development)  
-- 06.27.2016	Wasif Butt	Replaced table variable with temp tables to improve performance   
-- 20.12.2016	Ravichandra	What: Added Date Filters Paramter @DosFrom and @DosTo and included  All Statuses in Status drop down
							why : Bradford - Customizations Tasks #289--My Documents List page: Add 'All Statuses' to status drop down >  
--02/10/2017      jcarlson       Keystone Customizations 69 - increased documentname length to 175 to handle procedure code display as increasing to 75 
 06/14/2017	Msood	What: Added the conditions to check all StaffId with DocumentAssignedTasks
					Why: Showing wrong number of records on My Documents list page, Pathway - Support Go Live Task# 159		
					
 -- SEP-22-2016 Chita Ranjan   What: Added new column AssociateDocuments to display all associted documents in the list page
                               Why: Thresholds-Enhancements – Task# 838	
 --27/10/2017 Sunil.D          What: Extened Logic written by Chitta In Above Comments "SEP-22-2016 Chita Ranjan"
                               Why: As Per Requirement it is needed,Thresholds-Enhancements – Task# 838	
 --17/01/2018   Arjun K R      Modified to pull co-signer staffs and co-signer clients and guardian. Task #113 MHP Customizations.				
 --16/03/2018   Neha           What: Added a new column 'Group Name' to display the Group name if the document is a Group Service Note.
                               Why: MHP-Enhancements – Task# 193
 --29/03/2018   Neha           What: Removed conversion for Effective date, since time part is also required to be displayed on list page based on configuration.
                               Why: MHP-Enhancements – Task# 107
--04/26/2018  Rega			Updated the limit of characters in #result set select statement. Task #234 springriver SGL
--6/27/2018   Robert Caffrey  Increased Datatype to Varchar150 for ClientToSign field in #ResultSet - Multiple Client Contacts Selected - KeyPoint #1345	                               
-- 10/29/2018	Chethan N		What : 1. Showing Current Status of the document for both Author and Non-Author.
									   2. Displaying the count of versions in Ver column instead of 'Yes' or 'No'.
								Why : Valley - Support Go Live task # 1601
*********************************************************************************/                                                          
as                                                          
BEGIN  
BEGIN TRY  
                                                                                                                 
create table #ResultSet (                  
ListPageSCMyDocumentId [bigint] IDENTITY(1,1) NOT NULL,                                      
RowNumber        int,                                                            
PageNumber       int,                                       
ClientId         int,                                                          
ClientName       varchar(100),                  
DocumentId       int,                  
ServiceId        int,                
DocumentCodeId   int,                        
DocumentScreenId int,                    
DocumentName     varchar(175),                   
EffectiveDate    datetime,                  
Status           int,                    
StatusName       varchar(50),                   
DueDate          datetime,                    
ToCoSign         varchar(50),                                       
ClientToSign     varchar(150),                       
--Shared           varchar(3)      
Author varchar(100),  --Modifed by Rakesh  28Dec2011
 -- JUNE-13-2016 Akwinass
HasMoreThanOneVersion VARCHAR(3),
 -- SEP-22-2016 Chita Ranjan
AssociateDocuments VARCHAR(175),
--27/10/2017 Sunil.D 
AssociateDocumentId int,
AssociateScreenId int,
AssociateServiceId int,
GroupName  varchar(100), 
GroupId int,    
GroupServiceId int
)                                                            
                                        
                                                            
create table #MyDocuments (DocumentId int, ClientId int)                
create table #ToCosign  (DocumentId int)     
---------Added by Maninder------    
create table #MemberSign (DocumentId INT)                
---------Ends-------------------               
create table #DocumentCodeFilters (DocumentCodeId int)                                                         
declare @Today datetime                                
declare @ApplyFilterClicked char(1)                 
declare @CustomFiltersApplied char(1)                
declare @UsePrimaryProgramForCaseload char(1)                
declare @PrimaryProgramId int           
           
DECLARE @DocumentStatusCodeName VARCHAR(50);                                
DECLARE @DueDaysCodeName VARCHAR(50);                                
SET @DocumentStatusCodeName=dbo.csf_GetGlobalSubCodeById(@DocumentStatusFilter);      
SET @DueDaysCodeName=dbo.csf_GetGlobalSubCodeById(@DueDaysFilter);                  
                  
                                                 
                                                   
set @ApplyFilterClicked = 'Y'                                                            
--set @PageNumber = 1                                                     
set @Today = convert(char(10), getdate(), 101)                     
set @CustomFiltersApplied = 'N'                
                
-- Get custom filters                                      
if @ClientsFilter > 10000 or @DocumentStatusFilter > 10000 or @DueDaysFilter > 10000 or @OtherFilter > 10000                                
begin                
                
  set @CustomFiltersApplied = 'Y'                
                  
  --insert into #MyDocuments (DocumentId)                                      
   
       
 if object_id('dbo.scsp_ListPageSCMyDocuments', 'P') is not null  
 Begin  
   insert into #MyDocuments (DocumentId,ClientId)      
   EXEC scsp_ListPageSCMyDocuments @LoggedInStaffId = @LoggedInStaffId,                                   
             @StaffId = @StaffId,                  
             @ClientsFilter = @ClientsFilter,                                                                
             @DocumentNavigationIdFilter = @DocumentNavigationIdFilter,                                      
             @DocumentStatusFilter = @DocumentStatusFilter,                                       
             @DueDaysFilter = @DueDaysFilter,                                      
             @OtherFilter = @OtherFilter ,
             @DosFrom = @DosTo,  -- 20.12.2016	Ravichandra
             @DosTo = @DosTo     -- 20.12.2016	Ravichandra      
 end          
                
end                       
                
 -- All documents that need to be co-signed                
 insert into #ToCosign (DocumentId)                  
 select distinct d.DocumentId                  
 from DocumentSignatures dss                  
 join Documents d on d.DocumentId  = dss.DocumentId                  
 where dss.StaffId = @StaffId                   
 and (dss.StaffId <> d.AuthorId) and (dss.StaffId <> isnull(d.ReviewerId,0))                    
 and dss.SignatureDate is null                   
 and isnull(dss.DeclinedSignature, 'N') = 'N'                  
 and d.CurrentVersionStatus = 22                  
 and isnull(dss.RecordDeleted, 'N') = 'N'    
   AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <=@DosTo
		   )
       )  
    
    
                  
if @CustomFiltersApplied = 'N'                                      
begin                
  -- Get document code filters                
  insert into #DocumentCodeFilters (DocumentCodeId)                
  exec ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @DocumentNavigationIdFilter                
                
  -- To Do documents                
  insert into #MyDocuments (DocumentId, ClientId)                
  select  distinct d.DocumentId, d.ClientId              
    from Documents d                
         join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId                
   where  /* d.AuthorId = @StaffId           */      
  /*Added ReviewerId with AuthorId */      
  (d.AuthorId = @StaffId )--OR d.ReviewerId = @StaffId)      
     and       
  /*d.Status = 20          */      
  /*Replaced d.status with CurrentVersionStatus for Author/Reviewer*/      
     d.CurrentVersionStatus = 20      
     and isnull(d.RecordDeleted, 'N') = 'N'                
     and @DocumentStatusFilter in (115, 116,4102) -- 115 - Not Signed, Not Completed, Not Co-Signed; 116 - To Do ; 4102- All Statuses(-- 20.12.2016	Ravichandra)
                 
     and (@DueDaysFilter in (0, 122) or -- All                
          (@DueDaysFilter = 123 and d.DueDate < @today) or -- Past Due                                
          (@DueDaysFilter = 124 and d.DueDate < dateadd(dd, 8, @today)) or --Due within 1 week and Past Due                                
          (@DueDaysFilter = 125 and (d.DueDate >= @today and d.DueDate < dateadd(dd, 15, @today))) or -- Due within 14 days                                
          (@DueDaysFilter = 126 and d.DueDate < dateadd(dd, 15, @today)) or -- Due within 14 days and Past Due             
          (@DueDaysFilter = 127 and (d.DueDate >= @today and d.DueDate < dateadd(dd, 36, @today))) or -- Due within 5 weeks                                
          (@DueDaysFilter = 128 and (d.DueDate >= @today and d.DueDate <= dateadd(mm, 3, @today))) or -- Due within 3 months                                
          (@DueDaysFilter = 129 and d.DueDate > dateadd(mm, 3, @today)) or -- Due greater than 3 months         
          (@DueDaysCodeName = 'DT' and d.DueDate <= @today))  -- Due Today and Past Due                
      AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
       
       
  -- In Progress documents                
  insert into #MyDocuments (DocumentId, ClientId)                
  select distinct d.DocumentId, d.ClientId              
    from Documents d                
  join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId                
   where       
   /*(d.AuthorId = @StaffId or d.ProxyId = @StaffId)          */      
   /*Added ReviewerId with AuthorId */      
   (d.AuthorId = @StaffId or d.ProxyId = @StaffId)-- or d.ReviewerId = @StaffId)      
     /*d.Status = 21    */      
     /*Replaced d.status with CurrentVersionStatus for Author/Reviewer*/      
     and d.CurrentVersionStatus = 21              
     and isnull(d.RecordDeleted, 'N') = 'N'                
     and (@DocumentStatusFilter in (115, 117,4102) or -- 115 - Not Signed, Not Completed, Not Co-Signed; 117 - In Progress ; 4102- All Statuses(-- 20.12.2016	Ravichandra)              
          (@DocumentStatusFilter = 121 and d.ToSign = 'Y' and exists(                
          Select DS.SignatureId from DocumentSignatures DS where DS.DocumentId = D.DocumentId and                 
          ds.StaffID =@StaffId  and ds.StaffId = d.AuthorId                   
          ))) -- To Sign                
     and @DueDaysFilter in (0, 122)                
      AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
                   
  -- Signed documents                
  insert into #MyDocuments (DocumentId, ClientId)                
  select distinct d.DocumentId, d.ClientId               
    from Documents d                
         join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId                
   where       
  /*d.AuthorId = @StaffId    */      
  /*Added ReviewerId with AuthorId */      
  (d.AuthorId = @StaffId or d.ReviewerId = @StaffId)                
     /*and d.Status = 22    */      
     /*Replaced d.status with CurrentVersionStatus for Author/Reviewer*/      
     and d.CurrentVersionStatus = 22                
     and isnull(d.RecordDeleted, 'N') = 'N'                
     and ((@DocumentStatusFilter = 118 and d.SignedByAuthor = 'Y') or -- Signed                             
          (@DocumentStatusFilter = 119 and isnull(d.SignedByAuthor, 'N') = 'N')-- Completed    
          OR(@DocumentStatusFilter = 4102  )) -- 4102- All Statuses(-- 20.12.2016	Ravichandra)                            
     and @DueDaysFilter in (0, 122)                
       AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
                  
  -- To Co-sign documents                
  insert into #MyDocuments (DocumentId, ClientId)                
  select distinct d.DocumentId, d.ClientId               
    from Documents d                
         join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId             
         join #ToCosign tcs on tcs.DocumentId = d.DocumentId                
   where @DocumentStatusFilter in (115, 120,4102) -- 115 - Not Signed, Not Completed, Not Co-Signed; 120 - To Co-sign ; 4102- All Statuses(-- 20.12.2016	Ravichandra)
     and @DueDaysFilter in (0, 122)                
     AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
                     
   -- To Acknowledge documents                
  insert into #MyDocuments (DocumentId, ClientId)                
  select distinct da.DocumentId, d.ClientId             
    from DocumentsAcknowledgements da             
         join Documents d  on da.DocumentId = d.DocumentId  and isnull(d.RecordDeleted, 'N') = 'N'            
         join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId                
   where @DocumentStatusFilter in (114,4102) -- 114 - To Acknowledge;   4102- All Statuses(-- 20.12.2016	Ravichandra)         
     and @DueDaysFilter in (0, 122) and isnull(da.RecordDeleted, 'N') = 'N'            
     and da.AcknowledgedByStaffId=@LoggedInStaffId              
     and da.DateAcknowledged is null            
       AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
                   
   --To be Reviewed documents      
  insert into #MyDocuments (DocumentId, ClientId)          
  select distinct d.DocumentId, d.ClientId        
    from Documents d          
         join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId          
   where (d.AuthorId = @StaffId or d.ProxyId = @StaffId or d.ReviewerId = @StaffId)          
     and d.CurrentVersionStatus = 25          
     and isnull(d.RecordDeleted, 'N') = 'N'          
     and (@DocumentStatusFilter in (113,4102)) -- 113 - To Be Reviewed Status  ; 4102- All Statuses(-- 20.12.2016	Ravichandra)     
     and (@DueDaysFilter in (0, 122) or -- All          
          (@DueDaysFilter = 123 and d.DueDate < @today) or -- Past Due                          
          (@DueDaysFilter = 124 and d.DueDate < dateadd(dd, 8, @today)) or --Due within 1 week and Past Due                       
          (@DueDaysFilter = 125 and (d.DueDate >= @today and d.DueDate < dateadd(dd, 15, @today))) or -- Due within 14 days         
          (@DueDaysFilter = 126 and d.DueDate < dateadd(dd, 15, @today)) or -- Due within 14 days and Past Due                          
          (@DueDaysFilter = 127 and (d.DueDate >= @today and d.DueDate < dateadd(dd, 36, @today))) or -- Due within 5 weeks                          
          (@DueDaysFilter = 128 and (d.DueDate >= @today and d.DueDate <= dateadd(mm, 3, @today))) or -- Due within 3 months                          
          (@DueDaysFilter = 129 and d.DueDate > dateadd(mm, 3, @today)) or -- Due greater than 3 months       
          (@DueDaysCodeName = 'DT' and d.DueDate <= @today))  -- Due Today and Past Due       
      AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
                 
  -- To Assigned documents                  
  insert into #MyDocuments (DocumentId, ClientId)                  
  select D.DocumentId, D.ClientId          
  From           
     Documents AS D      
     JOIN DocumentAssignedTasks AS DAT ON D.InProgressDocumentVersionId=DAT.DocumentVersionId      
     JOIN #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId       
 WHERE DAT.AssignmentStatus<>6822  
 -- Msood 6/14/2017
 AND (d.ProxyId = @StaffId or d.ReviewerId = @StaffId or DAT.StaffId = @StaffId)      
 AND ISNULL(D.RecordDeleted, 'N') = 'N'      
 AND ISNULL(DAT.RecordDeleted, 'N') = 'N'    
      
    AND @DocumentStatusCodeName ='AS'      
    AND   (@DueDaysFilter in (0, 122) or -- All          
          (@DueDaysFilter = 123 and d.DueDate < @today) or -- Past Due                          
          (@DueDaysFilter = 124 and d.DueDate < dateadd(dd, 8, @today)) or --Due within 1 week and Past Due                       
          (@DueDaysFilter = 125 and (d.DueDate >= @today and d.DueDate < dateadd(dd, 15, @today))) or -- Due within 14 days                          
          (@DueDaysFilter = 126 and d.DueDate < dateadd(dd, 15, @today)) or -- Due within 14 days and Past Due                          
          (@DueDaysFilter = 127 and (d.DueDate >= @today and d.DueDate < dateadd(dd, 36, @today))) or -- Due within 5 weeks                          
          (@DueDaysFilter = 128 and (d.DueDate >= @today and d.DueDate <= dateadd(mm, 3, @today))) or -- Due within 3 months                          
          (@DueDaysFilter = 129 and d.DueDate > dateadd(mm, 3, @today)) or -- Due greater than 3 months       
          (@DueDaysCodeName = 'DT' and d.DueDate <= @today))  -- Due Today and Past Due       
       AND   -- 20.12.2016	Ravichandra
       (  
       (ISNULL(@DosFrom,'') = '' 
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom
        )  
       AND (
		   ISNULL(@DosTo,'')=''
		   OR CAST(D.EffectiveDate AS DATE)  <= @DosTo
		   )
       )  
       
        
  if @ClientsFilter in (158, 159)                
  begin                
    select @UsePrimaryProgramForCaseload = s.UsePrimaryProgramForCaseload,                                      
           @PrimaryProgramId = s.PrimaryProgramId                                      
      from Staff s                
     where s.Staffid = @StaffId                    
  end                          
                 
  -- My Primary Clients                
  if @ClientsFilter = 158                
  begin                
    delete md                
      from #MyDocuments md                
     where not exists(select 1                
                        from Clients c                
                       where c.ClientId = md.ClientId                
                         and (c.PrimaryClinicianId = @StaffId or                 
                (@UsePrimaryProgramForCaseload = 'Y' and                 
                              exists(select 1                 
                                       from ClientPrograms cp                 
                                      where cp.ClientId = c.ClientId                
                                        and cp.ProgramId = @PrimaryProgramId                
                                        and cp.Status <> 5                
                      and isnull(cp.RecordDeleted, 'N') = 'N'))))                
  end                
                
  -- Not My Primary Clients                
  if @ClientsFilter = 159                
  begin                
    delete md                
      from #MyDocuments md                
     where not exists(select 1                
                        from Clients c                
                       where c.ClientId = md.ClientId                
                         and isnull(c.PrimaryClinicianId, 0) <> @StaffId                
     and (isnull(@UsePrimaryProgramForCaseload, 'N') = 'N' or                 
                              not exists(select 1                 
                                           from ClientPrograms cp                 
                                          where cp.ClientId = c.ClientId                
                                            and cp.ProgramId = @PrimaryProgramId                
                                            and cp.Status <> 5                
                                            and isnull(cp.RecordDeleted, 'N') = 'N')))                
  end                
end                
                
insert into #ResultSet(                      
       ClientId,                                                          
       ClientName,                  
       DocumentId,                 
       ServiceId,                
       DocumentCodeId,                        
       DocumentScreenId,                    
       DocumentName,                   
       EffectiveDate,                  
       Status,                    
       StatusName,                   
       DueDate,                    
       ToCoSign,                                       
       ClientToSign,      
       Author   ,
       GroupName,    
	   GroupId,    
	   GroupServiceId                    
       /*,Shared*/      
       )                
select distinct c.ClientId,                
       LEFT(CASE     
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END,100), -- limited to 100 characters 04/27/2018  Rega Task #234 springriver SGL,
       --rtrim(c.LastName) + ', ' + rtrim(c.FirstName) as ClientName,                  
       d.DocumentId,                
       isnull(d.ServiceId, 0),                
       d.DocumentCodeId,                
       sr.ScreenId,  
       -- 02.06.2015  Vamsi  To display procedure code behind the service note type.   
       LEFT(Case when dc.ServiceNote='Y' then  dc.DocumentName + ' ( ' +  pc.DisplayAs + ' )'                        
       else dc.DocumentName End,175),  -- limited to 175 characters 04/27/2018  Rega Task #234 springriver SGL   
       --Changes End                      
       d.EffectiveDate,  -- modified by Neha 
        /*10/29/2018- Changes by Chethan N : displaying Current Status for both Author and Non-Author*/                
       d.CurrentVersionStatus as Status,       
       /*case when (d.AuthorId = @LoggedInStaffId or d.ReviewerId = @LoggedInStaffId)       
   then d.CurrentVersionStatus      
   else d.Status      
       end as Status,  */            
       LEFT(case when isnull(d.SignedByAuthor,'N') = 'N' and gcs.GlobalCodeId = 22                 
            then 'Completed'                
            when d.SignedByAuthor = 'Y' and gcs.GlobalCodeId = 22                
            then 'Signed'     
--            when   gcs.GlobalCodeId = 20  then 'To Do (In Progress)'         
            else gcs.CodeName      
       END,50),   -- limited to 50 characters  04/27/2018  Rega Task #234 springriver SGL                
       d.DueDate,                    
       LEFT(case when tcs.DocumentId is not null                                
            then 'To Co-Sign'                                                                              
            else null                                  
       end ,50),   -- limit to 50 characters  04/27/2018  Rega Task #234 springriver SGL        
       --Commented by Maninder (Task#7 in Development Phase IV(Offshore): To show message 'Yes' (if client is added and not signed),     
       --                  'Complete'(if client is added and signed) else null                
       --case when dsc.DocumentId is not null and dsc.SignatureDate is null and isnull(dsc.DeclinedSignature,'N') = 'N' and d.Status = 22                                
       --     then 'Client Sign'                                                                    
       --     else null           
       LEFT(case when dsc.DocumentId is not null and dsc.SignatureDate is null and isnull(dsc.DeclinedSignature,'N') = 'N' and dsc.IsClient='Y'                             
            then 'Yes'                                                                    
            when dsc.DocumentId is not null and dsc.SignatureDate is not null and isnull(dsc.DeclinedSignature,'N') = 'N' and dsc.IsClient='Y'    
            then 'Complete'    
            else null    
       end,50),   -- limit to 50 characters  04/27/2018  Rega Task #234 springriver SGL      
         LEFT(st.LastName+', '+st.FirstName ,100),  -- limit to 100 characters  04/27/2018  Rega Task #234 springriver SGL
         
         IsNull(G.GroupName,'') as 'GroupName',
         GS.GroupId,
		 GS.GroupServiceId
		                
       /*,case when d.DocumentShared = 'Y' then 'Yes' else 'No' end  as Shared*/                    
  from Documents d                     
       join #MyDocuments md on md.DocumentId = d.DocumentId                
       join Clients c on c.ClientId = d.ClientId        
       join StaffClients sc on sc.StaffId = @LoggedInStaffId and sc.ClientId = c.ClientId                
       join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId   
       /*10/29/2018- Changes by Chethan N : displaying Current Status for both Author and Non-Author*/              
       join GlobalCodes gcs on gcs.GlobalCodeId = d.CurrentVersionStatus     
       /*join GlobalCodes gcs on gcs.GlobalCodeId =       
       case when (d.AuthorId = @LoggedInStaffId or d.ReviewerId = @LoggedInStaffId)       
   then d.CurrentVersionStatus      
   else d.Status      
    end                    */ 
       join Screens sr on sr.DocumentCodeId= d.DocumentCodeId                
       left join Services s on s.ServiceId = d.ServiceId and dc.ServiceNote = 'Y' and isNull(s.RecordDeleted,'N')<>'Y'
       left outer join GroupServices GS on s.GroupServiceId=GS.GroupServiceId and isNull(GS.RecordDeleted,'N')<>'Y'
	   left outer join Groups G ON GS.GroupId=G.GroupId             
       left join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId                
       left join #ToCosign tcs on tcs.DocumentId = d.DocumentId      
    left join DocumentSignatures dsc on dsc.DocumentId = d.DocumentId and dsc.IsClient = 'Y' and isnull(dsc.RecordDeleted, 'N') = 'N'                                  
    join dbo.Staff st ON st.StaffId=d.AuthorId                     
 where isnull(d.RecordDeleted, 'N') = 'N'                
   and isnull(c.RecordDeleted, 'N') = 'N'                                            
   and isnull(sr.RecordDeleted, 'N') = 'N'     
  
 -- JHB 2/12/2013  
 -- In case there is an in progress document for a To Do document for same client, document code, author  
 -- then link to In Progress document      
   
 update a  
 set DocumentId = c.DocumentId, StatusName  = 'To Do (In Progress)'  
 from #ResultSet a  
 JOIN Documents b ON a.DocumentId = b.DocumentId  
 JOIN Documents c ON b.ClientId = c.ClientId  
 and b.DocumentCodeId = c.DocumentCodeId  
 and b.AuthorId = c.AuthorId  
 where a.Status = 20 -- To Do  
 and c.Status = 21 -- In Progress  
 and Isnull(c.RecordDeleted,'N') = 'N'  
 
 -- JUNE-13-2016 Akwinass
 /*10/29/2018- Changes by Chethan N : displaying count of Document version*/ 
 UPDATE D
 SET D.HasMoreThanOneVersion = DVC.HasMoreThanOneVersion
 FROM #ResultSet D
 JOIN (  SELECT DV.DocumentId, COUNT(DV.DocumentId) AS HasMoreThanOneVersion
		FROM DocumentVersions DV
		WHERE EXISTS (SELECT 1 FROM #ResultSet D WHERE DV.DocumentId = D.DocumentId AND ISNULL(DV.RecordDeleted, 'N') = 'N')
		GROUP BY DV.DocumentId
		) DVC ON D.DocumentId = DVC.DocumentId
  
  --Chita Ranjan SEP-21-2017----- 
 --- 27/10/2017 Sunil.D 
  CREATE TABLE #DocumentCount(NativeDocumentId int, total int)
  INSERT INTO #DocumentCount(NativeDocumentId,total) 
     SELECT AD.NativeDocumentId, COUNT(AD.NativeDocumentId) 
    FROM #ResultSet D  
   JOIN AssociateDocuments AD ON AD.NativeDocumentId=D.DocumentId 
   AND ISNULL(AD.RecordDeleted, 'N') = 'N' 
  GROUP by AD.NativeDocumentId 
  
;WITH CTE AS (
       SELECT AD.NativeDocumentId,
       CASE WHEN t.total >1 THEN 'Multiple'  WHEN t.total =1 THEN DC.DocumentName  END AS  DocumentName ,
			  AD.DocumentId As DocumentId,
			  S.Screenid AS Screenid,
			  D1.ServiceId As ServiceId
  FROM #ResultSet D  
   JOIN #DocumentCount  t ON T.NativeDocumentId=D.DocumentId
   JOIN AssociateDocuments AD ON AD.NativeDocumentId=D.DocumentId
   AND ISNULL(AD.RecordDeleted, 'N') = 'N' 
   JOIN Documents D1 ON D1.DocumentId=AD.DocumentId
   AND ISNULL(D1.RecordDeleted, 'N') = 'N'
   JOIN DocumentCodes DC ON DC.DocumentCodeId=D1.DocumentCodeId
    JOIN screens S  ON S.documentcodeid = DC.documentcodeid 
  GROUP by AD.NativeDocumentId ,AD.DocumentId,DC.DocumentName,t.total,S.Screenid ,D1.ServiceId
)

UPDATE  R
SET R.AssociateDocuments = Isnull(cte.DocumentName,'Add'),
R.AssociateDocumentId=CTE.DocumentId,
R.AssociateScreenId=CTE.Screenid,
R.AssociateServiceId=CTE.ServiceId
FROM #ResultSet R    JOIN cte
   on (R.DocumentId = cte.NativeDocumentId)
UPDATE  R
SET R.AssociateDocuments =Isnull(R.AssociateDocuments,'Add')
FROM #ResultSet R  
--------------------------------------------------------------------
 
---------------------------------------------------------17/01/2018   Arjun K R  Start------------------------------------------------
		UPDATE R
		SET ToCoSign = ISNULL(S.LastName + ', ' + S.FirstName, '')
		FROM #ResultSet R
		JOIN Documents D ON D.DocumentId=R.DocumentId
		JOIN DocumentSignatures ds ON ds.DocumentId = R.DocumentId
		JOIN Staff s ON S.StaffId = ds.StaffId
		WHERE ISNULL(ds.RecordDeleted, 'N') = 'N'
		AND S.StaffId=@StaffId
		AND S.StaffId<>D.AuthorId
		
		UPDATE R
		SET ClientToSign = LEFT(CASE 
				WHEN dsc1.DocumentId IS NOT NULL
					AND dsc1.SignatureDate IS NULL
					AND isnull(dsc1.DeclinedSignature, 'N') = 'N'
					AND d.[Status] = 22
					AND ISNULL(dc.DefaultGuardian, 'N') = 'Y'
					THEN (
							SELECT ISNULL(STUFF((
											SELECT ', ' + ISNULL(CC.LastName + ', ' + CC.FirstName, '')
											FROM ClientContacts CC
											WHERE CC.ClientId = D.ClientId
												AND ISNULL(CC.RecordDeleted, 'N') = 'N'
												AND ISNULL(CC.Guardian, 'N') = 'Y'
												AND EXISTS (
													SELECT 1
													FROM DocumentSignatures DSIGN
													WHERE DSIGN.RelationToClient=CC.Relationship AND DSIGN.DocumentId = D.DocumentId
														AND ISNULL(DSIGN.RecordDeleted, 'N') = 'N'
														AND DSIGN.IsClient = 'N'
														AND DSIGN.StaffId IS NULL
													)
											FOR XML PATH('')
												,type
											).value('.', 'nvarchar(max)'), 1, 2, ' '), '')
							)
				WHEN dsc.DocumentId IS NOT NULL
					AND dsc.SignatureDate IS NULL
					AND isnull(dsc.DeclinedSignature, 'N') = 'N'
					AND d.[Status] = 22
					AND dsc.ClientId IS NOT NULL
					AND ISNULL(DC.DefaultCoSigner, 'N') = 'Y'
					THEN dsc.SignerName
				ELSE NULL
				END,50) -- limited to 50 characters 04/27/2018  Rega Task #234 springriver SGL
		FROM #ResultSet R
		JOIN Documents D ON D.DocumentId = R.DocumentId
		JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
		LEFT JOIN DocumentSignatures dsc ON dsc.DocumentId = D.DocumentId
			AND dsc.IsClient = 'Y'
			AND isnull(dsc.RecordDeleted, 'N') = 'N'
		LEFT JOIN DocumentSignatures dsc1 ON dsc1.DocumentId = D.DocumentId
			AND dsc1.IsClient = 'N'
			AND dsc1.StaffId IS NULL
			AND isnull(dsc1.RecordDeleted, 'N') = 'N'
----------------------------------------------------------------17/01/2018   Arjun K R  End-------------------------------------------------- 

 
 
 
; with   Counts as (   
   select count(*) as TotalRows from #ResultSet  
   ),  
   RankResultSet AS (   
   SELECT                                                                        
        ClientId,                                                          
     ClientName,                  
     DocumentId,                  
     ServiceId,                                     
     DocumentCodeId,                        
     DocumentScreenId,                    
     DocumentName,                   
     EffectiveDate,                  
     Status,                    
     StatusName,                   
     DueDate,                    
     ToCoSign,                                       
     ClientToSign,      
     Author ,
    -- JUNE-13-2016 Akwinass    
    HasMoreThanOneVersion,  
      -- SEP-22-2016 Chita Ranjan
    AssociateDocuments,   
    --- 27/10/2017 Sunil.D 
	AssociateDocumentId ,
	AssociateScreenId ,
	AssociateServiceId ,
	GroupName,
	GroupId,   
	GroupServiceId ,                                      
    COUNT(*) OVER ( ) AS TotalCount ,  
                RANK() OVER ( order by case when @SortExpression= 'ClientId' then ClientId end,                                            
                                                case when @SortExpression= 'ClientId desc' then ClientId end desc,                  
                                                case when @SortExpression= 'ClientName' then ClientName end,                                                      
                                                case when @SortExpression= 'ClientName desc' then ClientName end desc,                                      
                                                case when @SortExpression= 'DocumentName' then DocumentName end,                                                      
                                                case when @SortExpression= 'DocumentName desc' Then DocumentName end desc,                                      
											    case when @SortExpression= 'EffectiveDate' then EffectiveDate end,                                                      
                                                case when @SortExpression= 'EffectiveDate desc' Then EffectiveDate end desc,                                                   
                                                case when @SortExpression= 'StatusName' then StatusName end,                                                      
                                                case when @SortExpression= 'StatusName desc' then StatusName end desc,                                                  
                                                case when @SortExpression= 'DueDate' then DueDate end,                                                      
                                                case when @SortExpression= 'DueDate desc' then DueDate end desc,                                                  
                                                case when @SortExpression= 'ToCoSign' then ToCoSign end,                                                      
                                                case when @SortExpression= 'ToCoSign desc' then ToCoSign end desc,                                                  
                                                case when @SortExpression= 'ClientToSign' then ClientToSign end,                 
                                                case when @SortExpression= 'ClientToSign desc' then ClientToSign end desc,                      
                                                 case when @SortExpression= 'Author' then Author end,                
                                                case when @SortExpression= 'Author desc' then Author end desc,
                                                -- JUNE-13-2016 Akwinass   
                                                CASE WHEN @SortExpression = 'HasMoreThanOneVersion' THEN HasMoreThanOneVersion END,
                                                CASE WHEN @SortExpression = 'HasMoreThanOneVersion DESC' THEN HasMoreThanOneVersion END DESC,   
                                                
                                                 -- SEP-22-2016 Chita Ranjan
                                                CASE WHEN @SortExpression = 'AssociateDocuments' THEN AssociateDocuments END,  
                                                CASE WHEN @SortExpression = 'AssociateDocuments DESC' THEN AssociateDocuments END DESC,  
                                                 
                                                case when @SortExpression= 'GroupName' then GroupName end,
                                                case when @SortExpression= 'GroupName desc' then GroupName end desc,   
                                                EffectiveDate,                
                                                ClientName,                                                  
                                DocumentName,                                                  
                                                ListPageSCMyDocumentId) as RowNumber   
                           FROM     #ResultSet  
                           )  
                             
                SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)  
      ClientId,                                                          
       ClientName,                  
       DocumentId,                  
       ServiceId,                                     
       DocumentCodeId,                        
       DocumentScreenId,                    
       DocumentName,                   
       EffectiveDate,                  
       Status,                    
       StatusName,                   
       DueDate,                    
       ToCoSign,                                       
       ClientToSign,      
       Author , 
        -- JUNE-13-2016 Akwinass
      HasMoreThanOneVersion,
      -- SEP-22-2016 Chita Ranjan
      AssociateDocuments, 
      --- 27/10/2017 Sunil.D  
		AssociateDocumentId ,
		AssociateScreenId ,
		AssociateServiceId ,
		GroupName,
		GroupId,
		GroupServiceId,   
      RowNumber,  
                        TotalCount   
                INTO    #FinalResultSet  
                FROM    RankResultSet  
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )    
                  
                  
                IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1  
     BEGIN  
      SELECT 0 AS PageNumber ,  
      0 AS NumberOfPages ,  
      0 NumberOfRows  
     END  
    ELSE  
     BEGIN  
      SELECT TOP 1  
       @PageNumber AS PageNumber ,  
       CASE (TotalCount % @PageSize) WHEN 0 THEN   
       ISNULL(( TotalCount / @PageSize ), 0)  
       ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,  
       ISNULL(TotalCount, 0) AS NumberOfRows  
      FROM    #FinalResultSet    
     END  
                                                     
                                    
select ClientId,                                                          
       ClientName,                  
       DocumentId,                    
       ServiceId,                                   
       DocumentCodeId,                
       DocumentScreenId,                    
       DocumentName,                   
       EffectiveDate,                  
       Status,                    
       StatusName,                   
       DueDate,                    
       ToCoSign,                                       
       ClientToSign,      
       Author,
       -- JUNE-13-2016 Akwinass  
       HasMoreThanOneVersion,
       -- SEP-22-2016 Chita Ranjan
		AssociateDocuments  ,
		--- 27/10/2017 Sunil.D 
		AssociateDocumentId ,
		AssociateScreenId ,
		AssociateServiceId,
		GroupName,  
		GroupId,
	    GroupServiceId                     
FROM    #FinalResultSet  
ORDER BY RowNumber  
      
END TRY                    
BEGIN CATCH                    
 DECLARE @Error varchar(8000)                                                                   
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCMyDocuments')                                                                                                 
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