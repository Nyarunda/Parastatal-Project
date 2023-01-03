page 51533119 "prTransaction Code"
{
    PageType = Card;
    SourceTable = "prTransaction Codes";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Transaction Code"; Rec."Transaction Code")
                {
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Pre-Tax Deduction"; Rec."Pre-Tax Deduction")
                {
                }
                field(Frequency; Rec.Frequency)
                {
                    ValuesAllowed = Fixed, Varied;
                }
                field("Balance Type"; Rec."Balance Type")
                {
                    ValuesAllowed = None, Increasing, Reducing;
                }
                field("Amount Preference"; Rec."Amount Preference")
                {
                    ValuesAllowed = "Posted Amount", "Take Lower ", "Take Higher";
                }
                field("Is Cash"; Rec."Is Cash")
                {
                }
                field(Taxable; Rec.Taxable)
                {
                }
                field(Pension; Rec.Pension)
                {
                }
                field("Is Formula"; Rec."Is Formula")
                {
                }
                field(Formula; Rec.Formula)
                {
                }
                field(Control1102756053; '')
                {
                    CaptionClass = Text19025872;
                    ShowCaption = false;
                }
                field("Include Employer Deduction"; Rec."Include Employer Deduction")
                {
                }
                field("Employer Deduction"; Rec."Employer Deduction")
                {
                }
                field("Is Formula for employer"; Rec."Is Formula for employer")
                {
                }
                field(Control1102756054; '')
                {
                    CaptionClass = Text19080001;
                    ShowCaption = false;
                }
                field("Transaction Category"; Rec."Transaction Category")
                {
                }
                field("GL Account"; Rec."GL Account")
                {
                }
                field(Subledger; Rec.Subledger)
                {
                    Caption = 'Posting to Subledger';
                }
                field(CustomerPostingGroup; Rec.CustomerPostingGroup)
                {
                    Caption = 'Debtor Posting Group';
                }
                field("IsCoop/LnRep"; Rec."IsCoop/LnRep")
                {
                    Caption = 'Is Loan/Coop';
                }
                field("Add to Relief"; Rec."Add to Relief")
                {
                }
                field("Excl. from Proration"; Rec."Excl. from Proration")
                {
                }
                field("Is Overtime Allowance"; Rec."Is Overtime Allowance")
                {
                }
            }
            group("Other Set-Ups")
            {
                Caption = 'Other Set-Ups';
                group("Select one")
                {
                    Caption = 'Select one';
                    field("Special Transactions3"; Rec."Special Transactions")
                    {
                        Caption = 'Other Transactions';
                    }
                }
                group(Control1102756068)
                {
                    Caption = 'Select one';
                    field("Deduct Premium"; Rec."Deduct Premium")
                    {
                    }
                }
                group("Coop Reporting")
                {
                    Caption = 'Coop Reporting';
                    field("IsCoop/LnRep2"; Rec."IsCoop/LnRep")
                    {
                        Caption = 'Coop Parameter';
                    }
                    field("coop parameters"; Rec."coop parameters")
                    {
                        DrillDown = false;
                    }
                    field("Fixed Amount"; Rec."Fixed Amount")
                    {
                    }
                }
            }
        }
    }

    actions
    {
    }

    var
        Text19025872: Label 'E.g ([005]+[020]*[24])/2268';
        Text19080001: Label 'E.g ([005]+[020]*[24])/2268';
}

