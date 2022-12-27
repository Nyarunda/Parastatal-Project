table 51533350 "Quotation Request Vendors"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender";
        }
        field(2; "Requisition Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = Vendor."No." WHERE ("Supplier Category"=FIELD("Scheme Applied"));

            trigger OnValidate()
            begin
                Vendor.Reset;
                Vendor.SetRange(Vendor."No.", "Vendor No.");
                if Vendor.Find('-') then
                    Address := Vendor.Address;
                //Vendor.CalcFields("AGPO Certificate No.");
                //if (Vendor."Supplier Category"=Vendor."Supplier Category"::PWD) or (Vendor."Supplier Category"=Vendor."Supplier Category"::Women) or (Vendor."Supplier Category"=Vendor."Supplier Category"::Youth) then begin

                // IF Vendor."AGPO Certificate No."='' THEN ERROR('Vendor must attach AGPO Crtificate') ELSE
                // IF Vendor."AGPO Expiry Date"<CURRENTDATETIME THEN ERROR('AGPO Cert Expired for this vendor. Kindly Update');
                //end;
            end;
        }
        field(4; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
        field(5; "Vendor Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Vendor Categories".Code;

            trigger OnValidate()
            begin
                VendorCatego.Reset;
                VendorCatego.SetRange(VendorCatego.Code, "Vendor Category Code");
                if VendorCatego.Find('-') then
                    "Vendor Category Description" := VendorCatego.Description;
                Address := Vendor.Address;
            end;
        }
        field(6; "Vendor Category Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Vendor Class"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "vendor class".Code;
        }
        field(8; "PR Requisition No"; Code[20])
        {
            Caption = 'Internal Memo';
            DataClassification = ToBeClassified;
        }
        field(9; Address; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "PRF No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Scheme Applied"; Option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Youth,Women,PWD,General';
            OptionMembers = " ",Youth,Women,PWD,General;
        }
        field(12; "E-mail"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Notified; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Requisition Document No.", "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PurchaseQuoteHeader.Reset;
        PurchaseQuoteHeader.SetRange("No.", "Requisition Document No.");
        if PurchaseQuoteHeader.FindFirst then
            "Vendor Category Code" := PurchaseQuoteHeader."Vendor Category Code";
    end;

    var
        VendorCatego: Record "Vendor Categories";
        QuotationRequest: Record "Quotation Request Vendors";
        Vendor: Record Vendor;
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        AGPO: Code[20];
}

