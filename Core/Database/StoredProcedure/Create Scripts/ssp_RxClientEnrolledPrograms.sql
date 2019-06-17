IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_RxClientEnrolledPrograms]') 
                  AND type in ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_RxClientEnrolledPrograms] 

GO 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER OFF 

GO 

CREATE PROC [dbo].[ssp_RxClientEnrolledPrograms] (@ClientId INT , @Order char(1))
As 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_ClientPrograms                   */ 
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
/* Creation Date:    30/Oct/2005                                      */ 
/* Created By   :    Malathi Shiva                                                                  */
/* Purpose: Check program enrollment for the current date for each non order locally medication on insert, then check to see if the program the client is enrolled in has the checkbox ‘Non Prescribed Meds’ */
/*                                                                   */ 
/* Input Parameters: none                     */ 
/*                                                                    */ 
/* Output Parameters:   None                                 */ 
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
/*  Date			Modified By       Purpose                                    */ 
/* 18 Jan 2015		Vithobha			Added @Order Parameter, Key Point - Environment Issues Tracking: #151 Changes to Client MAR 
   29 Mar 2016		Vithobha			Modified the Date conversion, Key Point - Support Go Live: #23                                   */ 
  /*********************************************************************/ 
  Begin 
if (@Order='N')
  begin
      SELECT CP.ProgramId 
             ,P.ProgramName 
             ,CP.ClientId 
             ,CP.EnrolledDate 
      from   ClientPrograms CP 
             Left Join Programs P 
                    on P.ProgramId = CP.ProgramId 
      where  ISNULL(P.RecordDeleted, 'N') = 'N' 
             and ISNULL(CP.RecordDeleted, 'N') = 'N' 
             and Status = 4 
             and ISNULL(P.MARNonOrderedMedication, 'N') = 'Y' 
             and cast(CP.EnrolledDate as Date) <=  cast(Getdate() as Date) 
             and CP.ClientId = @ClientId 
	end
if (@Order='O')
  begin
      SELECT CP.ProgramId 
             ,P.ProgramName 
             ,CP.ClientId 
             ,CP.EnrolledDate 
      from   ClientPrograms CP 
             Left Join Programs P 
                    on P.ProgramId = CP.ProgramId 
      where  ISNULL(P.RecordDeleted, 'N') = 'N' 
             and ISNULL(CP.RecordDeleted, 'N') = 'N' 
             and Status = 4 
             and (ISNULL(P.MARNonOrderedMedication, 'N') = 'Y' OR ISNULL(P.MARPrescribedMedication, 'N') = 'Y')
             and cast(CP.EnrolledDate as Date) <=  cast(Getdate() as Date)
             and CP.ClientId = @ClientId 
	end
      IF ( @@error != 0 ) 
        BEGIN 
            RAISERROR 20002 'ssp_RxClientEnrolledPrograms: An Error Occured' 

            RETURN( 1 ) 
        END 

      RETURN( 0 ) 
  End 

GO 