page 51533918 "Purchase Inspection lines"
{
    PageType = ListPart;
    SourceTable = "Purch. Inspection Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No.";Rec."Document No.")
                {
                }
                field(Type;Rec.Type)
                {
                }
                field("No.";Rec."No.")
                {
                }
                field(Description;Rec.Description)
                {
                }
                field("Unit of Measure";Rec."Unit of Measure")
                {
                }
                field("Unit of Measure Code";Rec."Unit of Measure Code")
                {
                    Visible = false;
                }
                field(Quantity;Rec.Quantity)
                {
                }
                field("Direct Unit Cost";Rec."Direct Unit Cost")
                {
                }
                field(Amount;Rec.Amount)
                {
                }
                field("Order No.";Rec."Order No.")
                {
                    Visible = false;
                }
                field("Quantity Accepted";Rec."Quantity Accepted")
                {
                }
                field("Quantity Rejected";Rec."Quantity Rejected")
                {
                }
                field(Remarks;Rec.Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
}

