/****** Object:  StoredProcedure [dbo].[ssp_GetHealthHistory]    Script Date: 03/08/2013 16:04:46 ******/
set ANSI_NULLS on
GO
set QUOTED_IDENTIFIER on
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHealthHistory]    Script Date: 03/08/2013 17:30:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHealthHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHealthHistory]
GO

create  procedure [dbo].[ssp_GetHealthHistory] 
/*********************************************************************************/    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: Customization support for Reception list page depending on the custom filter selection.    
--    
-- Author:  Vaibhav khare    
-- Date:    20 May 2011    
--    
-- *****History****    
/* 2012-09-21   Vaibhav khare  Created          */    
/* 2013-03-08	Modified by SHS-US team for Summit Pointe Primary Care release. */
/* 2013-03-21    New two parameters added by Deej. As per the discussion with Wasif*/
/* 2017-09-06  jcarlson - Andrews Centre SGL 63: Added logic to prevent the ssp from erroring out if the custom table "CustomFamilyHistory" does not exist*/
/*********************************************************************************/ 
@ClientId int
 ,@DocumentId INT
 ,@EffectiveDate DATETIME
as 
begin     

declare @name varchar(max);  
	set @name = '<b>Family History</b><br>';

	IF OBJECT_ID(N'CustomFamilyHistory',N'U') IS NOT NULL
	begin
		;
    with    cteFamilyHistory
              as (
                  select    dbo.csf_GetGlobalCodeNameById(FamilyMemberType) as FamilyMemberType,
                            CurrentAge,
                            CauseOfDeath,
                            CASE when IsLiving is null
                                 then '(Living Status Unknown)'
                                 when IsLiving = 'Y' then '(Still Living)'
                                 else '(Deceased)'
                            end as LivingStatus,
                            RTRIM(CASE when ISNULL(Hypertension, 'N') <> 'N'
                                       then 'Hypertension, '
                                       else ''
                                  end
                                  + CASE when ISNULL(Hyperlipidemia, 'N') <> 'N'
                                         then 'Hyperlipidemia, '
                                         else ''
                                    end
                                  + CASE when ISNULL(Diabetes, 'N') <> 'N'
                                         then 'Diabetes, '
                                         else ''
                                    end
                                  + CASE when ISNULL(Alcoholism, 'N') <> 'N'
                                         then 'Alcoholism, '
                                         else ''
                                    end
                                  + CASE when ISNULL(COPD, 'N') <> 'N'
                                         then 'COPD, '
                                         else ''
                                    end
                                  + CASE when ISNULL(Depression, 'N') <> 'N'
                                         then 'Depression, '
                                         else ''
                                    end
                                  + CASE when ISNULL(ThyroidDisease, 'N') <> 'N'
                                         then 'ThyroidDisease, '
                                         else ''
                                    end
                                  + CASE when ISNULL(CoronaryArteryDisease,
                                                     'N') <> 'N'
                                         then 'Coronary Artery Disease, '
                                         else ''
                                    end
                                  + CASE when CancerType is not null
                                         then dbo.csf_GetGlobalCodeNameById(CancerType)
                                              + ', '
                                         else ''
                                    end) as Conditions
                  from      CustomFamilyHistory CFH
                  join      Documentversions DV on CFH.DocumentVersionId = DV.DocumentVersionId
                  join      documents ds on DV.DocumentVersionId = ds.CurrentDocumentVersionId
                  where      ds.ClientId = @ClientId
							and ds.Status = 22	-- Signed
							and ISNULL(ds.RecordDeleted, 'N') <> 'Y'
							and ISNULL(dv.RecordDeleted, 'N') <> 'Y'
							and ISNULL(CFH.RecordDeleted, 'N') <> 'Y'
                            and not exists ( select *
                                             from   dbo.Documents as ds2
                                             where  ds2.ClientId = ds.ClientId
													and ds2.DocumentCodeId = ds.DocumentCodeId
                                                    and ds2.Status = 22
                                                    and ISNULL(ds2.RecordDeleted,
                                                              'N') <> 'Y'
                                                    and (
                                                         (ds2.EffectiveDate > ds.EffectiveDate)
                                                         or (
                                                             ds2.EffectiveDate = ds.EffectiveDate
                                                             and ds2.DocumentId > ds.DocumentId
                                                            )
                                                        ) )
                 )
        select  FamilyMemberType,
                CurrentAge,
                LivingStatus,
                CauseOfDeath,
                CASE when LEN(Conditions) > 1
                     then SUBSTRING(Conditions, 1, LEN(Conditions) - 1)
                     else ''
                end as Conditions
        into #tempFamilyHistory
        from    cteFamilyHistory

	declare cFamilyMembers cursor for
	select FamilyMemberType,
			LivingStatus,
                CurrentAge,
                CauseOfDeath,
                Conditions
	from #tempFamilyHistory
	order by CurrentAge desc

    declare @FamilyMemberType varchar(250), @CurrentAge int, @LivingStatus varchar(100), @CauseOfDeath varchar(1000), @Conditions varchar(MAX)

	open cFamilyMembers
	
	fetch cFamilyMembers into @FamilyMemberType, @LivingStatus, @CurrentAge, @CauseOfDeath, @Conditions
   
    IF @@FETCH_STATUS = 0 
    Begin
    while @@fetch_status = 0
        begin  
   
      
            set @name = ISNULL(@name, '') 
				+ '&nbsp;' + ISNULL(@FamilyMemberType, '(Unknown Family Member Type)') + ':'
				+ '&nbsp;' + ISNULL(CAST(@CurrentAge as varchar), '') 
                + '&nbsp;' + ISNULL(@Conditions, '')
                + '&nbsp;' + ISNULL(@LivingStatus, '') 
                + '&nbsp;' + ISNULL(@CauseOfDeath, '')
                + '<br>'  

			fetch cFamilyMembers into @FamilyMemberType, @LivingStatus, @CurrentAge, @CauseOfDeath, @Conditions
        end
    end
    else set @name += 'none'
   

    close cFamilyMembers
    
    deallocate cFamilyMembers
	END 
	ELSE 
	BEGIN
		SET @name += 'none';
	END
    select  '<span style=''color:black''>' + @name + '</span>' as 'name'      
end 

go
