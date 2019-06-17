   
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionIVaScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionIVaScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionIVaScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionIVaScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionIVaScore]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section IV A Score List with  static values like  */                           
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
  
insert into @table(TextField,ValueField)  values('1 - Low Stress Environment',1)  
insert into @table(TextField,ValueField)  values('2 - Mildly Stressful Environment',2)  
insert into @table(TextField,ValueField)  values('3 - Moderately Stressful Environment',3)   
insert into @table(TextField,ValueField)  values('4 - Highly Stressful Environment',4)  
insert into @table(TextField,ValueField)  values('5 - Extremely Stressful Environment',5 )  
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetLocusSectionIVaScore]: An Error Occured'               
  Return            
 End            
            
            
GO


