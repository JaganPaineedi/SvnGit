/****** Object:  StoredProcedure [dbo].[ssp_ListPagePlacement]    Script Date: 02/03/2015 01:57:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPagePlacement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPagePlacement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  

      
CREATE PROCEDURE [dbo].[ssp_ListPagePlacement]           
  /******************************************************************************                       
  ** File: ssp_ListPagePlacement.sql                       
  ** Name: ssp_ListPagePlacement                       
  ** Desc:                         
  **                         
  ** Parameters:                        
  ** Input Output                        
  ** ---------- -----------                        
  ** N/A   Dropdown values                       
  ** Auth: MSuma                     
  ** Date: 30/08/2012                      
  *******************************************************************************                       
  ** Change History                        
  *******************************************************************************                       
  ** Date:  Author:    Description:                         
  ** 09-03-2012 MSuma  Procedure to retrieve all placemens          
  -- 27-07-2018 Bibhu  what:Added join with staffclients table to display associated clients for login staff  
          			   why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  
  *******************************************************************************/           
  @PageNumber   INT,           
  @PageSize    INT,           
  @SortExpression  VARCHAR (100),           
  @OpenStatus   INT,           
  @StartDate   DATETIME,           
  @EndDate    DATETIME,           
  @AllLevels   INT,           
  @Placement   VARCHAR (50),           
  @Child    VARCHAR (50) ,          
  @PlacementType  INT  ,
  @LoggedInStaffId INT =NULL       
AS           
  BEGIN           
      BEGIN try           
          DECLARE @ApplyFilterClicked AS CHAR (1);           
          DECLARE @FiltersApplied AS CHAR (1);           
          
IF @StartDate = ''          
  SET @StartDate = NULL           
 ELSE          
  SET @StartDate = CONVERT(DATETIME,@StartDate,10)          
  SET @SortExpression = Rtrim(Ltrim(@SortExpression));           
IF Isnull(@SortExpression, '') = ''           
      SET @SortExpression = 'PlacementFamilyId';           
          
                    
          WITH placementresult           
               AS (      
        SELECT DISTINCT          
      CFP.FosterPlacementId,          
      CFC.LastName+ ', '+CFC.FirstName + ' ('+       
      ISNULL(CONVERT(VARCHAR,FLOOR((CAST (GetDate() AS INTEGER) - CAST(CFC.DOB AS INTEGER)) / 365.25)),'')+')'      
      as ChildName,          
      CASE GCS.CodeNAme WHEN 'Yes' THEN 'Y' WHEN 'No' THEN 'N' END AS AreSibsSplit,          
      CPF.FamilyName,          
      GC.CodeName as Status,          
      CFP.PlacementStart,          
      CFP.PlacementEnd,          
      S.LastName+ ', '+S.FirstName AS FosterCareSpecialist,          
      PC.ProcedureCodeNAme AS DOCRateLevel    ,      
      CPF.PlacementFamilyID,      
      CFC.FosterReferralId,      
      CFC.FosterChildId,  
      CFC.ClientId      
       FROM                
       FosterPlacements CFP          
      JOIN   FosterReferralPlacementChildren CFRPC ON  CFRPC.FosterChildId = CFP.FosterChildId      
      JOIN   FosterChildren CFC      ON  CFC.FosterChildId = CFP.FosterChildId          
      JOIN   PlacementFamilies CPF     ON  CPF.PlacementFamilyID = CFP.PlacementFamilyId              
      LEFT  JOIN  FosterPlacementDOCLevels DOCL  ON  DOCL.FosterPlacementId = CFP.FosterPlacementId          
      LEFT  JOIN GlobalCodes GC       ON  GC.GlobalCodeId = CFP.STATUS   
                 AND GC.Category = 'XPLACEMENTSTATUS'        
      LEFT  JOIN GlobalCodes GCS       ON  GCS.GlobalCodeId = CFP.AreSibsSplit   
                 AND GCS.Category = 'XCanSibsBeSplit'         
      LEFT  JOIN Staff S         ON  S.StaffId = CFP.FosterCareSpecialist    
      INNER JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId AND sc.ClientId = CFC.ClientId ----- -- 27-07-2018 Bibhu  
      LEFT  JOIN  PlacementFamilyTypes AS CPFT         
                 ON  CPFT.placementfamilyid = CPF.placementfamilyid    
      --Need to clarify with David on Recodes , join will be modified based on the same  
      LEFT JOIN ProcedureCodes PC       ON  PC.ProcedureCodeId =  DOCL.DOCRateLevel                
       WHERE            
     (ISNULL(@Placement,'')='' OR CPF.familyname like '%'+@Placement+'%')AND          
     (ISNULL(@Child,'') = '' OR CFC.lastname LIKE '%' + @Child + '%'           
        OR CFC.firstname LIKE '%' + @Child + '%' )   
     AND ((@StartDate IS NULL OR  CFP.placementstart IS NULL OR CFP.placementstart >= @StartDate)            
     AND ( @EndDate IS NULL OR CFP.placementstart <= @EndDate ) )          
     AND (ISNULL(@OpenStatus, -1) = -1 OR CFP.status = @OpenStatus )     
     AND ( @PlacementType = -1  OR CPFT.familytype = @PlacementType )      
     AND ( @AllLevels = -1  OR DOCL.DOCRateLevel = @AllLevels )      
        
     AND ISNULL(CFP.RecordDeleted,'N') ='N'      
     AND ISNULL(CFC.RecordDeleted,'N') ='N'      
     AND ISNULL(CPF.RecordDeleted,'N') ='N'      
     AND ISNULL(DOCL.RecordDeleted,'N')='N'      
     AND ISNULL(GC.RecordDeleted,'N') ='N'      
     AND ISNULL(GCS.RecordDeleted,'N') ='N'      
     AND ISNULL(PC.RecordDeleted,'N') ='N'      
     
      ),                         
      Counts           
      AS (SELECT Count(*) AS totalrows           
               FROM   placementresult),           
               rankresultset           
               AS (SELECT           
               FosterPlacementId,          
               ChildName,          
               AreSibsSplit,          
               FamilyName,          
               Status,          
               PlacementStart,          
               PlacementEnd,          
               FosterCareSpecialist,          
               DOCRateLevel,         
               PlacementFamilyID,      
      FosterReferralId ,      
         FosterChildId,     
      ClientId,   
         Count(*)           
         OVER ()                  AS TotalCount,           
                          Rank()           
                            OVER (           
                            ORDER BY            
                            CASE WHEN @SortExpression = 'ChildName' THEN ChildName END,          
                            CASE WHEN @SortExpression = 'ChildName DESC' THEN ChildName END DESC,           
                            CASE WHEN @SortExpression = 'AreSibsSplit' THEN  AreSibsSplit END,           
                            CASE WHEN @SortExpression = 'AreSibsSplit DESC' THEN AreSibsSplit END DESC,           
                            CASE WHEN @SortExpression = 'FamilyName' THEN  FamilyName END,           
                            CASE WHEN @SortExpression = 'FamilyName DESC' THEN FamilyName END DESC,          
                            CASE WHEN @SortExpression = 'Status' THEN Status END,           
                            CASE WHEN @SortExpression = 'Status DESC' THEN Status END DESC,           
                            CASE WHEN @SortExpression = 'PlacementStart' THEN PlacementStart END,           
                            CASE WHEN @SortExpression = 'PlacementStart DESC' THEN PlacementStart END DESC,           
                            CASE WHEN @SortExpression = 'PlacementEnd ' THEN PlacementEnd END,           
                            CASE WHEN @SortExpression = 'PlacementEnd DESC' THEN PlacementEnd END DESC,           
                            CASE WHEN @SortExpression = 'FosterCareSpecialist ' THEN FosterCareSpecialist END,           
                            CASE WHEN @SortExpression = 'FosterCareSpecialist DESC' THEN FosterCareSpecialist END DESC,           
                            CASE WHEN @SortExpression = 'DOCRateLevel ' THEN DOCRateLevel END,           
                            CASE WHEN @SortExpression = 'DOCRateLevel DESC' THEN DOCRateLevel END DESC,           
                                  
                            FosterPlacementId) AS RowNumber           
                   FROM   placementresult)           
          SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows           
          ,           
          0)           
          FROM counts)           
          ELSE (@PageSize) END)           
    FosterPlacementId,          
    ChildName,          
                AreSibsSplit,          
                FamilyName,          
                Status,          
                PlacementStart,          
                PlacementEnd,          
                FosterCareSpecialist,          
                DOCRateLevel,          
                PlacementFamilyID,      
    FosterReferralId,       
    FosterChildId,    
    ClientId,    
                TotalCount,          
                rownumber           
          INTO   #finalresultset           
          FROM   rankresultset           
          WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize );           
          
          IF (SELECT Isnull(Count(*), 0)           
              FROM   #finalresultset) < 1           
            BEGIN           
                SELECT 0 AS PageNumber,           
                       0 AS NumberOfPages,           
                       0 AS NumberOfRows;           
            END           
          ELSE           
            BEGIN           
                SELECT TOP 1 @PageNumber           AS PageNumber,           
                             CASE ( totalcount % @PageSize )           
                               WHEN 0 THEN Isnull(( totalcount / @PageSize ), 0)           
                               ELSE Isnull((totalcount / @PageSize), 0) + 1           
                             END                   AS NumberOfPages,           
                             Isnull(totalcount, 0) AS NumberOfRows           
                FROM   #finalresultset;           
            END           
          
          SELECT           
    FosterPlacementId,          
    ChildName,          
                AreSibsSplit,          
                FamilyName,          
                Status,          
                CONVERT(VARCHAR,PlacementStart,101)PlacementStart,          
                CONVERT(VARCHAR, PlacementEnd,101)PlacementEnd,          
                FosterCareSpecialist,          
                DOCRateLevel    ,      
                PlacementFamilyID,      
    FosterReferralId,      
    FosterChildId,  
    ClientId      
          FROM         
    #finalresultset;           
      END try           
          
      BEGIN catch           
          DECLARE @Error AS VARCHAR (8000);           
          
          SET @Error = CONVERT (VARCHAR, Error_number()) + '*****'           
                       + CONVERT (VARCHAR (4000), Error_message())           
                       + '*****'           
                       + Isnull(CONVERT (VARCHAR, Error_procedure()),           
                       'ssp_ListPagePlacement')           
                       + '*****' + CONVERT (VARCHAR, Error_line())           
                       + '*****' + CONVERT (VARCHAR, Error_severity())           
                       + '*****' + CONVERT (VARCHAR, Error_state());           
          
    RAISERROR (@Error,16,1);           
      -- Message text.           Severity.           State.                     
      END catch           
  END 

GO
