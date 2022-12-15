table 51533001 "HR Jobs"
{
    DrillDownPageID = "HR Jobs List";
    LookupPageID = "HR Jobs List";

    fields
    {
        field(1; "Job ID"; Code[60])
        {
            Editable = true;
        }
        field(2; "Job Description"; Text[250])
        {
            NotBlank = true;
        }
        field(3; "No of Posts"; Integer)
        {

            trigger OnValidate()
            begin
                //IF "No of Posts" <> xRec."No of Posts" THEN
                CalcFields("Occupied Positions");
                "Vacant Positions" := "No of Posts" - "Occupied Positions";
            end;
        }
        field(4; "Position Reporting to"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID" WHERE(Status = CONST(Approved));

            trigger OnValidate()
            begin
                "Position Reporting Name" := '';

                HRJobs.Reset;
                if HRJobs.Get("Position Reporting to") then begin
                    "Position Reporting Name" := HRJobs."Job Description";
                end;
            end;
        }
        field(5; "Occupied Positions"; Integer)
        {
            // CalcFormula = Count("HR-Employee" WHERE ("Job ID"=FIELD("Job ID"), Status=CONST(Approved)));

            //  FieldClass = FlowField;                                      
            Editable = false;

        }
        field(6; "Vacant Positions"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Vacant Positions" := "No of Posts" - "Occupied Positions";
            end;
        }
        field(7; "Score code"; Code[20])
        {
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                "Global Dimension 1 Name" := '';
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Global Dimension 1 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 1 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(9; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                "Global Dimension 2 Name" := '';
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code, "Global Dimension 2 Code");
                if DimensionValue.Find('-') then begin
                    "Global Dimension 2 Name" := DimensionValue.Name;
                end;
            end;
        }
        field(17; "Total Score"; Decimal)
        {
            Editable = false;
        }
        field(19; "Main Objective"; Text[250])
        {
        }
        field(21; "Key Position"; Boolean)
        {
        }
        field(22; Category; Code[20])
        {
        }
        field(23; Grade; Code[20])
        {
            //TableRelation = "Salary Grades"."Salary Grade";
        }
        field(24; "Employee Requisitions"; Integer)
        {
            //CalcFormula = Count("HR Employee Requisitions" WHERE("Job ID" = FIELD("Job ID")));
            //FieldClass = FlowField;
        }
        field(27; UserID; Code[50])
        {
        }
        field(28; "Supervisor/Manager"; Code[50])
        {
            TableRelation = "HR Jobs"."Job ID";

            trigger OnValidate()
            begin
                HREmp.Get("Supervisor/Manager");
                "Supervisor Name" := HREmp.FullName;
            end;
        }
        field(29; "Supervisor Name"; Text[60])
        {
            Editable = false;
        }
        field(30; Status; Option)
        {
            Editable = true;
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(32; "Date Created"; Date)
        {
        }
        field(33; "No. of Requirements"; Integer)
        {
            //CalcFormula = Count("HR Job Requirements" WHERE("Job ID" = FIELD("Job ID")));
            //FieldClass = FlowField;
        }
        field(34; "No. of Responsibilities"; Integer)
        {
            //CalcFormula = Count("HR Job Responsiblities" WHERE("Job ID" = FIELD("Job ID")));
            //FieldClass = FlowField;
        }
        field(44; "Is Supervisor"; Boolean)
        {
        }
        field(45; "G/L Account"; Code[50])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(46; "Global Dimension 1 Name"; Text[100])
        {
            Editable = false;
        }
        field(47; "Global Dimension 2 Name"; Text[100])
        {
            Editable = false;
        }
        field(49; "Position Reporting Name"; Text[100])
        {
            Editable = false;
        }
        field(50; "No. Series"; Code[20])
        {
        }
        field(50000; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                "Responsibility Center Name" := '';

                RespCenter.Reset;
                if RespCenter.Get("Responsibility Center") then begin
                    "Responsibility Center Name" := RespCenter.Name;
                end;
            end;
        }
        field(50001; "Responsibility Center Name"; Text[100])
        {
            Editable = false;
        }
        field(50002; "Marked for Succession"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Job ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job ID", "Job Description")
        {
        }
    }

    trigger OnDelete()
    begin
        if Status <> Status::New then Error('You cannot delete record when status is %1', Status);
    end;

    trigger OnInsert()
    begin
        if "Job ID" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Job ID Nos");
            NoSeriesMgt.InitSeries(HRSetup."Job ID Nos", xRec."No. Series", 0D, "Job ID", "No. Series");
        end;


        "Date Created" := Today;
    end;

    trigger OnModify()
    begin
        "Vacant Positions" := "No of Posts" - "Occupied Positions";
    end;

    var
        NoOfPosts: Decimal;
        HREmp: Record "HR Employees";
        DimensionValue: Record "Dimension Value";
        RespCenter: Record "Responsibility Center";
        HRJobs: Record "HR Jobs";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

