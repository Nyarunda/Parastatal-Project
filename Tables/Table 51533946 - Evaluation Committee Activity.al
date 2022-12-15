table 51533924 "Evaluation Committee Activity"
{
    //LookupPageID = "Evaluation Committee List";

    fields
    {
        field(1; "Code"; Code[30])
        {

            trigger OnValidate()
            begin
                // IF Code <> xRec.Code THEN BEGIN
                //  HRSetup.GET;
                //  //NoSeriesMgt.TestManual(HRSetup.);
                //  "No. Series":= '';
                // END;



                if Code <> xRec.Code then begin
                    NoSetup.Get();
                    NoSeriesMgt.TestManual(NoSetup."Evaluation Commitee");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "RFQ Description"; Text[200])
        {
        }
        field(3; Date; DateTime)
        {
        }
        field(4; Venue; Text[200])
        {
        }
        field(5; "Employee Responsible"; Code[20])
        {
            TableRelation = "HR Employees";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Employee Responsible");
                if HREmp.Find('-') then begin
                    EmpName := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Employee Name" := EmpName;
                end;
            end;
        }
        field(6; Costs; Decimal)
        {
        }
        field(7; "G/L Account No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                GLAccts.Reset;
                GLAccts.SetRange(GLAccts."No.", "G/L Account No");
                if GLAccts.Find('-') then begin
                    "G/L Account Name" := GLAccts.Name;
                end;
            end;
        }
        field(8; "Bal. Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            begin
                //{
                //IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
                //GLAccts.GET(GLAccts."No.")
                //ELSE
                //Banks.GET(Banks."No.");
                //}
            end;
        }
        field(9; "Bal. Account No"; Code[20])
        {
            NotBlank = true;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(16; "Email Message"; Text[250])
        {
        }
        field(17; "No. Series"; Code[10])
        {
        }
        field(18; Closed; Boolean)
        {
            Editable = true;
        }
        field(19; "Contribution Amount (If Any)"; Decimal)
        {
        }
        field(20; "Activity Status"; Option)
        {
            OptionCaption = 'Planning,On going,Complete';
            OptionMembers = Planning,"On going",Complete;
        }
        field(21; "G/L Account Name"; Text[50])
        {
        }
        field(22; "Employee Name"; Text[50])
        {
        }
        field(23; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(24; Status; Option)
        {
            Editable = true;
            OptionMembers = New,"Pending Approval",Approved,Rejected,Canceled;

            trigger OnValidate()
            var
                Astring: Text;
                WorkingString: Text;
                String1: Text;
            begin
                if Status = Status::Approved then begin
                    /**
                    HRActivityApprovalEntry.Reset;
                    HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Code);
                    if HRActivityApprovalEntry.Find('-') then begin
                        repeat
                            // IF Status <> Status::Approved THEN
                            // ERROR('You Cannot notify a participant when the application is not approved');

                            /*SMTP.CreateMessage('Dear'+' '+HRActivityApprovalEntry."Partipant Name",'erp@ufaa.go.ke',HRActivityApprovalEntry."Participant Email",
                               "RFQ Description","Email Message"+'. '+ 'On' + ' ' + FORMAT(Date) +'  '+FORMAT(Time)+'At'+Venue+'. '+HRActivityApprovalEntry."Email Message"+'. '+'Please plan to attend',TRUE);
                                    */
                    /**
                        Astring := HRActivityApprovalEntry."Partipant Name";

                        WorkingString := ConvertStr(Astring, ' ', ',');
                        String1 := SelectStr(1, WorkingString);

                        SMTP.CreateMessage('Dear' + ' ' + String1, 'erp@ufaa.go.ke', HRActivityApprovalEntry."Participant Email",
                        'Procurement Committee', 'Dear' + ' ' + String1 + ' ' + "Email Message" + ' ' + 'Evaluation of '
                            + "RFQ Description" + ' ' + 'On' + '  ' + Format(Date) + '  ' +
                            Format(Time) + 'At ' + Venue + '. '
                            + 'Thank you', true);

                        SMTP.Send();
                        HRActivityApprovalEntry.Notified := true;
                        HRActivityApprovalEntry.Modify;
                    until HRActivityApprovalEntry.Next = 0;
                    Message('[%1] Evaluation Committee Members Have Been Notified About This Activity', HRActivityApprovalEntry.Count);
                    **/
                end;
            end;

            end;
        }
        field(25; "RFQ No."; Code[10])
        {
            TableRelation = "Purchase Quote Header"."No.";

            trigger OnValidate()
            begin
                PurchaseQuoteHeader.Reset;
                PurchaseQuoteHeader.SetRange(PurchaseQuoteHeader."No.", "RFQ No.");
                if PurchaseQuoteHeader.Find('-') then begin
                    "RFQ Description" := PurchaseQuoteHeader."Posting Description";
                    "User ID" := UserId;
                    "Date Created" := Today;
                end;
            end;
        }
        field(26; "User ID"; Code[60])
        {
        }
        field(27; "Date Created"; Date)
        {
        }
        field(28; Time; Time)
        {
        }
        field(29; "Last Modified By"; Code[60])
        {
        }
        field(30; "Last Modified On"; Date)
        {
        }
        field(31; "Last Modified At"; Time)
        {
        }
        field(32; "Memo No."; Code[20])
        {
        }
        field(33; "Memo Description"; Text[250])
        {
        }
        field(34; "Member Count"; Integer)
        {
            //CalcFormula = Count("Tender Committee Members" WHERE("Document No." = FIELD(Code)));
            //FieldClass = FlowField;
        }
        field(35; "Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Year Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name".Name;
        }
        field(37; Roles; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Member,Chaiperson,Secretary';
            OptionMembers = " ",Member,Chaiperson,Secretary;
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

        // IF Code = '' THEN BEGIN
        //  HRSetup.GET;
        //  HRSetup.TESTFIELD(HRSetup."Company Activities");
        //  NoSeriesMgt.InitSeries(HRSetup."Company Activities",xRec."No. Series",0D,Code,"No. Series");
        // END;

        if Code = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Evaluation Commitee");
            NoSeriesMgt.InitSeries(NoSetup."Evaluation Commitee", xRec."No. Series", 0D, Code, "No. Series");
        end;

        "Last Modified At" := Time;
        "Last Modified By" := UserId;
        "Last Modified On" := Today;
    end;

    trigger OnModify()
    begin
        "Last Modified At" := Time;
        "Last Modified By" := UserId;
        "Last Modified On" := Today;
    end;

    trigger OnRename()
    begin
        "Last Modified At" := Time;
        "Last Modified By" := UserId;
        "Last Modified On" := Today;
    end;

    var
        GLAccts: Record "G/L Account";
        Banks: Record "Bank Account";
        Text000: Label 'You have canceled the create process.';
        Text001: Label 'Replace existing attachment?';
        Text002: Label 'You have canceled the import process.';
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HREmp: Record "HR Employees";
        EmpName: Text;
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        NoSetup: Record "Purchases & Payables Setup";
        //HRActivityParticipants: Record "HR Activity Participants";
        //HRActivityApprovalEntry: Record "Tender Committee Members";
        SMTP: Codeunit "SMTP Mail";
}

