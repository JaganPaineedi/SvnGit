/****** Object:  StoredProcedure [dbo].[ssp_CMListPageBatchClaimUpload]    Script Date: 08/22/2016 14:01:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMListPageBatchClaimUpload]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMListPageBatchClaimUpload]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMListPageBatchClaimUpload]    Script Date: 08/22/2016 14:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_CMListPageBatchClaimUpload]          
(   
  @PageNumber            INT   
 ,@PageSize              INT   
 ,@SortExpression varchar(50) 
 ,@OtherFilter int  
 ,@FromDate	Datetime
 ,@ToDate Datetime 
 ,@InsurerId int
 ,@SiteId int
 ,@ProviderId INT
 ,@LoggedInUserId INT
)        
 AS  
   BEGIN   
     BEGIN TRY       
/*********************************************************************/                                              
-- Stored Procedure: dbo.ssp_CMListPageBatchClaimUpload                                                              
-- Copyright: Streamline Healthcate Solutions                                                            
-- Creation Date:  09/08/2016                                                                               
--                                                                                                                 
-- Purpose: It will list the Batch Claim uploaded file details                                                      
--                                                                                                               
-- Input Parameters:                                                     
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
-- Date         Author       Purpose                                                                               
-- 09/08/2016   Gautam       Created,  Ref #73  Network180-Customizations.  
-- 02/09/2018	Msood		What: Added the check to check StaffProviders Table as well as Staff.AllProvider
--							Why: Heartland - Support Go Live Task #20  
-- 02/12/2018	jcarlson	Heartland SGL 20 : added @LoggedInUserId to allow filtering based on logged in user for Insurers and Providers to prevent seeing files
--												for providers and insurers you do not have access to
/*********************************************************************/    
  
DECLARE @StaffAllInsurers CHAR(1) = 'N';
DECLARE @StaffAllProviders CHAR(1) = 'N';

SELECT @StaffAllInsurers = ISNULL(st.AllInsurers,'N'),
@StaffAllProviders = ISNULL(st.AllProviders,'N')
FROM Staff st
WHERE st.StaffId = @LoggedInUserId 
AND isnull(st.RecordDeleted, 'N') = 'N'

	  
--Temp table to insert records for Batch Claim List page  
      CREATE TABLE #ResultSet   
         (   
        ClaimBatchUploadId int,  
		UploadedFileName varchar(500), 
		UploadedDate datetime, 
		UploadedBy varchar(300),
		ProviderName  varchar(100)
         )    

    INSERT INTO #ResultSet  
    (  
      ClaimBatchUploadId ,  
		UploadedFileName, 
		UploadedDate, 
		UploadedBy,
		ProviderName
    ) 
     Select distinct BC.ClaimBatchUploadId ,  
		BC.UploadedFileName, 
		BC.UploadedDate, 
		S.LastName + ', ' + S.FirstName as UploadedBy,
		P.ProviderName
	 From ClaimBatchUploads BC join ClaimBatchDirectEntries CD on BC.ClaimBatchUploadId= CD.ClaimBatchUploadId
			and isnull(CD.RecordDeleted,'N') = 'N'
			Join Staff S On BC.UploadedBy=S.StaffId 
			Join Providers P On P.ProviderId= BC.ProviderId
      WHERE  
        isnull(BC.RecordDeleted,'N') = 'N'  and
        ((@FromDate is null or cast(BC.UploadedDate as date)>= cast(@FromDate as date) ) and
         (@ToDate is null or cast(BC.UploadedDate as date) <= cast(@ToDate as date)   ))
       and (@InsurerId =-1 or CD.InsurerId=@InsurerId)
        and (@SiteId =-1 or CD.SiteId=@SiteId)
        and (@ProviderId = -1 or BC.ProviderId=@ProviderId )
        AND ( EXISTS (  
						 SELECT sp.ProviderId  
						 FROM StaffProviders AS sp 
						 WHERE  isnull(sp.RecordDeleted, 'N') = 'N'  
						 AND sp.ProviderId = P.ProviderId  
						 AND sp.StaffId = @LoggedInUserId )													
				OR @StaffAllProviders = 'Y'
			)
		AND ( EXISTS ( 
					SELECT 1
					FROM dbo.StaffInsurers AS si
					WHERE ISNULL(si.RecordDeleted,'N')='N'
					AND si.InsurerId = CD.InsurerId
					AND si.StaffId = @LoggedInUserId
				   )
			OR @StaffAllInsurers = 'Y'
		 )

----	

  ; WITH  Counts  
          AS ( SELECT   COUNT(*) AS TotalRows  
               FROM     #ResultSet  
             ) ,  
                        RankResultSet  
                          AS ( SELECT ClaimBatchUploadId ,  
							UploadedFileName, 
							UploadedDate, 
							UploadedBy,
							ProviderName,
							COUNT(*) OVER ( ) AS TotalCount   
							  , Rank() 
								 OVER( ORDER BY
								  CASE WHEN @SortExpression = 'UploadedFileName' THEN UploadedFileName END, 
								  CASE WHEN @SortExpression = 'UploadedFileName desc' THEN UploadedFileName END DESC, 							                               
								  CASE WHEN @SortExpression = 'UploadedDate' THEN UploadedDate END, 
								  CASE WHEN @SortExpression = 'UploadedDate desc' THEN UploadedDate END DESC, 
								  CASE WHEN @SortExpression = 'UploadedBy' THEN UploadedBy END, 
								  CASE WHEN @SortExpression = 'UploadedBy desc' THEN UploadedBy END DESC, 
								  CASE WHEN @SortExpression = 'ProviderName' THEN ProviderName END, 
								  CASE WHEN @SortExpression = 'ProviderName desc' THEN ProviderName END DESC, 
								  ClaimBatchUploadId) 
								  AS RowNumber 
							FROM   #ResultSet) 
       			
		
                  
        SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(Totalrows, 0) FROM Counts) ELSE (@PageSize) END) 
			 ClaimBatchUploadId ,  
							UploadedFileName, 
							UploadedDate, 
							UploadedBy,
							ProviderName,
							RowNumber,
							TotalCount
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
					 ClaimBatchUploadId ,  
							UploadedFileName, 
							UploadedDate, 
							UploadedBy,
							ProviderName
		  FROM   #FinalResultSet 
		  ORDER  BY Rownumber 
           
    END TRY           
  BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_CMListPageBatchClaimUpload')
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
   
 