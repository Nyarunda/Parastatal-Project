table 51533357 "Evaluation Year"
{
    DrillDownPageID = "Evaluation Year List";
    LookupPageID = "Evaluation Year List";

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Year;Integer)
        {
        }
        field(3;Description;Code[20])
        {
        }
        field(4;"Start Date";Date)
        {
            Caption = 'Evaluation Start Date';
        }
        field(5;"End Date";Date)
        {
            Caption = 'Evaluation End Date';
        }
    }

    keys
    {
        key(Key1;Year,"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

