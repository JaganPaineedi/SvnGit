IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCGetDocumentValidation') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCGetDocumentValidation;
END;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE ssp_SCGetDocumentValidation @DocumentValidationId INT
AS
/******************************************************************************
**		File: ssp_SCGetDocumentValidation.sql
**		Name: ssp_SCGetDocumentValidation
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    11/25/2016      jcarlson			    created
*******************************************************************************/
BEGIN
	BEGIN TRY
	declare @Manual char(1) = 'N';

	if not exists ( 
			  select *
			  from DocumentValidationConditions as a
			  where ISNULL(a.RecordDeleted,'N')='N'
			  and a.DocumentValidationId = @DocumentValidationId
			  )
	begin
	   set @Manual = 'Y'
	end


		SELECT 
		DocumentValidationId
		  ,Active
		  ,DocumentCodeId
		  ,DocumentType
		  ,TabName
		  ,TabOrder
		  ,TableName
		  ,ColumnName
		  ,ValidationLogic
		  ,ValidationDescription
		  ,ValidationOrder
		  ,ErrorMessage
		  ,CreatedBy
		  ,CreatedDate
		  ,ModifiedBy
		  ,ModifiedDate
		  ,RecordDeleted
		  ,DeletedBy
		  ,DeletedDate
		  ,SectionName 
		  ,@Manual as ManualValidation
		FROM dbo.DocumentValidations AS A
		WHERE A.DocumentValidationId = @DocumentValidationId;

		SELECT a.DocumentValidationConditionId, 
		a.CreatedBy, 
		a.CreatedDate, 
		a.ModifiedBy, 
		a.ModifiedDate, 
		a.RecordDeleted, 
		a.DeletedBy, 
		a.DeletedDate, 
		a.DocumentValidationId, 
		a.TableName, 
		a.ColumnName,
		a.RangeType, 
		a.StartRange, 
		a.EndRange, 
		a.ConditionType, 
		a.ConditionAction,
		gcct.CodeName as ConditionTypeName, 
		a.ValueConditionTypeCategory,
		a.ValueConditionValue, 
		a.ParentDocumentValidationConditionId, 
		i.DATA_TYPE as DataType, 
		i.IS_NULLABLE as IsNullable,
		i.CHARACTER_MAXIMUM_LENGTH as [MaxLength],
		i.DOMAIN_NAME as DomainName,
		i.ORDINAL_POSITION as [OrdinalPosition],
		a.ValueConditionTypeMapOn,
		case a.ConditionAction 
			 when 9524 then a.ColumnName + ' equals ' + a.ValueConditionValue
			 when 9525 then a.ColumnName + ' does not equal ' + a.ValueConditionValue
			 when 9526 then a.ColumnName + ' value must be in Recode Category ' + a.ValueConditionTypeCategory + case a.ValueConditionTypeMapOn when 1 then ' Character Code Id' else ' Interger Code Id'end + ' field'
			 when 9528 then a.ColumnName + ' value cannot be in Recode Category ' + a.ValueConditionTypeCategory + case a.ValueConditionTypeMapOn when 1 then ' Character Code Id' else ' Interger Code Id'end + ' field'
			 when 9527 then a.ColumnName + ' value must be ' + case a.RangeType when 9520 then ' between ' + cast(a.StartRange as varchar) + ' and ' + cast(a.EndRange as varchar)
																when 9521 then ' greater than ' + cast(a.StartRange as varchar)
																when 9522 then ' less than ' + cast(a.StartRange as varchar)
																end
			 when 9523 then a.ColumnName + ' is required'
		end as ConditionActionSummary
		FROM DocumentValidationConditions AS a
		JOIN sys.tables AS t ON a.[TableName] = t.[name]
		JOIN sys.columns AS c ON t.[object_id] = c.[object_id]
			AND a.[ColumnName] = c.name
	     join INFORMATION_SCHEMA.COLUMNS as i on i.COLUMN_NAME = c.[name] and i.TABLE_NAME = t.[name]
		left join GlobalCodes as gcct on gcct.GlobalCodeId = ConditionType
		WHERE A.DocumentValidationId = @DocumentValidationId 
		AND ISNULL(a.RecordDeleted, 'N') = 'N';
		
		declare @DocumentCodeId int;
		select @DocumentCodeId= dv.DocumentCodeId 
		from DocumentCodes as dc
		join DocumentValidations as dv on dc.DocumentCodeId = dv.DocumentCodeId
		where dv.DocumentValidationId	 = @DocumentValidationId

		exec ssp_SCGetDocumentValidationTables @DocumentCodeId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDocumentValidation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error,
				-- Message text.                                                                     
				16,
				-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH;
END;
GO

