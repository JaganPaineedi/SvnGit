/****** Object:  StoredProcedure [dbo].[ssp_SCShowServiceUpdateHistory]    Script Date: 12/03/2015 15:44:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCShowServiceUpdateHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCShowServiceUpdateHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCShowServiceUpdateHistory]    Script Date: 12/03/2015 15:44:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCShowServiceUpdateHistory]   
@ServiceId       INT           
AS   
/*********************************************************************/   
/* Stored Procedure: dbo.ssp_SCShowServiceUpdateHistory            */   
/* Creation Date:    30/Nov/2015                */   
/* Purpose:  To Show Service update history                */   
/*    Exec ssp_SCShowServiceUpdateHistory 637  --658                                           */  
/* Input Parameters:                           */   
/*  Date   Author   Purpose              */   
/* 30/Nov/2015  Gautam   Created    task #238 , Engineering Improvement Initiatives- NBL(I)          */  
/* 09/Dec/2015  Ponnin   Added space between StartDate,EndDate, StartTime and EndTime.   Why :task #238 , Engineering Improvement Initiatives- NBL(I)          */  
/* 17/Dec/2015  Gautam   Change OrderNo for EndTime, Why: Order no. was wrong - Initial release */ 
  /*********************************************************************/   
  BEGIN   
 DECLARE @Error VARCHAR(max)   
   
 BEGIN TRY  
 Create table #FinalOutput  
  (Id  int identity(1,1),ModifiedField varchar(100),OriginalValue varchar(250),NewValue varchar(250),UserName varchar(150),  
  ModifiedDateTime Datetime,OrderNo Int)  
  
 create table #Services  
 (ServiceId Int,ProcedureName varchar(250),ProgramName varchar(250),LocationName varchar (250),StartDate DateTime,  
  StartTime DateTime, EndDate DateTime, EndTime DateTime,ModifiedBy Varchar(120),ModifiedDate datetime)  
   
 create table #ServiceUpdateHistory  
 ( ServiceUpdateHistoryId int,ServiceId Int,ProcedureName varchar(250),ProgramName varchar(250),LocationName varchar(250),  
  StartDate DateTime, StartTime DateTime, EndDate DateTime, EndTime DateTime,ModifiedBy Varchar(120),ModifiedDate datetime )  
  
    
 Insert into #Services  
 Select S.ServiceId,PC.ProcedureCodeName ,P.ProgramName,L.LocationName,cast(S.DateOfService as date),cast(S.DateOfService as time(0))  
 ,cast(S.EndDateOfService as date), cast(S.EndDateOfService as time(0)),S.ModifiedBy,S.ModifiedDate   
 From Services S Join ProcedureCodes PC On S.ProcedureCodeId=PC.ProcedureCodeId  
 Join Programs P On S.ProgramId=P.ProgramId  
 Join Locations L On S.LocationId= L.LocationId  
  where S.ServiceId=@ServiceId  
  
  
 Insert into #ServiceUpdateHistory  
 Select S.ServiceUpdateHistoryId,S.ServiceId,PC.ProcedureCodeName ,P.ProgramName,L.LocationName,cast(S.StartDate as date),cast(S.StartTime as time(0))  
 ,cast(S.EndDate as date), cast(S.EndTime as time(0)),S.ModifiedBy,S.ModifiedDate   
 From ServiceUpdateHistory S Left Join ProcedureCodes PC On S.ProcedureCodeId=PC.ProcedureCodeId  
 Left Join Programs P On S.ProgramId=P.ProgramId  
 Left Join Locations L On S.LocationId= L.LocationId  
  where S.ServiceId=@ServiceId Order by S.ModifiedDate Asc  
  
 Create Table #ActualData(Id  int identity(1,1),OriginalData Varchar(250),ModifiedBy Varchar(120),ModifiedDate datetime)  
 Create Table #ModifiedData(Id  int ,ModifiedData Varchar(250))  
 --Program  
 Insert into #ActualData  
 Select ProgramName,ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
  where ProgramName is not null  
 union all  
 select ProgramName, null,null from #Services   
  
 Insert into #ModifiedData  
 select Id,OriginalData From #ActualData where Id >1  
  
 Insert into #FinalOutput  
 Select 'Program',A.OriginalData,M.ModifiedData,A.ModifiedBy,A.ModifiedDate,5  
 From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
 truncate table #ActualData  
 truncate table #ModifiedData  
  
  
 --Procedure  
 IF exists(Select 1 From #ServiceUpdateHistory   where ProcedureName is not null)  
 Begin  
  Insert into #ActualData  
  Select ProcedureName,ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
   where ProcedureName is not null  
  union all  
  select ProcedureName, null,null from #Services   
  
  Insert into #ModifiedData  
  select Id,OriginalData From #ActualData where Id >1  
  
  Insert into #FinalOutput  
  Select 'Procedure',A.OriginalData,M.ModifiedData,A.ModifiedBy,A.ModifiedDate,4  
  From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
  truncate table #ActualData  
  truncate table #ModifiedData  
 End  
  
  
 --Location  
 IF exists(Select 1 From #ServiceUpdateHistory   where LocationName is not null)  
 Begin  
  Insert into #ActualData  
  Select LocationName,ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
   where LocationName is not null  
  union all  
  select LocationName, null,null from #Services   
  
  Insert into #ModifiedData  
  select Id,OriginalData From #ActualData where Id >1  
  
  Insert into #FinalOutput  
  Select 'Location',A.OriginalData,M.ModifiedData,A.ModifiedBy,A.ModifiedDate,3  
  From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
  truncate table #ActualData  
  truncate table #ModifiedData  
 End  
  
  
--StartDate  
 IF exists(Select 1 From #ServiceUpdateHistory   where StartDate is not null)  
 Begin  
  Insert into #ActualData  
  Select CONVERT(varchar(20), StartDate,101),ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
   where StartDate is not null  
  union all  
  select CONVERT(varchar(20), StartDate,101), null,null from #Services   
  
  Insert into #ModifiedData  
  select Id,OriginalData From #ActualData where Id >1  
  
  Insert into #FinalOutput  
  Select 'Start Date',A.OriginalData,M.ModifiedData,A.ModifiedBy,A.ModifiedDate,6  
  From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
  truncate table #ActualData  
  truncate table #ModifiedData  
 End  
   
----StartTime  
 IF exists(Select 1 From #ServiceUpdateHistory   where StartTime is not null)  
 Begin  
  Insert into #ActualData  
  Select RIGHT(CONVERT(VARCHAR,StartTime,0),7),ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
   where StartTime is not null  
  union all  
  select RIGHT(CONVERT(VARCHAR,StartTime,0),7), null,null from #Services   
  
  Insert into #ModifiedData  
  select Id,OriginalData From #ActualData where Id >1  
  
  Insert into #FinalOutput  
  Select 'Start Time',left(A.OriginalData,CHARINDEX(':',A.OriginalData)-1) + ':' + substring(A.OriginalData,CHARINDEX(':',A.OriginalData) +1,2) + ' ' + right(A.OriginalData,2),
  left(M.ModifiedData,CHARINDEX(':',M.ModifiedData)-1) + ':' + substring(M.ModifiedData,CHARINDEX(':',M.ModifiedData) +1,2)  + ' ' + right(M.ModifiedData,2),A.ModifiedBy,A.ModifiedDate,7  
  From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
  truncate table #ActualData  
  truncate table #ModifiedData  
 End  
  
--EndDate  
 IF exists(Select 1 From #ServiceUpdateHistory   where EndDate is not null)  
 Begin  
  Insert into #ActualData  
  Select CONVERT(varchar(20), EndDate,101),ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
   where EndDate is not null  
  union all  
  select CONVERT(varchar(20), EndDate,101), null,null from #Services   
  
  Insert into #ModifiedData  
  select Id,OriginalData From #ActualData where Id >1  
  
  Insert into #FinalOutput  
  Select 'End Date',A.OriginalData,M.ModifiedData,A.ModifiedBy,A.ModifiedDate,1  
  From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
  truncate table #ActualData  
  truncate table #ModifiedData  
 End  
   
----EndTime  
 IF exists(Select 1 From #ServiceUpdateHistory   where EndTime is not null)  
 Begin  
  Insert into #ActualData  
  Select RIGHT(CONVERT(VARCHAR,EndTime,0),7),ModifiedBy,ModifiedDate From #ServiceUpdateHistory    
   where EndTime is not null  
  union all  
  select RIGHT(CONVERT(VARCHAR,EndTime,0),7), null,null from #Services   
  
  Insert into #ModifiedData  
  select Id,OriginalData From #ActualData where Id >1  
  
  Insert into #FinalOutput  
  Select 'End Time',left(A.OriginalData,CHARINDEX(':',A.OriginalData)-1) + ':' + substring(A.OriginalData,CHARINDEX(':',A.OriginalData) +1,2) + ' ' + right(A.OriginalData,2),
  left(M.ModifiedData,CHARINDEX(':',M.ModifiedData)-1) + ':' + substring(M.ModifiedData,CHARINDEX(':',M.ModifiedData) +1,2)  + ' ' + right(M.ModifiedData,2),A.ModifiedBy,A.ModifiedDate,2  
  From #ActualData A Join #ModifiedData M On A.Id=M.Id-1  
  
  truncate table #ActualData  
  truncate table #ModifiedData  
 End  
     
 select  Id, ModifiedField,  OriginalValue ,NewValue,UserName ,   
 CONVERT(varchar(20), ModifiedDateTime,101) + ' ' +  Left(RIGHT(CONVERT(VARCHAR,ModifiedDateTime,0),6),4) + ' ' + RIGHT(CONVERT(VARCHAR,ModifiedDateTime,0),2)  as 'DateTime'  
 from #FinalOutput order by OrderNo  
  
 --drop table #Services  
 --drop table #ServiceUpdateHistory  
 --drop table #FinalOutput  
 --drop table #ActualData  
 --drop table #ModifiedData  
  
  
 END TRY  
 BEGIN catch   
  SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
         + '*****'   
         + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
         'ssp_SCShowServiceUpdateHistory'   
         )   
         + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
         + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
         + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  Select @Error  
   RETURN   
  END catch   
  
End   
            
GO


