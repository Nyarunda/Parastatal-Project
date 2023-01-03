table 51533025 "HR Leave Application"
{
    //DrillDownPageID = "HR Leave Applications List";
    //LookupPageID = "HR Leave Applications List";

    fields
    {
        field(1; "Application Code"; Code[20])
        {

            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                if "Application Code" <> xRec."Application Code" then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Leave Application Nos.");
                    "No series" := '';
                end;
            end;
        }
        field(3; "Leave Type"; Code[30])
        {
            //TableRelation = "Payments-Users".No WHERE("Time Posted" = FIELD("Leave Family"));

            trigger OnValidate()
            begin
                // // HRLeaveTypes.RESET;
                // // HRLeaveTypes.SETRANGE(HRLeaveTypes.Code,"Leave Type");
                // // IF HRLeaveTypes.FIND('-') THEN BEGIN
                // //  IF HRLeaveTypes.Gender<>HRLeaveTypes.Gender::Both THEN BEGIN
                // //   HREmp.RESET;
                // //   HREmp.SETRANGE(HREmp."No.","Employee No");
                // //   HREmp.SETRANGE(HREmp.Gender,HRLeaveTypes.Gender);
                // //    IF NOT  HREmp.FIND('-') THEN BEGIN
                // //    ERROR('This leave type is restricted to the '+ FORMAT(HRLeaveTypes.Gender) +' gender');
                // //   END;
                // // END;
                // // END;
            end;
        }
        field(4; "Days Applied"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin

                TestField("Leave Type");

                //Calc. Ret/End Dates
                if ("Days Applied" <> 0) and ("Start Date" <> 0D) then begin
                    "Return Date" := DetermineLeaveReturnDate("Start Date", "Days Applied");
                    "End Date" := DeterminethisLeaveEndDate("Return Date");
                    Modify;
                end;
                //   IF "Days Applied">=15 THEN "Request Leave Allowance":=TRUE;
            end;
        }
        field(5; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Start Date" = 0D then begin
                    "Return Date" := 0D;
                    "End Date" := 0D;
                end else begin
                    if DetermineIfIsNonWorking("Start Date") = true then begin
                        Error('Start date must be a working day');
                    end;
                    Validate("Days Applied");
                end;
            end;
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
            Editable = true;
        }
        field(7; "Application Date"; Date)
        {
        }
        field(12; Status; Option)
        {
            Editable = true;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;

            trigger OnValidate()
            begin
                /*
                IF Status=Status::Approved THEN
                 BEGIN
                  intEntryNo:=0;
                
                  HRLeaveEntries.RESET;
                  HRLeaveEntries.SETRANGE(HRLeaveEntries."Entry No.");
                   IF HRLeaveEntries.FIND('-') THEN intEntryNo:=HRLeaveEntries."Entry No.";
                
                  intEntryNo:=intEntryNo+1;
                
                  HRLeaveEntries.INIT;
                  HRLeaveEntries."Entry No.":=intEntryNo;
                  HRLeaveEntries."Staff No.":="Employee No";
                  HRLeaveEntries."Staff Name":= Names;
                  HRLeaveEntries."Posting Date":=TODAY;
                  HRLeaveEntries."Leave Entry Type":=HRLeaveEntries."Leave Entry Type"::Negative;
                  HRLeaveEntries."Leave Approval Date":="Application Date";
                  HRLeaveEntries."Document No.":="Application Code";
                  HRLeaveEntries."External Document No.":="Employee No";
                  HRLeaveEntries."Job ID":="Job Tittle";
                  HRLeaveEntries."No. of days":="Days Applied";
                  HRLeaveEntries."Leave Start Date":="Start Date";
                  HRLeaveEntries."Leave Posting Description":='Leave';
                  HRLeaveEntries."Leave End Date":="End Date";
                  HRLeaveEntries."Leave Return Date":="Return Date";
                  HRLeaveEntries."User ID" :="User ID";
                  HRLeaveEntries."Leave Type":="Leave Type";
                  HRLeaveEntries.INSERT;
                END;
                */

            end;
        }
        field(15; "Applicant Comments"; Text[250])
        {
        }
        field(17; "No series"; Code[30])
        {
        }
        field(18; Gender; Option)
        {
            Editable = false;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(28; Selected; Boolean)
        {
        }
        field(31; "Current Balance"; Decimal)
        {
            FieldClass = Normal;
        }
        field(32; Posted; Boolean)
        {
        }
        field(33; "Posted By"; Text[250])
        {
        }
        field(34; "Date Posted"; Date)
        {
        }
        field(35; "Time Posted"; Time)
        {
        }
        field(36; Reimbursed; Boolean)
        {
        }
        field(37; "Days Reimbursed"; Decimal)
        {
        }
        field(3900; "End Date"; Date)
        {
            Editable = false;
        }
        field(3901; "Total Taken"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(3921; "E-mail Address"; Text[60])
        {
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(3924; "Entry No"; Integer)
        {
        }
        field(3929; "Start Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(3936; "Cell Phone Number"; Text[50])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(3937; "Request Leave Allowance"; Boolean)
        {
        }
        field(3939; Picture; BLOB)
        {
        }
        field(3940; Names; Text[100])
        {
        }
        field(3942; "Leave Allowance Entittlement"; Boolean)
        {
        }
        field(3943; "Leave Allowance Amount"; Decimal)
        {
        }
        field(3945; "Details of Examination"; Text[200])
        {
        }
        field(3947; "Date of Exam"; Date)
        {
        }
        field(3949; Reliever; Code[50])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if Reliever = "Employee No" then
                    Error('Employee cannot relieve him/herself');

                if HREmp.Get(Reliever) then begin
                    "Reliever Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end else begin
                    "Reliever Name" := '';
                end;
            end;
        }
        field(3950; "Reliever Name"; Text[100])
        {
        }
        field(3952; Description; Text[30])
        {
        }
        field(3955; "Supervisor Email"; Text[50])
        {
        }
        field(3956; "Number of Previous Attempts"; Text[200])
        {
        }
        field(3958; "Job Tittle"; Text[50])
        {
        }
        field(3959; "User ID"; Code[50])
        {
        }
        field(3961; "Employee No"; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(3962; Supervisor; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(3969; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(3970; "Approved days"; Integer)
        {

            trigger OnValidate()
            begin
                if "Approved days" > "Days Applied" then
                    Error(TEXT001);
            end;
        }
        field(3971; Attachments; Integer)
        {
            Editable = false;
        }
        field(3972; Emergency; Boolean)
        {
            Description = 'This is used to ensure one can apply annual leave which is emergency';
        }
        field(3973; "Approver Comments"; Text[200])
        {
        }
        field(3974; "Leave Family"; Code[20])
        {
            //TableRelation = "HR Leave Family Groups".Code;
        }
        field(3975; RecID; RecordID)
        {
            DataClassification = ToBeClassified;
        }
        field(3976; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            Description = 'Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(3977; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            Description = 'Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
    }

    keys
    {
        key(Key1; "Application Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Application Code", Names)
        {
        }
    }

    trigger OnDelete()
    begin
        Error('Please edit document instead of deleting');
    end;

    trigger OnInsert()
    begin
        //No. Series
        if "Application Code" = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Leave Application Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Leave Application Nos.", xRec."No series", 0D, "Application Code", "No series");
        end;

        HREmp.Reset;
        HREmp.SetRange(HREmp."User ID", UserId);
        if HREmp.Find('-') then begin
            HREmp.TestField(HREmp."Date Of Join");

            Calendar.Reset;
            Calendar.SetRange("Period Type", Calendar."Period Type"::Month);
            Calendar.SetRange("Period Start", HREmp."Date Of Join", Today);
            empMonths := Calendar.Count;
            /*
                //Minimum duration in months for Leave Applications
                IF HRSetup.GET THEN
                BEGIN
                    HRSetup.TESTFIELD(HRSetup."Min. Leave App. Months");
                    IF empMonths < HRSetup."Min. Leave App. Months" THEN ERROR(Text002,HRSetup."Min. Leave App. Months");
                END;
             */
            //Populate fields
            "Employee No" := HREmp."No.";
            Names := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            Gender := HREmp.Gender;
            "Application Date" := Today;
            "User ID" := UserId;
            "Job Tittle" := HREmp."Job Title";
            //"Dimension 1 Code" := HREmp."Dimension 1 Code";
            //"Dimension 2 Code" := HREmp."Dimension 2 Code";
            HREmp.CalcFields(HREmp.Picture);
            Picture := HREmp.Picture;
            //"Responsibility Center":=HREmp."Responsibility Center";
            //Approver details
            GetApplicantSupervisor(UserId);
            //"Leave Family" := HREmp."Leave Family";

        end else begin
            Error('UserID' + ' ' + '[' + UserId + ']' + ' has not been assigned to any employee. Please consult the HR officer for assistance')
        end;

    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HREmp: Record "HR Employees";
        varDaysApplied: Integer;
        HRLeaveTypes: Record "Payments-Users";
        BaseCalendarChange: Record "Base Calendar Change";
        ReturnDateLoop: Boolean;
        mSubject: Text[250];
        ApplicantsEmail: Text[30];
        //SMTP: Codeunit "SMTP Mail";
        HRJournalLine: Record "HR Leave Journal Line";
        "LineNo.": Integer;
        ApprovalComments: Record "Approval Comment Line";
        URL: Text[500];
        sDate: Record Date;
        //Customized: Record "HR Calendar List";
        //HREmailParameters: Record "HR E-Mail Parameters";
        HRLeavePeriods: Record "HR Leave Periods";
        HRJournalBatch: Record "HR Leave Journal Batch";
        TEXT001: Label 'Days Approved cannot be more than applied days';
        HRLeaveEntries: Record "HR Leave Ledger Entries";
        intEntryNo: Integer;
        Calendar: Record Date;
        empMonths: Integer;
        HRLeaveApp: Record "HR Leave Application";
        mWeekDay: Integer;
        empGender: Option Female;
        mMinDays: Integer;
        Text002: Label 'You cannot apply for leave until your are over [%1] months old in the company';
        Text003: Label 'UserID [%1] does not exist in [%2]';

    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal) fReturnDate: Date
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
            if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate) then
                    varDaysApplied := varDaysApplied + 1
                else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied - 1
            end
            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;

    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[10]): Boolean
    begin
        if HRLeaveTypes.Get(fLeaveCode) then begin
            //if HRLeaveTypes."Account No." = true then
            exit(true);
        end;
    end;

    procedure DetermineIfIsNonWorking(var bcDate: Date) Isnonworking: Boolean
    begin
        /**
        Customized.Reset;
        Customized.SetRange(Customized.Date, bcDate);
        if Customized.Find('-') then begin
            if Customized."Non Working" = true then
                exit(true)
            else
                exit(false);
        end;
        **/
    end;

    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    begin
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
            fEndDate := CalcDate('-1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate) then
                    fEndDate := CalcDate('-1D', fEndDate)
                else
                    ReturnDateLoop := false;
            end
        end;
        exit(fEndDate);
    end;

    procedure CreateLeaveLedgerEntries()
    begin

        //GET OPEN LEAVE PERIOD
        HRLeavePeriods.Reset;
        HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
        HRLeavePeriods.Find('-');

        HRJournalBatch.Reset;
        HRSetup.Get;
        HRSetup.TestField(HRSetup."Default Leave Posting Template");
        HRSetup.TestField(HRSetup."Negative Leave Posting Batch");

        HRJournalBatch.Get(HRSetup."Default Leave Posting Template", HRSetup."Negative Leave Posting Batch");

        //POPULATE JOURNAL LINES
        HRJournalLine.Reset;
        HRJournalLine.SetRange(HRJournalLine."Journal Template Name", HRSetup."Default Leave Posting Template");
        HRJournalLine.SetRange(HRJournalLine."Journal Batch Name", HRSetup."Negative Leave Posting Batch");
        if not HRJournalLine.Find('-') then
            HRJournalLine."Line No." := 1000
        else
            HRJournalLine.DeleteAll;
        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

        "LineNo." := HRJournalLine."Line No.";

        HRJournalLine.Init;
        HRJournalLine."Journal Template Name" := HRSetup."Default Leave Posting Template";
        HRJournalLine."Journal Batch Name" := HRSetup."Negative Leave Posting Batch";
        HRJournalLine."Line No." := "LineNo.";
        HRJournalLine."Leave Period" := HRLeavePeriods."Period Code";
        HRJournalLine."Document No." := "Application Code";
        HRJournalLine."Staff No." := "Employee No";
        HRJournalLine.Validate(HRJournalLine."Staff No.");
        HRJournalLine."Posting Date" := Today;
        HRJournalLine."Leave Entry Type" := HRJournalLine."Leave Entry Type"::Negative;
        HRJournalLine."Leave Approval Date" := Today;
        HRJournalLine.Description := 'Leave Taken' + "Application Code";
        HRJournalLine."Leave Type" := "Leave Type";
        HRJournalLine.Validate("Leave Type");
        //HRJournalLine."Leave Period Start Date":=HRLeavePeriods."Start Date";
        //HRJournalLine."Leave Period End Date":=HRLeavePeriods."End Date";
        HRJournalLine."No. of Days" := -"Days Applied";

        HRJournalLine.Insert(true);
        if GuiAllowed then begin
            //Post Journal
            HRJournalLine.Reset;
            HRJournalLine.SetRange("Journal Template Name", HRSetup."Default Leave Posting Template");
            HRJournalLine.SetRange("Journal Batch Name", HRSetup."Negative Leave Posting Batch");
            if HRJournalLine.Find('-') then begin
                //CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post", HRJournalLine);
                //Notify Leave Applicant
                /*
                NotifyApplicant;
                */
            end;
            //Mark document as posted
            Posted := true;
            "Posted By" := UserId;
            "Date Posted" := Today;
            "Time Posted" := Time;
        end;

    end;

    procedure NotifyApplicant()
    begin
        HREmp.Get("Employee No");
        HREmp.TestField(HREmp."Company E-Mail");
        /**
        HREmailParameters.Reset;
        HREmailParameters.Get(HREmailParameters."Associate With"::"Leave Notifications");
        SMTP.CreateMessage(HREmailParameters."Sender Name", HREmailParameters."Sender Address", HREmp."Company E-Mail",
        HREmailParameters.Subject, 'Dear' + ' ' + HREmp."First Name" + ' ' +
        HREmailParameters.Body + ' ' + "Application Code" + ' ' + HREmailParameters."Body 2", true);
        SMTP.Send();
        **/
        //MESSAGE('Leave applicant has been notified successfully');
    end;

    local procedure GetApplicantSupervisor(EmpUserID: Code[50]) SupervisorID: Code[10]
    var
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        HREmp2: Record "HR Employees";
    begin
        SupervisorID := '';

        UserSetup.Reset;
        if UserSetup.Get(EmpUserID) then begin
            UserSetup.TestField(UserSetup."Approver ID");

            //Get supervisor e-mail
            UserSetup2.Reset;
            if UserSetup2.Get(UserSetup."Approver ID") then begin
                UserSetup2.TestField(UserSetup2."E-Mail");
                Supervisor := UserSetup."Approver ID";
                "Supervisor Email" := UserSetup2."E-Mail";
            end;

        end else begin
            Error(Text003, EmpUserID, UserSetup.TableCaption);
        end;
    end;

    procedure PostLeave()
    var
        EntyryX: Integer;
    begin
        // //  intEntryNo:=0;
        // //
        // //  HRLeaveEntries.RESET;
        // //  HRLeaveEntries.SETRANGE(HRLeaveEntries."Entry No.");
        // //   IF HRLeaveEntries.FIND('-') THEN intEntryNo:=HRLeaveEntries."Entry No.";
        // //
        // //  intEntryNo:=intEntryNo+1;

        HRLeaveEntries.Init;
        //HRLeaveEntries."Entry No.":=EntyryX;
        HRLeaveEntries."Staff No." := "Employee No";
        HRLeaveEntries."Staff Name" := Names;
        HRLeaveEntries."Posting Date" := Today;
        HRLeaveEntries."Leave Entry Type" := HRLeaveEntries."Leave Entry Type"::Negative;
        HRLeaveEntries."Leave Approval Date" := "Application Date";
        HRLeaveEntries."Document No." := "Application Code";
        HRLeaveEntries."External Document No." := "Employee No";
        HRLeaveEntries."No. of days" := -"Days Applied";
        HRLeaveEntries."Leave Start Date" := "Start Date";
        HRLeaveEntries."Leave Posting Description" := 'Leave';
        HRLeaveEntries."Leave End Date" := "End Date";
        HRLeaveEntries."Leave Return Date" := "Return Date";
        HRLeaveEntries."User ID" := "User ID";
        HRLeaveEntries."Leave Type" := "Leave Type";
        HRLeaveEntries.Insert;
        Status := Status::Approved;
        Message('Leave Posted');
        Modify;
    end;

    [Scope('Cloud')]
    procedure DetermineLeaveReturnDate_Portal(var fBeginDate: Date; var fDays: Decimal; var LeaveType: Code[30]) fReturnDate: Date
    begin
        varDaysApplied := fDays;
        fReturnDate := fBeginDate;
        repeat
            if DetermineIfIncludesNonWorking(LeaveType) = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate) then
                    varDaysApplied := varDaysApplied + 1
                else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied - 1
            end
            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;
}

