if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_CalculateEMCode]')
                    and type in ( N'P', N'PC' ) )
    begin
        drop procedure [dbo].[ssp_CalculateEMCode];
    end;
go

create procedure [dbo].[ssp_CalculateEMCode]
    (
      @PatientType varchar(50)
    , @History varchar(200)
    , @Exam varchar(200)
    , @Assessment varchar(200)
    , @EffectiveDate varchar(200)
    , @ClientId int
    , @DocumentVersionId int
	)
as
    begin
        begin try
            declare @AGE int;
            declare @EMCode int;
            declare @HEMCode int;
            declare @ProcedureCodeId int;
            declare @IsTemplatedCalculatedByAge char(1);
            declare @IsTemplatedCalculatedByTime char(1);
            declare @50PercentFaceTime char(1);
            declare @FaceTime int;
			declare @appointment int;
			declare @TemplateType char(1) = 'C' -- 'A' -- Age, 'C' --Complexity, 'T' -- Time

/********************************************************************************                                                  
-- Stored Procedure: ssp_SCGetNoteTemplateDetails
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Returns procedure based on Calcullation.
--
-- Author:  Vaibhav Khare
-- Date:    DEC 10 2012
**  Change History                                                  
*******************************************************************************                                                  
**  Date:         Author:       Description:                           
**  --------  --------    ----------------------------------------------------       
 15-05-2014		vkhare		Added Age based calculation for Age based calculation template
 1/13/2015		Wasif Butt	Added New patient / Existing patient Tally Tables and logic to calculate proper EMCode for New/Existing patients
 8/21/2015		Wasif Butt	Configuration key to calculate at existing patient level even for new patient.
 6/19/2017		Wasif Butt	Time based calculation. Now we'll support 3 ways of calculation Age based, complexity based and Time Based.
 5/02/2018		MD			Added Record deleted check and select top 1 for @50PercentFaceTime and @FaceTime variables as it is breaking due to duplicate bad data in "NoteEMCodeOptions" table w.r.t Harbor - Support: #1583.1
 02/JULY/2018	Akwinass	As per the discussion with Wasif, modified the logic to work for Inpatient (Task #660 Engineering Improvement Initiatives- NBL(I)) 
 02/JULY/2018	Akwinass	As per the discussion with Wasif, modified the logic to work for Inpatient (Task #660 Engineering Improvement Initiatives- NBL(I)) 
 81/02/2018		Wasif Butt	Added option to always calculate for existing patient codes ref: Texas Go Live Build Issues #300 - EMCodeCalculationForNewPatient does not appear to work after upgrading to the 1/25 Build
*********************************************************************************/
            select  @IsTemplatedCalculatedByAge = isnull(TemplateForAge, 'N')
            from    NoteTemplates
            where   NoteTemplateId = ( select top 1  TemplateID
                                       from     DocumentProgressNotes
                                       where    DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted,'N')='N'
                                     );
			-- Modified by MD on 05/02/2018
            select @50PercentFaceTime = (select top 1 isnull(ECE50PercentFaceTime, 'N') from dbo.NoteEMCodeOptions where DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted,'N')='N')
			select @FaceTime = (select top 1 isnull(ECEMinutes, 0) from dbo.NoteEMCodeOptions where DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted,'N')='N')

					select  @AGE = case when DOB is null then 18
										else dbo.GetAge(DOB, getdate())
								   end
					from    Clients
					where   ClientId = @ClientId;


			if (@IsTemplatedCalculatedByAge = 'Y')
				set @TemplateType = 'A'
			else if (@50PercentFaceTime = 'Y' and @FaceTime > 0)
				set @TemplateType = 'T'


			--Age based calculation
            if ( @TemplateType = 'A' )
                begin

			        if (( isnull(@PatientType, 'New') = 'New'  or (select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') = 'Y') and ((select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') != 'O')) --New
                        begin
                            select  @EMCode = case when @AGE < 1 then 99381
                                                   when @AGE between 1 and 4
                                                   then 99382
                                                   when @AGE between 5 and 11
                                                   then 99383
                                                   when @AGE between 12 and 17
                                                   then 99384
                                                   when @AGE between 18 and 39
                                                   then 99385
                                                   when @AGE between 40 and 64
                                                   then 99386
                                                   when @AGE >= 65 then 99387
                                              end;
                        end;
                    else	--Existing
                        begin
                            select  @EMCode = case when @AGE < 1 then 99391
                                                   when @AGE between 1 and 4
                                                   then 99392
                                                   when @AGE between 5 and 11
                                                   then 99393
                                                   when @AGE between 12 and 17
                                                   then 99394
                                                   when @AGE between 18 and 39
                                                   then 99395
                                                   when @AGE between 40 and 64
                                                   then 99396
                                                   when @AGE >= 65 then 99397
                                              end;
                        end;
                end;
            else if (@TemplateType = 'T')
			begin
			        if (( isnull(@PatientType, 'New') = 'New'  or (select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') = 'Y') and ((select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') != 'O')) --New
                        begin
                            select  @EMCode = case when @FaceTime < 20 
												   then 99201
                                                   when @FaceTime >= 20 and @FaceTime < 30
                                                   then 99202
                                                   when @FaceTime >= 30 and @FaceTime < 45
                                                   then 99203
                                                   when @FaceTime >= 45 and @FaceTime < 60
                                                   then 99204
                                                   when @FaceTime >= 60
                                                   then 99205
                                              end;
                        end;
                    else	--Existing
                        begin
                            select  @EMCode = case when @FaceTime < 10 
												   then 99211
                                                   when @FaceTime >= 10 and @FaceTime < 15
                                                   then 99212
                                                   when @FaceTime >= 15 and @FaceTime < 25
                                                   then 99213
                                                   when @FaceTime >= 25 and @FaceTime < 40
                                                   then 99214
                                                   when @FaceTime >= 40
                                                   then 99215
                                              end;
                        end;							
			end
			else
                begin
			
--Setup Matrix
                    declare @Matrix table
                        (
                          Component varchar(50)
                        , [Option] varchar(100)
                        , [Weight] int
                        , [CPTCode] int
                        , [HCPTCode] int
                        , [Earned] int
                        );

                    insert  @Matrix
                            ( Component, [Option], [Weight], CPTCode, HCPTCode)
                    values  ( 'History', 'N/A', 0, 99211, 0 )
				,           ( 'History', 'Problem Focused', 1, 99212, 99231 )
				,           ( 'History', 'Expanded Problem Focused', 2, 99213, 99232 )
				,           ( 'History', 'Detailed', 3, 99214, 99233)
				,           ( 'History', 'Comprehensive', 4, 99215, 99233)
				,           ( 'Exam', 'N/A', 0, 99211, 0 )
				,           ( 'Exam', 'Problem Focused', 1, 99212, 99231 )
				,           ( 'Exam', 'Expanded Problem Focused', 2, 99213, 99232 )
				,           ( 'Exam', 'Detailed', 3, 99214, 99233)
				,           ( 'Exam', 'Comprehensive', 4, 99215, 99233 )
				,           ( 'Assessment', 'N/A', 0, 99211, 0 )
				,           ( 'Assessment', 'Straight forward', 1, 99212, 99231 )
				,           ( 'Assessment', 'Low', 2, 99213, 99231 )
				,           ( 'Assessment', 'Moderate', 3, 99214, 99232 )
				,           ( 'Assessment', 'High', 4, 99215, 99233 );

                    
			        if (( isnull(@PatientType, 'New') = 'New'  or (select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') = 'Y') and ((select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') != 'O')) --New
                                begin 
                                    delete  from @Matrix;
                                    insert  @Matrix
                                            ( Component, [Option], [Weight], CPTCode, HCPTCode )
                                    values  ( 'History', 'N/A', 0, 0, 0 )
				,                           ( 'History', 'Problem Focused', 1,99201, 0)
				,                           ( 'History', 'Expanded Problem Focused', 2, 99202, 0 )
				,                           ( 'History', 'Detailed', 3, 99203, 99221)
				,                           ( 'History', 'Comprehensive', 4, 99204, 99222)
				,                           ( 'History', 'Comprehensive', 5, 99205, 99223)
				,                           ( 'Exam', 'N/A', 0, 0, 0)
				,                           ( 'Exam', 'Problem Focused', 1, 99201, 0)
				,                           ( 'Exam', 'Expanded Problem Focused', 2, 99202, 0)
				,                           ( 'Exam', 'Detailed', 3, 99203, 99221)
				,                           ( 'Exam', 'Comprehensive', 4, 99204, 99222)
				,                           ( 'Exam', 'Comprehensive', 5, 99205, 99223)
				,                           ( 'Assessment', 'N/A', 0, 0, 0)
				,                           ( 'Assessment', 'Straight forward', 1, 99201, 99221)
				,                           ( 'Assessment', 'Straight forward', 2, 99202, 99221)
				,                           ( 'Assessment', 'Low', 3, 99203, 99221)
				,                           ( 'Assessment', 'Moderate', 4, 99204, 99222)
				,                           ( 'Assessment', 'High', 5, 99205, 99223);

                                end;
                    
                    update  @Matrix
                    set     Earned = 1
                    where   ( Component = 'History'
                              and [Option] = @History
                            )
                            or ( Component = 'Exam'
                                 and [Option] = @Exam
                               )
                            or ( Component = 'Assessment'
                                 and [Option] = @Assessment
                               )


--EMCode from CPTCode
  ;
                    with    cte_RowNumbers
                              as ( select   CPTCode
                                          , count(CPTCode) as Count
                                          , row_number() over ( order by CPTCode ) as RowNumber
                                   from     @Matrix
                                   where    Earned = 1
                                   group by CPTCode
        --order by CPTCode
                                 )
                        select  CPTCode as CPTCode
                              , max(Count) as CPTCount
                              , max(RowNumber) as RowNumber
                        into    #Results
                        from    cte_RowNumbers
                        group by CPTCode
                        order by CPTCode;

                    declare @meets int; 
                    select  @meets = count(CPTCode)
                    from    #Results;
	
			        if (( isnull(@PatientType, 'New') = 'New'  or (select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') = 'Y') and ((select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') != 'O')) --New
                        begin 
	    
                            declare @CPTCountmax int;  
                            select  @CPTCountmax = max(CPTCount)
                            from    #Results;

                            if @CPTCountmax = 3
                                begin 
                                    select top 1
                                            @EMCode = CPTCode
                                    from    #Results
                                    where   CPTCount = 3;
                                end; 
                            else
                                begin
                                    select top 1
                                            @EMCode = CPTCode
                                    from    #Results
                                    where   RowNumber = 1;  
                                end;                   
                        end; 
                    else
                             begin
                            if @meets = 1
                                begin 
                                    select top 1
                                            @EMCode = CPTCode
                                    from    #Results
                                    where   RowNumber = 1;
					
                                end;
                            else
                                if @meets = 2
                                    begin 
                                        select top 1
                                                @EMCode = CPTCode
                                        from    #Results
                                        where   CPTCount = 2;
                                    end;          
                                else
                                    if @meets = 3
                                        begin 
                                            select top 1
                                                    @EMCode = CPTCode
                                            from    #Results
                                            where   RowNumber = 2;
                                        end;          
                        end;

--HEMCode from HCPTCode

;
                    with    cte_RowNumbers
                              as ( select   HCPTCode
                                          , count(HCPTCode) as Count
                                          , row_number() over ( order by HCPTCode ) as RowNumber
                                   from     @Matrix
                                   where    Earned = 1
                                   group by HCPTCode
        --order by HCPTCode
                                 )
                        select  HCPTCode as HCPTCode
                              , max(Count) as HCPTCount
                              , max(RowNumber) as RowNumber
                        into    #HResults
                        from    cte_RowNumbers
                        group by HCPTCode
                        order by HCPTCode;

                    declare @Hmeets int; 
                    select  @Hmeets = count(HCPTCode)
                    from    #HResults;
	
			        if (( isnull(@PatientType, 'New') = 'New'  or (select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') = 'Y') and ((select Value from dbo.SystemConfigurationKeys as sck where  sck.[Key] = 'EMCodeCalculationForNewPatient') != 'O')) --New
                        begin 
	    
                            declare @HCPTCountmax int;  
                            select  @HCPTCountmax = max(HCPTCount)
                            from    #HResults;

                            if @HCPTCountmax = 3
                                begin 
                                    select top 1
                                            @HEMCode = HCPTCode
                                    from    #HResults
                                    where   HCPTCount = 3;
                                end; 
                            else
                                begin
                                    select top 1
                                            @HEMCode = HCPTCode
                                    from    #HResults
                                    where   RowNumber = 1;  
                                end;                   
                        end;
                    else
                        begin
                            if @Hmeets = 1
                                begin 
                                    select top 1
                                            @HEMCode = HCPTCode
                                    from    #HResults
                                    where   RowNumber = 1;
					
                                end;
                            else
                                if @Hmeets = 2
                                    begin 
                                        select top 1
                                                @HEMCode = HCPTCode
                                        from    #HResults
                                        where   HCPTCount = 2;
                                    end;          
                                else
                                    if @Hmeets = 3
                                        begin 
                                            select top 1
                                                    @HEMCode = HCPTCode
                                            from    #HResults
                                            where   RowNumber = 2;
                                        end;          
                        end;

			drop table #Results
			drop table #HResults
                end; 
				
			declare @ServiceProcedureCodeId int = ( select top 1
																s.ProcedureCodeId
													  from      dbo.DocumentVersions as dv
																join dbo.Documents as d on d.DocumentId = dv.DocumentId and dv.DocumentVersionId = @DocumentVersionId
																join dbo.Services as s on s.ServiceId = d.ServiceId
													  where     isnull(d.RecordDeleted,
																	   'N') = 'N'
																and isnull(dv.RecordDeleted,
																		  'N') = 'N'
																and isnull(s.RecordDeleted,
																		  'N') = 'N'
													);

			declare @ScheduledProcedureCodeId int
			declare @Inpatient char(1)

			select top 1 @ScheduledProcedureCodeId = ScheduledProcedureCodeId
				,@Inpatient = Inpatient
			from EMCodeProcedureCodes
			where isnull(RecordDeleted, 'N') = 'N'
				and isnull(Active, 'N') = 'Y'
				and ScheduledProcedureCodeId = @ServiceProcedureCodeId													

			if @ScheduledProcedureCodeId is null
			begin
				select top 1 @ProcedureCodeId = ProcedureCodeId
				from dbo.EMCodeProcedureCodes as ecpc
				where ecpc.EMCode = @EMCode
					and isnull(RecordDeleted, 'N') = 'N'
					and isnull(Active,'N') = 'Y'
					and EffectiveFrom <= @EffectiveDate
					and (EffectiveTo is null or EffectiveTo >= @EffectiveDate)
			end
			else if @ScheduledProcedureCodeId is not null
			begin
				if isnull(@Inpatient,'N') = 'Y' and @HEMCode is not null
				begin
					select top 1 @ProcedureCodeId = ProcedureCodeId
					from dbo.EMCodeProcedureCodes as ecpc
					where ecpc.EMCode = @HEMCode
						and isnull(RecordDeleted, 'N') = 'N'
						and isnull(Active,'N') = 'Y'
						and EffectiveFrom <= @EffectiveDate
						and (EffectiveTo is null or EffectiveTo >= @EffectiveDate)
				end 
				else if isnull(@Inpatient,'N') = 'N'
				begin
					select top 1 @ProcedureCodeId = ProcedureCodeId
					from dbo.EMCodeProcedureCodes as ecpc
					where ecpc.EMCode = @EMCode 
						and ecpc.ScheduledProcedureCodeId = @ScheduledProcedureCodeId
						and isnull(RecordDeleted, 'N') = 'N'
						and isnull(Active,'N') = 'Y'
						and EffectiveFrom <= @EffectiveDate
						and (EffectiveTo is null or EffectiveTo >= @EffectiveDate)
				end
			end			

            select  @ProcedureCodeId;

        end try

        begin catch
            declare @Error varchar(8000);

            set @Error = convert(varchar, error_number()) + '*****'
                + convert(varchar(4000), error_message()) + '*****'
                + isnull(convert(varchar, error_procedure()),
                         'ssp_CalculateEMCode') + '*****'
                + convert(varchar, error_line()) + '*****'
                + convert(varchar, error_severity()) + '*****'
                + convert(varchar, error_state());

            raiserror (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
        end catch;
    end;