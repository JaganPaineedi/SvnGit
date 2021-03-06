/****** Object:  StoredProcedure [dbo].[SSP_SCWebTimelineAxis5New]    Script Date: 11/18/2011 16:26:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCWebTimelineAxis5New]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCWebTimelineAxis5New]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SSP_SCWebTimelineAxis5New]                 
 @ClientId int              
AS                  
                  
/*********************************************************************/                    
/* Stored Procedure: dbo.ssp_TimelineAxis5                */                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                    
/* Creation Date:    8/1/05                                         */                    
/*                                                                   */                    
/* Purpose:  It is used to give the Timline axis 5             */                   
/*                                                                   */                  
/* Input Parameters: none                 */                  
/*                                                                   */                    
/* Output Parameters:   None                               */                    
/*                                                                   */                    
/* Return:  0=success, otherwise an error number                     */                    
/*                                                                   */                    
/* Called By:                                                        */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/*  Date     Author       Purpose                                    */                    
/* 8/1/05   Vikas     Created  

18-09-2017    Sachin	What : Pulling the GAF Score From DocumentDiagnosis. 
						Why  : TxAce - Environment Issues Tracking #182                                       */                    
/*********************************************************************/                     
BEGIN                  
                  
/*                  
select *,                  
case when (cast(datepart(month,getdate())+1 as varchar))='13' then '01' else (cast(datepart(month,getdate())+1 as varchar)) end + '-01-' + cast((datepart(year,getdate())-1) as varchar) as yearback,                  
 datediff(d,cast(datepart(month,getdate()) as varchar) + '-01-' + cast((datepart(year,getdate())-1) as varchar), t.DiagnosisDate)  as ActualValue                  
from TimelineAxisV t                  
where DiagnosisDate between dateadd(year,-1,getdate()) AND getdate()                  
and ClientId=@ClientId and t.Score>0                   
order by DiagnosisDate  
*/                  
          
                  
declare @currentMonth int                  
declare @firstDay varchar(2)                  
declare @currentYear int                  
declare @dt datetime                  
--declare @ClientId as int                
                  
set @dt = getdate()                  
                  
declare @yearBack varchar(10)                  
declare @yearNext varchar(10)                  
                  
set @firstDay='01'                  
set @yearBack=''                 
set @yearNext=''                
                
--set @ClientId=(SELECT ClientId FROM  Clients where RowIdentifier=@ClientRowIdentifier)                             
                  
set @currentMonth = datepart(month,@dt)                  
set @currentYear = datepart(year,@dt)                  
                  
/*                
  if(@currentMonth = 12)                  
  begin                  
    set @yearBack = cast(@currentMonth as varchar) + '/' + @firstDay + '/' + cast(@currentYear-1 as varchar)                  
    set @yearNext = @firstDay + '/' + @firstDay + '/' + cast(@currentYear+1 as varchar)                  
  end                  
 else                  
  begin                  
    set @yearBack = cast(@currentMonth+1 as varchar) + '/' + @firstDay + '/' + cast(@currentYear-1 as varchar)                  
    if(@currentMonth<>1)                  
     begin                  
       set @yearNext = cast(@currentMonth-1 as varchar) + '/' + @firstDay + '/' + cast(@currentYear as varchar)                  
     end                  
    else                  
     begin                  
       set @yearNext = '1'+ '/' + @firstDay + '/' + cast(@currentYear as varchar)                  
    end                  
  end                  
  */                
if(@currentMonth = 12)                  
  begin                  
    set @yearBack = '1' + '/' + @firstDay + '/' + cast(@currentYear as varchar)                  
    set @yearNext = cast(@currentMonth as varchar)  + '/' + '31' + '/' + cast(@currentYear as varchar)                  
  end                  
   else                  
  begin                  
    set @yearBack = cast(@currentMonth+1 as varchar) + '/' + @firstDay + '/' + cast(@currentYear-1 as varchar)                  
    if(@currentMonth<>1)                  
    begin                  
      set @yearNext = cast(@currentMonth as varchar) + '/' + cast(dbo.GetDaysInMonth(@currentMonth ,@currentYear) as varchar) + '/' + cast(@currentYear as varchar)                  
    end                  
    else                  
    begin                  
      set @yearNext = '1'+ '/' + '31' + '/' + cast(@currentYear as varchar)                  
    end                  
  end             
              
                 
--insert into #TempClientSummary              
--(ClientId, DateRange, Score, YearBack, ActualValue, GType)                  
select *,                  
  case when (cast(datepart(month,getdate()) as varchar))='12' then '01' else (cast(datepart(month,getdate())+1 as varchar)) end + '-01-' + case when cast(datepart(month,getdate()) as varchar)='12' then cast(datepart(year,getdate()) as varchar) else cast( 
  
    
      
       
datepart(year,getdate())-1 as varchar) end as yearback                  
, datediff(d, case when (cast(datepart(month,getdate()) as varchar))='12' then '01' else (cast(datepart(month,getdate())+1 as varchar)) end + '-01-' + case when cast(datepart(month,getdate()) as varchar)='12' then cast(datepart(year,getdate()) as varchar)
  
    
          
                
 --else cast(datepart(year,getdate())-1 as varchar) end , t.DiagnosisDate) as ActualValue    
 --,'Diagnosis'  
 
 else cast(datepart(year,getdate())-1 as varchar) end , D.EffectiveDate) as ActualValue   
                  

-- Added By Sachin        
FROM DocumentDiagnosis DD
JOIN DocumentVersions DV ON DV.DocumentVersionId=DD.DocumentVersionId
JOIN Documents D ON D.DocumentId=Dv.DocumentId
WHERE D.EffectiveDate between @yearBack AND @yearNext 
AND ClientId=@ClientId and DD.GAFScore > 0  


           
                  
--from TimelineAxisV t                  
--where DiagnosisDate between @yearBack AND @yearNext                  
----where DiagnosisDate between dateadd(year,-1,getdate()) AND getdate()                  
--and ClientId=@ClientId and t.Score>0                   
--order by DiagnosisDate                  
                  
                  
    IF (@@error!=0)                  
    BEGIN                  
        RAISERROR  ( 'SSP_TimelineAxis5: An Error Occured' ,16,1)                 
        RETURN(1)                  
                      
    END                  
    RETURN(0)                  
END
Go