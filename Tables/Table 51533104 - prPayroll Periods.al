table 51533104 "prPayroll Periods"
{
    LookupPageID = "prPayroll Periods";

    fields
    {
        field(1;"Period Month";Integer)
        {
        }
        field(2;"Period Year";Integer)
        {
        }
        field(3;"Period Name";Text[30])
        {
            Description = 'e.g November 2009';
        }
        field(4;"Date Opened";Date)
        {
            NotBlank = true;
        }
        field(5;"Date Closed";Date)
        {
        }
        field(6;Closed;Boolean)
        {
            Description = 'A period is either closed or open';
        }
        field(7;"Payroll Code";Code[20])
        {
            TableRelation = "prPayroll Type";
        }
        field(8;"Tax Paid";Decimal)
        {
            CalcFormula = Sum("prPeriod Transactions".Amount WHERE ("Payroll Period"=FIELD("Date Opened"),
                                                                    "Group Order"=CONST(7),
                                                                    "Sub Group Order"=CONST(3)));
            FieldClass = FlowField;
        }
        field(9;"Chosen To Send";Boolean)
        {
        }
        field(10;"Is before 13th Month";Boolean)
        {
            Description = 'Added to allow creation of a new month after the 13th Month';
        }
        field(11;"Variance Report";Boolean)
        {
            Description = 'Used to run Variance Report';
        }
        field(12;"Journal Transferred";Boolean)
        {
            Description = 'Used to identify periods whose Payroll Journal has been Transferred';
        }
        field(13;"Closed By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Opened By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Date Opened")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Date Opened","Period Name")
        {
        }
    }

    trigger OnInsert()
    begin
        PayrollPeriods.Reset;
        if PayrollPeriods.Find('-') then repeat
          if PayrollPeriods.Closed = false then Error(Txt001);
        until PayrollPeriods.Next = 0;
    end;

    var
        PayrollPeriods: Record "prPayroll Periods";
        Txt001: Label 'You can not have more than one open period. Please use the "Close Period" button to close the current open period.';
}

