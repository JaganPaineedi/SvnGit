IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCExportDocumentValidations') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCExportDocumentValidations;
END;
GO

CREATE PROCEDURE ssp_SCExportDocumentValidations @UserId INT, @UserCode VARCHAR(30), @DocumentCodeId INT
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCExportDocumentValidations
**		Desc: The purpose of this sp is to insert a new validation record into DynamicValidations field
			 when the user presses crtl+alt+v. This will create a new row with min init fields.
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 9/25/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**        9/25/2018          jcarlson             created
*******************************************************************************/
begin try
--select * from dbo.DocumentValidations
--select * From DocumentValidationConditions

declare @DocumentValidationInsert varchar(max) = 'set @DocumentValidationId = 0; insert into DocumentValidations(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Active,DocumentCodeId,DocumentType,TabName,TabOrder,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage,SectionName)';
declare @DocumentValidationConditionInsert varchar(max) = 'insert into DocumentValidationConditions(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentValidationId,TableName,ColumnName,ConditionType,ConditionAction,RangeType,StartRange,EndRange,ValueConditionTypeCategory,ValueConditionTypeMapOn,ValueConditionValue)';

declare @sqlHeader varchar(max) = ' UPDATE dv
   set Active = ''N''
   FROM DocumentValidations as dv
   where dv.DocumentCodeId = ' + cast(@DocumentCodeId as varchar(max)) + ' 
   ; declare @DocumentValidationId int;';

declare @sql varchar(max) = '';

select @sql = stuff((select ';' +CHAR(13)+CHAR(10) + @sql + @DocumentValidationInsert +
' SELECT ''' + @UserCode + ''', '''
 + convert(varchar(max),GETDATE(),101) + ''', '''
 + @UserCode + ''', '''
 + convert(varchar(max),GETDATE(),101) + ''', '''
 + a.Active + ''', '
 + convert(varchar(max),a.DocumentCodeId) + ', '
 + ISNULL(convert(varchar(max),a.DocumentType),'NULL') + ', '
 + case when a.TabName is null 
				    then 'NULL,'
				    else ''''  + ISNULL(cast(a.TabName as varchar),'') + ''','  
			end
 + ISNULL(convert(varchar(max),a.TabOrder),'NULL') + ', '''
 + ISNULL(a.TableName,'') + ''', '''
 + ISNULL(a.ColumnName,'') + ''', '''
 + ISNULL(replace(a.ValidationLogic,'''',''''''),'') + ''', '
  + case when a.ValidationDescription is null 
				    then 'NULL,'
				    else + '''' + ISNULL(replace(a.ValidationDescription,'''',''''''),'')   + ''', ' 
			end
 + ISNULL(convert(varchar(max),a.ValidationOrder),'NULL') + ', '''
 + ISNULL(replace(a.ErrorMessage,'''',''''''),'') + ''', '
 + ISNULL(a.SectionName,'NULL') + '; set @DocumentValidationId = SCOPE_IDENTITY() '
 + ISNULL(( select stuff((select  ' ; ' +CHAR(13)+CHAR(10) + @DocumentValidationConditionInsert + 
		  ' SELECT ''' + @UserCode + ''', '''
		   + convert(varchar(max),GETDATE(),101) + ''', '''
		   + @UserCode + ''', '''
		   + convert(varchar(max),GETDATE(),101) + ''', @DocumentValidationId, '''
		   + ISNULL(b.TableName,'') + ''', '''  
		   + ISNULL(b.ColumnName,'') + ''', '
		   + ISNULL(cast(b.ConditionType as varchar),'') + ', ' 
		   + ISNULL(cast(b.ConditionAction as varchar),'') 
		   + case when b.RangeType is null 
				    then ',NULL,'
				    else ', '  + ISNULL(cast(b.RangeType as varchar),'') + ','  
			end 
			+ case when b.StartRange is null 
				    then 'NULL,'
				    else ''''  + ISNULL(cast(b.StartRange as varchar),'') + ''','  
			end 
			+ case when b.EndRange is null then 'NULL,'
			  else '''' + ISNULL(cast(b.EndRange as varchar),'') + ''', '  
			end 
			+ case when b.ValueConditionTypeCategory is null then 'NULL,'
			  else ''''   + ISNULL(cast(b.ValueConditionTypeCategory as varchar),'') + ''', '  
			end 
			+ case when b.ValueConditionTypeMapOn is null then 'NULL,'
			  else '' + ISNULL(cast(b.ValueConditionTypeMapOn as varchar),'') + ', '  
			end
		   + case when b.ValueConditionValue is null then 'NULL'
			  else '''' + ISNULL(cast(b.ValueConditionValue as varchar),'') + ''''
			end
		  from DocumentValidationConditions as b
		  where isnull(b.RecordDeleted,'N')='N'
		  and a.DocumentValidationId = b.DocumentValidationId
		  FOR XML PATH(''),Type).value('.','nvarchar(max)'),1,1,'')),'')
from DocumentValidations as a
where ISNULL(a.RecordDeleted,'N') = 'N'
and a.DocumentCodeId = @DocumentCodeId
FOR XML PATH(''), TYPE).value('.','nvarchar(max)'),1,1,'')

select @sqlHeader + @sql as [Sql];

END TRY

BEGIN CATCH
    declare @Error varchaR(max);
	SELECT @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCExportDocumentValidations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

	RAISERROR ( @Error, 16,  1 );

	
END CATCH;