table 51533888 "Order Requsition Buffer"
{
    Caption = 'Order Requsition Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; RequisitionNo; Code[20])
        {
            Caption = 'RequisitionNo';
            DataClassification = ToBeClassified;
        }
        field(2; "Requisition Line No."; Integer)
        {
            Caption = 'Requisition Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; OrderNo; Code[20])
        {
            Caption = 'OrderNo';
            DataClassification = ToBeClassified;
        }
        field(4; UserID; Code[50])
        {
            Caption = 'UserID';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; RequisitionNo)
        {
            Clustered = true;
        }
    }
}
