page 51533441 "Store Requisitions List"
{
    CardPageID = "Store Requisition Header";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    SourceTable = "Store Requistion Header";
    SourceTableView = WHERE(Status=FILTER(Open|"Pending Approval"|Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Request date";"Request date")
                {
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                }
                field("Function Name";"Function Name")
                {
                    Caption = 'Branch Name';
                }
                field("Request Description";"Request Description")
                {
                }
                field("Requester ID";"Requester ID")
                {
                }
                field(TotalAmount;TotalAmount)
                {
                }
                field(Status;Status)
                {
                }
                field("Issuing Store";"Issuing Store")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755010;Notes)
            {
            }
            systempart(Control1102755011;MyNotes)
            {
            }
            systempart(Control1102755012;Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102755026>")
            {
                Caption = '&Functions';
                action("<Action1102755028>")
                {
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if not LinesExists then
                           Error('There are no Lines created for this Document');

                           if Status=Status::Posted then
                              Error('The Document Has Already been Posted');

                           if Status<>Status::Released    then
                              Error('The Document Has not yet been Approved');


                            TestField("Issuing Store");
                            ReqLine.Reset;
                            ReqLine.SetRange(ReqLine."Requistion No","No.");
                            TestField("Issuing Store");
                            if ReqLine.Find('-') then begin
                            repeat
                            //Issue
                              if InventorySetup.Get then begin
                                     InventorySetup.TestField(InventorySetup."Item Jnl Template");
                                     InventorySetup.TestField(InventorySetup."Item Jnl Batch");
                                     GenJnline.Reset;
                                     GenJnline.SetRange(GenJnline."Journal Template Name",InventorySetup."Item Jnl Template");
                                     GenJnline.SetRange(GenJnline."Journal Batch Name",InventorySetup."Item Jnl Batch");
                                     if GenJnline.Find('-') then GenJnline.DeleteAll;
                                     LineNo:=LineNo+1000;
                                     GenJnline.Init;
                                     GenJnline."Journal Template Name":=InventorySetup."Item Jnl Template";
                                     GenJnline."Journal Batch Name":=InventorySetup."Item Jnl Batch";
                                     GenJnline."Line No.":=LineNo;
                                     GenJnline."Entry Type":=GenJnline."Entry Type"::"Negative Adjmt.";
                                     GenJnline."Document No.":="No.";
                                     GenJnline."Item No.":=ReqLine."No.";
                                     GenJnline.Validate("Item No.");
                                     GenJnline."Location Code":="Issuing Store";
                                     GenJnline.Validate("Location Code");
                                     GenJnline."Posting Date":="Request date";
                                     GenJnline.Description:=ReqLine.Description;
                                     GenJnline.Quantity:=ReqLine.Quantity;
                                     GenJnline."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                                     GenJnline.Validate("Shortcut Dimension 1 Code");
                                     GenJnline."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                                     GenJnline.Validate("Shortcut Dimension 2 Code");
                                     GenJnline.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                     GenJnline.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                     GenJnline.Validate(Quantity);
                                     GenJnline.Validate("Unit Amount");
                                     GenJnline."Reason Code":='221';
                                     GenJnline.Validate("Reason Code");
                                     GenJnline.Insert(true);

                                     ReqLine."Request Status":=ReqLine."Request Status"::Closed;

                                  end;
                           until ReqLine. Next=0;
                                    //Post Entries
                                    GenJnline.Reset;
                                    GenJnline.SetRange(GenJnline."Journal Template Name",InventorySetup."Item Jnl Template");
                                    GenJnline.SetRange(GenJnline."Journal Batch Name",InventorySetup."Item Jnl Batch");
                                    CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post",GenJnline);
                                    //End Post entries

                                  //Modify All
                                  Post:=false;
                                  Post:=JournlPosted.PostedSuccessfully();
                                  if Post then
                                        ReqLine.ModifyAll(ReqLine."Request Status",ReqLine."Request Status"::Closed);
                           end;
                    end;
                }
                separator(Separator1102755014)
                {
                }
                action("<Action1102755036>")
                {
                    Caption = 'Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        REPORT.Run(39005887,true,true,Rec);
                        Reset;
                    end;
                }
                action("Cancel Document")
                {
                    Caption = 'Cancel Document';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text000: Label 'Are you sure you want to cancel this document?';
                        Text001: Label 'You have Selected not to cancle this document';
                    begin
                        //TESTFIELD(Status,Status::Approved);
                        if Confirm(Text000,true) then  begin
                        //Post Reversal Entries for Commitments
                        //Doc_Type:=Doc_Type::PettyCash;
                        //CheckBudgetAvail.ReverseEntries(Doc_Type,"No.");
                        Status:=Status::Cancelled;
                        Modify;
                        end else
                          Error(Text001);
                    end;
                }
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
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if not LinesExists then
                           Error('There are no Lines created for this Document');

                        if not AllFieldsEntered then
                           Error('Some of the Key Fields on the Lines:[ACCOUNT NO.,AMOUNT] Have not been Entered please RECHECK your entries');

                        //Ensure No Items That should be committed that are not
                        if LinesCommitmentStatus then
                          Error('There are some lines that have not been committed');

                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                          CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category9;

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
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;
        /*
        IF UserMgt.GetSetDimensions(USERID,2) <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Shortcut Dimension 2 Code",UserMgt.GetSetDimensions(USERID,2));
          FILTERGROUP(0);
        END;
        */
        SetFilter("User ID",UserId);

    end;

    var
        UserMgt: Codeunit "User Setup Management BR";
        ReqLine: Record "Store Requistion Lines";
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approval Management";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Store Requistion Lines";
    begin
         HasLines:=false;
         PayLines.Reset;
         PayLines.SetRange(PayLines."Requistion No","No.");
          if PayLines.Find('-') then begin
             HasLines:=true;
             exit(HasLines);
          end;
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Store Requistion Lines";
    begin
        AllKeyFieldsEntered:=true;
         PayLines.Reset;
         PayLines.SetRange(PayLines."No.","No.");
          if PayLines.Find('-') then begin
          repeat
             if (PayLines."No."='') or (PayLines."Quantity Requested"<=0) then
             AllKeyFieldsEntered:=false;
          until PayLines.Next=0;
             exit(AllKeyFieldsEntered);
          end;
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
        PayLine: Record "Store Requistion Lines";
    begin
         if BCsetup.Get() then  begin
            if not BCsetup.Mandatory then begin
               Exists:=false;
               exit;
            end;
         end else begin
               Exists:=false;
               exit;
         end;
           Exists:=false;
          PayLine.Reset;
          PayLine.SetRange(PayLine."No.","No.");
          PayLine.SetRange(PayLine.Committed,false);
           if PayLine.Find('-') then
              Exists:=true;
    end;
}

