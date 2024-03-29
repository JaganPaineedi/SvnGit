/****** Object:  StoredProcedure [dbo].[ssp_DashboardSelAlertMessages]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DashboardSelAlertMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_DashboardSelAlertMessages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DashboardSelAlertMessages]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' create  Procedure [dbo].[ssp_DashboardSelAlertMessages]          
 @StaffId INT          
AS          
          
/******************************************************************************          
**  File: dbo.ssp_DashboardSelAlertMessages.prc          
**  Name: dbo.ssp_DashboardSelAlertMessages.prc          
**  Desc: This SP returns the Alerts and Messages for the specified staff          
**          
**  This template can be customized:          
**                        
**  Return values:          
**           
**  Called by:             
**                        
**  Parameters:          
**  Input       Output          
**     ----------       -----------          
**          
**  Auth: Yogesh          
**  Date:           
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:  Author:    Description:          
**  --------  --------    -------------------------------------------          
**  18/03/2008 Vindu Modified :: Purpose is not to show names of Inactive clients   
**  6 May 2011  Pradeep         Made changes to join Staff.StaffId=Messages.FromSystemStaffId to show messaages which comes from other DB           

/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
*******************************************************************************/          
          
--DECLARE @StaffId INT          
--SET @StaffId = 115          
          
SELECT          
  M.MessageId,M.FromStaffId,M.ToStaffId,M.ClientId,M.Unread          
 ,CONVERT(VARCHAR,M.DateReceived,101) AS Received          
 ,M.Subject,CONVERT(VARCHAR,M.Message) As Message,M.Reference          
 ,Case When FromSystemStaffId IS Not Null Then FromSystemStaffName Else S1.LastName + '', '' + S1.FirstName end  AS [From]                   
 ,S2.LastName + '', '' + S2.FirstName AS [To]   
 
-- Modified by   Revathi   20 Oct 2015       
 ,case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''') + '', '' + ISNULL(C.FirstName,'''')  else ISNULL(C.OrganizationName,'''') end AS Client ,''M'' as Type          
FROM          
 Messages M          
LEFT OUTER JOIN          
 Staff S1 ON S1.StaffId = M.FromStaffId          
LEFT OUTER JOIN          
 --Staff S2 ON  S2.StaffId = M.ToStaffId    
 Staff S2 ON  S2.StaffId = M.FromSystemStaffId              
LEFT JOIN          
 Clients C          
ON          
 C.ClientId = M.ClientId --and C.active=''Y''    
WHERE          
 M.ToStaffId = @StaffId        
AND          
 (M.RecordDeleted = ''N'' OR M.RecordDeleted IS NULL)           
AND          
 Unread = ''Y''          
UNION          
SELECT          
  A.AlertId          
 ,null AS FromStaffId          
 ,A.ToStaffId,A.ClientId,A.Unread          
 ,CONVERT(VARCHAR,A.DateReceived,101) AS Received          
 ,A.Subject,A.Message,A.Reference          
 ,''System'' AS [From]          
 ,S.LastName + '', '' + S.FirstName AS [To]  
-- Modified by   Revathi   20 Oct 2015          
 ,case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''') + '', '' + ISNULL(C.FirstName,'''')  else ISNULL(C.OrganizationName,'''') end  AS Client ,''A'' as Type          
FROM          
 Alerts A          
INNER JOIN          
 Staff S          
ON          
 S.StaffId = A.ToStaffId          
LEFT JOIN          
 Clients C          
ON          
 C.ClientId = A.ClientId --and C.active=''Y''     
WHERE          
 A.ToStaffId = @StaffId         
AND          
 (A.RecordDeleted = ''N'' OR A.RecordDeleted IS NULL)         
AND        
 (C.RecordDeleted = ''N'' OR C.RecordDeleted IS NULL)         
AND          
 Unread = ''Y''   ' 
END
GO
