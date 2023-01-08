page 51533184 "HR Training Needs Card"
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approvals,Training Need';
    SourceTable = "HR Training Needs";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = FieldEditable;
                field("Code"; Rec.Code)
                {
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    NotBlank = true;
                    ShowMandatory = true;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ShowMandatory = true;
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Hrs per day"; Rec."Hrs per day")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Region Code';
                }
                field(Costs; Rec.Costs)
                {
                    Editable = false;
                }
                field(Location; Rec.Location)
                {
                }
                field("Re-Assessment Date"; Rec."Re-Assessment Date")
                {
                }
                field("Need Source"; Rec."Need Source")
                {
                    ShowMandatory = true;
                }
                field(Provider; Rec.Provider)
                {
                }
                field("Internal Provider"; Rec."Internal Provider")
                {
                }
                field("External Provider"; Rec."External Provider")
                {
                }
                field("External Provider Name"; Rec."External Provider Name")
                {
                    ShowCaption = false;
                }
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ShowMandatory = false;
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ShowMandatory = true;
                }
                field("Qualification Description"; Rec."Qualification Description")
                {
                    Editable = false;
                }
                field(Closed; Rec.Closed)
                {
                }
            }
            group(Bonding)
            {
                Caption = 'Bonding';
                field("Bondage Required?"; Rec."Bondage Required?")
                {
                }
                field("Early Bonded Exit?"; Rec."Early Bonded Exit?")
                {
                }
                field("Bondage Start Date"; Rec."Bondage Start Date")
                {
                }
                field("Bondage Duration"; Rec."Bondage Duration")
                {
                }
                field("Bondage Release Date"; Rec."Bondage Release Date")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control26; Outlook)
            {
            }
            systempart(Control25; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Training Costs")
                {
                    Caption = 'Training Costs';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HR Training Cost";
                    RunPageLink = "Training ID" = FIELD(Code);
                }
                action("Training Bonding Conditions")
                {
                    Caption = 'Training Bonding Conditions';
                    Image = BOM;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //RunObject = Page "HR Training Bonding Cond. List";
                    //RunPageLink = "Training Bonding Code" = FIELD(Code);
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Close)
                {
                    Image = Close;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm(Txt001, true) = false then exit;
                        Rec.Closed := true;
                    end;
                }
                action("Re-Open")
                {
                    Image = OpenJournal;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm(Txt002, true) = false then exit;
                        Rec.Closed := false;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControls;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
    end;

    trigger OnInit()
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        UpdateControls;
    end;

    var
        //HRTrainingBondingCond: Record "HR Training Bonding Conditions";
        FieldEditable: Boolean;
        Txt001: Label 'Do you want to close this training need?';
        Txt002: Label 'Do you want to reopen this training need?';

    local procedure UpdateControls()
    begin
        if Rec.Closed = true then begin
            FieldEditable := false;
        end else begin
            FieldEditable := true;
        end;
    end;
}

