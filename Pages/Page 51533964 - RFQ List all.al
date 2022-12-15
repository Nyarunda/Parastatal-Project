page 51533964 "RFQ List all"
{
    CardPageID = "Request For Quotation";
    PageType = List;
    SourceTable = "Purchase Quote Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No.";"No.")
                {
                }
                field(Description;"Posting Description")
                {
                    Caption = 'Description';
                }
                field("Expected Closing Date";"Expected Closing Date")
                {
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field(Status;Status)
                {
                }
                field("Ship-to Code";"Ship-to Code")
                {
                }
                field("Ship-to Name";"Ship-to Name")
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    procedure GetSelectionFilter(): Text
    var
        RFQ: Record "Purchase Quote Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(RFQ);
        //EXIT(SelectionFilterManagement.GetSelectionFilterForItem(Item));
        exit(RFQ."No.");
    end;

    procedure SetSelection(var RFQ: Record "Purchase Quote Header")
    begin
        CurrPage.SetSelectionFilter(RFQ);
    end;
}

