tableextension 51532005 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(1560; Awarded; Boolean)
        {
            Caption = 'Awarded';
            DataClassification = ToBeClassified;
        }
        field(1561; Committed; Boolean)
        {
            Caption = 'Committed';
            DataClassification = ToBeClassified;
        }
        field(1562; "Requisition No"; Code[20])
        {
            Caption = 'Requisition No';
            DataClassification = ToBeClassified;
        }
        field(1563; "Requisition Line No."; Integer)
        {
            Caption = 'Requisition Line No.';
            DataClassification = ToBeClassified;
        }
        field(1564; "Qty Ordered"; Decimal)
        {
            Caption = 'Qty Ordered';
            DataClassification = ToBeClassified;
        }
        field(1565; "Qty UnOrdered"; Decimal)
        {
            Caption = 'Qty UnOrdered';
            DataClassification = ToBeClassified;
        }
        field(1566; Copied; Boolean)
        {
            Caption = 'Copied';
            DataClassification = ToBeClassified;
        }
    }
}
