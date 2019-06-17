using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
namespace SC.Cryptography
{
    public class EncryptDecrypt
    {
        #region Private members
        private static byte[] KEY = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c, 0x54, 0xac, 0x67, 0x9f, 0x45, 0x6e, 0xaa, 0x56 };
        private static byte[] IV = new byte[] { 0x12, 0xe3, 0x4a, 0xa1, 0x45, 0xd2, 0x56, 0x7c };
        #endregion

        #region Public methods

        #region Encrypt
        /// <summary>
        /// Encrypt text
        /// </summary>
        /// <param name="stringToEncrypt">Plain text</param>
        /// <returns>Encrypted text</returns>
        public static string Encrypt(string stringToEncrypt)
        {
            return Encrypt(stringToEncrypt, KEY, IV);
        }
        /// <summary>
        /// Encrypt text
        /// </summary>
        /// <param name="stringToEncrypt">Plain text</param>
        /// <param name="encryptDecryptKey">Encrypt decrypt key in plain text</param>
        /// <returns>Encrypted text</returns>
        public static string Encrypt(string stringToEncrypt, string encryptDecryptKey)
        {
            return Encrypt(stringToEncrypt, Convert.FromBase64String(encryptDecryptKey), IV);
        }
        /// <summary>
        /// Encrypt text
        /// </summary>
        /// <param name="stringToEncrypt">Plain text</param>
        /// <param name="Key">Encrypt decrypt key in byte array</param>
        /// <returns>Encrypted text</returns>
        public static string Encrypt(string stringToEncrypt, byte[] key)
        {
            return Encrypt(stringToEncrypt, key, IV);
        }
       

        public static string Encrypt(string stringToEncrypt, byte[] key, byte[] iV)
        {
            TripleDESCryptoServiceProvider tripledes = null;
            byte[] inputByteArray = null;
            MemoryStream ms = null;
            CryptoStream cs = null;
            try
            {
                tripledes = new TripleDESCryptoServiceProvider();
                inputByteArray = Encoding.UTF8.GetBytes(stringToEncrypt);
                ms = new MemoryStream();
                cs = new CryptoStream(ms, tripledes.CreateEncryptor(key, iV), CryptoStreamMode.Write);
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                String str = Convert.ToBase64String(ms.ToArray());
                cs.Clear();
                return str;
            }
            catch (Exception ex)
            {
                throw new Exception("EncryptDecryptException", ex.InnerException);
            }
            finally
            {
                tripledes = null;
                inputByteArray = null;
                if (ms != null)
                    ms.Dispose();
                if (cs != null)
                    cs.Dispose();
            }
        }
        #endregion

        #region Decrypt

        /// <summary>
        /// Decrypt text
        /// </summary>
        /// <param name="stringToDecrypt">Encrypted text</param>
        /// <returns>Plain text</returns>
        public static string Decrypt(string stringToDecrypt)
        {
            return Decrypt(stringToDecrypt, KEY, IV);
        }
        /// <summary>
        /// Decrypt text
        /// </summary>
        /// <param name="stringToDecrypt">Encrypted text</param>
        /// <param name="encryptDecryptKey">Encrypt decrypt key in plain text</param>
        /// <returns>Plain text</returns>
        public static string Decrypt(string stringToDecrypt, string encryptDecryptKey)
        {
            return Decrypt(stringToDecrypt, Convert.FromBase64String(encryptDecryptKey), IV);
        }
        /// <summary>
        /// Decrypt text
        /// </summary>
        /// <param name="stringToDecrypt">Encrypted text</param>
        /// <param name="Key">Encrypt decrypt key in byte array</param>
        /// <returns>Plain text</returns>
        public static string Decrypt(string stringToDecrypt, byte[] key)
        {
            return Decrypt(stringToDecrypt, key, IV);
        }
        

        public static string Decrypt(string ciphertext, byte[] key, byte[] iV)
        {
            TripleDESCryptoServiceProvider tripledes = null;
            MemoryStream ms = null;
            CryptoStream cs = null;
            byte[] cipherbytes = null;
            try
            {
                tripledes = new TripleDESCryptoServiceProvider();
                ms = new MemoryStream();
                cs = new CryptoStream(ms, tripledes.CreateDecryptor(key, iV), CryptoStreamMode.Write);
                cipherbytes = Convert.FromBase64String(ciphertext);
                cs.Write(cipherbytes, 0, cipherbytes.Length);
                cs.FlushFinalBlock();
                byte[] decryptedArray = ms.ToArray();
                Char[] characters = new Char[43693];
                Decoder dec = Encoding.UTF8.GetDecoder();

                int charlen = dec.GetChars(decryptedArray, 0, decryptedArray.Length, characters, 0);

                string decrpytedString = new string(characters, 0, charlen);

                return decrpytedString;
            }
            catch (Exception ex)
            {
                throw new Exception("EncryptDecryptException", ex.InnerException);
            }
            finally
            {
                tripledes = null;
                cipherbytes = null;
                if (ms != null)
                    ms.Dispose();
                if (cs != null)
                    cs.Dispose();
            }
        }

        #endregion

        #endregion
    }
}
