table 51533447 "Tender Committee Activities"
{
    LookupPageID = "Tender Committee List";

    fields
    {
        field(1; "Code"; Code[20])
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
                    NoSeriesMgt.TestManual(NoSetup."Tender Commitee");
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
            OptionMembers = New,"Pending Approval",Approved,Rejected,canceled;

            trigger OnValidate()
            begin

                if Status = Status::Approved then begin
                    CI.Get;
                    HRActivityApprovalEntry.Reset;
                    HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Code);
                    if HRActivityApprovalEntry.Find('-') then begin
                        repeat

                            Astring := HRActivityApprovalEntry."Partipant Name";

                            WorkingString := ConvertStr(Astring, ' ', ',');

                            String1 := SelectStr(1, WorkingString);
                            TextEmail := HRActivityApprovalEntry."Participant Email";
                            ListOfText.Add(TextEmail);

                            SMTP.CreateMessage('Dear' + ' ' + String1, 'erp@ufaa.go.ke', ListOfText,
                            'Procurement Committee', 'Dear' + ' ' + String1 + ' ' + "Email Message" + ' ' + 'Opening of '
                             + "RFQ Description" + ' ' + 'On' + '  ' + Format(Date) + '  ' +
                               Format(Time) + 'At ' + Venue + '. '
                               + 'Thank you', true);

                            SMTP.Send();
                            HRActivityApprovalEntry.Notified := true;
                            HRActivityApprovalEntry.Modify;
                        until HRActivityApprovalEntry.Next = 0;
                        Message('[%1] Procurement Committee Members Have Been Notified About This Activity', HRActivityApprovalEntry.Count)

                    end;
                end;
                //END;`
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
                    Date := PurchaseQuoteHeader."Expected Opening Date";
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
            CalcFormula = Count("Tender Committee Members" WHERE("Document No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(35; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Tender,Inspection,Disposal,Evaluation';
            OptionMembers = Tender,Inspection,Disposal,Evaluation;
        }
        field(36; "Bid No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Quotation Analysis Header"."No.";
        }
        field(37; Roles; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Member,Chaiperson,Secretary';
            OptionMembers = " ",Member,Chaiperson,Secretary;
        }
        field(38; "Portal Date"; Date)
        {
            DataClassification = ToBeClassified;
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
            NoSetup.TestField(NoSetup."Tender Commitee");
            NoSeriesMgt.InitSeries(NoSetup."Tender Commitee", xRec."No. Series", 0D, Code, "No. Series");
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
        ListOfText: List of [Text];
        TextEmail: Text[30];
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
        SMTP: Codeunit "SMTP Mail";
        HRActivityApprovalEntry: Record "Tender Committee Members";
        CI: Record "Company Information";
        Astring: Text;
        WorkingString: Text;
        String1: Text;
        String2: Text;
        String3: Text;
}

