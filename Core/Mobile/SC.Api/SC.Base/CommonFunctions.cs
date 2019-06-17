using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace SC.Base
{
    public static class CommonFunctions
    {
        public static void SetProperty(string compoundProperty, object target, object value)
        {
            string[] bits = compoundProperty.Split('.');
            PropertyInfo propertyToSet = target.GetType().GetProperty(bits.Last());

            if (propertyToSet != null)
            {
                TypeConverter converter = TypeDescriptor.GetConverter(propertyToSet.PropertyType);
                if (converter.CanConvertTo(propertyToSet.PropertyType))
                {
                    propertyToSet.SetValue(target, converter.ConvertTo(value, propertyToSet.PropertyType), null);
                }
                else if (propertyToSet.PropertyType.GenericTypeArguments.Length > 0 && converter.CanConvertTo(propertyToSet.PropertyType.GenericTypeArguments[0]) && propertyToSet.PropertyType.GenericTypeArguments[0] != typeof(DateTime))
                {
                    propertyToSet.SetValue(target, converter.ConvertTo(value, propertyToSet.PropertyType.GenericTypeArguments[0]), null);
                }
                else if (propertyToSet.PropertyType == typeof(DateTime) || (propertyToSet.PropertyType.GenericTypeArguments.Length > 0 && propertyToSet.PropertyType.GenericTypeArguments[0] == typeof(DateTime)))
                {
                    propertyToSet.SetValue(target, Convert.ToDateTime(value), null);
                }
                else if (propertyToSet.PropertyType == typeof(decimal))
                {
                    propertyToSet.SetValue(target, Convert.ToDecimal(value), null);
                }
            }
        }

        public static string FirstCharToUpper(string input)
        {
            return input.First().ToString().ToUpper() + input.Substring(1);
        }

        public static string FirstCharToLower(string input)
        {
            return input.First().ToString().ToLower() + input.Substring(1);
        }

        public static string EncodeBase64(string data)
        {
            string str = data.Trim().Replace(" ", "+");
            if (str.Length % 4 > 0)
            {
                str = str.PadRight(str.Length + 4 - str.Length % 4, '=');
            }
            return str;
        }
    }
}
