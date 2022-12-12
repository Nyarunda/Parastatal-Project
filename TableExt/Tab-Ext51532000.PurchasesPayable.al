tableextension 51532000 "Purchases & Payable Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(7004; "Stores Requisition No"; Code[20])
        {
            Caption = 'Stores Requisition No';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7005; "Bid Analysis Nos"; Code[20])
        {
            Caption = 'Bid Analysis Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
