
/****** Object:  UserDefinedFunction [dbo].[ssf_GetIsToolTipRequired]    Script Date: 14.02.2018 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetIsToolTipRequired]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetIsToolTipRequired]
GO
/****** Object:  UserDefinedFunction [dbo].[ssf_GetIsToolTipRequired]    Script Date: 14.02.2018  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[ssf_GetIsToolTipRequired] (@Name varchar(200),@StaffId INT)  --'dob',13324      
RETURNS varchar(1) 
/********************************************************************************                              
-- Function: dbo.[ssf_GetIsToolTipRequired]                                
--                              
-- Copyright: Streamline Healthcate Solutions                              
--                              
-- Purpose: Get the Tool tip status to show the Tooltip item in the Client information                         
--                              
-- Updates:                                                                                     
-- Date        Author		Purpose                              
-- 14.02.2018  RK          	What: Client Hover: Enhancements being requested
							Why: MHP-Customizations - Task 121       
*********************************************************************************/   
BEGIN
Declare @isRequired char(1)  

declare @PermissionItems table (        
PermissionItemId int,
RecordDeleted Char(1))
        
-- Get all Role based permission items        
insert into @PermissionItems (        
       PermissionItemId,
       RecordDeleted        
       )

SELECT  PIT.PermissionItemId, ISNULL(PIT.RecordDeleted, 'Y')    
FROM PermissionTemplateItems PIT    
	INNER JOIN PermissionTemplates PT ON PIT.PermissionTemplateId =PT.PermissionTemplateId    
	INNER JOIN ClientInformationToolTipItems CIT ON CIT.ClientInformationToolTipItemId= PIT.PermissionItemId      
WHERE PT.PermissionTemplateType =5930 AND isnull(PIT.RecordDeleted, 'N') = 'N' AND isnull(PT.RecordDeleted, 'N') = 'N'   AND CIT.[Name] =@Name  
	AND PT.RoleId IN (      select distinct SR.RoleId from StaffRoles SR  
	inner join GlobalCodes GC on GC.GlobalCodeId =SR.RoleId  where StaffId=@StaffId  AND isnull(SR.RecordDeleted, 'N') = 'N' )  --13324 ADMIN-- 13463 DEEJI

-- Get all Staff based permission items 	
insert into @PermissionItems (        
       PermissionItemId,
       RecordDeleted        
       )
	
SELECT  SPE.PermissionItemId, ISNULL(SPE.RecordDeleted, 'Y')    
FROM StaffPermissionExceptions SPE     
	INNER JOIN ClientInformationToolTipItems CIT ON CIT.ClientInformationToolTipItemId= SPE.PermissionItemId      
WHERE SPE.Allow = 'Y' AND SPE.PermissionTemplateType =5930 AND isnull(SPE.RecordDeleted, 'N') = 'N' AND isnull(CIT.RecordDeleted, 'N') = 'N' 
	AND CIT.[Name] =@Name  AND StaffId=@StaffId 	

--Delete the permission items which are not allowed for the staff	
 DELETE
 FROM @PermissionItems
 WHERE PermissionItemId IN (
    SELECT PermissionItemId 
    FROM StaffPermissionExceptions SPE 
    WHERE SPE.PermissionTemplateType = 5930 
     AND SPE.StaffId = @StaffId
     AND SPE.Allow = 'N'
     AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
    )
	
 select @isRequired = RecordDeleted from @PermissionItems

Return @isRequired 
END
