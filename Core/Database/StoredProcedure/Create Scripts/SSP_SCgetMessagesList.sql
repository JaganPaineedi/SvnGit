/****** Object:  StoredProcedure [dbo].[SSP_SCgetMessagesList]    Script Date: 11/18/2011 16:25:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCgetMessagesList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCgetMessagesList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCgetMessagesList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[SSP_SCgetMessagesList]  
@StaffRowIdentifier varchar(50)
AS  
/*********************************************************************/    
/* Stored Procedure: dbo.SSP_getMessagesList                */    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */    
/* Creation Date:    7/24/05                                         */    
/*                                                                   */    
/* Purpose:  Get the list of The message for the specific clients*/  
/*                                                                   */  
/* Input Parameters: @varStaffId             */  
/*                                                                   */    
/* Output Parameters:   None                   */    
/*                                                                   */    
/* Return:  0=success, otherwise an error number                     */    
/*                                                                   */    
/* Called By:                                                        */    
/*                                                                   */    
/* Calls:                                                            */    
/*                                                                   */    
/* Data Modifications:                                               */    
/*                                                                   */    
/* Updates:                                                          */    
/*   Date				Author			Purpose                                    */    
/*  7/24/05				Vikas			Created                                    */   
/*	20 Oct 2015			Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */
/*										why:task #609, Network180 Customization  */    
/*********************************************************************/   
/* Updated as	Task # 1806 SmartCare EHR - Support				*/
BEGIN  
    
Declare @varStaffId as int
set @varStaffId=(Select StaffId from Staff where RowIdentifier=@StaffRowIdentifier)
  
 select a.*, case when a.Unread=''Y'' then ''Not Read''  when a.Unread=''N'' then ''Read'' end as codename  ,
rtrim(c.LastName) + '', '' + rtrim(c.FirstName) as FromName,rtrim(d.LastName)+ '', ''+ rtrim(d.FirstName) as ToName, 
-- Modified by  Revathi 20 Oct 2015 
 case when  ISNULL(e.ClientType,''I'')=''I'' then rtrim(ISNULL(e.LastName,''''))+ '', '' +rtrim(ISNULL(e.FirstName,'''')) else ISNULL(e.OrganizationName,'''') end  as ClientName, 
 f.CodeName as PriorityCodeName  
from Messages a  
-- join GlobalCodes b on a.Status = b.GlobalCodeId  
 join Staff c on a.FromStaffId = c.StaffId and IsNull(c.RecordDeleted,''N'')= ''N''  
 join Staff d on a.ToStaffId = d.StaffId and IsNull(d.RecordDeleted,''N'')=''N''   
 LEft join Clients e on a.ClientId = e.ClientId and IsNull(e.RecordDeleted,''N'')= ''N'' 
 left join GlobalCodes f on a.Priority = f.GlobalCodeId 
 where a.ToStaffId=@varStaffId and IsNull(a.RecordDeleted,''N'') <> ''Y''  -- and e.Active=''Y''     
 order by a.DateReceived Desc  
   
select a.* from Messages as a
where a.ToStaffId=@varStaffId and IsNull(a.RecordDeleted,''N'') <> ''Y''
  
    IF (@@error!=0)  
    BEGIN  
        RAISERROR  20002 ''SSP_getMessagesList: An Error Occured''  
        
        RETURN(1)  
      
    END  
  
  
    RETURN(0)  
END
' 
END
GO
