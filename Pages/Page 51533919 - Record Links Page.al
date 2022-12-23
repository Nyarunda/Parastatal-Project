page 51533912 "Record Links Page"
{
    PageType = List;
    SourceTable = "Record Link";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Link ID"; Rec."Link ID")
                {
                    Editable = false;
                }
                field("Record ID"; Rec."Record ID")
                {
                }
                field(URL1; Rec.URL1)
                {

                    trigger OnValidate()
                    begin
                        //HYPERLINK(URL1);
                    end;
                }
                /**
                field(URL2;URL2)
                {
                }
                field(URL3;URL3)
                {
                }
                field(URL4;URL4)
                {
                } **/
                field(Description; Rec.Description)
                {
                }
                field(Created; Rec.Created)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Company; Rec.Company)
                {
                }
                field("To User ID"; Rec."To User ID")
                {
                }
                /**
                field("Record Link Name"; Rec."Record Link Name")
                {
                }
                field("Document No"; Rec."Document No")
                {
                } 
                field("Document Type"; Rec."Document Type")
                {
                }**/
                field(Type; Rec.Type)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        newURL: Text;
}

