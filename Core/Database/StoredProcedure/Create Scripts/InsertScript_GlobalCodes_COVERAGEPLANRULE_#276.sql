IF NOT EXISTS(SELECT 1 FROM GlobalCodes where globalcodeid=4274)
 BEGIN
  SET IDENTITY_INSERT GlobalCodes ON 
   INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Active)
   VALUES(4274,'COVERAGEPLANRULE','No authorization required if service is created from claim.','NOAUTHORIZATIONREQUIREDIFSERVICEISCREATEDFROMCLAIM','Y')
  SET IDENTITY_INSERT GlobalCodes OFF
 END