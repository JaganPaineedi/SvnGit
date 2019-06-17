/****** Object:  StoredProcedure [dbo].[ssp_EligibilityBatchProcessSubListPage]    Script Date: 06/07/2012 16:56:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_EligibilityBatchProcessSubListPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_EligibilityBatchProcessSubListPage]
GO
/****** Object:  StoredProcedure [dbo].[ssp_EligibilityBatchProcessSubListPage]    Script Date: 06/07/2012 16:56:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Kneale Alpers    
-- Create date: Feb 14, 2012    
-- Description: Retrieves Electronic Eligibility Batch Process records s
-- 10/Mar/2016	Pradeep.A	Included Sort Expresion for SubscriberInsuredId
-- 20/Jun/2016	Ravichandra		   Removed the physical table ListPageEligibilityBatchProcess from SP
--								   Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--								   108 - Do NOT use list page tables for remaining list pages (refer #107)
-- =============================================    
CREATE PROCEDURE [dbo].[ssp_EligibilityBatchProcessSubListPage]    
    @SessionId VARCHAR(30) ,    
    @InstanceId INT ,    
    @PageNumber INT ,    
    @PageSize INT ,    
    @SortExpression VARCHAR(100) ,    
    @BatchId AS INT ,    
    @OtherFilter INT ,    
    @StaffId INT    
AS     
    BEGIN    
        BEGIN TRY     
      
            CREATE TABLE #ResultSet    
                (    
                  EligibilityVerificationRequestId INT ,    
                  Organization VARCHAR(50) ,    
                  BatchId BIGINT ,    
                  BatchName VARCHAR(50) ,    
                  BatchDate DATETIME ,    
                  StaffName VARCHAR(50) ,    
                  ClientId BIGINT ,    
                  ElectronicEligibilityVerificationPayerId INT ,    
                  SubscriberInsuredId VARCHAR(25) ,    
                  SubscriberFirstName VARCHAR(20) ,    
                  SubscriberLastName VARCHAR(30) ,    
                  SubscriberDOB DATETIME ,    
                  SubscriberSex CHAR(1) ,    
                  SubscriberSocialSecurity CHAR(11) ,    
                  DependentRelationshipName VARCHAR(50) ,    
                  DependentFirstName VARCHAR(20) ,    
                  DependentLastName VARCHAR(30) ,    
                  DependentSex CHAR(1) ,    
                  DependentDOB DATETIME ,    
                  DateOfServiceStart DATETIME ,    
                  DateOfServiceEnd DATETIME ,    
                  RequestErrorMessage VARCHAR(MAX) ,    
                  VerifiedOnDate DATETIME    
                )    

            SET @SortExpression = RTRIM(LTRIM(@SortExpression))    
            IF ISNULL(@SortExpression, '') = ''     
                SET @SortExpression = 'EligibilityVerificationRequestId'    
                
 
  ;WITH    OrganizationSelection ( Organization )    
                      AS ( SELECT TOP ( 1 )    
                                    OrganizationName    
                           FROM     SystemConfigurations    
                         ),    
                    OrgWithBatchName ( Organization, BatchId, BatchName, BatchDate, StaffName )    
                      AS ( SELECT   a.Organization ,    
                                    b.ElectronicEligibilityVerificationBatchId ,    
                                    b.BatchName ,    
                                    b.CreatedDate ,                                        
                                    RTRIM(c.LastName) + ', ' + LTRIM(c.FirstName)    
                           FROM     dbo.ElectronicEligibilityVerificationBatches b    
                                    JOIN OrganizationSelection a ON ( a.Organization = a.Organization )    
                                    LEFT JOIN staff c ON ( b.CreatedBy = c.UserCode )    
                           WHERE    ElectronicEligibilityVerificationBatchId = @BatchId    
                         )   
                         
                          
                INSERT  INTO #ResultSet    
                        (
                         EligibilityVerificationRequestId ,    
                          Organization ,    
                          BatchId ,    
                          BatchName ,    
                          BatchDate ,    
                          StaffName ,    
                          ClientId ,    
                          ElectronicEligibilityVerificationPayerId ,    
                          SubscriberInsuredId ,    
                          SubscriberFirstName ,    
                          SubscriberLastName ,    
                          SubscriberDOB ,    
                          SubscriberSex ,    
                          SubscriberSocialSecurity ,    
                          DependentRelationshipName ,    
                          DependentFirstName ,    
                          DependentLastName ,    
                          DependentSex ,    
                          DependentDOB ,    
                          DateOfServiceStart ,    
                          DateOfServiceEnd ,    
                          RequestErrorMessage ,    
                          VerifiedOnDate     
                        )    
                        SELECT  b.EligibilityVerificationRequestId ,    
                                Organization ,    
                                BatchId ,    
                                BatchName ,    
                                BatchDate ,    
                                StaffName ,    
                                b.clientid ,    
                                b.ElectronicEligibilityVerificationPayerId ,    
                                b.SubscriberInsuredId ,    
                                b.SubscriberFirstName ,    
                                b.SubscriberLastName ,    
                                CONVERT(VARCHAR(10), CAST(b.SubscriberDOB AS DATETIME), 101) AS SubscriberDOB ,    
                                b.SubscriberSex ,    
                                CASE WHEN ISNULL(b.SubscriberSSN, '') = ''    
                                     THEN ''    
                                     ELSE '***-**-'    
                                          + RIGHT(ISNULL(b.SubscriberSSN, ''),    
                                                  4)    
                                END AS SubscriberSocialSecurity ,    
                                c.CodeName AS DependentRelationshipName ,    
                                b.DependentFirstName ,    
                                b.DependentLastName ,    
                                b.DependentSex ,    
                                CONVERT(VARCHAR(10), CAST(b.DependentDOB AS DATETIME), 101) AS DependentDOB ,    
                                CONVERT(VARCHAR(10), CAST(b.DateOfServiceStart AS DATETIME), 101) AS DateOfServiceStart ,    
                                CONVERT(VARCHAR(10), CAST(b.DateOfServiceEnd AS DATETIME), 101) AS DateOfServiceEnd ,    
                                b.RequestErrorMessage ,    
                                CONVERT(VARCHAR(10), CAST(b.VerifiedOnDate AS DATETIME), 101) AS VerifiedOnDate    
                        FROM    OrgWithBatchName a    
                                JOIN dbo.ElectronicEligibilityVerificationRequests b ON ( a.BatchId = b.ElectronicEligibilityVerificationBatchId )    
                                LEFT JOIN globalcodes c ON ( b.DependentRelationshipCode = c.GlobalCodeId )    
						WHERE   ISNULL(b.RecordDeleted, 'N') <> 'Y'     

 
 ; WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT		 EligibilityVerificationRequestId ,    
                              Organization ,    
                              BatchId ,    
                              BatchName ,    
                              BatchDate ,    
                              StaffName ,    
                              ClientId ,    
                              ElectronicEligibilityVerificationPayerId ,    
                              SubscriberInsuredId ,    
                              SubscriberFirstName ,    
                              SubscriberLastName ,    
                              SubscriberDOB ,    
                              SubscriberSex ,    
                              SubscriberSocialSecurity ,    
                              DependentRelationshipName ,    
                              DependentFirstName ,    
                              DependentLastName ,    
                              DependentSex ,    
                              DependentDOB ,    
                              DateOfServiceStart ,    
                              DateOfServiceEnd ,    
                              RequestErrorMessage ,    
                              VerifiedOnDate      
				 ,Count(*) OVER () AS TotalCount
				 ,ROW_NUMBER() OVER ( ORDER BY CASE    
                                                              WHEN @SortExpression = 'StaffName'    
                                                              THEN StaffName    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'StaffName DESC'    
															  THEN StaffName    
                                                              END DESC, CASE    
                                                              WHEN @SortExpression = 'DependentFirstName'    
                                                              THEN DependentFirstName    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'DependentFirstName DESC'    
                                                              THEN DependentFirstName    
                                                              END DESC, CASE    
                                                              WHEN @SortExpression = 'DependentLastName'    
                                                              THEN DependentLastName    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'DependentLastName DESC'    
                                                              THEN DependentLastName    
                                                              END DESC, CASE    
                                                              WHEN @SortExpression = 'DependentSex'    
                                                              THEN DependentSex    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'DependentSex DESC'    
                                                              THEN DependentSex    
                                                              END DESC,CASE    
                                                              WHEN @SortExpression = 'DependentDOB'    
                                                              THEN DependentDOB    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'DependentDOB DESC'    
                                                              THEN DependentDOB    
                                                              END DESC,CASE      
                                                              WHEN @SortExpression = 'SubscriberInsuredId'      
                                                              THEN SubscriberInsuredId      
                                                              END, CASE      
                                                              WHEN @SortExpression = 'SubscriberInsuredId DESC'      
                                                              THEN SubscriberInsuredId      
                                                              END DESC,CASE    
                                                              WHEN @SortExpression = 'DateOfServiceStart'    
                                                              THEN CAST(DateOfServiceStart AS DATETIME)    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'DateOfServiceStart DESC'    
                                                              THEN CAST(DateOfServiceStart AS DATETIME)    
                                                              END DESC, CASE    
                                                              WHEN @SortExpression = 'DateOfServiceEnd'    
                                                              THEN CAST(DateOfServiceEnd AS DATETIME)    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'DateOfServiceEnd DESC'    
                                                              THEN CAST(DateOfServiceEnd AS DATETIME)    
                                                              END DESC, CASE    
                                                              WHEN @SortExpression = 'RequestErrorMessage'    
                                                              THEN RequestErrorMessage    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'RequestErrorMessage DESC'    
                                                              THEN RequestErrorMessage    
                                                              END DESC,CASE    
                                                              WHEN @SortExpression = 'VerifiedOnDate'    
                                                              THEN CAST(VerifiedOnDate AS DATETIME)    
                                                              END, CASE    
                                                              WHEN @SortExpression = 'VerifiedOnDate DESC'    
                                                              THEN CAST(VerifiedOnDate AS DATETIME)    
                                                              END DESC, EligibilityVerificationRequestId ) AS RowNumber    
												FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)	  EligibilityVerificationRequestId ,    
                              Organization ,    
                              BatchId ,    
                              BatchName ,    
                              BatchDate ,    
                              StaffName ,    
                              ClientId ,    
                              ElectronicEligibilityVerificationPayerId ,    
                              SubscriberInsuredId ,    
                              SubscriberFirstName ,    
                              SubscriberLastName ,    
                              SubscriberDOB ,    
                              SubscriberSex ,    
                              SubscriberSocialSecurity ,    
                              DependentRelationshipName ,    
                              DependentFirstName ,    
                              DependentLastName ,    
                              DependentSex ,    
                              DependentDOB ,    
                              DateOfServiceStart ,    
                              DateOfServiceEnd ,    
                              RequestErrorMessage ,    
                              VerifiedOnDate      
					,TotalCount
					,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
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
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT   EligibilityVerificationRequestId ,    
				Organization ,    
				BatchId ,    
				BatchName ,    
				BatchDate ,    
				StaffName ,    
				ClientId ,    
				ElectronicEligibilityVerificationPayerId ,    
				SubscriberInsuredId ,   
				SubscriberFirstName ,    
				SubscriberLastName ,    
				CONVERT(VARCHAR(10), SubscriberDOB, 101) AS SubscriberDOB ,    
				SubscriberSex ,    
				SubscriberSocialSecurity ,    
				DependentRelationshipName ,    
				DependentFirstName ,    
				DependentLastName ,    
				DependentSex ,    
				CONVERT(VARCHAR(10), DependentDOB, 101) AS DependentDOB,    
				CONVERT(VARCHAR(10), DateOfServiceStart, 101) AS DateOfServiceStart ,    
				CONVERT(VARCHAR(10), DateOfServiceEnd, 101) AS DateOfServiceEnd ,    
				RequestErrorMessage ,    
				CONVERT(VARCHAR(10), VerifiedOnDate, 101) AS VerifiedOnDate         
		FROM #FinalResultSet
		ORDER BY RowNumber   
            
                    
        END TRY     
     
        BEGIN CATCH    
            DECLARE @Error VARCHAR(8000)           
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'    
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'    
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),    
                         'ssp_EligibilityBatchProcessSubListPage') + '*****'    
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'    
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'    
                + CONVERT(VARCHAR, ERROR_STATE())    
            RAISERROR    
  (    
   @Error, -- Message text.    
   16,  -- Severity.    
   1  -- State.    
  ) ;    
        END CATCH    
    END    
    
    
GO


