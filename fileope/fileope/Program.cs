using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Serialization;
using System.Xml;
using System.Xml.Schema;

namespace ope
{
    class MainClass
	{
		public static void Main (string[] args)
		{
			string name1 = "C:\\Users\\admin\\Documents\\Tencent Files\\792802515\\FileRecv\\combine.lua";
			string Path1 = "C:\\Users\\admin\\Documents\\Tencent Files\\792802515\\FileRecv\\game";
			string name2 = "C:\\Users\\admin\\Documents\\Tencent Files\\792802515\\FileRecv\\game\\JOWBaseComponent.lua";
            fileope fo = new fileope();
			fo.combine(name1, Path1);
            string str = System.Text.Encoding.UTF8.GetString(fo.search(name2, name1));
            Console.Write(str);
			Console.ReadKey();
		}
		
	}
    class fileope
    {
        public void combine(string name, string path)
        {
            SerializableDictionary<string, int> table = new SerializableDictionary<string, int>();
            DirectoryInfo dic = new DirectoryInfo(path);
            FileInfo[] files = searchfiles(dic);
            FileStream writer = new FileStream(name, FileMode.Append);
            int off = 0;
            foreach (FileInfo file in files)
            {
                if (file.Extension == ".lua")
                {
                    FileStream reader = new FileStream(file.FullName, FileMode.Open);
                    byte[] buff = new byte[(int)reader.Length];
                    reader.Read(buff, 0, buff.Length);
                    table.Add(file.FullName, off);
                    writer.Write(buff, 0, buff.Length);
                    off += buff.Length;
                    reader.Close();
                }
            }
            using (FileStream fileStream = new FileStream(@"C:\Users\admin\Documents\Tencent Files\792802515\FileRecv\table.xml", FileMode.Create))
            {
                XmlSerializer xmlFormatter = new XmlSerializer(typeof(SerializableDictionary<string, int>));
                xmlFormatter.Serialize(fileStream, table);
            }
            writer.Close();

        }

        private FileInfo[] searchfiles(DirectoryInfo dic)
        {
            FileInfo[] f1 = dic.GetFiles();
            DirectoryInfo[] d1 = dic.GetDirectories();
            foreach( DirectoryInfo di in d1)
            {
                FileInfo[] f2 = searchfiles(di);
                FileInfo[] f3 = new FileInfo[f1.Length + f2.Length];
                f1.CopyTo(f3, 0);
                f2.CopyTo(f3, f1.Length);
                f1 = f3;
            }
            return f1;
        }

        public byte[] search(string name, string path)
        {
            int off = -1;
            int count = -1;
            SerializableDictionary<string, int> table = new SerializableDictionary<string, int>();
            using (FileStream fileStream = new FileStream(@"C:\Users\admin\Documents\Tencent Files\792802515\FileRecv\table.xml", FileMode.Open))
            {
                XmlSerializer xmlFormatter = new XmlSerializer(typeof(SerializableDictionary<string, int>));
                table = (SerializableDictionary<string, int>)xmlFormatter.Deserialize(fileStream);
            }
            FileStream searcher = new FileStream(path, FileMode.Open);
            foreach (KeyValuePair<string, int> kvp in table)
            {
                if (count != -1)
                {
                    break;
                }
                if (off != -1)
                {
                    count = kvp.Value - off;
                }
                if (kvp.Key == name)
                {
                    off = kvp.Value;
                }
            }
            byte[] buffer = new byte[count];
            searcher.Position = off;
            searcher.Read(buffer, 0, count);
            searcher.Close();
            return buffer;
        }
    }
	[Serializable]  
	public class SerializableDictionary<TKey, TValue> : Dictionary<TKey, TValue>, IXmlSerializable  
	{  
		public SerializableDictionary() { }  
		public void WriteXml(XmlWriter write)       // Serializer  
		{  
			    XmlSerializer KeySerializer = new XmlSerializer(typeof(TKey));  
			    XmlSerializer ValueSerializer = new XmlSerializer(typeof(TValue));  
			  
			    foreach (KeyValuePair<TKey, TValue> kv in this)  
				    {  
				        write.WriteStartElement("SerializableDictionary");  
				        write.WriteStartElement("key");  
				        KeySerializer.Serialize(write, kv.Key);  
				        write.WriteEndElement();  
				        write.WriteStartElement("value");  
				        ValueSerializer.Serialize(write, kv.Value);  
				        write.WriteEndElement();  
				        write.WriteEndElement();  
				    }  
			}  
		public void ReadXml(XmlReader reader)       // Deserializer  
		{  
			    reader.Read();  
			    XmlSerializer KeySerializer = new XmlSerializer(typeof(TKey));  
			    XmlSerializer ValueSerializer = new XmlSerializer(typeof(TValue));  
			  
			    while (reader.NodeType != XmlNodeType.EndElement)  
				    {  
				        reader.ReadStartElement("SerializableDictionary");  
				        reader.ReadStartElement("key");  
				        TKey tk = (TKey)KeySerializer.Deserialize(reader);  
				        reader.ReadEndElement();  
				        reader.ReadStartElement("value");  
				        TValue vl = (TValue)ValueSerializer.Deserialize(reader);  
				        reader.ReadEndElement();  
				        reader.ReadEndElement();  
				        this.Add(tk, vl);  
				        reader.MoveToContent();  
				    }  
			    reader.ReadEndElement();  
			  
		}
        public XmlSchema GetSchema()
        {
            throw new NotImplementedException();
        }
    }  
}
