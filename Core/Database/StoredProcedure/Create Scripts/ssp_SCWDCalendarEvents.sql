
/****** Object:  StoredProcedure [dbo].[ssp_SCWDCalendarEvents]    Script Date: 04/18/2013 17:16:50 ******/
if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_SCWDCalendarEvents]')
                    and type in ( N'P', N'PC' ) ) 
    drop procedure [dbo].[ssp_SCWDCalendarEvents]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCWDCalendarEvents]    Script Date: 04/18/2013 17:16:50 ******/
set ANSI_NULLS on
GO

set QUOTED_IDENTIFIER on
GO


    
-- =============================================      
-- Author:  Kneale Alpers      
-- Create date: May 27, 2011      
-- Description: Pulls appointments for the wdcalendar      
-- Modified      
-- June 14, 2011 Kneale Alpers - Added staff list return      
-- Aug 23, 2011 Wasif Butt - Hide Service Title if staff doesn't have access to client records and make it read only      
-- Jul 12, 2012 JHB - Removed Canceled, Error and Deleted Services      
-- Aug 07, 2012 Davinderk -  Added the new column status into select list per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Aug 08, 2012 Davinderk - Displayed status with subject as per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Aug 17, 2012 Davinderk - Check to IsNull(al.Subject,'') as per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Aug 30, 2012 Davinderk - Added the new column ClientId,Comments into AppointmentList as per Task#-26 - Scheduling - Missing Client Name and Appointment Type on the Appointment - Primary Care - Summit Pointe      
-- Sep 14, 2012 Vishant Garg-Add condition 'PCAPPOINTMENTTYPE' TO GET THE COLORS FOR APPOINTMENT STATUS TYPE AS per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Sep 19, 2012 Vishant Garg-Add Clkient Label AS per Task#-7-Scheduling-Primary Care - Summit Pointe      
-- Sep 20 2012 Vishant Garg-Add Condition to get the thpe for appointmentstatus    
-- Oct. 10 2012 Wasif Butt - Specific Location added to appointments    
-- 16 Nov 2012 Added By Mamta Gupta - Ref Task 61 - Primary Care - Bugs/Features - To Remove Rescheduled and Error appointments from Calendar    
-- 30/Nov/2012 Mamta Gupta  Ref Task 61 - Primary Care - Bugs/Features - Isnull check added for a.Status    
-- 21/Jan/2013  SunilKh  Added by Sunil for task 2618 (Threshold bugs/Featurs)check for procedurecodes    
-- 29 jan 2013  SunilKh  Revert the changes made for task 2618, As not showing Primary Care appointments on calendar. Now NotonCalendar will be handle through code      
-- Sep 17, 2013	Wasif Butt	Updating 6 char color to 8 char by appending ff to it so appointmenttype color displays properly.
-- Jan 20, 2014 Wasif Butt	Adding Paging feature
-- APR-10-2014 dharvey  Added RecordDeleted check on Staff table to eliminate invalid staff 
-- Jul-07-2014 Gautam	Modify not to show cancelled appintments (Added 8042 (Cancelled) in status,
--									Ref. to task Primary Care - Summit Pointe: #187 Calendar - Cancelled Appointments
-- Venkatesh 21/07/2014 - Remove cancelled and error appointments and deleted group services w.Ref Task 151 in Customization Bugs
-- 06/08/2015 Wasif Butt - Stacking overbooked appointments based on ShowTimeAs globalcode category Free, Busy, Tenative, Other (4341,4342,4343,4344)
--						   May need to base this on GlobalCodes.Order if there are custom values with higher priority. For now only core sorting is sufficient
-- 10/08/2015 MD Hussain - Added Subject instead of hard coded word 'Exists' if client is inactive w.r.t Core Bugs #1928
-- Oct-27-2015  Anto -  Modified to display the appointments of only logged in staff when My calendar staffview dropdown is set to "Single Staff View" w.r.t New Directions - Support Go Live #101
-- Dec-22-2015  Hemant -Added Active check on Staff table to eliminate inactive staff 
--                      Project:St. Joe - Support #161	
-- Dec-22-2016  Himmat - Added Recorddeleted condition To Documents table Threshold Support#827	
-- March-03-2017 Himmat- We should hide client names only the appointment should still be visible core bug#2368		   
-- June-01-2017 Suhail - Split logic for query appointments by querying staffclient separately since for Phil Haven who has millions of staffclients records was causing peroformance problems.
-- July-19-07-2017 Lakshmi Spilit logic has been modified if the appointment doesn't have any associated clients. Harbor - Support #1420
-- Dec-12-2017     Lakshmi - Fixed the performance issue, used temp table(#StaffClients) instead of (dbo.StaffClients) under split logic. As per the task Philhaven-Support #283   
-- 15/12/2017    Bernardin   What:Condition added to check cancelled services. Why: It is displaying cancelled services in My Calendar.Pines-Support# 905
-- 10/08/2018    Rajeshwari  What: Added code to get correct client name from clients table instead of getting from Appointments.Subjects . Why: AHN-SupportGoLive# 134
-- 19/02/2019    Neelima  What: Added case statement to get the Client name based on the Type. If ClientType = 'O', need to pull the OrganizationName, else Client firstname and last name Why: 	Spring River-Support Go Live #405
-- =============================================      
create procedure [dbo].[ssp_SCWDCalendarEvents]
      @ViewType varchar(15)  
  , -- ('MULTISTAFF', 'SINGLESTAFF','SELECTED')                                                               
    @StartDate datetime  
  , @EndDate datetime  
  , @StaffList varchar(max)  
  , @LoggedInStaffId int  
  , @Page int  
  , @ResourcesPerPage int  
as   
    begin        
  
        declare @MagicNumberLow int  
          , @MagicNumberHigh int  
        set @MagicNumberLow = ( ( @Page - 1 ) * @ResourcesPerPage ) + 1    
        set @MagicNumberHigh = @MagicNumberLow + @ResourcesPerPage - 1  
  
        create table #StaffIds  
            (        
              StaffId int not null  
            , SortOrder int not null  
            )        
     
        create table #StaffIdsForPage  
   (          
              StaffId int not null  
            , SortOrder int not null  
            )  
  
        create table #AppointmentList  
            (  
              AppointmentId int  
            , StaffId int  
            , Subject varchar(250)  
            , StartTime datetime  
            , endtime datetime  
            , AppointmentType int  
            , AppointmentTypeCodeName varchar(250)  
            , AppointmentTypeDescription text  
            , AppointmentTypeColor varchar(10)  
            , Description text  
            , ShowTimeAs int  
            , ShowTimeAsCodeName varchar(250)  
            , ShowTimeAsDescription text  
            , ShowTimeAsColor varchar(10)  
            , LocationId int  
            , ServiceId int  
            , LocationCode varchar(30)  
            , LocationName varchar(100)  
            , RecurringAppointment char(1)  
            , RecurringAppointmentId int  
            , ReadOnly int  
            , DocumentId int  
            , GroupId int  
            , GroupServiceId int  
            , RecurringGroupServiceId int  
            , STATUS int  
            , SpecificLocation varchar(250)  
            , NotonCalendar char(1)  
            , Resource varchar(max) null  
            , DataFrom varchar(15) null  
            )          
        if @ViewType = 'MULTISTAFF'   
            begin         
                insert  into #StaffIdsForPage  
                        ( StaffId  
                        , SortOrder         
                        )  
                        select  a.staffid  
                              , row_number() over ( order by s.lastName, s.firstName, a.StaffId asc )  
                        from    dbo.MultiStaffViewStaff a  
                                join staff s on ( a.StaffId = s.StaffId )  
                        where   MultiStaffViewId in (  
                                select  ids  
                                from    dbo.SplitIntegerString(@StaffList, ',') )  
                                and isnull(a.RecordDeleted, 'N') <> 'Y'     
                                AND ISNULL(s.RecordDeleted,'N')='N'     
            end         
        else  
            if @ViewType = 'SELECTED'  
                or @ViewType = 'SINGLESTAFF'   
                begin         
                    insert  into #StaffIdsForPage  
                            ( StaffId  
                            , SortOrder                                        
                            )  
                            select  ids  
                                  , row_number() over ( order by s.lastName, s.firstName, a.ids asc )  
                            from    dbo.SplitIntegerString(@StaffList, ',') a  
                                    join staff s on ( a.ids = s.StaffId )        
                end         
            else   
                begin         
                    insert  into #StaffIdsForPage  
                            ( StaffId, SortOrder )  
                    values  ( -1, 1 )        
                end  
      
        insert  into #StaffIds  
                ( StaffId  
                , SortOrder   
                )  
                select  StaffId  
                      , SortOrder  
                from    #StaffIdsForPage  
                where   SortOrder between @MagicNumberLow  
                                  and     @MagicNumberHigh;        
  
		/* Get Clients for Staff in temp table since joining directly to services table was causing bad query plan and slow performance when StaffClients table is large */
    	SELECT ClientId 
		INTO #StaffClients
		FROM dbo.StaffClients sc
		WHERE sc.StaffId = @LoggedInStaffId;

		CREATE INDEX IX_TempStaffClients_CalendarEvents ON #StaffClients (ClientId);

		with    AppointmentList ( AppointmentId, StaffId, Subject, StartTime, endtime, AppointmentType, AppointmentTypeCodeName, AppointmentTypeDescription, AppointmentTypeColor, Description, ShowTimeAs, ShowTimeAsCodeName, ShowTimeAsDescription, 
        ShowTimeAsColor, LocationId, ServiceId, LocationCode, LocationName, RecurringAppointment, RecurringAppointmentId, ReadOnly, DocumentId, GroupId, GroupServiceId, RecurringGroupServiceId, Status, ClientId, Comments, SpecificLocation, NotonCalendar )  
                  as ( select   a.AppointmentId  
                              , a.staffid  
                              , a.Subject  
                              , a.StartTime  
                              , a.endtime  
                              , a.AppointmentType  
                              , isnull(c.CodeName, '') as AppointmentTypeCodeName  
                              , isnull(c.Description, '') as AppointmentTypeDescription  
                              , case when len(isnull(c.color, '')) = 6  
                                     then 'ff' + isnull(c.color, '')  
                                     else isnull(c.color, '')  
                                end as AppointmentTypeColor  
                              ,       
                                --ISNULL(c.color, '') AS AppointmentTypeColor ,        
                                a.Description  
                              , a.ShowTimeAs  
                              , isnull(b.CodeName, '') as ShowTimeAsCodeName  
                              , isnull(b.Description, '') as ShowTimeAsDescription  
                              , isnull(b.color, '') as ShowTimeAsColor  
                              , a.locationid  
                              , a.ServiceId  
                              , isnull(d.LocationCode, '') as LocationCode  
                              , isnull(d.LocationName, '') as LocationName  
                              , isnull(a.RecurringAppointment, 'N') as RecurringAppointment  
                              , isnull(a.RecurringAppointmentId, 0) as RecurringAppointmentId  
                              , case when isnull(serv.ServiceId, -1) = -1  
                                     then 0  
                                     else case when isnull(sc.ClientId, -1) <> -1  
                                               then 0  
                                               else 1  
                                          end  
                                end as READONLY  
                              , isnull(doc.DocumentId, 0)  
                              , isnull(gs.GroupId, 0) as GroupId  
                              , isnull(a.GroupServiceId, 0) as GroupServiceId  
                              , isnull(a.RecurringGroupServiceId, 0) as RecurringGroupServiceId  
                              , a.Status  
                              , a.ClientId  
                              , a.Description  
                              , a.SpecificLocation  
                              , isnull(p.Notoncalendar, 'N') as NotonCalendar  
                       from     #StaffIds s  
                                join appointments a on ( s.StaffId = a.StaffId )  
                                left join globalcodes b on ( a.ShowTimeAs = b.GlobalCodeId  
                                                             and b.Category = 'SHOWTIMEAS'  
                                                           )        
                                left join globalcodes c on ( a.AppointmentType = c.GlobalCodeId        
                                                            -- AND c.Category = 'APPOINTMENTTYPE'        
                                                             and ( c.Category = 'APPOINTMENTTYPE'  
                                                              or c.Category = 'PCAPPOINTMENTTYPE'  
                                                              )            
             --ADDED BY VISHANT GARG        
                                                                    
                                                            -----        
                                      
                                                           )  
                                left join dbo.Locations d on ( a.LocationId = d.LocationId )  
                                left join dbo.Services serv on ( a.ServiceId = serv.ServiceId  
                                                              and isnull(serv.RecordDeleted,  
                                                              'N') = 'N'  
                                                              and serv.status in (  
                                                              70, 71, 72, 75 )  
                                                              )  
                                left join dbo.Documents doc on ( serv.ServiceId = doc.ServiceId and isnull(doc.RecordDeleted,'N') = 'N' )  -- Added by Rakesh w.r.f to task 413 in SC web phase II bugs/Features            
								left join #StaffClients sc on serv.ClientId = sc.ClientId
                                --Added by Sunil for task 2618 (Threshold bugs/Featurs)      
                                left join dbo.procedurecodes p on p.Procedurecodeid = serv.procedurecodeid  
                                left join dbo.GroupServices gs on ( a.GroupServiceId = gs.GroupServiceId )  
                       where    ( EndTime >= @StartDate  
                                  or EndTime is null  
                                )        
                                and ( StartTime <= @EndDate )        
          -- Venkatesh 21/07/2014 - Remove cancelled and error appointments and deleted group services
                                and ( gs.GroupServiceId is null  
                                      or ( isnull(gs.RecordDeleted, 'N') = 'N'  
                                           and gs.status in ( 70, 71, 72, 75 )  
                                         )  
                                    )       
                                       
           --Added By Mamta Gupta - Ref Task 61 - Primary Care - Bugs/Features - To Remove Rescheduled and Error appointments from Calendar      
								-- Jul-07-2014 Gautam  (8042 Cancelled)
                                and isnull(a.Status, 0) not in ( 8042,8044, 8045 )  
                                and isnull(a.RecordDeleted, 'N') = 'N' 
                                -- Added by Bernardin on 15/12/2017
                                and (a.ServiceId is null or exists(Select 1 from Services S1 where S1.serviceId=a.ServiceId
                                and isnull(S1.status,0) in (70, 71, 72, 75 ))) 
                     )  
            insert  into #AppointmentList  
                    select  al.AppointmentId  
                          , al.StaffId  
                          -- Modified on 10/08/2015 by MD Hussain
                          , case when al.ReadOnly = 1 then isnull(al.Subject, '') --'Exists'  
                                 when isnull(al.GroupServiceId, 0) <> 0  
                                 then 'Group Service: '  
                                      + cast(g.GroupName as varchar(100))  
                                      + ' (#'  
                                      + cast(al.GroupServiceId as varchar(100))  
                                      + ')'  
                                 when isnull(al.RecurringGroupServiceId, 0) <> 0  
                                 then case when isnull(al.GroupServiceId, 0) = 0  
                                           then 'Group Service Exists'  
                                      end  
                                 else isnull(al.Subject, '')  
                            end as Subject  
                          , al.StartTime  
                          , al.endtime  
                          , al.AppointmentType  
                          , al.AppointmentTypeCodeName  
                          , al.AppointmentTypeDescription  
                          , al.AppointmentTypeColor  
                          , al.Description  
                          , al.ShowTimeAs  
                          , al.ShowTimeAsCodeName  
                          , al.ShowTimeAsDescription  
                          , al.ShowTimeAsColor  
                          , al.LocationId  
                          , al.ServiceId  
                          , al.LocationCode  
                          , al.LocationName  
                          , al.RecurringAppointment  
                          , al.RecurringAppointmentId  
                          , case when isnull(al.RecurringGroupServiceId, 0) <> 0  
                                 then case when isnull(al.GroupServiceId, 0) = 0  
                                           then 1  
                                      end  
                                 else al.ReadOnly  
                            end as ReadOnly  
                          , al.DocumentId  
                          , al.GroupId  
                          , al.GroupServiceId  
                          , al.RecurringGroupServiceId  
                          , al.STATUS  
                          , al.SpecificLocation  
                          , al.NotonCalendar  
                          , '' as Resource  
                          , '' as DataFrom  
                    from    AppointmentList al  
                            left join dbo.Groups g on al.GroupId = g.GroupId  
                    where   ( ( al.RecurringAppointment = 'Y'  
                                and al.RecurringAppointmentId > 0  
                              )  
                              or al.RecurringAppointment = 'N'  
                          )  
					OPTION (RECOMPILE);        
          
        insert  into #AppointmentList  
                select  AM.AppointmentMasterId as AppointmentId  
                      , AMS.StaffId  
                      , isnull(AM.Subject, '') as Subject  
                      , AM.StartTime as StartTime  
                      , AM.EndTime as endtime  
                      , AM.AppointmentType as AppointmentType  
                      , isnull(c.CodeName, '') as AppointmentTypeCodeName  
                      , isnull(c.Description, '') as AppointmentTypeDescription  
                      , isnull(c.color, '') as AppointmentTypeColor  
                      , AM.Description as Description  
                      , AM.ShowTimeAs as ShowTimeAs  
                      , isnull(b.CodeName, '') as ShowTimeAsCodeName  
                      , isnull(b.Description, '') as ShowTimeAsDescription  
                      , isnull(b.color, '') as ShowTimeAsColor  
                      , '' as LocationId  
                      , null as ServiceId  
                      , '' as LocationCode  
                      , '' as LocationName  
                      , 'N' as RecurringAppointment  
                      , 0 as RecurringAppointmentId  
                      , 0 as ReadOnly  
                      , '' as DocumentId  
                      , 0 as GroupId  
                      , 0 as GroupServiceId  
                      , 0 as RecurringGroupServiceId  
                      , null as STATUS  
                      , '' as SpecificLocation  
                      , 'N' as NotonCalendar  
                      , '' as Resource  
                      , 'ResourceEvents' as DataFrom  					  
					  from  #StaffIds ST 
						Join  AppointmentMasterStaff AMS  on ST.StaffId = AMS.staffid
						join AppointmentMaster AM on ( AMS.AppointmentMasterId = AM.AppointmentMasterId )						
                        left join globalcodes b on ( AM.ShowTimeAs = b.GlobalCodeId  
                                                     and b.Category = 'SHOWTIMEAS'  
                     )        
                        left join globalcodes c on ( AM.AppointmentType = c.GlobalCodeId  
                                                     and c.Category = 'APPOINTMENTTYPE'  
                                                   )  
                where   ( EndTime >= @StartDate  
                          or EndTime is null  
                        )  
                        and ( StartTime <= @EndDate )  
                        and ( AM.ServiceId is null )  
                        and isnull(AM.RecordDeleted, 'N') <> 'Y'  
                order by AM.StartTime  
                      , AM.EndTime  
                      , AM.AppointmentMasterId           
               OPTION (RECOMPILE);  
          
          
-- Update Resources where ServiceId is null               
        update  AP  
        set     AP.Resource = ltrim(ResourceWithService.DisplayAs)  
        from    #AppointmentList AP  
                left outer join ( select    AppointmentResourceList.AppointmentMasterId  
                                          , case when AppointmentResourceList.DisplayAs is not null  
                                                 then '('  
                                                      + AppointmentResourceList.DisplayAs  
                                                      + ')'  
                                                 else AppointmentResourceList.DisplayAs  
                                            end DisplayAs  
                                  from      ( select    AM.AppointmentMasterId  
                                                      , replace(replace(stuff(( select distinct  
                                                              ', '  
                                                              + RES.DisplayAs  
                                                              from  
                                             AppointmentMasterResources AMR  
                                                              inner join Resources RES on RES.ResourceId = AMR.ResourceId  
                                                              where  
                                                              AM.AppointmentMasterId = AMR.AppointmentMasterId  
                                                              and isnull(AMR.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                              and isnull(RES.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                              for  
                                                              xml  
                                                              path('')  
                                                              ), 1, 1, ''),  
                                                              '&lt;', '<'),  
                                                              '&gt;', '>') 'DisplayAs'  
                                              from      #AppointmentList RS  
                                                        inner join AppointmentMaster AM on RS.AppointmentId = AM.AppointmentMasterId  
        and RS.DataFrom='ResourceEvents'           
                                              where     isnull(AM.RecordDeleted,  
                                                              'N') <> 'Y'  
          ) AppointmentResourceList            
        ) ResourceWithService on (AP.AppointmentId=ResourceWithService.AppointmentMasterId            
                                                           and AP.DataFrom = 'ResourceEvents'  
                                                         )          
          
-- Update Resources where ServiceId is available               
        update  AP  
        set     AP.Resource = ltrim(ResourceWithService.DisplayAs)  
        from    #AppointmentList AP  
                left outer join ( select    AppointmentResourceList.ServiceId  
                                          , case when AppointmentResourceList.DisplayAs is not null  
                                                 then '('  
                                                      + AppointmentResourceList.DisplayAs  
                                                      + ')'  
                                                 else AppointmentResourceList.DisplayAs  
                                            end DisplayAs  
                                  from      ( select    AM.AppointmentMasterId  
                                                      , AM.ServiceId  
                                                      , replace(replace(stuff(( select distinct  
                                                              ', '  
                                                              + RES.DisplayAs  
                                                              from  
                                                              AppointmentMasterResources AMR  
                                                              inner join Resources RES on RES.ResourceId = AMR.ResourceId  
                                                              where  
                                                              AM.AppointmentMasterId = AMR.AppointmentMasterId  
                                                              and isnull(AMR.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                              and isnull(RES.RecordDeleted,  
                                                              'N') <> 'Y'  
                                                              for  
                                                              xml  
                         path('')  
                                                              ), 1, 1, ''),  
                                                              '&lt;', '<'),  
                                                              '&gt;', '>') 'DisplayAs'  
                                              from      #AppointmentList RS  
                                                        inner join AppointmentMaster AM on RS.ServiceId = AM.ServiceId  
                                              where     isnull(AM.RecordDeleted,  
                                                              'N') <> 'Y'  
          ) AppointmentResourceList            
                                ) ResourceWithService on AP.ServiceId = ResourceWithService.ServiceId  
        where   AP.DataFrom <> 'ResourceEvents'                                  
                 
        select  AppointmentId  
              , StaffId  
      --Date:-03-March-2017 Himmat
            ,case when ServiceId is not null and not exists (Select 1 from #StaffClients sc       
            join Services s on s.ClientId = sc.ClientId       
            where a.ServiceId= s.ServiceId) then (REPLACE (a.Subject,(substring (a.subject,0,CHARINDEX('-',a.Subject,CHARINDEX('-',a.Subject,LEN(a.subject))))),''))
            When  ServiceId is not null Then   ---Rajeshwari S
             ISNULL((REPLACE (a.subject,(substring(a.subject,8,(CHARINDEX('(',a.subject)-8))),
             (SELECT CASE WHEN ISNULL(C.ClientType, 'I') = 'I'
			  THEN ISNULL(C.LastName, '')+', '+ISNULL(C.FirstName, '')
			  ELSE ISNULL(C.OrganizationName, '')
			  END
              FROM clients C  
              WHERE exists(Select 1 from  services s where s.serviceid = a.serviceid 
                                         and S.ClientId = C.clientid )))),'')  
              else ISNULL(a.Subject,'') end as Subject   --Modified By Lakshmi on 19-07-2017
      --End Himmat Changes
              , StartTime  
              , endtime  
              , AppointmentType  
              , AppointmentTypeCodeName  
              , AppointmentTypeDescription  
              , AppointmentTypeColor  
              , Description  
              , ShowTimeAs  
              , ShowTimeAsCodeName  
              , ShowTimeAsDescription  
              , ShowTimeAsColor  
              , LocationId  
              , ServiceId  
              , LocationCode  
              , LocationName  
              , RecurringAppointment  
              , RecurringAppointmentId  
              , ReadOnly  
              , DocumentId  
              , GroupId  
              , GroupServiceId  
              , RecurringGroupServiceId  
              , STATUS  
              , SpecificLocation  
              , NotonCalendar  
              , Resource  
              , DataFrom  
        from    #AppointmentList a
		order by StartTime, ShowTimeAs      
          
          
        select  a.StaffId  
              , ltrim(rtrim(a.LastName)) + ', ' + ltrim(rtrim(a.FirstName)) as StaffName  
              , case when a.StaffId = @LoggedInStaffId then 1  
                     else 1  
                end as CanSchedule  
        from    #StaffIds s  
                join Staff a on ( s.StaffId = a.StaffId )
                --Start Hemant 12/22/2015 	St. Joe - Support #161 
                AND a.Active='Y' 
                --End 
     AND ISNULL(a.RecordDeleted,'N')='N'  
        order by s.SortOrder        
        
  end         
  go      
      
      
  