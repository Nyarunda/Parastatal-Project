table 51533074 "HR Training App Lines"
{
    //DrillDownPageID = 52018713;
    //LookupPageID = 52018713;

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Application No."; Code[20])
        {
        }
        field(3; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmployees.Reset;
                if HREmployees.Get("Employee No.") then begin
                    Name := HREmployees."First Name" + ' ' + HREmployees."Middle Name" + ' ' + HREmployees."Last Name";
                    "Job ID" := HREmployees."Job ID";
                    "Job Title" := HREmployees."Job Title";
                end else begin
                    Name := '';
                    "Job ID" := '';
                    "Job Title" := '';
                end;
            end;
        }
        field(4; Name; Text[50])
        {
        }
        field(5; Objectives; Text[250])
        {
        }
        field(6; "Job ID"; Code[10])
        {
        }
        field(7; "Job Title"; Text[50])
        {
        }
        field(8; Notified; Boolean)
        {
        }
        field(9; Suggested; Boolean)
        {
            Editable = false;
        }
        field(10; Attended; Boolean)
        {
        }
        field(11; "Provided attendance evidence?"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Provided attendance evidence?" = true then
                    Attended := true
                else
                    Attended := false;
            end;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Application No.")
        {
        }

    }

    fieldgroups
    {
    }

    var
        HREmployees: Record "HR Employees";
}

