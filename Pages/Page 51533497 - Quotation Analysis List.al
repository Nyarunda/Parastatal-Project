page 51533497 "Quotation Analysis List"
{
    CardPageID = "Quotation Analysis Page";
    Editable = false;
    PageType = List;
    SourceTable = "Quotation Analysis Header";
    SourceTableView = SORTING("No.")
                      ORDER(Descending)
                      WHERE("Sent to Proc Officer"=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("RFQ No.";"RFQ No.")
                {
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field(Status;Status)
                {
                }
                field("Evaluation Status";"Evaluation Status")
                {
                }
                field("Created By";"Created By")
                {
                }
            }
        }
    }

    actions
    {
    }
}

