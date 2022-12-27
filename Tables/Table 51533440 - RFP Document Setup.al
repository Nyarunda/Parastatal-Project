table 51533440 "RFP Document Setup"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[250])
        {
        }
        field(3;Mandatory;Boolean)
        {
        }
        field(4;Category;Option)
        {
            OptionCaption = ',Mandatory,Financial,Technical';
            OptionMembers = ,Mandatory,Financial,Technical;
        }
        field(5;"Mandatory Category";Option)
        {
            OptionCaption = ' ,General,All';
            OptionMembers = " ",General,All;
        }
        field(6;"Procurement Method Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Procurement Methods".Code;
        }
        field(7;"Procurement Method";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Procurement Methods".Code;
        }
        field(8;"Tender No";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Quote Header"."No." WHERE ("Procurement Methods"=FIELD("Procurement Method Code"));
        }
    }

    keys
    {
        key(Key1;"Code","Procurement Method Code")
        {
        }
    }

    fieldgroups
    {
    }
}

