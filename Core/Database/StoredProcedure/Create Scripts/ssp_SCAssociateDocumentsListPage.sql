/****** Object:  StoredProcedure [dbo].[ssp_SCAssociateDocumentsListPage]    Script Date: 25/09/2017  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCAssociateDocumentsListPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCAssociateDocumentsListPage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ssp_SCAssociateDocumentsListPage]                                                                             
@SessionId varchar(30),                                                                    
@InstanceId int,                                                                    
@PageNumber int,                                                                        
@PageSize int,                                                                        
@SortExpression varchar(100),                                                                    
@ClinicianId int,                                                                                              
@ClientId int,                                                                    
@AuthorIdFilter int,                                                                               
@StatusFilter int,                                                      
@EffectiveFromDate datetime,                                                      
@EffectiveToDate datetime,                                                      
@OtherFilter int,              
@DocumentNavigationId int,  
@NativeDocumentId int  ,
@FromScaned char(2)         
/********************************************************************************                                                                    
-- Stored Procedure: dbo.ssp_SCAssociateDocumentsListPage                                                                      
--                                                                    
-- Copyright: Streamline Healthcare Solutions                                                                    
-- Created By: Sunil.D
---Creatd Date:15/09/2017                                        
-- Purpose: used by  Associate Documents list page  
-- Task   :   Thresholds-Enhancements #838.   
-- Updates:                                                                                                                           
-- Date        Author			Purpose 
------------------------------------------------------------------------------------ 
*********************************************************************************/                                                                     
AS
BEGIN
BEGIN TRY
                                                                    
Declare @ScreenId int                 
set @SortExpression =Rtrim ( Ltrim(@SortExpression))                
                                                                                                                           
create table #ResultSet(                                                                                                                                   
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
ClientName varchar(100),                                        
DocumentVersionId int                                  
)                                                                    
                                                        
declare @CustomFilters table (DocumentId int)                                          
declare @DocumentCodeFilters table (DocumentCodeId int)                                 
                                                                    
                          
if @DocumentNavigationId > 0                                      
begin                                                              
                        
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
       ClientName ,                                                                                
       DocumentVersionId                          
      )                                                                                                             
SELECT DISTINCT d.DocumentId,                                        
       d.CurrentDocumentVersionId,                                                           
       d.DocumentCodeId,                                  
       '',                                                                                         
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
       C.LastName + ', ' + C.FirstName,                             
       dv.DocumentVersionId                                                                        
  from Documents d                           
                                                                                
 join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId    
 join DocumentVersions dv on dv.DocumentId=d.DocumentId and dv.DocumentVersionId=d.CurrentDocumentVersionId                                                                                    
       join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                                                                    
       join Staff a on a.StaffId = d.AuthorId                                
       join Clients as C on d.ClientId=C.ClientId                                                     
       left join DocumentSignatures dss on dss.DocumentId = d.DocumentId and dss.StaffId = @ClinicianId and dss.StaffId <> d.AuthorId and isnull(dss.RecordDeleted, 'N') = 'N'                                                                     
       left join DocumentSignatures dsc on dsc.DocumentId = d.DocumentId and dsc.IsClient = 'Y' and Isnull(dsc.RecordDeleted, 'N') = 'N'                            
       left join Services s on s.ServiceId = d.ServiceId and d.Status in (20, 21, 22, 23) and dc.ServiceNote = 'Y'                                                                                                                              
       left join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeID                                                                                                                     
       left join TpGeneral tp on tp.DocumentVersionId = d.CurrentDocumentVersionId                                                                                                            
                                                                                                                                                        
 where d.ClientID = @ClientId  
 and d.DocumentId not in (SELECT DocumentId FROM Associatedocuments  Ad  WHERE AD.NativeDocumentId = @NativeDocumentId AND ISNULL(AD.RecordDeleted,'N') <> 'Y' or AD.NativeImageRecordId = @NativeDocumentId   )                          
 
    and (d.AuthorId = @ClinicianId or                                                                      
    d.ProxyId = @ClinicianId or                                                                      
    d.Status in (22, 23) or                                                                    
    d.DocumentShared = 'Y' or           
   (d.Status = 22 and dss.DocumentId is not null))                                  
                                           
		and (d.AuthorId = @AuthorIdFilter or isnull(@AuthorIdFilter, 0) = 0) 
		and (isnull(d.EffectiveDate,@EffectiveFromDate) >= @EffectiveFromDate and isnull(d.EffectiveDate,@EffectiveFromDate)<=@EffectiveToDate)                                                
		                                              
		and ((exists(select * from @DocumentCodeFilters dcf where dcf.DocumentCodeId = d.DocumentCodeId)) or (isnull(@DocumentNavigationId, 0) = 0))                                                                    
		  
		and (((@StatusFilter = 247 or -- All Statuses                       
        @StatusFilter = 0     or -- All Statuses                                                        
        @StatusFilter > 10000)  
			and d.Status <> 20) or -- Custom Status                                                            
        (@StatusFilter = 249 and d.Status = 21) or -- In Progress                                                                    
        (@StatusFilter = 250 and d.Status = 22 and d.SignedByAuthor = 'Y') or -- Signed                                                                    
        (@StatusFilter = 251 and d.Status = 22 and isnull(d.SignedByAuthor, 'N') = 'N') or -- Completed                                                 
        (@StatusFilter = 252 and dss.DocumentId is not null and dss.SignatureDate is null and isnull(dss.DeclinedSignature, 'N') = 'N') or -- To Co-Sign                                                                                                 
        (@StatusFilter = 253 and d.Status = 22) or --Signed, Completed                                        
        (@StatusFilter = 254 and d.Status not in (20, 22,23)) or -- To Do -- Not-Signed and Completed                                                                    
        (@StatusFilter = 254 and d.Status = 21 and d.ToSign = 'Y')) -- To Sign                                                                                                                        
   and isnull(d.RecordDeleted, 'N') = 'N'                                                                    
                                                      
if @StatusFilter > 10000 or @OtherFilter > 10000                                                                    
begin                                                                    
  insert into @CustomFilters (DocumentId)                      
  exec scsp_ListPageSCAssociteDocumentList   @StatusFilter = @StatusFilter, @OtherFilter = @OtherFilter                                                        
                                                                    
  delete d                                                     
    from #ResultSet d   where not exists(select * from @CustomFilters f where f.DocumentId = d.DocumentId)                                                          
end                                                                    
     
     
;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
		AS (SELECT  DocumentId,                                                                 
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
       ClientName ,                                                                               
       DocumentVersionId         
				,Count(*) OVER () AS TotalCount
				,row_number() over( order by case when @SortExpression= 'DocumentName' then  DocumentName end,  
								   case when @SortExpression= 'DocumentName' then  EffectiveDate  end Desc,      
								   case when @SortExpression= 'DocumentName Desc' then DocumentName end Desc , 
								   case when @SortExpression= 'DocumentName Desc' then  EffectiveDate end Desc  ,       
								   case when @SortExpression= 'EffectiveDate' then EffectiveDate end ,  
								   case when @SortExpression= 'EffectiveDate' then DocumentName end ,  
								   case when @SortExpression= 'EffectiveDate' then DocumentId end ,       
								   case when @SortExpression= 'EffectiveDate desc' then EffectiveDate  end desc, 
								   case when @SortExpression= 'EffectiveDate desc' then DocumentName end ,
								   case when @SortExpression= 'EffectiveDate desc' then DocumentId end ,       
								   case when @SortExpression= 'StatusName' then StatusName end, 
								   case when @SortExpression= 'StatusName' then DocumentName end,  
								   case when @SortExpression= 'StatusName' then  DocumentId end,         
								   case when @SortExpression= 'StatusName desc' then StatusName  end desc  ,  
								   case when @SortExpression= 'StatusName desc' then DocumentName end  , 
								   case when @SortExpression= 'StatusName desc' then  DocumentId end  ,        
								   case when @SortExpression= 'AuthorName' then AuthorName end  ,  
								   case when @SortExpression= 'AuthorName' then DocumentName end  ,  
								   case when @SortExpression= 'AuthorName' then  DocumentId end  ,        
								   case when @SortExpression= 'AuthorName desc' then AuthorName  end desc,
								   case when @SortExpression= 'AuthorName desc' then DocumentName end ,
								   case when @SortExpression= 'AuthorName desc' then DocumentId end ,
									DocumentId   ) as RowNumber                                                               
			FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT Isnull(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)	   DocumentId,                                                                 
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
						ClientName ,                                                                                
						DocumentVersionId             
						,TotalCount
						,RowNumber						
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT Isnull(Count(*), 0)	FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT	 DocumentId,                                                                 
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
			   ClientName ,                                                                               
			   DocumentVersionId          
		FROM #FinalResultSet
		ORDER BY RowNumber         
                                                                                    
 END TRY  
BEGIN CATCH                                                                             
 DECLARE @Error varchar(8000)                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCAssociateDocumentsListPage')                                                                                                                                             
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
