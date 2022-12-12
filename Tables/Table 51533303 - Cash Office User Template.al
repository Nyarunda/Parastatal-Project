table 51533303 "Cash Office User Template"
{
    DataCaptionFields = UserID;
    //DrillDownPageID = 39006023;
    //LookupPageID = 39006023;

    fields
    {
        field(1; UserID; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the user in the database';
            NotBlank = true;

            trigger OnLookup()
            begin
                //LoginMgt.LookupUserID(UserID);
            end;

            trigger OnValidate()
            begin
                //LoginMgt.ValidateUserID(UserID);
            end;
        }
        field(2; "Receipt Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
        }
        field(3; "Receipt Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Receipt Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Receipt Journal Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(4; "Payment Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the payment journal template in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(5; "Payment Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the payment journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payment Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SetRange(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Payment Journal Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(6; "Petty Cash Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the petty cash payment voucher in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(7; "Petty Cash Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Petty Cash Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Petty Cash Template", "Petty Cash Template");
                UserTemp.SetRange(UserTemp."Petty Cash Batch", "Petty Cash Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Petty Cash Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(8; "Inter Bank Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(9; "Inter Bank Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the inter bank transfer batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Inter Bank Template Name"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Inter Bank Template Name", "Inter Bank Template Name");
                UserTemp.SetRange(UserTemp."Inter Bank Batch Name", "Inter Bank Batch Name");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Inter Bank Batch Name" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(10; "Default Receipts Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the default receipts bank deposit account';
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default Receipts Bank", "Default Receipts Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(11; "Default Payment Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the default payments bank deposit account';
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default Payment Bank", "Default Payment Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(12; "Default Petty Cash Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the default petty cash account in the database';
            TableRelation = "Bank Account"."No." WHERE("Bank Type" = CONST(Cash));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default Petty Cash Bank", "Default Petty Cash Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(13; "Max. Cash Collection"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Max. Cheque Collection"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Max. Deposit Slip Collection"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Supervisor ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference for the supervisor for the specific teller';

            trigger OnLookup()
            begin
                //LoginMgt.LookupUserID("Supervisor ID");
            end;

            trigger OnValidate()
            begin
                //LoginMgt.ValidateUserID("Supervisor ID");
            end;
        }
        field(17; "Bank Pay In Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(18; "Bank Pay In Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Bank Pay In Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Bank Pay In Journal Template", "Bank Pay In Journal Template");
                UserTemp.SetRange(UserTemp."Bank Pay In Journal Batch", "Bank Pay In Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp.UserID <> Rec.UserID then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(19; "Imprest Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(20; "Imprest  Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(21; "Claim Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(22; "Claim  Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Claim Template"));
        }
        field(23; "Advance Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(24; "Advance  Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Advance Template"));
        }
        field(25; "Advance Surr Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(26; "Advance Surr Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Advance Surr Template"));
        }
        field(27; "Dim Change Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Dimensions/ GL journal template in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(28; "Dim Change Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Dimensions/GL  journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Dim Change Journal Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SetRange(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Payment Journal Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(29; "Journal Voucher Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the JV  journal Template in the database';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(30; "Journal Voucher Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the JV  journal Batch in the database';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Voucher Template"));
        }
        field(31; "Default Cash Sale Customer"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(32; "Investment Dep. Jnl Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Investment Deposit Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(33; "Investment Dep. Jnl Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Investment Deposit Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Investment Dep. Jnl Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Receipt Journal Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(34; "Investment Int. Jnl Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Investment Interest Template';
            TableRelation = "Gen. Journal Template";
        }
        field(35; "Investment Int. Jnl Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Investmen Interest Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Investment Int. Jnl Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Receipt Journal Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
        field(36; "Investment Recall Jnl Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Investment Recall Jnl Template';
            TableRelation = "Gen. Journal Template";
        }
        field(37; "Investment Recall Jnl Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Investment Recall Jnl Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Investment Recall Jnl Template"));

            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another user*/

                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp.UserID <> Rec.UserID) and ("Receipt Journal Batch" <> '') then begin
                            Error(ErrorTextSameBatch);
                        end;
                    until UserTemp.Next = 0;
                end;

            end;
        }
    }

    keys
    {
        key(Key1; UserID)
        {
        }
    }

    fieldgroups
    {
    }

    var
        UserTemp: Record "Cash Office User Template";
        LoginMgt: Codeunit "User Management";
        ErrorTextSameBatch: Label 'Please note that another user has been assigned the same batch.';
    //TextInvIntBatch: Text[30]; 'InvestmenT Interest Batch';
}

