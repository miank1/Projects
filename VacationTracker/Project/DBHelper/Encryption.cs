using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DBHelper
{
    public class Encryption
    {
        public Encryption()
        {
        }

        public string EncryptText(string TextToEncrypt)
        {
            string strResult = "";
            try
            {
                char[] chrPassword;
                chrPassword = TextToEncrypt.ToCharArray();

                for (int intLoop = 0; intLoop < TextToEncrypt.Length; intLoop++)
                {
                    if (intLoop == 0)
                    {
                        strResult = Convert.ToString((char)(Convert.ToInt16(chrPassword[intLoop]) + TextToEncrypt.Length));
                    }
                    else
                    {
                        strResult += Convert.ToString((char)(Convert.ToInt16(chrPassword[intLoop]) + (intLoop + 1)));
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return strResult;
        }

        public string DecryptText(string TextToEncrypt)
        {
            string strResult = "";
            try
            {
                char[] chrPassword;
                chrPassword = TextToEncrypt.ToCharArray();

                for (int intLoop = 0; intLoop < TextToEncrypt.Length; intLoop++)
                {
                    if (intLoop == 0)
                    {
                        strResult = Convert.ToString((char)(Convert.ToInt16(chrPassword[intLoop]) - TextToEncrypt.Length));
                    }
                    else
                    {
                        strResult += Convert.ToString((char)(Convert.ToInt16(chrPassword[intLoop]) - (intLoop + 1)));
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return strResult;
        }
    }
}