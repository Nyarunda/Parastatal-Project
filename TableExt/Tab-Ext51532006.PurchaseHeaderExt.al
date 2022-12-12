tableextension 51532006 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(3450; "RFQ No"; Code[20])
        {
            Caption = 'RFQ No';
            DataClassification = ToBeClassified;
        }
    }
}
