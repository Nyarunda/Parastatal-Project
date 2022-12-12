page 51533919 "Tender Committe Activities"
{
    Caption = 'Opening Committee Activities';
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SaveValues = true;
    SourceTable = "Tender Committee Activities";

    layout
    {
        area(content)
        {
            group(Control1102755007)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    Enabled = false;
                    Importance = Promoted;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    Caption = 'Tender/RFQ No.';
                }
                field("RFQ Description"; Rec."RFQ Description")
                {
                    Caption = 'Tender/RFQ Description';
                    Enabled = false;
                    Importance = Promoted;
                }
                field(Date; Rec.Date)
                {
                    Caption = 'Opening Date';
                    Importance = Promoted;
                }
                field(Venue; Rec.Venue)
                {
                    Importance = Promoted;
                }
                field("Email Message"; Rec."Email Message")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Visible = true;
                }
                field(Closed; Rec.Closed)
                {
                }
                field("Activity Status"; Rec."Activity Status")
                {
                    Enabled = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Enabled = false;
                }
                field("Date Created"; Rec."Date Created")
                {
                    Enabled = false;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    Enabled = false;
                }
                field("Last Modified On"; Rec."Last Modified On")
                {
                    Enabled = false;
                }
            }
            part(Control1102755011; "Tender Activity Participants")
            {
                SubPageLink = "Document No." = FIELD(Code),
                              "RFQ No" = FIELD("RFQ No.");
            }
            part(Control13; "Bidders Present")
            {
                SubPageLink = "Document No" = FIELD(Code);
            }
        }
        area(factboxes)
        {
            part(Control1102755024; "Tender Activities Factbox")
            {
                SubPageLink = Code = FIELD(Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action("Get Participants")
                {
                    Enabled = false;
                    Image = SalesPurchaseTeam;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TestField(Closed, false);
                        //DELETE ANY PREVIOS RECORDS RELATED TO THIS ACTIVITY
                        HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Rec.Code);
                        if HRActivityApprovalEntry.Find('-') then
                            HRActivityApprovalEntry.DeleteAll;

                        //GET ONLY ACTIVE EMPLOYEES
                        InternalMemoLines.Reset;
                        InternalMemoLines.SetRange(InternalMemoLines."Document No.", Rec."Memo No.");
                        InternalMemoLines.FindFirst;
                        begin
                            HRActivityApprovalEntry.Reset;
                            repeat
                                HRActivityApprovalEntry.Init;
                                HRActivityApprovalEntry.Participant := InternalMemoLines."Employee No.";
                                HRActivityApprovalEntry."Document No." := Rec.Code;
                                HRActivityApprovalEntry.Validate(HRActivityApprovalEntry.Participant);
                                HRActivityApprovalEntry.Insert;
                            until InternalMemoLines.Next = 0;
                            Message('Completed Successfully');
                        end;
                    end;
                }
                action("Notify Participants ")
                {
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Astring: Text;
                        WorkingString: Text;
                        String1: Text;
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        CI.Get;
                        HRActivityApprovalEntry.Reset;
                        HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Rec.Code);
                        if HRActivityApprovalEntry.Find('-') then begin
                            repeat
                                // IF Status <> Status::Approved THEN
                                // ERROR('You Cannot notify a participant when the application is not approved');
                                /*
                                SMTP.CreateMessage('Dear'+' '+HRActivityApprovalEntry."Partipant Name",
                                HRActivityApprovalEntry."Participant Email",HRActivityApprovalEntry."Participant Email",
                                   "RFQ Description","Email Message"+'. '+ 'On' + ' ' + FORMAT(Date) +'  '+
                                   FORMAT(Time)+'At'+Venue+'. '+HRActivityApprovalEntry."Email Message"+
                                   '. '+'Please plan to attend',TRUE);
                                   Dear "First name"
                                Please plan to attend "evaluation/opening/inspection/disposal" of "posting description" on 14/09/22 14:30 At UFAA Boardroom. Thank you
                                */


                                Astring := HRActivityApprovalEntry."Partipant Name";

                                WorkingString := ConvertStr(Astring, ' ', ',');
                                String1 := SelectStr(1, WorkingString);

                                /* 
                                SMTP.CreateMessage('Dear'+' '+String1,'erp@ufaa.go.ke',HRActivityApprovalEntry."Participant Email",
                                'Procurement Committee','Dear'+' '+String1+','+'<br>'+"Email Message"+' '+'Opening of '
                                 + "RFQ Description"+' '+ 'On' + '  ' + Format(Date) +'  '+
                                   Format(Time)+'At ' +Venue+' '+'as'+ Format(HRActivityApprovalEntry.Roles)   +'Thank you',true);

                                 SMTP.Send(); 
                                 */
                                HRActivityApprovalEntry.Notified := true;
                                HRActivityApprovalEntry.Modify;
                            until HRActivityApprovalEntry.Next = 0;
                            Message('[%1] Procurement Committee Members Have Been Notified About This Activity', HRActivityApprovalEntry.Count)

                        end

                    end;
                }
                action(Close)
                {
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TestField(Closed, false);
                        Rec.Closed := true;
                        Rec."Activity Status" := Rec."Activity Status"::Complete;
                        Rec."Last Modified At" := Time;
                        Rec."Last Modified By" := UserId;
                        Rec."Last Modified On" := Today;
                        Rec.Modify;
                        Message('Tender Activity :: %1 :: Has Been Closed', Rec."RFQ Description");
                        //CurrPage.CLOSE;
                    end;
                }
                action(MarkAsOnGoing)
                {
                    Caption = 'Mark As OnGoing';
                    Image = Open;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Rec."Activity Status" <> Rec."Activity Status"::Planning then
                            Error(Text002, Rec.Code);
                        Rec.TestField(Closed, false);
                        Rec."Activity Status" := Rec."Activity Status"::"On going";
                        Rec."Last Modified At" := Time;
                        Rec."Last Modified By" := UserId;
                        Rec."Last Modified On" := Today;
                        Rec.Modify;
                        Message('Tender Activity :: %1 :: Is Currently On-Going', Rec."RFQ Description");
                        //CurrPage.CLOSE;
                    end;
                }
                action(Print)
                {
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        HRCompanyActivities.Reset;
                        HRCompanyActivities.SetRange(HRCompanyActivities.Code, Rec.Code);
                        if HRCompanyActivities.Find('-') then
                            REPORT.Run(39006017, true, false, HRCompanyActivities);
                    end;
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Visible = false;
                action(Action3)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        DocumentType: Integer;
                    begin
                        DocType := 0;
                        ApprovalEntries.SetRecordFilters(DATABASE::"Tender Committee Activities", DocType, Rec.Code);
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        Commitments: Record Committments;
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Status, Rec.Status::New);
                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action("Cancel Approval")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                        //ApprovalMgt.OnCancelProfOpApprovalRequest(Rec);
                        Rec.TestField(Status, Rec.Status::Approved);
                        USetup.Get(UserId);
                        if USetup."Can Cancel Document" = true then begin
                            Rec.Status := Rec.Status::canceled;
                            Rec.Modify;
                            DTime := Today;
                            CI.Get;
                            HRActivityApprovalEntry.Reset;
                            HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Rec.Code);
                            if HRActivityApprovalEntry.Find('-') then begin
                                repeat

                                /*
                                SMTP.CreateMessage(CI.Name,CI."E-Mail",HRActivityApprovalEntry."Participant Email",
                                'Procurement Committee','Dear'+' '+HRActivityApprovalEntry."Partipant Name"
                                 + 'Please note that Document '+HRActivityApprovalEntry."Document No."+' has been cancelled '+ 'On ' + Format(DTime)  +'  '
                                   ,true);
                                 SMTP.Send();
                                 */
                                //HRActivityApprovalEntry.Notified:=TRUE;
                                //HRActivityApprovalEntry.MODIFY;
                                until HRActivityApprovalEntry.Next = 0;
                                Message('[%1] Procurement Committee Members Have Been Notified About This Activity', HRActivityApprovalEntry.Count);
                            end;
                        end;
                    end;
                }
                action("Cancel Document")
                {
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to cancel this document?';
                        Text001: Label 'You have Selected not to cancle this document';
                    begin
                        USetup.Get(UserId);
                        if USetup."Can Cancel Document" = true then begin
                            //TESTFIELD("Cancellation Remarks");
                            Rec.TestField(Status, Rec.Status::Approved);
                            if Confirm(Text000, true) then begin

                                Rec.Status := Rec.Status::canceled;
                                Rec.Modify;
                            end else
                                Error(Text001);
                        end else begin
                            Error('You do not have the rights to cancel the document');
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
    end;

    trigger OnInit()
    begin
        // UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        UpdateControls;
    end;

    var
        D: Date;
        SMTP: Codeunit "SMTP Mail";
        CTEXTURL: Text[500];
        HREmp: Record "HR Employees";
        //ApprovalSetup: Record "HR Approvals Set Up";
        ApprovalsMgtNotification: Codeunit "Approvals Mgmt.";
        HRCompanyActivities: Record "Tender Committee Activities";
        HRActivityApprovalEntry: Record "Tender Committee Members";
        //DocType: Option Quote,"Order",Invoice,CMemo,BlankOrder,"Ret Order","None",PV,"Petty Cash",Imp,Requisition,ImpSurr,Interbank,Receipt,"Staff Claim","Staff Adv",AdvSurr,"Bank Slip",Grant,"Grant Surr","Emp Req","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer,Contract,Project,MR,Inves,PB,Prom,Ind,Conf,BSC,OT,Jobsucc,SuccDetails,Qualified,Disc,ChDetai,Separation,TNeed,Grievance,CompAct,TenderMember;
        DocType: Enum "Custome Document Types";
        Text001: Label 'All Participants have been notified via E-Mail';
        GenJournal: Record "Gen. Journal Line";
        LineNo: Integer;
        AppMgmt: Codeunit "Approvals Mgmt.";
        Text002: Label 'Tender Activity %1 Must Be At Planning Stage';
        VarVariant: Variant;
        ApprovalEntries: Page "Approval Entries";
        ApprovalComments: Page "Approval Comments";
        InternalMemoLines: Record "Internal Memo Lines";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CI: Record "Company Information";
        CustomApprovals: Codeunit "Custom Approval Management";
        DTime: Date;
        USetup: Record "User Setup";

    procedure UpdateControls()
    begin
        if Rec.Closed then begin
            CurrPage.Editable := false;
        end else begin
            CurrPage.Editable := true;
        end;
    end;

    procedure Notify_Participants()
    begin
        //TESTFIELD(Status,Status::Approved);
        CI.Get;
        HRActivityApprovalEntry.Reset;
        HRActivityApprovalEntry.SetRange(HRActivityApprovalEntry."Document No.", Rec.Code);
        if HRActivityApprovalEntry.Find('-') then begin
            repeat
                // IF Status <> Status::Approved THEN
                // ERROR('You Cannot notify a participant when the application is not approved');
                /*
                SMTP.CreateMessage('Dear'+' '+HRActivityApprovalEntry."Partipant Name",
                HRActivityApprovalEntry."Participant Email",HRActivityApprovalEntry."Participant Email",
                   "RFQ Description","Email Message"+'. '+ 'On' + ' ' + FORMAT(Date) +'  '+
                   FORMAT(Time)+'At'+Venue+'. '+HRActivityApprovalEntry."Email Message"+
                   '. '+'Please plan to attend',TRUE);
                */
                /*
                 SMTP.CreateMessage(CI.Name,CI."E-Mail",HRActivityApprovalEntry."Participant Email",
                 'Procurement Committee','Dear'+' '+HRActivityApprovalEntry."Partipant Name"
                  + "RFQ Description"+''+"Email Message"+'. '+ 'On' + ' ' + Format(Date) +'  '+
                    Format(Time)+'At'+Venue+'. '+HRActivityApprovalEntry."Email Message"+
                    '. '+'Please plan to attend',true);
                  SMTP.Send();
                  */
                HRActivityApprovalEntry.Notified := true;
                HRActivityApprovalEntry.Modify;

            until HRActivityApprovalEntry.Next = 0;
            Message('[%1] Procurement Committee Members Have Been Notified About This Activity', HRActivityApprovalEntry.Count);
        end;

    end;
}

