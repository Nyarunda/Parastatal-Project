table 51533143 "Salary Grades"
{
    DrillDownPageID = "Salary Grades List";
    LookupPageID = "Salary Grades List";

    fields
    {
        field(1;"Salary Grade";Code[20])
        {
        }
        field(2;"Salary Amount";Decimal)
        {
        }
        field(3;Description;Text[100])
        {
        }
        field(4;"Pays NHF";Boolean)
        {
        }
        field(5;"Pays NSITF";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Salary Grade")
        {
        }
    }

    fieldgroups
    {
    }
}

