INSERT INTO [HL7CPVendorConfigurations] 
([VendorName],[HL7Version],[CommType],[SendingApplication],[ReceivingApplication],[SendingFacility],[ReceivingFacility],[VendorInboundAddress],[VendorInboundPort],[ConnectorPlatformInboundAddress],[ConnectorPlatformInboundPort],[AckToVendorExpected],[AckFromVendorExpected],[VendorRecordActive],[MessageBOFChars],[MessageEOFChars],[HL7EscapeChars],[SendErrorRetryLen],[AcceptAckType],[AppAckType],[MessageProfileIdentifier])
VALUES('Immunization History and Forecast','2.5.1',8617,'NISTEHRAPP','NISTIISAPP','NISTEHRFAC','NISTIISFAC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ER','AL','Z44^CDCPHINVS')

INSERT INTO [HL7CPVendorConfigurations] 
([VendorName],[HL7Version],[CommType],[SendingApplication],[ReceivingApplication],[SendingFacility],[ReceivingFacility],[VendorInboundAddress],[VendorInboundPort],[ConnectorPlatformInboundAddress],[ConnectorPlatformInboundPort],[AckToVendorExpected],[AckFromVendorExpected],[VendorRecordActive],[MessageBOFChars],[MessageEOFChars],[HL7EscapeChars],[SendErrorRetryLen],[AcceptAckType],[AppAckType],[MessageProfileIdentifier])
VALUES('Immunization Administration','2.5.1',8617,'NISTEHRAPP','NISTIISAPP','NISTEHRFAC','NISTIISFAC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ER','AL','Z22^CDCPHINVS')