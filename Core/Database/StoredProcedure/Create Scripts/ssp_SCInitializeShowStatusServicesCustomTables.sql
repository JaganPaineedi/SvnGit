
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInitializeShowStatusServicesCustomTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInitializeShowStatusServicesCustomTables]
GO


-- Test N'<Root>
--    <Services>
--		<ServiceId>1143482</ServiceId>
--		<ClientId>19</ClientId>
--		<row id="1"><name>Larry</name><oflw>some text</oflw><fd>jkjfkjkjdsfkjdsfjlkf</fd></row>
--    </Services>
--     <Services>
--		<ServiceId>1143481</ServiceId>
--		<ClientId>14</ClientId>
--		<row id="2"><name>moe</name></row>
--    </Services>
--     <Services>
--		<ServiceId>11434815</ServiceId>
--		<ClientId>16</ClientId>
--		 <row id="3" />
--    </Services>
--     <Services>
--		<ServiceId>17</ServiceId>
--		<ClientId>18</ClientId>
--		<row id="10">
--			<name>Umesh</name>
--			<lastName>Sharma</lastName>
--		</row>
--    </Services>
--     <Services>
--		<ServiceId>-1</ServiceId>
--		<ClientId>108</ClientId>
--		<row id="100">
--			<name>Umesh</name>
--			<lastName>Sharma</lastName>
--		</row>
--    </Services>
--     <Services>
--		<ServiceId>-2</ServiceId>
--		<ClientId>1048</ClientId>
--		<row id="1030">
--			<name>Umesh</name>
--			<lastName>Sharma</lastName>
--		</row>
--    </Services>
--</Root>',92,5,'csp_InitCustomCAFASStandardInitialization',''

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
go

CREATE PROCEDURE [dbo].[ssp_SCInitializeShowStatusServicesCustomTables]      
 @ObjServiceObject xml,
 --@ServiceIds varchar(2000),      
 --@NewServiceId varchar(2000),      
 @StaffId int,      
 --@ClientId int,      
 @DocumentCodeId int,      
 @InitializationStoredProcedure varchar(100),        
 @CustomParameters xml            
AS        
/******************************************************************************            
**  File: dob.InitializeShowServiceCustomTable            
**  Name: dob.InitializeShowServiceCustomTable            
**  Desc: This Procedure is used to call initialization stored procedure for         
**  each Show  Status Service,if there exists no row in Custom Table      
**  Return values:            
**             
**  Called by:               
**                          
**  Parameters:            
**  Input       Output            
**     ----------      -----------            
**  @StaffId              
**  @ClientIds         
**  @CallingSpname        
**  @CustomParameters        
**  Auth: Nisha Mittal           
**  Date: 28/05/2010            
*******************************************************************************            
**  Change History            
*******************************************************************************            
**  Date:  Author:    Description:            
**  -------- --------   -------------------------------------------            
**  1O ct   2011 Shifali		Removed Column RowIdentifier,RowIdentifier,ExternalReferenceId  
**  23 June 2015 MD Hussain K 	Initializing DocumentVersionId with -1 instead of 0 if it is null because Custom tables DocumentVersionId is initializing with -1
								w.r.t WMU-Support Go Live   
**  13 August   2015 Dhanil		to get original @CustomParameters if T.CustomParameters is empty and  passing @ClientId as first parameter   to initialization stored procedure.       
**  11 -January-2018 Sachin     What : Joining the [Documents] with DocumentVersions and added the ISNull(D.RecordDeleted,'N')='N'.
                                Why : While Group service opening from the unsaved changes and clicking on Save it was throwing an error because it was pulling the Record Deleted.
                                      for Task Carelink - EIT #37  
*******************************************************************************/            
BEGIN  

  --Following option is reqd for xml operations              
  SET ARITHABORT ON  
    
  DECLARE @Count int      
  DECLARE @MaxCount int       
  DECLARE @DocumentId int      
  DECLARE @DocumentVersionId int      
  DECLARE @ServiceId int  
  DECLARE @ClientId int 
  DECLARE @TableList varchar(1000)      
  DECLARE @FirstCustomTableName varchar(100)      
  --DECLARE @CustomParameters xml
        
  SET @Count = 1      
  --set @StaffId =92      
          
 --Get The first Custom table according to documentCodeId
  exec ssp_SCGetFirstCustomTableName @DocumentCodeId,@FirstCustomTableName out
  --PRINT @FirstCustomTableName 

Create Table #ServiceTable 
(
	ServiceId int,
	ClientId int,
	CustomParameters xml
)
INSERT INTO #ServiceTable
SELECT T.c.query('ServiceId').value('.','VARCHAR(20)')  AS ServiceId,
T.c.query('ClientId').value('.','VARCHAR(20)')  AS ClientId,
T.c.query('row')  AS CustomParametersXml

FROM   @ObjServiceObject.nodes('/Root/Services') T(c);
--select * from #ServiceTable

Create Table #validationReturnTable                                                
(        
 RowId INT IDENTITY(1,1),                      
 DocumentId      int ,    
 ServiceId       int,                                                
 DocumentVersionId  int ,      
 ClientId  varchar(200),
 CustomParameters xml                                                
)                  
       --Modified by Dhanil to get original @CustomParameters if T.CustomParameters is empty
INSERT INTO #validationReturnTable      
SELECT D.DocumentId, T.ServiceId , D.CurrentDocumentVersionId,T.ClientId,(case when rtrim(ltrim(cast(T.CustomParameters AS varchar(max))))= '' then @CustomParameters else  T.CustomParameters end)         
FROM #ServiceTable T LEFT OUTER JOIN Services S ON T.ServiceId = S.ServiceId  
LEFT OUTER JOIN  Documents D on S.ServiceId = D.ServiceId      
LEFT OUTER JOIN  Screens Sc on D.DocumentCodeId = Sc.DocumentCodeId       
   
--select * from #validationReturnTable
      
select @MaxCount = COUNT(RowId) from #validationReturnTable      
declare @CustomTableRecordCount int       
 WHILE(@Count <= @MaxCount )                      
 BEGIN      
 
    select @DocumentId =isnull(DocumentId,0),@ServiceId =ServiceId, @CustomParameters=CustomParameters,
    @DocumentVersionId = isnull(DocumentVersionId,-1),@ClientId =isnull(ClientId,0) from #validationReturnTable where RowId = @Count      
    SET @Count = @Count + 1      
   
    --Execute the Stored Procedure that calculate the count of Records in Custom Table
     EXEC ssp_SCGetCustomTableCount @DocumentVersionId,@FirstCustomTableName,@CustomTableRecordCount OUT
    
    IF(@CustomTableRecordCount = 0)      
    BEGIN      
         SELECT 'DocumentVersionTable' AS 'TableName',@DocumentVersionId AS DocumentVersionId,@ServiceId AS ServiceId    
       --PRINT @ServiceId    
       IF(@ServiceId > 0)    
		   BEGIN    
				 SELECT    
			'Documents 'AS 'TableName'    
			,[DocumentId]                                      
			 ,[ClientId]                                      
			 ,[ServiceId]                                      
			 ,[GroupServiceId]                                      
			 ,[DocumentCodeId]                                      
			 ,[EffectiveDate]                                      
			 ,[DueDate]                                      
			 ,[Status]                                      
			 ,[AuthorId]                                      
			 ,[CurrentDocumentVersionId]                                      
			 ,[DocumentShared]                                      
			 ,[SignedByAuthor]                                      
			 ,[SignedByAll]                                      
			 ,[ToSign]                                      
			 ,[ProxyId]                                      
			 ,[UnderReview]                                      
			 ,[UnderReviewBy]                                      
			 ,[RequiresAuthorAttention]            
			 ,[InitializedXML]            
			 --,[RowIdentifier]                                      
			 --,[ExternalReferenceId]                        
			 ,[CreatedBy]                                      
			 ,[CreatedDate]                                      
			 ,[ModifiedBy]                                      
			 ,[ModifiedDate]                                      
			 ,[RecordDeleted]                                     
			 ,[DeletedDate]                                      
			 ,[DeletedBy]                                  
		                                                                  
			 FROM [Documents]                     
			 WHERE ISNull(RecordDeleted,'N')='N' and DocumentId=@DocumentId      
		         
			 SELECT    
			'DocumentVersions'AS 'TableName'     
			 ,dv.[DocumentVersionId]                                      
			 ,dv.[DocumentId]                                      
			 ,dv.[Version]                                      
			 ,dv.[EffectiveDate]                                      
			 ,dv.[DocumentChanges]                                      
			 ,dv.[ReasonForChanges]                                      
			 --,[RowIdentifier]                                      
			 --,[ExternalReferenceId]                                      
			 ,dv.[CreatedBy]                                      
			 ,dv.[CreatedDate]                                      
			 ,dv.[ModifiedBy]                                      
			 ,dv.[ModifiedDate]                                      
			 ,dv.[RecordDeleted]                                      
			 ,dv.[DeletedDate]                                      
			 ,dv.[DeletedBy]                                                                          
			 FROM [DocumentVersions] dv
			 Join   [Documents]   d on dv.DocumentVersionId=d.CurrentDocumentVersionId    and ISNull(D.RecordDeleted,'N')='N'                                                                          
			 WHERE ISNull(dv.RecordDeleted,'N')='N' and dv.DocumentVersionId=@DocumentVersionId    
		          
				 SELECT    
			'DocumentInitializationLog'AS 'TableName'     
			 ,di.[DocumentInitializationLogId]                          
			 ,di.[DocumentId]                          
			 ,di.[TableName]                         
			 ,di.[ColumnName]                          
			 ,di.[InitializationStatus]                
			 ,di.[ParentChildName]                          
			 ,di.[ChildRecordId]                          
			 ,di.[RowIdentifier]                        
			 ,di.[CreatedBy]                          
			 ,di.[CreatedDate]                          
			 ,di.[ModifiedBy]                          
			 ,di.[ModifiedDate]                          
			 ,di.[RecordDeleted]                          
			 ,di.[DeletedDate]                          
			 ,di.[DeletedBy]                          
			 FROM [DocumentInitializationLog] di inner join Documents d on di.DocumentId = d.DocumentId and d.[Status] <> 22                             
			 WHERE ISNull(di.RecordDeleted,'N')='N' and ISNull(d.RecordDeleted,'N')='N' and di.DocumentId=@DocumentId     
		 END    
		 --Modified by Dhanil passing @ClientId as first parameter
     EXEC @InitializationStoredProcedure @ClientId,@StaffId,@CustomParameters     
    END      
   END      
    
    DROP TABLE #ServiceTable 
    DROP TABLE #validationReturnTable 
END
GO


