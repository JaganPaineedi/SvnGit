 /****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCClientProblemList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCClientProblemList]
GO



/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientProblemList]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
  
/********************************************************************************                                                    
-- Stored Procedure: ssp_ListPageSCClientProblemList  
-- File      : ssp_ListPageSCClientProblemList.sql  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Procedure to return data for the Client Problems list page.  
--  
-- Date   Author    Purpose  
-- 22/Aug/2012  Mamta Gupta   Created   
-- 19/Sep/2012  Mamta Gupta   End Date filter Modification . Ref Task No. 13 - Primary Care - Bugs/Features.  
-- 19/Sep/2012  Mamta Gupta   Start Date filter Modification . Ref Task No. 13 - Primary Care - Bugs/Features.  
 /*30 oct 2012          Vishant Garg                Replace DiagnosisDSMDescription with DiagnosisicdCodes */  
 /*11 Dec 2012          Raghum          Modified the LastName, Firstname format as per the standard format. Ref Task#217 in Primary Care Bugs/Features */  
--03 Sep  2015  vkhare			Modified for ICD10 changes
--01 June  2017  Varun			Modified for MeaningfulUseStage3 #5.1
*********************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_ListPageSCClientProblemList]     
(  
 @PageNumber   INT,    
 @PageSize   INT,    
 @SortExpression  VARCHAR(100),    
 @ClientId   INT,  
 @StartDate   VARCHAR(50),  
 @EndDate   VARCHAR(50),  
 @ProblemType  INT,  
 @ProvidersFilter INT  
)  
AS         
BEGIN                                                                  
 BEGIN TRY    
  
  declare @DiagnosisHistoryTable TABLE (StartDate datetime,
				EndDate datetime,
				DSMCode Varchar(20),
				ICD10Code Varchar(20),
				SNOMEDCODE Varchar(20),
                DSMDescription Varchar(max),
				DiagnosisType Varchar(100)
               )
insert @DiagnosisHistoryTable
exec [ssp_MeaningfulUseDiagnosisHistory] @StartDate,@EndDate,@ClientId
              
 ;WITH SCClientProblems  
 AS   
 (   
  SELECT  
    CONVERT(VARCHAR(10), CP.StartDate, 101) AS StartDate,  
    CONVERT(VARCHAR(10), CP.EndDate, 101) AS EndDate, 
    GC.CodeName as ProblemType,  
    CP.DSMCode, 
    CP.ICD10Code,  
    CP.SNOMEDCODE,  
    DDD.ICDDescription AS DSMDescription
    FROM ClientProblems AS CP   
    Left JOIN Staff AS S ON S.StaffId=CP.StaffId  
    Left Join GlobalCodes GC on GC.GlobalCodeId=CP.ProblemType  
    Left Join DiagnosisICD10Codes DDD on DDD.ICD10CodeId=CP.ICD10CodeId
    LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE 
    WHERE   
    (  
   CP.ClientId=@ClientId  
   and (@ProblemType=0 or CP.ProblemType=@ProblemType)  
   and (@ProvidersFilter=0 or CP.StaffId=@ProvidersFilter)  
   --AND (@StartDate is null or CP.StartDate is null or CP.EndDate is null or (cast(convert(varchar(10),CP.StartDate,101) as datetime) >= cast(convert(varchar(10),@StartDate,101) as datetime) and cast(convert(varchar(10),CP.StartDate,101) as datetime) <=cast(convert(varchar(10),@EndDate,101) as datetime)))  
   --AND (@EndDate is null or CP.StartDate is null or CP.EndDate is null or (cast(convert(varchar(10),CP.EndDate,101) as datetime) <= cast(convert(varchar(10),@EndDate,101) as datetime) and cast(convert(varchar(10),CP.EndDate,101) as datetime) >= cast(convert(varchar(10),@StartDate,101) as datetime)))  
   AND (  
     (cast(convert(varchar(10),CP.StartDate,101) as datetime) >= @StartDate OR @StartDate is null or CP.StartDate is null)   
     OR    
     (cast(convert(varchar(10),CP.EndDate,101) as datetime) >= @StartDate OR CP.EndDate is null)  
    )      
   AND (  
     cast(convert(varchar(10),CP.StartDate,101) as datetime)<= ISNULL(@EndDate,'01/01/2999') OR CP.StartDate is null   
    )  
    and isnull(CP.RecordDeleted,'N')='N'  
    )  
	UNION
	select 
	 CONVERT(VARCHAR(10), StartDate, 101) AS StartDate,  
     CONVERT(VARCHAR(10), EndDate, 101) AS EndDate,
	 DiagnosisType AS ProblemType,
	 DSMCode,
	 ICD10Code,
	 SNOMEDCODE,
	 DSMDescription
	 from  @DiagnosisHistoryTable 
   ),  
      counts as (  
  select count(*) as totalrows from SCClientProblems  
      ),  
      RankResultSet  
      as  
      (  
  SELECT 
   StartDate,  
   EndDate,  
   ProblemType,  
   DSMCode, 
   ICD10Code,  
   SNOMEDCODE,  
   DSMDescription,
   COUNT(*) OVER ( ) AS TotalCount ,  
            ROW_NUMBER() OVER ( ORDER BY   
            CASE WHEN @SortExpression= 'DSMCode'   THEN DSMCODE END,    
            CASE WHEN @SortExpression= 'DSMCode DESC'   THEN DSMCODE END DESC,    
   CASE WHEN @SortExpression= 'DSMDescription'    THEN DSMDescription END,           
   CASE WHEN @SortExpression= 'DSMDescription DESC'   THEN DSMDescription END DESC,  
   CASE WHEN @SortExpression= 'StartDate'   THEN StartDate END,                                      
   CASE WHEN @SortExpression= 'StartDate DESC'  THEN StartDate END DESC,                                            
   CASE WHEN @SortExpression= 'EndDate'    THEN EndDate END,                                                
   CASE WHEN @SortExpression= 'EndDate DESC'   THEN EndDate END DESC,    
   CASE WHEN @SortExpression= 'ProblemType'    THEN ProblemType END,                                      
   CASE WHEN @SortExpression= 'ProblemType DESC'   THEN ProblemType END DESC,
   CASE WHEN @SortExpression= 'ICD10Code'    THEN ICD10Code END,                                      
   CASE WHEN @SortExpression= 'ICD10Code DESC'   THEN ICD10Code END DESC, 
   CASE WHEN @SortExpression= 'SNOMEDCODE'    THEN ICD10Code END,                                      
   CASE WHEN @SortExpression= 'SNOMEDCODE DESC'   THEN ICD10Code END DESC, 
   CASE WHEN @SortExpression= 'SNOMEDCTDescription'    THEN ICD10Code END,                                      
   CASE WHEN @SortExpression= 'SNOMEDCTDescription DESC'   THEN ICD10Code END DESC)    
   AS RowNumber  
   FROM     SCClientProblems    
        )  
        SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)  
   StartDate,  
   EndDate,  
   ProblemType,  
   DSMCode,  
   ICD10Code,  
   SNOMEDCODE, 
   DSMDescription,  
   TotalCount ,  
   RowNumber  
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
  
  SELECT 
   StartDate,  
   EndDate,  
   ProblemType,  
   DSMCode,  
   ICD10Code,  
   SNOMEDCODE,
   DSMDescription, 
   TotalCount,  
   RowNumber  
         FROM    #FinalResultSet  
         ORDER BY RowNumber                      
    
 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMGlobalCodes')                                                                                                 
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                  
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())    
  RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  );    
 END CATCH    
END    