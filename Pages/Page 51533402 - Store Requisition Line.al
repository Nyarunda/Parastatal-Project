page 51533402 "Store Requisition Line"
{
    PageType = ListPart;
    SourceTable = "Store Requistion Lines";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Requistion No";Rec."Requistion No")
                {
                    Visible = false;
                }
                field("Line No.";Rec."Line No.")
                {
                    Visible = false;
                }
                field(Type;Rec.Type)
                {
                }
                field("No.";Rec."No.")
                {
                }
                field(Description;Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2";Rec."Description 2")
                {
                    Caption = 'Remark';
                }
                field("Unit of Measure";Rec."Unit of Measure")
                {
                }
                field("Issuing Store";Rec."Issuing Store")
                {
                }
                field("Qty in store";Rec."Qty in store")
                {
                }
                field("Shortcut Dimension 1 Code";Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code";Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Quantity Requested";Rec."Quantity Requested")
                {
                }
                field("Unit Cost";Rec."Unit Cost")
                {

                    trigger OnValidate()
                    begin
                        // IF Type=Type::Item THEN
                           Rec."Line Amount":=Rec."Unit Cost"*Rec.Quantity;
                    end;
                }
                field("Line Amount";Rec."Line Amount")
                {
                }
                field(Quantity;Rec.Quantity)
                {
                    Caption = 'Quantity To Issue';
                }
                field("Gen. Prod. Posting Group";Rec."Gen. Prod. Posting Group")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                }
                action("Item Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array [8] of Code[20];
}

