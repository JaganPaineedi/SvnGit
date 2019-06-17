----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.62)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.62 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

------ End of STEP 3 ------------
------ STEP 4 ---------------
/****** Object:  Trigger [TriggerDiagnosisAllCodes_SNOMEDCTCodes]    Script Date: 3/23/2017 10:59:06 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' AND name = 'TriggerDiagnosisAllCodes_SNOMEDCTCodes')
DROP TRIGGER [dbo].[TriggerDiagnosisAllCodes_SNOMEDCTCodes]
GO

/****** Object:  Trigger [dbo].[TriggerDiagnosisAllCodes_SNOMEDCTCodes]    Script Date: 3/23/2017 10:59:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create trigger [dbo].[TriggerDiagnosisAllCodes_SNOMEDCTCodes] on [dbo].[SNOMEDCTCodes]
  for insert, update, delete
/*********************************************************************
-- Trigger: TriggerDiagnosisAllCodes_SNOMEDCTCodes
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: maintains DiagnosisAllCodes and DiagnosisAllCodeKeywords tables
--
-- Updates: 
--  Date         Author       Purpose
--  08.04.2015   SFarber      Created.
--  03.23.2017   TRemisoski	  Corrected RAISERROR Syntax for SQL2014
--
**********************************************************************/
as
create table #DiagnosisCodes (
DiagnosisCode varchar(25))

create table #DiagnosisAllCodes (
DiagnosisAllCodeId int)

declare @ErrorNumber int
declare @ErrorMessage varchar(255)

insert  into #DiagnosisCodes
        (DiagnosisCode)
        select  i.SNOMEDCTCode
        from    inserted i
        union
        select  d.SNOMEDCTCode
        from    deleted d

delete  dackw
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'SNOMED'
        join DiagnosisAllCodeKeywords dackw on dackw.DiagnosisAllCodeId = dac.DiagnosisAllCodeId

if @@error <> 0 
  begin
    select  @ErrorNumber = 50010,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodeKeywords'
    goto error
  end 

delete  dac
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'SNOMED'

if @@error <> 0 
  begin
    select  @ErrorNumber = 50020,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodes'
    goto error
  end 

insert  into DiagnosisAllCodes
        (DiagnosisCode,
         CodeType,
         DiagnosisDescription,
         IncludeInSearch)
output  inserted.DiagnosisAllCodeId
        into #DiagnosisAllCodes (DiagnosisAllCodeId)
        select  smed.SNOMEDCTCode,
                'SNOMED',
                smed.SNOMEDCTDescription,
                'Y'
        from    #DiagnosisCodes dc
                join dbo.SNOMEDCTCodes smed on smed.SNOMEDCTCode = dc.DiagnosisCode

if @@error <> 0 
  begin
    select  @ErrorNumber = 50030,
            @ErrorMessage = 'Failed to insert into DiagnosisAllCodes'
    goto error
  end 

exec ssp_PopulateDiagnosisAllCodeKeywordsTable 

if @@error <> 0 
  begin
    select  @ErrorNumber = 50040,
            @ErrorMessage = 'Failed to execute ssp_PopulateDiagnosisAllCodeKeywordsTable'
    goto error
  end 
return

error:
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
raiserror(@ErrorMessage, 16, 1, @ErrorNumber )
rollback transaction

GO

ALTER TABLE [dbo].[SNOMEDCTCodes] ENABLE TRIGGER [TriggerDiagnosisAllCodes_SNOMEDCTCodes]
GO

-------------------------------------------------------------------------------------------------


/****** Object:  Trigger [TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions]    Script Date: 3/23/2017 11:15:36 AM ******/

IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' AND name = 'TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions')
DROP TRIGGER [dbo].[TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions]
GO

/****** Object:  Trigger [dbo].[TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions]    Script Date: 3/23/2017 11:15:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create trigger [dbo].[TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions] on [dbo].[DiagnosisDSMDescriptions]
  for insert, update, delete
/*********************************************************************
-- Trigger: TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: maintains DiagnosisAllCodes and DiagnosisAllCodeKeywords tables
--
-- Updates: 
--  Date         Author       Purpose
--  08.04.2015   SFarber      Created.
--  03.23.2017   TRemisoski	  Corrected RAISERROR Syntax for SQL2014
--
**********************************************************************/
as
create table #DiagnosisCodes (
DiagnosisCode varchar(25))

create table #DiagnosisAllCodes (
DiagnosisAllCodeId int)

declare @ErrorNumber int
declare @ErrorMessage varchar(255)

insert  into #DiagnosisCodes
        (DiagnosisCode)
        select  i.DSMCode
        from    inserted i
        union
        select  d.DSMCode
        from    deleted d

delete  dackw
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'DSMIV'
        join DiagnosisAllCodeKeywords dackw on dackw.DiagnosisAllCodeId = dac.DiagnosisAllCodeId

if @@error <> 0 
  begin
    select  @ErrorNumber = 50010,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodeKeywords'
    goto error
  end 

delete  dac
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'DSMIV'

if @@error <> 0 
  begin
    select  @ErrorNumber = 50020,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodes'
    goto error
  end 


insert  into DiagnosisAllCodes
        (DiagnosisCode,
         CodeType,
         DiagnosisDescription,
         IncludeInSearch)
output  inserted.DiagnosisAllCodeId
        into #DiagnosisAllCodes (DiagnosisAllCodeId)
        select  dsm.DSMCode,
                'DSMIV',
                dsm.DSMDescription,
                'Y'
        from    #DiagnosisCodes dc
                join DiagnosisDSMDescriptions dsm on dsm.DSMCode = dc.DiagnosisCode

if @@error <> 0 
  begin
    select  @ErrorNumber = 50030,
            @ErrorMessage = 'Failed to insert into DiagnosisAllCodes'
    goto error
  end 

exec ssp_PopulateDiagnosisAllCodeKeywordsTable 

if @@error <> 0 
  begin
    select  @ErrorNumber = 50040,
            @ErrorMessage = 'Failed to execute ssp_PopulateDiagnosisAllCodeKeywordsTable'
    goto error
  end 

return

error:
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
raiserror(@ErrorMessage, 16, 1, @ErrorNumber )
rollback transaction

GO

ALTER TABLE [dbo].[DiagnosisDSMDescriptions] ENABLE TRIGGER [TriggerDiagnosisAllCodes_DiagnosisDSMDescriptions]
GO


-----------------------------------------------------------------------------------------------------


/****** Object:  Trigger [TriggerDiagnosisAllCodes_DiagnosisICD10Codes]    Script Date: 3/23/2017 11:18:40 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' AND name = 'TriggerDiagnosisAllCodes_DiagnosisICD10Codes')
DROP TRIGGER [dbo].[TriggerDiagnosisAllCodes_DiagnosisICD10Codes]
GO

/****** Object:  Trigger [dbo].[TriggerDiagnosisAllCodes_DiagnosisICD10Codes]    Script Date: 3/23/2017 11:18:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[TriggerDiagnosisAllCodes_DiagnosisICD10Codes] on [dbo].[DiagnosisICD10Codes]
  for insert, update, delete
/*********************************************************************
-- Trigger: TriggerDiagnosisAllCodes_DiagnosisICD10Codes
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: maintains DiagnosisAllCodes and DiagnosisAllCodeKeywords tables
--
-- Updates: 
--  Date         Author       Purpose
--  08.04.2015   SFarber      Created.
--  03.23.2017   TRemisoski	  Corrected RAISERROR Syntax for SQL2014
--
**********************************************************************/
as
create table #DiagnosisCodes (
DiagnosisCode varchar(25))

create table #DiagnosisAllCodes (
DiagnosisAllCodeId int)

declare @ErrorNumber int
declare @ErrorMessage varchar(255)

insert  into #DiagnosisCodes
        (DiagnosisCode)
        select  i.ICD10Code
        from    inserted i
        union
        select  d.ICD10Code
        from    deleted d

delete  dackw
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType in ('ICD10', 'DSM5')
        join DiagnosisAllCodeKeywords dackw on dackw.DiagnosisAllCodeId = dac.DiagnosisAllCodeId

if @@error <> 0 
  begin
    select  @ErrorNumber = 50010,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodeKeywords'
    goto error
  end 

delete  dac
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType in ('ICD10', 'DSM5')

if @@error <> 0 
  begin
    select  @ErrorNumber = 50020,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodes'
    goto error
  end 

insert  into DiagnosisAllCodes
        (DiagnosisCode,
         CodeType,
         DiagnosisDescription,
         IncludeInSearch)
output  inserted.DiagnosisAllCodeId
        into #DiagnosisAllCodes (DiagnosisAllCodeId)
        select  icd.ICD10Code,
                case when icd.DSMVCode = 'Y' then 'DSM5'
                     else 'ICD10'
                end,
                icd.ICDDescription,
                icd.IncludeInSearch
        from    #DiagnosisCodes dc
                join dbo.DiagnosisICD10Codes icd on icd.ICD10Code = dc.DiagnosisCode

if @@error <> 0 
  begin
    select  @ErrorNumber = 50030,
            @ErrorMessage = 'Failed to insert into DiagnosisAllCodes'
    goto error
  end 

exec ssp_PopulateDiagnosisAllCodeKeywordsTable 

if @@error <> 0 
  begin
    select  @ErrorNumber = 50040,
            @ErrorMessage = 'Failed to execute ssp_PopulateDiagnosisAllCodeKeywordsTable'
    goto error
  end 

return

error:
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
raiserror(@ErrorMessage, 16, 1, @ErrorNumber )
rollback transaction

GO

ALTER TABLE [dbo].[DiagnosisICD10Codes] ENABLE TRIGGER [TriggerDiagnosisAllCodes_DiagnosisICD10Codes]
GO

------------------------------------------------------------------------------------------------------------


/****** Object:  Trigger [TriggerDiagnosisAllCodes_DiagnosisICDCodes]    Script Date: 3/23/2017 11:20:00 AM ******/

IF  EXISTS (SELECT * FROM sys.objects WHERE type = 'TR' AND name = 'TriggerDiagnosisAllCodes_DiagnosisICDCodes')

DROP TRIGGER [dbo].[TriggerDiagnosisAllCodes_DiagnosisICDCodes]
GO

/****** Object:  Trigger [dbo].[TriggerDiagnosisAllCodes_DiagnosisICDCodes]    Script Date: 3/23/2017 11:20:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[TriggerDiagnosisAllCodes_DiagnosisICDCodes] on [dbo].[DiagnosisICDCodes]
  for insert, update, delete
/*********************************************************************
-- Trigger: TriggerDiagnosisAllCodes_DiagnosisICDCodes
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: maintains DiagnosisAllCodes and DiagnosisAllCodeKeywords tables
--
-- Updates: 
--  Date         Author       Purpose
--  08.04.2015   SFarber      Created.
--  03.23.2017   TRemisoski	  Corrected RAISERROR Syntax for SQL2014
--
**********************************************************************/
as
create table #DiagnosisCodes (
DiagnosisCode varchar(25))

create table #DiagnosisAllCodes (
DiagnosisAllCodeId int)

declare @ErrorNumber int
declare @ErrorMessage varchar(255)

insert  into #DiagnosisCodes
        (DiagnosisCode)
        select  i.ICDCode
        from    inserted i
        union
        select  d.ICDCode
        from    deleted d

delete  dackw
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'ICD9'
        join DiagnosisAllCodeKeywords dackw on dackw.DiagnosisAllCodeId = dac.DiagnosisAllCodeId

if @@error <> 0 
  begin
    select  @ErrorNumber = 50010,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodeKeywords'
    goto error
  end 

delete  dac
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'ICD9'

if @@error <> 0 
  begin
    select  @ErrorNumber = 50020,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodes'
    goto error
  end 

insert  into DiagnosisAllCodes
        (DiagnosisCode,
         CodeType,
         DiagnosisDescription,
         IncludeInSearch)
output  inserted.DiagnosisAllCodeId
        into #DiagnosisAllCodes (DiagnosisAllCodeId)
        select  icd.ICDCode,
                'ICD9',
                icd.ICDDescription,
                icd.IncludeInSearch
        from    #DiagnosisCodes dc
                join dbo.DiagnosisICDCodes icd on icd.ICDCode = dc.DiagnosisCode

if @@error <> 0 
  begin
    select  @ErrorNumber = 50030,
            @ErrorMessage = 'Failed to insert into DiagnosisAllCodes'
    goto error
  end 

exec ssp_PopulateDiagnosisAllCodeKeywordsTable 

if @@error <> 0 
  begin
    select  @ErrorNumber = 50040,
            @ErrorMessage = 'Failed to execute ssp_PopulateDiagnosisAllCodeKeywordsTable'
    goto error
  end 

return

error:
set @ErrorMessage = @ErrorMessage + ', Error Number: %d'
raiserror(@ErrorMessage, 16, 1, @ErrorNumber )
rollback transaction

GO

ALTER TABLE [dbo].[DiagnosisICDCodes] ENABLE TRIGGER [TriggerDiagnosisAllCodes_DiagnosisICDCodes]
GO



----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.62)
BEGIN
Update SystemConfigurations set DataModelVersion=16.63
PRINT 'STEP 7 COMPLETED'
END
Go

