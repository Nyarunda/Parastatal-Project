table 51533908 "Inspection Analysis Members"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Staff Code"; Code[20])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if Emp.Get("Staff Code") then
                    "User Id" := Emp."User ID";
                "User Name" := Emp."Full Name";
            end;
        }
        field(3; "User Id"; Code[50])
        {
        }
        field(4; "User Name"; Text[30])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(5; Approve; Boolean)
        {

            trigger OnValidate()
            begin
                if "User Id" <> UserId then Error('Only users assigned to an inspection can approve');
            end;
        }
        field(6; Comment; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Staff Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Emp: Record "HR Employees";
}

