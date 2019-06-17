--Created On  :27 April 2015  
--Create By    :Malathi Shiva  
--Purpose  :New Directions - Customizations: Task# 6 Assessment Document - To modify "Add Disposition" to "Add facility" in Drop Downs

DELETE FROM ApplicationMessages 
WHERE  PrimaryScreenId = 10018 

DECLARE @ApplicationMessageId INT 

DELETE ApplicationMessages 
WHERE  MessageCode = 'SELECTFACILITY' 

INSERT INTO ApplicationMessages 
            (CreatedBy 
             ,CreatedDate 
             ,PrimaryScreenId 
             ,MessageCode 
             ,OriginalText 
             ,[Override] 
             ,OverrideText) 
VALUES      ('streamline-dbo' 
             ,Getdate() 
             ,10018 
             ,'SELECTFACILITY' 
             ,'Select Disposition' 
             ,'Y' 
             ,'Select Facility' ) 

SET @ApplicationMessageId = (SELECT TOP 1 ApplicationMessageId 
                             FROM   ApplicationMessages 
                             WHERE  MessageCode = 'SELECTFACILITY') 

INSERT INTO ApplicationMessageScreens 
            (CreatedBy 
             ,CreatedDate 
             ,ApplicationMessageId 
             ,ScreenId) 
VALUES     ('streamline-dbo' 
            ,Getdate() 
            ,@ApplicationMessageId 
            ,10018) 