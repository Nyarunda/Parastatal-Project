table 51533073 "HR Training Cost"
{

    fields
    {
        field(1;"Training ID";Code[50])
        {
            Editable = false;
        }
        field(2;"Cost Item";Code[30])
        {
            TableRelation = "HR Lookup Values".Code WHERE (Type=FILTER("Interview Areas"));

            trigger OnValidate()
            begin
                LookUpVal.Reset;
                LookUpVal.SetRange(LookUpVal.Type,LookUpVal.Type::"Interview Areas");
                LookUpVal.SetRange(LookUpVal.Code,"Cost Item");
                if LookUpVal.Find('-') then
                "Cost Item Description":=LookUpVal.Description;
            end;
        }
        field(3;Cost;Decimal)
        {
        }
        field(4;"Cost Item Description";Text[100])
        {
        }
        field(5;"G/L Account";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;Committed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(8;"Global Dimension 1 Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Shortcut Dimension 2 Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Training ID","Cost Item")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LookUpVal: Record "HR Lookup Values";

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",StrSubstNo('%1 %2','Payment',"Training ID"));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Shortcut Dimension 2 Code");
    end;
}

