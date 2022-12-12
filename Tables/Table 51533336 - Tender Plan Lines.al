table 51533336 "Tender Plan Lines"
{

    fields
    {
        field(1;"Tender No.";Code[20])
        {
        }
        field(5;"Planned start date";Date)
        {
            Editable = true;
        }
        field(6;"Planned end date";Date)
        {
            Editable = true;
        }
        field(7;"Planned duration";Decimal)
        {
            Editable = true;
        }
        field(8;"Actual start date";Date)
        {

            trigger OnValidate()
            begin
                if "Actual end date">"Actual start date" then "Actual Duration":="Actual end date"-"Actual start date";
                SetNextStart;
            end;
        }
        field(9;"Actual end date";Date)
        {

            trigger OnValidate()
            begin
                if "Actual end date">"Actual start date" then "Actual Duration":="Actual end date"-"Actual start date";
                SetNextStart;
            end;
        }
        field(10;"Actual Duration";Decimal)
        {
            Editable = true;
        }
        field(11;Stage;Code[20])
        {
            Editable = true;
        }
        field(12;"Sorting No.";Integer)
        {
            Editable = false;
        }
        field(13;WorkplanCode;Code[20])
        {
            CalcFormula = Lookup("Tender Plan Header"."Workplan Code" WHERE ("No."=FIELD("Tender No.")));
            FieldClass = FlowField;
        }
        field(14;"WorkPlan Code";Code[20])
        {
        }
        field(15;"Proc. Method No.";Code[20])
        {
            CalcFormula = Lookup("Tender Plan Header"."Procurement Method" WHERE ("No."=FIELD("Tender No.")));
            FieldClass = FlowField;
        }
        field(16;Description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Tender No.",Stage)
        {
        }
        key(Key2;"Tender No.","Sorting No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        me: Record "Tender Plan Lines";

    procedure SetNextStart()
    begin
        me.SetFilter("Sorting No.",'%1',"Sorting No."+1);
        if me.FindFirst then begin
          me."Actual start date":="Actual end date";
          me.Modify;
        end;
    end;
}

