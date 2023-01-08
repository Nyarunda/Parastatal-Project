table 51533193 "HR Employee Bank Accounts"
{
    DrillDownPageID = "HR Bank Accounts List";
    LookupPageID = "HR Bank Accounts List";

    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2;"Employee Code";Code[20])
        {
            Editable = false;
        }
        field(3;"Bank  Code";Code[20])
        {
            TableRelation = "prBank Structure"."Bank Code";

            trigger OnValidate()
            begin
                "Bank Name":='';
                "Branch Code":='';
                "Branch Name":='';

                prBankStructure.Reset;
                prBankStructure.SetRange(prBankStructure."Bank Code","Bank  Code");
                if prBankStructure.Find('-') then
                begin
                    "Bank Name":=prBankStructure."Bank Name";
                end;
            end;
        }
        field(4;"Bank Name";Text[100])
        {
            Editable = false;
        }
        field(5;"Branch Code";Code[10])
        {
            TableRelation = "prBank Structure"."Branch Code" WHERE ("Bank Code"=FIELD("Bank  Code"));

            trigger OnValidate()
            begin

                prBankStructure.Reset;
                prBankStructure.SetRange(prBankStructure."Branch Code","Branch Code");
                if prBankStructure.Find('-') then
                begin
                    "Branch Name":=prBankStructure."Branch Name";
                end;
            end;
        }
        field(6;"Branch Name";Text[100])
        {
            Editable = false;
        }
        field(7;"A/C  Number";Code[20])
        {
        }
        field(8;"Percentage to Transfer";Decimal)
        {

            trigger OnValidate()
            var
                currAmount: Decimal;
                Total: Decimal;
            begin
                /*
                HREmployeeBankAcc.reset;
                HREmployeeBankAcc.setrange(HREmployeeBankAcc."Employee Code","Employee Code");
                if HREmployeeBankAcc.find('-') then
                begin
                    Total:=0;
                    currAmount:=HREmployeeBankAcc."Amount to Transfer (%)";
                    repeat
                        Total += HREmployeeBankAcc."Amount to Transfer (%)";
                    until HREmployeeBankAcc.next = 0;
                    if total + curramount > 100 then error('Percentage of amount to tranfer exceed 100%');
                end;
                */

            end;
        }
    }

    keys
    {
        key(Key1;"Line No.","Employee Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        prBankStructure: Record "prBank Structure";
        HREmployeeBankAcc: Record "HR Employee Bank Accounts";
}

