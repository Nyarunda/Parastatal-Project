table 51533904 "Bid Analysis"
{

    fields
    {
        field(1; "RFQ No."; Code[20])
        {
        }
        field(2; "RFQ Line No."; Integer)
        {
        }
        field(3; "Quote No."; Code[20])
        {
        }
        field(4; "Vendor No."; Code[20])
        {
        }
        field(5; "Item No."; Code[20])
        {
        }
        field(6; Description; Text[100])
        {
        }
        field(7; Quantity; Decimal)
        {
        }
        field(8; "Unit Of Measure"; Code[20])
        {
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; "Line Amount"; Decimal)
        {
        }
        field(11; Total; Decimal)
        {
        }
        field(12; "Last Direct Cost"; Decimal)
        {
            CalcFormula = Lookup(Item."Last Direct Cost" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(13; Remarks; Text[50])
        {

            trigger OnValidate()
            begin
                PurchLine.Reset;
                PurchLine.SetRange(PurchLine."Document Type", PurchLine."Document Type"::Quote);
                PurchLine.SetRange(PurchLine."Document No.", "Quote No.");
                PurchLine.SetRange(PurchLine."Line No.", "RFQ Line No.");
                if PurchLine.FindSet then begin
                    //PurchLine."RFQ Remarks" := Remarks;
                    PurchLine.Modify;
                end
            end;
        }
    }

    keys
    {
        key(Key1; "RFQ No.", "RFQ Line No.", "Quote No.", "Vendor No.")
        {
        }
        key(Key2; "Item No.")
        {
        }
        key(Key3; "Vendor No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PurchLine: Record "Purchase Line";
}

