IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSearchICD10CodesByDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSearchICD10CodesByDescription]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSearchICD10CodesByDescription]    Script Date: 3/16/2018 12:08:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[ssp_SCSearchICD10CodesByDescription]
  @PageNumber int,
  @PageSize int,
  @ICDDescriptionSearchText varchar(100),
  @DSMCodeText varchar(100) = null,
  @DXSearchPreference1 int = 0,
  @DXSearchPreference2 int = 0,
  @DXSearchPreference3 int = 0,
  @DXSearchPreference4 int = 2
/**********************************************************************                
-- Stored Procedure: ssp_SCSearchICD10CodesByDescription
--
-- Copyright: Streamline Healthcare Solutions                
--
-- Creation Date:  30/07/2014                
-- Created By : Deej              
--
-- Modified      Author      Reason              
-- 15/Sep/2014   Bernardin   Implemented SOUNDEX Keyword search              
-- 20/Apr/2015   Gautam      Selected only required code for code and description search and set default ICD10 for performance issue    
-- 08/Jul/2015   Gautam      Included view "ssv_SCViewGetICD9Details" for ICD9 search for performance issue 
-- 07/Aug/2015   Javed       Included new table DiagnosisAllCodes,DiagnosisAllCodeKeywords to store Soundex data to improve the search performance
-- 13/Aug/2015   SFarber     Fixed multiple issues.
-- 17/Aug/2015   SFarber     Fixed order of the final result set.
-- 09/Sep/2015   SFarber     Added ordering logic for MatchOnCode, MatchOnKeyword or/and MatchOnKeywordSoundex
-- 10/Sep/2015   SFarber     Improved ordering logic.
-- 21/Sep/2015	 TRemisoski	 Introduced Left Joins to SNOMED Mapping (specifically for Harbor ICD9 995.5x lookup)
-- 22/Sep/2015   Gautam      Added Billable column in final result set,Diagnosis Changes (ICD10),Tasks#43
-- 10/28/2016   jwheeler     rmoved inner join on DiagnosisICD10ICD9Mapping and added checks for record deletes.  Philhaven-Support #72.
-- 21/Nov/216    Himmat      As per Core Bug#643 and and isnull(ICD10.RecordDeleted, 'N') = 'N' condition to avoid duplicate codes
--14/Feb/2017    Lakshmi     As per the task Valley - Support Go Live #1079`, Added AND isnull(DDI9M.RecordDeleted, 'N') = 'N' to									 DiagnosisICD10ICD9Mapping
-- 16/Jan/2018   mraymond    Added condition to check for IncludeInSearch value when inserting from #DiagnosisSearch - MFS - Support Go Live Task #175
-- 16/Mar/2018   mraymond    added additional checks to the above change per Slavik to account for SNOMED and ICD9 searches - MFS - Support Go Live Task #175
-- 19/June/2018  Arjun K R   Added new filter called '@DXSearchPreference4' to filter codes based on its billable or non billable. For Task #31 KCMHSAS Enhancement.
							 If @DXSearchPreference4=2 its both billable and non billable.
							 If @DXSearchPreference4=1 its billable.
							 If @DXSearchPreference4=0 its non billable.
--*********************************************************************/
as 

create table #DiagnosisSearch (
CodeType varchar(15),
DiagnosisCode varchar(15),
MatchOnCode int,
MatchOnKeyword int,
MatchOnKeywordSoundex int)

create table #DiagData (
ICD10CodeId int,
ICD10Code varchar(200),
ICD9Code varchar(200),
DSMDescription varchar(500),
SNOMEDCTCode varchar(100),
SNOMEDCTDescription varchar(500),
DSMVCode char(1),
MatchOnCode int,
MatchOnKeyword int,
MatchOnKeywordSoundex int,
Billable char(1))

create table #SearchItem (
SearchItemId int identity(1, 1) not null,
Keyword varchar(100),
KeywordSoundex varchar(15))
    
declare @ICD9 char(1) = 'N'
declare @ICD10 char(1) = 'N'
declare @SNOMED char(1) = 'N'
declare @NumberOfKeyWords int
    
begin try

  -- Determine search preferences      
  if @DXSearchPreference1 = 8951 
    begin
      set @ICD9 = 'Y'
    end

  if @DXSearchPreference2 = 8952 
    begin
      set @ICD10 = 'Y'
    end

  if @DXSearchPreference3 = 8953 
    begin
      set @SNOMED = 'Y'
    end

  if @DXSearchPreference1 = 0
    and @DXSearchPreference2 = 0
    and @DXSearchPreference3 = 0 
    begin
      set @ICD10 = 'Y'
    end

  -- Determined Keywords sent      
  insert  into #SearchItem
          (Keyword,
           KeywordSoundex)
          select  '%' + convert(varchar(100), Item) + '%',
                  soundex(convert(varchar(15), Item))
          from    dbo.fnSplit(@ICDDescriptionSearchText, ' ')

  select @NumberOfKeyWords = count(distinct Keyword) from #SearchItem

  -- If there is a description the search is looking at keywords.
  if isnull(@NumberOfKeyWords, 0) < 1
    begin
      insert  into #DiagnosisSearch
              (CodeType,
               DiagnosisCode,
               MatchOnCode,
               MatchOnKeyword,
               MatchOnKeywordSoundex)
              select  a.CodeType,
                      a.DiagnosisCode,
                      1,
                      0,
                      0
              from    DiagnosisAllCodes a
              where   ((@ICD9 = 'Y'
                        and a.CodeType in ('ICD9', 'DSMIV'))
                       or (@ICD10 = 'Y'
                           and a.CodeType in ('ICD10', 'DSM5'))
                       or (@SNOMED = 'Y'
                           and a.CodeType = 'SNOMED'))
                      and a.IncludeInSearch = 'Y'
                      and a.DiagnosisCode like (@DSMCodeText + '%')
                      and isnull(a.RecordDeleted, 'N') = 'N'
    end
  else 
    begin
      insert  into #DiagnosisSearch
              (CodeType,
               DiagnosisCode,
               MatchOnCode,
               MatchOnKeyword,
               MatchOnKeywordSoundex)
              select  a.CodeType,
                      a.DiagnosisCode,
					  sum(case when a.DiagnosisCode like (@DSMCodeText + '%') then 1 else 0 end),
                      sum(case when b.Keyword like si.Keyword then 1 else 0 end),
                      sum(case when si.KeywordSoundex = b.KeywordSoundex then 1 else 0 end)
              from    DiagnosisAllCodes a
                      join DiagnosisAllCodeKeywords b on b.DiagnosisAllCodeId = a.DiagnosisAllCodeId
                      join #SearchItem si on (b.Keyword like si.Keyword
                                              or si.KeywordSoundex = b.KeywordSoundex)
              where   ((@ICD9 = 'Y'
                        and a.CodeType in ('ICD9', 'DSMIV'))
                       or (@ICD10 = 'Y'
                           and a.CodeType in ('ICD10', 'DSM5'))
                       or (@SNOMED = 'Y'
                           and a.CodeType = 'SNOMED'))
                      and a.IncludeInSearch = 'Y'
                      and (@DSMCodeText is null
                           or a.DiagnosisCode like (@DSMCodeText + '%'))
                      and isnull(a.RecordDeleted, 'N') = 'N'
                      and isnull(b.RecordDeleted, 'N') = 'N'
			  group by a.CodeType,
                       a.DiagnosisCode	
			 having count(distinct si.Keyword) = @NumberOfKeyWords		   	   
      
    end


  -- Get Mapping Codes
  if @ICD9 = 'Y' 
    begin
      insert  into #DiagData
              (ICD10CodeId,
               ICD10Code,
               ICD9Code,
               DSMDescription,
               SNOMEDCTCode,
               SNOMEDCTDescription,
               DSMVCode,
               MatchOnCode,
               MatchOnKeyword,
               MatchOnKeywordSoundex,
               Billable)
              select  ICD10.ICD10CodeId,
                      ICD10.ICD10Code,
                      DDI9M.ICD9Code,
                      ICD10.ICDDescription,
                      SNOMED.SNOMEDCTCode,
                      SNOMED.SNOMEDCTDescription,
                      ICD10.DSMVCode,
                      DS.MatchOnCode,
                      DS.MatchOnKeyword,
                      DS.MatchOnKeywordSoundex,
                      ISNULL(ICD10.BillableFlag,'N')
              from    #DiagnosisSearch DS
                      inner join DiagnosisICD10ICD9Mapping DDI9M on DS.DiagnosisCode = DDI9M.ICD9Code
                      left join ICD9SNOMEDCTMapping SNICD9 on DS.DiagnosisCode = SNICD9.ICD9Code
                      inner join DiagnosisICD10Codes ICD10 on DDI9M.ICD10CodeId = ICD10.ICD10CodeId AND ICD10.IncludeInSearch = 'Y' --mraymond 3/16/2018
                      left join SNOMEDCTCodes SNOMED on SNICD9.SNOMEDCTCodeId = SNOMED.SNOMEDCTCodeId
              where   DS.CodeType in ('DSMIV', 'ICD9')and isnull(ICD10.RecordDeleted, 'N') = 'N'
              AND isnull(DDI9M.RecordDeleted, 'N') = 'N' --Added by Lakshmi 14-02-2017
              AND (@DXSearchPreference4=2 
									    OR (ISNULL(ICD10.BillableFlag,'N')='Y' AND @DXSearchPreference4=1) 
										   OR (ISNULL(ICD10.BillableFlag,'N')='N' AND @DXSearchPreference4=0)
				   ) -- 19/June/2018  Arjun K R 
								 
    end
  
  if @ICD10 = 'Y' 
    begin
      insert  into #DiagData
              (ICD10CodeId,
               ICD10Code,
               ICD9Code,
               DSMDescription,
               SNOMEDCTCode,
               SNOMEDCTDescription,
               DSMVCode,
               MatchOnCode,
               MatchOnKeyword,
               MatchOnKeywordSoundex,
               Billable)
              select  ICD10.ICD10CodeId,
                      ICD10.ICD10Code,
                      DDI9M.ICD9Code,
                      ICD10.ICDDescription,
                      SNOMED.SNOMEDCTCode,
                      SNOMED.SNOMEDCTDescription,
                      ICD10.DSMVCode,
                      DS.MatchOnCode,
                      DS.MatchOnKeyword,
                      DS.MatchOnKeywordSoundex,
                      ISNULL(ICD10.BillableFlag,'N')
              from    #DiagnosisSearch DS
                                INNER JOIN DiagnosisICD10Codes ICD10 ON DS.DiagnosisCode = ICD10.ICD10Code AND ISNULL(ICd10.RecordDeleted, 'N') = 'N' AND ICD10.IncludeInSearch = 'Y' --mraymond 1/16/2018
                                LEFT JOIN ICD10SNOMEDCTMapping SNICD10 ON ICD10.ICD10Code = SNICD10.ICD10CodeId AND ISNULL(SNICD10.RecordDeleted, 'N') = 'N'
                                LEFT JOIN DiagnosisICD10ICD9Mapping DDI9M ON ICD10.ICD10CodeId = DDI9M.ICD10CodeId  AND ISNULL(DDI9M.RecordDeleted, 'N') = 'N'--jwheeler 10/28/16
                                LEFT JOIN SNOMEDCTCodes SNOMED ON SNICD10.SNOMEDCTCodeId = SNOMED.SNOMEDCTCodeId AND ISNULL(SNOMED.RecordDeleted, 'N') = 'N'
                            WHERE DS.CodeType IN ( 'ICD10', 'DSM5' )
                            AND (@DXSearchPreference4=2 
									    OR (ISNULL(ICD10.BillableFlag,'N')='Y' AND @DXSearchPreference4=1) 
										   OR (ISNULL(ICD10.BillableFlag,'N')='N' AND @DXSearchPreference4=0)
				                ) -- 19/June/2018  Arjun K R
    end
  
  if @SNOMED = 'Y' 
    begin
      insert  into #DiagData
              (ICD10CodeId,
               ICD10Code,
               ICD9Code,
               DSMDescription,
               SNOMEDCTCode,
               SNOMEDCTDescription,
               DSMVCode,
               MatchOnCode,
               MatchOnKeyword,
               MatchOnKeywordSoundex,
               Billable)
              select  ICD10.ICD10CodeId,
                      ICD10.ICD10Code,
                      SNICD9.ICD9Code,
                      ICD10.ICDDescription,
                      SNOMED.SNOMEDCTCode,
                      SNOMED.SNOMEDCTDescription,
                      ICD10.DSMVCode,
                      DS.MatchOnCode,
                      DS.MatchOnKeyword,
                      DS.MatchOnKeywordSoundex,
                      ISNULL(ICD10.BillableFlag,'N')
              from    #DiagnosisSearch DS
                                INNER JOIN SNOMEDCTCodes SNOMED ON DS.DiagnosisCode = SNOMED.SNOMEDCTCode AND ISNULL(SNOMED.RecordDeleted, 'N') = 'N'
                                INNER JOIN ICD10SNOMEDCTMapping SNICD10 ON SNOMED.SNOMEDCTCodeId = SNICD10.SNOMEDCTCodeId AND ISNULL(SNICD10.RecordDeleted, 'N') = 'N'
                                Left JOIN ICD9SNOMEDCTMapping SNICD9 ON SNICD9.SNOMEDCTCodeId = SNOMED.SNOMEDCTCodeId AND ISNULL(SNICD9.RecordDeleted, 'N') = 'N' -- jwheeler 10/28/16
                                INNER JOIN DiagnosisICD10Codes ICD10 ON SNICD10.ICD10CodeId = ICD10.ICD10Code AND ISNULL(ICD10.RecordDeleted, 'N') = 'N' AND ICD10.IncludeInSearch = 'Y' --mraymond 3/16/2018
                            WHERE DS.CodeType IN ( 'SNOMED' )
                            AND (@DXSearchPreference4=2 
									    OR (ISNULL(ICD10.BillableFlag,'N')='Y' AND @DXSearchPreference4=1) 
										   OR (ISNULL(ICD10.BillableFlag,'N')='N' AND @DXSearchPreference4=0)
				                 ) -- 19/June/2018  Arjun K R
    end
  
  -- Paging logic          
  ;
  with  DiagnosisDetailsData
          as (select distinct
                      ICD10CodeId,
                      ICD10Code,
                      ICD9Code,
                      DSMDescription,
                      SNOMEDCTCode,
                      SNOMEDCTDescription,
                      DSMVCode,
                      MatchOnCode,
                      MatchOnKeyword,
                      MatchOnKeywordSoundex,
                      Billable
              from    #DiagData),
        Counts
          as (select  count(*) as totalrows
              from    DiagnosisDetailsData),
        RankResultSet
          as (select  ICD10CodeId,
                      ICD10Code,
                      ICD9Code,
                      DSMDescription,
                      SNOMEDCTCode,
                      SNOMEDCTDescription,
                      DSMVCode,
                      Billable,
                      count(*) over () as TotalCount,
                      row_number() over (order by MatchOnCode desc, 
									              MatchOnKeyword desc,
                                                  MatchOnKeywordSoundex desc, 
											      ICD10Code,
												  case when DSMVCode = 'Y' then 1 else 2 end, 
											      ICD9Code, 
									  			  SNOMEDCTCode, 
									  			  ICD10CodeId,
									  			  Billable) as RowNumber
              from                   DiagnosisDetailsData)
    select top (case when @PageNumber = -1 then (select isnull(totalrows, 0)
                                                 from   counts)
                     else @PageSize
                end)
            ICD10CodeId,
            ICD10Code + case when DSMVCode = 'Y' then '*'
                             else ''
                        end as ICD10Code,
            ICD9Code,
            DSMDescription,
            SNOMEDCTCode,
            SNOMEDCTDescription,
            Billable,
            RowNumber,
            TotalCount
    into    #FinalResultSet
    from    RankResultSet
    where   RowNumber > ((@PageNumber - 1) * @PageSize)

  if (select  isnull(count(*), 0)
      from    #FinalResultSet) < 1 
    begin
      select  0 as PageNumber,
              0 as NumberOfPages,
              0 NumberOfRows
    end
  else 
    begin
      select top 1
              @PageNumber as PageNumber,
              case (TotalCount % @PageSize)
                when 0 then isnull((TotalCount / @PageSize), 0)
                else isnull((TotalCount / @PageSize), 0) + 1
              end as NumberOfPages,
              isnull(TotalCount, 0) as NumberOfRows
      from    #FinalResultSet
    end

  select  ICD10CodeId,
          ICD10Code,
          ICD9Code,
          DSMDescription,
          SNOMEDCTCode,
          SNOMEDCTDescription,
          Billable,
          CASE WHEN Billable='Y' THEN 'Yes' 
				ELSE 'No' END AS IsBillable   -- 19/June/2018  Arjun K R
  from    #FinalResultSet
  order by RowNumber

end try

begin catch
  declare @Error varchar(8000)

  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), 'ssp_SCSearchICD10CodesByDescription') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state())

  raiserror (@Error, 16, 1);
end catch


GO


