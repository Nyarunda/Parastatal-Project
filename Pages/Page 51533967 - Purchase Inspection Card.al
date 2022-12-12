page 51533917 "Purchase Inspection Card"
{
    PageType = Card;
    SourceTable = "Purch. Inspection Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";Rec."No.")
                {
                    Editable = false;
                }
                field("Order No.";Rec."Order No.")
                {
                }
                field("Inspection Committtee No.";Rec."Inspection Committtee No.")
                {
                }
                field("Buy-from Vendor No.";Rec."Buy-from Vendor No.")
                {
                }
                field("Buy-from Vendor Name";Rec."Buy-from Vendor Name")
                {
                }
                field("Posting Date";Rec."Posting Date")
                {
                }
                field(Status;Rec.Status)
                {
                    Editable = false;
                }
            }
            part(Control9;"Purchase Inspection lines")
            {
                Editable = false;
                SubPageLink = "Document No."=FIELD("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Fu&nctions")
            {
                Caption = 'Fu&nctions';
                action(Approvals)
                {
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        DocumentType:=0;
                        ApprovalEntries.Setfilters(DATABASE::"Purch. Inspection Header",DocumentType,Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(SendApprovalRequest)
                {
                    Caption = '&Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VarVariant: Variant;
                    begin
                        VarVariant := Rec;
                        //if CustomApprovalsCodeunit.CheckApprovalsWorkflowEnabled(VarVariant) then
                          //CustomApprovalsCodeunit.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = '&Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        //CustomApprovalsCodeunit.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action("Inspection Committee list")
                {
                    Caption = 'Inspection Committee list';
                    Image = Form;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Tender Activity Participants";
                    RunPageLink = "Document No."=FIELD("Inspection Committtee No.");

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
                action(SendInspectionCertificate)
                {
                    Caption = 'Send Certificate';
                    Image = SendAsPDF;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VarVariant: Variant;
                    begin
                        Rec.TestField(Status,Rec.Status::Released);
                              Vend.Reset;
                              Vend.SetRange("No.",Rec."Buy-from Vendor No.");
                              if Vend.FindFirst then
                              MyRecordRef.Open(51533957);
                              MyFieldRef := MyRecordRef.Field(3);
                              MyFieldRef.SetRange(Rec."No.");
                              MyRecordRef.Find('-');

                              //EmailMgt.SendEmailInspection(Vend."E-Mail",51533138,MyRecordRef,Format('Purchase Inspection : '+Rec."No."));
                    end;
                }
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VarVariant: Variant;
                    begin
                        Rec.Reset;
                        Rec.SetRange("No.",Rec."No.");
                        if Rec.FindFirst then
                          REPORT.Run(51533166,true,false,Rec);
                    end;
                }
                action("Send Email to Members")
                {
                    Caption = 'Send Email to Members';
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to send email to inspection members?',true) then  begin
                          QuotationAnalysisLines.Reset;
                          QuotationAnalysisLines.SetRange(Code,Rec."No.");
                          if QuotationAnalysisLines.FindFirst then begin repeat
                            Emp.Reset;
                            Emp.SetRange("No.",QuotationAnalysisLines."Staff Code");
                            if Vend.FindFirst then begin
                        //SMTP.CreateMessage('ERPINFO','',Emp."Company E-Mail",'Inspection Notification','You have been selected as a member in inspection, '+Rec."No."+' ' ,true);
                        SMTP.Send();
                        Message('Email sent to inspection members');
                        end;
                        until QuotationAnalysisLines.Next=0;
                        end;
                        end;
                    end;
                }
            }
        }
    }

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Payment Voucher","Petty Cash",Interbank,Receipt,Surrender,"Staff Claim","Staff Advance",AdvanceSurrender,"Express Pv",Requisition,Transport,Imprest,JV,"Job Order","Store Req",Legal,LeaveApp,TrainingApp,Vacancy,EmpConfi,Grievance,Disciplinary,Tneed,EmpSep,MON,PTW,PoolCar,CrdAssess,"Job Approval",Inspection,RFQ,EmpTransfer,Inspect;
        ApprovalEntries: Page "Approval Entries";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Inspect: Record "Purch. Inspection Header";
        SMTP: Codeunit "SMTP Mail";
        HRSetup: Record "HR Setup";
        CTEXTURL: Text[30];
        HREmp: Record "HR Employees";
        HREmailParameters: Record "HR E-Mail Parameters";
        ContractDesc: Text[30];
        HRLookupValues: Record "HR Lookup Values";
        DimValue: Record "Dimension Value";
        objEmp: Record "HR Employees";
        VarVariant: Variant;
        //CustomApprovalsCodeunit: Codeunit "Custom Approvals Codeunit2";
        Vend: Record Vendor;
        //EmailMgt: Codeunit "Posting Check FP";
        MyRecordRef: RecordRef;
        MyFieldRef: FieldRef;
        SMTPMail: Codeunit "SMTP Mail";
        QuotationAnalysisLines: Record "Inspection Analysis Members";
        Emp: Record "HR Employees";
}

