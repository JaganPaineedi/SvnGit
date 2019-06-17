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
			<td style="color: black" >Segment</td>
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
									<td style="color: black">
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
						</table>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>