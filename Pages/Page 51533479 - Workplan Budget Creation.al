page 51533479 "Workplan Budget Creation"
{
    PageType = List;
    SourceTable = "Procur. Plan Budget Allocation";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Analysis Area"; Rec."Analysis Area")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Workplan Code';
                }
                field("Current G/L Budget"; Rec."Current G/L Budget")
                {
                    Editable = false;
                }
                field("Current Item Budget"; Rec."Current Item Budget")
                {
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Budget Dimension 1 Code"; Rec."Budget Dimension 1 Code")
                {
                    Caption = 'Budget Dimension 1 Code';
                    Enabled = FieldsEditable;
                    Visible = FieldsEditable;
                }
                field("Budget Dimension 2 Code"; Rec."Budget Dimension 2 Code")
                {
                    Caption = 'Budget Dimension 2 Code';
                    Enabled = FieldsEditable;
                    Visible = FieldsEditable;
                }
                field("Budget Dimension 3 Code"; Rec."Budget Dimension 3 Code")
                {
                    Caption = 'Budget Dimension 3 Code';
                    Enabled = FieldsEditable;
                    Visible = FieldsEditable;
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("Period Type"; Rec."Period Type")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Overwrite; Rec.Overwrite)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Process)
            {
                Caption = 'Process';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("Start Date");
                    Rec.TestField("End Date");
                    if Confirm('Process Allocation?', false) = false then begin
                        Error('Processing Aborted');
                        exit;
                    end else begin
                        fnProcessAllocation;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        Budget.Reset;
        Budget.SetRange(Budget."Workplan Code", Rec.Name);
        if Budget.Find('-') then begin
            //Check if the budget dimension 1 is to be enabled
            if Budget."Budget Dimension 1 Code" = '' then begin
                FieldsEditable := false;
            end
            else begin
                FieldsEditable := true;
            end;
            if Budget."Budget Dimension 2 Code" = '' then begin
                FieldsEditable := false;
            end
            else begin
                FieldsEditable := true;
            end;
            if Budget."Budget Dimension 3 Code" = '' then begin
                FieldsEditable := false;
            end
            else begin
                FieldsEditable := true;
            end;
        end;
    end;

    var
        Budget: Record Workplan;
        FieldsEditable: Boolean;
    //BudgetAllocation: Codeunit "WP Budget Allocation";

    procedure fnProcessAllocation()
    begin
        Rec.SetRange(Rec."Line No.", Rec."Line No.");
        //BudgetAllocation.CreateBudgetFromWorkplan(Rec);
    end;
}

