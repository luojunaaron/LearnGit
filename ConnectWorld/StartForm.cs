using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;

namespace WSDL
{
    public partial class StartForm : Form
    {
        bool secondPageShown = false;
        public StartForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            System.Net.WebRequest req = System.Net.WebRequest.Create("http://vmzal04:16560/wsa/wsa1/wsdl?targetURI=urn:services-qad-com:financials:IBill:2016-05-15");

            System.Net.WebResponse resp = req.GetResponse();
            System.IO.StreamReader sr = new System.IO.StreamReader(resp.GetResponseStream());
            string result = sr.ReadToEnd().Trim();
            XNamespace ns = XNamespace.Get("http://www.w3.org/2001/XMLSchema");

            XDocument xd = XDocument.Parse(result);
            var query = xd
     .Descendants(ns + "schema")
     .Single(element => (string)element.Attribute("elementFormDefault") == "qualified")
     .Elements(ns + "element")
     .ToDictionary(x => (string)x.Attribute("name"),
                   x => (string)x.Attribute("prodata"));


            foreach (var c in query)
            {
                System.Console.WriteLine("acct: " +
                 c.Key +
                 "\t\t\t" +
                 "contact: " +
                 c.Value);
            }
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void searchBtn_Click(object sender, EventArgs e)
        {
            string wsdlpath = this.wsdlTxt.Text;
            
            System.Net.WebRequest req = System.Net.WebRequest.Create(wsdlpath);

            System.Net.WebResponse resp = req.GetResponse();
            System.IO.StreamReader sr = new System.IO.StreamReader(resp.GetResponseStream());
            string result = sr.ReadToEnd().Trim();

            XNamespace ns = XNamespace.Get("http://www.w3.org/2001/XMLSchema");

            XPathDocument xDoc = new XPathDocument(wsdlpath);
            XPathNavigator xNav = xDoc.CreateNavigator();
            XmlNamespaceManager mngr = new XmlNamespaceManager(xNav.NameTable);
            mngr.AddNamespace("wsdl", "http://schemas.xmlsoap.org/wsdl/"); // this namespace may need to be different - I don't know what your wsdl file looks like
            XPathNodeIterator xIter = xNav.Select("wsdl:definitions/wsdl:types", mngr);
            /*
            while (xIter.MoveNext())
            {
              
             
                 XPathNodeIterator xpni =   xIter.Current.SelectChildren(XPathNodeType.Element);
                while (xpni.MoveNext())
                {
                    if (xpni.Current.GetAttribute("elementFormDefault", "") == "qualified")
                    {
                        //XPathNodeIterator xpni1 = xpni.Current.Select("/element");
                       // while (xpni.MoveNext())
                        {
                            Console.WriteLine("aaaa="  + xpni.Current.SelectChildren(XPathNodeType.Element).Current.GetAttribute("prodata:datasetName", "http://www.w3.org/2001/XMLSchema"));
                        }

                    }
                }
       
            }
            */
            
                        XDocument xd = XDocument.Parse(result);
                        var query = xd
                                 .Descendants(ns + "schema")
                                 .Single(element => (string)element.Attribute("elementFormDefault") == "qualified")
                                 .Elements(ns + "element")
                                 .ToDictionary(x => (string)x.Attribute("name"),
                                 x => (string)x.Attribute("prodatatableName"));

                        foreach (var c in query)
                        {
                            dataItemListBox.Items.Add(c.Key);
                        }
            

        }

        private void dataItemListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string wsdlpath = this.wsdlTxt.Text;
                System.Net.WebRequest req = System.Net.WebRequest.Create(wsdlpath);

                System.Net.WebResponse resp = req.GetResponse();
                System.IO.StreamReader sr = new System.IO.StreamReader(resp.GetResponseStream());
                string result = sr.ReadToEnd().Trim();
                XNamespace ns = XNamespace.Get("http://www.w3.org/2001/XMLSchema");

                XDocument xd = XDocument.Parse(result);
                string selDI = this.dataItemListBox.SelectedItem.ToString();
                var query = xd
                     .Descendants(ns + "element")
                     .Single(element => (string)element.Attribute("name") == selDI)
                     .Element(ns + "complexType")
                     .Element(ns + "sequence")
                     .Element(ns + "element")
                     .Element(ns + "complexType")
                     .Element(ns + "sequence")
                     .Elements(ns + "element")
                     .ToDictionary(x => (string)x.Attribute("name"),
                                   x => (string)x.Attribute("type"));

                dataFieldListBox.Items.Clear();
                foreach (var c in query)
                {

                    dataFieldListBox.Items.Add(c.Key + "(" + c.Value + ")");
                    findList.Items.Add(c.Key + "(" + c.Value + ")");
                    getterList.Items.Add(c.Key + "(" + c.Value + ")");
                    sortList.Items.Add(c.Key + "(" + c.Value + ")");
                }
            }
            catch(Exception ex)
            {
                this.dataFieldListBox.Items.Clear();
                MessageBox.Show("Selected Element is not a dataitem");
            }
             
        }

        private void GenerateBtn_Click(object sender, EventArgs e)
        {
            if (this.classRadio.Checked)
            {
                String classTemplateFileName = @"C:\C_Template.ts";
                string[] lines = System.IO.File.ReadAllLines(classTemplateFileName);
                lines = this.FillInDataItemName(lines);
                lines = this.FileInProperties(lines);
                lines = this.FillInConstructorSig(lines);
                lines = this.FillInConstructorContent(lines);
                lines = this.FillInInitAssignment(lines);
                lines = this.FillInSortFieldName(lines);
                lines = this.FillInGetFieldName(lines);
                this.GenerateFile(lines);
                
            }
            else
            {
                String infTemplateFileName = @"C:\I_Template.ts";
                string[] lines = System.IO.File.ReadAllLines(infTemplateFileName);
                lines = this.FillInDataItemName(lines);
                lines = this.FileInProperties(lines);
                this.GenerateFile(lines);
            }
            MessageBox.Show("Completed!");

        }


        private void GenerateFile(string[] result)
        {
            string selectedDI = this.dataItemListBox.Text.Trim();
            if (this.infRadio.Checked)
                selectedDI = "I" + selectedDI;
            string gtype = "";
            if(infRadio.Checked)
                gtype = @"interface\";
            else
                gtype = @"class\";

            if (!System.IO.File.Exists(@"C:\gen\class" + selectedDI + ".ts"))
            {
                System.IO.FileStream fs = System.IO.File.Create(@"C:\gen\"+ gtype + selectedDI + ".ts");
                fs.Close();
            }

            System.IO.StreamWriter file = new System.IO.StreamWriter(@"C:\gen\" + gtype + selectedDI + ".ts");
            foreach (string line in result)
            {
                file.WriteLine(line);
            }
            file.Close();
        }

        //Write DataItem name
        private string[] FillInDataItemName(string[] lines)
        {
            string selectedDI = this.dataItemListBox.Text.Trim();

            int i = 0;
            foreach (string line in lines)
            {
                if (line.Contains("$DataItemName$"))
                {
                    lines[i] = line.Replace("$DataItemName$", selectedDI);
                }
                i++;

            }
            return lines;
        }


        //Write sort column name
        private string[] FillInSortFieldName(string[] lines)
        {
            if (sortSelected.Items.Count > 0)
            {
                int i = 0;
                while (i < sortSelected.Items.Count)
                {
                    int lineno = 0;
                    foreach (string line in lines)
                    {
                        if (line.Contains("$SortField$"))
                        {
                            string strItem = sortSelected.Items[i].ToString().Trim();
                            string fieldName = strItem.Substring(0, strItem.IndexOf("("));
                            string fieldType = strItem.Trim().Substring(strItem.IndexOf("("), strItem.Length - strItem.IndexOf("("));
                            lines[lineno] = line.Replace("$SortField$", fieldName);
                        }

                        if (line.Contains("$SortFieldDataType$"))
                        {
                            string strItem = sortSelected.Items[i].ToString().Trim();
                            string fieldName = strItem.Substring(0, strItem.IndexOf("("));
                            string fieldType = strItem.Trim().Substring(strItem.IndexOf("("), strItem.Length - strItem.IndexOf("("));
                            lines[lineno] = line.Replace("$SortFieldDataType$", fieldType);
                        }
                        lineno++;

                    }
                    i++;
                }
            }
            else
            {
                int lineno = 0;
                bool inSortSection = false;
                foreach (string line in lines)
                {
                    if (line.Contains("//Sort_Section_Start") || inSortSection)
                    {
                        inSortSection = true;
                        lines[lineno] = "";
                    }

                    if (line.Contains("//Sort_Section_End"))
                    {
                        inSortSection = false;
                        lines[lineno] = "";
                        break;
                    }
                    lineno++;

                }

            }
            return lines;
        }


        //Write Get column name
        private string[] FillInGetFieldName(string[] lines)
        {
            if (getterSelected.Items.Count > 0)
            {
                int i = 0;
                while (i < getterSelected.Items.Count)
                {
                    int lineno = 0;
                    foreach (string line in lines)
                    {
                        if (line.Contains("$GetField$"))
                        {
                            string strItem = getterSelected.Items[i].ToString().Trim();
                            string fieldName = strItem.Substring(0, strItem.IndexOf("("));
                            lines[lineno] = line.Replace("$GetField$", fieldName);
                        }
                        lineno++;

                    }
                    i++;
                }
            }
            else
            {
                int lineno = 0;
                bool inGetSetction = false;
                foreach (string line in lines)
                {
                    if (line.Contains("//Get_Section_Start") || inGetSetction)
                    {
                        inGetSetction = true;
                        lines[lineno] = "";
                    }

                    if (line.Contains("//Get_Section_End"))
                    {
                        inGetSetction = false;
                        lines[lineno] = "";
                        break;
                    }
                    lineno++;

                }

            }
            return lines;
        }


        private string[] FillInConstructorSig(string[] lines)
        {
            int i = 0;
            foreach (string line in lines)
            {
                if (line.Contains("$ConstructorSig$"))
                {
                    string sigStr = "";
                    String[] fieldList = this.dataFieldListBox.Items.Cast<String>().ToArray();
                    int j = 0;
                    foreach (string strProp in fieldList)
                    {
                        string fieldName = "var" + strProp.Trim().Substring(0, strProp.IndexOf("("));
                        string fieldType = strProp.Trim().Substring(strProp.IndexOf("("), strProp.Length - strProp.IndexOf("("));
                        if (j ==5)
                        {
                            sigStr = sigStr + fieldName + ":" + this.ConvertType(fieldType) + "," + "\r\n" + "                            ";
                            j = 0;
                        }
                        else
                        {
                            sigStr = sigStr + fieldName + ":" + this.ConvertType(fieldType) + ",";
                            j++;
                        }
                    }
                    lines[i] = line.Replace("$ConstructorSig$", sigStr.Substring(0,sigStr.Length - 1));
                    break;


                }
                i++;


            }
            return lines;
        }





        private string[] FillInInitAssignment(string[] lines)
        {
            int i = 0;
            foreach (string line in lines)
            {
                if (line.Contains("$InitAssignment$"))
                {
                    string initAssignmentStr = "";
                    String[] fieldList = this.dataFieldListBox.Items.Cast<String>().ToArray();
                    foreach (string strProp in fieldList)
                    {
                        string fieldName =  strProp.Trim().Substring(0, strProp.IndexOf("("));
                       
                            initAssignmentStr = initAssignmentStr + "                this." +fieldName  + ",\r\n";
                         
                       
                    }
                    lines[i] = line.Replace("$InitAssignment$", initAssignmentStr.Substring(0,initAssignmentStr.Length -1 ));
                    break;


                }
                i++;


            }
            return lines;
        }


        private string[] FillInConstructorContent(string[] lines)
        {
            int i = 0;
            foreach (string line in lines)
            {
                if (line.Contains("$ConstructorContent$"))
                {
                    string consContent = "";
                    String[] fieldList = this.dataFieldListBox.Items.Cast<String>().ToArray();
                    foreach (string strProp in fieldList)
                    {
                        string fieldName = strProp.Trim().Substring(0, strProp.IndexOf("("));
                        string fieldType = strProp.Trim().Substring(strProp.IndexOf("("), strProp.Length - strProp.IndexOf("("));

                        consContent = consContent + "        this." + fieldName + " = " +  "var" + fieldName + ";" + "\r\n";
                    }
                    lines[i] = line.Replace("$ConstructorContent$", consContent);
                    break;


                }
                i++;


            }
            return lines;
        }



        private string ConvertType(string jsonType)
        {
            if (jsonType.Contains("xsd:string"))
                return "string";

            if (jsonType.Contains("xsd:boolean"))
                return "boolean";

            return "number";
        }

        //Write DataItem name
        private string[] FileInProperties(string[] lines)
        {
            int i = 0;
            string spaceStr = "";
            foreach (string line in lines)
            {
                if (line.Contains("$Properties$"))
                {
                    int startP = line.IndexOf("$");
                    int k = 0;
                    while (k < startP)
                    {
                        spaceStr = spaceStr + " ";
                        k++;
                    }
                    string propList = "";
                    String[] fieldList =  this.dataFieldListBox.Items.Cast<String>().ToArray();
                    foreach (string strProp in fieldList)
                    {
                        string fieldName = strProp.Trim().Substring(0, strProp.IndexOf("("));
                        string fieldType = strProp.Trim().Substring(strProp.IndexOf("("), strProp.Length - strProp.IndexOf("("));
                        propList = propList + fieldName + ":" + this.ConvertType(fieldType) + ";" + "\r\n" + spaceStr;
                    }
                    lines[i] = line.Replace("$Properties$", propList);
                    break;


                }
                i++;
               

            }
            return lines;
        }

        private void StartForm_Load(object sender, EventArgs e)
        {
            tabPage.Visible = false;
            this.nextBtn.Enabled = this.classRadio.Checked;
            getterList.Visible = true;
            getterSelected.Visible = true;
            label2.Visible = true;
            label3.Visible = true;
        }

        private void setterList_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

  

        private void getterList_DoubleClick(object sender, EventArgs e)
        {
            getterSelected.Items.Add(getterList.SelectedItem);
            getterList.Items.RemoveAt(getterList.SelectedIndex);
        }

        private void getterSelected_DoubleClick(object sender, EventArgs e)
        {
            getterList.Items.Add(getterSelected.SelectedItem);
            getterSelected.Items.RemoveAt(getterSelected.SelectedIndex);
        }

        private void sortList_DoubleClick(object sender, EventArgs e)
        {
            sortSelected.Items.Add(sortList.SelectedItem);
            sortList.Items.RemoveAt(sortList.SelectedIndex);
        }

        private void sortSelected_DoubleClick(object sender, EventArgs e)
        {
            sortList.Items.Add(sortSelected.SelectedItem);
            sortSelected.Items.RemoveAt(sortSelected.SelectedIndex);
        }

        private void infRadio_CheckedChanged(object sender, EventArgs e)
        {
            

        }

        private void classRadio_CheckedChanged(object sender, EventArgs e)
        {
            this.nextBtn.Enabled = true;
           
        }

        private void nextBtn_Click(object sender, EventArgs e)
        {
            
            this.dataFieldListBox.Visible = false;
            this.dataItemListBox.Visible = false;
            label2.Visible = false;
            label3.Visible = false;
            tabPage.Visible = true;

            nextBtn.Enabled = false;

        }

        private void infRadio_CheckedChanged_1(object sender, EventArgs e)
        {
            this.dataFieldListBox.Visible = true;
            this.dataItemListBox.Visible = true;
            tabPage.Visible = false;
            this.nextBtn.Enabled = false;
            label2.Visible = true;
            label3.Visible = true;
        }
    }
}

