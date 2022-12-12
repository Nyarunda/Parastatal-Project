page 51533472 "Workplan Activities"
{
    Caption = 'Departmental Procurement Plan Activities';
    Editable = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approvals';
    SourceTable = "Workplan Activities";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = statuseditable;
                IndentationColumn = NameIndent;
                IndentationControls = "Activity Code","Activity Description";
                ShowAsTree = false;
                field("Workplan Code";Rec."Workplan Code")
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Activity Code";Rec."Activity Code")
                {
                    Caption = 'Activity Code';
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Source Of Funds";Rec."Source Of Funds")
                {
                }
                field("Entry Type";Rec."Entry Type")
                {
                }
                field(Budget;Rec.Budget)
                {
                    TableRelation = "G/L Budget Name";
                }
                field("Account Type";Rec."Account Type")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;

                    trigger OnValidate()
                    begin
                        UpdateControls;
                    end;
                }
                field(Type;Rec.Type)
                {
                    Caption = 'Type';
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("No.";Rec."No.")
                {
                }
                field(Description;Rec.Description)
                {
                }
                field("Activity Description";Rec."Activity Description")
                {
                }
                field("Global Dimension 1 Code";Rec."Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                }
                field("Shortcut Dimension 2 Code";Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                }
                field(Period;Rec.Period)
                {
                }
                field("Proc. Method No.";Rec."Proc. Method No.")
                {
                }
                field(Quantity;Rec.Quantity)
                {
                }
                field("Unit of Cost";Rec."Unit of Cost")
                {
                    Caption = ' Cost Per Unit';
                }
                field("Amount to Transfer";Rec."Amount to Transfer")
                {

                    trigger OnValidate()
                    begin
                        Rec."Amount to Transfer" := Rec.Quantity * Rec."Unit of Cost";
                    end;
                }
                field("Date to Transfer";Rec."Date to Transfer")
                {
                }
                field("Procurement Category";Rec."Procurement Category")
                {
                    Caption = 'Category';
                }
                field("Budgeted Amount";Rec."Budgeted Amount")
                {
                    Editable = false;
                }
                field("Uploaded to Procurement Workpl";Rec."Uploaded to Procurement Workpl")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Document Date";Rec."Document Date")
                {
                }
                field("Converted to Budget";Rec."Converted to Budget")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Status;Rec.Status)
                {
                    Editable = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control2;Outlook)
            {
            }
            systempart(Control1;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Visible = false;
                action(IndentWorkPlan)
                {
                    Caption = 'Indent Workplan Activities';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunObject = Codeunit Codeunit39005493;
                }
                action("Import Procurement Plan ")
                {
                    Caption = 'Import Procurement Plan';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ImportProcurementPlan('');
                        //XMLPORT.run(39003901);
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin


                        //IF LinesCommitted THEN
                           //ERROR('All Lines should be committed');
                          Rec.Reset;
                          Rec.SetRange("No.",Rec."No.");
                          REPORT.Run(51533313,true,true,Rec);
                          Rec.Reset;
                        //DocPrint.PrintPurchHeader(Rec);
                    end;
                }
            }
            group("Actions")
            {
                Caption = 'Actions';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField("Procurement Category");
                        VarVariant := Rec;
                        //IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                         // CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

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
                    PromotedCategory = Category4;

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
                action("Re-Open Work Plan Activites")
                {
                    Caption = 'Re-Open Work Plan Activites';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        EditWorkPlanErr: Label 'You have no permission to Edit Workplan Activities. Kindly contact your system Administrator';
                        EditWorkPlanMessage: Label 'Workplan has been Reopen Successfully';
                    begin
                        //only the one with rights can edit workplan activites
                        UserSetup.Reset;
                        UserSetup.SetRange(UserSetup."User ID",UserId);
                        if UserSetup.Find('-')then begin
                        if UserSetup."Edit Work Plan Activites"=false then begin
                          Error(EditWorkPlanErr);
                          end else
                          Rec.Status:= Rec.Status::Pending;
                          Rec.Modify;
                          Message(EditWorkPlanMessage);
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

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        Text0001: Label 'Convert to Workplan Activity [ %1-%2 ]to a Workplan Budget Entry?';
        Text0002: Label 'Workplan Budget Entry created for Workplan Activity [ %1-%2 ]';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Approvals Mgmt.";
        [InDataSet]
        StatusEditable: Boolean;
        UserSetup: Record "User Setup";

    procedure SetSelection(var GLAcc: Record "Workplan Activities")
    begin
        CurrPage.SetSelectionFilter(GLAcc);
    end;

    procedure GetSelectionFilter(): Code[80]
    var
        GLAcc: Record "Workplan Activities";
        FirstAcc: Text[20];
        LastAcc: Text[20];
        SelectionFilter: Code[80];
        GLAccCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(GLAcc);
        GLAcc.SetCurrentKey("Activity Code");
        GLAccCount := GLAcc.Count;
        if GLAccCount > 0 then begin
          GLAcc.Find('-');
          while GLAccCount > 0 do begin
            GLAccCount := GLAccCount - 1;
            GLAcc.MarkedOnly(false);
            FirstAcc := GLAcc."Activity Code";
            LastAcc := FirstAcc;
            More := (GLAccCount > 0);
            while More do
              if GLAcc.Next = 0 then
                More := false
              else
                if not GLAcc.Mark then
                  More := false
                else begin
                  LastAcc := GLAcc."Activity Code";
                  GLAccCount := GLAccCount - 1;
                  if GLAccCount = 0 then
                    More := false;
                end;
            if SelectionFilter <> '' then
              SelectionFilter := SelectionFilter + '|';
            if FirstAcc = LastAcc then
              SelectionFilter := SelectionFilter + FirstAcc
            else
              SelectionFilter := SelectionFilter + FirstAcc + '..' + LastAcc;
            if GLAccCount > 0 then begin
              GLAcc.MarkedOnly(true);
              GLAcc.Next;
            end;
          end;
        end;
        exit(SelectionFilter);
    end;

    procedure UpdateControls()
    begin
        /*
        IF (Type = Type::"Begin-Total") OR (Type = Type::"End-Total") THEN
        BEGIN
            FieldEditable:=FALSE;
        END ELSE
        BEGIN
            FieldEditable:=TRUE;
        END;
        */
        
        //For Bold and Indentation
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        
        StatusEditable := true;
        if Rec.Status <> Rec.Status::Pending then
        StatusEditable := false;

    end;

    procedure CheckRequiredFields()
    begin

        Rec.TestField("Account Type");
        Rec.TestField("Activity Description");
        Rec.TestField("Workplan Code");
        Rec.TestField("Date to Transfer",0D);
        //if
    end;

    procedure UploadWorkplanActivities()
    var
        WorkplanEntry: Record "Workplan Entry";
        EntryNum: Integer;
    begin
        WorkplanEntry.Reset;
        WorkplanEntry.Init;

        WorkplanEntry."Entry No.":=GetNextEntryNo;

        WorkplanEntry."Workplan Code":=WorkplanEntry."Workplan Code";
        WorkplanEntry."Activity Code":=WorkplanEntry."Activity Code";
        WorkplanEntry.Date:=Rec."Date to Transfer";

        //Validation will fill other variables
        WorkplanEntry.Validate(WorkplanEntry.Date);

        WorkplanEntry.Insert;
    end;

    local procedure GetNextEntryNo() EntryNumber: Integer
    var
        WorkplanEntry: Record "Workplan Entry";
        EntryNum: Integer;
    begin
        WorkplanEntry.SetCurrentKey("Entry No.");
        if WorkplanEntry.Find('+') then
          exit(WorkplanEntry."Entry No." + 1)
        else
          exit(1);
    end;

    procedure ImportProcurementPlan(FileName: Text)
    var
        //TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
        //ExportImportWorkPlan: XMLport WorkPlan;
        InStr: InStream;
    begin
        /***
        TempBlob.Init;
        if FileManagement.BLOBImport(TempBlob,FileName) = '' then
          exit;
        TempBlob.Blob.CreateInStream(InStr);
        ExportImportWorkPlan.SetSource(InStr);
        ExportImportWorkPlan.Import;
        ***/
    end;
}

