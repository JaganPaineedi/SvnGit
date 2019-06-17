 /****** Object:  StoredProcedure [dbo].[ssp_PCGetClientProblem]    Script Date: 08/28/2012 17:58:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageImmunizationTransmissionLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageImmunizationTransmissionLog]
GO



/****** Object:  StoredProcedure [dbo].[ssp_ListPageImmunizationTransmissionLog]    Script Date: 08/28/2012 17:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
  
/********************************************************************************                                                    
-- Stored Procedure: ssp_ListPageImmunizationTransmissionLog  0,200,'ExportDateTime DESC',11126839,127685,-1
-- File      : ssp_ListPageImmunizationTransmissionLog.sql  
-- Copyright: Streamline Healthcate Solutions  
--  
--  
-- Date   Author    Purpose  
-- 07/June/2017  Varun   Created   

*********************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_ListPageImmunizationTransmissionLog]     
(  
 @PageNumber   INT,    
 @PageSize   INT,    
 @SortExpression  VARCHAR(100), 
 @ActionType  INT, 
 @ClientId INT, 
 @Other INT
)  
AS         
BEGIN                                                                  
 BEGIN TRY    
 
              
 ;WITH SCImmunizationLog
 AS   
 (   
  SELECT  
	 I.ImmunizationTransmissionLogId
    ,I.ClientId
	,I.VaccineName
	,GC.CodeName AS ActionType
	,I.ExportDateTime
	,I.AckResponse
	,I.AdministrationHL7Message
	,I.AckHL7Message
	,I.QueryHL7Message
	,I.ResponseHL7Message
	,CASE GC.CodeName WHEN 'Send' THEN (SELECT Token from dbo.SplitHL7Segment((SELECT SUBSTRING(AdministrationHL7Message, 0, CHARINDEX('PID', AdministrationHL7Message) - 1) FROM ImmunizationTransmissionLog where ImmunizationTransmissionLogId=I.ImmunizationTransmissionLogId),'|') WHERE Position=9) 
	 ELSE (SELECT Token from dbo.SplitHL7Segment((SELECT SUBSTRING(QueryHL7Message, 0, CHARINDEX('QPD', QueryHL7Message) - 1) FROM ImmunizationTransmissionLog where ImmunizationTransmissionLogId=I.ImmunizationTransmissionLogId),'|') WHERE Position=9)  END 
	 AS MessageControlId
	FROM ImmunizationTransmissionLog I
	INNER JOIN GlobalCodes GC on GC.GlobalCodeId=I.ActionType
	WHERE I.ClientId=@ClientId AND (I.ActionType=@ActionType OR @ActionType=-1) AND ISNULL(I.RecordDeleted, 'N') = 'N'
   ),  
      counts as (  
  select count(*) as totalrows from SCImmunizationLog  
      ),  
      RankResultSet  
      as  
      (  
  SELECT 
	ImmunizationTransmissionLogId
    ,ClientId
	,VaccineName
	,ActionType
	,ExportDateTime
	,AckResponse
	,AdministrationHL7Message
	,AckHL7Message
	,QueryHL7Message
	,ResponseHL7Message
	,MessageControlId
    ,COUNT(*) OVER ( ) AS TotalCount ,  
            ROW_NUMBER() OVER ( ORDER BY   
            CASE WHEN @SortExpression= 'ActionType'   THEN ActionType END,    
            CASE WHEN @SortExpression= 'ActionType DESC'   THEN ActionType END DESC, 
			CASE WHEN @SortExpression= 'ExportDateTime'   THEN ExportDateTime END,    
            CASE WHEN @SortExpression= 'ExportDateTime DESC'   THEN ExportDateTime END DESC     
  )    
   AS RowNumber  
   FROM     SCImmunizationLog    
        )  
        SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
		ImmunizationTransmissionLogId  
    ,ClientId
	,VaccineName
	,ActionType
	,ExportDateTime
	,AckResponse
	,AdministrationHL7Message
	,AckHL7Message
	,QueryHL7Message
	,ResponseHL7Message
	,MessageControlId
   ,TotalCount ,  
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
	ImmunizationTransmissionLogId
    ,ClientId
	,VaccineName
	,ActionType
	,ExportDateTime
	,AckResponse
	,AdministrationHL7Message
	,AckHL7Message
	,QueryHL7Message
	,ResponseHL7Message
	,MessageControlId
   ,TotalCount  
   RowNumber  
         FROM    #FinalResultSet  
         ORDER BY RowNumber  
		 
	SELECT c.ClientImmunizationId
			,GV.CodeName AS VaccineName
			,C.AdministeredDateTime
			,isnull(Str(C.AdministeredAmount, 10, 2), '') + ' ' + isnull(GAmount.CodeName, '') AS AdministeredAmount
			,C.LotNumber
			,GM.CodeName AS Manufacturer
			,C.ExportedDateTime 
			,GStatus.CodeName AS VaccineStatus
			,C.Comment
			,C.RecordDeleted
		FROM ClientImmunizations C
		LEFT JOIN GlobalCodes GV ON C.VaccineNameId = GV.GlobalCodeId
			AND ISNULL(GV.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GM ON C.ManufacturerId = GM.GlobalCodeId
			AND ISNULL(GM.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GAmount ON C.AdministedAmountType = GAmount.GlobalCodeId
			AND ISNULL(GAmount.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GStatus ON C.VaccineStatus = GStatus.GlobalCodeId
			AND ISNULL(GStatus.RecordDeleted, 'N') = 'N'
		WHERE C.ClientId = @ClientId
    
 END TRY    
     
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)           
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPageImmunizationTransmissionLog')                                                                                                 
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