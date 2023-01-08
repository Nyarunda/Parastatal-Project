table 51533071 "HR Training App Header"
{
    Caption = 'HR Training Application Header';
    DataCaptionFields = "Application No", "Course Title", "Course Description";
    DrillDownPageID = "HR Training Application List";
    LookupPageID = "HR Training Application List";

    fields
    {
        field(1; "Application No"; Code[20])
        {
            Editable = true;
        }
        field(2; "Created by"; Text[100])
        {
        }
        field(3; "No. Series"; Code[20])
        {
        }
        field(4; "Application Date"; Date)
        {
        }
        field(5; "Course Title"; Code[20])
        {

            trigger OnValidate()
            begin
                HRTrainingNeeds.Reset;
                if HRTrainingNeeds.Get("Course Title") then begin
                    "Course Description" := HRTrainingNeeds.Description;
                    "Start Date" := HRTrainingNeeds."Start Date";
                    "End Date" := HRTrainingNeeds."End Date";
                    Duration := HRTrainingNeeds.Duration;
                    "Bonded Training?" := HRTrainingNeeds."Bondage Required?";
                    "Global Dimension 1 Code" := HRTrainingNeeds."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := HRTrainingNeeds."Global Dimension 2 Code";
                end else begin
                    Clear("Course Description");
                    Clear("Start Date");
                    Clear("End Date");
                    Clear(Duration);
                    Clear("Bonded Training?");
                    Clear("Global Dimension 1 Code");
                    Clear("Global Dimension 2 Code");
                end;
            end;
        }
        field(6; "Course Description"; Text[100])
        {
        }
        field(7; "No. of Participants"; Integer)
        {
            CalcFormula = Count("HR Training App Lines" WHERE("Application No." = FIELD("Application No"),
                                                               "Employee No." = FILTER(<> '')));
            FieldClass = FlowField;
        }
        field(8; "Start Date"; Date)
        {
        }
        field(9; "End Date"; Date)
        {
        }
        field(10; Duration; DateFormula)
        {
        }
        field(11; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(12; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(13; "Training Institution"; Text[50])
        {
        }
        field(14; "Training Venue"; Text[50])
        {
        }
        field(15; "Training Cost Cstimated"; Decimal)
        {
        }
        field(16; "Bonded Training?"; Boolean)
        {
            Editable = false;
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(19; "Training Status"; Option)
        {
            OptionCaption = ' ,Ongoing,Closed';
            OptionMembers = " ",Ongoing,Closed;
        }
        field(20; "Actual Start Date"; Date)
        {

            trigger OnValidate()
            begin
                CalculateDate;
            end;
        }
        field(21; "Actual Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                CalculateDate;
            end;
        }
        field(22; "Actual End Date"; Date)
        {
            Editable = false;
        }
        field(23; "Course applying"; Code[20])
        {
        }
        field(24; Justification; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Application No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Application No" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Training Application Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Training Application Nos.", xRec."No. Series", 0D, "Application No", "No. Series");
        end;

        "Application Date" := Today;
        "Created by" := 'Created by ' + UserId + ' on ' + Format(CreateDateTime(Today, Time));
    end;

    var
        HRTrainingNeeds: Record "HR Training Needs";
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        mcontent: Label 'Status must be new on Training Application No.';
        mcontent2: Label '. Please cancel the approval request and try again';
        HREmp: Record "HR Employees";
        Vend: Record Vendor;

    local procedure CalculateDate()
    var
        HRDates: Codeunit "HR Dates";
    begin
        TestField("Actual Start Date");

        if "Actual Start Date" <> 0D then begin
            "Actual End Date" := CalcDate("Actual Duration", "Actual Start Date");
        end;
    end;
}

