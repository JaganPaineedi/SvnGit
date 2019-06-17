/****** Object:  StoredProcedure [dbo].[scsp_SCValidateOderingMethod]    Script Date: 2/10/2014 8:08:24 PM ******/
if exists ( select  1
            from    INFORMATION_SCHEMA.ROUTINES
            where   SPECIFIC_SCHEMA = 'dbo'
                    and SPECIFIC_NAME = 'scsp_SCValidateOderingMethod' )
    drop procedure [dbo].[scsp_SCValidateOderingMethod];
go

/****** Object:  StoredProcedure [dbo].[scsp_SCValidateOderingMethod]    Script Date: 2/10/2014 8:08:24 PM ******/
set ansi_nulls on;
go

set quoted_identifier on;
go

create procedure [dbo].[scsp_SCValidateOderingMethod]
--
-- Procedure: scsp_SCValidateOderingMethod
--
-- Purpose: Check contents of script and determine whether the script may
-- be transmitted by the given ordering method.  If it may not be transmitted,
-- set the alternative ordering method that is allowed.
--
-- Called by: the SmartCareRx
--
/*
-- Change Log:
--    2010.12.12 - T Remisoski - Created.
--    2011.01.17 - T Remisoski - Add "ScriptMessage".
--	  2012.06.05 - dharvey		Add check for Titration on Electronic orders
	  10.12.2012	dharvey		Added Validation Error insert into CustomBugTracking
								and added additional validation to prevent multiple meds
								on single Script when order method E
	10.15.2012		dharvey		Modified validation to join on SessionId
	10.16.2012		dharvey		Reduced validation restrictions to prevent catches on valid orders
	10.19.2012		dharvey		Moved validations inside ELSE block to prevent controlled med
								scripts status from changing
								Also modified Controlled Meds check to utilize SessionId rather than ScriptId
								to prevent controlled meds from being delivered via fax
	12.16.2013      Kneale      removed dependency on session id and used script id and joined to clientmedicationscriptsdrugs table
--
*/  @ClientMedicationScriptId int
  , @IncomingOrderingMethod char(1) = null -- SDI, do not use this parameter
as
    declare @OrderingMethod char(1);
    declare @ScriptContainsControlledMedications char(1);
    declare @MedicationId int;
    declare @ScriptMessage varchar(200);
    declare @tScriptMessages table
        (
          ScriptMessage nvarchar(max)
        );

    declare @error_message nvarchar(4000);
    declare @error_number int;

    set @ScriptContainsControlledMedications = 'N';
    
    declare @ClientId int
      , @OriginalOrderingMethod char(1)
      , @SessionId varchar(24);

    select  @OrderingMethod = OrderingMethod
          , @ClientId = ClientId
          , @OriginalOrderingMethod = OrderingMethod
          , @SessionId = SessionId
    from    ClientMedicationScriptsPreview
    where   ClientMedicationScriptId = @ClientMedicationScriptId;

    declare @DEACode char(1);
    set @DEACode = '';

--
-- "controlled" medications cannot be faxed or printed.
-- identify them here.
--
    if @OrderingMethod in ( 'E', 'F' )
        begin

            select  @DEACode = isnull(max(dbo.[ssf_SCClientMedicationC2C5Drugs](cmi.StrengthId)),
                                      '')
            from    ClientMedicationScriptDrugsPreview cmsd
                    join ClientMedicationInstructionsPreview as cmi on ( cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                                              and cmsd.ClientMedicationScriptId = @ClientMedicationScriptId
                                                              and isnull(cmi.RecordDeleted,
                                                              'N') <> 'Y'
                                                              ) AND ISNULL(cmi.Active,'Y')='Y';

            if @DEACode in ( '1', '2', '3', '4', '5' )
                set @ScriptContainsControlledMedications = 'Y';

        end;
		
--
-- E-prescribing validation checks.
--
    if @OrderingMethod = 'E'
        begin
            if @ScriptContainsControlledMedications = 'Y'
                begin
                    if @DEACode in ( '3', '4', '5' )
                        set @OrderingMethod = 'F';
                    else
                        begin 
                            set @OrderingMethod = 'P';
                            insert  into @tScriptMessages
                                    ( ScriptMessage
                                	)
                            values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'SCHEDULE2SIGNEDWET_SCSP',
                                                              'Scripts for schedule II medications must be printed and signed with a "wet" signature.')
                                      )
                                    );
                        end;
                end;
            else
                begin

   -- Look for possible truncation of client information.

                    declare @lenFirstName int
                      , @lenMiddleName int
                      , @lenLastName int
                      , @ZipCodeMessage varchar(100);

                    declare @lenPatientAddress1 int
                      , @lenPatientAddress2 int
                      , @lenPatientCity int;

                    select  @lenFirstName = len(isnull(c.FirstName, ''))
                          , @lenMiddleName = len(isnull(c.MiddleName, ''))
                          , @lenLastName = len(isnull(c.LastName, ''))
                    from    Clients as c
                            join ClientMedicationScriptsPreview as cms on cms.ClientId = c.ClientId
                    where   cms.ClientMedicationScriptId = @ClientMedicationScriptId;

                    if @lenFirstName > 35
                        insert  into @tScriptMessages
                                ( ScriptMessage
                                )
                        values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTFNAMEEPRESCRIBING_SCSP',
                                                              'WARNING: CLIENT FIRST NAME HAS BEEN TRUNCATED TO FIT INTO THE E-PRESCRIBING FORMAT.')
                                  )
                                );

                    if @lenMiddleName > 35
                        insert  into @tScriptMessages
                                ( ScriptMessage
                                )
                        values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTMNAMEEPRESCRIBING_SCSP',
                                                              'WARNING: CLIENT MIDDLE NAME HAS BEEN TRUNCATED TO FIT INTO THE E-PRESCRIBING FORMAT.')
                                  )
                                );

                    if @lenLastName > 35
                        insert  into @tScriptMessages
                                ( ScriptMessage
                                )
                        values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTLNAMEEPRESCRIBING_SCSP',
                                                              'WARNING: CLIENT LAST NAME HAS BEEN TRUNCATED TO FIT INTO THE E-PRESCRIBING FORMAT.')
                                  )
                                );

                    select  @lenPatientAddress1 = len(isnull(dbo.ssf_SureScriptsAddressElement(ca.Address,
                                                              1, 'N'), ''))
                          , @lenPatientAddress2 = len(isnull(dbo.ssf_SureScriptsAddressElement(ca.Address,
                                                              2, 'N'), ''))
                          , @lenPatientCity = len(isnull(ca.City, ''))
                          , @ZipCodeMessage = case when ( len(replace(ltrim(rtrim(ca.Zip)),
                                                              '-', '')) not in (
                                                          5, 9 ) )
                                                   then ( select
                                                              dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTADDRESSZIPINVALID_SCSP',
                                                              'WARNING: Client ADDRESS ZIP CODE IS INVALID AND HAS BEEN OMMITTED FROM SCRIPT')
                                                        )
                                                   when ( replace(ltrim(rtrim(ca.Zip)),
                                                              '-', '') like '%[^0-9]%' )
                                                   then ( select
                                                              dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTADDRESSZIPINVALIDCHAR_SCSP',
                                                              'WARNING: Client ADDRESS ZIP CODE CONTAINS INVALID CHARACTERS AND HAS BEEN OMMITTED FROM SCRIPT')
                                                        )
                                                   else ''
                                              end
                    from    ClientMedicationScriptsPreview as cms
                            join Clients as c on c.ClientId = cms.ClientId
                            left outer join ClientAddresses as ca on ca.ClientId = c.ClientId
                                                              and ca.AddressType = 90
                                                              and isnull(ca.RecordDeleted,
                                                              'N') <> 'Y'
                    where   cms.ClientMedicationScriptId = @ClientMedicationScriptId
                            and not exists ( select *
                                             from   ClientAddresses as ca3
                                             where  ca3.ClientId = ca.ClientId
                                                    and ca3.AddressType = ca.AddressType
                                                    and isnull(ca3.RecordDeleted,
                                                              'N') <> 'Y'
                                                    and ca3.ClientAddressId > ca.ClientAddressId );

                    if @lenPatientAddress1 > 35
                        insert  into @tScriptMessages
                                ( ScriptMessage
                                )
                        values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTADDRESSLINE1TRUNC_SCSP',
                                                              'WARNING: CLIENT ADDRESS LINE 1 TRUNCATED.')
                                  )
                                );

                    if @lenPatientAddress2 > 35
                        insert  into @tScriptMessages
                                ( ScriptMessage
                                )
                        values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTADDRESSLINE2TRUNC_SCSP',
                                                              'WARNING: CLIENT ADDRESS LINE 2 TRUNCATED.')
                                  )
                                );

                    if @lenPatientCity > 35
                        insert  into @tScriptMessages
                                ( ScriptMessage
                                )
                        values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'CLIENTADDRESSCITYTRUNC_SCSP',
                                                              'WARNING: CLIENT ADDRESS CITY TRUNCATED.')
                                  )
                                );

      --if len(isnull(@ZipCodeMessage, '')) > 0
      --   insert into @tScriptMessages(ScriptMessage) values (@ZipCodeMessage)
      
					
				/** Moved inside Else block to DJH - 10/19/2012 **/
                    if exists ( select  1
                                from    ClientMedicationInstructionsPreview cmi
                                        join ClientMedicationScriptDrugsPreview cmsd on cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                where   ClientMedicationScriptId = @ClientMedicationScriptId
                                        and isnull(cmi.TitrationStepNumber, 1) > 1 AND ISNULL(cmi.Active,'Y')='Y')
                        begin
                            set @OrderingMethod = 'F';
                            insert  into @tScriptMessages
                                    ( ScriptMessage 
                                    )
                            values  ( 'Titrated/Previously Titrated Orders are not permitted through SureScripts.  Please continue and this order will be faxed instead.'
                                    );
                        end;
                     
                     
                    if exists ( select  count(distinct cmsd.Days)
                                from    ClientMedicationInstructionsPreview cmi
                                        join ClientMedicationScriptDrugsPreview cmsd on cmsd.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
                                where   ClientMedicationScriptId = @ClientMedicationScriptId AND ISNULL(cmi.Active,'Y')='Y'
                                group by cmi.ClientMedicationId
                                      , cmi.StrengthId
                                having  count(distinct cmsd.Days) > 1 )
                        begin
                            set @OrderingMethod = 'F';
                            insert  into @tScriptMessages
                                    ( ScriptMessage 
                                    )
                            values  ( 'Medication Orders with same strength and different duration are not permitted through SureScripts.  Please continue and this order will be faxed instead.'
                                    );
                        end;
                  
                end;

   -- make sure the quantity will be calculated correctly
            begin
                begin try
                    declare @ScriptOutput table
                        (
                          ClientMedicationScriptId int
                        , PON varchar(35)
                        , RxReferenceNumber varchar(35)
                        , DrugDescription varchar(250)
                        , SureScriptsQuantityQualifier varchar(3)
                        , SureScriptsQuantity decimal(29, 14)
                        , TotalDaysInScript int
                        , ScriptInstructions varchar(max)
                        , ScriptNote varchar(max)
                        , -- VARCHAR(210) ,
                          Refills int
                        , DispenseAsWritten char(1)
                        , -- Y/N
                          OrderDate datetime
                        , NDC varchar(35)
                        , RelatesToMessageID varchar(35)
                        , PotencyUnitCode varchar(35)
                        );

                    insert  into @ScriptOutput
                            exec scsp_SureScriptsScriptOutput @ClientMedicationScriptId,
                                'Y';

                    if exists ( select  *
                                from    @ScriptOutput
                                where   ( SureScriptsQuantity is null )
                                        or ( SureScriptsQuantity = 0.0 ) )
                        begin
                            set @OrderingMethod = 'P';
                            insert  into @tScriptMessages
                                    ( ScriptMessage
                                    )
                            values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'QUANTITYNOTDETERMINE_SCSP',
                                                              'Quantity could not be determined from data entry. Script cannot be transmitted directly to pharmacy.')
                                      )
                                    );
                        end;
                                                
                    if exists ( select  *
                                from    @ScriptOutput
                                where   --LEN(ScriptInstructions) > 140) -- 
                                        len(replace(replace(replace(replace(replace(ScriptInstructions,
                                                              '&', '&amp;'),
                                                              '''', '&#39;'),
                                                              '"', '&quot;'),
                                                            '>', '&gt;'), '<',
                                                    '&lt;')) > 140 )
                        begin
                            set @OrderingMethod = 'F';
                            insert  into @tScriptMessages
                                    ( ScriptMessage
                                    )
                                    select  'Instructions greater than 140 characters. Shorten instructions or fax the order: [ '
                                            + ScriptInstructions + ' ]'
                                    from    @ScriptOutput
                                    where   -- LEN(ScriptInstructions) > 140 --
                                            len(replace(replace(replace(replace(replace(ScriptInstructions,
                                                              '&', '&amp;'),
                                                              '''', '&#39;'),
                                                              '"', '&quot;'),
                                                              '>', '&gt;'),
                                                        '<', '&lt;')) > 140;
                            
                        end;
                    if exists ( select  *
                                from    @ScriptOutput
                                where   --LEN(ScriptNote) > 210) --  
                                        len(replace(replace(replace(replace(replace(ScriptNote,
                                                              '&', '&amp;'),
                                                              '''', '&#39;'),
                                                              '"', '&quot;'),
                                                            '>', '&gt;'), '<',
                                                    '&lt;')) > 210 )
                        begin
                            set @OrderingMethod = 'F';
                            insert  into @tScriptMessages
                                    ( ScriptMessage
                                    )
                                    select  'Note to Pharmacy greater than 210 characters. Shorten Note to Pharmacy or fax the order: [ '
                                            + ScriptNote + ' ]'
                                    from    @ScriptOutput
                                    where   --LEN(ScriptNote) > 210 -- 
                                            len(replace(replace(replace(replace(replace(ScriptNote,
                                                              '&', '&amp;'),
                                                              '''', '&#39;'),
                                                              '"', '&quot;'),
                                                              '>', '&gt;'),
                                                        '<', '&lt;')) > 210;                            
                        end;                      
					


                        
                        
                end try
                begin catch
                    set @error_message = error_message();
                    set @error_number = error_number();

                    set @OrderingMethod = 'P';
                    set @ScriptMessage = ( select   dbo.Ssf_GetMesageByMessageCode(29,
                                                              'ERRORESCRIPTPREPARE_SCSP',
                                                              'Error in e-script preparation. Script must be printed. Please contact administrator. Error:')
                                         ) + cast(@error_number as varchar)
                        + '-'; 
                    set @ScriptMessage = @ScriptMessage + left(@error_message,
                                                              200
                                                              - len(@ScriptMessage));

                    insert  into @tScriptMessages
                            ( ScriptMessage )
                    values  ( @ScriptMessage );

                end catch;
            end;
        end;
    else
        if @OrderingMethod = 'F'
            begin
                if @ScriptContainsControlledMedications = 'Y'
                    begin
                        if @DEACode = '2'
                            begin
                                set @OrderingMethod = 'P';
                                insert  into @tScriptMessages
                                        ( ScriptMessage
                                    	)
                                values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'SCHEDULE2SIGNEDWET_SCSP',
                                                              'Scripts for schedule II medications must be printed and signed with a "wet" signature.')
                                          )
                                        );
                            end;
                    end;
                else
   -- check for a fax number at least 7-characters long
                    if not exists ( select  *
                                    from    Pharmacies as p
                                            join ClientMedicationScriptsPreview
                                            as cms on cms.PharmacyId = p.PharmacyId
                                    where   cms.ClientMedicationScriptId = @ClientMedicationScriptId
                                            and len(dbo.ssf_SureScriptsFormatPhone(p.FaxNumber)) >= 7
                                            and isnumeric(dbo.ssf_SureScriptsFormatPhone(p.FaxNumber)) = 1 )
                        begin
                            set @OrderingMethod = 'P';
                            insert  into @tScriptMessages
                                    ( ScriptMessage
                                    )
                            values  ( ( select  dbo.Ssf_GetMesageByMessageCode(29,
                                                              'FAXMISSINVALID_SCSP',
                                                              'Fax number for selected pharmacy is missing/invalid. Script must be printed.')
                                      )
                                    );
                        end;
   
            end;
            
            
   
          
            
            
            

    if 0 = ( select count(*)
             from   @tScriptMessages
           )  -- dummy row if all is well
        select  @ClientMedicationScriptId as ClientMedicationScriptId
              , @OrderingMethod as OrderingMethodAllowed
              , null as ScriptMessage;
    else
        insert  into dbo.ErrorLog
                ( ErrorMessage
                , VerboseInfo
                , DataSetInfo
                , ErrorType
                , CreatedBy
				)
                select  'Client-' + ltrim(rtrim(str(@ClientId)))
                        + '::SCRxValidation:' + ' ClientMedicationScriptId('
                        + convert(varchar(100), @ClientMedicationScriptId)
                        + ')' + ' OriginalOrderingMethod-'
                        + @OriginalOrderingMethod + ' OrderingMethodAllowed-'
                        + @OrderingMethod + ' ~ ' + ScriptMessage as DESCRIPTION
                      , -- ErrorMessage - text
                        ''
                      , -- VerboseInfo - text
                        ''
                      , -- DataSetInfo - text
                        'Rx'
                      , -- ErrorType - varchar(50)
                        'SCRxValidation' -- CreatedBy - type_CurrentUser
                from    @tScriptMessages;
		
    select  @ClientMedicationScriptId as ClientMedicationScriptId
          , @OrderingMethod as OrderingMethodAllowed
          , ScriptMessage as ScriptMessage
    from    @tScriptMessages;


go


