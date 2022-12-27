table 51533732 "Non Stock Ledger Entry"
{
    //DrillDownPageID = "Non Stock List2";
    //LookupPageID = "Non Stock List2";

    fields
    {
        field(1; No; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Unit Of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(4; Quantity; Decimal)
        {
        }
        field(5; Category; Code[20])
        {
            TableRelation = "No Stock Category".Code;
        }
        field(6; "Gl Budgeted Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5000; "No. Series"; Code[20])
        {
        }
        field(50001; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50002; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50003; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(50004; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                /*IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN BEGIN
                  IF CurrFieldNo <> 0 THEN
                    IF ProdOrderExist THEN
                      IF NOT CONFIRM(
                           Text024 +
                           Text022,FALSE,
                           FIELDCAPTION("Gen. Prod. Posting Group"))
                      THEN BEGIN
                        "Gen. Prod. Posting Group" := xRec."Gen. Prod. Posting Group";
                        EXIT;
                      END;
                
                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                END;
                
                VALIDATE("Price/Profit Calculation");  */

            end;
        }
        field(50005; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                //VALIDATE("Price/Profit Calculation");
            end;
        }
        field(50006; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";

            trigger OnValidate()
            begin
                /*ItemLedEntry.RESET;
                ItemLedEntry.SETRANGE(ItemLedEntry."Item No.","No.");
                IF ItemLedEntry.FINDFIRST THEN BEGIN
                   IF ("Inventory Posting Group")<>(xRec."Inventory Posting Group") THEN
                      ERROR('There are already entries for Item '+"No."+', Cannot change the Posting Group');
                END;

               IF "Inventory Posting Group" <> '' THEN
                 TESTFIELD(Type,Type::Inventory);*/

            end;
        }
        field(50007; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; No, "Line No")
        {
        }
        key(Key2; "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if No = '' then begin
            Purchase.Get;
            Purchase.TestField(Purchase."Non Stock No");
            NoSeriesMgt.InitSeries(Purchase."Non Stock No", xRec."No. Series", 0D, No, "No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Vend: Record Vendor;
        Purchase: Record "Purchases & Payables Setup";
}

