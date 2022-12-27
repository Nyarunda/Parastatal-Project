table 51533974 "Quotatin Analysis Members"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"Staff Code";Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if Emp.Get("Staff Code") then
                  "User Id":=Emp."User ID";
                   "User Name":=Emp."Full Name";
            end;
        }
        field(3;"User Id";Code[50])
        {
        }
        field(4;"User Name";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Code","Staff Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Emp: Record "HR Employees";
}

