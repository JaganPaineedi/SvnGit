IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_SCGetCountiesForInquiryDetails]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetCountiesForInquiryDetails]; 

go 

CREATE PROCEDURE [dbo].[ssp_SCGetCountiesForInquiryDetails] 
														--@CountyName  VARCHAR(50), 
                                                        @StateFIPS   CHAR(2), 
                                                        @FinOrCounty CHAR(1) 
AS 

  BEGIN 
  /*********************************************************************/ 
  /* Stored Procedure: dbo.ssp_SCGetCountiesForInquiryDetails                */ 
  /* Copyright: 2006 Streamlin Healthcare Solutions           */ 
  /* Creation Date:  Aug/10/2018                                    */ 
  /*                                                                   */ 
  /* Purpose: To get binding value for CountyOfResidence field of Inquiry Details(C)  */ 
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
  /*     Aug/10/2018		  Alok Kumar				  Created with same query from 'ssp_SCGetCountiesBasedonSearch' (Client Information(C) -> CountyOfResidence).                                 


	********************************************************************/ 
      BEGIN try 
          DECLARE @StateFIPSCode CHAR(2); 

          SELECT @StateFIPSCode = statefips 
          FROM   states 
          WHERE  stateabbreviation = @StateFIPS; 

          --Ajay 21/Oct/2016 
          SELECT Ltrim(Rtrim(countyname)) + ' - ' 
                 + st.stateabbreviation AS CountyName, 
                 C.countyfips
          FROM   counties C 
                 JOIN states AS st 
                   ON st.statefips = C.statefips 
                 JOIN dbo.Ssf_recodevaluesasofdate('STATESFORCOUNTYDROPDOWNS', 
                      Getdate 
                      ()) 
                      AS a 
                   ON st.statefips = a.charactercodeid 
          --WHERE  C.countyname LIKE ( @CountyName + '%' ) 
          UNION 
          -- End 
          SELECT Ltrim(Rtrim(countyname)) + ' - ' 
                 + st.stateabbreviation AS CountyName, 
                 C.countyfips 
          FROM   counties C 
                 JOIN states AS st 
                   ON st.statefips = C.statefips 
                 JOIN dbo.Ssf_recodevaluesasofdate('STATESFORCOUNTYDROPDOWNS', 
                      Getdate 
                      ()) 
                      AS a 
                   ON st.statefips = CONVERT(VARCHAR(max), a.integercodeid) 
          --handle if the user enters statefips as integer code id                                
          --WHERE  C.countyname LIKE ( @CountyName + '%' ) 
          UNION 
          SELECT Ltrim(Rtrim(countyname)) + ' - ' 
                 + St.stateabbreviation AS CountyName, 
                 C.countyfips
          FROM   counties C 
                 JOIN states St 
                   ON St.statefips = C.statefips 
          WHERE  --C.countyname LIKE ( @CountyName + '%' ) AND 
                 C.statefips = @StateFIPSCode 
                 AND @FinOrCounty = 'N' 
                 AND NOT EXISTS (SELECT 1 
                                 FROM 
                         dbo.Ssf_recodevaluesasofdate('STATESFORCOUNTYDROPDOWNS' 
                         , 
                         Getdate( 
                         )) AS a 
                                 WHERE 
                                  --handle if user enters state fips as integer code id 
                                  a.charactercodeid = St.statefips 
                                   OR CONVERT(VARCHAR(max), a.integercodeid) = 
                                      st.statefips); 
      END try 

      BEGIN catch 
		DECLARE @Error VARCHAR(8000)
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetCountiesForInquiryDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())
		RAISERROR (
				@Error
				,-- Message text.                                                                        
				16
				,-- Severity.                                                                        
				1 -- State.                                                                        
				);
      END catch; 
  END; 