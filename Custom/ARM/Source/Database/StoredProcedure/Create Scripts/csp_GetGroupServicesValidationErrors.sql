/****** Object:  StoredProcedure [dbo].[csp_GetGroupServicesValidationErrors]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetGroupServicesValidationErrors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetGroupServicesValidationErrors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetGroupServicesValidationErrors]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
          
--csp_GetGroupServicesValidationErrors  1963,94                        
                        
CREATE PROCEDURE [dbo].[csp_GetGroupServicesValidationErrors]--9,92                          
    @GroupServiceid INT ,
    @StaffId INT
AS /******************************************************************************                                                              
**  File: csp_GetGroupServicesValidationErrors                                                          
**  Name: csp_GetGroupServicesValidationErrors                                      
**  Desc: For Validation  for GroupServices documents                                
**  Return values: Resultset having validation messages                                                              
**  Called by:                                                               
**  Parameters:                                          
**  Auth:  Umesh                                              
**  Date:  Jun 17 2010                                                          
*******************************************************************************                                                              
**  Change History                                                              
*******************************************************************************                                                              
**  Date:       Author:       Description:        
**	6/22/2012	Wasif Butt		Validation Stored Procedure logic updated                                                      
*******************************************************************************/                                                            
                              
    BEGIN                                                                            
                                  
        BEGIN TRY                               
                           
            DECLARE @DocumentsWithNoError TABLE
                (
                  DocumentId INT ,
                  ClientId INT ,
                  ClientName VARCHAR(100)
                )                          
                           
                            
            CREATE TABLE #validationGroupServices
                (
                  RowId INT IDENTITY(1, 1) ,
                  TableName VARCHAR(200) ,
                  ColumnName VARCHAR(200) ,
                  ErrorMessage VARCHAR(200) ,
                  PageIndex INT ,
                  ServiceId INT ,
                  DocumentId INT
                )                                 
                            
            DECLARE @MyTableVar TABLE
                (
                  RowId INT IDENTITY(1, 1) ,
                  DocumentId INT ,
                  DocumentVersionId INT ,
                  DocumentCodeId INT ,
                  ServiceId INT ,
                  ClientId INT ,
                  ClientName VARCHAR(100) ,                           
    --ProcedureCodeId INT,                            
                  ValidationProcedureName VARCHAR(200)
                ) ;                            
                            
            INSERT  INTO @MyTableVar
                    SELECT  D.DocumentId ,
                            D.CurrentDocumentVersionId ,
                            SCR.DocumentCodeId ,
                            S.ServiceId ,
                            S.ClientId ,
                            ( C.LastName + '', '' + C.FirstName ) AS ClientName ,
                            SCR.ValidationStoredProcedureComplete
                    FROM    Services S
                            INNER JOIN Documents D ON S.ServiceId = D.ServiceId
                            INNER JOIN Screens SCR ON D.DocumentCodeId = SCR.DocumentCodeId
                            INNER JOIN Clients C ON S.ClientId = C.ClientId
                    WHERE   D.GroupServiceId = @GroupServiceid
                            AND S.GroupServiceId = @GroupServiceid
                            AND ISNULL(S.RecordDeleted, ''N'') = ''N''
                            AND ISNULL(SCR.RecordDeleted, ''N'') = ''N''
                            AND ISNULL(D.RecordDeleted, ''N'') = ''N''
                            AND D.AuthorId = @StaffId
                            AND D.Status <> 22
                            AND S.Status = 71                  
                            
            CREATE TABLE #validationReturnTable
                (
                  TableName VARCHAR(200) ,
                  ColumnName VARCHAR(200) ,
                  ErrorMessage VARCHAR(MAX) ,
                  PageIndex INT ,
                  TabOrder INT ,
                  ValidationOrder INT ,
                  ServiceId INT
                )                                   
                               
                            
            DECLARE @Counter INT                             
            DECLARE @MaxCount INT                             
            DECLARE @ValidationProcedureName VARCHAR(200)                                           
            SET @Counter = 1                             
            SELECT  @MaxCount = MAX(RowId)
            FROM    @MyTableVar                            
                            
            IF ( @MaxCount <> 0 ) 
                BEGIN                            
                    DECLARE @DocumentVersionId INT                             
                    DECLARE @ClientId INT              
                    DECLARE @ClientName VARCHAR(100)                             
                    DECLARE @DocumentId INT         
                    DECLARE @ServiceId INT          
                    DECLARE @CustomTableRecordCount INT      
                    DECLARE @DocumentCodeId INT       
                    DECLARE @FirstCustomTableName VARCHAR(100)      
                     
                    WHILE ( @Counter <= @MaxCount ) 
                        BEGIN        
                            
                            SELECT  @DocumentVersionId = DocumentVersionId ,
                                    @ServiceId = ServiceId ,
                                    @ClientId = ClientId ,
                                    @DocumentCodeId = DocumentCodeId ,
                                    @ClientName = ClientName ,
                                    @DocumentId = DocumentId ,
                                    @ValidationProcedureName = ValidationProcedureName
                            FROM    @MyTableVar
                            WHERE   RowId = @Counter                             
           
                            IF @Counter = 1 
                                BEGIN      
   --Get The first Custom table according to documentCodeId      
                                    EXEC ssp_SCGetFirstCustomTableName @DocumentCodeId,
                                        @FirstCustomTableName OUT      
                                END      
            
      --Execute the Stored Procedure that calculate the count of Records in Custom Table      
                            EXEC ssp_SCGetCustomTableCount @DocumentVersionId,
                                @FirstCustomTableName,
                                @CustomTableRecordCount OUT      
             
                            IF @CustomTableRecordCount < 1 
                                BEGIN      
      --If the record count of custom table =0 , Do not sign Document and continue with others      
                                    SET @Counter = @Counter + 1       
                                    CONTINUE      
                                END       
                   
                            DELETE  FROM #validationReturnTable                         
                            IF @ValidationProcedureName IS NOT NULL
                                AND RTRIM(LTRIM(@ValidationProcedureName)) <> '''' 
                                BEGIN
                                    INSERT  INTO #validationReturnTable
            --Call the Validation Stored Procedure                            
                                            EXEC @ValidationProcedureName @DocumentVersionId                       		    
                                    EXEC scsp_SCValidateDocument @StaffId,
                                        @DocumentId, @ValidationProcedureName 
                                END                        
                            
                            UPDATE  #validationReturnTable
                            SET     ServiceId = @ServiceId                         
                              
                            SET @Counter = @Counter + 1                             
                              
                            IF ( ( SELECT   COUNT(TableName)
                                   FROM     #validationReturnTable
                                 ) = 0 ) 
                                BEGIN                          
                                    INSERT  INTO @DocumentsWithNoError
                                            ( DocumentId ,
                                              ClientId ,
                                              ClientName
                                            )
                                    VALUES  ( @DocumentId ,
                                              @ClientId ,
                                              @ClientName
                                            )                          
                                END                
                            
                            INSERT  INTO #validationGroupServices
                                    ( TableName ,
                                      ColumnName ,
                                      ErrorMessage ,                                                      
   --PageIndex ,                            
                                      ServiceId         
                                    )
                                    SELECT  TableName ,
                                            ColumnName ,
                                            ErrorMessage ,                            
  --PageIndex    ,                            
                                            ServiceId
                                    FROM    #validationReturnTable                            
                                
                        END                             
                             
                END                      
            SELECT  RowId ,
                    TableName ,
                    ColumnName ,
                    ErrorMessage ,
                    PageIndex ,
                    S.ClientId ,
                    #validationGroupServices.ServiceId ,
                    ( C.LastName + '' '' + C.FirstName ) AS ClientName ,
                    DocumentId
            FROM    #validationGroupServices
                    LEFT OUTER JOIN Services S ON #validationGroupServices.ServiceId = S.ServiceId
                    LEFT OUTER JOIN Clients C ON S.ClientId = C.ClientId         
--WHERE ISNULL(C.RecordDeleted,''N'')=''N''  AND  ISNULL(S.RecordDeleted,''N'')=''N''                      
                          
            SELECT  *
            FROM    @DocumentsWithNoError                 
                                   
        END TRY                                                                                                               
        BEGIN CATCH                                
            DECLARE @Error VARCHAR(8000)                                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         ''csp_GetGroupServicesValidationErrors'') + ''*****''
                + CONVERT(VARCHAR, ERROR_LINE()) + ''*****''
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****''
                + CONVERT(VARCHAR, ERROR_STATE())                                                         
            RAISERROR                                                                                                           
 (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 ) ;                                                                             
        END CATCH                                                      
    END 
' 
END
GO
