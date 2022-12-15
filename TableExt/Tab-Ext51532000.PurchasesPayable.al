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
        field(7006; "Request For Quotation"; Code[20])
        {
            Caption = 'Request For Quotation"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7007; "Low Value Proucrement No"; Code[20])
        {
            Caption = 'Low Value Proucrement No"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7008; "Open Tender No"; Code[20])
        {
            Caption = 'BLN10106"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7009; "Evaluation Nos."; Code[20])
        {
            Caption = 'Evaluation Nos."';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7010; "Evaluation Commitee"; Code[20])
        {
            Caption = 'Evaluation Commitee"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7011; "Professional Opinion Nos"; Code[20])
        {
            Caption = 'Professional Opinion Nos"';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
