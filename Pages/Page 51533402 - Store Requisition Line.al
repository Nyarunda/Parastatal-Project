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
                field("Requistion No";"Requistion No")
                {
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    Visible = false;
                }
                field(Type;Type)
                {
                }
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                    Editable = false;
                }
                field("Description 2";"Description 2")
                {
                    Caption = 'Remark';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                }
                field("Issuing Store";"Issuing Store")
                {
                }
                field("Qty in store";"Qty in store")
                {
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field("Quantity Requested";"Quantity Requested")
                {
                }
                field("Unit Cost";"Unit Cost")
                {

                    trigger OnValidate()
                    begin
                        // IF Type=Type::Item THEN
                           "Line Amount":="Unit Cost"*Quantity;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                }
                field(Quantity;Quantity)
                {
                    Caption = 'Quantity To Issue';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
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
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array [8] of Code[20];
}

