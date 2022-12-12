table 51533361 "Evaluation Criterial Header"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Evaluation Year"; Integer)
        {
            TableRelation = "Evaluation Year";
        }
        field(3; "Actual Weight Assigned"; Decimal)
        {
        }
        field(4; Description; Code[150])
        {
        }
        field(5; "RFQ No."; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Purchase Quote Header"."No.";
        }
        field(6; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(7; YesNo; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(8; "Procurement Method"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Evaluation Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Mandatory,Financial,Technical';
            OptionMembers = " ",Mandatory,Financial,Technical;
        }
        field(10; "Evaluation Maximum Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "User ID"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Bid Status"; Enum "Approval Status")
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "RFQ No.", "Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

