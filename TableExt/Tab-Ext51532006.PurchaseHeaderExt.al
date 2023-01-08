tableextension 51532006 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {

        field(3450; "RFQ No"; Code[20])
        {
            Caption = 'RFQ No';
            DataClassification = ToBeClassified;
        }

        field(3451; DocApprovalType; Enum "Doc Approval Type")
        {
            Caption = 'DocApprovalType';
            DataClassification = ToBeClassified;
        }
        field(3452; Copied; Boolean)
        {
            Caption = 'Copied';
            DataClassification = ToBeClassified;
        }

    }
}