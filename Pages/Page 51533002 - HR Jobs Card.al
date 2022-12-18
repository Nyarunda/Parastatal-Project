page 51533002 "HR Jobs Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Job,Job Succession';
    SourceTable = "HR Jobs";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = FieldEditable;
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                    Caption = 'Job Title';
                    Importance = Promoted;
                }
                group(Control17)
                {
                    ShowCaption = false;
                    grid(Control16)
                    {
                        GridLayout = Rows;
                        ShowCaption = false;
                        group(Control15)
                        {
                            ShowCaption = false;
                            field("Position Reporting to"; Rec."Position Reporting to")
                            {
                                Importance = Promoted;
                            }
                            field("Position Reporting Name"; Rec."Position Reporting Name")
                            {
                                ShowCaption = false;
                            }
                        }
                    }
                }
                field(Grade; Rec.Grade)
                {
                }
                field("No of Posts"; Rec."No of Posts")
                {
                    Importance = Promoted;
                }
                field("Occupied Positions"; Rec."Occupied Positions")
                {
                    Importance = Promoted;
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    Importance = Promoted;
                }
                group(Control13)
                {
                    ShowCaption = false;
                    grid(Control12)
                    {
                        GridLayout = Rows;
                        ShowCaption = false;
                        group(Control11)
                        {
                            ShowCaption = false;
                            field("Responsibility Center"; Rec."Responsibility Center")
                            {
                            }
                            field("Responsibility Center Name"; Rec."Responsibility Center Name")
                            {
                            }
                        }
                    }
                }
                field("Employee Requisitions"; Rec."Employee Requisitions")
                {
                    Editable = false;
                }
                field("Date Created"; Rec."Date Created")
                {
                    Editable = false;
                    Style = Attention;
                }
                field(Status; Rec.Status)
                {
                    Editable = true;
                    Importance = Promoted;
                    Style = Attention;
                }
                field("Marked for Succession"; Rec."Marked for Succession")
                {
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                Editable = FieldEditable;
                group(Control29)
                {
                    ShowCaption = false;
                    grid(Control10)
                    {
                        GridLayout = Rows;
                        ShowCaption = false;
                        group(Control9)
                        {
                            ShowCaption = false;
                            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                            {
                            }
                            field("Global Dimension 1 Name"; Rec."Global Dimension 1 Name")
                            {
                                ShowCaption = false;
                            }
                        }
                    }
                }
                group(Control6)
                {
                    ShowCaption = false;
                    grid(Control5)
                    {
                        GridLayout = Rows;
                        ShowCaption = false;
                        group(Control4)
                        {
                            ShowCaption = false;
                            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                            {
                            }
                            field("Global Dimension 2 Name"; Rec."Global Dimension 2 Name")
                            {
                                ShowCaption = false;
                            }
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            //part(Control1102755004; "HR Jobs Factbox")
            //{
            //SubPageLink = Rec."Job Description" = FIELD("Job ID");
            //}
            systempart(Control1102755006; Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                action("Job Requirements")
                {
                    Caption = 'Job Requirements';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //RunObject = Page "HR Job Requirement Lines";
                    //RunPageLink = "Job ID" = FIELD("Job ID");
                }
                action(Responsibilities)
                {
                    Caption = 'Responsibilities';
                    Image = JobResponsibility;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //RunObject = Page "HR Job Responsiblities Lines";
                    //RunPageLink = "Job ID" = FIELD("Job ID");
                }
                action(Occupants)
                {
                    Caption = 'Occupants';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Category5;
                    //RunObject = Page "HR Job Occupants";
                    //RunPageLink = Rec."Job ID"=FIELD("Job ID");
                }
                action("Succession Requirements")
                {
                    Caption = 'Succession Requirements';
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Category6;
                    //RunObject = Page "Two Stage Tendering List- Rele";
                    //RunPageLink = Field2=FIELD("Job ID");
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(SendApproval)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TestField("No of Posts");
                        Rec.TestField("Responsibility Center");

                        Rec.CalcFields("No. of Requirements");
                        if Rec."No. of Requirements" = 0 then Error('Please Specify the Job Requirements');
                        Rec.CalcFields("No. of Responsibilities");

                        if Rec."No. of Responsibilities" = 0 then Error('Please Specify the Job Responsibilities');
                        VarVariant := Rec;
                        //if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        //    CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Jobs,"Employee Req",Employees,Promotion,Confirmation,"Employee Transfer","Asset Transfer","Transport Req",Overtime,"Training App","Leave App";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action(CancelApproval)
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        //CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;

        Rec.Validate(Rec."Vacant Positions");
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
        HREmployees: Record "HR Employees";
        FieldEditable: Boolean;
        //CustomApprovals: Codeunit "Custom Approval Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        VarVariant: Variant;

    local procedure UpdateControls()
    begin
        if (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::"Pending Approval") then begin
            FieldEditable := false;
        end else begin
            FieldEditable := true;
        end;
    end;

    procedure RecordLinkCheck(job: Record "HR Jobs") RecordLnkExist: Boolean
    var
        objRecordLnk: Record "Record Link";
        TableCaption: RecordID;
        objRecord_Link: RecordRef;
    begin
        objRecord_Link.GetTable(job);
        TableCaption := objRecord_Link.RecordId;
        objRecordLnk.Reset;
        objRecordLnk.SetRange(objRecordLnk."Record ID", TableCaption);
        if objRecordLnk.Find('-') then exit(true) else exit(false);
    end;
}

