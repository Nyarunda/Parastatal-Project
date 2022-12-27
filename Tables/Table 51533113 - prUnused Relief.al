table 51533113 "prUnused Relief"
{

    fields
    {
        field(1; "Employee Code"; Code[10])
        {
        }
        field(2; "Unused Relief"; Decimal)
        {
        }
        field(3; "Period Month"; Integer)
        {
        }
        field(4; "Period Year"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Period Month", "Period Year")
        {
        }
    }

    fieldgroups
    {
    }
}

