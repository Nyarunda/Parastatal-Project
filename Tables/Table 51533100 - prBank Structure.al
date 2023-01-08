table 51533100 "prBank Structure"
{
    LookupPageID = "prBank Structure";

    fields
    {
        field(1;"Bank Code";Code[10])
        {
        }
        field(2;"Branch Code";Code[30])
        {
        }
        field(3;"Bank Name";Text[100])
        {
        }
        field(4;"Branch Name";Text[100])
        {
        }
        field(5;Address;Text[100])
        {
        }
        field(10;"Current Month Filter";Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "prPayroll Periods"."Date Opened";
        }
        field(11;"Location/Division Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('LOC/DIV'));
        }
        field(12;"Department Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
        field(13;"Cost Centre Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('COSTCENTRE'));
        }
        field(14;"Salary Grade Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salary Grades"."Salary Grade";
        }
        field(15;"Salary Notch Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Salary Notch"."Salary Notch" WHERE ("Salary Grade"=FIELD("Salary Grade Filter"));
        }
    }

    keys
    {
        key(Key1;"Bank Code","Branch Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Bank Code","Bank Name","Branch Code","Branch Name")
        {
        }
    }
}

