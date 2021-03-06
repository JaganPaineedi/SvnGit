/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCAuthorizationCodeList]    Script Date: 11/18/2011 16:25:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCAuthorizationCodeList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCAuthorizationCodeList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ssp_ListPageSCAuthorizationCodeList]                                                        
@SessionId varchar(30),                                                    
@InstanceId int,                                                    
@PageNumber int,                                                        
@PageSize int,                                                        
@SortExpression varchar(100),                                                    
@ActiveCodeFilter int,                                                   
@MapFilter int,                     
@ProcedureCodeFilter int,                  
@BillingCodeFilter int,                             
@OtherFilter int ,      
@StaffId int  --Modified by Sahil Dated : 19-May-2010                                                     
/********************************************************************************                                                    
-- Stored Procedure: dbo.ssp_ListPageSCAuthorizationCodeList                                                      
--                                                    
-- Copyright: Streamline Healthcate Solutions                                                    
--                                                    
-- Purpose: used by  Attach/Review Claims list page                                                    
--                                                    
-- Updates:                                                                                                           
-- Date      Author    Purpose                                                    
-- 21.1.2010       Ankesh    Created.                                                          
-- Procedure Need to be modified to have handle Map Filter in a single select statement rather than Multiple if's                                                  
-- 07,July,2010    Mahesh Sharma     Show display as column on Authorization code list pages. And Modify the table     
--          ListPageSCAuthorizationCodes for same purpose.    
-- 19,July,2010    Mahesh Sharma     Removed dispaly as column from ListPageSCAuthorizationCodes table and set the
									 AuthorizationCodeName as 'Display As' header with AuthorizationCodeName column on Authorization code list pages
--20 Feb 2013		Saurav Pande	Done w.r.t task #512 in Centrawellness-Bugs/Features In list page "DispalyAs" data will be there.	
--20 July 2015      Arjun K R        Condition to check record deleted from procedures and billing code tables is removed. Task #210 CEI Env Issues Tracking.						 
--02 JUN  2016		Ravichandra		 Removed the physical table ListPageSCAuthorizationCodes from SP
									 Why:Engineering Improvement Initiatives- NBL(I)	
									 108 - Do NOT use list page tables for remaining list pages (refer #107)
--07-March-2017    Sachin			 Added Subquery as MapsToPracticeManagementCode	and as  MapsToCareManagementCode Task AspenPointe-Environment Issues #149
--03-Jan-2018      Lakshmi			Filter issue has been fixed as per the task core bugs #2497
*********************************************************************************/                                                    
AS                  
  BEGIN        
Begin try                    
                  
create table #ResultSet(                                                                               
SortExpression varchar(100),                  
AuthorizationCodeId int,                  
AuthorizationCodeName varchar(100),       
--DispalyAs varchar(25),Removed on 19 July,2010
Units varchar(50),                  
MapsToPracticeManagementCode varchar(100),                  
MapsToCareManagementCode varchar(100)                         
)                                                    
                                                    
declare @CustomFilters table (AuthorizationCodeId int)                                                    
--declare @DocumentCodeFilters table (DocumentCodeId int)                                                    
                                                    
declare @ApplyFilterClicked char(1)                                                    
--                                                    
-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                    
--                                                    
             
--                                                    
-- New retrieve - the request came by clicking on the Apply Filter button                                                               
--                                                    
                                                    
                              
if (@MapFilter=154) --Procedure Need to be modified to have handle Map Filter in a single select statement rather than Multiple if's              
 begin                                                           
insert into #ResultSet(                          
 AuthorizationCodeId ,                  
 AuthorizationCodeName ,    
 --DispalyAs,--Added on 7 July,2010                  
 Units ,                  
 MapsToPracticeManagementCode ,                  
 MapsToCareManagementCode                        
)              
  SELECT  AC.AuthorizationCodeId, 
  --AC.AuthorizationCodeName,    
  AC.DisplayAs as AuthorizationCodeName, --Added by saurav Pande
  --AC.DisplayAs,  --Added on 7 July,2010                         
             CAST(AC.Units AS Varchar)+ ' ' + G.CodeName AS Units,           
             --AC.ProcedureCodeGroupName as MapsToPracticeManagementCode,                     
             --AC.BillingCodeGroupName as  MapsToCareManagementCode
              (SELECT top 1 AC.ProcedureCodeGroupName FROM AuthorizationCodeProcedureCodes AA WHERE AC.AuthorizationCodeId = AA.AuthorizationCodeId  AND (ISNULL(AA.RecordDeleted, 'N') = 'N')) as MapsToPracticeManagementCode,
              (SELECT top 1 AC.BillingCodeGroupName FROM  AuthorizationCodeBillingCodes ABC WHERE AC.AuthorizationCodeId = ABC.AuthorizationCodeId AND (ISNULL(ABC.RecordDeleted, 'N') = 'N')) as  MapsToCareManagementCode 
                    FROM   GlobalCodes G RIGHT OUTER JOIN                    
                           AuthorizationCodes AC ON G.GlobalCodeId = AC.UnitType                    
                    LEFT OUTER JOIN  ProcedureCodes PC                    
                    LEFT OUTER JOIN  AuthorizationCodeProcedureCodes A ON PC.ProcedureCodeId = A.ProcedureCodeId ON                     
                        AC.AuthorizationCodeId = A.AuthorizationCodeId  AND (ISNULL(A.RecordDeleted, 'N') = 'N')                     
                    LEFT OUTER JOIN  AuthorizationCodeBillingCodes ACB                    
                    LEFT OUTER JOIN  BillingCodes BC ON ACB.BillingCodeId = BC.BillingCodeId ON                     
                        AC.AuthorizationCodeId = ACB.AuthorizationCodeId AND (ISNULL(ACB.RecordDeleted, 'N') = 'N')                    
                    WHERE (ISNULL(G.RecordDeleted, 'N') = 'N') AND ISNULL(G.Active , 'Y') = 'Y' AND         
                        (ISNULL(AC.RecordDeleted, 'N') = 'N') AND                    
                        --(ISNULL(PC.RecordDeleted, 'N') = 'N') AND                     
                        -- (ISNULL(BC.RecordDeleted, 'N') = 'N')   AND
                        ( (@ActiveCodeFilter = 0 And (AC.Active =  'Y'))or        
                             (@ActiveCodeFilter = 151 And (AC.Active =  'Y'))or          
                             (@ActiveCodeFilter = 152 And (AC.Active =  'N'))or        
                             (@ActiveCodeFilter = 153 And (AC.Active =  'Y' or AC.Active =  'N'))           
                        )          
                        AND( @BillingCodeFilter != '' and ACB.BillingCodeId =  @BillingCodeFilter or isnull(@BillingCodeFilter,0)=0             
                        )           
                        AND( @ProcedureCodeFilter != '' And A.ProcedureCodeId =  @ProcedureCodeFilter or isnull(@ProcedureCodeFilter, 0) = 0           
                        )               
                        GROUP BY AC.AuthorizationCodeId,                
                        AC.ProcedureCodeGroupName,                
                        AC.BillingCodeGroupName,                     
                        AC.AuthorizationCodeName,                
                        AC.DisplayAs,                 
                        AC.Units,                 
                        AC.UnitType,                     
                        G.CodeName,                 
                        AC.ProcedureCodeGroupName,                 
                        AC.BillingCodeGroupName          
 end          
if(@MapFilter=155) --Procedure Need to be modified to have handle Map Filter in a single select statement rather than Multiple if's              
 begin          
 insert into #ResultSet(                          
  AuthorizationCodeId ,                  
  AuthorizationCodeName ,    
  --DispalyAs,--Added on 7 July,2010                        
  Units ,                  
  MapsToPracticeManagementCode ,                  
  MapsToCareManagementCode              
)              
 SELECT AC.AuthorizationCodeId, 
  AC.DisplayAs as AuthorizationCodeName, --Added by saurav Pande
 --AC.AuthorizationCodeName,      
 --AC.DisplayAs,--Added on 7 July,2010                      
           CAST(AC.Units AS Varchar) + ' ' + G.CodeName AS Units,                    
       AC.ProcedureCodeGroupName as MapsToPracticeManagementCode,          
           AC.BillingCodeGroupName as  MapsToCareManagementCode                      
           FROM  AuthorizationCodes AC left OUTER JOIN  GlobalCodes G ON G.GlobalCodeId = AC.UnitType                      
                 RIGHT OUTER JOIN AuthorizationCodeProcedureCodes ACPC ON ACPC.AuthorizationCodeId = AC.AuthorizationCodeId            
                 AND (ISNULL(ACPC.RecordDeleted, 'N') = 'N')                       
                 WHERE         
                 (ISNULL(G.RecordDeleted, 'N') = 'N') AND (ISNULL(G.Active , 'Y') = 'Y')AND         
                 ((ISNULL(AC.RecordDeleted, 'N') = 'N') and  (AC.AuthorizationCodeId is not null) )          
                 AND (        
                 (@ActiveCodeFilter = 0 And (AC.Active =  'Y'))or        
                 (@ActiveCodeFilter = 151 And (AC.Active =  'Y'))or          
                 (@ActiveCodeFilter = 152 And (AC.Active =  'N'))or        
                 (@ActiveCodeFilter = 153 And (AC.Active =  'Y' or AC.Active =  'N'))          
               )            
              AND (@ProcedureCodeFilter != '' And ACPC.ProcedureCodeId =  @ProcedureCodeFilter or isnull(@ProcedureCodeFilter, 0) = 0           
              )
              AND NOT EXISTS ((SELECT 1 FROM  AuthorizationCodeBillingCodes ABC WHERE AC.AuthorizationCodeId = ABC.AuthorizationCodeId AND (ISNULL(ABC.RecordDeleted, 'N') = 'N')))               
                        Group By AC.AuthorizationCodeId,AC.ProcedureCodeGroupName,AC.BillingCodeGroupName,                    
                        AC.AuthorizationCodeName, AC.DisplayAs,                     
                        AC.Units, AC.UnitType, G.CodeName          
 end            
if(@MapFilter=156)--Procedure Need to be modified to have handle Map Filter in a single select statement rather than Multiple if''s              
 Begin          
  insert into #ResultSet(                          
  AuthorizationCodeId ,                  
  AuthorizationCodeName ,    
  --DispalyAs,  --Added on 7 July,2010                             
  Units ,                  
  MapsToPracticeManagementCode ,                  
  MapsToCareManagementCode                  
)              
          
  SELECT AC.AuthorizationCodeId, 
   AC.DisplayAs as AuthorizationCodeName, --Added by saurav Pande
  --AC.AuthorizationCodeName,    
  --AC.DisplayAs,--Added on 7 July,2010    
            
             CAST(AC.Units AS Varchar)  + ' '+  G.CodeName AS Units,          
            AC.ProcedureCodeGroupName as MapsToPracticeManagementCode,                    
            AC.BillingCodeGroupName  as  MapsToCareManagementCode                    
   FROM                      
    AuthorizationCodes AC left OUTER JOIN  GlobalCodes G ON G.GlobalCodeId = AC.UnitType                      
   RIGHT OUTER JOIN  AuthorizationCodeBillingCodes ACB ON ACB.AuthorizationCodeId = AC.AuthorizationCodeId  AND                    
    (ISNULL(ACB.RecordDeleted, 'N') = 'N')                    
    WHERE        
    (ISNULL(G.RecordDeleted, 'N') = 'N') AND (ISNULL(G.Active , 'Y') = 'Y')AND         
    ((ISNULL(AC.RecordDeleted, 'N') = 'N') and  (AC.AuthorizationCodeId is not null )  )              
    AND (        
         (@ActiveCodeFilter = 0 And (AC.Active =  'Y'))or        
         (@ActiveCodeFilter = 151 And (AC.Active =  'Y'))or          
         (@ActiveCodeFilter = 152 And (AC.Active =  'N'))or        
         (@ActiveCodeFilter = 153 And (AC.Active =  'Y' or AC.Active =  'N'))          
    )          
    AND(@BillingCodeFilter != '' and ACB.BillingCodeId =  @BillingCodeFilter or isnull(@BillingCodeFilter,0)=0             
    ) 
    AND NOT EXISTS (SELECT 1 FROM AuthorizationCodeProcedureCodes AA WHERE AC.AuthorizationCodeId = AA.AuthorizationCodeId  AND (ISNULL(AA.RecordDeleted, 'N') = 'N'))         
    Group By AC.AuthorizationCodeId, AC.ProcedureCodeGroupName,  AC.BillingCodeGroupName, AC.AuthorizationCodeName,AC.DisplayAs,                     
    AC.Units, AC.UnitType,G.CodeName          
 end          
              
                        
if @OtherFilter > 10000                                    
begin                                    
  insert into @CustomFilters (AuthorizationCodeId)                                    
  exec scsp_ListPageSCAuthorizationCodeList @OtherFilter = @OtherFilter                    
                                    
  delete d                         
    from #ResultSet d  where not exists(select * from @CustomFilters f where f.AuthorizationCodeId = d.AuthorizationCodeId)                                    
end 


;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
		AS (SELECT AuthorizationCodeId ,                  
				  AuthorizationCodeName ,    
				  --DispalyAs,  --Added on 7 July,2010                             
				  Units ,                  
				  MapsToPracticeManagementCode ,                  
				  MapsToCareManagementCode           
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'AuthorizationCodeId' then AuthorizationCodeId end,                                    
                                                case when @SortExpression= 'AuthorizationCodeId desc' then AuthorizationCodeId end desc, 
                                                case when @SortExpression= 'DispalyAs' then AuthorizationCodeName end,                                              
                                                case when @SortExpression= 'DispalyAs desc' then AuthorizationCodeName end desc,                                                                       
                                                case when @SortExpression= 'AuthorizationCodeName' then AuthorizationCodeName end,                                              
                                                case when @SortExpression= 'AuthorizationCodeName desc' then AuthorizationCodeName end desc,                              
                                                case when @SortExpression= 'Units' then Units end,                                              
                                                case when @SortExpression= 'Units desc' Then Units end desc,                              
                                                case when @SortExpression= 'MapsToPracticeManagementCode' then MapsToPracticeManagementCode end,                                              
                                                case when @SortExpression= 'MapsToPracticeManagementCode desc' Then MapsToPracticeManagementCode end desc,                                           
												case when @SortExpression= 'MapsToCareManagementCode' then MapsToCareManagementCode end,                                              
                                                case when @SortExpression= 'MapsToCareManagementCode desc' then MapsToCareManagementCode end desc ,                 
                                                AuthorizationCodeId ) as RowNumber                                                                    
			FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT Isnull(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)	  AuthorizationCodeId ,                  
					  AuthorizationCodeName ,    
					  --DispalyAs,  --Added on 7 July,2010                             
					  Units ,                  
					  MapsToPracticeManagementCode ,                  
					  MapsToCareManagementCode               
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

		SELECT	AuthorizationCodeId ,                  
			  AuthorizationCodeName ,    
			  --DispalyAs,  --Added on 7 July,2010                             
			  Units ,                  
			  MapsToPracticeManagementCode ,                  
			  MapsToCareManagementCode            
		FROM #FinalResultSet
		ORDER BY RowNumber         
         
              
END TRY                                                                                                   
                  
BEGIN CATCH                    
DECLARE @Error varchar(8000)                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCAuthorizationCodeList')                                                                                               
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
