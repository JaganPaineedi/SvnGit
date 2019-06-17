if object_id('dbo.ssp_SCClientSearch') is not null 
  drop procedure dbo.ssp_SCClientSearch
go
               
create procedure dbo.ssp_SCClientSearch
  @StaffId int,
  @ClientId int,
  @LastName varchar(30),
  @FirstName varchar(30),
  @SSN varchar(15),
  @Phone varchar(15),
  @DOB datetime,
  @PrimaryClinicianId int,
  @SearchType varchar(20),-- ('CLIENTID', 'BROAD', 'NARROW', 'SSN', 'PHONE', 'DOB', 'CAREMANAGEMENTID', 'PRIMARYCLINICIAN')                                                    
  @CreatedDate datetime,
  @CreatedBy varchar(30),
  @Paging char(1),
  @MasterClientId int,
  @IncludeClientContacts char(1) = 'N',
  @ProgramId int,
  @InsuredId varchar(25),
  @ClientStatus char(1),
  @ProviderId int  ,
  @ClientType char(1),
  @OrganizationName varchar(30),    
  @AuthorizationID varchar(200),
  @EIN varchar(15)     
 /********************************************************************************                                                                                                                    
-- Stored Procedure: dbo.ssp_SCClientSearch                                                                                                                      
--                                                                                                                    
-- Copyright: Streamline Healthcate Solutions                                                                                                                    
--                                                                                                                    
-- Purpose: performs clinet search                    
--                                                                                                                    
-- Updates:                                                                                                                                                                           
-- Date            Author          Purpose                                                                                                                
-- 23.12.2009      Ankesh          Created.                    
-- 07.28.2010      SFarber         Added StaffClients.                  
-- 06.27.2011      SFarber         Modified to include client contacts.                  
-- 06.28.2011      SFarber         Added searches on soundex.                  
-- 09.26.2011      Priyanka Gupta  Modified SSN field replace with "last 4 digit of SSN field" refrence task number 182                  
-- 03.01.2012      Shifali         Modified in reference to Removed soundex logic from "Narrow" search(SHS change - Ryan).                   
-- 29.03.2012      Vikas Kashyap   Modified Add New Parameter ProgramId And InsuredId & ClientStatus For Client Search                  
-- 01.06.2012      Rakesh-II       Replace (") from  firstName & lastName(was breaking the stringon page) ,Task 9 in Phase III Development                   
-- 11.16.2012      vishant garg    ADD TRY CATCH BLOCK WITH REF TASK# 68 IN PRIMARY CARE BUGS/FEATURES.                  
-- 11.28.2012      Raghum          Why-Fetched ssn number column as to show complete ssn number in tooltip.,What- as per task 5-ssnIssue in development phaseIV(offshore)                   
-- 12.11.2012      Manjit Singh    Fix the time-out issue by replacing "inner join to EXISTS" in the last query when searching was performed without paging i.e when @Paging='N'                  
-- 03.05.2013      Varinderv       Added column FormattedFullSSN for formating the SSN Ref. the task #206 3.5x Issues.                    
-- 09.27.2013      John Sudhakar   Changed @InsuredId datatype to INT.                  
-- 08.29.2014      SFarber         Added call to ssp_RefreshStaffClients                        
-- 09.24.2014      Malathi Shiva   Added logic for Provider Search criteria: with ref to Task# 88.1: Care Management to SmartCare                   
-- 09.Oct.2014     SuryaBalan      Added Provider Name to bind in result for task #88.201 Care Management to SmartCare Env. Issues Tracking                   
-- 27.Oct.2014     SuryaBalan      Fixed ProviderName Duplicates Issue for Care Management to SmartCare Env. Issues Tracking              
-- 29.Oct.2014     SuryaBalan      Task #67 Fixed ProviderName Duplicates Issue for Care Management to SmartCare Env. Issues Tracking                   
-- 08.Dec.2014     N Kiran Kumar   Task #187 fixed the issue of MasterID comming blank    
-- 12.26.2014      SFarber         Made changes to Provider ID and Master Client ID search options
-- 09.16.2015      SFarber         Added logic to check for @IsMasterDatabase
-- 10.19.2015      Vichee          Modified the ssp to add logic for Organization in ClientSearchPopUp Network- 180 Customizations - #609
-- 10.29.2015      Vichee          Modified the ssp to add logic to search AuthorizationID both CM and SC in ClientSearchPopUp Network- 180 Customizations - #609
-- 11.04.2015      Vichee          Modified the ssp to add logic to search AuthorizationID both CM and SC in ClientSearchPopUp Network- 180 Customizations - #609
-- 11.24.2015      Vichee          Modified the  logic to search AuthorizationID both CM and SC in ClientSearchPopUp Network- 180 Customizations - #609
-- 26.Feb.2016		Rohith Uppin	Alias name - ContactName added for Contact column. Core bugs 2254
-- 03.Jun.2016	   Suneel N		   Used Group By ClientId and select min(ClientAliasId) as ClientAliasId for Broad Search - Network180 Env. Issues Tracking #250
*********************************************************************************/
as 
begin try  
          
  create table #ClientSearch (
  ClientId int,
  ClientContactId int,
  ClientAliasId int)            
            
  declare @TotalClients int            
  declare @SearchId int     
  declare @IsMasterDatabase char(1)  
  declare @IsNumeric int     
        
  set @IsMasterDatabase = dbo.ssf_IsMasterDatabase()

  if @SearchType = 'CLIENTID' 
    begin            
      insert  into #ClientSearch
              (ClientId)
              select  c.ClientId
              from    Clients c
              where   c.ClientId = @ClientId
                      and isnull(c.RecordDeleted, 'N') <> 'Y'
    end   
  else -- Added By Vichee 19/10/2015
     if @SearchType = 'AuthorizationID'
     begin
     set @IsNumeric = (select ISNUMERIC(@AuthorizationID))
     
     if  @IsNumeric = 0
       begin        
     insert into #ClientSearch
				 (ClientId)
				 select c.ClientId
				 from Clients c
				 join ProviderAuthorizations pa on pa.ClientId=c.ClientId					 			
				 where pa.AuthorizationNumber = @AuthorizationID
				 and isnull(c.RecordDeleted, 'N') = 'N'
                 and isnull(pa.RecordDeleted, 'N') = 'N' 
                 
                 UNION
                 select c.ClientId
				 from Clients c
				 join ClientCoveragePlans Cp on cp.ClientId=c.Clientid
                join AuthorizationDocuments Ad on Ad.ClientCOveragePlanId=cp.ClientCoveragePlanId
                join Authorizations A On A.AuthorizationDocumentId =ad.AuthorizationDocumentId 
				 where a.AuthorizationNumber = @AuthorizationID 
				 and isnull(c.RecordDeleted, 'N') = 'N'
                 and isnull(a.RecordDeleted, 'N') = 'N' 
                  and isnull(cp.RecordDeleted, 'N') = 'N'
                 and isnull(ad.RecordDeleted, 'N') = 'N' 
        end
      else
        begin
      --numeric
         insert into #ClientSearch
				 (ClientId)
				 select c.ClientId
				 from Clients c
				 join ProviderAuthorizations pa on pa.ClientId=c.ClientId
				 where (pa.ProviderAuthorizationId = Cast(@AuthorizationID as Int)
				 		or  pa.AuthorizationNumber = @AuthorizationID)
				  and isnull(c.RecordDeleted, 'N') = 'N'
                  and isnull(pa.RecordDeleted, 'N') = 'N' 
                  
                  UNION
                  
                  select c.ClientId
				 from Clients c
				 join ClientCoveragePlans Cp on cp.ClientId=c.Clientid
                join AuthorizationDocuments Ad on Ad.ClientCOveragePlanId=cp.ClientCoveragePlanId
                join Authorizations A On A.AuthorizationDocumentId =ad.AuthorizationDocumentId 
				 where (a.AuthorizationId = Cast(@AuthorizationID as Int) or  a.AuthorizationNumber = @AuthorizationID )
				  and isnull(c.RecordDeleted, 'N') = 'N'
                  and isnull(a.RecordDeleted, 'N') = 'N' 
                   and isnull(cp.RecordDeleted, 'N') = 'N'
                 and isnull(ad.RecordDeleted, 'N') = 'N'
        end  
     end   -- end by Vichee
             
  else 
    if @SearchType = 'CAREMANAGEMENTID' 
      begin            
        if @IsMasterDatabase = 'Y' 
          begin
            insert  into #ClientSearch
                    (ClientId)
                    select  c.ClientId
                    from    Clients c
                    where   c.MasterRecord = 'Y'
                            and c.ClientId = @MasterClientId
                            and isnull(c.RecordDeleted, 'N') = 'N'
		
            insert  into #ClientSearch
                    (ClientId)
                    select  c.ClientId
                    from    Clients c
                            join ProviderClients pc on pc.ClientId = c.ClientId
                    where   pc.MasterClientId = @MasterClientId
                            and c.MasterRecord = 'N'
                            and isnull(c.RecordDeleted, 'N') = 'N'
                            and isnull(pc.RecordDeleted, 'N') = 'N'
          end 
        else 
          begin        
            insert  into #ClientSearch
                    (ClientId)
                    select  c.ClientId
                    from    Clients c
                    where   c.CareManagementId = @MasterClientId
                            and isnull(c.RecordDeleted, 'N') <> 'Y' 
          end	      			           
      end            
    else 
      if @SearchType = 'PRIMARYCLINICIAN' 
        begin            
          insert  into #ClientSearch
                  (ClientId)
                  select  c.ClientId
                  from    Clients c
                  where   c.PrimaryClinicianId = @PrimaryClinicianId
                          and isnull(c.RecordDeleted, 'N') <> 'Y'            
        end            
      else 
        if @SearchType = 'INSUREDID' --Insured Id Search                            
          begin            
            insert  into #ClientSearch
                    (ClientId)
                    select  c.ClientId
                    from    Clients c
                            join ClientCoveragePlans as ccp on ccp.ClientId = c.ClientId
                    where   ccp.InsuredId = '' + @InsuredId + ''
                            and isnull(ccp.RecordDeleted, 'N') <> 'Y'
                            and isnull(c.RecordDeleted, 'N') <> 'Y'         
          end              
                 
        else 
          if @SearchType = 'BROAD' 
            begin            
              insert  into #ClientSearch
                      (ClientId)
                      select  c.ClientId
                      from    Clients c
                      where   (c.LastName like (substring(@LastName, 1, 3) + '%')
                               or c.LastNameSoundex = soundex(@LastName)
                               or isnull(@LastName, '') = '')
                              and (c.FirstName like (substring(@FirstName, 1, 3) + '%')
                                   or c.FirstNameSoundex = soundex(@FirstName)
                                   or isnull(@FirstName, '') = '')
                              and isnull(c.RecordDeleted, 'N') <> 'Y'
                              and ((C.ClientId in (select CP.ClientId
                                                   from   ClientPrograms CP
                                                   where  (CP.ClientId = c.ClientId
                                                           and isnull(CP.RecordDeleted, 'N') <> 'Y')
                                                          and (((CP.ProgramId = @ProgramId)
                                                                and CP.STATUS in (1, 4))
                                                               or @ProgramId = 0)))
                                   or @ProgramId = 0) 
                                    -- Added By Vichee 19/10/2015     
                                    and  (c.OrganizationName like (substring(@OrganizationName, 1, 3) + '%')                              
                               or isnull(@OrganizationName, '') = '')  
                                and ClientType = @ClientType
                               -- end by Vichee      
            
              insert  into #ClientSearch
                      (ClientId,
                       ClientAliasId)
                      select  ca.ClientId,
                              Min(ca.ClientAliasId)
                      from    ClientAliases ca
                              inner join Clients c on c.ClientId = ca.ClientId
                      where   (ca.LastName like (substring(@LastName, 1, 3) + '%')
                               or ca.LastNameSoundex = soundex(@LastName)
                               or isnull(@LastName, '') = '')
                              and (ca.FirstName like (substring(@FirstName, 1, 3) + '%')
                                   or ca.FirstNameSoundex = soundex(@FirstName)
                                   or isnull(@FirstName, '') = '')
                              and ca.AllowSearch = 'Y'
                              and isnull(ca.RecordDeleted, 'N') <> 'Y'
                              and isnull(c.RecordDeleted, 'N') <> 'Y'
                              and not exists ( select *
                                               from   #ClientSearch cs
                                               where  cs.ClientId = c.ClientId )
                              and ((C.ClientId in (select CP.ClientId
                                                   from   ClientPrograms CP
                                                   where  (CP.ClientId = c.ClientId
                                                           and isnull(CP.RecordDeleted, 'N') <> 'Y')
                                                          and (((CP.ProgramId = @ProgramId)
                                                                and CP.STATUS in (1, 4))
                                                               or @ProgramId = 0)))
                                   or @ProgramId = 0)    
                                   
									-- Added By Vichee 19/10/2015 
                                    and  (c.OrganizationName like (substring(@OrganizationName, 1, 3) + '%')                              
                               or isnull(@OrganizationName, '') = '')   
                               and ClientType = @ClientType
                                -- end by Vichee     
                            Group By ca.ClientId
            
              if @IncludeClientContacts = 'Y' 
                begin            
                  insert  into #ClientSearch
                          (ClientId,
                           ClientContactId)
                          select  cc.ClientId,
                                  cc.ClientContactId
                          from    Clients c
                                  inner join ClientContacts cc on cc.ClientId = c.ClientId
                          where   (cc.LastName like (substring(@LastName, 1, 3) + '%')
                                   or cc.LastNameSoundex = soundex(@LastName)
                                   or isnull(@LastName, '') = '')
                                  and (cc.FirstName like (substring(@FirstName, 1, 3) + '%')
                                       or cc.FirstNameSoundex = soundex(@FirstName)
                                       or isnull(@FirstName, '') = '')
                                  and isnull(c.RecordDeleted, 'N') <> 'Y'
                                  and isnull(cc.RecordDeleted, 'N') <> 'Y'
                                  and ((C.ClientId in (select CP.ClientId
                                                       from   ClientPrograms CP
                                                       where  (CP.ClientId = c.ClientId
                                                               and isnull(CP.RecordDeleted, 'N') <> 'Y')
                                                              and (((CP.ProgramId = @ProgramId)
                                                                    and CP.STATUS in (1, 4))
                                                                   or @ProgramId = 0)))
                                       or @ProgramId = 0)     
                                       
                                       -- Added By Vichee 19/10/2015 
                                    and  (c.OrganizationName like (substring(@OrganizationName, 1, 3) + '%')                              
                               or isnull(@OrganizationName, '') = '')   
                               and ClientType = @ClientType
                                -- end by Vichee           
                end            
            end            
          else 
            if @SearchType = 'NARROW' 
              begin            
                insert  into #ClientSearch
                        (ClientId)
                        select  c.ClientId
                        from    Clients c
                        where   (c.LastName like (@LastName + '%')
                                 or isnull(@LastName, '') = '')
                                and (c.FirstName like (@FirstName + '%')
                                     or isnull(@FirstName, '') = '')
                                  and (c.OrganizationName like (@OrganizationName + '%')
                                     or isnull(@OrganizationName, '') = '') 
                                     and c.ClientType = @ClientType   
                                and isnull(c.RecordDeleted, 'N') <> 'Y'
                                and ((C.ClientId in (select CP.ClientId
                                                     from   ClientPrograms CP
                                                     where  (CP.ClientId = c.ClientId
                                                             and isnull(CP.RecordDeleted, 'N') <> 'Y')
                                                            and (((CP.ProgramId = @ProgramId)
                                                                  and CP.STATUS in (1, 4))
                                                                 or @ProgramId = 0)))
                                     or @ProgramId = 0)            
            
                insert  into #ClientSearch
                        (ClientId,
                         ClientAliasId)
                        select  ca.ClientId,
                                Min(ca.ClientAliasId)
                        from    ClientAliases ca
                                inner join Clients c on c.ClientId = ca.ClientId
                        where   (ca.LastName like (@LastName + '%')
                                 or isnull(@LastName, '') = '')
                                and (ca.FirstName like (@FirstName + '%')
                                     or isnull(@FirstName, '') = '')
                                     -- Added By Vichee 19/10/2015
                                      and (c.OrganizationName like (@OrganizationName + '%')
                                     or isnull(@OrganizationName, '') = '') 
                                     and c.ClientType = @ClientType
                                      -- end by Vichee
                                and ca.AllowSearch = 'Y'
                                and isnull(ca.RecordDeleted, 'N') <> 'Y'
                                and isnull(c.RecordDeleted, 'N') <> 'Y'
                                and not exists ( select *
                                                 from   #ClientSearch cs
                                                 where  cs.ClientId = c.ClientId )
                                and ((C.ClientId in (select CP.ClientId
                                                     from   ClientPrograms CP
                                                     where  (CP.ClientId = c.ClientId
                                                             and isnull(CP.RecordDeleted, 'N') <> 'Y')
                                                            and (((CP.ProgramId = @ProgramId)
                                                                  and CP.STATUS in (1, 4))
                                                                 or @ProgramId = 0)))
                                     or @ProgramId = 0)            
							Group By ca.ClientId
							
                if @IncludeClientContacts = 'Y' 
                  begin            
                    insert  into #ClientSearch
                            (ClientId,
                             ClientContactId)
                            select  cc.ClientId,
                                    cc.ClientContactId
                            from    Clients c
                                    inner join ClientContacts cc on cc.ClientId = c.ClientId
                            where   (cc.LastName like (@LastName + '%')
                                     or isnull(@LastName, '') = '')
                                    and (cc.FirstName like (@FirstName + '%')
                                         or isnull(@FirstName, '') = '')
                                    and isnull(c.RecordDeleted, 'N') <> 'Y'
                                    and isnull(cc.RecordDeleted, 'N') <> 'Y'
                                    and ((C.ClientId in (select CP.ClientId
                                                         from   ClientPrograms CP
                                                         where  (CP.ClientId = c.ClientId
                                                                 and isnull(CP.RecordDeleted, 'N') <> 'Y')
                                                                and (((CP.ProgramId = @ProgramId)
                                                                      and CP.STATUS in (1, 4))
                                                                     or @ProgramId = 0)))
                                         or @ProgramId = 0)      
                                         -- Added By Vichee 19/10/2015 
                                    and  (c.OrganizationName like (substring(@OrganizationName, 1, 3) + '%')                              
                               or isnull(@OrganizationName, '') = '')   
                               and ClientType = @ClientType
                                -- end by Vichee          
                  end            
              end    
                 else 
                 -- Added By Vichee 19/10/2015
              if @SearchType = 'EIN' 
                begin          
                  set @EIN = replace(@EIN, '-', '')            
            
                  insert  into #ClientSearch
                          (ClientId)
                          select  c.ClientId
                          from    Clients c
                          where   ((len(@EIN) = 4
                                    and substring(c.EIN, 6, 9) = @EIN)
                                   or c.EIN = @EIN)
                                  and isnull(c.RecordDeleted, 'N') <> 'Y'
                  
                if @IncludeClientContacts = 'Y' 
                    begin            
                      insert  into #ClientSearch
                              (ClientId,
                               ClientContactId)
                              select  cc.ClientId,
                                      cc.ClientContactId
                              from    Clients c
                                      inner join ClientContacts cc on cc.ClientId = c.ClientId
                              where   ((len(@EIN) = 4
                                        and substring(c.EIN, 6, 9) = @EIN)                                       
                                      or c.EIN = @EIN)
                                  and isnull(c.RecordDeleted, 'N') <> 'Y'
                                      and isnull(cc.RecordDeleted, 'N') <> 'Y'            
                    end 
               
                end 
                -- end by Vichee       
                      
            else 
              if @SearchType = 'SSN' 
                begin            
                  set @SSN = replace(@SSN, '-', '')            
            
                  insert  into #ClientSearch
                          (ClientId)
                          select  c.ClientId
                          from    Clients c
                          where   ((len(@SSN) = 4
                                    and substring(c.SSN, 6, 9) = @SSN)
                                   or c.SSN = @SSN)
                                  and isnull(c.RecordDeleted, 'N') <> 'Y'
            
                  if @IncludeClientContacts = 'Y' 
                    begin            
                      insert  into #ClientSearch
                              (ClientId,
                               ClientContactId)
                              select  cc.ClientId,
                                      cc.ClientContactId
                              from    Clients c
                                      inner join ClientContacts cc on cc.ClientId = c.ClientId
                              where   ((len(@SSN) = 4
                                        and substring(cc.SSN, 6, 9) = @SSN)
                                       or cc.SSN = @SSN)
                                      and isnull(c.RecordDeleted, 'N') <> 'Y'
                                      and isnull(cc.RecordDeleted, 'N') <> 'Y'            
                    end            
                end            
              else 
                if @SearchType = 'PHONE' 
                  begin            
                    set @Phone = replace(replace(replace(replace(@Phone, '-', ''), ')', ''), '(', ''), ' ', '')            
            
                    insert  into #ClientSearch
                            (ClientId)
                            select  c.ClientId
                            from    Clients c
                            where   isnull(c.RecordDeleted, 'N') <> 'Y'
                                    and exists ( select *
                                                 from   ClientPhones cp
                                                 where  cp.ClientId = c.ClientId
                                                        and cp.PhoneNumberText = @Phone
                                                        and isnull(cp.RecordDeleted, 'N') = 'N' )            
            
                    if @IncludeClientContacts = 'Y' 
                      begin            
                        insert  into #ClientSearch
                                (ClientId,
                                 ClientContactId)
                                select  cc.ClientId,
                                        cc.ClientContactId
                                from    Clients c
                                        inner join ClientContacts cc on cc.ClientId = c.ClientId
                                where   isnull(c.RecordDeleted, 'N') <> 'Y'
                                        and isnull(cc.RecordDeleted, 'N') <> 'Y'
                                        and exists ( select *
                                                     from   ClientContactPhones ccp
                                                     where  ccp.ClientContactId = cc.ClientContactId
                                                            and ccp.PhoneNumberText = @Phone
                                                            and isnull(ccp.RecordDeleted, 'N') = 'N' )            
                      end            
                  end            
                else 
                  if @SearchType = 'DOB' 
                    begin            
                      insert  into #ClientSearch
                              (ClientId)
                              select  c.ClientId
                              from    Clients c
                              where   c.DOB = @DOB
                                      and isnull(c.RecordDeleted, 'N') <> 'Y'            
            
                      if @IncludeClientContacts = 'Y' 
                        begin            
                          insert  into #ClientSearch
                                  (ClientId,
                                   ClientContactId)
                                  select  cc.ClientId,
                                          cc.ClientContactId
                                  from    Clients c
                                          inner join ClientContacts cc on cc.ClientId = c.ClientId
                                  where   cc.DOB = @DOB
                                          and isnull(c.RecordDeleted, 'N') <> 'Y'
                                          and isnull(cc.RecordDeleted, 'N') <> 'Y'            
                        end            
                    end            
            
  if @ProviderId is not null 
    begin
      delete  cs
      from    #ClientSearch cs
      where   not exists ( select *
                           from   ProviderClients pc
                           where  pc.ClientId = cs.ClientId
                                  and pc.ProviderId = @ProviderId
                                  and isnull(pc.RecordDeleted, 'N') = 'N' )
    end


 -- Make sure all found clients are in StaffClients according to Client Access permissions                  
  exec ssp_RefreshStaffClients 
    @StaffId = @StaffId,
    @ClientId = null,
    @ClientSearch = 'Y'            
            
          
            
  select  c.ClientId,
          case when @IsMasterDatabase = 'Y' 
		       then case when isnull(c.MasterRecord, 'N') = 'N' 
			             then pc.MasterClientId
                         else c.ClientId
                    end
               else c.CareManagementId
          end as CareManagementId,
          'Self' as Relationship,
          replace(c.LastName, '"', '&#34;') as LastName,
          replace(c.FirstName, '"', '&#34;') as FirstName,
          replace(c.LastName, '"', '&#34;') + ', ' + replace(c.FirstName, '"', '&#34;') as ContactName,
          c.DOB,
          substring(c.SSN, 6, 9) as SSN,
          c.SSN as SSNToolTip,
          case when len(c.SSN) > 8 then substring(c.SSN, 1, 3) + '-' + substring(c.SSN, 4, 2) + '-' + substring(c.SSN, 6, 4)
               else c.SSN
          end as FormattedFullSSN,
           case when c.LastName IS NULL OR c.FirstName IS NULL  then  
          OrganizationName else 
           c.LastName+', '+ c.FirstName  end as ClientName,
          case when c.Active = 'Y' then 'Active'
               else 'Inactive'
          end as STATUS,
          ca.City,
          cal.LastName + ', ' + cal.FirstName as ClientAlias,
          s.LastName + ', ' + s.FirstName as PrimaryClinician,
          p.ProviderName + case when isnull(p.FirstName, '') <> '' then ', ' + p.FirstName
                                else ''
                           end as ProviderName,
          -- Added By Vichee 19/10/2015 
          c.OrganizationName,
          c.ClientType,
          c.EIN
          -- end by Vichee
  from    #ClientSearch cs
          join Clients c on c.ClientId = cs.ClientId
          join StaffClients sc on sc.StaffId = @StaffId
                                  and sc.ClientId = c.ClientId
          left join ClientAddresses ca on ca.ClientId = c.ClientId
                                          and ca.AddressType = 90
                                          and isnull(ca.RecordDeleted, 'N') <> 'Y'
          left join Staff s on s.StaffId = c.PrimaryClinicianId
          left join ClientAliases cal on cal.ClientAliasId = cs.ClientAliasId
          left join ProviderClients pc on pc.ClientId = c.ClientId
                                          and c.MasterRecord = 'N'
                                          and isnull(pc.RecordDeleted, 'N') = 'N'
          left join Providers p on p.ProviderId = pc.ProviderId
  where   cs.ClientContactId is null
          and (isnull(c.Active, 'Y') = @ClientStatus
               or @ClientStatus = 'N')
  union
  select  c.ClientId,
          case when @IsMasterDatabase = 'Y' 
		       then case when isnull(c.MasterRecord, 'N') = 'N' 
			             then pc.MasterClientId
                         else c.ClientId
                    end
               else c.CareManagementId
          end as CareManagementId,
          isnull(gccr.CodeName, 'Unknown') as Relationship,
          replace(cc.LastName, '"', '&#34;') as LastName,
          replace(cc.FirstName, '"', '&#34;') as FirstName,
          replace(cc.LastName, '"', '&#34;') + ', ' + replace(cc.FirstName, '"', '&#34;') as ContactName,
          cc.DOB,
          substring(c.SSN, 6, 9) as SSN,
          c.SSN as SSNToolTip,
          case when len(c.SSN) > 8 then substring(c.SSN, 1, 3) + '-' + substring(c.SSN, 4, 2) + '-' + substring(c.SSN, 6, 4)
               else c.SSN
          end as FormattedFullSSN,
           case when c.LastName IS NULL OR c.FirstName IS NULL  then  
     OrganizationName else 
      c.LastName+', '+ c.FirstName  end as ClientName,
          case when c.Active = 'Y' then 'Active'
               else 'Inactive'
          end as STATUS,
          cca.City,
          null as ClientAlias,
          s.LastName + ', ' + s.FirstName as PrimaryClinician,
          p.ProviderName + case when isnull(p.FirstName, '') <> '' then ', ' + p.FirstName
                                else ''
                           end as ProviderName,
            -- Added By Vichee 19/10/2015  
          c.OrganizationName,
          c.ClientType,
          c.EIN
           -- end by Vichee
  from    #ClientSearch cs
          join Clients c on c.ClientId = cs.ClientId
          join ClientContacts cc on cc.ClientContactId = cs.ClientContactId
          join StaffClients sc on sc.StaffId = @StaffId
                                  and sc.ClientId = c.ClientId
          left join GlobalCodes gccr on gccr.GlobalCodeId = cc.Relationship
          left join ClientContactAddresses cca on cca.ClientContactId = cc.ClientContactId
                                                  and cca.AddressType = 90
                                                  and isnull(cca.RecordDeleted, 'N') <> 'Y'
          left join Staff s on s.StaffId = c.PrimaryClinicianId
          left join ProviderClients pc on pc.ClientId = c.ClientId
                                          and c.MasterRecord = 'N'
                                          and isnull(pc.RecordDeleted, 'N') = 'N'
          left join Providers p on p.ProviderId = pc.ProviderId
  where   (isnull(c.Active, 'Y') = @ClientStatus
           or @ClientStatus = 'N')
          
           
  select  @TotalClients = @@rowcount            
            
  if @TotalClients > 0 
    begin            
      if isnull(@CreatedBy, '') = '' 
        select  @CreatedBy = UserCode
        from    Staff
        where   staffid = @StaffId            
            
      if isnull(@CreatedDate, '') = '' 
        set @CreatedDate = getdate()            
            
      insert  into ClientSearchAudits
              (StaffId,
               SearchDate,
               LastName,
               FirstName,
               ClientId,
               DOB,
               SSN,
               IncludeClientContacts,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               Modifieddate)
      values  (@StaffId,
               @CreatedDate,
               nullif(@LastName, ''),
               nullif(@FirstName, ''),
               @ClientId,
               @DOB,
               nullif(@SSN, ''),
               isnull(@IncludeClientContacts, 'N'),
               @CreatedBy,
               @CreatedDate,
               @CreatedBy,
               @CreatedDate)            
            
      select  @SearchId = @@Identity            
            
      select  @SearchId as SearchId            
            
      if @SearchId > 0 
        begin            
          if isnull(@Paging, 'N') <> 'Y' --Do not insert record on paging                              
            begin            
              insert  into ClientViewAudits
                      (SearchID,
                       ClientId,
                       ClientSelected,
                       CreatedBy,
                       Createddate,
                       ModifiedBy,
                       Modifieddate)
                      select distinct
                              SearchId = @SearchId,
                              cs.ClientId,
                              'N',
                              @CreatedBy,
                              @CreatedDate,
                              @CreatedBy,
                              @CreatedDate
                      from    #ClientSearch cs
					          join Clients c on c.ClientId = cs.ClientId
                              join StaffClients sc on sc.StaffId = @StaffId and sc.ClientId = cs.ClientId                  
                      where   (c.Active = @ClientStatus
                                                   or @ClientStatus = 'N')          
            end            
        end            
    end            
end try            
            
begin catch            
  declare @Error varchar(8000)            
            
  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_SCClientSearch') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())                
  raiserror (            
   @Error            
   ,-- Message text.                             
   16            
   ,-- Severity.                             
   1 -- State.                                                                               
   );            
end catch

go
