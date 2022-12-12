page 51533957 "Purchase Inspection list"
{
    CardPageID = "Purchase Inspection Card";
    Editable = false;
    PageType = List;
    SourceTable = "Purch. Inspection Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Posting Description"; Rec."Posting Description")
                {
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

