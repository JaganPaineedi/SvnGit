--Created By  : Anto Jenkins
--Dated       : 07 Dec 2016
--What        : To insert into Reports entry for the report "Control Substance Details"
--Why         : EPCS #31
 

DECLARE @ReportServerId INT
DECLARE @reportfoldername varchar(100)

select @reportfoldername=reportfoldername from SystemConfigurations
Select TOP 1 @ReportServerId=ReportServerId from ReportServers where  ISNULL(RecordDeleted,'N')='N'

IF NOT EXISTS(SELECT 1 FROM reports Where Name like 'Control Substance Report') 
BEGIN
  INSERT INTO Reports(Name,Description,IsFolder,ReportServerId,ReportServerPath) 
  VALUES('Control Substance Report','Control Substance Report','N',@ReportServerId,'/'+@reportfoldername+'/RDLControlSubstanceDetails')
END



