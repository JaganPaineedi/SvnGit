<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output omit-xml-declaration="yes" />
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<title>Client Eligibility Information</title>
		</head>
		<body>
			<xsl:template match="eligibilityresponses">
				<xsl:apply-templates select="eligibilityresponse" />
			</xsl:template>
		</body>
	</html>
	<xsl:template match="eligibilityresponse[@type='999']">
		<b>
			Client Eligibility Acknowledgment 999 (Transaction Set Control Id: <xsl:value-of select="TransactionSetControlId" />)
		</b>
		<hr />
		<xsl:apply-templates select="functionalgroupresponse" />
	</xsl:template>
	<xsl:template match="functionalgroupresponse">
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<b>
						Functional Group Response: <xsl:value-of select="@type" />
					</b>
				</td>
			</tr>
			<tr>
				<td>
					<table border="0" cellpadding="2" cellspacing="0">
						<tr>
							<td style="color: black">Transaction Set</td>
							<td colspan="5">
								<xsl:value-of select="transactionsetcontrolnumber" />
							</td>
						</tr>
						<xsl:apply-templates select="erroridentification"></xsl:apply-templates>
						<xsl:apply-templates select="transactionsetreponsetrailer"></xsl:apply-templates>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="erroridentification">
		<tr>
			<td style="color: black">Segment</td>
			<td>
				<xsl:value-of select="segmentidcode" />
			</td>
			<td style="color: black">Position</td>
			<td>
				<xsl:value-of select="segmentposition" />
			</td>
			<td style="color: black">Loop</td>
			<td>
				<xsl:value-of select="loopidentifier" />
			</td>
		</tr>
		<xsl:if test="segmentidcode='N4'">
			<tr style="background-color:#e5e5e5;">
				<td style="color: black">Segment Info</td>
				<td colspan="5">Missing Address Information</td>
			</tr>
		</xsl:if>
		<xsl:if test="segmentidcode='DMG'">
			<tr style="background-color:#e5e5e5;">
				<td style="color: black">Segment Info</td>
				<td colspan="5">Invalid Demographic Information</td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="error"></xsl:apply-templates>
		<xsl:apply-templates select="errorelement"></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="errorelement">
		<tr>
			<td style="color: black">
				Element Position (<xsl:value-of select="elementposition"/>)
			</td>
			<td colspan="5">
				<xsl:value-of select="error/errormessage"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="error">
		<tr>
			<td style="color: black">
				Error Message <xsl:value-of select="position()"/>
			</td>
			<td colspan="5">
				<xsl:value-of select="errormessage"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="transactionsetreponsetrailer">
		<tr>
			<td colspan="2" style="color: black">
				Transaction Response <xsl:value-of select="position()"/>
			</td>
			<td colspan="1">
				<xsl:value-of select="acknowledgment/message"/>
			</td>
			<td colspan="3">
				<xsl:value-of select="syntaxerror/message"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="eligibilityresponse[@type='271']">
		<b>
			Client Eligibility Information (Transaction Set: <xsl:value-of select="TransactionSetControlId" />)
		</b>
		<hr />
		<xsl:apply-templates select="subscriber/rejection" />
		<xsl:apply-templates select="infosource/rejection" />
		<xsl:if test="subscriber/patient/*">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<b>Patient:</b>
					</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellpadding="2" cellspacing="0">
							<tr>
								<td style="color: black">
									<b>First Name:</b>
								</td>
								<td>
									<xsl:value-of select="subscriber/patient/patientname/first" />
								</td>
								<xsl:if test="subscriber/patient/patientname/middle">
									<td style="color: black" >
										<b>Middle Name:</b>
									</td>
									<td>
										<xsl:value-of select="subscriber/patient/patientname/middle" />
										<xsl:value-of select="eligibilityresponses/clientdemographics/clients/firstname" />
									</td>
								</xsl:if>
								<td style="color: black">
									<b>Last Name:</b>
								</td>
								<td colspan="2">
									<xsl:value-of select="subscriber/patient/patientname/last" />
								</td>
								<td style="color: black">
									<b>Suffix:</b>
								</td>
								<td colspan="2">
									<xsl:value-of select="subscriber/patient/patientname/suffix" />
								</td>							
							</tr>
							<tr>
								<td style="color: black">
									<b>Gender:</b>
								</td>
								<td>
									<xsl:value-of select="subscriber/patient/sex" />
								</td>
								<td style="color: black">
									<b>DOB:</b>
								</td>
								<td colspan="4">
									                <xsl:choose>
                    <xsl:when test="contains(subscriber/patient/date-of-birth, '*') and string-length(subscriber/patient/date-of-birth) >= 8">
                      <xsl:value-of select="concat(substring(subscriber/patient/date-of-birth, 1,1),substring(subscriber/patient/date-of-birth, 6,2),'/',substring(subscriber/patient/date-of-birth, 8,2),'/',substring(subscriber/patient/date-of-birth, 2,4))" />

                    </xsl:when>
                    <xsl:when test="not(contains(subscriber/patient/date-of-birth, '*')) and string-length(subscriber/patient/date-of-birth) >= 8">
                      <xsl:value-of select="concat(substring(subscriber/patient/date-of-birth, 5,2),'/',substring(subscriber/patient/date-of-birth, 7,2),'/',substring(subscriber/patient/date-of-birth, 1,4))" />
                    </xsl:when>
                  </xsl:choose>
                  <!--<xsl:if test="subscriber/patient/date-of-birth and string-length(subscriber/patient/date-of-birth) >= 8">
										<xsl:value-of select="concat(substring(subscriber/patient/date-of-birth, 1,1),substring(subscriber/patient/date-of-birth, 5,2),'/',substring(subscriber/patient/date-of-birth, 7,2),'/',substring(subscriber/patient/date-of-birth, 1,4))" />
									</xsl:if>-->
	
								</td>
							</tr>
							<tr>
								<td style="color: black">
									<b>Patient Id:</b>
								</td>
								<td colspan="2">
									<xsl:value-of select="subscriber/patient/patientid" />
								</td>
								<td colspan="2" style="color: black">
									<b>Information Contact:</b>
								</td>
								<td colspan="2">
									<xsl:value-of select="subscriber/patient/informationcontact" />
								</td>
							</tr>
							<tr>
								<td style="color: black">
									<b>Patient Address:</b>
								</td>
								<td colspan="6">
									<xsl:value-of select="subscriber/patient/patientaddress/address" />
									<xsl:if test="subscriber/patient/patientaddress/address">
										<br/>
										<xsl:value-of select="subscriber/patient/patientaddress/address2" />

									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="color: black">
									<b>Patient City:</b>
								</td>
								<td>
									<xsl:value-of select="subscriber/patient/patientaddress/city" />
								</td>
								<td style="color: black">
									<b>Patient State:</b>
								</td>
								<td>
									<xsl:value-of select="subscriber/patient/patientaddress/state" />
								</td>
								<td style="color: black">
									<b>Patient Zip:</b>
								</td>
								<td colspan="2">
									<xsl:value-of select="subscriber/patient/patientaddress/zip" />
								</td>
							</tr>
							<xsl:apply-templates select="subscriber/patient/subscriberadditionalid" />
						</table>
					</td>
				</tr>
			</table>
		</xsl:if>
		<xsl:if test="subscriber/benefit">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<b>Benefits:</b>
					</td>
				</tr>
				<tr>
					<td>
						<table cellspacing="0" cellpadding="0">
							<tr style="color: black; background-color:#dce5ea;" class="EligibilityView">
								<td></td>
								<td>Coverage</td>
								<td></td>
								<td>Insurance</td>
								<td>Plan</td>
								<td>Group</td>
								<td colspan="2" style="text-align:center;">Service Date</td>
								<td></td>
								<td colspan="3" style="text-align:center;">Message(s)</td>
							</tr>
							<tr style="color: black; background-color:#dce5ea;" class="EligibilityView">
								<td>Info</td>
								<td>Type</td>
								<td>Service</td>
								<td>Type</td>
								<td>Coverage</td>
								<td>Policy</td>
								<td style="text-align:center;">Start</td>
								<td style="text-align:center;">End</td>
								<td style="padding-right:10px;">Benefit</td>
								<td style="text-align:center;">1</td>
								<td style="text-align:center;">2</td>
								<td style="text-align:center;">3</td>
							</tr>
							<xsl:apply-templates select="subscriber/benefit">
								<xsl:sort select="info"/>
							</xsl:apply-templates>
						</table>
					</td>
				</tr>
			</table>
		</xsl:if>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<b>Information Source:</b>
				</td>
			</tr>
			<tr>
				<td>
					<table cellpadding="0" cellspacing="0">
						<xsl:apply-templates select="infosource" />
					</table>
				</td>
			</tr>
		</table>
    <xsl:if test="eligibilityresponse/inforeceiver">
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<b>Information Receiver:</b>
				</td>
			</tr>
			<tr>
				<td>
					<table cellpadding="0" cellspacing="0">
						<xsl:apply-templates select="inforeceiver" />
					</table>
				</td>
			</tr>
			<tr>
				<td>
					Note: '*' denotes change in information.  
				</td>
			</tr>
		</table>
    </xsl:if>
	</xsl:template>
	<xsl:template match="subscriber/rejection">
		<table cellspacing="0" cellpadding="2">
			<tr bgcolor="#FFFF00">
				<td>
					<strong>Eligibility check failed:</strong>
				</td>
				<td>
					<xsl:value-of select="rejectreason" />
				</td>
			</tr>
			<tr bgcolor="#FFF">
				<td>
					<strong>Action to take:</strong>
				</td>
				<td>
					<xsl:value-of select="followupaction" />
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="infosource/rejection">
		<table cellspacing="0" cellpadding="2">
			<tr>
				<td bgcolor="#FFFF00">
					<strong>Eligibility check failed:</strong>
				</td>
				<td>
					<xsl:value-of select="rejectreason" />
				</td>
			</tr>
			<tr>
				<td bgcolor="#FFFF00">
					<strong>Action to take:</strong>
				</td>
				<td>
					<xsl:value-of select="followupaction" />
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="infosource">
		<tr class="EligibilityView">
			<td style="color: black">
				<b>Name:</b>
			</td>
			<td>
				<xsl:value-of select="payer/payername" />
			</td>
			<td width="10px"></td>
			<td style="color: black">
				<b>Id:</b>
			</td>
			<td>
				<xsl:value-of select="payer/payerid" />
			</td>
		</tr>
			<tr>
				<td style="color: black"  colspan="5">
					<b>Third Party Administrator</b>
				</td>
			</tr>
			<tr>
			<td style="color: black">
				<b>Name:</b>
			</td>
			<td>
				<xsl:value-of select="thirdpartyadmin/organizationname" />
			</td>
			<td width="10px"></td>
			<td style="color: black">
				<b>Id:</b>
			</td>
			<td>
				<xsl:value-of select="thirdpartyadmin/payerid" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="inforeceiver">
		<tr>
			<td style="color: black"  colspan="8">
				<b>Provider</b>
			</td>
		</tr>
		<tr class="EligibilityView">
			<td style="color: black">
				<b>First Name:</b>
			</td>
			<td>
				<xsl:value-of select="provider/first" />
			</td>
			<td width="10px"></td>
			<td style="color: black">
				<b>Last Name:</b>
			</td>
			<td>
				<xsl:value-of select="provider/last" />
			</td>
			<td width="10px"></td>
			<td style="color: black">
				<b>Suffix:</b>
			</td>
			<td>
				<xsl:value-of select="provider/suffix" />
			</td>
		</tr>
		<tr>
			<td style="color: black">
				<b>Provider Id:</b>
			</td>
			<td colspan="2">
				<xsl:value-of select="providerid" />
			</td>
		</tr>
		<tr>
			<td style="color: black">
				<b>Additional Id:</b>
			</td>
			<td colspan="3">
				<xsl:value-of select="receiveradditionalid/referenceidentification" />
			</td>
			<td colspan="4">
				<xsl:value-of select="receiveradditionalid/referenceidentificationtype" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="subscriber/benefit">
		<xsl:variable name="css-class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 0">ListPageAltRow</xsl:when>
				<xsl:otherwise>ListPageRow</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="{$css-class} EligibilityView">
			<td>
				<xsl:value-of select="info" />
			</td>
			<td>
				<xsl:value-of select="coveragelevel" />
			</td>
			<td>
				<xsl:value-of select="servicetype" />
			</td>
			<td>
				<xsl:value-of select="insurancetype" />
			</td>
			<td>
				<xsl:value-of select="plancoveragedescription" />
			</td>
			<td>
				<xsl:value-of select="subscriberaddinfo/grouppolicynum" />
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="date-of-service[@type='Plan']/daterangefrom and string-length(date-of-service[@type='Plan']/daterangefrom) >= 8">
						<xsl:value-of select="concat(substring(date-of-service[@type='Plan']/daterangefrom, 5,2),'/',substring(date-of-service[@type='Plan']/daterangefrom, 7,2),'/',substring(date-of-service[@type='Plan']/daterangefrom, 1,4))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="date-of-service[@type='Plan'] and string-length(date-of-service[@type='Plan']) >= 8">
							<xsl:value-of select="concat(substring(date-of-service[@type='Plan'], 5,2),'/',substring(date-of-service[@type='Plan'], 7,2),'/',substring(date-of-service[@type='Plan'], 1,4))" />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="date-of-service[@type='Plan']/daterangeto and string-length(date-of-service[@type='Plan']/daterangeto) >= 8">
					<xsl:value-of select="concat(substring(date-of-service[@type='Plan']/daterangeto, 5,2),'/',substring(date-of-service[@type='Plan']/daterangeto, 7,2),'/',substring(date-of-service[@type='Plan']/daterangeto, 1,4))" />
				</xsl:if>
			</td>
			<td>
				<xsl:value-of select="benefitentity/entitycode" />
				<xsl:if test="benefitentity/entitycode">-</xsl:if>
				<xsl:value-of select="benefitentity/informationcontact" />
			</td>
			<td>
				<xsl:value-of select="message[1]" />
			</td>
			<td>
				<xsl:value-of select="message[2]" />
			</td>
			<td>
				<xsl:value-of select="message[3]" />
			</td>
		</tr>
		<xsl:apply-templates select="subscriberadditionalid"  mode="addinfo1" />
	</xsl:template>
	<xsl:template match="subscriber/patient/subscriberadditionalid">
		<xsl:variable name="css-class">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 0">ListPageAltRow</xsl:when>
				<xsl:otherwise>ListPageRow</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="{$css-class}">
			<td style="color: black">
				<b>Additional Id:</b>
			</td>
			<td colspan="2">
				<xsl:value-of select="referenceidentification" />
			</td>
			<td colspan="4">
				<xsl:value-of select="referenceidentificationtype" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="subscriber/benefit/subscriberadditionalid" mode="addinfo1">
		<tr style="color: black; border:none;" bgcolor="#e4e4e4">
			<td style="text-align:right;">
				<b>Id:&#160;</b>
			</td>
			<td>
				<xsl:value-of select="referenceidentification" />
			</td>
			<td colspan="10">
				-&#160;&#160;<xsl:value-of select="referenceidentificationtype" />
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>