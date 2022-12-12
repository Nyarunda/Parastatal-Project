table 51533360 "Evaluation Parameters Setup"
{

    fields
    {
        field(1;"Line No";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Code";Code[10])
        {
        }
        field(3;Description;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Line No","Code")
        {
        }
    }

    fieldgroups
    {
    }
}

