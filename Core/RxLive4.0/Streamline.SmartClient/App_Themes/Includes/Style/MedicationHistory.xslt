<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output omit-xml-declaration="yes" />
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<style>
					#prescriber {
					width: 100%;

					}

					#prescriber td, #customers th {
					font-size: 1em;

					padding: 3px 7px 2px 7px;
					}

					#prescriber th {
					font-size: 1.1em;
					text-align: left;
					padding-top: 5px;
					padding-bottom: 4px;
					background-color: #87CEEB;
					color: #ffffff;
					}

					#prescriber tr {
					background-color: #eee;
					}

					#inside th {
					font-size: 1em;
					text-align: left;
					padding-top: 2px;
					padding-bottom: 2px;
					background-color: #ADD8E6;
					color: #ffffff;
					}

				</style>
				<title>MedicationHistory</title>
			</head>
			<body>
				<xsl:for-each select="MedicationHistoryResponses/MedicationHistory">
					<b>MessageID: </b>
					<xsl:value-of select="MessageID" />
					<br />
					<b>Response: </b>
					<xsl:choose>
						<xsl:when test="TransactionResult">
							<xsl:value-of select="TransactionResult/ErrorDescription"/> 
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="RxHistoryResponse/Response" />
						</xsl:otherwise>
					</xsl:choose>
					<br />
					<br />
					<hr />
					<b>Prescriber: </b>
					<xsl:choose>
						<xsl:when test="RxHistoryResponse/Prescriber/Name">
							<ul>
								<xsl:for-each select="RxHistoryResponse/Prescriber/Identification/*">
									<li>
										<xsl:value-of select ="name(.)"/>: <xsl:value-of select="."/>
									</li>
								</xsl:for-each>
								<li>
									Last Name: <xsl:value-of select="RxHistoryResponse/Prescriber/Name/LastName"/>
								</li>
								<li>
									First Name: <xsl:value-of select="RxHistoryResponse/Prescriber/Name/FirstName"/>
								</li>
								<li>
									Contact: <xsl:value-of select="RxHistoryResponse/Prescriber/Communication/Number"/>-
									<i>
										<xsl:value-of select="RxHistoryResponse/Prescriber/Communication/Qualifier"/>
									</i>
								</li>

							</ul>
						</xsl:when>
						<xsl:otherwise>
							No Information Available
						</xsl:otherwise>
					</xsl:choose>
					<br />
					<!--<b>Patient: </b>
					<ul>
						<xsl:if test="PatientRelationship">
							<li>
								Relationship: <xsl:value-of select="RxHistoryResponse/Patient/PatientRelationship" />
							</li>
						</xsl:if>
						<li>
							Last Name: <xsl:value-of select="RxHistoryResponse/Patient/Name/LastName" />
						</li>
						<li>
							Middle Name: <xsl:value-of select="RxHistoryResponse/Patient/Name/MiddleName" />
						</li>
						<li>
							First Name: <xsl:value-of select="RxHistoryResponse/Patient/Name/FirstName" />
						</li>
						<li>
							Gender: <xsl:value-of select="RxHistoryResponse/Patient/Gender" />
						</li>
						<li>
							Date Of Birth: <xsl:value-of select="RxHistoryResponse/Patient/DateOfBirth/Date" />
						</li>
					</ul>-->
					<br />
					<b>Coordination Of Benefits</b>
					<table id="prescriber">
						<tr>
							<th>Payer ID</th>
							<th>Payer Name</th>
							<th>Effective Date</th>
							<th>Expiration Date</th>
							<th>Consent</th>
							<th>Patient Identifier</th>
						</tr>
						<xsl:choose>
							<xsl:when test="RxHistoryResponse/BenefitsCoordination">

								<xsl:for-each select="RxHistoryResponse/BenefitsCoordination">
									<tr>
										<td>
											<xsl:value-of select="PayerIdentification/PayerID"/>
										</td>
										<td>
											<xsl:value-of select="PayerName"/>
										</td>
										<td>
											<xsl:value-of select="EffectiveDate"/>
										</td>
										<td>
											<xsl:value-of select="ExpirationDate"/>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="Consent='Y'">Consent given</xsl:when>
												<xsl:when test="Consent='N'">No consent</xsl:when>
												<xsl:when test="Consent='P'">Prescriber</xsl:when>
												<xsl:when test="Consent='X'">Parental/Guardian consent on behalf of a minor for prescriber to receive the medication history from any prescriber</xsl:when>
												<xsl:when test="Consent='Z'">Parental/Guardian consent on behalf of a minor for prescriber to only receive the medication history this prescriber prescribed</xsl:when>
											</xsl:choose>
										</td>
										<td>
											<xsl:value-of select="PBMMemberID"/>
										</td>
									</tr>
									<br />
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td colspan="5">
									No Information Available
								</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</table>
					<br />
					<br />
					<b>Medication Dispensed:</b>
					<table id="prescriber">
						<tr>
							<th>No.</th>
							<th>Drug Description</th>
							<th>Product Code</th>
							<th>Quantity</th>
							<th>Date</th>
							<xsl:if test="RxHistoryResponse/MedicationDispensed/Substitutions">
								<th>
									Substitutions
								</th>
							</xsl:if>
							<!--<th>Prescriber</th>
							<th>Pharmacy</th>-->
							<xsl:if test="RxHistoryResponse/MedicationDispensed/HistorySource">
								<th>
									HistorySource
								</th>
							</xsl:if>
						</tr>
						<xsl:choose>
							<xsl:when test="RxHistoryResponse/MedicationDispensed">

								<xsl:for-each select="RxHistoryResponse/MedicationDispensed">
									<tr>
										<td>
											<xsl:value-of select="position()" />
										</td>
										<td>
											<xsl:value-of select="DrugDescription"/>
										</td>
										<td>
											<xsl:value-of select="DrugCoded/ProductCode"/>
											<i>
												<xsl:choose>
													<xsl:when test="DrugCoded/ProductCodeQualifier='MF'"> MFG</xsl:when>
													<xsl:when test="DrugCoded/ProductCodeQualifier='UP'"> UPC</xsl:when>
													<xsl:when test="DrugCoded/ProductCodeQualifier='ND'"> NDC11</xsl:when>
												</xsl:choose>
											</i>
										</td>
										<td>
											<table>
												<tr>
													<td>
														<xsl:choose>
															<xsl:when test="Quantity/CodeListQualifier='38'">Original Qty: </xsl:when>
															<xsl:when test="Quantity/CodeListQualifier='40'">Remaining Qty: </xsl:when>
															<xsl:when test="Quantity/CodeListQualifier='87'">Quantity Received: </xsl:when>
															<xsl:when test="Quantity/CodeListQualifier='QS'">Quantity Sufficient</xsl:when>
														</xsl:choose>
													</td>
													<td>
														<xsl:value-of select="Quantity/Value"/>
													</td>
												</tr>
												<!--<tr>
											<td>
												Source Code List:
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="Quantity/UnitSourceCode='AC'">Potency Unit </xsl:when>
												</xsl:choose>
											</td>
										</tr>
										<tr>
											<td>
												Potency Unit Code:
											</td>
											<td>
												<xsl:value-of select="Quantity/PotencyUnitCode"/>
											</td>
										</tr>-->
											</table>
										</td>
										<td>
											<table>
												<xsl:if test="SoldDate">
													<tr>
														<td>Sold Date: </td>
														<td>
															<xsl:value-of select="SoldDate"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="SoldDate">
													<tr>
														<td>Sold Date: </td>
														<td>
															<xsl:value-of select="SoldDate"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="EffectiveDate">
													<tr>
														<td>Effective Date: </td>
														<td>
															<xsl:value-of select="EffectiveDate"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="DeliveredonThisDate">
													<tr>
														<td>Delivered on ThisDate: </td>
														<td>
															<xsl:value-of select="DeliveredonThisDate"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="ExpirationDate">
													<tr>
														<td>Expiration Date: </td>
														<td>
															<xsl:value-of select="ExpirationDate"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="DateIssued">
													<tr>
														<td>Date Issued: </td>
														<td>
															<xsl:value-of select="DateIssued"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="LastFillDate">
													<tr>
														<td>Last Fill Date: </td>
														<td>
															<xsl:value-of select="LastFillDate"/>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="PeriodEnd">
													<tr>
														<td>Period End: </td>
														<td>
															<xsl:value-of select="Period End"/>
														</td>
													</tr>
												</xsl:if>
												<!--<xsl:if test="DaysSupply">
											<tr>
												<td>Days Supply: </td>
												<td>
													<xsl:value-of select="DaysSupply"/>
												</td>
											</tr>
										</xsl:if>-->
											</table>
										</td>
										<xsl:if test="Substitutions">
											<td>
												<xsl:choose>
													<xsl:when test="Substitutions='0'">Allowed</xsl:when>
													<xsl:when test="Substitutions='1'">Not-Allowed</xsl:when>
												</xsl:choose>
											</td>
										</xsl:if>
										<!--<td>
									<xsl:if test="Prescriber">
										<table id="inside">
											<tr>
												<th>Id</th>
												<th>Last Name</th>
												<th>First Name</th>
												<th>Contact</th>
											</tr>
											<tr>
												<td>
													<table>
														<xsl:for-each select="Prescriber/Identification/*">
															<tr>
																<td>
																	<xsl:value-of select ="name(.)"/>:
																</td>
																<td>
																	<xsl:value-of select="."/>
																</td>
															</tr>
														</xsl:for-each>
													</table>
												</td>
												<td>
													<xsl:value-of select="Prescriber/Name/LastName"/>
												</td>
												<td>
													<xsl:value-of select="Prescriber/Name/FirstName"/>
												</td>
												<td>
													<xsl:value-of select="Prescriber/Communication/Number"/>-
													<i>
														<xsl:value-of select="Prescriber/Communication/Qualifier"/>
													</i>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="Pharmacy">
										<table id="inside">
											<tr>
												<th>Id</th>
												<th>Store Name</th>
												<th>Contact</th>
											</tr>
											<tr>
												<td>
													<table>
														<xsl:for-each select="Pharmacy/Identification/*">
															<tr>
																<td>
																	<xsl:value-of select ="name(.)"/>:
																</td>
																<td>
																	<xsl:value-of select="."/>
																</td>
															</tr>
														</xsl:for-each>
													</table>
												</td>
												<td>
													<xsl:value-of select="Pharmacy/StoreName"/>
												</td>
												<td>
													<xsl:value-of select="Pharmacy/Communication/Number"/>-
													<i>
														<xsl:value-of select="Pharmacy/Communication/Qualifier"/>
													</i>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<xsl:if test="RxHistoryResponse/MedicationDispensed/HistorySource">
									<td>
										<table>
											<tr>
												<td>
													Source Description:
												</td>
												<td>
													<xsl:choose>
														<xsl:when test="Source/SourceQualifier='P2'">Pharmacy - </xsl:when>
														<xsl:when test="Source/SourceQualifier='PY'">Payer - </xsl:when>
													</xsl:choose>
													<xsl:value-of select="Source/SourceDescription"/>
												</td>
											</tr>
											<tr>
												<td>
													Reference:
												</td>
												<td>
													<xsl:value-of select="Source/Reference/IDValue"/> - <i>
														<xsl:value-of select="Source/Reference/IDQualifier"/>
													</i>
												</td>
											</tr>
											<tr>
												<td>
													Source Reference:
												</td>
												<td>
													<xsl:value-of select="SourceReference"/>
												</td>
											</tr>
											<tr>
												<td>
													Fill Number:
												</td>
												<td>
													<xsl:value-of select="FillNumber"/>
												</td>
											</tr>
										</table>
									</td>
								</xsl:if>-->

									</tr>
								</xsl:for-each>

							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td colspan="5">No Information Available</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>

					</table>
				</xsl:for-each>
				<p>
					Disclaimer: Certain information may not be available or accurate in
					this report, including items that the patient asked not be disclosed due to
					patient privacy concerns, over-the-counter medications, low cost prescriptions,
					prescriptions paid for by the patient or non-participating sources, or errors in
					insurance claims information. The provider should independently verify
					medication history with the patient.
				</p>
			</body>
		</html>
	</xsl:template>


</xsl:stylesheet>
