table 51533072 "HR Training Needs"
{
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "HR Training Needs List";
    LinkedObject = false;
    LookupPageID = "HR Training Needs List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[200])
        {
        }
        field(3; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                CalculateDate;
            end;
        }
        field(4; "End Date"; Date)
        {
            Editable = true;
        }
        field(5; Duration; DateFormula)
        {

            trigger OnValidate()
            begin
                CalculateDate;
            end;
        }
        field(6; Costs; Decimal)
        {
            CalcFormula = Sum("HR Training Cost".Cost WHERE("Training ID" = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(7; Location; Text[100])
        {
        }
        field(8; "Re-Assessment Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Re-Assessment Date" < "End Date" then Error('Re-Assesment date should be greater than the start date');
            end;
        }
        field(9; "Need Source"; Option)
        {
            OptionCaption = '  ,Appraisal,Succesion,Training,Employee,Employee Skill Plan,Competency Profiling';
            OptionMembers = "  ",Appraisal,Succesion,Training,Employee,"Employee Skill Plan","Competency Profiling";
        }
        field(10; "External Provider"; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                CalcFields("External Provider Name");
            end;
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(12; Closed; Boolean)
        {
            Editable = false;
        }
        field(13; "Qualification Code"; Code[20])
        {
            TableRelation = "HR Job Qualifications".Code WHERE("Qualification Type" = FIELD("Qualification Type"));

            trigger OnValidate()
            begin
                HRQualifications.Reset;
                if HRQualifications.Get("Qualification Type", "Qualification Code") then
                    "Qualification Description" := HRQualifications.Description;
            end;
        }
        field(14; "Qualification Type"; Code[30])
        {
            NotBlank = false;
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Job Group Range"));
        }
        field(15; "Qualification Description"; Text[80])
        {
        }
        field(16; "External Provider Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("External Provider")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(18; "Bondage Start Date"; Date)
        {
            Editable = false;
        }
        field(19; "Bondage Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                "Bondage Release Date" := CalcDate("Bondage Duration", "Bondage Start Date");
            end;
        }
        field(20; "Bondage Release Date"; Date)
        {
            Editable = false;
        }
        field(21; "Inclusive of Non Working Days"; Boolean)
        {

            trigger OnValidate()
            begin
                CalculateDate;
            end;
        }
        field(22; "Bondage Required?"; Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Start Date");
                TestField("End Date");

                Clear("Bondage Start Date");
                Clear("Bondage Duration");
                Clear("Bondage Release Date");

                if "Bondage Required?" then begin
                    "Bondage Start Date" := "End Date";
                    Validate("Bondage Duration");
                end;
            end;
        }
        field(23; "No. of Training Cost Items"; Integer)
        {
        }
        field(24; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Cancelled,Approved';
            OptionMembers = Open,"Pending Approval",Cancelled,Approved;
        }
        field(25; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(26; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(27; "Currency Code"; Code[20])
        {
            TableRelation = Currency.Code;
        }
        field(28; "Early Bonded Exit?"; Boolean)
        {
        }
        field(29; "Employee No"; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(30; "No. Series"; Code[20])
        {
        }
        field(31; "Hrs per day"; Decimal)
        {
        }
        field(32; Provider; Option)
        {
            OptionMembers = " ",Internal,External;
        }
        field(33; "Internal Provider"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if Code = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Traning Needs Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Traning Needs Nos.", xRec."No. Series", 0D, Code, "No. Series");
        end;
    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Dates: Codeunit "HR Dates";
        HRQualifications: Record "HR Job Qualifications";

    local procedure CalculateDate()
    var
        HRDates: Codeunit "HR Dates";
    begin
        /*
        TESTFIELD("Start Date");
        
        IF "Start Date" <> 0D THEN
        BEGIN
            "Re-Assessment Date":=0D;
            "End Date":=CALCDATE(Duration,"Start Date");
        END;
        */

    end;
}

