page 51533585 WorkplanActivities
{
    PageType = List;
    SourceTable = "Workplan Activities";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workplan Code"; Rec."Workplan Code")
                {
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    Caption = 'Activity Code';
                }
                field("Source Of Funds"; Rec."Source Of Funds")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field(Budget; Rec.Budget)
                {
                    TableRelation = "G/L Budget Name";
                }
                field("Account Type"; Rec."Account Type")
                {

                    trigger OnValidate()
                    begin
                        //UpdateControls;
                    end;
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Activity Description"; Rec."Activity Description")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Department Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Division Code';
                }
                field(Period; Rec.Period)
                {
                }
                field("Proc. Method No."; Rec."Proc. Method No.")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Cost"; Rec."Unit of Cost")
                {
                    Caption = ' Cost Per Unit';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field("Amount to Transfer"; Rec."Amount to Transfer")
                {

                    trigger OnValidate()
                    begin
                        Rec."Amount to Transfer" := Rec.Quantity * Rec."Unit of Cost";
                    end;
                }
                field("Date to Transfer"; Rec."Date to Transfer")
                {
                }
                field("Procurement Category"; Rec."Procurement Category")
                {
                    Caption = 'Category';
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    Editable = false;
                }
                field("Uploaded to Procurement Workpl"; Rec."Uploaded to Procurement Workpl")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Converted to Budget"; Rec."Converted to Budget")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Include In Procurement Plan"; Rec."Include In Procurement Plan")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec."Document Date" := Today;
    end;
}

