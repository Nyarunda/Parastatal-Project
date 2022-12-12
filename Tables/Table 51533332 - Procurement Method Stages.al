table 51533332 "Procurement Method Stages"
{

    fields
    {
        field(1;"Procurement Method";Code[20])
        {
        }
        field(2;Stage;Code[20])
        {
        }
        field(3;Description;Text[50])
        {
        }
        field(4;"Maximum Duration";DateFormula)
        {
        }
        field(5;"Minimum Duration";DateFormula)
        {
        }
    }

    keys
    {
        key(Key1;Stage,"Procurement Method")
        {
        }
        key(Key2;"Maximum Duration")
        {
        }
    }

    fieldgroups
    {
    }
}

