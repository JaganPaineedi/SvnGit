/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomPreventionServicesNote]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomPreventionServicesNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomPreventionServicesNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomPreventionServicesNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE PROCEDURE [dbo].[csp_conv_Document_CustomPreventionServicesNote]
AS 
    INSERT  INTO dbo.CustomPreventionServicesNote
            ( DocumentVersionId ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              PatientName ,
              DateOfService ,
              StaffName ,
              Degree ,
              BeginTime ,
              Duration ,
              DurationType ,
              ProcedureCode ,
              ParticipantsNumber ,
              LocationID ,
              ClassroomNumber ,
              QuarterOfYear ,
              WeekNumber ,
              SessionNumber ,
              Score ,
              Guarded ,
              UnderInfluance ,
              Cooperative ,
              Hallucinations ,
              Withdrawn ,
              Provocative ,
              Pleasant ,
              Delusions ,
              NonCompliant ,
              Manipulative ,
              Hyperactive ,
              NotObservedBehavior ,
              Hostile ,
              Suspicious ,
              Hypoactive ,
              OtherBehavior ,
              OtherBehaviorDescription ,
              Appropriate ,
              Euphoric ,
              Angry ,
              Depressed ,
              Incongruent ,
              Flat ,
              Suicidal ,
              Fearful ,
              NotObservedMood ,
              Anxious ,
              Irritable ,
              OtherMood ,
              OtherMoodDescription ,
              OutcomesUsed ,
              Intervention ,
              ClientResponse ,
              ProgressRating
            )
            SELECT  dvm.DocumentVersionId ,
                    d.orig_user_id ,
                    d.orig_entry_chron ,
                    d.user_id ,
                    d.entry_chron ,
                    entry_chron patient_name ,
                    date_of_service ,
                    staff_name ,
                    degree ,
                    begin_time ,
                    duration ,
                    duration_type ,
                    proc_code ,
                    num_participants ,
                    CCML.locationid ,
                    classroom_no ,
                    quarter_of_yr ,
                    week_no ,
                    session_no ,
                    score ,
                    guarded ,
                    under_influence ,
                    cooperative ,
                    hallucinations ,
                    withdrawn ,
                    provocative ,
                    pleasant ,
                    delusions ,
                    non_compliant ,
                    manipulative ,
                    hyperactive ,
                    not_observed_behavior ,
                    hostile ,
                    suspicious ,
                    hypoactive ,
                    other_behavior ,
                    other_behavior_desc ,
                    appropriate ,
                    euphoric ,
                    angry ,
                    depressed ,
                    incongruent ,
                    flat ,
                    suicidal ,
                    fearful ,
                    not_observed_mood ,
                    anxious ,
                    irritable ,
                    other_mood ,
                    other_mood_desc ,
                    outcomes_used ,
                    intervention ,
                    client_response ,
                    progress_rating
            FROM    Psych..cstm_doc_prev_services d
                    LEFT JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
                    LEFT JOIN dbo.Cstm_Conv_Map_Locations CCML ON d.location = CCML.location_code
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   CustomActivityNotes c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )  
					
                    AND NOT EXISTS ( SELECT *
                                     FROM   Cstm_Conv_Map_Exclude_Documents ed
                                     WHERE  ed.doc_session_no = d.doc_session_no )    
    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_CustomPreventionServicesNote''


' 
END
GO
