table 51533922 "Inspection Committee Activity"
{
    LookupPageID = "Inspection Committee List";

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
                    NoSeriesMgt.TestManual(NoSetup."Inspection Commitee");
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

                    HRActivityApprovalEntry.Reset;
                    HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Code);
                    if HRActivityApprovalEntry.Find('-') then begin
                        repeat
                            // IF Status <> Status::Approved THEN
                            // ERROR('You Cannot notify a participant when the application is not approved');

                            /*SMTP.CreateMessage('Dear'+' '+HRActivityApprovalEntry."Partipant Name",HRActivityApprovalEntry."Participant Email",HRActivityApprovalEntry."Participant Email",
                               "RFQ Description","Email Message"+'. '+ 'On' + ' ' + FORMAT(Date) +'  '+FORMAT(Time)+'At'+Venue+'. '+HRActivityApprovalEntry."Email Message"+'. '+'Please plan to attend',TRUE);
                             */

                            Astring := HRActivityApprovalEntry."Partipant Name";

                            WorkingString := ConvertStr(Astring, ' ', ',');
                            String1 := SelectStr(1, WorkingString);
                            Textmail := HRActivityApprovalEntry."Participant Email";
                            TextList.Add(Textmail);

                            SMTP.CreateMessage('Dear' + ' ' + String1, 'erp@ufaa.go.ke', TextList,
                           'Procurement Committee', 'Dear' + ' ' + String1 + ' ' + "Email Message" + ' ' + 'Inspection of '
                            + "RFQ Description" + ' ' + 'On' + '  ' + Format(Date) + '  ' +
                              Format(Time) + 'At ' + Venue + '. '
                              + 'Thank you', true);

                            SMTP.Send();
                            HRActivityApprovalEntry.Notified := true;
                            HRActivityApprovalEntry.Modify;
                        until HRActivityApprovalEntry.Next = 0;
                        Message('[%1] Inspection Committee Members Have Been Notified About This Activity', HRActivityApprovalEntry.Count);



                    end;


                    SMTPSetup.Get;

                    CI.Get;


                    HRActivityApprovalEntry.Reset;
                    HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Code);
                    if HRActivityApprovalEntry.Find('-') then begin
                        repeat

                            if Exists(Filename) then
                                Erase(Filename);

                            if PayslipReportToPrint = 0 then
                                PayslipReportToPrint := 51533159;
                            Attachment := Format(PayslipReportToPrint);
                            Filename := HRActivityApprovalEntry.Participant + '_ ' + HRActivityApprovalEntry."Document No." + '_  Inspection.pdf';
                            REPORT.SaveAsPdf(PayslipReportToPrint, Filename, Rec);
                            SMTPMail.CreateMessage(CI.Name, SMTPSetup."User ID", TextList, 'Inspection', '', true);
                            SMTPMail.AppendBody('*******************************');
                            SMTPMail.AppendBody('<br><br>');
                            //SMTPMail.AppendBody('Dear '+ HR."First Name" +' '+ HR."Middle Name"+' ,');
                            SMTPMail.AppendBody('Hello, ');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Please find attached Inspection Memo for Document number ' + Rec.Code);// for the month of January 2014');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Thanks & Regards');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody(CI.Name);
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('<HR>');
                            //SMTPMail.AppendBody('blaaaaaaaaaaaaaaaaaaaaaaaaaaPlease find attached your payslip');
                            //SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('This is a system generated mail.');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('<br><br>');

                            SMTPMail.AddAttachment(Attachment, '_  Inspection.pdf');
                            SMTPMail.Send;

                            if Exists(Filename) then
                                Erase(Filename);

                        //MESSAGE('Passed through');

                        until HRActivityApprovalEntry.Next = 0
                    end;
                end;

            end;
        }
        field(25; "RFQ No."; Code[10])
        {
            TableRelation = "Purchase Header"."No." WHERE(Status = FILTER(Released),
                                                           "Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                // PurchaseQuoteHeader.RESET;
                // PurchaseQuoteHeader.SETRANGE(PurchaseQuoteHeader."No.","RFQ No.");
                // IF PurchaseQuoteHeader.FIND('-') THEN BEGIN
                // "RFQ Description":=PurchaseQuoteHeader."Posting Description";
                // "User ID":=USERID;
                // "Date Created":=TODAY;
                // END;

                PurchHeader.Reset;
                PurchHeader.SetRange(PurchHeader."No.", "RFQ No.");
                if PurchHeader.Find('-') then begin

                    "RFQ Description" := PurchHeader."Buy-from Vendor Name";
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
            CalcFormula = Count("Tender Committee Members" WHERE("Document No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(35; "LPO No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                           Status = FILTER(Released));
        }
        field(36; "Ref No"; Code[10])
        {
            DataClassification = ToBeClassified;
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
        key(Key1; "Code", "Ref No")
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
            NoSetup.TestField(NoSetup."Inspection Commitee");
            NoSeriesMgt.InitSeries(NoSetup."Inspection Commitee", xRec."No. Series", 0D, Code, "No. Series");
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
        TextList: List of [Text];
        Textmail: Text[30];
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
        PurchHeader: Record "Purchase Header";
        NoSetup: Record "Purchases & Payables Setup";
        SMTPMail: Codeunit "SMTP Mail";
        SMTPSetup: Record "SMTP Mail Setup";
        SMTP: Codeunit "SMTP Mail";
        HRActivityApprovalEntry: Record "Tender Committee Members";
        CI: Record "Company Information";
        Filename: Text;
        PayslipReportToPrint: Integer;
        Attachment: Text;
}

