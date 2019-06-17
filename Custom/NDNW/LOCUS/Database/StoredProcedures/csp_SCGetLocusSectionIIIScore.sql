  
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionIIIScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionIIIScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionIIIScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionIIIScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionIIIScore]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section III Score List with  static values like  */                           
/*                                                                   */                          
/*                                                                   */                            
/* Output Parameters:                                */                            
/*                                                                   */                            
/*  Date                  Author                 Purpose          */                            
/* 12/02/2011             Rakesh Kumar -II               Created         */                            
/*********************************************************************/                     
            
    Declare @table table  
 (  
  TextField nvarchar(100),  
  ValueField int  
 )  
  
insert into @table(TextField,ValueField)  values('1 - No Co-morbidity',1)  
insert into @table(TextField,ValueField)  values('2 - Minor Co-morbidity',2)  
insert into @table(TextField,ValueField)  values('3 - Significant Co-morbidity',3)   
insert into @table(TextField,ValueField)  values('4 - Major Co-morbidity',4)  
insert into @table(TextField,ValueField)  values('5 - Severe Co-morbidity',5 )  
 
  
  
select TextField,ValueField from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetLocusSectionIIIScore]: An Error Occured'               
  Return            
 End            
            
            
GO


