table 51533154 PrOtherSetups
{
    //DrillDownPageID = 39004055;
    //LookupPageID = 39004055;

    fields
    {
        field(1; Range; Integer)
        {
            MaxValue = 31;
            MinValue = 1;
        }
        field(3; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Period <> 0 then Error('Please select either amount or days');
            end;
        }
        field(4; Period; Decimal)
        {

            trigger OnValidate()
            begin
                if Amount <> 0 then Error('Please select either amount or days');
            end;
        }
        field(5; "Transaction Code"; Code[50])
        {
        }
        field(6; "Period Type"; Option)
        {
            OptionMembers = Day,Month;
        }
    }

    keys
    {
        key(Key1; Range)
        {
        }
    }

    fieldgroups
    {
    }
}

