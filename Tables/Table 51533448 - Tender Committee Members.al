table 51533448 "Tender Committee Members"
{
    Caption = 'HR Activity Participants';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Enum "Document Types")
        {
            Caption = 'Document Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = true;
        }
        field(4; "Sequence No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Sequence No.';
        }
        field(5; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
        }
        field(6; "Sender ID"; Code[50])
        {
            Caption = 'Sender ID';
            Editable = true;
        }
        field(7; Contribution; Decimal)
        {
            Caption = 'Contribution';
        }
        field(8; "Approver ID"; Code[50])
        {
            Caption = 'Participant User ID';
            Editable = true;
        }
        field(9; "Activity Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Created,Open,Canceled,Rejected,Approved';
            OptionMembers = Created,Open,Canceled,Rejected,Approved;
        }
        field(10; "Date-Time Sent for Approval"; DateTime)
        {
            Caption = 'Date-Time Sent for Approval';
        }
        field(11; "Last Date-Time Modified"; DateTime)
        {
            Caption = 'Last Date-Time Modified';
        }
        field(12; "Last Modified By ID"; Code[50])
        {
            Caption = 'Last Modified By ID';
        }
        field(13; Comment; Boolean)
        {
            CalcFormula = Exist("Approval Comment Line" WHERE("Table ID" = FIELD("Table ID"),
                                                               "Document Type" = FIELD("Document Type"),
                                                               "Document No." = FIELD("Document No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Event Date"; DateTime)
        {
            Caption = 'Event Date';
            Editable = false;
        }
        field(15; "Event Code"; Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Event Code';
            Editable = false;
        }
        field(16; "Event Description"; Text[30])
        {
            AutoFormatType = 1;
            Caption = 'Event Description';
            Editable = false;
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(18; "Approval Type"; Option)
        {
            Caption = 'Approval Type';
            OptionCaption = ' ,Sales Pers./Purchaser,Approver';
            OptionMembers = " ","Sales Pers./Purchaser",Approver;
        }
        field(19; "Limit Type"; Option)
        {
            Caption = 'Limit Type';
            OptionCaption = 'Approval Limits,Credit Limits,Request Limits,No Limits';
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits";
        }
        field(20; "Event Venue"; Text[30])
        {
            Caption = 'Event Venue';
            Editable = false;
        }
        field(21; "Email Message"; Text[250])
        {
            Caption = 'Email Message';
        }
        field(22; Participant; Code[30])
        {
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                /* HREmp.RESET;
                 HREmp.SETRANGE(HREmp."No.",Participant);
                 IF HREmp.FIND('-') THEN
                 BEGIN
                 "Partipant Name":=HREmp."First Name";
                 "Participant Email":=HREmp."Company E-Mail";
                 "User ID":=HREmp."User ID";
                 END;*/

                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."User ID", Participant);
                if UserSetup.Find('-') then begin
                    //"Partipant Name":=UserSetup."Employee name";
                    "Participant Email" := UserSetup."E-Mail";
                    //"User ID":= UserSetup."User ID";
                end;
                //          TendComm.RESET;
                //          TendComm.SETRANGE(TendComm.Code,"Document No.");
                //          IF TendComm.FIND('-') THEN BEGIN
                //          "Email Message":=TendComm."Email Message";
                //          TendComm.MODIFY;
                //          END;
                //IF HREmp.GET(Participant) THEN
                /**
                "Approver ID" := UserSetup."Approver ID";
                // HRCompanyActivities.GET("Document No.");
                "Event Date" := HRCompanyActivities.Date;
                "Event Venue" := HRCompanyActivities.Venue;
                "Email Message" := HRCompanyActivities."Email Message";
                "Event Code" := HRCompanyActivities.Code;
                "Event Description" := HRCompanyActivities.Description;
                "Sender ID" := UserId;
                "Activity Status" := "Activity Status"::Created;
                **/

            end;
        }
        field(23; Notified; Boolean)
        {
            Editable = false;
        }
        field(24; "Partipant Name"; Text[60])
        {
        }
        field(25; "Attendance Confimed"; Boolean)
        {
        }
        field(26; "Line. No"; Integer)
        {
            AutoIncrement = false;
        }
        field(27; "Participant Email"; Text[100])
        {
        }
        field(28; "User ID"; Code[60])
        {
        }
        field(29; "RFQ No"; Code[20])
        {
        }
        field(30; Roles; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Member,Chaiperson,Secretary';
            OptionMembers = " ",Member,Chaiperson,Secretary;

            trigger OnValidate()
            begin
                if Roles = Roles::Chaiperson then
                    Delegate := true;
                if Roles = Roles::Secretary then
                    Delegate := true;
                if Roles = Roles::Member then
                    Delegate := false;
                if Roles = Roles::" " then
                    Delegate := false;

                //MESSAGE('Delegate%1',Delegate);
            end;
        }
        field(31; Delegate; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", Participant, "RFQ No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /**TendComm.Reset;
        TendComm.SetRange(TendComm.Code, "Document No.");
        if TendComm.FindFirst then
            "RFQ No" := TendComm."RFQ No.";
            **/
    end;

    var
        //HRCompanyActivities: Record "HR Company Activities";
        HREmp: Record "HR Employees";
        //TendComm: Record "Tender Committee Activities";
        UserSetup: Record "User Setup";

    procedure ShowDocument()
    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
    begin
        case "Table ID" of
            DATABASE::"Sales Header":
                begin
                    if not SalesHeader.Get("Document Type", "Document No.") then
                        exit;
                    case "Document Type" of
                        "Document Type"::Quote:
                            PAGE.Run(PAGE::"Sales Quote", SalesHeader);
                        "Document Type"::Order:
                            PAGE.Run(PAGE::"Sales Order", SalesHeader);
                        "Document Type"::Invoice:
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                        "Document Type"::"Credit Memo":
                            PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                    //"Document Type"::Order:
                    //PAGE.Run(PAGE::"Blanket Sales Order", SalesHeader);
                    //"Document Type"::Order:
                    //  PAGE.Run(PAGE::"Sales Return Order", SalesHeader);
                    end;
                end;
            DATABASE::"Purchase Header":
                begin
                    if not PurchHeader.Get("Document Type", "Document No.") then
                        exit;
                    case "Document Type" of
                        "Document Type"::Quote:
                            PAGE.Run(PAGE::"Sales Quote", SalesHeader);
                        "Document Type"::Order:
                            PAGE.Run(PAGE::"Sales Order", SalesHeader);
                        "Document Type"::Invoice:
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader);
                        "Document Type"::"Credit Memo":
                            PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                    //"Document Type"::Order:
                    //PAGE.Run(PAGE::"Blanket Sales Order", SalesHeader);
                    //"Document Type"::Order:
                    //  PAGE.Run(PAGE::"Sales Return Order", SalesHeader);
                    end;
                end;
        end;
    end;
}

