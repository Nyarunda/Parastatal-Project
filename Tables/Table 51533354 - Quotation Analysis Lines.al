table 51533354 "Quotation Analysis Lines"
{

    fields
    {
        field(1;"RFQ No.";Code[20])
        {
        }
        field(2;"RFQ Line No.";Integer)
        {
        }
        field(3;"Quote No.";Code[20])
        {
        }
        field(4;"Vendor No.";Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange( Vend."No.","Vendor No.");
                if Vend.Find('-') then
                   "Vendor Name":=Vend.Name;
            end;
        }
        field(5;"Item No.";Code[20])
        {
        }
        field(6;Description;Text[250])
        {
        }
        field(7;Quantity;Decimal)
        {
        }
        field(8;"Unit Of Measure";Code[20])
        {
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;"Line Amount";Decimal)
        {
        }
        field(11;Total;Decimal)
        {
        }
        field(12;"Last Direct Cost";Decimal)
        {
            CalcFormula = Lookup(Item."Last Direct Cost" WHERE ("No."=FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(13;Remarks;Text[50])
        {
        }
        field(14;"Header No";Code[20])
        {
        }
        field(15;Award;Boolean)
        {

            trigger OnValidate()
            begin
                QuoteLine.Reset;
                QuoteLine.SetRange(QuoteLine."Document No.","Quote No.");
                if QuoteLine.Find('-') then
                  if Award = true then
                    QuoteLine.Awarded := true;
                  QuoteLine.Modify;
                  if Award = false then
                    QuoteLine.Awarded := false;
                  QuoteLine.Modify;
                  //MESSAGE('Awarded%1',QuoteLine.Awarded);
            end;
        }
        field(50000;"Vendor Name";Text[70])
        {

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange( Vend."No.","Vendor No.");
                if Vend.Find('-') then
                   "Vendor Name":=Vend.Name;
            end;
        }
        field(50001;"Currency Code";Code[10])
        {
        }
        field(50075;"Delivery Time";Duration)
        {
        }
        field(50076;"Payment Terms";Code[20])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(50110;Brand;Text[40])
        {
        }
        field(50111;Warranty;Duration)
        {
        }
        field(50112;"Country Of Origin";Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(50113;"Professional Opinion";Text[250])
        {
        }
        field(50114;Responsive;Boolean)
        {
        }
        field(50115;"Description 2";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50116;"Percentage( %age)";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50117;"Add Reccomendation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50118;Reccomendation;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ', recommended,not recommended';
            OptionMembers = ," recommended","not recommended";
        }
        field(50119;"Technical Awarded Score";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50120;"Mandatory Comments";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50121;"User ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50122;"Supplier No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50123;"Supplier Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"RFQ No.","RFQ Line No.","Quote No.","Vendor No.","Header No")
        {
        }
        key(Key2;"Item No.")
        {
        }
        key(Key3;"Vendor No.")
        {
        }
        key(Key4;"RFQ No.","RFQ Line No.","Line Amount")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID":=UserId;
    end;

    var
        Vend: Record Vendor;
        QuoteLine: Record "Purchase Line";
}

