page 51533911 "Procurement Plan"
{
    Editable = true;
    MultipleNewLines = false;
    PageType = List;
    SourceTable = "Procurement Plan Activities";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                ShowAsTree = false;
                field("Date to Transfer"; Rec."Date to Transfer")
                {
                }
                field("Workplan Code"; Rec."Workplan Code")
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Activities Code"; Rec."Activities Code")
                {
                }
                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Source of Fund"; Rec."Source of Fund")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Strategic Goal"; Rec."Strategic Goal")
                {
                }
                field("Procurement Type"; Rec."Procurement Type")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Code"; Rec.Code)
                {
                }
                field("Date Filter"; Rec."Date Filter")
                {
                }
                field("Converted to Budget"; Rec."Converted to Budget")
                {
                }
                field("Uploaded to Procurement Workpl"; Rec."Uploaded to Procurement Workpl")
                {
                }
                field("Budget Filter"; Rec."Budget Filter")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control2; Outlook)
            {
            }
            systempart(Control1; Notes)
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
                action("Indent Procurement Plan")
                {
                    Caption = 'Indent Procurement Plan';
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
                    PromotedCategory = Category4;
                    //RunObject = XMLport XMLport39003903;
                }
                action("Update Unit Cost 2")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        PPA.Reset;
                        if PPA.Find('-') then begin
                            repeat
                                PPA."Unit Cost2" := PPA."Unit Cost";
                                PPA.Modify;
                            until PPA.Next = 0;
                        end;
                        Message('Activities Updated Successfully !');
                    end;
                }
                action("Attach Documents")
                {
                    Image = Attach;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /**
                        DMSint.Reset;
                        DMSint.SetRange(DMSint."DMS Link Type", DMSint."DMS Link Type"::DMSAttach);
                        if DMSint.Find('-') then begin

                             HyperLink(DMSint."DMS Link Path" + '&dt_code=DT_1_1464075594713&dtgcode=DTT_1_1464075644448&savetype=UPLOADONLY&spu_id=' + "Workplan Code" +
                          '&txtPPD_ITEM_DESP=' + "Workplan Code" +
                          '&txtPPD_PROC_MTHD=' + "Global Dimension 1 Code" +
                          //'&txtCRIV_DEPT='+"Responsibility Center"+
                          '&attach_category=Procurement+Plan+Document')
                        end;s
                    end; 
                }
                action("View Documents")
                {
                    Image = Attach;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        DMSint.Reset;
                        DMSint.SetRange(DMSint."DMS Link Type", DMSint."DMS Link Type"::DMSView);
                        if DMSint.Find('-') then begin

                            //HyperLink(DMSint."DMS Link Path" + '&dt_code=DT_1_1464075594713&dtgcode=DTT_1_1464075644448&spu_id=' + "Workplan Code" +
                            //'&attach_category=Procurement+Plan+Document')
                        end;

                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    var
                        OldDimSetID: Integer;
                        DimMgt: Codeunit DimensionManagement;
                    begin
                        /**
                        OldDimSetID := "Dimension Set ID";
                        "Dimension Set ID" :=
                          DimMgt.EditDimensionSet2(
                            "Dimension Set ID", StrSubstNo('%1 %2', 'Procurement Plan', "No."),
                            "Global Dimension 1 Code", "Global Dimension 2 Code");

                        if OldDimSetID <> "Dimension Set ID" then begin
                            Modify;
                            //  IF PurchLinesExist THEN
                            //UpdateAllLineDim("Dimension Set ID",OldDimSetID);
                        end;

                        CurrPage.SaveRecord;
                        **/
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
        GLSelected: Boolean;
        ItemSelected: Boolean;
        PPA: Record "Procurement Plan Activities";
    //DMSint: Record "DMS Intergration";

    procedure SetSelection(var GLAcc: Record "Procurement Plan Activities")
    begin
        CurrPage.SetSelectionFilter(GLAcc);
    end;

    procedure GetSelectionFilter(): Code[80]
    var
        GLAcc: Record "Procurement Plan Activities";
        FirstAcc: Text[20];
        LastAcc: Text[20];
        SelectionFilter: Code[80];
        GLAccCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(GLAcc);
        GLAcc.SetCurrentKey(Code);
        GLAccCount := GLAcc.Count;
        if GLAccCount > 0 then begin
            GLAcc.Find('-');
            while GLAccCount > 0 do begin
                GLAccCount := GLAccCount - 1;
                GLAcc.MarkedOnly(false);
                FirstAcc := GLAcc.Code;
                LastAcc := FirstAcc;
                More := (GLAccCount > 0);
                while More do
                    if GLAcc.Next = 0 then
                        More := false
                    else
                        if not GLAcc.Mark then
                            More := false
                        else begin
                            LastAcc := GLAcc.Code;
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
        NoEmphasize := Rec."Account Type" <> "Account Type"::Customer;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> "Account Type"::Customer;

    end;

    procedure CheckRequiredFields()
    begin

        Rec.TestField("Account Type");
        Rec.TestField(Description);
        Rec.TestField("Workplan Code");
        Rec.TestField("Date to Transfer", 0D);
        //if
    end;

    procedure UploadWorkplanActivities()
    var
        WorkplanEntry: Record "Workplan Entry";
        EntryNum: Integer;
    begin
        WorkplanEntry.Reset;
        WorkplanEntry.Init;

        WorkplanEntry."Entry No." := GetNextEntryNo;

        WorkplanEntry."Workplan Code" := WorkplanEntry."Workplan Code";
        WorkplanEntry."Activity Code" := WorkplanEntry."Activity Code";
        WorkplanEntry.Date := Rec."Date to Transfer";

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
}

