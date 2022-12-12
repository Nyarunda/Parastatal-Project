page 51533914 "Procurement Plan List"
{
    CardPageID = "Procurement Plan Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "Procurement Plan";
    SourceTableView = WHERE("Last Year" = FILTER(false),
                            Blocked = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                ShowCaption = false;
                field("Workplan Code"; Rec."Workplan Code")
                {
                }
                field("Workplan Description"; Rec."Workplan Description")
                {
                    Caption = 'Workplan Description';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000002; Outlook)
            {
            }
            systempart(Control1000000000; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
                action(EditBudget)
                {
                    Caption = 'Procurement plan Budget';
                    Image = Bank;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        Budget: Page "Budget Workplan";
                        WPCode: Code[20];
                    begin
                        Budget.SetBudgetName(Rec."Workplan Code");
                        Budget.Run;
                    end;
                }
                action("Procurement plan Activities")
                {
                    Caption = 'Procurement plan Activities';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Procurement Plan";
                    RunPageLink = "Workplan Code" = FIELD("Workplan Code");
                    RunPageMode = Edit;
                }
                action(Print)
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        /*
                        RESET;
                        SETFILTER("Workplan Code","Workplan Code");
                        REPORT.RUN(REPORT::"W/P Report",TRUE,TRUE,Rec);
                        RESET;
                         */

                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        /*
                        DocumentType:=DocumentType::"Staff Claim";
                        ApprovalEntries.Setfilters(DATABASE::"Staff Claims Header",DocumentType,"No.");
                        ApprovalEntries.RUN;
                        */

                    end;
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if (Rec.Status <> Rec.Status::Pending) then begin
                            Error('Document must be Pending');
                        end;

                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        VarVariant := Rec;
                        /*
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);
                        */
                    end;
                }
                action("Cancel Approval Re&quest")
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
                        VarVariant := Rec;
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if Confirm('Are you sure to cancel this Procurement Plan?', true) then begin
                            //Post Reversal Entries for Commitments
                            PurchaseLine.Reset;
                            PurchaseLine.SetRange(PurchaseLine."Workplan Code", Rec."Workplan Code");
                            if PurchaseLine.FindFirst then begin
                                repeat
                                    Commitments.Reset;
                                    Commitments.SetRange(Commitments."Document Type", Commitments."Document Type"::Requisition);
                                    Commitments.SetRange(Commitments."Document No.", PurchaseLine."Document No.");
                                    Commitments.DeleteAll;
                                until PurchaseLine.Next = 0;
                            end;

                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
                        end else
                            Error('You have chosen not to cancel document');
                    end;
                }
            }
        }
    }

    var
        VarVariant: Variant;
        //CustomApprovals: Codeunit "Custom Approvals Codeunit2";
        PurchaseLine: Record "Purchase Line";
        Commitments: Record Committments;

    local procedure LinesExists(): Boolean
    var
        ProcurementPlanActivities: Record "Procurement Plan Activities";
    begin
        ProcurementPlanActivities.SetRange("Workplan Code", Rec."Workplan Code");
        if ProcurementPlanActivities.FindSet then
            exit(true)
        else
            Error('Procurement plan activities do not exist');
    end;
}

