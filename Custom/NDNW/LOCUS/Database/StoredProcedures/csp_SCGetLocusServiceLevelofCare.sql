      
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusServiceLevelofCare]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusServiceLevelofCare]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusServiceLevelofCare]
GO

   
create  Procedure [dbo].[csp_SCGetLocusServiceLevelofCare]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusServiceLevelofCare]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section V Score List with  static values like  */                           
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
  
insert into @table(TextField,ValueField)  values('Service Level I',1)  
insert into @table(TextField,ValueField)  values('Service Level II',2)  
insert into @table(TextField,ValueField)  values('Service Level III',3)   
insert into @table(TextField,ValueField)  values('Service Level IV',4)  
insert into @table(TextField,ValueField)  values('Service Level V',5 )  
insert into @table(TextField,ValueField)  values('Service Level VI',6 ) 
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetLocusServiceLevelofCare]: An Error Occured'               
  Return            
 End            
            
            
GO


