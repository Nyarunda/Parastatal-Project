table 51533155 prLatenessLedger
{
    DrillDownPageID = 39004056;
    LookupPageID = 39004056;

    fields
    {
        field(1;"Employee Code";Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2;"Transaction Code";Code[30])
        {
            TableRelation = "prTransaction Codes"."Transaction Code";
        }
        field(4;"Payroll Period";Date)
        {
            TableRelation = "prPayroll Periods"."Date Opened" WHERE (Closed=CONST(false));
        }
        field(5;"No. Of Days";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Employee Code","Transaction Code","Payroll Period")
        {
        }
    }

    fieldgroups
    {
    }
}

