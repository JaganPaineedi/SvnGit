IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_CMPrintCheckNumber')
	BEGIN
		DROP  Procedure  ssp_CMPrintCheckNumber
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
          
          
CREATE PROCEDURE [dbo].[ssp_CMPrintCheckNumber]          
          
 @Claimlines xml,          
 @Date DateTime,          
 @StaffCode varchar(50),          
 @BankAccountId int,          
 @PrintCheckNumber int OUTPUT          
          
/******************************************************************************              
**  File:               
**  Name: Stored_Procedure_Name              
**  Desc: Used for Client Search              
**              
**  This template can be customized:              
**                            
**  Return values:              
**               
**  Called by:                 
**                            
**  Parameters:              
**  Input       Output              
**     ----------       -----------              
**              
**  Auth: Vikrant Tiwari              
**  Date:               
*******************************************************************************              
**  Change History              
*******************************************************************************              
**  Date:  Author:    Description:              
**  --------  --------    -------------------------------------------              
**  05/08/2007		Vikrant For assigning CheckNumbers          
**  10 April 2012   Sourabh	Modified to add new column ClaimLineControlNumber wrt 716(Kalamazoo Bugs)
**  03 December 2013 SuryaBalan [KCMHSAS - Support] wrf 63 Error when processing large bathces of  checks  
**	03.Nov.2014	Rohith Uppin	Changed table name from claimlineplans to ClaimLineCoveragePlans. Task#25 CM to SC. 
**  19.Jan.2015	Rohith Uppin	Provider name column length increased. Task#364 CM to SC issue tracking. 
**  20.Jan.2015 Rohith Uppin	All Temp table column length modified according to Physical table column length. Task#364 CM to SC issues tracking.   
**  28.Jan.2015 David Knewtson	Removed references to deprecated tables InsurerPlans, ClientPlans, and Plans
**  19.Nov.2015 Arjun K R       Added 'ReleaseToProvider' column to the #TableCheckPrint table. Task #54 CEI - Support Go Live
**  26.Aug.2016 Shivanand       Providing a value to 'ReleaseToProvider' column to the #TableCheckPrint table from SystemConfiguration Key. Task #384 Network 180 Environment Issues Tracking
**  07.March.2017 Arjun K R     Condition checking @SumCheckAmount > 0 is removed. Task #156 Network180 Support Go Live.
*******************************************************************************/            
AS          
declare @idoc int          
         
Begin          
BEGIN TRY    
--Added below Codes SuryaBalan 03 December 2013
CREATE TABLE #servicelineids         
            (         
               servicelineid INT,         
               checkamount MONEY,      
               creditamount MONEY      
            )         
    exec sp_xml_preparedocument @idoc OUTPUT, @Claimlines       
insert into #servicelineids              
select * from OPENXML(@idoc, '/root/claims',2)       
WITH (sid  varchar(100),chkamt money,cramt money)    
    
      
          CREATE TABLE #claimdisplayforpayment       
            (       
               claimlineid INT,       
               plan1       VARCHAR(100),       
               plan1amt    MONEY,       
               plan2       VARCHAR(100),       
               plan2amt    MONEY,       
               otheramt    MONEY       
            )       
      
          CREATE TABLE #claimlineplans       
            (       
               claimlineid INT,       
               clientid    INT,       
               insurerid   INT,       
               planid      INT,       
               paidamount  MONEY,       
               coborder    INT,       
               fromdate    DATETIME       
            )       
      
          INSERT INTO #claimlineplans       
                      (claimlineid,       
                       clientid,       
                       insurerid,       
                       planid,       
                       paidamount,       
                       coborder,       
                       fromdate)       
          SELECT oc.claimlineid,       
                 c.clientid,                    c.insurerid,       
                 clp.CoveragePlanId as PlanId,       
                 Sum(clp.paidamount),       
                 1,       
                 Max(cl.fromdate)       
          FROM   openclaims oc       
                 JOIN claimlines cl ON cl.claimlineid = oc.claimlineid       
                 JOIN claims c ON c.claimid = cl.claimid       
                 JOIN ClaimLineCoveragePlans clp ON clp.claimlineid = cl.claimlineid       
                 JOIN #servicelineids sids ON sids.servicelineid = oc.claimlineid       
          WHERE  cl.status IN ( 2023, 2025 )       
                 AND Isnull(cl.recorddeleted, 'N') = 'N'       
                 AND Isnull(c.recorddeleted, 'N') = 'N'       
                 AND Isnull(clp.recorddeleted, 'N') = 'N'       
          GROUP  BY oc.claimlineid,       
                    c.clientid,       
                    c.insurerid,       
                    clp.CoveragePlanId       
          HAVING Sum(clp.paidamount) <> 0       
      

-- dknewtson - 1/28/2014 Removing references to deprecated tables InsurerPlans and ClientPlans
UPDATE  clp
SET     COBOrder = cch.COBOrder
FROM    #ClaimLinePlans clp
        JOIN dbo.InsurerServiceAreas isa
            ON clp.InsurerId = isa.InsurerId
        JOIN dbo.CoveragePlanServiceAreas cpsa
            ON isa.ServiceAreaId = cpsa.ServiceAreaId
        JOIN dbo.CoveragePlans cp
            ON cpsa.CoveragePlanId = cp.CoveragePlanId
               AND clp.PlanId = cp.CoveragePlanId
        JOIN dbo.ClientCoveragePlans ccp
            ON cp.CoveragePlanId = ccp.CoveragePlanId
               AND ccp.ClientId = clp.ClientId
        JOIN dbo.ClientCoverageHistory cch
            ON ccp.ClientCoveragePlanId = cch.ClientCoveragePlanId
               AND cpsa.ServiceAreaId = cch.ServiceAreaId
       --join InsurerPlans ip on ip.InsurerId = clp.InsurerId and ip.PlanId = clp.PlanId   
       --join ClientPlans cp on cp.ClientId = clp.ClientId and cp.InsurerPlanId = ip.InsurerPlanId
 --where cp.EffectiveFrom <= clp.FromDate 
 --  and (cp.EffectiveTo >= clp.FromDate or isnull(cp.EffectiveTo, '') = '')
 --  and isnull(cp.RecordDeleted, 'N') = 'N'   
 --  and isnull(ip.RecordDeleted, 'N') = 'N'   
WHERE   cch.StartDate <= clp.FromDate
        AND (
              cch.EndDate >= clp.FromDate
              OR ISNULL(cch.EndDate, '') = ''
            )
        AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
        AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
        AND ISNULL(cpsa.RecordDeleted, 'N') <> 'Y'
        AND ISNULL(isa.RecordDeleted, 'N') <> 'Y' 
             
      
          INSERT INTO #claimdisplayforpayment       
          SELECT clp.claimlineid,       
                 Max(CASE       
                       WHEN clp.coborder = 1 THEN clp.planname       
                       ELSE NULL       
                     END) AS Plan1,       
                 Sum(CASE       
                       WHEN clp.coborder = 1 THEN clp.paidamount       
                       ELSE 0       
                     END) AS Plan1Amt,       
                 Max(CASE       
                       WHEN clp.coborder = 2 THEN clp.planname       
                       ELSE NULL       
                     END) AS Plan2,       
                 Sum(CASE       
                       WHEN clp.coborder = 2 THEN clp.paidamount       
                       ELSE 0       
                     END) AS Plan2Amt,       
                 Sum(CASE       
                       WHEN clp.coborder > 2 THEN clp.paidamount       
                       ELSE 0       	
                     END) AS OtherAmt       
          FROM   (SELECT clp.claimlineid,       
                         p.CoveragePlanName AS PlanName,       
                         clp.paidamount,       
                         Row_number()       
                           OVER (       
                             partition BY clp.claimlineid       
                             ORDER BY clp.coborder, clp.planid) AS COBOrder       
                  FROM   #claimlineplans clp       
                         JOIN CoveragePlans p       
                           ON p.CoveragePlanId = clp.planid) AS clp       
          GROUP  BY clp.claimlineid 	
     
--In #ClaimlinesTempTable we will get the table pass in the form of XML          
CREATE TABLE #ClaimlinesTempTable (ServiceLineID  nvarchar(20), Member varchar(80),          
       Provider varchar(100), DOS varchar(20),          
       [CPT/HCPCS Code+Mods] nvarchar(50),          
       [Rev Code] varchar(25),           
       Units decimal,          
       CodeName varchar(250),          
       Insurer varchar(100),          
       [Claimed Amt] varchar(20),          
       [Payable Amt] decimal,          
       TaxId varchar(50),PayableName varchar(100),          
       TaxIdType varchar(50),InsurerId int,          
       ProviderId int,          
       CheckAmount float,          
       CreditAmount float,Plan1 varchar(100),Plan1Amt float,          
       Plan2 varchar(100),Plan2Amt float,          
       OtherAmt float)           
--In #TableCheckPrint we will get the check numbers for group of Claimlines based on Provider & TaxId, and this will be used in Displaying Check number row by XSLT           
CREATE TABLE #TableCheckPrint(          
    CheckNumber varchar(50),          
       PayeeName  varchar(50),          
    Amount money,          
    TaxId varchar(50),          
    TaxIdType varchar(50),          
    InsurerId Int,          
    InsurerBankAccountId Int,          
    ProviderId Int,          
    CheckDate DateTime,          
    Memo varchar(50),          
    Voided varchar(50),          
   -- RowIdentifier varchar(50),          
    CreatedBy varchar(50),          
    CreatedDate varchar(50),          
    ModifiedBy varchar(50),          
    ModifiedDate varchar(50),          
    RecordDeleted varchar(50),          
    DeletedDate varchar(50),          
    DeletedBy varchar(50),
    [835FileText] varchar(max),
    [ClaimLineControlNumber] varchar(50),
    ReleaseToProvider varchar(50)       
    )          
--In #TableXslClaimlines we will get the Claimlines for which check is generated, and this will be used in Displaying ClaimLines row by XSLT           
  
CREATE TABLE #TableXslClaimlines (ServiceLineID  varchar(10), Member varchar(80),          
               Provider varchar(100), DOS varchar(20),          
               [CPT/HCPCS Code+Mods] varchar(50),          
         [Rev Code] varchar(10),           
               Units decimal,          
               CodeName varchar(250),          
               Insurer varchar(100),          
               [Claimed Amt] varchar(50),          
             [Payable Amt] money,          
               TaxId varchar(50),PayableName varchar(100),          
               TaxIdType varchar(50),InsurerId int,         
               ProviderId int,CheckAmount varchar(50),          
               CreditAmount varchar(50),Plan1 varchar(100),Plan1Amt varchar(50),          
         Plan2 varchar(100),Plan2Amt varchar(50),          
               OtherAmt varchar(50))           
          
--Commented by SuryaBalan 03-Dec-2013        
--exec sp_xml_preparedocument @idoc OUTPUT, @Claimlines  
          
          
insert into #ClaimlinesTempTable          
           
--SuryaBalan 03-Dec-2013
SELECT claimlines.claimlineid,       
                 clients.lastname + ',' + clients.firstname AS ClientName,       
                 providers.providername,       
                 claimlines.fromdate,       
                 CASE       
                   WHEN claimlines.units IS NULL THEN claimlines.procedurecode       
                   ELSE claimlines.procedurecode + ' '       
                        +       
  Substring(CONVERT(VARCHAR, CONVERT(DECIMAL(18, 0), claimlines.units)), 1, 6)       
         + 'Units'       
  END                                        AS ProcedureCode,       
  claimlines.revenuecode,       
  claimlines.units,       
  globalcodes.codename,       
  insurers.insurername,       
  claimlines.claimedamount,       
  claimlines.payableamount,       
  sites.taxid,       
  sites.payablename,       
  sites.taxidtype,       
  claims.insurerid,       
  sites.providerid,       
  sids.checkamount,       
  sids.creditamount,       
  plan1,       
  plan1amt,       
  plan2,       
  plan2amt,       
  otheramt       
  FROM   claimlines       
         INNER JOIN claims       
                 ON claimlines.claimid = claims.claimid       
         INNER JOIN sites       
                 ON sites.siteid = claims.siteid       
         INNER JOIN globalcodes       
                 ON globalcodes.globalcodeid = claimlines.status       
         INNER JOIN clients       
                 ON claims.clientid = clients.clientid       
         INNER JOIN providers       
                 ON providers.providerid = sites.providerid       
         INNER JOIN insurers       
                 ON insurers.insurerid = claims.insurerid       
         JOIN #servicelineids sids       
           ON sids.servicelineid = claimlines.claimlineid       
         LEFT OUTER JOIN #claimdisplayforpayment       
                      ON claimlines.claimlineid =       
                         #claimdisplayforpayment.claimlineid       
  WHERE  Isnull(claimlines.recorddeleted, 'N') <> 'Y'       
         AND Isnull(claims.recorddeleted, 'N') <> 'Y'       
         AND Isnull(sites.recorddeleted, 'N') <> 'Y'       
         AND Isnull(globalcodes.recorddeleted, 'N') <> 'Y'       
         AND Isnull(clients.recorddeleted, 'N') <> 'Y'       
         AND Isnull(providers.recorddeleted, 'N') <> 'Y'       
         AND Isnull(insurers.recorddeleted, 'N') <> 'Y'       
      
  -- select * from #ServiceLineIDs            
  INSERT INTO #claimlinestemptable       
              (servicelineid,       
               member,       
               provider,       
               dos,       
               taxid)       
  VALUES      (0,       
               '',       
               'ZZZZZZZZZ',       
               '01/01/1900',       
               'ZZZZZZZZZ')   
         
--select * from OPENXML(@idoc, '/PayClaims/ViewPayClaims',2)           
--WITH (ServiceLineID  varchar(10), Member varchar(20),          
      --Provider varchar(50), DOS varchar(20),          
      --CPTMods varchar(50),          
   --[Rev Code] varchar(50),          
     -- Units decimal,         
      --CodeName varchar(50),          
      --Insurer varchar(50),          
      --ClaimedAmt varchar(50),          
      --PayableAmt decimal,          
      --TaxId varchar(50),PayableName varchar(50),          
   --TaxIdType varchar(50),InsurerId int,          
     --ProviderId int,CheckAmount float,          
      --CreditAmount float,Plan1 varchar(50),Plan1Amt float,          
      --Plan2 varchar(50),Plan2Amt float,OtherAmt float)          
          
      
         
--select * from #ClaimlinesTempTable order by Provider,TaxId           
        
  declare @ReleaseToProvider varchar(100)
  select Top 1 @ReleaseToProvider= Value from SystemConfigurationkeys WHERE [Key]='DefaultReleaseCheckToProvider'        
               
Declare @ServiceLineID  varchar(10),@Member varchar(80),@Provider varchar(100),          
  @DOS varchar(20),@CPTHCPCSCode varchar(50),@RevCode varchar(50),@Units decimal,@CodeName varchar(250),@Insurer varchar(100),          
        @ClaimedAmt varchar(50),@PayableAmt decimal,@TaxId varchar(50),@PayableName varchar(100),          
        @TaxIdType varchar(50),@InsurerId int,@ProviderId int,@CheckAmount float,          
        @CreditAmount float,@Plan1 varchar(100),@Plan1Amt float,@Plan2 varchar(100),@Plan2Amt float,@OtherAmt float,          
    
  @PrevPayableName varchar(50),@PrevTaxId varchar(50),@PrevTaxIdType varchar(50),@PrevProviderId int,@PrevInsurerId int,    
            
  @FirstProvider varchar(50), @NextProvider varchar(50),@previousTaxId varchar(50),@nextTaxId varchar(50),            
   @SumCheckAmount money          
  set @SumCheckAmount=0          
  set @NextProvider=''          
  set @previousTaxId=''          
  set @nextTaxId=''          
          
--In this cursor I will compare provider of each claimlines, if they are same then I will compare taxId if it is also same then no check will be generated          
--but if either of Provider,taxid gets changed then Checknumber has to be generated.            
DECLARE Provider_cursor CURSOR FOR           
SELECT ServiceLineID,Member,Provider,DOS,[CPT/HCPCS Code+Mods],Units,CodeName,Insurer,[Claimed Amt],[Payable Amt],          
  TaxId,PayableName,TaxIdType ,InsurerId,ProviderId,CheckAmount,CreditAmount,Plan1 ,Plan1Amt,OtherAmt          
FROM #ClaimlinesTempTable          
ORDER BY Provider,TaxId           
          
OPEN Provider_cursor          
          
FETCH NEXT FROM Provider_cursor           
INTO @ServiceLineID,@Member,@Provider,@DOS,@CPTHCPCSCode,@Units,@CodeName,@Insurer,@ClaimedAmt,@PayableAmt,        
  @TaxId,@PayableName,@TaxIdType ,@InsurerId,@ProviderId,@CheckAmount,@CreditAmount,@Plan1 ,@Plan1Amt,@OtherAmt          
          
WHILE @@FETCH_STATUS = 0          
BEGIN          
          
 set @FirstProvider=@Provider          
           
    if(@FirstProvider != @NextProvider)--if Provider is changed then generate a check number          
  Begin          
              
     -- Arjun K R 07-March-2017         
    if @NextProvider!=''          
       Begin          
          --insert into tablecheckprint           
        -- if @SumCheckAmount>0          
         -- Begin          
            insert into #tablecheckprint(CheckNumber,PayeeName,Amount,TaxId,TaxIdType,InsurerId,          
                    InsurerBankAccountId,ProviderId,CheckDate,Memo,Voided,          
                    CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,[835Filetext],[ClaimLineControlNumber],ReleaseToProvider)          
             values           
                   (@PrintCheckNumber,@PrevPayableName,@SumCheckAmount,@PrevTaxId,@PrevTaxIdType,@PrevInsurerId,          
                    @BankAccountId  ,@PrevProviderId,Convert(DateTime,@Date,101) ,null,null,          
                    @StaffCode,@Date,@StaffCode,@Date,'N',null,null,null,null,@ReleaseToProvider)           
                
                                  
            set @PrintCheckNumber=@PrintCheckNumber+1;          
      --    End          
         --else          
         -- Begin          
         --   insert into #tablecheckprint(CheckNumber,PayeeName,Amount,TaxId,TaxIdType,InsurerId,          
         --           InsurerBankAccountId,ProviderId,CheckDate,Memo,Voided,          
         --           CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,[835Filetext],[ClaimLineControlNumber],ReleaseToProvider)          
         --    values           
         --          (-1,@PrevPayableName,@SumCheckAmount,@PrevTaxId,@PrevTaxIdType,@PrevInsurerId,          
         --           @BankAccountId  ,@PrevProviderId,Convert(DateTime,@Date,101) ,null,null,          
         --           @StaffCode,@Date,@StaffCode,@Date,'N',null,null,null,null,@ReleaseToProvider)           
         -- End               
                      
         set @SumCheckAmount=0  -- for a Provider,TaxId a check is generated so @SumCheckAmount set it to zero          
       End          
    set @NextProvider=@Provider          
    set @previousTaxId=@TaxId          
    set @nextTaxId=@TaxId          
              
  End          
    else          
   Begin          
    set @previousTaxId=@TaxId          
    if @previousTaxId != @nextTaxId --if Provider is same , but TaxId is changed then generate a check number          
    Begin          
      -- Arjun K R 07-March-2017            
       if @nextTaxId != ''          
         Begin          
         --insert into tablecheckprint           
        -- if(@SumCheckAmount>0)          
         --    Begin          
            insert into #tablecheckprint(CheckNumber,PayeeName,Amount,TaxId,TaxIdType,InsurerId,          
              InsurerBankAccountId,ProviderId,CheckDate,Memo,Voided,          
              CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,[835FileText],[ClaimLineControlNumber],ReleaseToProvider)         
             values           
                (@PrintCheckNumber,@PrevPayableName,@SumCheckAmount,@PrevTaxId,@PrevTaxIdType,@PrevInsurerId,          
              @BankAccountId  ,@PrevProviderId,Convert(DateTime,@Date,101) ,null,null,          
              @StaffCode,@Date,@StaffCode,@Date,'N',null,null,null,null,@ReleaseToProvider)           
                                           
            set @PrintCheckNumber=@PrintCheckNumber+1          
    --         End          
         --else          
         --    Begin          
         --   insert into #tablecheckprint(CheckNumber,PayeeName,Amount,TaxId,TaxIdType,InsurerId,          
         --     InsurerBankAccountId,ProviderId,CheckDate,Memo,Voided,          
         --     CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,[835FileText],[ClaimLineControlNumber],ReleaseToProvider)
         --    values           
         --       (-1,@PrevPayableName,@SumCheckAmount,@PrevTaxId,@PrevTaxIdType,@PrevInsurerId,          
         --     @BankAccountId  ,@PrevProviderId,Convert(DateTime,@Date,101) ,null,null,          
         --     @StaffCode,@Date,@StaffCode,@Date,'N',null,null,null,null,@ReleaseToProvider)           
         --    End               
                            
         set @SumCheckAmount=0  -- for a Provider,TaxId a check is generated so @SumCheckAmount set it to zero          
          End          
     set @nextTaxId=@TaxId          
                  
    End           
   End          
          
 if @CheckAmount > 0          
    Begin          
     Begin Try          
      set @SumCheckAmount = @SumCheckAmount + @CheckAmount          
     End Try          
     Begin catch          
       SELECT ERROR_NUMBER() AS ErrorNumber;          
     End Catch          
          
    End          
     --This is added so that the last row manually entered doesnot come, this row is added in .net code.          
     if @TaxId !='ZZZZZZZZZ'          
     Begin          
       --insert into @TableXslClaimlines          
       insert into #TableXslClaimlines(ServiceLineID,Member,Provider,DOS,[CPT/HCPCS Code+Mods],          
                 [Rev Code],Units,CodeName,Insurer,[Claimed Amt],[Payable Amt],          
                 CheckAmount,CreditAmount,ProviderId,TaxId,Plan1,Plan1Amt,          
                 Plan2,Plan2Amt,OtherAmt)            
            Values    (@ServiceLineID,@Member,@Provider,@DOS ,@CPTHCPCSCode ,          
                 @RevCode,@Units ,'Paid',@Insurer ,@ClaimedAmt ,@PayableAmt,          
              @CheckAmount,@CreditAmount,@ProviderId,@TaxId,@Plan1,@Plan1Amt,          
                 @Plan2,@Plan2Amt,@OtherAmt)          
     End          
              
           
select @PrevPayableName=@PayableName,@PrevTaxId=@TaxId,@PrevTaxIdType=@TaxIdType,@PrevInsurerId=@InsurerId,@PrevProviderId=@ProviderId  
          
   
          
FETCH NEXT FROM Provider_cursor           
INTO @ServiceLineID,@Member,@Provider,@DOS,@CPTHCPCSCode,@Units,@CodeName,@Insurer,@ClaimedAmt,@PayableAmt,          
  @TaxId,@PayableName,@TaxIdType ,@InsurerId,@ProviderId,@CheckAmount,@CreditAmount,@Plan1 ,@Plan1Amt,@OtherAmt          
END           
CLOSE Provider_cursor          
DEALLOCATE Provider_cursor          
          
select * from  #tablecheckprint          
select * from  #TableXslClaimlines          
return @PrintCheckNumber      
        
  DROP TABLE #claimlinestemptable       
      
  DROP TABLE #tablecheckprint       
      
  DROP TABLE #tablexslclaimlines       
      
  DROP TABLE #claimdisplayforpayment       
      
  DROP TABLE #claimlineplans       
      
  DROP TABLE #servicelineids 
 
--drop table #ClaimlinesTempTable drop table #tablecheckprint drop table #TableXslClaimlines          
END TRY        
BEGIN CATCH        
     DECLARE @ErrorMessage NVARCHAR(4000);  
      DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
  
    SELECT @ErrorMessage = ERROR_MESSAGE(),  
           @ErrorSeverity = ERROR_SEVERITY(),  
           @ErrorState = ERROR_STATE();  
  
    -- Use RAISERROR inside the CATCH block to return   
    -- error information about the original error that   
    -- caused execution to jump to the CATCH block.  
    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
  
  
END CATCH        
End          
          
          
  