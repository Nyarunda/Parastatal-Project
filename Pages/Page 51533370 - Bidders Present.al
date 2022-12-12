page 51533370 "Bidders Present"
{
    PageType = ListPart;
    SourceTable = "Bidders Presents";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field("Document No"; Rec."Document No")
                {
                }
                field("Bidder No"; Rec."Bidder No")
                {
                }
                field("Bidder Name"; Rec."Bidder Name")
                {
                }
                field("Bidder Category"; Rec."Bidder Category")
                {
                }
                field(Address; Rec.Address)
                {
                }
            }
        }
    }

    actions
    {
    }
}

