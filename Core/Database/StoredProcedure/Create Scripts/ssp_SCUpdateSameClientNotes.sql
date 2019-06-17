/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateSameClientNotes]    Script Date: 06/02/2015 16:46:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateSameClientNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateSameClientNotes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateSameClientNotes]    Script Date: 06/02/2015 16:46:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateSameClientNotes] 
	@UserCode VARCHAR(30)
	,@ServiceId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCUpdateSameClientNotes                            */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To update Same Client Notes                                     */
/* Input Parameters:@UserCode,@ServiceId                                    */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/*		 09-Jan-2019	Irfan			  What:Corrected the syntax in the DynamicSQL where the Update statement is written.
										  Why: It is throwing error when click on 'Update Client Notes' button under Note - Client Note -Note tab -Group Service Detail
												as per the task HighPlains - Environment Issues Tracking-#38 	*/
/*		 29-Jan-2019	Irfan			  What:Added logic to pull the Billing Diagnosis from one note to the other note under Client Notes tab in Group Service Detail screen.
										  Why: The Billing Diagnosis was not pulling from one note to the other when click on 'Update Client Notes' under Client Note in Goup Service Detail
												as per the task HighPlains - Environment Issues Tracking-#38 	*/												
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @GroupServiceId INT
		DECLARE @ClientId INT
		DECLARE @DocumentCodeId INT
		DECLARE @TableList VARCHAR(MAX)
		DECLARE @DocumentVersionIds VARCHAR(MAX)
		DECLARE @DocumentVersionId INT

		SELECT TOP 1 @GroupServiceId = GroupServiceId
			,@ClientId = ClientId
		FROM Services
		WHERE ServiceId = @ServiceId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		IF OBJECT_ID('tempdb..#DocumentVersionIds') IS NOT NULL
			DROP TABLE #DocumentVersionIds

		CREATE TABLE #DocumentVersionIds (DocumentCodeId INT,DocumentVersionId INT)
		
		INSERT INTO #DocumentVersionIds(DocumentCodeId,DocumentVersionId)
		SELECT D.DocumentCodeId,D.CurrentDocumentVersionId
		FROM Documents D JOIN Services S ON D.ServiceId = S.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.ClientId = @ClientId
			AND S.ServiceId <> @ServiceId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			
		SELECT TOP 1 @DocumentVersionId = D.CurrentDocumentVersionId
		FROM Documents D JOIN Services S ON D.ServiceId = S.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.ClientId = @ClientId
			AND S.ServiceId = @ServiceId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		
		SELECT TOP 1 @DocumentCodeId = DocumentCodeId
		FROM #DocumentVersionIds		
		
		SELECT @DocumentVersionIds = COALESCE(@DocumentVersionIds+',' ,'') + CAST(DocumentVersionId AS VARCHAR(25))
		FROM #DocumentVersionIds
		
		SELECT @TableList = TableList
		FROM DocumentCodes
		WHERE DocumentCodeId = @DocumentCodeId

		IF OBJECT_ID('tempdb..#ParentTableList') IS NOT NULL  
		DROP TABLE #ParentTableList  

		IF OBJECT_ID('tempdb..#ChildTableList') IS NOT NULL  
		DROP TABLE #ChildTableList  
		   
		   CREATE TABLE #ParentTableList
		  (
		  TableName VARCHAR(2000)
		  )  
		  INSERT INTO #ParentTableList
		  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS  
		  WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME IN (SELECT item FROM dbo.fnSplit(@TableList, ',') WHERE item LIKE 'Custom%')
		  AND ORDINAL_POSITION=1
		  AND Column_Name='DocumentVersionId'
		   
			 CREATE TABLE #ChildTableList
		  (
		  TableName VARCHAR(2000),
		  ColumnNames VARCHAR(MAX)
		  )  
		  INSERT INTO #ChildTableList(TableName)
		  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS  
		  WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME IN (SELECT item FROM dbo.fnSplit(@TableList, ',') WHERE item LIKE 'Custom%')
		  AND ORDINAL_POSITION<>1
		  AND Column_Name='DocumentVersionId'
		  
		  UPDATE #ChildTableList
		  SET ColumnNames= [dbo].[ssf_SCGetTableColumnNamesInCommaSeparated] (TableName)
		
	
  		DECLARE @DynamicSQL VARCHAR(MAX),
			  @DynamicSQL1 VARCHAR(MAX),
			  @DynamicSQL2 VARCHAR(MAX)
			
		SELECT @DynamicSQL = COALESCE(@DynamicSQL+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10) ,'') + 
		'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].['+TABLE_NAME+']'') AND type in (N''U'')) 
		BEGIN UPDATE '+ TABLE_NAME+' SET ['+ COLUMN_NAME +'] = (SELECT TOP 1 ['+COLUMN_NAME+'] FROM '+TABLE_NAME+ '
		WHERE DocumentVersionId = ' + CAST(@DocumentVersionId AS VARCHAR(25)) + '),ModifiedBy = '''+@UserCode+''',ModifiedDate = '''
		+CONVERT(VARCHAR, GETDATE(), 120)+''' WHERE DocumentVersionId IN (' + @DocumentVersionIds +') END'  
		FROM INFORMATION_SCHEMA.COLUMNS  
		WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME IN (SELECT item FROM dbo.fnSplit(@TableList, ',') WHERE item LIKE 'Custom%')  
		AND ORDINAL_POSITION <> 1  
		AND [COLUMN_NAME] NOT IN ('CreatedBy','CreatedDate','ModifiedBy','ModifiedDate','RecordDeleted','DeletedDate','DeletedBy')  
		AND TABLE_NAME IN (SELECT TableName FROM #ParentTableList)
	   
		SELECT  @DynamicSQL1 =COALESCE(@DynamicSQL1+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10) ,'') + 
		'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].['+TableName+']'') AND type in (N''U'')) 
		BEGIN UPDATE '+ TableName+' SET RecordDeleted = ''Y'',DeletedBy=''UpdateClientNotes'',DeletedDate= '''+CONVERT(VARCHAR, GETDATE(), 120)+''' WHERE DocumentVersionId IN (' + CAST(DocumentVersionId AS VARCHAR(250)) +') END'
		FROM #ChildTableList CROSS JOIN #DocumentVersionIds 
		
		SELECT  @DynamicSQL2 =COALESCE(@DynamicSQL2+ CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10) ,'') + 
		'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].['+TableName+']'') AND type in (N''U'')) 		
		BEGIN INSERT INTO '+ TableName+'('+ ColumnNames +') SELECT '+ REPLACE(REPLACE(REPLACE(ColumnNames,',[DocumentVersionId],',','+ CAST(DocumentVersionId AS VARCHAR(250)) +','),'[CreatedBy],','''UpdateClientNotes'','),',[ModifiedBy],',',''UpdateClientNotes'',') +' FROM '+ TableName +' 
		WHERE DocumentVersionId IN (' + CAST(@DocumentVersionId AS VARCHAR(250)) +') END'
		FROM #ChildTableList CROSS JOIN #DocumentVersionIds 	

		EXEC (@DynamicSQL)	
		EXEC (@DynamicSQL1)
		EXEC (@DynamicSQL2)
				
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateSameClientNotes')
		 + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' 
		 + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                          
				16
				,-- Severity.                                                                                  
				1 -- State.                                                                                                          
				);
	END CATCH
END

GO


