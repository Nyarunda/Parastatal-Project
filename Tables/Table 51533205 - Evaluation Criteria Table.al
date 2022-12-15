table 51533205 "Evaluation Criteria Table"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "Evaluation Criterial Header".Code;
        }
        field(2; "Evaluation Year"; Integer)
        {
            TableRelation = "Evaluation Year";
        }
        field(3; "Actual Weight Assigned"; Decimal)
        {
        }
        field(4; Description; Code[150])
        {
        }
        field(5; "RFQ No."; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Quote Header"."No.";
        }
        field(6; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(7; YesNo; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(8; "Procurement Method"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Evaluation Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Mandatory,Financial,Technical';
            OptionMembers = " ",Mandatory,Financial,Technical;
        }
        field(10; "Evaluation Maximum Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "User ID"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "No."; Code[40])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PurchSetup.Get;
                    NoSeriesMgt.TestManual(PurchSetup."Evaluation Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(13; "No. Series"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Quote No"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Bid No."; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Bid Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending,Approved,Rejected,Cancelled,Completed';
            OptionMembers = Open,Pending,Approved,Rejected,Cancelled,Completed;
        }
    }

    keys
    {
        key(Key1; "No.", "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            PurchSetup.Get;
            PurchSetup.TestField(PurchSetup."Evaluation Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Evaluation Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "User ID" := UserId;
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Hrempl: Record "HR Employees";
        //ContractLineType: Record "Contract Lines Types";
        PurchaseHeader: Record "Purchase Header";
}

