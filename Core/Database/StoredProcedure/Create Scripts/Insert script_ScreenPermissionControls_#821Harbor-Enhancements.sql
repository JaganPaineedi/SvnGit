/*********************************************************************/                                                                                                                                                                                                                     
 /* Creation Date:   20 july 2017                                  */                                                                                  
 /*                                                                 */                                                                                  
 /* Purpose: Insert script for ScreenPermissionControls  */                                                                                 
           
 /*********************************************************************/  
Delete ScreenPermissionControls Where ScreenId=913
Declare @ScreenId Int
set @ScreenId=913
INSERT INTO  ScreenPermissionControls (ScreenId,ControlName,DisplayAs,Active) values (@ScreenId,'ToSign','To Sign','Y')
INSERT INTO  ScreenPermissionControls (ScreenId,ControlName,DisplayAs,Active) values (@ScreenId,'CoSign','To Cosign','Y')
INSERT INTO  ScreenPermissionControls (ScreenId,ControlName,DisplayAs,Active) values (@ScreenId,'InProgress','In Progress','Y')
INSERT INTO  ScreenPermissionControls (ScreenId,ControlName,DisplayAs,Active) values (@ScreenId,'ToBeReviewed','To Be Reviewed','Y')
INSERT INTO  ScreenPermissionControls (ScreenId,ControlName,DisplayAs,Active) values (@ScreenId,'ToAcknowledge','To Acknowledge','Y')


