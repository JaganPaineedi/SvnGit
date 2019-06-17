 IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMGetChecksFilteredDetail]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMGetChecksFilteredDetail] 

GO         
CREATE PROCEDURE [dbo].[ssp_CMGetChecksFilteredDetail]-- 550,-1,-1,'A',Null,'02/06/2014','11/23/2015',-1,0,200,-1,'checkdate',Null                   
                      
(                    
 @staffid int,                    
 @insurerid int,                    
 @providerid int,                    
 @taxid varchar(15),  
   
 @voidchecks CHAR(1),                    
-- @printstatus int,                    
 @datefrom varchar(10),                    
 @dateto varchar(10),                    
 @InsurerBankAccountId int,         
 @PageNumber int,                
 @PageSize int,          
 @OtherFilter int , 
 @CheckNumber varchar(100)  ,           
 @SortExpression  varchar(50)='checknumber',              
 @SortOrder varchar(4) ='asc'                    
)                    
AS                    
/*********************************************************************/                      
/* Stored Procedure: ssp_GetChecksFilteredDetail           */                      
/* Copyright: 2005 Provider Claim Management System,  PCMS             */                      
/* Creation Date:    1/12/06                                         */                      
/*                                                                   */                      
/* Purpose:  It is used to return the detail used in Manually Approvd Claim Screen          */                     
/*                                                                   */                    
/* Input Parameters: @staffid int,@insurerid int,@providerid int,@siteid int,@printstatus int,@dateto datetime,@datefrom datetime,            */                    
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
/* 1/12/06   Gursharan    Created                                    */  
/* 10 July 2014 Task #55 CM to SC Project, Created and Modified for CM Checks List Page */  
/* 2 Sept 2014 Task #55 CM to SC Project, Added Check Number for Search */   
/* 7 Oct 2014 SuryaBalan Task #16 Care Management to SmartCare Env. Issues Tracking  Fixed Check List Page - data does not display in list  */  
/* 28 Oct 2014 SuryaBalan Task #81 Care Management to SmartCare Env. Issues Tracking  Fixed For AllProviders it should display all rrcords depends on Associated provider with staff */                    
/* 30 Dec 2014 Arjun K R  #319 CM to SC Env Issues Tracking- Records are not showing if allinsurer and allproviders is set to 'Y' issue is fixed */                 
/* 23 Nov 2015 Manikandan R M What:#708.1 Network 180 Environment Issues Tracking ,Why: checks not listed as Under Review on Checks and PA Checks List Page
 */
/* 16 Oct 2018 K.Soujanya     What:Added logic to get PagePayableAmount and AllPayableAmount,Why: KCMHSAS - Enhancements#54 */
                 
/*********************************************************************/                       
        
        
DECLARE @CustomFiltersApplied CHAR(1)            
    CREATE TABLE #CustomFilters(DocumentId Int)            
    SET @CustomFiltersApplied = 'N'            
                        
                    
declare @str NVarchar(4000)                    
  DECLARE @PagePayableAmount MONEY    
  DECLARE @AllPayableAmount MONEY           
          
          
  IF @SortExpression = ''          
  Set @SortExpression = 'payeename'          
 IF  @SortOrder = ''          
  Set @SortOrder = 'asc'           
          
         
 IF @OtherFilter > 10000                   
 BEGIN               
  SET @CustomFiltersApplied = 'Y'            
            
  INSERT INTO #CustomFilters(DocumentId)            
          
  EXEC scsp_CMGetChecksFilteredDetail      
   @staffid = @staffid,                  
   @insurerid =@insurerid,                    
   @providerid =@providerid,                    
   @taxid =@taxid,
   @CheckNumber=@CheckNumber,      
   @voidchecks=@voidchecks,                    
   @datefrom= @datefrom,                    
   @dateto =@dateto,                    
   @InsurerBankAccountId =@InsurerBankAccountId,         
   @PageNumber =@PageNumber,                
   @PageSize =@PageSize,          
   @OtherFilter =@OtherFilter ,              
   @SortExpression  =@SortExpression,              
   @SortOrder =@SortOrder           
 END         
         
         
 CREATE TABLE #ResultSet               
            (             
               CheckBox  INT,          
               checkdate Datetime,
               --23/11/2015 Manikandan         
               checknumber varchar(100),        
               payeename VARCHAR (100), 
               CheckStatus  CHAR(20),      
               voided CHAR(10),        
               amount MONEY,        
               insurername VARCHAR(500) ,        
               checkid INT,        
               taxid CHAR(50),        
               insurerid INT ,
               providerid INT,
               BankName VARCHAR(200),
               ReleaseToProvider VARCHAR(20)        
             )             
     BEGIN                    
                    
set @str = 'Select  0 as CheckBox, checkdate,checknumber,payeename,  case isnull(checks.voided ,''N'') when   ''N'' then ''Non-Void Checks'' else ''Void Checks'' end CheckStatus   ,                
case isnull(checks.voided ,''N'') when   ''N'' then '''' else ''Void'' end voided,amount,insurers.insurername,checkid,checks.taxid,checks.insurerid,checks.providerid,IB.BankName,ReleaseToProvider '                    
set @str = @str + ' from checks join insurers insurers on checks.insurerid = insurers.insurerid '     
set @str = @str + '  join Providers P on checks.ProviderId = P.ProviderId' 
set @str = @str + '  join InsurerBankAccounts IB on checks.InsurerBankAccountId  = IB.InsurerBankAccountId ' 
   
 if(@CheckNumber <> '')
 set @str = @str +' and Convert(varchar,checks.checknumber) like '+'''%'+convert(varchar,@CheckNumber)+'%''' 
	       

 if(@insurerid > 0)  
 begin                  
  set @str = @str + ' and checks.insurerid = ' + Cast(@insurerid as varchar)
 end
 else
	begin
		declare @AllStaffInsurers Varchar(1)
		select @AllStaffInsurers=AllInsurers from staff where staffid=@staffid
		if(@AllStaffInsurers='Y')
			BEGIN
			  SET @str = @str + ' and checks.InsurerId in (Select InsurerId from Insurers where ISNULL(RecordDeleted,''N'')=''N'')'
			END
		else
			BEGIN
				SET @str=@str + 'and checks.InsurerId in (Select InsurerId from staffInsurers where RecordDeleted<>''Y'' and staffid='+Cast(@staffid as varchar)+')'
			END
	end
                        
 if(@providerid > 0 )
 begin	
     set @str = @str + ' and checks.providerid = '+ Cast(@providerid as varchar) 
 end   
 else
	 Begin
		DECLARE @AllStaffProvider VARCHAR(1)
	    SELECT @AllStaffProvider =AllProviders FROM staff WHERE staffid=@staffid
	    IF(@AllStaffProvider = 'Y')
			BEGIN
				SET @str = @str + ' and checks.providerid in (Select ProviderId from Providers where ISNULL(RecordDeleted,''N'')=''N'')'
			END
		ELSE
			BEGIN
				SET @str=@str + 'and checks.providerid in (Select ProviderId from staffproviders where RecordDeleted<>''Y'' and staffid='+Cast(@staffid as varchar)+')'
			END
	 end
 
 
 
 --if(ltrim(rtrim(@taxid)) <> 'All Tax Ids' )                    
 -- set @str = @str + ' and checks.taxid =  ''' + @taxid + ''''       
 if(ltrim(rtrim(@voidchecks)) <> 'A' )                    
  set @str = @str + ' and isnull(checks.voided ,''N'') =  ''' + @voidchecks + ''''                    
 if(@datefrom <> '' and  @dateto <> '')                    
   set @str = @str +  ' and Convert(Datetime,Convert(varchar,checkdate,101)) >= ''' + Convert(varchar,@datefrom,101) + ''' and Convert(Datetime,Convert(varchar,checkdate,101)) <= ''' + Convert(varchar,@dateto,101) + ''''                     
 else if(@datefrom = '' and  @dateto <> '')                    
  set @str = @str +  ' and Convert(Datetime,Convert(varchar,checkdate,101)) <= ''' + Convert(varchar,@dateto,101)  + ''''                    
 else if(@datefrom <> '' and  @dateto = '')                    
   set @str = @str +  ' and Convert(Datetime,Convert(varchar,checkdate,101)) >= ''' + Convert(varchar,@datefrom,101) + ''' and Convert(Datetime,Convert(varchar,checkdate,101)) <= ''' + Convert(varchar,getdate(),101)  + ''''                    
 else if(@datefrom = '' and  @dateto = '')                    
  set @str = @str + ' and Convert(Datetime,Convert(varchar,checkdate,101)) >= '''+ Convert(varchar,dateadd(month,-12,getdate()),101) + ''' and Convert(Datetime,Convert(varchar,checkdate,101)) <= ''' + Convert(varchar,getdate(),101)  + ''''                
 
     
 if(@InsurerBankAccountId > 0)                    
  set @str = @str + ' and checks.InsurerBankAccountId = ' + Cast(@InsurerBankAccountId as varchar)                      
set @str = @str + ' and  isnull(checks.recorddeleted,''N'') = ''N'' and IsNull(insurers.RecordDeleted,''N'') =''N'' and insurers.Active=''Y'''                    
--set @str = @str + ' and  1= 2'                    
                        
--print @taxID + @str                    
--exec @str                    
         
        
 Insert Into #ResultSet  Execute SP_EXECUTESQL @str               
                    
--Execute SP_EXECUTESQL @str                    
--select @str as Ret         
  SELECT @AllPayableAmount = sum(c.Amount)    
 FROM #ResultSet rs    
 JOIN Checks c ON c.CheckId = rs.checkid;      
        
;With counts             
   AS (SELECT Count(*) AS TotalRows FROM   #ResultSet),             
    RankResultSet AS (        
    SELECT         
               CheckBox,          
               checkdate,        
               checknumber ,        
               payeename, 
               CheckStatus,       
               voided,        
               amount,        
               insurername,        
               checkid,        
               taxid ,        
               insurerid ,   
               providerid, 
               BankName  ,
                   --23/11/2015 Manikandan    
               ReleaseToProvider ,      
     Count(*) OVER ( )   AS TotalCount,             
     Rank()             
      OVER( ORDER BY           
     CASE WHEN @SortExpression= 'checkdate' THEN checkdate END,           
     CASE WHEN @SortExpression= 'checkdate desc' THEN checkdate END DESC ,        
     CASE WHEN @SortExpression= 'checknumber' THEN checknumber END,           
     CASE WHEN @SortExpression= 'checknumber desc' THEN checknumber END DESC ,        
     CASE WHEN @SortExpression= 'payeename' THEN payeename END,           
     CASE WHEN @SortExpression= 'payeename desc' THEN payeename END DESC,        
     CASE WHEN @SortExpression= 'voided' THEN voided END,           
     CASE WHEN @SortExpression= 'voided desc' THEN voided END DESC,        
     CASE WHEN @SortExpression= 'amount' THEN amount END,           
     CASE WHEN @SortExpression= 'amount desc' THEN amount END DESC,        
     CASE WHEN @SortExpression= 'insurername' THEN insurername END,           
     CASE WHEN @SortExpression= 'insurername desc' THEN insurername END DESC ,
     CASE WHEN @SortExpression= 'CheckStatus' THEN CheckStatus END,           
     CASE WHEN @SortExpression= 'CheckStatus desc' THEN CheckStatus END DESC ,
     CASE WHEN @SortExpression= 'BankName' THEN BankName END,             
     CASE WHEN @SortExpression= 'BankName desc' THEN BankName END DESC, 
         --23/11/2015 Manikandan    
     CASE WHEN @SortExpression= 'ReleaseToProvider' THEN ReleaseToProvider END,             
     CASE WHEN @SortExpression= 'ReleaseToProvider desc' THEN ReleaseToProvider END DESC  
     
            
                
      , checknumber) AS RowNumber             
    FROM   #ResultSet)           
               
    SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(Totalrows, 0) FROM Counts) ELSE (@PageSize) END)             
               Checkbox ,          
               Convert(varchar(10),checkdate, 101 ) AS checkdate,        
               --checkdate,        
               checknumber ,        
               payeename, 
               CheckStatus,       
               voided,        
               amount,        
               insurername,        
               checkid,        
               taxid ,        
               insurerid ,    
               providerid,
               BankName,
                   --23/11/2015 Manikandan    
               ReleaseToProvider,       
               TotalCount,           
               RowNumber             
   INTO   #FinalResultSet             
   FROM   RankResultSet             
   WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize )      
       
    declare @CheckIds varchar(max);    
    SELECT @CheckIds = COALESCE(@CheckIds + ',', '') + CAST(Rs.checkid  AS VARCHAR)    
FROM   #ResultSet Rs
 SELECT @PagePayableAmount = sum(Amount)    
 FROM #FinalResultSet           
            
   IF (SELECT Isnull(Count(*), 0) FROM   #FinalResultSet) < 1             
   BEGIN             
    SELECT 0   AS PageNumber             
     , 0 AS NumberOfPages             
     , 0 NumberOfRows   
     , '' as CheckIds 
     ,0 AS PagePayableAmount    
     ,0 AS AllPayableAmount               
   END             
   ELSE             
   BEGIN             
    SELECT TOP 1 @PageNumber AS PageNumber             
     , CASE ( TotalCount % @PageSize )             
      WHEN 0 THEN Isnull(( TotalCount / @PageSize ),0)             
     ELSE Isnull(( TotalCount / @PageSize ), 0) + 1             
     END NumberOfPages             
     , Isnull(TotalCount, 0) AS NumberOfRows  ,@CheckIds as CheckIds 
     ,@PagePayableAmount AS PagePayableAmount    
     ,@AllPayableAmount AS AllPayableAmount           
    FROM   #FinalResultSet             
   END            
             
   SELECT       Checkbox ,          
                checkdate, 
                    --23/11/2015 Manikandan    
                CASE WHEN  ReleaseToProvider='N'
                THEN checknumber+'-Under Review' 
                ELSE
                checknumber
                END AS checknumber,             
                payeename, 
                CheckStatus,       
                voided,        
                amount,        
                insurername,        
                checkid,        
                taxid ,        
                insurerid,
                providerid ,
                BankName ,
                ReleaseToProvider     
               FROM   #FinalResultSet ORDER  BY RowNumber          
                   
                    
 IF (@@error!=0)                      
    BEGIN                      
       RAISERROR ('ssp_CMGetChecksFilteredDetail: An Error Occured While Updating ',16,1);                     
      END                     
                    
                    
END                    
                    