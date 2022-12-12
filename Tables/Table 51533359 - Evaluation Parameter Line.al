table 51533359 "Evaluation Parameter Line"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"Overall Comment";Text[50])
        {
        }
        field(3;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(4;"Parameter Code";Code[20])
        {
            Editable = false;
        }
        field(5;"Min. Score";Decimal)
        {
            Editable = false;
        }
        field(6;"Max. Score";Decimal)
        {
            Editable = false;
        }
        field(7;"Vendor No";Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.","Vendor No");
                if Vend.Find('-')  then
                "Vendor Name":=Vend.Name;
            end;
        }
        field(8;"Vendor Name";Text[100])
        {
        }
        field(9;"Evaluation Year";Code[50])
        {
        }
        field(10;"Actuals Scores";Decimal)
        {
        }
        field(11;Comment;Text[100])
        {
        }
        field(12;"Total Actual Scores";Decimal)
        {
        }
        field(13;"Parameter description";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Code","Line No.")
        {
        }
        key(Key2;"Line No.","Vendor No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vend: Record Vendor;
}

