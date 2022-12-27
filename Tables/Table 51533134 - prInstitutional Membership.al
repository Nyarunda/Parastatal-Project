table 51533134 "prInstitutional Membership"
{
    //LookupPageID = 39004018;

    fields
    {
        field(1; "Group No"; Code[10])
        {
            TableRelation = "prMembership Groups"."Group No";
        }
        field(2; "Institution No"; Code[10])
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Address; Text[200])
        {
        }
        field(10; "Current Month Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(11; "Location/Division Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('LOC/DIV'));
        }
        field(12; "Department Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(13; "Cost Centre Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('COSTCENTRE'));
        }
        field(14; "Salary Grade Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salary Grades"."Salary Grade";
        }
        field(15; "Salary Notch Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salary Notch"."Salary Notch" WHERE("Salary Grade" = FIELD("Salary Grade Filter"));
        }
    }

    keys
    {
        key(Key1; "Group No", "Institution No")
        {
        }
    }

    fieldgroups
    {
    }
}

