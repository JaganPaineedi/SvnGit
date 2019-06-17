if object_id('dbo.ssp_PAGetImport837SendersList') is not null
  drop procedure dbo.ssp_PAGetImport837SendersList
go

create procedure dbo.ssp_PAGetImport837SendersList 
@StaffId int
/******************************************************************************          
**  File:           
**  Name: ssp_PAGetImport837SendersList          
**  Desc: Procedure to get the list of senders to fill the senders dropdown on import837 list page.        
**          
**  This template can be customized:          
**                        
**  Return values:Table containing list of senders.  
**           
**  Called by: DataServices\Import837Files.cs  
**  Parameters:          
**  Input     Output          
**  @UserId  
**     
**  Auth:  Shruthi.S         
**  Date:  October 17,2014       
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:                 Author:        Description:          
    October 17,2014       Shruthi.S      Procedure to get the list of senders to fill the senders dropdown on import837 list page.
	12.15.2017            SFarber        Added logic for Import837SenderDropdownShowSenderId config key.
*******************************************************************************/
as
declare @Import837SenderDropdownShowSenderId char(1)
declare @All837Senders char(1) 

select  @Import837SenderDropdownShowSenderId = sck.Value
from    SystemConfigurationKeys sck
where   sck.[Key] = 'Import837SenderDropdownShowSenderId'
        and sck.Value in ('Y', 'N')

if @Import837SenderDropdownShowSenderId is null
  set @Import837SenderDropdownShowSenderId = 'N';

select top 1
        @All837Senders = s.All837Senders
from    Staff s
where   s.StaffId = @StaffId

  
select  s.Import837SenderId,
        s.SenderName + case when @Import837SenderDropdownShowSenderId = 'Y'
                                 and s.SenderId is not null then ' - ' + s.SenderId
                            else ''
                       end as SenderName
from    Import837Senders s
where   s.Active = 'Y'
        and (@All837Senders = 'Y'
             or exists ( select *
                         from   Staff837Senders ss
                         where  ss.StaffId = @StaffId
                                and ss.Import837SenderId = s.Import837SenderId
                                and isnull(ss.RecordDeleted, 'N') = 'N' ))
        and isnull(s.RecordDeleted, 'N') = 'N'
order by SenderName                                         
  
go
 