/****** Object:  StoredProcedure [dbo].[csp_VocationalPlacedByList]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_VocationalPlacedByList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_VocationalPlacedByList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_VocationalPlacedByList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE procedure [dbo].[csp_VocationalPlacedByList]      

/*********************************************************************            
-- Stored Procedure: ssp_ListPagePMPrograms  
-- Copyright: Streamline Healthcare Solutions 
-- Creation Date:  06 Sept 2011                        
--                                                   
-- Purpose: returns Staff for the Job Placement list page.  
--                                                      
-- Modified Date    Modified By    Purpose  
-- 06 Sept 2011     Vaibhav        Added Last Name.
-- 13 Jan 2012      Veena S Mani   Added Last Name.
****************************************************************************/   
as      
    SELECT sf.StaffId,sf.LastName+'', ''+sf.FirstName as FirstName from Staff as sf  Inner join ViewStaffPermissions as vsp ON sf.StaffId=vsp.StaffId
    WHERE vsp.PermissionItemId=5721 order by  sf.LastName
' 
END
GO
