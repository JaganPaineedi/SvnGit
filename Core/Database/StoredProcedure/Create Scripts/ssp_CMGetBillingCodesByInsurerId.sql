IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodesByInsurerId]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMGetBillingCodesByInsurerId] 

GO
Create Procedure [dbo].[ssp_CMGetBillingCodesByInsurerId] 
( @InsurerID int,
  @StartDate datetime,
  @EndDate datetime,
  @Characters VARCHAR(max) = ''
)
As    
  
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_CMGetBillingCodesByInsurerId            */                  
/* Copyright: 2005 Provider Claim Management System             */                  
/* Creation Date:  May 22/2014                                */                  
/*                                                                   */                  
/* Purpose: it will get all billingcodes for an insurer.             */                 
/*                                                                   */                
/* Input Parameters: @Active          */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return:Plan Records based on the applied filer  */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/*  Date          Author               Purpose                                    */                  
/* May 22/2014    Shruthi.S            Created                                    */    
/* Dec 04/2014    Vichee Humane        Modified Sort Order CM to SC EIT #197      */ 
/* Aug 22/2016    Vithobha				Modified  fetching of BillingCode from Description to Modifiers, CEI - Support Go Live: #258      */    
-- Dec 29/2017	  jcarlson				HEartland EIT 70 - Changed billing code dropdown to searchable textbox, added characters parameter to filter result set               
/* Dec 18 2018    Arjun K R             Added Condition to filter records based on start date and end date.Task #900.77 KCMHSAS Enhancement  */
/*********************************************************************/       

Begin Try
--Get BillingCode   For  InsurerID  
SELECT  distinct BillingCodes.BillingCodeId,   
--Aug 22/2016    Vithobha	
CASE WHEN  ISNULL(BCM.Modifier1,'') = '' AND ISNULL(BCM.Modifier2,'') = '' AND ISNULL(BCM.Modifier3,'') = '' AND ISNULL(BCM.Modifier4,'') = '' 
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) 
	WHEN ISNULL(BCM.Modifier2,'') = '' AND ISNULL(BCM.Modifier3,'') = '' AND ISNULL(BCM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,'')))
	WHEN ISNULL(BCM.Modifier3,'') = '' AND ISNULL(BCM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,''))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier2,'')))
	WHEN ISNULL(BCM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,''))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier2,''))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier3,'')))
	ELSE
		Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + 
		+ ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,''))) + ':' + Ltrim(RTrim(Isnull(BCM.Modifier2,''))) + ':' + Ltrim(RTrim(Isnull(BCM.Modifier3,''))) + ':' + Ltrim(RTrim(Isnull(BCM.Modifier4,'')))
	END as BillingCode,   
  BillingCodes.CodeName,    
Cast(dbo.BillingCodes.Units as decimal(18,0)) as Units,    
 dbo.BillingCodes.UnitType,     
      dbo.GlobalCodes.CodeName AS UnitTypeName  
      ,BCM.Modifier1,BCM.Modifier2,BCM.Modifier3,BCM.Modifier4  
,BCM.BillingCodeModifierId,   (Convert(Varchar,BillingCodes.BillingCodeId) + '_' +  Convert(Varchar,BCM.BillingCodeModifierId)) as BillingCodeAndCodeModifierId  
INTO #Results
FROM         dbo.BillingCodes INNER JOIN    
             dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId   
            inner Join BillingCodeModifiers BCM on BillingCodes.BillingCodeId = BCM.BillingCodeId and ISNULL(BCM.RecordDeleted,'N') = 'N'   
WHERE     (dbo.BillingCodes.AllInsurers = 'Y') AND (dbo.BillingCodes.Active = 'Y') AND    
  isnull(dbo.BillingCodes.RecordDeleted,'N')='N' AND   isnull(dbo.GlobalCodes.RecordDeleted,'N')='N'  
  AND (((cast(isnull(BCM.StartDate,0) as date) <= cast(isnull(@StartDate,0) as date)) OR @StartDate IS NULL) --Dec 18 2018    Arjun K R 
    AND ((cast(isnull(BCM.EndDate,2958463) as date) >= cast(isnull(@EndDate,2958463) as date)) OR @EndDate IS NULL)
  ) 
  AND ISNULL(BCM.Active,'Y')='Y'
  
  Union All    


SELECT dbo.BillingCodes.BillingCodeId,  
--Aug 22/2016    Vithobha	
CASE WHEN  ISNULL(BCM.Modifier1,'') = '' AND ISNULL(BCM.Modifier2,'') = '' AND ISNULL(BCM.Modifier3,'') = '' AND ISNULL(BCM.Modifier4,'') = '' 
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) 
	WHEN ISNULL(BCM.Modifier2,'') = '' AND ISNULL(BCM.Modifier3,'') = '' AND ISNULL(BCM.Modifier4,'') = ''	
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,'')))
	WHEN ISNULL(BCM.Modifier3,'') = '' AND ISNULL(BCM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,''))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier2,'')))
	WHEN ISNULL(BCM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,''))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier2,''))) + ' :' + Ltrim(RTrim(Isnull(BCM.Modifier3,'')))
	ELSE
		Ltrim(Rtrim(BillingCodes.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BillingCodes.CodeName,'-', ' '))) + 
		+ ' :' + Ltrim(RTrim(Isnull(BCM.Modifier1,''))) + ':' + Ltrim(RTrim(Isnull(BCM.Modifier2,''))) + ':' + Ltrim(RTrim(Isnull(BCM.Modifier3,''))) + ':' + Ltrim(RTrim(Isnull(BCM.Modifier4,'')))
	END as BillingCode,     BillingCodes.CodeName,    
Cast(dbo.BillingCodes.Units as decimal(18,0)) as Units,   
dbo.BillingCodes.UnitType,     
dbo.GlobalCodes.CodeName AS UnitTypeName   
,BCM.Modifier1,BCM.Modifier2,BCM.Modifier3,BCM.Modifier4  
,BCM.BillingCodeModifierId  , (Convert(Varchar,BillingCodes.BillingCodeId) + '_' +  Convert(Varchar,BCM.BillingCodeModifierId)) as BillingCodeAndCodeModifierId  
FROM  dbo.BillingCodes 
INNER JOIN dbo.BillingCodeValidInsurers ON dbo.BillingCodes.BillingCodeId = dbo.BillingCodeValidInsurers.BillingCodeId 
INNER JOIN dbo.GlobalCodes ON dbo.BillingCodes.UnitType = dbo.GlobalCodes.GlobalCodeId    
inner Join BillingCodeModifiers BCM on BillingCodes.BillingCodeId = BCM.BillingCodeId and ISNULL(BCM.RecordDeleted,'N') = 'N'           
WHERE (dbo.BillingCodes.Active = 'Y') AND (dbo.BillingCodes.AllInsurers = 'N') AND (dbo.BillingCodeValidInsurers.InsurerId = @InsurerID) AND     
isnull(dbo.BillingCodes.RecordDeleted,'N')='N'  AND     
isnull(dbo.GlobalCodes.RecordDeleted,'N')='N' AND    
isnull(dbo.BillingCodeValidInsurers.RecordDeleted,'N')='N' 
AND ((cast(isnull(BCM.StartDate,0) as date) <= cast(isnull(@StartDate,0) as date)) OR @StartDate IS NULL) --Dec 18 2018    Arjun K R 
AND ((cast(isnull(@EndDate,2958463) as date)<= cast(isnull(BCM.EndDate,2958463) as date)) OR @EndDate IS NULL)
AND ISNULL(BCM.Active,'N')='Y'
    
Order By BillingCode


IF ( LEN(@Characters) > 0 )
    BEGIN
        SELECT  *
        FROM    #Results AS a
        WHERE   a.BillingCode LIKE '%' + @Characters + '%'; 
    END;
ELSE
    BEGIN 
        SELECT  *
        FROM    #Results AS a;

    END;

  End Try          
Begin Catch            
           
declare @Error varchar(8000)                
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CMGetBillingCodesByInsurerId')                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
  + '*****' + Convert(varchar,ERROR_STATE())                
                  
 RAISERROR                 
 (                
  @Error, -- Message text.                
  16, -- Severity.                
  1 -- State.                
 )                
          
          
End Catch   
 go