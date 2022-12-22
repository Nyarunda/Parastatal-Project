page 51533401 "Store Requisition Header"
{
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Cancellation,Category6_caption,Category7_caption,Category8_caption,Approval_Details,Category10_caption';
    SourceTable = "Store Requistion Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                }
                field("Request date"; Rec."Request date")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                    //Editable = statuseditable;
                }
                field("Function Name"; Rec."Function Name")
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                    //Editable = statuseditable;
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Caption = 'Request Description.';
                }
                field("Request Description"; Rec."Request Description")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Required Date"; Rec."Required Date")
                {
                    //Editable = statuseditable;
                }
                field("Issuing Store"; Rec."Issuing Store")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    //Editable = statuseditable;
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(RecID; Format(Rec.RecordId))
                {
                    Visible = false;
                }
            }
            part(Control1102755015; "Store Requisition Line")
            {
                Editable = true;
                SubPageLink = "Requistion No" = FIELD("No.");
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
                action("Post Store Requisition")
                {
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        ItemLedger: Record "Item Ledger Entry";
                    begin
                        if not LinesExists then
                            Error('There are no Lines created for this Document');

                        if Rec.Status = Rec.Status::Posted then
                            Error('The Document Has Already been Posted');

                        if Rec.Status <> Rec.Status::Released then
                            Error('The Document Has not yet been Approved');
                        if InventorySetup.Get then begin
                            InventorySetup.TestField(InventorySetup."Item Jnl Template");
                            InventorySetup.TestField(InventorySetup."Item Jnl Batch");
                            GenJnline.Reset;
                            GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Item Jnl Template");
                            GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Item Jnl Batch");
                            if GenJnline.Find('-') then GenJnline.DeleteAll;

                            //TESTFIELD("Issuing Store");
                            ReqLine.Reset;
                            ReqLine.SetRange(ReqLine."Requistion No", Rec."No.");
                            if ReqLine.Find('-') then begin
                                repeat
                                    //Issue

                                    LineNo := LineNo + 1000;
                                    GenJnline.Init;
                                    GenJnline."Journal Template Name" := InventorySetup."Item Jnl Template";
                                    GenJnline."Journal Batch Name" := InventorySetup."Item Jnl Batch";
                                    GenJnline."Line No." := LineNo;
                                    GenJnline."Entry Type" := GenJnline."Entry Type"::"Negative Adjmt.";
                                    GenJnline."Document No." := Rec."No.";
                                    GenJnline."Item No." := ReqLine."No.";
                                    GenJnline.Validate("Item No.");
                                    ReqLine.TestField("Issuing Store");
                                    GenJnline."Location Code" := ReqLine."Issuing Store";
                                    GenJnline."Bin Code" := ReqLine."Bin Code";
                                    GenJnline.Validate("Location Code");
                                    GenJnline."Posting Date" := Rec."Request date";
                                    GenJnline.Description := ReqLine.Description;
                                    ItemLedger.Reset;
                                    ItemLedger.SetRange(ItemLedger."Item No.", ReqLine."No.");
                                    ItemLedger.SetRange(ItemLedger."Location Code", ReqLine."Issuing Store");
                                    ItemLedger.CalcSums(Quantity);
                                    if ItemLedger.Quantity <= 0 then Error('Item %1 is out of stock in store %2', ReqLine.Description, ReqLine."Issuing Store");
                                    GenJnline.Quantity := ReqLine.Quantity;
                                    GenJnline."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
                                    GenJnline.Validate("Shortcut Dimension 1 Code");
                                    GenJnline."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
                                    GenJnline.Validate("Shortcut Dimension 2 Code");
                                    //GenJnline."Lot No.":=ReqLine."Lot No.";
                                    GenJnline."Dimension Set ID" := ReqLine."Dimension Set ID";
                                    GenJnline.Validate(Quantity);
                                    GenJnline.Validate("Unit Amount");
                                    GenJnline."Reason Code" := '221';
                                    //GenJnline.VALIDATE("Reason Code");
                                    GenJnline."Gen. Prod. Posting Group" := ReqLine."Gen. Prod. Posting Group";
                                    GenJnline."Gen. Bus. Posting Group" := ReqLine."Gen. Bus. Posting Group";
                                    GenJnline.Insert(true);

                                    //ReqLine."Request Status":=ReqLine."Request Status"::Closed;

                                    //Denno Added to take care of lot numbers-----------------
                                    //If Lot No field  Exist then insert reservation line
                                    ResEntry.Reset;
                                    ResEntry.SetRange(ResEntry."Entry No.");
                                    if ResEntry.Find('+') then LastResNo := ResEntry."Entry No.";

                                    LastResNo := LastResNo + 1;

                                    if ReqLine."Lot No." <> '' then begin
                                        ResEntry.Init;
                                        ResEntry."Entry No." := LastResNo;   //ResEntry."Entry No."
                                        ResEntry."Item No." := ReqLine."No.";
                                        ResEntry."Location Code" := ReqLine."Issuing Store";
                                        ResEntry."Quantity (Base)" := -ReqLine.Quantity;
                                        ResEntry.Validate("Quantity (Base)");
                                        ResEntry.Quantity := -ReqLine.Quantity;
                                        ResEntry."Qty. to Handle (Base)" := -ReqLine.Quantity;
                                        ResEntry.Validate("Qty. to Handle (Base)");
                                        ResEntry."Reservation Status" := ResEntry."Reservation Status"::Prospect;
                                        ResEntry."Creation Date" := Rec."Request date";
                                        ResEntry."Source Type" := 83;
                                        ResEntry."Source Subtype" := 3;
                                        ResEntry."Source ID" := 'ITEM';
                                        ResEntry."Source Batch Name" := 'DEFAULT';
                                        ResEntry."Source Ref. No." := LineNo;
                                        ResEntry."Lot No." := ReqLine."Lot No.";
                                        ResEntry."Item Tracking" := ResEntry."Item Tracking"::"Lot No.";
                                        ResEntry.Insert;

                                    end;
                                //End Denno Added to take care of lot numbers-----------------

                                until ReqLine.Next = 0;
                                //Post Entries
                                GenJnline.Reset;
                                GenJnline.SetRange(GenJnline."Journal Template Name", InventorySetup."Item Jnl Template");
                                GenJnline.SetRange(GenJnline."Journal Batch Name", InventorySetup."Item Jnl Batch");
                                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", GenJnline);
                                //End Post entries

                                // Modify All
                                Post := false;
                                Post := JournlPosted.PostedSuccessfully();
                                if Post then begin
                                    //ReqLine.MODIFYALL(ReqLine."Request Status",ReqLine."Request Status"::Closed);
                                    Rec.Status := Rec.Status::Posted;
                                    Rec.Modify;
                                end
                            end;
                        end;

                        Rec.Status := Rec.Status::Posted;
                        Rec.Modify;
                    end;
                }
                separator(Separator1102755035)
                {
                }
                action("Print/Preview")
                {
                    Caption = 'Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.Reset;
                        Rec.SetFilter("No.", Rec."No.");
                        REPORT.Run(39005887, true, true, Rec);
                        Rec.Reset;
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
                        if Confirm(Text000, true) then begin
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.Modify;
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
                        Rec.TestField("Item Description");
                        if not LinesExists then
                            Error('There are no Lines created for this Document');
                        if LinesCommitmentStatus then
                            Error('There are some lines that have not been committed');




                        VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    CustomApprovals.OnSendDocForApproval(VarVariant);

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
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
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
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId)
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = CONST(39005478),
                                  "Document No." = FIELD("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPageUpdate;
        SetControlAppearance;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if GuiAllowed then begin
            Rec.Reset;
            Rec.SetRange(Status, Rec.Status::Open);
            Rec.SetRange("User ID", UserId);
            if Rec.Find('-') then begin
                if Rec.Count > 0 then begin
                    Error('There are still some untilized store requisition Documents [ %1 ]. Please utilise them first'
                          , Rec."No.");
                end;
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //Add dimensions if set by default here
        //Rec."Global Dimension 1 Code" := UserMgt.GetSetDimensions(UserId, 1);
        Rec.Validate("Global Dimension 1 Code");
        //Rec."Shortcut Dimension 2 Code" := UserMgt.GetSetDimensions(UserId, 2);
        Rec.Validate("Shortcut Dimension 2 Code");
        //Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        //Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");

        UpdateControls;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        if (Rec.Status <> Rec.Status::Open) then
            CurrPage.Editable := false else
            CurrPage.Editable := true;

        if Rec.Status = Rec.Status::Open then begin
            PageActionsVisible := false;
        end else
            if Rec.Status <> Rec.Status::Open then begin
                PageActionsVisible := true;
            end;


        /*
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        */

    end;

    var
        UserMgt: Codeunit "User Setup Management";
        ReqLine: Record "Store Requistion Lines";
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit "Journal Post Successful";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,Loan,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","MSacco Applications","MSacco PinChange","MSacco PhoneChange","MSacco TransChange",BulkSMS,"Payment Voucher","Petty Cash",Imp,Requisition,ImpSurr,Interbank,Receipt,"Staff Claim","Staff Adv",AdvSurr,OT;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        ApprovalEntries: Page "Approval Entries";
        [InDataSet]

        StatusEditable: Boolean;
        [InDataSet]
        PageActionsVisible: Boolean;
        Text046: Label 'The %1 does not match the quantity defined in item tracking.';
        ResEntry: Record "Reservation Entry";
        LastResNo: Integer;
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        //CustomApprovals: Codeunit "Custom Approval Management";
        RespCenter: Record "Responsibility Center";

    procedure LinesExists(): Boolean
    var
        PayLines: Record "Store Requistion Lines";
    begin
        HasLines := false;
        PayLines.Reset;
        PayLines.SetRange(PayLines."Requistion No", Rec."No.");
        if PayLines.Find('-') then begin
            HasLines := true;
            if PayLines."Issuing Store" = '' then Error('Kindly insert the issuing store for item %1', PayLines."No.");
            exit(HasLines);
        end;
    end;

    procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Open then
            StatusEditable := true
        else
            StatusEditable := false;
    end;

    procedure CurrPageUpdate()
    begin
        //xRec:=Rec;
        UpdateControls;
        //CurrPage.UPDATE;
    end;

    local procedure CheckTrackingSpecification(var PurchLine: Record "Store Requistion Lines")
    var
        PurchLineToCheck: Record "Store Requistion Lines";
        ReservationEntry: Record "Reservation Entry";
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ItemTrackingManagement: Codeunit "Item Tracking Management";
        ErrorFieldCaption: Text[250];
        SignFactor: Integer;
        PurchLineQtyHandled: Decimal;
        PurchLineQtyToHandle: Decimal;
        TrackingQtyHandled: Decimal;
        TrackingQtyToHandle: Decimal;
        Inbound: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        SNInfoRequired: Boolean;
        LotInfoReguired: Boolean;
        CheckPurchLine: Boolean;
    begin
        // if a PurchaseLine is posted with ItemTracking then the whole quantity of
        // the regarding PurchaseLine has to be post with Item-Tracking

        TrackingQtyToHandle := 0;
        TrackingQtyHandled := 0;

        PurchLineToCheck.Copy(PurchLine);
        PurchLineToCheck.SetRange(Type, PurchLineToCheck.Type::Item);
        //IF PurchHeader.Receive THEN BEGIN ---- Denno
        //  PurchLineToCheck.SETFILTER("Quantity Received",'<>%1',0);
        //  ErrorFieldCaption := PurchLineToCheck.FIELDCAPTION("Qty. to Receive");
        //END ELSE BEGIN
        PurchLineToCheck.SetFilter(Quantity, '<>%1', 0);
        ErrorFieldCaption := PurchLineToCheck.FieldCaption(Quantity);
        //END;

        if PurchLineToCheck.FindSet then begin
            ReservationEntry."Source Type" := DATABASE::"Store Requistion Lines";
            ReservationEntry."Source Subtype" := 0;//PurchHeader."Document Type";
            SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
            repeat
                // Only Item where no SerialNo or LotNo is required
                Item.Get(PurchLineToCheck."No.");
                if Item."Item Tracking Code" <> '' then begin
                    Inbound := (PurchLineToCheck.Quantity * SignFactor) > 0;
                    ItemTrackingCode.Code := Item."Item Tracking Code";
                    /**ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
                      GenJnline."Entry Type"::"Negative Adjmt.",
                      Inbound,
                      SNRequired,
                      LotRequired,
                      SNInfoRequired,
                      LotInfoReguired); **/
                    CheckPurchLine := (SNRequired = false) and (LotRequired = false);
                    if CheckPurchLine then
                        CheckPurchLine := GetTrackingQuantities(PurchLineToCheck, 0, TrackingQtyToHandle, TrackingQtyHandled);
                end else
                    CheckPurchLine := false;

                TrackingQtyToHandle := 0;
                TrackingQtyHandled := 0;

                if CheckPurchLine then begin
                    GetTrackingQuantities(PurchLineToCheck, 1, TrackingQtyToHandle, TrackingQtyHandled);
                    TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
                    TrackingQtyHandled := TrackingQtyHandled * SignFactor;
                    /*      IF PurchHeader.Receive THEN BEGIN
                            PurchLineQtyToHandle := PurchLineToCheck."Qty. to Receive (Base)";
                            PurchLineQtyHandled := PurchLineToCheck."Qty. Received (Base)";
                          END ELSE */
                    begin
                        PurchLineQtyToHandle := PurchLineToCheck.Quantity;
                        PurchLineQtyHandled := PurchLineToCheck.Quantity;
                    end;
                    if ((TrackingQtyHandled + TrackingQtyToHandle) <> (PurchLineQtyHandled + PurchLineQtyToHandle)) or
                       (TrackingQtyToHandle <> PurchLineQtyToHandle)
                    then
                        Error(StrSubstNo(Text046, ErrorFieldCaption));
                end;
            until PurchLineToCheck.Next = 0;
        end;

    end;

    local procedure GetTrackingQuantities(PurchLine: Record "Store Requistion Lines"; FunctionType: Option CheckTrackingExists,GetQty; var TrackingQtyToHandle: Decimal; var TrackingQtyHandled: Decimal): Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
    begin
        with TrackingSpecification do begin
            SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
              "Source Prod. Order Line", "Source Ref. No.");
            SetRange("Source Type", DATABASE::"Store Requistion Lines");
            SetRange("Source Subtype", 0);
            SetRange("Source ID", PurchLine."Requistion No");
            SetRange("Source Batch Name", '');
            SetRange("Source Prod. Order Line", 0);
            SetRange("Source Ref. No.", PurchLine."Line No.");
        end;
        with ReservEntry do begin
            SetCurrentKey(
              "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
              "Source Batch Name", "Source Prod. Order Line");
            SetRange("Source ID", PurchLine."Requistion No");
            SetRange("Source Ref. No.", PurchLine."Line No.");
            SetRange("Source Type", DATABASE::"Store Requistion Lines");
            SetRange("Source Subtype", 0);
            SetRange("Source Batch Name", '');
            SetRange("Source Prod. Order Line", 0);
        end;

        case FunctionType of
            FunctionType::CheckTrackingExists:
                begin
                    TrackingSpecification.SetRange(Correction, false);
                    if not TrackingSpecification.IsEmpty then
                        exit(true);
                    ReservEntry.SetFilter("Serial No.", '<>%1', '');
                    if not ReservEntry.IsEmpty then
                        exit(true);
                    ReservEntry.SetRange("Serial No.");
                    ReservEntry.SetFilter("Lot No.", '<>%1', '');
                    if not ReservEntry.IsEmpty then
                        exit(true);
                end;
            FunctionType::GetQty:
                begin
                    TrackingSpecification.CalcSums("Quantity Handled (Base)");
                    TrackingQtyHandled := TrackingSpecification."Quantity Handled (Base)";
                    if ReservEntry.FindSet then
                        repeat
                            if (ReservEntry."Lot No." <> '') or (ReservEntry."Serial No." <> '') then
                                TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
                        until ReservEntry.Next = 0;
                end;
        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure AllFieldsEntered(): Boolean
    var
        PayLines: Record "Store Requistion Lines";
    begin
        AllKeyFieldsEntered := true;
        PayLines.Reset;
        PayLines.SetRange(PayLines."No.", Rec."No.");
        if PayLines.Find('-') then begin
            repeat
                if (PayLines."No." = '') or (PayLines."Quantity Requested" <= 0) then
                    AllKeyFieldsEntered := false;
            until PayLines.Next = 0;
            exit(AllKeyFieldsEntered);
        end;
    end;

    procedure LinesCommitmentStatus() Exists: Boolean
    var
        BCsetup: Record "Budgetary Control Setup";
        PayLine: Record "Store Requistion Lines";
    begin
        if BCsetup.Get() then begin
            if not BCsetup.Mandatory then begin
                Exists := false;
                exit;
            end;
        end else begin
            Exists := false;
            exit;
        end;
        Exists := false;
        PayLine.Reset;
        PayLine.SetRange(PayLine."No.", Rec."No.");
        PayLine.SetRange(PayLine.Committed, false);
        if PayLine.Find('-') then
            Exists := true;
    end;

    local procedure Testfi()
    begin
        ReqLine.Reset;
        ReqLine.SetRange("No.", ReqLine."Requistion No");
        if ReqLine.Find('-') then
            Error(ReqLine."Issuing Store");
    end;
}

