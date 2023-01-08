tableextension 51532003 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(6000; "Staff Travel Account"; Code[20])
        {
            Caption = 'Staff Travel Account';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(6001; "Allow Send Email Proc Officer"; Boolean)
        {
            Caption = 'Allow Send Email Proc Officer';
            DataClassification = ToBeClassified;
        }
        field(6002; "Can Cancel Document"; Boolean)
        {
            Caption = 'Can Cancel Document';
            DataClassification = ToBeClassified;
        }
        field(6003; "Edit Work Plan Activites"; Boolean)
        {
            Caption = 'Edit Work Plan Activites';
            DataClassification = ToBeClassified;
        }
        field(6004; "Responsibility Center"; code[50])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
        }
        field(6005; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
        }
        field(6006; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
        }
        field(6007; "Other Advance Staff Account"; Code[20])
        {
            Caption = 'Other Advance Staff Account';
            DataClassification = ToBeClassified;
        }
    }
}
