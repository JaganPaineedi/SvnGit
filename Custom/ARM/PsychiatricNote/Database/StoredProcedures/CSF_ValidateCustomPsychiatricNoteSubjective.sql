IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  NAME = 'CSF_ValidateCustomPsychiatricNoteSubjective') 
  DROP FUNCTION [dbo].csf_validatecustompsychiatricnotesubjective 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE FUNCTION Csf_validatecustompsychiatricnotesubjective (@DocumentVersionId 
INT, @TDocumentType CHAR(1)) 
returns @validationReturnTable TABLE( 
  tablename       VARCHAR(100) NULL, 
  columnname      VARCHAR(100) NULL, 
  errormessage    VARCHAR(max) NULL, 
  taborder        INT NULL, 
  validationorder INT NULL) 
  BEGIN 
      DECLARE @TabOrder INT = 1 
      DECLARE @ValidationOrder INT = 55 
      DECLARE @ProblemNumber INT = 0 
      DECLARE @TwoItemCount INT = 0 
      DECLARE @AssociatedSymptomsText VARCHAR(250) 
      DECLARE @SubjectiveText                   VARCHAR(max), 
              @TypeOfProblem                    INT, 
              @Severity                         INT, 
              @Duration                         INT, 
              @TimeOfDayAllday                  CHAR(1), 
              @TimeOfDayMorning                 CHAR(1), 
              @TimeOfDayAfternoon               CHAR(1), 
              @TimeOfDayNight                   CHAR(1), 
              @LocationHome                     CHAR(1), 
              @LocationSchool                   CHAR(1), 
              @LocationWork                     CHAR(1), 
              @LocationEveryWhere               CHAR(1), 
              @LocationOther                    CHAR(1), 
              @LocationOtherText                VARCHAR(max), 
              @AssociatedSignsSymptoms          INT, 
              @ModifyingFactors                 VARCHAR(max), 
              @AssociatedSignsSymptomsOtherText VARCHAR(max), 
              @ProblemStatus                    INT, 
              @DiscussLongActingInjectable      CHAR(1), 
              @ProblemMDMComments               VARCHAR(max), 
              @ICD10Code                        VARCHAR(max), 
              @ContextText                      VARCHAR(max) 
      DECLARE fa_cursor CURSOR fast_forward FOR 
        SELECT subjectivetext, 
               typeofproblem, 
               severity, 
               duration, 
               timeofdayallday, 
               timeofdaymorning, 
               timeofdayafternoon, 
               timeofdaynight, 
               locationhome, 
               locationschool, 
               locationwork, 
               locationeverywhere, 
               locationother, 
               locationothertext, 
               associatedsignssymptoms, 
               modifyingfactors, 
               associatedsignssymptomsothertext, 
               problemstatus, 
               discusslongactinginjectable, 
               problemmdmcomments, 
               icd10code, 
               contexttext 
        FROM   custompsychiatricnoteproblems 
        WHERE  documentversionid = @DocumentVersionId 
               AND Isnull(recorddeleted, 'N') = 'N' 
        ORDER  BY psychiatricnoteproblemid ASC 

      OPEN fa_cursor 

      FETCH next FROM fa_cursor INTO @SubjectiveText, @TypeOfProblem, @Severity, 
      @Duration, @TimeOfDayAllday, @TimeOfDayMorning, @TimeOfDayAfternoon, 
      @TimeOfDayNight, @LocationHome, @LocationSchool, @LocationWork, 
      @LocationEveryWhere, @LocationOther, @LocationOtherText, 
      @AssociatedSignsSymptoms, @ModifyingFactors, 
      @AssociatedSignsSymptomsOtherText, @ProblemStatus, 
      @DiscussLongActingInjectable, @ProblemMDMComments, @ICD10Code, 
      @ContextText 

      WHILE @@FETCH_STATUS = 0 
        BEGIN 
            SET @ProblemNumber = @ProblemNumber + 1 

            IF Isnull(@SubjectiveText, '') = '' 
              BEGIN 
                  SET @ValidationOrder = @ValidationOrder + 1 

                  INSERT INTO @validationReturnTable 
                              (tablename, 
                               columnname, 
                               errormessage, 
                               taborder, 
                               validationorder) 
                  SELECT 'CustomPsychiatricNoteProblems', 
                         'SubjectiveText', 
                         'General - Problem ' 
                         + Cast(@ProblemNumber AS VARCHAR(200)) 
                         + ' - Problem is required.', 
                         @TabOrder, 
                         @ValidationOrder 
              END 

            SET @TwoItemCount = 0 

            IF Isnull(@Severity, 0) > 0 
              BEGIN 
                  SET @TwoItemCount = @TwoItemCount + 1 
              END 

            IF Isnull(@Duration, 0) > 0 
              BEGIN 
                  SET @TwoItemCount = @TwoItemCount + 1 
              END 

            --  IF ISNULL(@Intensity,0) > 0 
            --  BEGIN 
            --SET @TwoItemCount = @TwoItemCount + 1 
            --  END 
            IF Isnull(@TimeOfDayMorning, 'N') <> 'N' 
                OR Isnull(@TimeOfDayAfternoon, 'N') <> 'N' 
                OR Isnull(@TimeOfDayAllday, 'N') <> 'N' 
                OR Isnull(@TimeOfDayNight, 'N') <> 'N' 
              BEGIN 
                  SET @TwoItemCount = @TwoItemCount + 1 
              END 

            IF Isnull(@LocationHome, 'N') <> 'N' 
                OR Isnull(@LocationSchool, 'N') <> 'N' 
                OR Isnull(@LocationWork, 'N') <> 'N' 
                OR Isnull(@LocationEveryWhere, 'N') <> 'N' 
                OR Isnull(@LocationOther, 'N') <> 'N' 
              BEGIN 
                  SET @TwoItemCount = @TwoItemCount + 1 
              END 

            IF Isnull(@ContextText, '') <> '' 
              BEGIN 
                  SET @TwoItemCount = @TwoItemCount + 1 
              END 

            IF Isnull(@TwoItemCount, 0) < 2 
              BEGIN 
                  SET @ValidationOrder = @ValidationOrder + 1 

                  INSERT INTO @validationReturnTable 
                              (tablename, 
                               columnname, 
                               errormessage, 
                               taborder, 
                               validationorder) 
                  SELECT 'CustomPsychiatricNoteProblems', 
                         'Severity', 
                         'General - Problem ' 
                         + Cast(@ProblemNumber AS VARCHAR(200)) 
                         + ' - At least two items are required.', 
                         @TabOrder, 
                         @ValidationOrder 
              END 

            IF Isnull(@LocationOther, 'N') = 'Y' 
               AND Isnull(@LocationOtherText, '') = '' 
              BEGIN 
                  SET @ValidationOrder = @ValidationOrder + 1 

                  INSERT INTO @validationReturnTable 
                              (tablename, 
                               columnname, 
                               errormessage, 
                               taborder, 
                               validationorder) 
                  SELECT 'CustomPsychiatricNoteProblems', 
                         'LocationOtherText', 
                         'General - Problem ' 
                         + Cast(@ProblemNumber AS VARCHAR(200)) 
                         + 
              ' - Location Other Text is required when other is selected.', 
                         @TabOrder, 
                         @ValidationOrder 
              END 

            FETCH next FROM fa_cursor INTO @SubjectiveText, @TypeOfProblem, 
            @Severity, 
            @Duration, @TimeOfDayAllday, @TimeOfDayMorning, @TimeOfDayAfternoon, 
            @TimeOfDayNight, @LocationHome, @LocationSchool, @LocationWork, 
            @LocationEveryWhere, @LocationOther, @LocationOtherText, 
            @AssociatedSignsSymptoms, @ModifyingFactors, 
            @AssociatedSignsSymptomsOtherText, @ProblemStatus, 
            @DiscussLongActingInjectable, @ProblemMDMComments, @ICD10Code, 
            @ContextText 
        END 

      CLOSE fa_cursor 

      DEALLOCATE fa_cursor 

      RETURN 
  END 