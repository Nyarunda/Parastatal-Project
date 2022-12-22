page 51533471 "Workplan Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Approvals';
    SourceTable = Workplan;
    SourceTableView = WHERE("Last Year" = FILTER(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Workplan Code"; Rec."Workplan Code")
                {
                }
                field("Workplan Description"; Rec."Workplan Description")
                {
                    Caption = 'Workplan Description';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Workplan Status"; Rec."Workplan Status")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Last Year"; Rec."Last Year")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        WPA.Reset;
                        WPA.SetRange(WPA."Workplan Code", Rec."Workplan Code");
                        WPA.SetFilter(WPA.Status, '=%1', WPA.Status::Approved);
                        if WPA.Find('-') then begin
                            WPA.TestField(WPA."Workplan Code", Rec."Workplan Code");
                            WPA.TestField(WPA.Quantity);
                            WPA.TestField(WPA."Unit of Cost");
                            WPA.TestField(WPA."Global Dimension 1 Code");
                            WPA.TestField(WPA."Global Dimesnsion 2 Code");
                        end;
                        VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //CustomApprovals.OnSendDocForApproval(VarVariant);

                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        /*
                        DocumentType := DocumentType::"Payment Voucher";
                        ApprovalEntries.Setfilters(DATABASE::"Payments Header","Document Type","No.");
                        ApprovalEntries.RUN;
                        */
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

                    end;
                }
                action("Workplan Activities")
                {
                    Caption = 'Workplan Activities';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page WorkplanActivities;
                    RunPageLink = "Workplan Code" = FIELD("Workplan Code");
                    RunPageMode = Edit;
                }
            }
        }
    }

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        VarVariant: Variant;
        //CustomApprovals: Codeunit "Custom Approval Management";
        WPA: Record "Workplan Activities";
}

