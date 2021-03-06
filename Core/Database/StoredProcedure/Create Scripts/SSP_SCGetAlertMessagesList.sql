/****** Object:  StoredProcedure [dbo].[SSP_SCGetAlertMessagesList]    Script Date: 11/18/2011 16:25:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetAlertMessagesList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetAlertMessagesList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetAlertMessagesList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SSP_SCGetAlertMessagesList]     
(    
@StaffRowIdentifier varchar(150)    
)    
AS    
/*********************************************************************/      
/* Stored Procedure: ssp_GetAlertMessagesList           */      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */      
/* Creation Date:    8/1/05                                         */      
/*                                                                   */      
/* Purpose:  It is used to return the messages  or Alerts list which we show on the dashboard for the loged user          */     
/*                                                                   */    
/* Input Parameters: @varStaffId                 */    
/*                                                                   */      
/* Output Parameters:   None                               */      
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
/*  Date     Author       Purpose                                    */      
/* 8/1/05   Vikas     Created               
	01 march 2008 Pramod returning lastname frist name as single field											                     */      
/* ********************************************************************/       
    
    
    
    
BEGIN    
--get the data from messages    
  
Declare @varStaffId as int        
set @varStaffId=(SELECT StaffId FROM  Staff where RowIdentifier=@StaffRowIdentifier)       
  
   

select  
--Change By Pramod Prakash On 01 March 2008 
 -- rtrim(c.LastName) as FromLastName,rtrim(c.FirstName) as FromFirstName ,
--now returning last name and fisrt as single field
substring(rtrim(c.LastName) + '', '' + rtrim(c.FirstName),0,15)as FromName ,
 convert(datetime, convert(varchar(18),    
 a.dateReceived,101)) as Received ,    
a.Subject,rtrim(b.LastName)+'', '' +  rtrim(b.FirstName)  as Client ,a.Message,a.MessageId from Messages a    
Left outer join Clients b on b.Clientid= a.Clientid  and IsNull(b.RecordDeleted,''N'')<>''Y''  
Left outer join Staff c  on a.FromStaffId=c.StaffId  and IsNull(c.RecordDeleted,''N'')<>''Y''  
where  a.unread=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y''  and a.ToStaffId= @varStaffId     
--where a.MessageId in (select Top 2 MessageId from Messages Order by messageid desc)  )    
    
union  all  
-- get the Data from Alerts    
select 
--Change By Pramod on 1 march 2008 now first name and last name 
--now returning last name and fisrt as single field
-- ''System'' as FromLastName,'''' as FromFirstName ,
''System'' as FromName,
 convert(datetime, convert(varchar(18), a.dateReceived,101)) as Received ,
a.Subject,rtrim(b.LastName)+'', '' +  rtrim(b.FirstName)  as Client  ,a.Message,a.AlertId  as MessageId    
  from alerts a
	left join Clients b on a.ClientId = b.ClientId and IsNull(b.RecordDeleted,''N'')<>''Y''
	where  a.ToStaffId = @varStaffId and a.unread=''Y''    
 and isNull(a.RecordDeleted,''N'')<>''Y''     order by 2 desc
   
--order by received desc    
--commented by Sukhbir Singh 09/05/2006 now sorting is being handled at front-end  
    
 IF (@@error!=0)    
    BEGIN    
        RAISERROR  20002 ''ssp_GetAlertMessagesList: An Error Occured''    
        RETURN(1)    
        
    END    
    
    RETURN(0)    
    
END
' 
END
GO
