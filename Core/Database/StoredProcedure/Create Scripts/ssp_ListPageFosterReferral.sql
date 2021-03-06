/****** Object:  StoredProcedure [dbo].[ssp_ListPageFosterReferral]    Script Date: 02/03/2015 01:57:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageFosterReferral]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageFosterReferral]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
      
CREATE PROCEDURE [dbo].[ssp_ListPageFosterReferral]                  
/*********************************************************************/   
/* Stored Procedure: dbo.ssp_ListPageFosterReferral          */   
/* Creation Date:  30/10/2012                                            */   
/*                                                                       */   
/* Purpose: To Bind Foster Referral List Page   
                                   */   
/*                                                                   */   
/* Input Parameters: @FosterReferralId               */   
/*                                                                   */   
/* Output Parameters:                         */   
/*                                                                   */   
/*  Date                  Author                 Purpose             */   
/* 30/10/2012             MSuma           Created                
   27/07/2018			  Bibhu     what:Added join with staffclients table to display associated clients for login staff  
          							why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  */
/*********************************************************************/   
    @PageNumber INT ,            
    @PageSize INT ,            
    @SortExpression VARCHAR(100) ,                                  
    @FromDate DATETIME,      
    @ToDate DATETIME,                                
    @ReferralStatus INT,            
    @Placement varchar(50),            
    @Child varchar(50) ,
    @LoggedInStaffId INT =NULL           
                
    AS             
    BEGIN            
                                                              
        BEGIN TRY              
                                                                             
            
            DECLARE @ApplyFilterClicked CHAR(1)              
            DECLARE @FiltersApplied CHAR(1)              
              
            IF ( @FromDate = CONVERT(DATETIME, N'') )             
                BEGIN              
                    SET @FromDate = NULL              
                END              
                            
                         IF ( @ToDate = CONVERT(DATETIME, N'') )             
                BEGIN              
                    SET @ToDate = NULL              
                END     
                    
                    
                 SET @SortExpression = RTRIM(LTRIM(@SortExpression))              
            IF ISNULL(@SortExpression, '') = ''             
                SET @SortExpression = 'ReferralID'              
                            
                  
            ;WITH    ReferralListResultSet            
            AS (          
                 
 SELECT   DISTINCT  
    CFR.FosterReferralId,    
    ISNULL(CFC.LastName,'') + ', '+ISNULL(CFC.FirstName,'') as ChildName,    
    GC.CodeName AS Status,    
    CFR.StartDate As RequestedDate,    
    ISNULL(S.LastName,'') + ', ' + ISNULL(S.FirstName,'') As IntakeWorker,    
    CPF.FamilyName ,CPF.PlacementFamilyID,CFC.ClientId  
     FROM    
    FosterReferrals  CFR     
    JOIN  FosterChildren CFC on CFR.FosterReferralId = CFC.FosterReferralId    
   --LEFT JOIN  FosterReferralPlacements CFP ON CFC.FosterReferralId = CFP.FosterReferralId and CFP.Accepted='Y'  
   --   AND ISNULL(CFP.RecordDeleted,'N')='N'   
   LEFT JOIN  FosterPlacements CFP ON CFP.FosterReferralId = CFR.FosterReferralId   
    and CFC.FosterChildId= CFP.FosterChildId  AND ISNULL(CFP.RecordDeleted,'N')='N'   
    LEFT JOIN  PlacementFamilies CPF on CPF.PlacementFamilyID = CFP.PlacementFamilyId    
    LEFT JOIN GlobalCodes GC on Gc.GlobalCodeId = CFC.ReferralStatus and GC.Category = 'XFosterReferralsTYPE'  
    LEFT JOIN Staff S on S.StaffId = CFR.IntakeWorker 
    INNER JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId AND sc.ClientId = CFC.ClientId            ----- 27/07/2018			  Bibhu 
     WHERE    
   (ISNULL(@Placement,'')='' OR CPF.familyname like '%'+@Placement+'%')AND  
   ( ISNULL(@Child,'') = '' OR CFC.lastname LIKE '%' + @Child + '%'   
                                     OR CFC.firstname LIKE '%' + @Child + '%' ) AND  
   (CFR.StartDate IS NULL OR     
      (CFR.StartDate IS NOT NULL AND     
      (@FromDate IS NULL OR CFR.StartDate >= @FromDate) AND     
      (@ToDate IS NULL OR CFR.StartDate <= @ToDate)))    
    AND (ISNULL(@ReferralStatus,-1) = -1 OR CFC.ReferralStatus = @ReferralStatus )   
    AND ISNULL(CFR.RecordDeleted,'N')='N'  
    AND ISNULL(CFC.RecordDeleted,'N')='N'  
    AND ISNULL(CPF.RecordDeleted,'N')='N'  
    AND ISNULL(GC.RecordDeleted,'N')='N'  
    AND ISNULL(S.RecordDeleted,'N')='N'  
    ),  
      
  
  COUNTS AS (   
  SELECT count(*) as totalrows from ReferralListResultSet  
  ),RankResultSet AS   
                
            (select     
   FosterReferralId,    
   ChildName,    
   Status,    
   RequestedDate,    
   IntakeWorker,    
   FamilyName  ,  
   PlacementFamilyID,  
   ClientId,  
   COUNT(*) OVER ( ) AS TotalCount ,  
             RANK() OVER ( ORDER BY   
                CASE WHEN @SortExpression= 'FosterReferralId'    THEN FosterReferralId END,   
                CASE WHEN @SortExpression= 'FosterReferralId DESC'  THEN FosterReferralId END DESC,                                    
    CASE WHEN @SortExpression= 'ChildName'    THEN ChildName END,    
    CASE WHEN @SortExpression= 'ChildName DESC'   THEN ChildName END DESC,                                          
    CASE WHEN @SortExpression= 'Status'     THEN Status END,                                              
    CASE WHEN @SortExpression= 'Status DESC'   THEN Status END DESC,  
    CASE WHEN @SortExpression= 'RequestDate'   THEN RequestedDate END,  
    CASE WHEN @SortExpression= 'RequestDate DESC'  THEN RequestedDate  END  DESC,   
    CASE WHEN @SortExpression= 'IntakeWorker'   THEN IntakeWorker END,  
    CASE WHEN @SortExpression= 'IntakeWorker DESC'  THEN IntakeWorker  END  DESC,  
    CASE WHEN @SortExpression= 'FamilyName'    THEN FamilyName END,  
    CASE WHEN @SortExpression= 'FamilyName DESC'  THEN FamilyName  END  DESC,  
    FosterReferralId  
    )  AS RowNumber  
                           FROM     ReferralListResultSet  
     )  
                                           
    
   SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)  
    FosterReferralId,    
   ChildName,    
   Status,    
   RequestedDate,    
   IntakeWorker,    
   FamilyName  ,  
   PlacementFamilyID,  
   ClientId,  
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
               FosterReferralId,    
   ChildName,    
   Status,    
   CONVERT(Varchar,RequestedDate ,101) AS  RequestedDate,  
   IntakeWorker,    
   FamilyName,  
   PlacementFamilyID,  
   ClientId  
            FROM    #FinalResultSet  
              
              
                
                
                
     
                            
               END TRY            
             
 BEGIN CATCH            
  DECLARE @Error VARCHAR(8000)                   
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                        
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPageFosterReferral')                                                                                                         
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
  
GO
