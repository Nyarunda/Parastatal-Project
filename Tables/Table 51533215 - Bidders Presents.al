table 51533215 "Bidders Presents"
{

    fields
    {
        field(1; No; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Bidder No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                Vend.Reset;
                //Vend.SetRange("No.","Addendum / Clarificaton");
                if Vend.Find('-') then begin
                    "Bidder Name" := Vend.Name;
                    //"Bidder Category":= Vend."Supplier Category";
                    Address := Vend."Phone No.";
                    //Rec.MODIFY;

                end;
            end;
        }
        field(4; "Bidder Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Bidder Category"; Enum "People Classification")
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Vendor Category Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Address; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No, "Document No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vend: Record Vendor;
}

