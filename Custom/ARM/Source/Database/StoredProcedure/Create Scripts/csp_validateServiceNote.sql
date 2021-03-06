/****** Object:  StoredProcedure [dbo].[csp_validateServiceNote]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateServiceNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateServiceNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[csp_validateServiceNote]   
(    
 @CurrentUserId Int,          
@ScreenKeyId Int     
)    
as    
    
--This is a temporary  Procedure we will modify this as needed            
/******************************************************************************                                    
*******************************************************************************                                    
**  Change History                                    
*******************************************************************************                                    
**  Date:       Author:       Description:                                    
**  31/05/2012  Sanjayb       Task#134 Another validation to please check - 
**                            on the Service note if the custom field "Other options for Treatment Plan 
**                            Objectives Addressed by This Service" is checked then the validation 
**                            "Service-Goal must be specified" should be met. The user must either 
**                            select at least 1 goal + 1 objective or choose one option form this custom drop down. 
**  --------    --------        ----------------------------------------------------   
*******************************************************************************/        
    
   
--*TABLE CREATE*--     
CREATE TABLE #ValidationErrors   
(    
TableName varchar(200),          
ColumnName varchar(200),          
ErrorMessage varchar(1000) 
)    
    
IF EXISTS(select ''1'' from CustomFieldsData WHERE PrimaryKey1=@ScreenKeyId AND ColumnGlobalCode5=10635)
BEGIN
	IF NOT EXISTS(select ''1'' from ServiceGoals  WHERE ServiceId=@ScreenKeyId AND ISNULL(RecordDeleted,''N'')=''N'')
	BEGIN
		Insert into #ValidationErrors   
		(	TableName,    
			ColumnName,    
			ErrorMessage    
		)  
		SELECT ''Service Note'', ''ServiceGoals'',''Service - select at least 1 goal or choose one options for Treatment Plan Objectives Addressed by This Service''
	END
	IF NOT EXISTS(select ''1'' from ServiceObjectives WHERE ServiceId=@ScreenKeyId AND ISNULL(RecordDeleted,''N'')=''N'')
	BEGIN
		Insert into #ValidationErrors   
		(	TableName,    
			ColumnName,    
			ErrorMessage    
		)  
		SELECT ''Service Note'', ''ServiceObjectives'',''Service - select at least 1 objective or choose one options for Treatment Plan Objectives Addressed by This Service''
	END

END


Select TableName, ColumnName, ErrorMessage       
from #ValidationErrors    
    
IF Exists (Select * From #ValidationErrors)    
Begin     
  select 1  as ValidationStatus 
End    
Else    
Begin    
  select 0  as ValidationStatus 
End    
    
if @@error <> 0 goto error    
    
return    
    
error:    
raiserror 50000 ''csp_validateServiceNote failed.  Contact your system administrator.''     
  

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


' 
END
GO
