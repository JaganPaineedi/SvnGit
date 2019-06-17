if object_id('dbo.ssp_PopulateDiagnosisAllCodeKeywordsTable') is not null 
  drop procedure dbo.ssp_PopulateDiagnosisAllCodeKeywordsTable
go

create procedure dbo.ssp_PopulateDiagnosisAllCodeKeywordsTable
  @DiagnosisAllCodeId int = null
/*********************************************************************
-- Stored procedure: ssp_PopulateDiagnosisAllCodeKeywordsTable
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: populates DiagnosisAllCodeKeywords table
--
-- Updates: 
--  Date         Author       Purpose
--  08.04.2015   SFarber      Created.
--
**********************************************************************/
as 

if object_id('tempdb.dbo.#DiagnosisAllCodes') is null 
  begin
    create table #DiagnosisAllCodes (
    DiagnosisAllCodeId int)
  end

if @DiagnosisAllCodeId is not null 
  begin
    insert  into #DiagnosisAllCodes
            (DiagnosisAllCodeId)
    values  (@DiagnosisAllCodeId)
  end

delete  dackw
from    #DiagnosisAllCodes dac
        join DiagnosisAllCodeKeywords dackw on dackw.DiagnosisAllCodeId = dac.DiagnosisAllCodeId
 
insert  into DiagnosisAllCodeKeywords
        (DiagnosisAllCodeId,
         Keyword,
         KeywordSoundex)
        select  dac.DiagnosisAllCodeId,
                split.item,
                soundex(split.item)
        from    #DiagnosisAllCodes dact
                join DiagnosisAllCodes dac on dac.DiagnosisAllCodeId = dact.DiagnosisAllCodeId
                cross apply dbo.Fnsplit(replace(replace(replace(replace(replace(replace(dac.DiagnosisDescription, ',', ' '), '-', ' '), '(', ''), ')', ''), '[', ''), ']', ''), ' ') as split
        where   split.item not in ('the', 'or', 'and', 'in', 'of', 'a', 'by')


go