/****** Object:  StoredProcedure [dbo].[ssp_SCGetSystemConfigurationKeysDetail1]    Script Date: 10/14/2016 10:59:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSystemConfigurationKeysDetail1]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSystemConfigurationKeysDetail1]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSystemConfigurationKeysDetail1]    Script Date: 10/14/2016 10:59:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ssp_SCGetSystemConfigurationKeysDetail1]
@SystemConfigurationKeyId INT
/************************************************************************************************                        
**  File:                                           
**  Name: ssp_SCGetSystemConfigurationKeysDetail1                                          
**  Desc: This Store Procedure Get The Records From Banner Table 
**
**  Parameters: 
**  Input  	@bannerId INT
**  Output     ----------       ----------- 
**  
**  Author:  Atul Pandey
**  Date:  April 17, 2012
*************************************************************************************************
**  Change History  
************************************************************************************************* 
**  Date:			Author:			Description: 
**  --------		--------		-------------------------------------------------------------
** 14 oct 2016        Vijeta         Modified SP to relate new table Moduels, ModuleScreens and ScreenConfigurationKeys with Configuration screens.
** 3/25/2017          Hemant         Included the missing columns Screens,Modules.Project#Thresholds - Support #904
*************************************************************************************************/
AS
BEGIN
  --BEGIN TRY
		--  SELECT 
		--    SystemConfigurationKeyId
		--	,CreatedBy
		--	,CreateDate 
		--	,ModifiedBy
		--	,ModifiedDate
		--	,RecordDeleted
		--	,DeletedDate
		--	,DeletedBy
		--	,[Key]
		--	--,case when Value IS NULL then 'NULL' ELSE Value end as value
		--	,Value
		--	,[Description]
		--	--,case when AcceptedValues is null then 'NULL' ELSE AcceptedValues end as AcceptedValues
		--	,AcceptedValues
		--	,ShowKeyForViewingAndEditing
		--	,Modules
		--	,Screens
		--	,Comments
		--	--,Display 
				
		--  FROM  SystemConfigurationKeys 
		--  WHERE SystemConfigurationKeyId=@SystemConfigurationKeyId and  isnull(RecordDeleted, 'N') = 'N'
  --END TRY

  
  BEGIN TRY
  
  
  Declare @Screenname varchar(1000)
  set @Screenname=STUFF(( SELECT DISTINCT ', ' + sc.ScreenName AS [text()] 
          ,' ('+CAST(sc.ScreenId as varchar(10))+')'          
          FROM  SystemConfigurationKeys s
		   LEFT JOIN screenconfigurationkeys sk on s.SystemConfigurationKeyId= sk.SystemConfigurationKeyId AND isnull(sk.RecordDeleted, 'N') = 'N'
		  LEFT JOIN Screens sc on sk.screenId= sc.ScreenId AND isnull(sc.RecordDeleted, 'N') = 'N' 
		    WHERE s.SystemConfigurationKeyId=@SystemConfigurationKeyId --259 
                        FOR XML PATH('')   
                        ), 1,1, '' )
                                       
  Declare @Modulename varchar(1000)
  set @Modulename=STUFF(( SELECT DISTINCT ', ' + m.ModuleName AS [text()]    
          FROM  SystemConfigurationKeys s
		  LEFT JOIN screenconfigurationkeys sk on s.SystemConfigurationKeyId= sk.SystemConfigurationKeyId AND isnull(sk.RecordDeleted, 'N') = 'N'
		  LEFT JOIN ModuleScreens ms on sk.screenId= ms.ScreenId AND isnull(ms.RecordDeleted, 'N') = 'N' 
		  LEFT Join Modules m ON ms.ModuleId=m.ModuleId AND isnull(m.RecordDeleted, 'N') = 'N'
		    WHERE s.SystemConfigurationKeyId=@SystemConfigurationKeyId ---259 
                        FOR XML PATH('')   
                        ), 1,1, '' )              

		  SELECT 
		   SystemConfigurationKeyId
			,CreatedBy
			,CreateDate 
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,[Key]
			,Value
			,[Description]
			,AcceptedValues
			,ShowKeyForViewingAndEditing
			,@Modulename AS ModuleNames
			,@Screenname AS ScreenNames
			,Comments
			,SourceTableName
			,AllowEdit
			,Modules
			,Screens 
				
		  FROM  SystemConfigurationKeys 
		  WHERE SystemConfigurationKeyId=@SystemConfigurationKeyId and  isnull(RecordDeleted, 'N') = 'N'
		  
		  
  END TRY
  
  BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetSystemConfigurationKeysDetail1')                                                                                     
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                      
    + '*****' + Convert(varchar,ERROR_STATE())                                  
  RAISERROR                                                                                     
  (                                                       
   @Error, -- Message text.                                                                                    
   16, -- Severity.                                                                                    
   1 -- State.                                                                                    
   );         
 END CATCH
END


GO


