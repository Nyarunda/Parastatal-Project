page 51533487 "PRF Lists"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = CONST(Quote));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //Check document line HAS NOT been copied TO rfq lines
        //CheckDocLinesNotCopied();
        Rec.FilterGroup(2);
        //Rec.SetRange(Copied,false);
        Rec.FilterGroup(0);
    end;

    procedure SetSelection(var Collection: Record "Purchase Line")
    begin
        CurrPage.SetSelectionFilter(Collection);
    end;

    local procedure CheckDocLinesNotCopied()
    var
        PurchaseQuoteLine: Record "Purchase Quote Line";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseQuoteLine.Reset;
        PurchaseQuoteLine.SetRange(PurchaseQuoteLine."PRF No", Rec."Document No.");
        PurchaseQuoteLine.SetRange(PurchaseQuoteLine."PRF Line No.", Rec."Line No.");
        /*if PurchaseQuoteLine.FindSet then
          Copied := true
        else
          Copied := false; */
    end;
}

