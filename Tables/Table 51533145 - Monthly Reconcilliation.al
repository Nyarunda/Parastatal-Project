table 51533145 "Monthly Reconcilliation"
{

    fields
    {
        field(1; Employee; Code[20])
        {
        }
        field(2; TransCode; Code[20])
        {
        }
        field(3; Description; Text[50])
        {
        }
        field(4; CurrAmount; Decimal)
        {
        }
        field(5; PrevAmount; Decimal)
        {
        }
        field(6; "Refference Code"; Code[20])
        {
        }
        field(7; Difference; Decimal)
        {
        }
        field(8; "Group Order"; Integer)
        {
        }
        field(9; "Sub Group Order"; Integer)
        {
        }
        field(10; "Entry/Exit"; Boolean)
        {
        }
        field(11; "Location/Division"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('LOC/DIV'));
        }
        field(12; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(13; "Cost Centre"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('COSTCENTRE'));
        }
        field(14; "Salary Grade"; Code[20])
        {
            TableRelation = "Salary Grades"."Salary Grade";
        }
        field(15; "Salary Notch"; Code[20])
        {
            TableRelation = "Salary Notch"."Salary Notch" WHERE("Salary Grade" = FIELD("Salary Grade"));
        }
    }

    keys
    {
        key(Key1; Employee, TransCode, "Group Order", "Refference Code", "Entry/Exit")
        {
            SumIndexFields = Difference;
        }
        key(Key2; TransCode, "Location/Division", Department, "Cost Centre", "Salary Grade", "Salary Notch")
        {
            SumIndexFields = Difference;
        }
    }

    fieldgroups
    {
    }
}

