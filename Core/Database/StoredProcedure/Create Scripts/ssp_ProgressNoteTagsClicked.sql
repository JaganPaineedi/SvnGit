if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_ProgressNoteTagsClicked]')
                    and type in ( N'P', N'PC' ) ) 
    drop procedure [dbo].ssp_ProgressNoteTagsClicked
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ssp_ProgressNoteTagsClicked]
/*********************************************************************************/    
/* Date			Modified By			Description									 */    
/* Oct	7 2013	Wasif Butt			Insert/Update Tags clicked on note in table	 */
/* June	4 2014 Wasif Butt			Progress Note MDM section signature changes	 */
/* June	22 2014 Wasif Butt			filling appointment details into code options*/
/* Feb 10 2017	Alok Kumar			Modified to pull Program and Time value from Primary Care Appointment to E&M Code Evaluation pop up. Ref: #692.01 Allegan - Support. */
/* 01/11/2018   Bernardin           Added RecordDeleted check to avoid duplicate record merge into "DocumentProgressNoteTags" table. Allegan - Support# 1274*/
/*********************************************************************************/
    @DocumentVersionId bigint
  , @CurrentUser varchar(30)
  , @TagsList varchar(max)
as 
    begin  
    BEGIN TRY    
   
   --declare @TagsList varchar(max)
   --set @TagsList = 'Location,Eyes O2, None'

        select  item
              , count(item) as TagClickCount
        into    #items
        from    dbo.fnSplit(@TagsList, ',') fns
        group by item

        select  nt.NoteTagId as NoteTagId
              , item as TagName
              , TagClickCount as TagClickCount
              , EMCategory
              , EMSubCategory
        into    #NoteTags
        from    #items as i
                left join dbo.NoteTags as nt on i.item = nt.TagName
                left join dbo.GlobalCodes as gc on nt.EMCategory = GlobalCodeId
                left join dbo.GlobalSubCodes as gsc on nt.EMSubCategory = GlobalSubCodeId
        where   isnull(nt.RecordDeleted, 'N') = 'N'

		--select * from #NoteTags as nt
		
        select  EMCategory
              , EMSubCategory
              , sum(TagClickCount) as ClickCount
        into    #EmCatSub
        from    #NoteTags as nt
        group by EMCategory
              , EMSubCategory

        if @DocumentVersionId > 0 
            begin

		----Chief Complaint found
  --              if exists ( select top 1
  --                                  'Y' as ChiefComplaint
  --                          from    DocumentProgressNoteTags as dpnt
  --                                  join dbo.NoteTags as nt on dpnt.NoteTagId = nt.NoteTagId
  --                                                            and nt.EMCategory = 7100
  --                                                            and nt.EMSubCategory = 6020
  --                          where   DocumentVersionId = @DocumentVersionId
  --                                  and isnull(dpnt.RecordDeleted, 'N') = 'N' ) 
  --                  select  'Y' as ChiefComplaint
  --              else 
  --                  select  'N' as ChiefComplaint


                update  dbo.DocumentProgressNoteTags
                set     RecordDeleted = 'Y'
                      , DeletedBy = @CurrentUser
                      , DeletedDate = getdate()
                where   DocumentVersionId = @DocumentVersionId;

                merge dbo.DocumentProgressNoteTags as target
                    using 
                        ( select    NoteTagId
                                  , TagName
                                  , TagClickCount
                          from      #NoteTags
                        ) as source ( NoteTagId, TagName, TagClickCount )
                    on ( target.TagName = source.TagName
                         and target.DocumentVersionId = @DocumentVersionId 
                         -- Added by Bernardin on 01/11/2018
                         and isnull(target.RecordDeleted, 'N') = 'N'
                       )
                    when matched 
                        then
			update       set
                    RecordDeleted = 'N'
                  , DeletedBy = null
                  , DeletedDate = null
                  , TagName = source.TagName
                  , TagClickCount = source.TagClickCount
                  , NoteTagId = source.NoteTagId
                    when not matched 
                        then
			insert  (
                      DocumentVersionId
                    , CreatedBy
                    , CreatedDate
                    , ModifiedBy
                    , ModifiedDate
                    , NoteTagId
                    , TagName
                    , TagClickCount
					)    values
                    ( @DocumentVersionId
                    , @CurrentUser
                    , getdate()
                    , @CurrentUser
                    , getdate()
                    , source.NoteTagId
                    , source.TagName
                    , source.TagClickCount
				    );

                select  DocumentProgressNoteTagId
                      , CreatedBy
                      , CreatedDate
                      , ModifiedBy
                      , ModifiedDate
                      , RecordDeleted
                      , DeletedDate
                      , DeletedBy
                      , DocumentVersionId
                      , NoteTagId
                      , TagName
                      , TagClickCount
                from    dbo.DocumentProgressNoteTags
                where   isnull(RecordDeleted, 'N') = 'N'

--NoteEMCodeOptions


      
                select  @DocumentVersionId as DocumentVersionId 
	/*Chief Complaint*/

	/*History of Present Illness*/
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6085 then 'Y'
                             else null
                        end as HistoryHPILocation
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6086 then 'Y'
                             else null
                        end as HistoryHPIDuration
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6087 then 'Y'
                             else null
                        end as HistoryHPIModifyingFactors
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6088 then 'Y'
                             else null
                        end as HistoryHPIContextOnset
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6089 then 'Y'
                             else null
                        end as HistoryHPIQualityNature
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6090 then 'Y'
                             else null
                        end as HistoryHPITimingFrequency
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6084 then 'Y'
                             else null
                        end as HistoryHPIAssociatedSignsSymptoms
                      , case when EMCategory = 7101
                                  and EMSubCategory = 6091 then 'Y'
                             else null
                        end as HistoryHPISeverity
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7101
                        ) as HistoryHPITotalCount 
	 /*Review of Symptoms*/
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6092 then 'Y'
                             else null
                        end as HistoryROSConstitutional
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6093 then 'Y'
                             else null
                        end as HistoryROSEarNoseMouthThroat
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6094 then 'Y'
                             else null
                        end as HistoryROSCardiovascular
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6095 then 'Y'
                             else null
                        end as HistoryROSRespiratory
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6096 then 'Y'
                             else null
                        end as HistoryROSSkin
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6097 then 'Y'
                             else null
                        end as HistoryROSPsychiatric
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6098 then 'Y'
                             else null
                        end as HistoryROSHematologicLymphatic
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6099 then 'Y'
                             else null
                        end as HistoryROSEye
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6100 then 'Y'
                             else null
                        end as HistoryROSGastrointestinal
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6101 then 'Y'
                             else null
                        end as HistoryROSGenitourinary
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6102 then 'Y'
                             else null
                        end as HistoryROSNeurological
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6103 then 'Y'
                             else null
                        end as HistoryROSEndocrine
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6104 then 'Y'
                             else null
                        end as HistoryROSAllergicImmunologic
                      , case when EMCategory = 7102
                                  and EMSubCategory = 6070 then 'Y'
                             else null
                        end as HistoryROSMusculoskeletal
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7102
                        ) as HistoryROSTotalCount
	
	/*Past History*/
                      , case when EMCategory = 7103
                                  and EMSubCategory = 6105 then 'Y'
                             else null
                        end as HistoryPHFamilyHistory
                      , case when EMCategory = 7103
                                  and EMSubCategory = 6106 then 'Y'
                             else null
                        end as HistoryPHSocialHistory
                      , case when EMCategory = 7103
                                  and EMSubCategory = 6082 then 'Y'
                             else null
                        end as HistoryPHMedicalHistory
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7103
                        ) as HistoryPHTotalCount
	
	/*Body Area*/
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6107 then 'Y'
                             else null
                        end as ExamBAHead
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6107
                        ) as ExamBAHeadCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6108 then 'Y'
                             else null
                        end as ExamBABack
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6108
                        ) as ExamBABackCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6046 then 'Y'
                             else null
                        end as ExamBANeck
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6109
                        ) as ExamBANeckCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6110 then 'Y'
                             else null
                        end as ExamBAChest
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6110
                        ) as ExamBAChestCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6111 then 'Y'
                             else null
                        end as ExamBALeftUpperExtremity
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6111
                        ) as ExamBALeftUpperExtremityCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6112 then 'Y'
                             else null
                        end as ExamBALeftLowerExtremity
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6112
                        ) as ExamBALeftLowerExtremityCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6113 then 'Y'
                             else null
                        end as ExamBARightUpperExtremity
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6113
                        ) as ExamBARightUpperExtremityCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6114 then 'Y'
                             else null
                        end as ExamBARightLowerExtremity
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6114
                        ) as ExamBARightLowerExtremityCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6052 then 'Y'
                             else null
                        end as ExamBAAbdomen
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6052
                        ) as ExamBAAbdomenCount
                      , case when EMCategory = 7104
                                  and EMSubCategory = 6053 then 'Y'
                             else null
                        end as ExamBAGenitaliaButtocks
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7104
                                    and EMSubCategory = 6053
                        ) as ExamBAGenitaliaButtocksCount


	/*Organ System*/
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6054 then 'Y'
                             else null
                        end as ExamOSConstitutional
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6054
                        ) as ExamOSConstitutionalCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6055 then 'Y'
                             else null
                        end as ExamOSEarNoseMouthThroat
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6055
                        ) as ExamOSEarNoseMouthThroatCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6056 then 'Y'
                             else null
                        end as ExamOSCardiovascular
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6056
                        ) as ExamOSCardiovascularCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6057 then 'Y'
                             else null
                        end as ExamOSRespiratory
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6057
                        ) as ExamOSRespiratoryCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6058 then 'Y'
                             else null
                        end as ExamOSSkin
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6058
                        ) as ExamOSSkinCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6059 then 'Y'
                             else null
                        end as ExamOSPsychiatric
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6059
                        ) as ExamOSPsychiatricCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6063 then 'Y'
                             else null
                        end as ExamOSHematologicLymphatic
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6063
                        ) as ExamOSHematologicLymphaticCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6064 then 'Y'
                             else null
                        end as ExamOSEyes
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6064
                        ) as ExamOSEyesCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6065 then 'Y'
                             else null
                        end as ExamOSGastrointestinal
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6065
                        ) as ExamOSGastrointestinalCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6066 then 'Y'
                             else null
                        end as ExamOSGenitourinary
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6066
                        ) as ExamOSGenitourinaryCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6067 then 'Y'
                             else null
                        end as ExamOSNeurologic
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6067
                        ) as ExamOSNeurologicCount
                      , case when EMCategory = 7105
                                  and EMSubCategory = 6068 then 'Y'
                             else null
                        end as ExamOSMusculoskeletal
                      , ( select    sum(ClickCount)
                          from      #EmCatSub
                          where     EMCategory = 7105
                                    and EMSubCategory = 6068
                        ) as ExamOSMusculoskeletalCount

	/*Data Reviewed*/
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6071 then 'Y'
                             else null
                        end as MDMDRROClinicalLabs
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6072 then 'Y'
                             else null
                        end as MDMDRROOtherTest
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6073 then 'Y'
                             else null
                        end as MDMDRObtainRecords
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6074 then 'Y'
                             else null
                        end as MDMDRRORadiologyTest
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6075 then 'Y'
                             else null
                        end as MDMDRIndependentVisualization
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6076 then 'Y'
                             else null
                        end as MDMDRDiscussion
                      , case when EMCategory = 7106
                                  and EMSubCategory = 6077 then 'Y'
                             else null
                        end as MDMDRReviewSummarize

	/*Diagnosis/Treatment Options*/

	/*Risk*/
	
	/*Other*/
                into    #EMCodeOptions
                from    #EmCatSub as ecs



                select  @DocumentVersionId as DocumentVersionId
                      , max(HistoryHPILocation) as HistoryHPILocation
                      , max(HistoryHPIDuration) as HistoryHPIDuration
                      , max(HistoryHPIModifyingFactors) as HistoryHPIModifyingFactors
                      , max(HistoryHPIContextOnset) as HistoryHPIContextOnset
                      , max(HistoryHPIQualityNature) as HistoryHPIQualityNature
                      , max(HistoryHPITimingFrequency) as HistoryHPITimingFrequency
                      , max(HistoryHPIAssociatedSignsSymptoms) as HistoryHPIAssociatedSignsSymptoms
                      , max(HistoryHPISeverity) as HistoryHPISeverity
                      , max(HistoryHPITotalCount) as HistoryHPITotalCount
                      , max(HistoryROSConstitutional) as HistoryROSConstitutional
                      , max(HistoryROSEarNoseMouthThroat) as HistoryROSEarNoseMouthThroat
                      , max(HistoryROSCardiovascular) as HistoryROSCardiovascular
                      , max(HistoryROSRespiratory) as HistoryROSRespiratory
                      , max(HistoryROSSkin) as HistoryROSSkin
                      , max(HistoryROSPsychiatric) as HistoryROSPsychiatric
                      , max(HistoryROSHematologicLymphatic) as HistoryROSHematologicLymphatic
                      , max(HistoryROSEye) as HistoryROSEye
                      , max(HistoryROSGastrointestinal) as HistoryROSGastrointestinal
                      , max(HistoryROSGenitourinary) as HistoryROSGenitourinary
                      , max(HistoryROSNeurological) as HistoryROSNeurological
                      , max(HistoryROSEndocrine) as HistoryROSEndocrine
                      , max(HistoryROSAllergicImmunologic) as HistoryROSAllergicImmunologic
                      , max(HistoryROSMusculoskeletal) as HistoryROSMusculoskeletal
                      , max(HistoryROSTotalCount) as HistoryROSTotalCount
                      , max(HistoryPHFamilyHistory) as HistoryPHFamilyHistory
                      , max(HistoryPHSocialHistory) as HistoryPHSocialHistory
                      , max(HistoryPHMedicalHistory) as HistoryPHMedicalHistory
                      , max(HistoryPHTotalCount) as HistoryPHTotalCount
                      , max(ExamBAHead) as ExamBAHead
                      , max(ExamBAHeadCount) as ExamBAHeadCount
                      , max(ExamBABack) as ExamBABack
                      , max(ExamBABackCount) as ExamBABackCount
                      , max(ExamBANeck) as ExamBANeck
                      , max(ExamBANeckCount) as ExamBANeckCount
                      , max(ExamBAChest) as ExamBAChest
                      , max(ExamBAChestCount) as ExamBAChestCount
                      , max(ExamBALeftUpperExtremity) as ExamBALeftUpperExtremity
                      , max(ExamBALeftUpperExtremityCount) as ExamBALeftUpperExtremityCount
                      , max(ExamBALeftLowerExtremity) as ExamBALeftLowerExtremity
                      , max(ExamBALeftLowerExtremityCount) as ExamBALeftLowerExtremityCount
                      , max(ExamBARightUpperExtremity) as ExamBARightUpperExtremity
                      , max(ExamBARightUpperExtremityCount) as ExamBARightUpperExtremityCount
                      , max(ExamBARightLowerExtremity) as ExamBARightLowerExtremity
                      , max(ExamBARightLowerExtremityCount) as ExamBARightLowerExtremityCount
                      , max(ExamBAAbdomen) as ExamBAAbdomen
                      , max(ExamBAAbdomenCount) as ExamBAAbdomenCount
                      , max(ExamBAGenitaliaButtocks) as ExamBAGenitaliaButtocks
                      , max(ExamBAGenitaliaButtocksCount) as ExamBAGenitaliaButtocksCount
                      , max(ExamOSConstitutional) as ExamOSConstitutional
                      , max(ExamOSConstitutionalCount) as ExamOSConstitutionalCount
                      , max(ExamOSEarNoseMouthThroat) as ExamOSEarNoseMouthThroat
                      , max(ExamOSEarNoseMouthThroatCount) as ExamOSEarNoseMouthThroatCount
                      , max(ExamOSCardiovascular) as ExamOSCardiovascular
                      , max(ExamOSCardiovascularCount) as ExamOSCardiovascularCount
                      , max(ExamOSRespiratory) as ExamOSRespiratory
                      , max(ExamOSRespiratoryCount) as ExamOSRespiratoryCount
                      , max(ExamOSSkin) as ExamOSSkin
                      , max(ExamOSSkinCount) as ExamOSSkinCount
                      , max(ExamOSPsychiatric) as ExamOSPsychiatric
                      , max(ExamOSPsychiatricCount) as ExamOSPsychiatricCount
                      , max(ExamOSHematologicLymphatic) as ExamOSHematologicLymphatic
                      , max(ExamOSHematologicLymphaticCount) as ExamOSHematologicLymphaticCount
                      , max(ExamOSEyes) as ExamOSEyes
                      , max(ExamOSEyesCount) as ExamOSEyesCount
                      , max(ExamOSGastrointestinal) as ExamOSGastrointestinal
                      , max(ExamOSGastrointestinalCount) as ExamOSGastrointestinalCount
                      , max(ExamOSGenitourinary) as ExamOSGenitourinary
                      , max(ExamOSGenitourinaryCount) as ExamOSGenitourinaryCount
                      , max(ExamOSNeurologic) as ExamOSNeurologic
                      , max(ExamOSNeurologicCount) as ExamOSNeurologicCount
                      , max(ExamOSMusculoskeletal) as ExamOSMusculoskeletal
                      , max(ExamOSMusculoskeletalCount) as ExamOSMusculoskeletalCount
                      , max(MDMDRROClinicalLabs) as MDMDRROClinicalLabs
                      , max(MDMDRROOtherTest) as MDMDRROOtherTest
                      , max(MDMDRObtainRecords) as MDMDRObtainRecords
                      , max(MDMDRRORadiologyTest) as MDMDRRORadiologyTest
                      , max(MDMDRIndependentVisualization) as MDMDRIndependentVisualization
                      , max(MDMDRDiscussion) as MDMDRDiscussion
                      , max(MDMDRReviewSummarize) as MDMDRReviewSummarize
                into    #NoteEMCodeOptions
                from    #EMCodeOptions

                update  neco
                set     ModifiedBy = @CurrentUser
                      , ModifiedDate = getdate()
                      , HistoryHPILocation = tempneco.HistoryHPILocation
                      , HistoryHPIDuration = tempneco.HistoryHPIDuration
                      , HistoryHPIModifyingFactors = tempneco.HistoryHPIModifyingFactors
                      , HistoryHPIContextOnset = tempneco.HistoryHPIContextOnset
                      , HistoryHPIQualityNature = tempneco.HistoryHPIQualityNature
                      , HistoryHPITimingFrequency = tempneco.HistoryHPITimingFrequency
                      , HistoryHPIAssociatedSignsSymptoms = tempneco.HistoryHPIAssociatedSignsSymptoms
                      , HistoryHPISeverity = tempneco.HistoryHPISeverity
                      , HistoryHPITotalCount = tempneco.HistoryHPITotalCount
      --, HistoryHPIResults = tempneco.HistoryHPIResults
                      , HistoryROSConstitutional = tempneco.HistoryROSConstitutional
                      , HistoryROSEarNoseMouthThroat = tempneco.HistoryROSEarNoseMouthThroat
                      , HistoryROSCardiovascular = tempneco.HistoryROSCardiovascular
                      , HistoryROSRespiratory = tempneco.HistoryROSRespiratory
                      , HistoryROSSkin = tempneco.HistoryROSSkin
                      , HistoryROSPsychiatric = tempneco.HistoryROSPsychiatric
                      , HistoryROSHematologicLymphatic = tempneco.HistoryROSHematologicLymphatic
                      , HistoryROSEye = tempneco.HistoryROSEye
                      , HistoryROSGastrointestinal = tempneco.HistoryROSGastrointestinal
                      , HistoryROSGenitourinary = tempneco.HistoryROSGenitourinary
                      , HistoryROSMusculoskeletal = tempneco.HistoryROSMusculoskeletal
                      , HistoryROSNeurological = tempneco.HistoryROSNeurological
                      , HistoryROSEndocrine = tempneco.HistoryROSEndocrine
                      , HistoryROSAllergicImmunologic = tempneco.HistoryROSAllergicImmunologic
                      , HistoryROSTotalCount = tempneco.HistoryROSTotalCount
      --, HistoryROSResults = tempneco.HistoryROSResults
                      , HistoryPHFamilyHistory = tempneco.HistoryPHFamilyHistory
                      , HistoryPHSocialHistory = tempneco.HistoryPHSocialHistory
                      , HistoryPHMedicalHistory = tempneco.HistoryPHMedicalHistory
                      , HistoryPHTotalCount = tempneco.HistoryPHTotalCount
      --, HistoryPHResults = tempneco.HistoryPHResults
      --, HistoryFinalResult = tempneco.HistoryFinalResult
                      , ExamBAHead = tempneco.ExamBAHead
                      , ExamBABack = tempneco.ExamBABack
                      , ExamBALeftUpperExtremity = tempneco.ExamBALeftUpperExtremity
                      , ExamBALeftLowerExtremity = tempneco.ExamBALeftLowerExtremity
                      , ExamBAAbdomen = tempneco.ExamBAAbdomen
                      , ExamBANeck = tempneco.ExamBANeck
                      , ExamBAChest = tempneco.ExamBAChest
                      , ExamBARightUpperExtremity = tempneco.ExamBARightUpperExtremity
                      , ExamBARightLowerExtremity = tempneco.ExamBARightLowerExtremity
                      , ExamBAGenitaliaButtocks = tempneco.ExamBAGenitaliaButtocks
                      , ExamOSConstitutional = tempneco.ExamOSConstitutional
                      , ExamOSEyes = tempneco.ExamOSEyes
                      , ExamOSEarNoseMouthThroat = tempneco.ExamOSEarNoseMouthThroat
                      , ExamOSCardiovascular = tempneco.ExamOSCardiovascular
                      , ExamOSRespiratory = tempneco.ExamOSRespiratory
                      , ExamOSPsychiatric = tempneco.ExamOSPsychiatric
                      , ExamOSGastrointestinal = tempneco.ExamOSGastrointestinal
                      , ExamOSGenitourinary = tempneco.ExamOSGenitourinary
                      , ExamOSMusculoskeletal = tempneco.ExamOSMusculoskeletal
                      , ExamOSSkin = tempneco.ExamOSSkin
                      , ExamOSNeurologic = tempneco.ExamOSNeurologic
                      , ExamOSHematologicLymphatic = tempneco.ExamOSHematologicLymphatic
      --, ExamTypeOfExam = tempneco.ExamTypeOfExam
      --, ExamFinalResult = tempneco.ExamFinalResult
      --, MDMDRROClinicalLabs = tempneco.MDMDRROClinicalLabs
      --, MDMDRROOtherTest = tempneco.MDMDRROOtherTest
      --, MDMDRObtainRecords = tempneco.MDMDRObtainRecords
      --, MDMDRIndependentVisualization = tempneco.MDMDRIndependentVisualization
      --, MDMDRRORadiologyTest = tempneco.MDMDRRORadiologyTest
      --, MDMDRDiscussion = tempneco.MDMDRDiscussion
      --, MDMDRReviewSummarize = tempneco.MDMDRReviewSummarize
      --, MDMDRResults = tempneco.MDMDRResults
      --, MDMDTONewProblem = tempneco.MDMDTONewProblem
      --, MDMDTOProblems1 = tempneco.MDMDTOProblems1
      --, MDMDTOProblems2 = tempneco.MDMDTOProblems2
      --, MDMDTOProblems3 = tempneco.MDMDTOProblems3
      --, MDMDTOProblems4Plus = tempneco.MDMDTOProblems4Plus
      --, MDMDTOAdditionalWorkup = tempneco.MDMDTOAdditionalWorkup
      --, MDMDTOProblemWorsening1 = tempneco.MDMDTOProblemWorsening1
      --, MDMDTOProblemWorsening2 = tempneco.MDMDTOProblemWorsening2
      --, MDMDTOResults = tempneco.MDMDTOResults
      --, MDMRCMMMajorProblems0 = tempneco.MDMRCMMMajorProblems0
      --, MDMRCMMMajorProblems1 = tempneco.MDMRCMMMajorProblems1
      --, MDMRCMMMajorProblems2Plus = tempneco.MDMRCMMMajorProblems2Plus
      --, MDMRCMMOtherProblems0to1 = tempneco.MDMRCMMOtherProblems0to1
      --, MDMRCMMOtherProblems2Plus = tempneco.MDMRCMMOtherProblems2Plus
      --, MDMRCMMPrescriptionMedication = tempneco.MDMRCMMPrescriptionMedication
      --, MDMRCMMProblemWorsening = tempneco.MDMRCMMProblemWorsening
      --, MDMRCMMThreatToLife = tempneco.MDMRCMMThreatToLife
      --, MDMRCMMResults = tempneco.MDMRCMMResults
      --, MDMFinalResult = tempneco.MDMFinalResult
      --, ECEEMCode = tempneco.ECEEMCode
      --, ECEGuidelines = tempneco.ECEGuidelines
      --, ECETypeOfPatient = tempneco.ECETypeOfPatient
      --, ECEVisitType = tempneco.ECEVisitType
      --, ECE50PercentFaceTime = tempneco.ECE50PercentFaceTime
      --, ECEMinutes = tempneco.ECEMinutes
      --, ECAQChronicProblemsAddressed3Plus = tempneco.ECAQChronicProblemsAddressed3Plus
      --, ECAQAdditionalWorkup = tempneco.ECAQAdditionalWorkup
      --, ECAQProblemWorsening1 = tempneco.ECAQProblemWorsening1
      --, ECAQProblemWorsening2 = tempneco.ECAQProblemWorsening2
      --, ECAQIllnessWithExacerbation = tempneco.ECAQIllnessWithExacerbation
      --, ECAQDiscussion = tempneco.ECAQDiscussion
      --, ECAQObtainRecords = tempneco.ECAQObtainRecords
      --, ECAQIndependentVisualization = tempneco.ECAQIndependentVisualization
      --, ECAQReviewSummarize = tempneco.ECAQReviewSummarize
                      , ExamBAHeadCount = tempneco.ExamBAHeadCount
      --, ExamBAHeadTotalCount = tempneco.ExamBAHeadTotalCount
                      , ExamBABackCount = tempneco.ExamBABackCount
      --, ExamBABackTotalCount = tempneco.ExamBABackTotalCount
                      , ExamBALeftUpperExtremityCount = tempneco.ExamBALeftUpperExtremityCount
      --, ExamBALeftUpperExtremityTotalCount = tempneco.ExamBALeftUpperExtremityTotalCount
                      , ExamBALeftLowerExtremityCount = tempneco.ExamBALeftLowerExtremityCount
      --, ExamBALeftLowerExtremityTotalCount = tempneco.ExamBALeftLowerExtremityTotalCount
                      , ExamBAAbdomenCount = tempneco.ExamBAAbdomenCount
      --, ExamBAAbdomenTotalCount = tempneco.ExamBAAbdomenTotalCount
                      , ExamBANeckCount = tempneco.ExamBANeckCount
      --, ExamBANeckTotalCount = tempneco.ExamBANeckTotalCount
                      , ExamBAChestCount = tempneco.ExamBAChestCount
      --, ExamBAChestTotalCount = tempneco.ExamBAChestTotalCount
                      , ExamBARightUpperExtremityCount = tempneco.ExamBARightUpperExtremityCount
      --, ExamBARightUpperExtremityTotalCount = tempneco.ExamBARightUpperExtremityTotalCount
                      , ExamBARightLowerExtremityCount = tempneco.ExamBARightLowerExtremityCount
      --, ExamBARightLowerExtremityTotalCount = tempneco.ExamBARightLowerExtremityTotalCount
                      , ExamBAGenitaliaButtocksCount = tempneco.ExamBAGenitaliaButtocksCount
      --, ExamBAGenitaliaButtocksTotalCount = tempneco.ExamBAGenitaliaButtocksTotalCount
                      , ExamOSConstitutionalCount = tempneco.ExamOSConstitutionalCount
      --, ExamOSConstitutionalTotalCount = tempneco.ExamOSConstitutionalTotalCount
                      , ExamOSEyesCount = tempneco.ExamOSEyesCount
      --, ExamOSEyesTotalCount = tempneco.ExamOSEyesTotalCount
                      , ExamOSEarNoseMouthThroatCount = tempneco.ExamOSEarNoseMouthThroatCount
      --, ExamOSEarNoseMouthThroatTotalCount = tempneco.ExamOSEarNoseMouthThroatTotalCount
                      , ExamOSCardiovascularCount = tempneco.ExamOSCardiovascularCount
      --, ExamOSCardiovascularTotalCount = tempneco.ExamOSCardiovascularTotalCount
                      , ExamOSRespiratoryCount = tempneco.ExamOSRespiratoryCount
      --, ExamOSRespiratoryTotalCount = tempneco.ExamOSRespiratoryTotalCount
                      , ExamOSPsychiatricCount = tempneco.ExamOSPsychiatricCount
      --, ExamOSPsychiatricTotalCount = tempneco.ExamOSPsychiatricTotalCount
                      , ExamOSGastrointestinalCount = tempneco.ExamOSGastrointestinalCount
      --, ExamOSGastrointestinalTotalCount = tempneco.ExamOSGastrointestinalTotalCount
                      , ExamOSGenitourinaryCount = tempneco.ExamOSGenitourinaryCount
      --, ExamOSGenitourinaryTotalCount = tempneco.ExamOSGenitourinaryTotalCount
                      , ExamOSMusculoskeletalCount = tempneco.ExamOSMusculoskeletalCount
      --, ExamOSMusculoskeletalTotalCount = tempneco.ExamOSMusculoskeletalTotalCount
                      , ExamOSSkinCount = tempneco.ExamOSSkinCount
      --, ExamOSSkinTotalCount = tempneco.ExamOSSkinTotalCount
                      , ExamOSNeurologicCount = tempneco.ExamOSNeurologicCount
      --, ExamOSNeurologicTotalCount = tempneco.ExamOSNeurologicTotalCount
                      , ExamOSHematologicLymphaticCount = tempneco.ExamOSHematologicLymphaticCount
      --, ExamOSHematologicLymphaticTotalCount = tempneco.ExamOSHematologicLymphaticTotalCount
                from    #NoteEMCodeOptions as tempneco
                        join dbo.NoteEMCodeOptions as neco on tempneco.DocumentVersionId = neco.DocumentVersionId
                where   neco.DocumentVersionId = @DocumentVersionId
                        and isnull(RecordDeleted, 'N') = 'N'

                declare @StartTime datetime
                  , @EndTime datetime
				, @LocationId int                
				, @ProgramId int
				, @PrimaryCareAppointmentsStatus int = 0            

                select  @StartTime = StartTime
                      , @EndTime = EndTime
					  , @locationId = LocationId
					  , @ProgramId = ProgramId
                from    NoteEMCodeOptions
                where   DocumentVersionId = @DocumentVersionId
                        and isnull(RecordDeleted, 'N') = 'N'
                if ( @StartTime is null
                     or @EndTime is null
                     or @LocationId is null
                     or @ProgramId is null
                   ) 
                    begin
                    
						--Feb 10 2017	Alok Kumar
						If Exists(Select 1 From dbo.SystemConfigurationKeys Where [Key]='SETSTATUSFORPRIMARYCAREAPPOINTMENTS' And IsNull(RecordDeleted, 'N') = 'N' AND Value Is Not Null)
						Begin
							Set @PrimaryCareAppointmentsStatus = Cast((Select Top 1 Value From dbo.SystemConfigurationKeys Where [Key]='SETSTATUSFORPRIMARYCAREAPPOINTMENTS' And IsNull(RecordDeleted, 'N') = 'N' AND Value Is Not Null) as Int)
						End

                        update  neco
                        set     StartTime = CASE When ( @PrimaryCareAppointmentsStatus > 0 And @PrimaryCareAppointmentsStatus = a.Status) 
														Then (Select Top 1 PCASH.[Time] From dbo.PrimaryCareAppointmentsStatusHistory PCASH Where PCASH.PrimaryCareAppointmentId = a.AppointmentId And PCASH.[Status] = @PrimaryCareAppointmentsStatus And IsNull(PCASH.RecordDeleted, 'N') = 'N')
												Else a.StartTime
											END
                              , EndTime = a.EndTime
							  , LocationId = a.LocationId
							  --, ProgramId = a.PrimaryProgramId --This to be changed once appointments datamodel is updated for primary care.
							  , ProgramId = CASE When ( @PrimaryCareAppointmentsStatus > 0 ) Then a.ProgramId
												Else (select top 1 IntegerCodeId from dbo.ssf_RecodeValuesCurrent('AutoFillPrimaryCareProgram'))
											END
                        from    dbo.NoteEMCodeOptions as neco
                                join documents d on neco.DocumentVersionId = d.CurrentDocumentVersionId
                                left join appointments a on d.AppointmentId = a.AppointmentId
                        where   neco.DocumentVersionId = @DocumentVersionId
                                and isnull(neco.RecordDeleted, 'N') = 'N'
                                and isnull(d.RecordDeleted, 'N') = 'N'
                                and isnull(a.RecordDeleted, 'N') = 'N'

                    end

                select  neco.NoteEMCodeOptionId
                      , neco.CreatedBy
                      , neco.CreatedDate
                      , neco.ModifiedBy
                      , neco.ModifiedDate
                      , neco.RecordDeleted
                      , neco.DeletedDate
                      , neco.DeletedBy
                      , neco.DocumentVersionId
                      , neco.ProcedureCodeId
                      , neco.ModifierId1
                      , neco.ModifierId2
                      , neco.ModifierId3
                      , neco.ModifierId4
                      , neco.ProgramId
					  , LocationId
					  , StartTime
					  , EndTime
                      , neco.HistoryHPILocation
                      , neco.HistoryHPIDuration
                      , neco.HistoryHPIModifyingFactors
                      , neco.HistoryHPIContextOnset
                      , neco.HistoryHPIQualityNature
                      , neco.HistoryHPITimingFrequency
                      , neco.HistoryHPIAssociatedSignsSymptoms
                      , neco.HistoryHPISeverity
                      , neco.HistoryHPITotalCount
                      , neco.HistoryHPIResults
                      , neco.HistoryROSConstitutional
                      , neco.HistoryROSEarNoseMouthThroat
                      , neco.HistoryROSCardiovascular
                      , neco.HistoryROSRespiratory
                      , neco.HistoryROSSkin
                      , neco.HistoryROSPsychiatric
                      , neco.HistoryROSHematologicLymphatic
                      , neco.HistoryROSEye
                      , neco.HistoryROSGastrointestinal
                      , neco.HistoryROSGenitourinary
                      , neco.HistoryROSMusculoskeletal
                      , neco.HistoryROSNeurological
                      , neco.HistoryROSEndocrine
                      , neco.HistoryROSAllergicImmunologic
                      , neco.HistoryROSTotalCount
                      , neco.HistoryROSResults
                      , neco.HistoryPHFamilyHistory
                      , neco.HistoryPHSocialHistory
                      , neco.HistoryPHMedicalHistory
                      , neco.HistoryPHTotalCount
                      , neco.HistoryPHResults
                      , neco.HistoryFinalResult
                      , neco.ExamBAHead
                      , neco.ExamBABack
                      , neco.ExamBALeftUpperExtremity
                      , neco.ExamBALeftLowerExtremity
                      , neco.ExamBAAbdomen
                      , neco.ExamBANeck
                      , neco.ExamBAChest
                      , neco.ExamBARightUpperExtremity
                      , neco.ExamBARightLowerExtremity
                      , neco.ExamBAGenitaliaButtocks
                      , neco.ExamOSConstitutional
                      , neco.ExamOSEyes
                      , neco.ExamOSEarNoseMouthThroat
                      , neco.ExamOSCardiovascular
                      , neco.ExamOSRespiratory
                      , neco.ExamOSPsychiatric
                      , neco.ExamOSGastrointestinal
                      , neco.ExamOSGenitourinary
                      , neco.ExamOSMusculoskeletal
                      , neco.ExamOSSkin
                      , neco.ExamOSNeurologic
                      , neco.ExamOSHematologicLymphatic
                      , neco.ExamTypeOfExam
                      , neco.ExamFinalResult
                      , neco.MDMDRROClinicalLabs
                      , neco.MDMDRROOtherTest
                      , neco.MDMDRObtainRecords
                      , neco.MDMDRIndependentVisualization
                      , neco.MDMDRRORadiologyTest
                      , neco.MDMDRDiscussion
                      , neco.MDMDRReviewSummarize
                      , neco.MDMDRResults
                      , neco.MDMDTONewProblem
                      , neco.MDMDTOProblems1
                      , neco.MDMDTOProblems2
                      , neco.MDMDTOProblems3
                      , neco.MDMDTOProblems4Plus
                      , neco.MDMDTOAdditionalWorkup
                      , neco.MDMDTOProblemWorsening1
                      , neco.MDMDTOProblemWorsening2
                      , neco.MDMDTOResults
                      , neco.MDMRCMMResults
                      , neco.MDMFinalResult
                      , neco.ECEEMCode
                      , neco.ECEGuidelines
                      , neco.ECETypeOfPatient
                      , neco.ECEVisitType
                      , neco.ECE50PercentFaceTime
                      , neco.ECEMinutes
                      , neco.ECAQChronicProblemsAddressed3Plus
                      , neco.ECAQAdditionalWorkup
                      , neco.ECAQProblemWorsening1
                      , neco.ECAQProblemWorsening2
                      , neco.ECAQIllnessWithExacerbation
                      , neco.ECAQDiscussion
                      , neco.ECAQObtainRecords
                      , neco.ECAQIndependentVisualization
                      , neco.ECAQReviewSummarize
                      , neco.ExamBAHeadCount
                      , neco.ExamBAHeadTotalCount
                      , neco.ExamBABackCount
                      , neco.ExamBABackTotalCount
                      , neco.ExamBALeftUpperExtremityCount
                      , neco.ExamBALeftUpperExtremityTotalCount
                      , neco.ExamBALeftLowerExtremityCount
                      , neco.ExamBALeftLowerExtremityTotalCount
                      , neco.ExamBAAbdomenCount
                      , neco.ExamBAAbdomenTotalCount
                      , neco.ExamBANeckCount
                      , neco.ExamBANeckTotalCount
                      , neco.ExamBAChestCount
                      , neco.ExamBAChestTotalCount
                      , neco.ExamBARightUpperExtremityCount
                      , neco.ExamBARightUpperExtremityTotalCount
                      , neco.ExamBARightLowerExtremityCount
                      , neco.ExamBARightLowerExtremityTotalCount
                      , neco.ExamBAGenitaliaButtocksCount
                      , neco.ExamBAGenitaliaButtocksTotalCount
                      , neco.ExamOSConstitutionalCount
                      , neco.ExamOSConstitutionalTotalCount
                      , neco.ExamOSEyesCount
                      , neco.ExamOSEyesTotalCount
                      , neco.ExamOSEarNoseMouthThroatCount
                      , neco.ExamOSEarNoseMouthThroatTotalCount
                      , neco.ExamOSCardiovascularCount
                      , neco.ExamOSCardiovascularTotalCount
                      , neco.ExamOSRespiratoryCount
                      , neco.ExamOSRespiratoryTotalCount
                      , neco.ExamOSPsychiatricCount
                      , neco.ExamOSPsychiatricTotalCount
                      , neco.ExamOSGastrointestinalCount
                      , neco.ExamOSGastrointestinalTotalCount
                      , neco.ExamOSGenitourinaryCount
                      , neco.ExamOSGenitourinaryTotalCount
                      , neco.ExamOSMusculoskeletalCount
                      , neco.ExamOSMusculoskeletalTotalCount
                      , neco.ExamOSSkinCount
                      , neco.ExamOSSkinTotalCount
                      , neco.ExamOSNeurologicCount
                      , neco.ExamOSNeurologicTotalCount
                      , neco.ExamOSHematologicLymphaticCount
                      , neco.ExamOSHematologicLymphaticTotalCount
                      , neco.MDMRCMMPPMinorOtherProb1
                      , neco.MDMRCMMPPMinorOtherProb2Plus
                      , neco.MDMRCMMPPStableChronicMajor1
                      , neco.MDMRCMMPPChronicMajorMildExac1Plus
                      , neco.MDMRCMMPPAcuteUncomplicated1
                      , neco.MDMRCMMPPNewProblem
                      , neco.MDMRCMMPPAcuteIllness
                      , neco.MDMRCMMPPAcuteComplicatedInjury
                      , neco.MDMRCMMPPChronicMajorSevereExac1Plus
                      , neco.MDMRCMMPPAcuteChronicThreat
                      , neco.MDMRCMMDLabVenipuncture
                      , neco.MDMRCMMDNonCardImaging
                      , neco.MDMRCMMDPhysTestNoStress
                      , neco.MDMRCMMDPhysTestYesStress
                      , neco.MDMRCMMDSkinBiopsies
                      , neco.MDMRCMMDDeepNeedle
                      , neco.MDMRCMMDDiagEndoNoRisk
                      , neco.MDMRCMMDDiagEndoYesRisk
                      , neco.MDMRCMMDCardImagingNoRisk
                      , neco.MDMRCMMDCardImagingYesRisk
                      , neco.MDMRCMMDClinicalLab
                      , neco.MDMRCMMDObtainFluid
                      , neco.MDMRCMMDCardiacElectro
                      , neco.MDMRCMMDDiscopgraphy
                      , neco.MDMRCMMMOSMedicationManagement
                from    dbo.NoteEMCodeOptions as neco
                where   neco.DocumentVersionId = @DocumentVersionId
                        and isnull(neco.RecordDeleted, 'N') = 'N'

            end
      
  END TRY 
    --Checking For Errors                                         
  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                  + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                  + '*****' 
                  + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                  'ssp_ProgressNoteTagsClicked') 
                  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                  + '*****ERROR_SEVERITY=' 
                  + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                  + '*****ERROR_STATE=' 
                  + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR (@Error /* Message text*/,16 /*Severity*/,1/*State*/ ) 
  END CATCH 
 END





	