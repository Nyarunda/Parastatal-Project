table 51533126 "prPayroll Type"
{
    //DrillDownPageID = 39004025;
    //LookupPageID = 39004025;

    fields
    {
        field(1; "Payroll Code"; Code[10])
        {
        }
        field(2; "Payroll Name"; Text[50])
        {
        }
        field(3; Comment; Text[200])
        {
        }
        field(4; "Period Length"; DateFormula)
        {
        }
        field(5; EntryNo; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Payroll Code")
        {
        }
        key(Key2; EntryNo)
        {
        }
    }

    fieldgroups
    {
    }
}

