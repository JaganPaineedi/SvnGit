
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageDisclosureDocumentList]    Script Date: 02/02/2017 12:59:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageDisclosureDocumentList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageDisclosureDocumentList]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCListPageDisclosureDocumentList]    Script Date: 02/02/2017 12:59:43 ******/
SET ANSI_NULLS ON
GO
/****** Author Name: Animesh 
 Modified date: 11-07-2018
 DEscription:Disclosure/Request details: For attaching documents, want a checkbox to show errored documents
******/
SET QUOTED_IDENTIFIER ON
GO


Create procedure [dbo].[ssp_SCListPageDisclosureDocumentList]                                                                             
@SessionId varchar(30),                                                                    
@InstanceId int,                                                                    
@PageNumber int,                                                                        
@PageSize int,                                                                        
@SortExpression varchar(100),                                                                    
@ClinicianId int,                                                                                              
@ClientId int,                                                                    
@AuthorIdFilter int,                                                                    
--@DocumentCodeIdFilter int,                                                                                                                         
--@DocumentBannerFilter char(1),                                                                    
@StatusFilter int,                                                      
@EffectiveFromDate datetime,                                                      
@EffectiveToDate datetime,                                                      
@OtherFilter int,              
@DocumentNavigationId int,
@IncludeErroredDocument int =0            
/********************************************************************************                                                                    
-- Stored Procedure: dbo.ssp_ListPageSCDisclosureDocumentList                                                                      
--                                                                    
-- Copyright: Streamline Healthcate Solutions                                                                    
--                                                                    
-- Purpose: used by  AttachReleaseDocument list page                                                                    
--                                                                    
-- Updates:                                                                                                                           
-- Date        Author			Purpose 
------------------------------------------------------------------------------------                                                                   
-- 10.12.2009	Anuj Tomar		Created.      
-- 08.18.2011	dharvey			Adjusted filters to not include "To Do" documents on Final Result set                                                                    
-- 10.18.2013   Manju           What/Why : Threshold support - Disclosure/Request      
-- 12.11.2013   Gautam          What : Chnage the sorting for DocumentName and DocumentName Desc 
								For Task# 125 : Thresholds – Support    
-- 04.08.2016   Ravichandra		Removed the physical table ListPageSCDisclosureDocuments from SP
								Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
								108 - Do NOT use list page tables for remaining list pages (refer #107)	
-- 02-Feb-2017  Pradeep Y       What - Revert the changes which has been done as part of task #108  Engineering Improvement Initiatives- NBL(I)  
--                              Why - Because its breaking other work flow, for task #506 Woods - Support Go Live
11-jul-2018    Animesh          What-Disclosure/Request details: For attaching documents, want a checkbox to show errored documents
*********************************************************************************/                                                          
          
as                                                                    
Declare @ScreenId int                 
set @SortExpression =Rtrim ( Ltrim(@SortExpression))                
                                                                                                                           
create table #ResultSet(                                                                    
RowNumber      int,                                                                    
PageNumber     int,                                                                    
DocumentId     int,                                                                     
CurrentVersion int,                                                                    
DocumentCodeId int,                                                                
DocumentScreenId int,                                                                 
ClientId       int,                                                                    
DocumentName   varchar(100),                                                                    
EffectiveDate  datetime,                                                                    
Status         int,                                                                    
StatusName     varchar(50),                                                                    
AuthorId  int,                                                                    
AuthorName     varchar(100),                                            
 --Added By Sahil                   
ClientName varchar(100),                             
--Ended over here               
--Changes by Sonia reference new specs                          
DocumentVersionId int                          
                          
--Changes end over here                                    
                                                      
)                                                                    
                                                        
declare @CustomFilters table (DocumentId int)                                          
declare @DocumentCodeFilters table (DocumentCodeId int)                                 
                                                                    
declare @Today datetime                                    
declare @ApplyFilterClicked char(1)      
Declare @strSQL NVarchar(4000)                                                                
--                                               
-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                                    
--                                                                    
if @PageNumber > 0 and exists(select * from ListPageSCDisclosureDocuments where SessionId = @SessionId and InstanceId = @InstanceId)                                                                     
begin                                                                    
  set @ApplyFilterClicked = 'N'                                                                    
  goto GetPage                                                                    
end                                                          
                                                                    
--                                                                    
-- New retrieve - the request came by clicking on the Apply Filter button                                                                               
--                                     
                                                                    
set @ApplyFilterClicked = 'Y'                                                                    
set @PageNumber = 1                                                                                          
set @Today = convert(char(10), getdate(), 101)                                                                    
                                                                 
 --Get all document codes if the DocumentCodeIdFilter is specified                                                                    
--if @DocumentCodeIdFilter > 0                                                                    
--begin                                                                    
--  if @DocumentBannerFilter = 'Y'                                                                    
--  begin                                                         
--    insert into @DocumentCodeFilters (DocumentCodeId)                                                                    
--    select DocumentCodeId                                                                    
--      from DocumentBannerDocumentCodes                                                      
--     where DocumentBannerId = @DocumentCodeIdFilter                                                                    
--       and isnull(RecordDeleted, 'N') = 'N'                                                                    
--  end                                                                   
--  else                                                                    
--  begin                                                                    
--    insert into @DocumentCodeFilters (DocumentCodeId) values (@DocumentCodeIdFilter)                                                             
--  end          
--end                                                                    
              
              
              
              
-- Get all document codes based on DocumentNavigationId                  
if @DocumentNavigationId > 0                                      
begin                                      
 -- if @DocumentBannerFilter = 'Y'                                      
  --begin                           
                        
Select @ScreenId=isnull(ScreenId,0)  from DocumentNavigations where DocumentNavigationId=@DocumentNavigationId                      
if (@ScreenId=0)            
begin                      
    insert into @DocumentCodeFilters (DocumentCodeId)                       
Select S.DocumentCodeId from DocumentNavigations DN                      
inner join Screens  S on DN.ScreenId=S.ScreenId                         
 where ParentDocumentNavigationId=@DocumentNavigationId                       
End                      
                      
Else                      
begin                      
insert into @DocumentCodeFilters (DocumentCodeId)                       
Select S.DocumentCodeId from  Screens  S                       
 where S.ScreenId=@ScreenId                      
     end                        
    -- End                            
                                     
end                        
              
              
              
              
                                                         
                                                                               
insert into #ResultSet(                                                                    
       DocumentId,                                                                 
       CurrentVersion,                                                                    
       DocumentCodeId,                                                                           
    DocumentScreenId ,                                                                              
       ClientId,                                                             
       DocumentName,                                                                    
       EffectiveDate,                                                                    
       Status,                                                                    
       StatusName,                                                                                    
       AuthorId,                                                                    
       AuthorName,                            
        --Added By Sahil                                            
       ClientName ,                                                  
       --Ended over here                                                                          
       DocumentVersionId                          
      )                                                                                                             
select distinct d.DocumentId,                                        
       d.CurrentDocumentVersionId,                            
       --dv.DocumentVersionId,                                                          
       d.DocumentCodeId,                                  
       '',                                                
       --sr.ScreenId,                                                                            
       d.ClientId,                                                                                 
       case                                 
       when pc.DisplayDocumentAsProcedureCode = 'Y' then pc.DisplayAs                                                                    
            when dc.DocumentCodeId = 2 and tp.PlanOrAddendum = 'A' then 'TxPlan Addendum'                    
            else dc.DocumentName                                                                    
       end,                                                                    
       d.EffectiveDate,                                       
       d.Status,                                                
       gcs.CodeName,                                                                     
       d.AuthorId,       
       a.LastName + ', ' + a.FirstName ,                                           
       --Aded By Sahil                                            
       C.LastName + ', ' + C.FirstName,                             
       dv.DocumentVersionId                                                                 
       --Ended over here                                            
       --case when dss.DocumentId is not null and dss.SignatureDate is null and isnull(dss.DeclinedSignature,'N') = 'N'                                                                    
       --     then 'To Co-Sign'                                                                     
       --     else null                                                                     
       --end,                                     
       --case when dsc.DocumentId is not null and dsc.SignatureDate is null and isnull(dsc.DeclinedSignature,'N') = 'N' and d.Status = 22                                                                    
       --     then 'To Sign'                                                                                                        
       --     else null                               
       --end,                                                                      
       --case when d.DocumentShared = 'Y' then 'Yes' else 'No' end                                                                    
  from Documents d                           
                                                                                
 join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId                             
 --following added by sonia                          
 join DocumentVersions dv on dv.DocumentId=d.DocumentId and dv.DocumentVersionId=d.CurrentDocumentVersionId                                                                           
 --Changes end over here                          
       --left join Screens sr on sr.DocumentCodeId= d.DocumentCodeId                                                                                   
       join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                                                                    
       join Staff a on a.StaffId = d.AuthorId                                            
       --Added By Sahil                                            
       join Clients as C on d.ClientId=C.ClientId                                            
       --Ened Over here                                                                    
       left join DocumentSignatures dss on dss.DocumentId = d.DocumentId and dss.StaffId = @ClinicianId and dss.StaffId <> d.AuthorId and isnull(dss.RecordDeleted, 'N') = 'N'                                                                     
       left join DocumentSignatures dsc on dsc.DocumentId = d.DocumentId and dsc.IsClient = 'Y' and Isnull(dsc.RecordDeleted, 'N') = 'N'                            
       left join Services s on s.ServiceId = d.ServiceId and d.Status in (20, 21, 22, 23) and dc.ServiceNote = 'Y'                                                                                                                              
       left join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeID                                                                                                                     
       left join TpGeneral tp on tp.DocumentVersionId = d.CurrentDocumentVersionId                                                                   
                                               
                                                                                                                                                        
 where d.ClientID = @ClientId                                
 --and ISNULL(dc.ServiceNote,'N')='N'                     
   and (d.AuthorId = @ClinicianId or -- Current clinician is an author                                                                    
    d.ProxyId = @ClinicianId or  -- Current clinician is a proxy                                                                    
    d.Status in (22, 23) or -- Document is in the final status: Signed or Cancelled  
                                                                   
    d.DocumentShared = 'Y' or -- Document is shared           
   (d.Status = 22 and dss.DocumentId is not null)) -- Signed documents where current clinician is a co-signer                                 
                                           
   and (d.AuthorId = @AuthorIdFilter or isnull(@AuthorIdFilter, 0) = 0)                                                      
   --Added by Anuj                                                      
     and (isnull(d.EffectiveDate,@EffectiveFromDate) >= @EffectiveFromDate and isnull(d.EffectiveDate,@EffectiveFromDate)<=@EffectiveToDate)                                                
   --and (d.EffectiveDate >= @EffectiveFromDate and d.EffectiveDate <= @EffectiveToDate)                          
   --End                                                      
   and ((exists(select * from @DocumentCodeFilters dcf where dcf.DocumentCodeId = d.DocumentCodeId)) or (isnull(@DocumentNavigationId, 0) = 0))                                                                    
              
   and ((((@StatusFilter = 247 and d.Status <> 26 and @IncludeErroredDocument = 0) or -- All Statuses 
(@StatusFilter = 247 and @IncludeErroredDocument = 1) or 
@StatusFilter = 0 or -- All Statuses 
@StatusFilter > 10000) 
--Exclude all To Do Documents from Disclosures
and d.Status <> 20) or -- Custom Status 
--(@StatusFilter = 248 and d.Status = 20) or -- To Do 
(@StatusFilter = 249 and d.Status = 21) or -- In Progress 
(@StatusFilter = 250 and d.Status = 22 and d.SignedByAuthor = 'Y') or -- Signed 
(@StatusFilter = 251 and d.Status = 22 and isnull(d.SignedByAuthor, 'N') = 'N') or -- Completed 
(@StatusFilter = 252 and dss.DocumentId is not null and dss.SignatureDate is null and isnull(dss.DeclinedSignature, 'N') = 'N') or -- To Co-Sign 
(@StatusFilter = 253 and d.Status = 22) or --Signed, Completed 
(@StatusFilter = 254 and d.Status not in (20, 22,23)) or -- To Do -- Not-Signed and Completed 
(@StatusFilter = 254 and d.Status = 21 and d.ToSign = 'Y') or-- To Sign 
(@IncludeErroredDocument = 1 and d.Status = 26)) -- To Error 
and isnull(d.RecordDeleted, 'N') = 'N'
    
                                                              
                                                                              
--                                                                    
-- Apply custom filters                                                                    
--                                                                    
                                                                   
if @StatusFilter > 10000 or @OtherFilter > 10000                                                                    
begin                                                                    
  insert into @CustomFilters (DocumentId)                      
  exec scsp_ListPageSCDisclosureDocumentList @StatusFilter = @StatusFilter, @OtherFilter = @OtherFilter                                                        
                                                                    
  delete d                                                     
    from #ResultSet d     where not exists(select * from @CustomFilters f where f.DocumentId = d.DocumentId)                                                          
end                                                                    
                                                                    
GetPage:                                                                    
                                                                    
--                                                                    
-- If the sort expression has changed, resort the data set, otherwise goto Final and retrieve the page                                                                    
--                                                                
                                       
if @ApplyFilterClicked = 'N' and exists(select * from ListPageSCDisclosureDocuments where SessionId = @SessionId and InstanceId = @InstanceId and SortExpression = @SortExpression)                              
  goto Final                                                                    
                                                                    
set @PageNumber = 1                                                           
                                                                    
if @ApplyFilterClicked = 'N'                                                                    
begin                                                                    
  insert into #ResultSet(                                     
  DocumentId,                                                                    
         CurrentVersion,                                                                    
         DocumentCodeId,                                                                               
   DocumentScreenId ,                                                                              
         ClientId,                                         
         DocumentName,                                                                  
         EffectiveDate,                                                                    
         Status,                                                                    
         StatusName,                                                                    
                                                                      
         AuthorId,                                                                    
         AuthorName,                                            
          --Added By Sahil                                            
         ClientName,                                             
         --Ended overe here                                                                           
         DocumentVersionId                          
         )                                                                      
  select DocumentId,                                                    
         CurrentVersion,                                                                    
         DocumentCodeId,                                                                         
                                                                
         DocumentScreenId,                                                                
                                                              
         ClientId,                                                                    
         DocumentName,                                                                    
         EffectiveDate,                                                                    
  Status,                                                                    
         StatusName,                                                                    
                                                                   
         AuthorId,                                                                    
         AuthorName,                                            
          --Added By Sahil                                            
         ClientName,                                             
         --Ended overe here                                                                   
         --Changes by sonia                     
         DocumentVersionId                          
  --Changes end over here                              
    from ListPageSCDisclosureDocuments                                                                    
   where SessionId = @SessionId                                              
     and InstanceId = @InstanceId                                                                    
end                                                                    
    
  set @strSQL='                                                                    
update d                                                                    
   set RowNumber = rn.RowNumber,                                                                    
       PageNumber = (rn.RowNumber/' + cast(@PageSize  as varchar) + ' ) + case when rn.RowNumber % ' + cast(@PageSize  as varchar) + ' = 0 then 0 else 1 end                                                                    
  from #ResultSet d                                                                    
       join (select DocumentId,                                                                    
                    row_number() over (order by '
  
  if @SortExpression = 'DocumentName'  
  begin  
   set @strSQL= @strSQL +  ' DocumentName Asc, EffectiveDate Desc'  
  End                       
  Else if @SortExpression = 'DocumentName Desc'  
  begin  
   set @strSQL= @strSQL +  ' DocumentName Desc, EffectiveDate Desc'  
  End    
  Else if @SortExpression = 'EffectiveDate'  
  begin  
   set @strSQL= @strSQL +  ' EffectiveDate,DocumentName, DocumentId'  
  End
  Else if @SortExpression = 'EffectiveDate desc'  
  begin  
   set @strSQL= @strSQL +  ' EffectiveDate desc,DocumentName, DocumentId'  
  End                                                                                        
 Else if @SortExpression = 'StatusName'  
  begin  
   set @strSQL= @strSQL +  ' StatusName,DocumentName, DocumentId'  
  End                                                                                                                    
 Else if @SortExpression = 'StatusName desc'  
  begin  
   set @strSQL= @strSQL +  ' StatusName desc,DocumentName, DocumentId'  
  End 
 Else if @SortExpression = 'AuthorName'  
  begin  
   set @strSQL= @strSQL +  ' AuthorName,DocumentName, DocumentId'  
  End                                                                        
  Else if @SortExpression = 'AuthorName desc,'  
  begin  
   set @strSQL= @strSQL +  ' AuthorName desc,DocumentName, DocumentId'  
  End                                                                                
                                                                                                                   
  set @strSQL= @strSQL +  ' ) AS RowNumber from #ResultSet) rn on rn.DocumentId = d.DocumentId '  
  exec sp_executeSQL @strSQL                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                          
                                                                    
delete from ListPageSCDisclosureDocuments         
 where SessionId = @SessionId                                                                    
   and InstanceId = @InstanceId                                 
                                                                                      
insert into ListPageSCDisclosureDocuments(                                                                    
       SessionId,                                                                    
       InstanceId,                                                                    
RowNumber,                                                                    
       PageNumber,                                                                    
       SortExpression,                                                                    
       DocumentId,                                                                    
       CurrentVersion,                                                                    
       DocumentCodeId,                                       
       DocumentScreenId,                                                                                
       ClientId,                                                 
       DocumentName,                                                                    
       EffectiveDate,                                                     
       Status,                                               
       StatusName,                                                                                   
       AuthorId,                                                          
       AuthorName ,                                           
        --Added By Sahil                                            
       ClientName,                
       --Ended overe here                                                                 
       --Changes by Sonia                          
       DocumentVersionId                          
       --Changes end over here                          
      )                                                                    
select @SessionId,                                                                    
@InstanceId,                                                                
       RowNumber,                                                       
       PageNumber,                                                                    
       @SortExpression,                                                                    
       DocumentId,                                                                    
       CurrentVersion,                                                                    
       DocumentCodeId,                                                                           
       DocumentScreenId,                                                                                 
       ClientId,                                                              
 DocumentName,                                                                    
       EffectiveDate,                                                    
       Status,                                                                    
    StatusName,                                                                                      
       AuthorId,                                                                    
       AuthorName,                                            
        --Added By Sahil                                            
       ClientName,                                             
       --Ended overe here                                                                  
     --Changes by Sonia                          
       DocumentVersionId                          
       --Changes end over here                                                               
  from #ResultSet                                                                     
                                                                     
                                                                    
Final:                                                                    
                                                                    
select @PageNumber as PageNumber, isnull(max(PageNumber), 0) as NumberOfPages, isnull(max(RowNumber), 0) as NumberOfRows                                                                    
  from ListPageSCDisclosureDocuments                                                                    
 where SessionId = @SessionId                                                                    
   and InstanceId = @InstanceId                         
                                                                    
select DocumentId,                   
       CurrentVersion,                                                                    
       DocumentCodeId,                                                                          
       DocumentScreenId,                                                                                
       ClientId,                                   
       DocumentName,                                            
       --CONVERT(VARCHAR(10), EffectiveDate, 101) AS EffectiveDate ,                             
       EffectiveDate,                                                                    
       Status,                                                                    
       StatusName,                                                                    
       --DueDate,                                                                    
       AuthorId,                                                                    
       AuthorName,                                        
       --Added By Sahil                                            
       ClientName,                                                  
       --Ended over here                                                             
       --ToCoSign,                                                                    
      -- ClientToSign,                         
      -- Shared                            
      --Changes by Sonia                          
       DocumentVersionId                          
       --Changes end over here                         
  from ListPageSCDisclosureDocuments                                                                    
 where SessionId = @SessionId                                                                    
   and InstanceId = @InstanceId                                         
    and PageNumber = @PageNumber                                                                    
 order by RowNumber 

GO


