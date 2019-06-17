/****** Object:  Trigger [TriggerInsert_SystemEvents]    ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerInsert_SystemEvents]'))
DROP TRIGGER [dbo].[TriggerInsert_SystemEvents]
GO

/****** Object:  Trigger [dbo].[TriggerInsert_SystemEvents]    Script Date: 07/07/2016 18:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TriggerInsert_SystemEvents] ON [dbo].[SystemEvents]
  FOR INSERT
/*********************************************************************  
-- Trigger: TriggerInsert_SystemEvents  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Updates:   
--  Date         Author       Purpose  
--  07.11.2018   Ravi         Created For Task #590 Engineering Improvement Initiatives- NBL(I)
**********************************************************************/    
AS
Begin
Begin Try


DECLARE @SystemEventId INT
DECLARE @EventKeyId INT
		DECLARE @SystemEventConfigurationId INT
		DECLARE @StoredProcedureName VARCHAR(250)
		

SELECT 
@SystemEventId=i.SystemEventId
,@SystemEventConfigurationId=i.SystemEventConfigurationId
FROM INSERTED i
WHERE i.EventStatus IS NULL

SELECT	@EventKeyId=SE.EventKeyId
		,@StoredProcedureName=SEC.EventHandlerAgent
		FROM SystemEvents SE
		JOIN SystemEventConfigurations SEC ON SEC.SystemEventConfigurationId = SE.SystemEventConfigurationId
		WHERE SE.SystemEventId=@SystemEventId
		AND SEC.SystemEventConfigurationId=@SystemEventConfigurationId

IF @StoredProcedureName IS NOT NULL AND ISNULL(@EventKeyId,0)<>0
BEGIN
		EXEC @StoredProcedureName @EventKeyId
END


 
END TRY                                                                                                 
BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'TriggerInsert_SystemEvents')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                                
END CATCH          
END

GO
