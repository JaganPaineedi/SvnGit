using Microsoft.Web.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for DigitalSignature
/// </summary>
public class DigitalSignature
{
	public DigitalSignature()
	{
	}

    private string prescriberName;
    public string medicationName;
    public string instruction;


    public string PrescriberName
    {
        get
        {
            return prescriberName;
        }
        set
        {
            prescriberName = value;
        }
    }

    public string MedicationName
    {
        get
        {
            return medicationName;
        }
        set
        {
            medicationName = value;
        }
    }

    public string Instruction
    {
        get
        {
            return instruction;
        }
        set
        {
            instruction = value;
        }
    }

    /// <summary>
    /// Sign the Prescriber Name, Medication Name, Unit, Strength, Frequency, Dose comnination text and return a hash value string
    /// </summary>
    /// <param name="text"></param>
    /// <param name="certSubject"></param>
    /// <returns></returns>
    public byte[] Sign(DigitalSignature digitalSignature, string certSubject)
    {
        byte[] returnCertText = null;
        string concatChar = "-";
        string DigitalSign = digitalSignature.PrescriberName + concatChar + digitalSignature.medicationName + concatChar + digitalSignature.Instruction;
        //This is with certificate 
        //RSACryptoServiceProvider csp = GetRSACryptoServiceProvider(certSubject); 
        RSACryptoServiceProvider csp = new RSACryptoServiceProvider();

        if (csp != null)
        {
            // Hash the data
            SHA256CryptoServiceProvider sha256 = new SHA256CryptoServiceProvider();
            UnicodeEncoding encoding = new UnicodeEncoding();
            byte[] data = encoding.GetBytes(DigitalSign);
            byte[] hash = sha256.ComputeHash(data);

            // Sign the hash
            returnCertText = csp.SignHash(hash, CryptoConfig.MapNameToOID("SHA256"));
        }
        return returnCertText;
    }

    ///// <summary>
    ///// Returns RSACryptoServiceProvider object
    ///// </summary>
    ///// <param name="certSubject"></param>
    ///// <returns></returns>
    private static RSACryptoServiceProvider GetRSACryptoServiceProvider(string certSubject)
    {
        RSACryptoServiceProvider csp = null;
        X509Store x509Store = new X509Store(StoreName.AddressBook, StoreLocation.CurrentUser);

        x509Store.Open(OpenFlags.ReadOnly);
        foreach (X509Certificate2 cert in x509Store.Certificates)
        {
            if (cert.Subject.ToLower().Contains(certSubject))
            {
                csp = (RSACryptoServiceProvider)cert.PrivateKey;
            }
        }
        return csp;
    }


    /// <summary>
    /// Verify Hash value from the data base with the Prescriber Name, Medication Name, Unit, Strength, Frequency, Dose comnination text
    /// </summary>
    /// <param name="text"></param>
    /// <param name="signature"></param>
    /// <param name="certPath"></param>
    /// <param name="certSubject"></param>
    /// <returns></returns>
    public bool VerifyHash(DigitalSignature digitalSign, byte[] signedHashValue, string certSubject)
    {
        bool isValid = false;
        string concatChar = "-";
        string DigitalSign = digitalSign.PrescriberName + concatChar + digitalSign.medicationName + concatChar + digitalSign.Instruction;
        //This is with certificate 
        //RSACryptoServiceProvider csp = GetRSACryptoServiceProvider(certSubject);
        RSACryptoServiceProvider csp = new RSACryptoServiceProvider();
        SHA256CryptoServiceProvider sha256 = new SHA256CryptoServiceProvider();
        UnicodeEncoding encoding = new UnicodeEncoding();

        byte[] data = encoding.GetBytes(DigitalSign);
        byte[] hash = sha256.ComputeHash(data);

        isValid = csp.VerifyHash(hash, "SHA256", signedHashValue);
        return isValid;
    }
}