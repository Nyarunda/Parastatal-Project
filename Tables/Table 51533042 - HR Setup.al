table 51533042 "HR Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Employee Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(3; "Training Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(4; "Leave Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(6; "Disciplinary Cases Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(7; "Base Calendar"; Code[10])
        {
            //TableRelation = "HR Calendar";
        }
        field(13; "Transport Req Nos"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(14; "Employee Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(15; "Leave Posting Period[FROM]"; Date)
        {
        }
        field(16; "Leave Posting Period[TO]"; Date)
        {
        }
        field(17; "Job Application Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(18; "Exit Interview Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19; "Appraisal Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(20; "Company Activities"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(21; "Default Leave Posting Template"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch"."Journal Template Name";
        }
        field(22; "Positive Leave Posting Batch"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(23; "Leave Template"; Code[10])
        {
            TableRelation = "HR Leave Journal Template";
        }
        field(24; "Leave Batch"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(25; "Job Interview Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(26; "Company Documents"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(27; "HR Policies"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(28; "Notice Board Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(29; "Leave Reimbursment Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(30; "Min. Leave App. Months"; Integer)
        {
            Caption = 'Minimum Leave Application Months';
        }
        field(31; "Negative Leave Posting Batch"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(32; "Appraisal Method"; Option)
        {
            OptionCaption = ' ,Normal Appraisal,360 Appraisal,BSC Appraisal';
            OptionMembers = " ","Normal Appraisal","360 Appraisal","BSC Appraisal";
        }
        field(33; "Appraisal Template"; Code[10])
        {
            //TableRelation = "HR Appraisal Journal Template";
        }
        field(34; "Appraisal Batch"; Code[10])
        {
            //TableRelation = "HR Appraisal Journal Batch".Name;
        }
        field(35; "Appraisal Posting Period[FROM]"; Date)
        {
        }
        field(36; "Appraisal Posting Period[TO]"; Date)
        {
        }
        field(37; "Target Setting Month"; Integer)
        {
        }
        field(38; "Appraisal Interval"; DateFormula)
        {
        }
        field(39; "Job ID Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(40; "HR Loan Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(41; "Loan Batch Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(42; "Overtime Req Nos."; Code[10])
        {
            Caption = 'Overtime Requisition Nos.';
            TableRelation = "No. Series";
        }
        field(43; "Overtime Payroll Code"; Code[20])
        {
        }
        field(50000; "Loan Application Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50001; "Leave Carry Over App Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50002; "Pay-change No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50003; "Max Appraisal Rating"; Decimal)
        {
        }
        field(50004; "Medical Claims Nos"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(50005; "Employee Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50006; "Leave Planner Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50007; "Employee Asset Transfer No."; Code[30])
        {
            TableRelation = "No. Series".Code;
        }
        field(50008; "Company Additional Amount"; Decimal)
        {
        }
        field(50009; "Employee Confirmation No."; Code[30])
        {
            TableRelation = "No. Series".Code;
        }
        field(50010; "Employee Promotion No."; Code[30])
        {
            TableRelation = "No. Series".Code;
        }
        field(50011; "Professional Bodies No."; Code[30])
        {
            TableRelation = "No. Series".Code;
        }
        field(50012; "Employee Grievance Nos."; Code[30])
        {
            TableRelation = "No. Series".Code;
        }
        field(50013; "Proffessional Bodies Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50014; "Traning Needs Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50015; "Induction Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50016; "Transport Allocation Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50017; "Succession Planning Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50018; "Incident Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50019; "Investigation Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50020; "Shift Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50021; "Shift Schedule Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50022; "House Keeping Complains"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50023; "Event Request Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50024; "Kitchen Delivery Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50025; "Security Duty Roaster Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50026; "Motor Vehicle Registor Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50027; "Motor Vehicle Inspection Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50028; "Overtime Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50029; "Checklist Inspection Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50030; "Vehicle Return Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50031; "Transport Office Email"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "House Keeping Duty Roaster Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50033; "Visitor Registor Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50034; "School Generator Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50035; "Staff Register Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50036; "OB Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50037; "Online Job Profile Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50038; "Tender Committees Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Fuel Order"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50040; "Transport Mechanics"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50041; "Out Office days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Retirement Age"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Retirement Age Disabled"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Travel Authorization No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

