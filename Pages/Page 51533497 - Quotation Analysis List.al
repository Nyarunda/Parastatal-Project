page 51533497 "Quotation Analysis List"
{
    CardPageID = "Quotation Analysis Page";
    Editable = false;
    PageType = List;
    SourceTable = "Quotation Analysis Header";
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE("Sent to Proc Officer" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Evaluation Status"; Rec."Evaluation Status")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
            }
        }
    }

    actions
    {
    }
}

