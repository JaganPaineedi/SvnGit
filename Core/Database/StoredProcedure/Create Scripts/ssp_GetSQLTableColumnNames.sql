IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_GetSQLTableColumnNames' )
DROP PROCEDURE [dbo].ssp_GetSQLTableColumnNames
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetOrders]    Script Date: 1/7/2014 11:05:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ssp_GetSQLTableColumnNames]      
 @TableName VARCHAR(1000)                      
AS  
/*********************************************************************/                                                                                          
 /* Stored Procedure: [ssp_GetSQLTableColumnNames]			        */   
 /*exec ssp_GetSQLTableColumnNames 'OrderFrequencies'				*/                                                                              
 /* Creation Date:  23/July/2014                                    */                                                                                          
 /* Purpose: To get Column names of a table				            */                                                                                        
  /* Output Parameters:												*/              
  /*Returns The Table for Order Details								*/                                                                                          
 /* Called By:Connection.cs                                         */                                                                                
 /* Data Modifications:                                             */                                                                                          
 /*   Updates:                                                      */                                                                                          
 /*   Date    Author   Purpose					                    */                                                                                          
 /*  23/July/2014  Deej  Created			                        */          
 /*  16/MAR/2017   Akwinass  Included ORDER BY  ORDINAL_POSITION (Task #635 in Engineering Improvement Initiatives- NBL(I))*/   
 /********************************************************************/ 
BEGIN
--DECLARE @TableName1 VARCHAR(1000)
DECLARE @Columns VARCHAR(MAX)
--SET @TableName1='OrderFrequencies' 
SELECT @Columns= COALESCE(@Columns + ',', '') + COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName and TABLE_SCHEMA='dbo'
ORDER BY  ORDINAL_POSITION 
SELECT @Columns AS COLUMN_NAME
END
