  IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCountiesBasedonSearch]')
                    AND type IN ( N'P' , N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCGetCountiesBasedonSearch];
GO
  CREATE  PROCEDURE [dbo].[ssp_SCGetCountiesBasedonSearch]
    @CountyName VARCHAR(50) ,
    @StateFIPS CHAR(2) ,
    @FinOrCounty CHAR(1)
  AS
    BEGIN          
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCGetCountiesBasedonSearch                */   
  
/* Copyright: 2006 Streamlin Healthcare Solutions           */            
  
/* Creation Date:  22/01/2016                                    */            
/*                                                                   */            
/* Purpose: Created  to search Counties based on Countyname and StateFIPS Table */           
/*                                                                   */          
/* Input Parameters: None*/          
/*                                                                   */             
/* Output Parameters:                                */            
/*                                                                   */            
/* Return:   */            
/*                                                                   */                 
  
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/*                                                                   */            
/*   Updates:                                                        */            
  
/*     Date                 Author                      Purpose      */            
/*     22/01/2016           Shruthi.S                   Created to search Counties based on Countyname and StateFIPS.Ref : #275 EII.                                
       5/5/2016             Pavani                      Added sot condition as per the task Woods - Support Go Live: #57 Client Information 
       21/Oct/2016          Ajay						Why: Column StateFIPS (char type) column (In States table) was joining with InegerCodeId (Int type) column(In Recodes table). 
		  So whenever StateFIPS will have charecter type value it will throw data conversion error. So we are copying IntegerCodeId into CharacterCodeId
		  and we are joining States table to Recodes table with States.StateFIPs = Recodes.CharacterCodeId and applying UNION to existing recodes.Also also I am casting IntegerCodeId from INT to char. 
          Woods - Support Go Live:Task#311 
       12/30/2016	        jcarlson			      updated script to make use of recode functions, reformatted
       11/13/2018			Msood			What: Calling SCSP for to not to display State Name if the County name having -OK and -MO	
											Why: Spring River-Support Go Live Task #355
	 
	  */            
/*********************************************************************/             
   
        BEGIN TRY 
            DECLARE @StateFIPSCode CHAR(2);
            SELECT
                    @StateFIPSCode = StateFIPS
                FROM
                    States
                WHERE
                    StateAbbreviation = @StateFIPS;
   -- Msood 11/13/2018
   IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetCountiesBasedonSearch]') AND type in (N'P', N'PC'))        
	BEGIN        
		EXEC scsp_SCGetCountiesBasedonSearch @CountyName, @StateFIPS,  @FinOrCounty   
	END
	Else 

   --Ajay 21/Oct/2016
            SELECT
                    LTRIM(RTRIM(CountyName)) + ' - ' + st.StateAbbreviation AS CountyName ,
                    C.CountyFIPS ,
                    CASE WHEN st.StateFIPS = @StateFIPSCode THEN 1
                         ELSE 2
                    END AS SortOrder
                FROM
                    Counties C
                JOIN States AS st ON st.StateFIPS = C.StateFIPS
                JOIN dbo.ssf_RecodeValuesAsOfDate('STATESFORCOUNTYDROPDOWNS' , GETDATE()) AS a ON st.StateFIPS = a.CharacterCodeId
                WHERE
                    C.CountyName LIKE ( @CountyName + '%' )
            UNION
    -- End
            SELECT
                    LTRIM(RTRIM(CountyName)) + ' - ' + st.StateAbbreviation AS CountyName ,
                    C.CountyFIPS ,
   --Pavani  5/5/2016
                    CASE WHEN st.StateFIPS = @StateFIPSCode THEN 1
                         ELSE 2
                    END AS SortOrder
   -- End
                FROM
                    Counties C
                JOIN States AS st ON st.StateFIPS = C.StateFIPS
                JOIN dbo.ssf_RecodeValuesAsOfDate('STATESFORCOUNTYDROPDOWNS' , GETDATE()) AS a ON st.StateFIPS = CONVERT(VARCHAR(MAX) , a.IntegerCodeId) --handle if the user enters statefips as integer code id                               
                WHERE
                    C.CountyName LIKE ( @CountyName + '%' )
            UNION
            SELECT
                    LTRIM(RTRIM(CountyName)) + ' - ' + St.StateAbbreviation AS CountyName ,
                    C.CountyFIPS ,
    --Pavani  5/5/2016
                    CASE WHEN St.StateFIPS = @StateFIPSCode THEN 1
                         ELSE 2
                    END AS SortOrder  
   --  End
                FROM
                    Counties C
                JOIN States St ON St.StateFIPS = C.StateFIPS
                WHERE
                    C.CountyName LIKE ( @CountyName + '%' )
                    AND C.StateFIPS = @StateFIPSCode
                    AND @FinOrCounty = 'N'
                    AND NOT EXISTS ( SELECT
                                            1
                                        FROM
                                            dbo.ssf_RecodeValuesAsOfDate('STATESFORCOUNTYDROPDOWNS' , GETDATE()) AS a
                                        WHERE                  --handle if user enters state fips as integer code id
                                            a.CharacterCodeId  = St.StateFIPS
								    OR CONVERT(VARCHAR(MAX) , a.IntegerCodeId) = st.StateFIPS
					          );
  
        END TRY
        BEGIN CATCH
            RAISERROR ('ssp_SCGetCountiesBasedonSearch: An Error Occured While Updating ',16,1);
        END CATCH;
  
    END;  