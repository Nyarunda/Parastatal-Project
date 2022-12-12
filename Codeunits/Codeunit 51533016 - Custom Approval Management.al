codeunit 51533016 "Custom Approval Management"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';
        OnSendPaymentApprovalRequestTxt: Label 'Approval of a Payment is requested';
        RunWorkflowOnSendPaymentForApprovalCode: Label 'RUNWORKFLOWONSENDPAYMENTFORAPPROVAL';
        OnCancelPaymentApprovalRequestTxt: Label 'An Approval of a Payment is canceled';
        RunWorkflowOnCancelPaymentForApprovalCode: Label 'RUNWORKFLOWONCANCELPAYMENTFORAPPROVAL';
        OnSendInterbankApprovalRequestTxt: Label 'Approval of a Interbank is requested';
        RunWorkflowOnSendInterbankForApprovalCode: Label 'RUNWORKFLOWONSENDINTERBANKFORAPPROVAL';
        OnCancelInterbankApprovalRequestTxt: Label 'An Approval of a Interbank is canceled';
        RunWorkflowOnCancelInterbankForApprovalCode: Label 'RUNWORKFLOWONCANCELINTERBANKFORAPPROVAL';
        OnSendStaffClaimApprovalRequestTxt: Label 'Approval of a Staff Claim is requested';
        RunWorkflowOnSendStaffClaimForApprovalCode: Label 'RUNWORKFLOWONSENDSTAFFCLAIMFORAPPROVAL';
        OnCancelStaffClaimApprovalRequestTxt: Label 'An Approval of a Staff Claim is canceled';
        RunWorkflowOnCancelStaffClaimForApprovalCode: Label 'RUNWORKFLOWONCANCELSTAFFCLAIMFORAPPROVAL';
        OnSendStaffAdvanceApprovalRequestTxt: Label 'Approval of a Staff Advance is requested';
        RunWorkflowOnSendStaffAdvanceForApprovalCode: Label 'RUNWORKFLOWONSENDSTAFFADVANCEFORAPPROVAL';
        OnCancelStaffAdvanceApprovalRequestTxt: Label 'An Approval of a Staff Advance is canceled';
        RunWorkflowOnCancelStaffAdvanceForApprovalCode: Label 'RUNWORKFLOWONCANCELSTAFFADVANCEFORAPPROVAL';
        OnSendStaffAdvanceSurrenderApprovalRequestTxt: Label 'Approval of a Staff Advance Surrender is requested';
        RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode: Label 'RUNWORKFLOWONSENDSTAFFADVANCESURRENDERFORAPPROVAL';
        OnCancelStaffAdvanceSurrenderApprovalRequestTxt: Label 'An Approval of a Staff Advance Surrender is canceled';
        RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode: Label 'RUNWORKFLOWONCANCELSTAFFADVANCESURRENDERFORAPPROVAL';
        OnSendStoreRequisitionApprovalRequestTxt: Label 'Approval of a Store Requisition is requested';
        RunWorkflowOnSendStoreRequisitionForApprovalCode: Label 'RUNWORKFLOWONSENDSTOREREQUISITIONFORAPPROVAL';
        OnCancelStoreRequisitionApprovalRequestTxt: Label 'An Approval of a Store Requisition is canceled';
        RunWorkflowOnCancelStoreRequisitionForApprovalCode: Label 'RUNWORKFLOWONCANCELSTOREREQUISITIONFORAPPROVAL';
        OnSendImprestApprovalRequestTxt: Label 'Approval of a Imprest is requested';
        RunWorkflowOnSendImprestForApprovalCode: Label 'RUNWORKFLOWONSENDIMPRESTFORAPPROVAL';
        OnCancelImprestApprovalRequestTxt: Label 'An Approval of a Imprest is canceled';
        RunWorkflowOnCancelImprestForApprovalCode: Label 'RUNWORKFLOWONCANCELIMPRESTFORAPPROVAL';
        OnSendImprestSurrenderApprovalRequestTxt: Label 'Approval of a Imprest Surrender is requested';
        RunWorkflowOnSendImprestSurrenderForApprovalCode: Label 'RUNWORKFLOWONSENDIMPRESTSURRENDERFORAPPROVAL';
        OnCancelImprestSurrenderApprovalRequestTxt: Label 'An Approval of a Imprest Surrender is canceled';
        RunWorkflowOnCancelImprestSurrenderForApprovalCode: Label 'RUNWORKFLOWONCANCELIMPRESTSURRENDERFORAPPROVAL';
        OnSendOvertimeApprovalRequestTxt: Label 'Approval of a Overtime is requested';
        RunWorkflowOnSendOvertimeForApprovalCode: Label 'RUNWORKFLOWONSENDOVERTIMEFORAPPROVAL';
        OnCancelOvertimeApprovalRequestTxt: Label 'An Approval of a Overtime is canceled';
        RunWorkflowOnCancelOvertimeForApprovalCode: Label 'RUNWORKFLOWONCANCELOVERTIMEFORAPPROVAL';
        OnSendBudgetApprovalRequestTxt: Label 'Approval of a Budget is requested';
        RunWorkflowOnSendBudgetForApprovalCode: Label 'RUNWORKFLOWONSENDBUDGETFORAPPROVAL';
        OnCancelBudgetApprovalRequestTxt: Label 'An Approval of a Budget is canceled';
        RunWorkflowOnCancelBudgetForApprovalCode: Label 'RUNWORKFLOWONCANCELBUDGETFORAPPROVAL';
        OnSendVoteApprovalRequestTxt: Label 'Approval of a Vote Transfer is requested';
        RunWorkflowOnSendVoteForApprovalCode: Label 'RUNWORKFLOWONSENDVOTEFORAPPROVAL';
        OnCancelVoteApprovalRequestTxt: Label 'An Approval of a Vote is canceled';
        RunWorkflowOnCancelVoteForApprovalCode: Label 'RUNWORKFLOWEmailquestedONCANCELVOTEFORAPPROVAL';
        OnSendWorkplanApprovalRequestTxt: Label 'Approval of a Workplan is requested';
        RunWorkflowOnSendWorkplanForApprovalCode: Label 'RUNWORKFLOWONSENDWORKPLANFORAPPROVAL';
        OnCancelWorkplanApprovalRequestTxt: Label 'An Approval of a Workplan is canceled';
        RunWorkflowOnCancelWorkplanForApprovalCode: Label 'RUNWORKFLOWONCANCELWORKPLANFORAPPROVAL';
        OnSendAssetTransferApprovalRequestTxt: Label 'An Approval of an Asset Transfer is requested';
        RunWorkflowOnSendAssetTransferForApprovalCode: Label 'RUNWORKFLOWONSENDASSETTRANSFERFORAPPROVAL';
        OnCancelAssetTransferApprovalRequestTxt: Label 'An Approval of an Asset Transfer is canceled';
        RunWorkflowOnCancelAssetTransferForApprovalCode: Label 'RUNWORKFLOWONCANCELASSETTRANSFERFORAPPROVAL';
        OnSendRFQApprovalRequestTxt: Label 'An Approval of a RFQ is reParticipant Emailquested';
        RunWorkflowOnSendRFQForApprovalCode: Label 'RUNWORKFLOWONSENDRFQFORAPPROVAL';
        OnCancelRFQApprovalRequestTxt: Label 'An Approval of an RFQ is canceled';
        RunWorkflowOnCancelRFQForApprovalCode: Label 'RUNWORKFLOWONCANCELRFQFORAPPROVAL';
        OnSendDisposalApprovalRequestTxt: Label 'An Approval of a Disposal is requested';
        RunWorkflowOnSendDisposalForApprovalCode: Label 'RUNWORKFLOWONSENDDISPOSALFORAPPROVAL';
        OnCancelDisposalApprovalRequestTxt: Label 'An Approval of an Disposal is canceled';
        RunWorkflowOnCancelDisposalForApprovalCode: Label 'RUNWORKFLOWONCANCELDISPOSALFORAPPROVAL';
        //"********Disposal**": ;
        OnSendDisposalPlanApprovalRequestTxt: Label 'An Approval of a Disposal Plan is requested';
        RunWorkflowOnSendDisposalPlanForApprovalCode: Label 'RUNWORKFLOWONSENDDISPOSALPLANFORAPPROVAL';
        OnCancelDisposalPlanApprovalRequestTxt: Label 'An Approval of an Disposal Plan is canceled';
        RunWorkflowOnCancelDisposalPlanForApprovalCode: Label 'RUNWORKFLOWONCANCELDISPOSALPLANFORAPPROVAL';
        //"***Disposal**": ;
        //"**CoreTec Hr**": ;
        OnSendHrJobsApprovalRequestTxt: Label 'An Approval Request for a Job Position has been requested.';
        RunWorkflowOnSendHrJobsForApprovalCode: Label 'RUNWORKFLOWONSENDHRJOBSFORAPPROVAL';
        OnCancelHrJobsApprovalRequestTxt: Label 'An Approval Request for a Job Position has been cancelled.';
        RunWorkflowOnCancelHrJobsForApprovalCode: Label 'RUNWORKFLOWONCANCELHRJOBSFORAPPROVAL';
        OnSendHrEmployeeReqApprovalRequestTxt: Label 'An Approval request for Employee Requsition is Requested.';
        RunWorkflowOnSendHrEmployeeReqForApprovalCode: Label 'RUNWORKFLOWONSENDHREMPLOYEEREQFORAPPROVAL';
        OnCancelHrEmployeeReqApprovalRequestTxt: Label 'An Approval request for Employee Requsition is Cancelled';
        RunWorkflowOnCancelHrEmployeeReqForApprovalCode: Label 'RUNWORKFLOWONCANCELHREMPLOYEEREQFORAPPROVAL';
        OnSendHrLeaveApprovalRequestTxt: Label 'An Approval Request for Leave application has been Requested.';
        RunWorkflowOnSendHrLeaveForApprovalCode: Label 'RUNWORKFLOWONSENDHRLEAVEFORAPPROVAL';
        OnCancelHrLeaveApprovalRequestTxt: Label 'An Approval Request for Leave Application has been Cancelled';
        RunWorkflowOnCancelHrLeaveForApprovalCode: Label 'RUNWORKFLOWONCANCELHRLEAVEFORAPPROVAL';
        OnSendHrTrainingApprovalRequestTxt: Label 'An Approval Request for Training application has been Requested.';
        RunWorkflowOnSendHrTrainingForApprovalCode: Label 'RUNWORKFLOWONSENDHRTRAININGFORAPPROVAL';
        OnCancelHrTrainingApprovalRequestTxt: Label 'An Approval Request for Training Application has been Cancelled';
        RunWorkflowOnCancelHrTrainingForApprovalCode: Label 'RUNWORKFLOWONCANCELHRTRAININGFORAPPROVAL';
        OnSendHrTransportApprovalRequestTxt: Label 'An Approval Request for Transport Requisition has been Requested.';
        RunWorkflowOnSendHrTransportForApprovalCode: Label 'RUNWORKFLOWONSENDHRTRANSPORTFORAPPROVAL';
        OnCancelHrTransportApprovalRequestTxt: Label 'An Approval Request for Transport Requisition has been Cancelled';
        RunWorkflowOnCancelHrTransportForApprovalCode: Label 'RUNWORKFLOWONCANCELHRTRANSPORTFORAPPROVAL';
        OnSendHrEmpTransApprovalRequestTxt: Label 'An Approval Request for Employee Transfer has been Requested.';
        RunWorkflowOnSendHrEmpTransForApprovalCode: Label 'RUNWORKFLOWONSENDHREMPTRANSFORAPPROVAL';
        OnCancelHrEmpTransApprovalRequestTxt: Label 'An Approval Request for Employee Transfer has been Cancelled.';
        RunWorkflowOnCancelHrEmpTransForApprovalCode: Label 'RUNWORKFLOWONCANCELHREMPTRANSFORAPPROVAL';
        OnSendHrPromotionApprovalRequestTxt: Label 'An Approval Request for Employee Promotion has been requested.';
        RunWorkflowOnSendHrPromotionForApprovalCode: Label 'RUNWORKFLOWONSENDHRPROMOTIONFORAPPROVAL';
        OnCancelHrPromotionApprovalRequestTxt: Label 'An Approval Request for Employee Promotion has been cancelled.';
        RunWorkflowOnCancelHrPromotionForApprovalCode: Label 'RUNWORKFLOWONCANCELHRPROMOTIONFORAPPROVAL';
        OnSendHrConfirmationApprovalRequestTxt: Label 'An Approval Request for Employee Confirmation has been requested.';
        RunWorkflowOnSendHrConfirmationForApprovalCode: Label 'RUNWORKFLOWONSENDHRCONFIRMATIONFORAPPROVAL';
        OnCancelHrConfirmationApprovalRequestTxt: Label 'Approval Request for Employee Confirmation has been cancelled.';
        RunWorkflowOnCancelHrConfirmationForApprovalCode: Label 'RUNWORKFLOWONCANCELHRCONFIRMATIONFORAPPROVAL';
        //"**********Employee": ;
        EmployeeSendForApprovalEventDescTxt: Label 'An Approval Request for the Employee has been requested.';
        EmployeeApprovalRequestCancelEventDescTxt: Label 'An Approval Request for the Employee has been Cancelled.';
        EmployeeChangedTxt: Label 'A Employee record is changed.';
        //"***Investment*****": ;
        OnSendInvestimentApprovalRequestTxt: Label 'An Approval Request for Investiment application has been Requested.';
        RunWorkflowOnSendInvestimentForApprovalCode: Label 'RUNWORKFLOWONSENDINVESTIMENTFORAPPROVAL';
        OnCancelInvestimentApprovalRequestTxt: Label 'An Approval Request for Investiment Application has been Cancelled';
        RunWorkflowOnCancelInvestimentForApprovalCode: Label 'RUNWORKFLOWONCANCELINVESTIMENTFORAPPROVAL';
        //"****Leave Reinbursement***": ;
        OnSendHrLeaveReinbApprovalRequestTxt: Label 'An Approval Request for Leave Reinbursement application has been Requested.';
        RunWorkflowOnSendHrLeaveReinForApprovalCode: Label 'RUNWORKFLOWONSENDHRLEAVEREINBURSEMENTFORAPPROVAL';
        OnCancelHrLeaveReinApprovalRequestTxt: Label 'An Approval Request for Leave Reinbursement Application has been Cancelled';
        RunWorkflowOnCancelHrLeaveReinForApprovalCode: Label 'RUNWORKFLOWONCANCELHRLEAVEREINBURSEMENTFORAPPROVAL';
        //"******StaffLoan": ;
        OnSendStaffLoanAppApprovalRequestTxt: Label 'Approval of Staff Loan Application is requested';
        RunWorkflowOnSendStaffLoansForApprovalCode: Label 'RUNWORKFLOWONSENDStaffLoanAppFORAPPROVAL';
        OnCancelStaffLoanAppApprovalRequestTxt: Label 'An Approval of Staff Loan Application is canceled';
        RunWorkflowOnCancelStaffLoanAppForApprovalCode: Label 'RUNWORKFLOWONCANCELStaffLoanAppFORAPPROVAL';
        //"********Inspection**": ;
        OnSendInspectionPlanApprovalRequestTxt: Label 'An Approval of a Inspection Plan is requested';
        RunWorkflowOnSendInspectionPlanForApprovalCode: Label 'RUNWORKFLOWONSENDINSPECTIONPLANFORAPPROVAL';
        OnCancelInspectionPlanApprovalRequestTxt: Label 'An Approval of an Inspection Plan is canceled';
        RunWorkflowOnCancelInspectionPlanForApprovalCode: Label 'RUNWORKFLOWONCANCELINSPECTIONPLANFORAPPROVAL';
        //"***Inspection**": ;
        OnSendPerdiemApprovalRequestTxt: Label 'Approval of a Perdiem is requested';
        RunWorkflowOnSendPerdiemForApprovalCode: Label 'RUNWORKFLOWONSENDPerdiemFORAPPROVAL';
        OnCancelPerdiemApprovalRequestTxt: Label 'An Approval of a Perdiem is canceled';
        RunWorkflowOnCancelPerdiemForApprovalCode: Label 'RUNWORKFLOWONCANCELPerdiemFORAPPROVAL';
        //"Bid Analysis***": ;
        OnSendBIDApprovalRequestTxt: Label 'Approval of Bid Anaylsis is requested';
        RunWorkflowOnSendBIDForApprovalCode: Label 'RUNWORKFLOWONSENDBIDFORAPPROVAL';
        OnCancelBIDApprovalRequestTxt: Label 'An Approval of Bid Analysis is canceled';
        RunWorkflowOnCancelBIDForApprovalCode: Label 'RUNWORKFLOWONCANCELBIDFORAPPROVAL';
        //"Employee Card*****": ;
        OnSendStaffApprovalRequestTxt: Label 'An Approval Request for Staff has been Requested.';
        RunWorkflowOnSendStaffForApprovalCode: Label 'RUNWORKFLOWONSENDStaffFORAPPROVAL';
        OnCancelStaffApprovalRequestTxt: Label 'An Approval Request for Staff has been Cancelled';
        RunWorkflowOnCancelStaffForApprovalCode: Label 'RUNWORKFLOWONCANCELStaffFORAPPROVAL';
        //"HS Complain*****": ;
        OnSendComplainApprovalRequestTxt: Label 'An Approval Request for Complain has been Requested.';
        RunWorkflowOnSendComplainForApprovalCode: Label 'RUNWORKFLOWONSENDComplainFORAPPROVAL';
        OnCancelComplainApprovalRequestTxt: Label 'An Approval Request for Complain has been Cancelled';
        RunWorkflowOnCancelComplainForApprovalCode: Label 'RUNWORKFLOWONCANCELComplainFORAPPROVAL';
        //"Evants*****": ;
        OnSendEventsApprovalRequestTxt: Label 'An Approval Request for Events has been Requested.';
        RunWorkflowOnSendEventsForApprovalCode: Label 'RUNWORKFLOWONSENDEventsFORAPPROVAL';
        OnCancelEventsApprovalRequestTxt: Label 'An Approval Request for Events has been Cancelled';
        RunWorkflowOnCancelEventsForApprovalCode: Label 'RUNWORKFLOWONCANCELEventsFORAPPROVAL';
        //"StaffOvertime*****": ;
        OnSendStaffOvertimeApprovalRequestTxt: Label 'An Approval Request for StaffOvertime has been Requested.';
        RunWorkflowOnSendStaffOvertimeForApprovalCode: Label 'RUNWORKFLOWONSENDStaffOvertimeFORAPPROVAL';
        OnCancelStaffOvertimeApprovalRequestTxt: Label 'An Approval Request for StaffOvertime has been Cancelled';
        RunWorkflowOnCancelStaffOvertimeForApprovalCode: Label 'RUNWORKFLOWONCANCELStaffOvertimeFORAPPROVAL';
        //"FleetService*****": ;
        OnSendFleetServiceOrderApprovalRequestTxt: Label 'An Approval Request for FleetServiceOrder has been Requested.';
        RunWorkflowOnSendFleetServiceOrderForApprovalCode: Label 'RUNWORKFLOWONSENDFleetServiceOrderFORAPPROVAL';
        OnCancelFleetServiceOrderApprovalRequestTxt: Label 'An Approval Request for FleetServiceOrder has been Cancelled';
        RunWorkflowOnCancelFleetServiceOrderForApprovalCode: Label 'RUNWORKFLOWONCANCELFleetServiceOrderFORAPPROVAL';
        //"Grievances***": ;
        OnSendGrievanceApprovalRequestTxt: Label 'An Approval Request for Grievance has been Requested.';
        RunWorkflowOnSendGrievanceForApprovalCode: Label 'RUNWORKFLOWONSENDGrievanceFORAPPROVAL';
        OnCancelGrievanceApprovalRequestTxt: Label 'An Approval Request for Grievance has been Cancelled';
        RunWorkflowOnCancelGrievanceForApprovalCode: Label 'RUNWORKFLOWONCANCELGrievanceFORAPPROVAL';
        //"Repairs*****": ;
        OnSendRepairsApprovalRequestTxt: Label 'An Approval Request for Repairs has been Requested.';
        RunWorkflowOnSendRepairsForApprovalCode: Label 'RUNWORKFLOWONSENDRepairsFORAPPROVAL';
        OnCancelRepairsApprovalRequestTxt: Label 'An Approval Request for Repairs has been Cancelled';
        RunWorkflowOnCancelRepairsForApprovalCode: Label 'RUNWORKFLOWONCANCELRepairsFORAPPROVAL';
        //"SecurityOB***": ;
        OnSendOBApprovalRequestTxt: Label 'An Approval Request for OB has been Requested.';
        RunWorkflowOnSendOBForApprovalCode: Label 'RUNWORKFLOWONSENDOBFORAPPROVAL';
        OnCancelOBApprovalRequestTxt: Label 'An Approval Request for OB has been Cancelled';
        RunWorkflowOnCancelOBForApprovalCode: Label 'RUNWORKFLOWONCANCELOBFORAPPROVAL';
        //"SchoolVehicleInspection***": ;
        OnSendSchoolVehicleInspectionApprovalRequestTxt: Label 'An Approval Request forSchoolVehicleInspection has been Requested.';
        RunWorkflowOnSendSchoolVehicleInspectionForApprovalCode: Label 'RUNWORKFLOWONSENDSchoolVehicleInspectionFORAPPROVAL';
        OnCancelSchoolVehicleInspectionApprovalRequestTxt: Label 'An Approval Request for School vehicle has been Cancelled';
        RunWorkflowOnCancelSchoolVehicleInspectionForApprovalCode: Label 'RUNWORKFLOWONCANCELSchoolVehicleInspectionFORAPPROVAL';
        //"FuelOrder***": ;
        OnSendFuelOrderApprovalRequestTxt: Label 'An Approval Request for FuelOrder has been Requested.';
        RunWorkflowOnSendFuelOrderForApprovalCode: Label 'RUNWORKFLOWONSENDFuelOrderFORAPPROVAL';
        OnCancelFuelOrderApprovalRequestTxt: Label 'An Approval Request for FuelOrder has been Cancelled';
        RunWorkflowOnCancelFuelOrderForApprovalCode: Label 'RUNWORKFLOWONCANCELFuelOrderFORAPPROVAL';
        //"Mechanics***": ;
        OnSendMechanicsApprovalRequestTxt: Label 'An Approval Request for Mechanics has been Requested.';
        RunWorkflowOnSendMechanicsForApprovalCode: Label 'RUNWORKFLOWONSENDMechanicsFORAPPROVAL';
        OnCancelMechanicsApprovalRequestTxt: Label 'An Approval Request for Mechanics has been Cancelled';
        RunWorkflowOnCancelMechanicsForApprovalCode: Label 'RUNWORKFLOWONCANCELMechanicsFORAPPROVAL';
        //"ProfessionalOpinion***": ;
        OnSendProfessionalOpinionApprovalRequestTxt: Label 'An Approval Request for Professional Opinion has been Requested.';
        RunWorkflowOnSendProfessionalOpinionForApprovalCode: Label 'RUNWORKFLOWONSENDProfessional OpinionFORAPPROVAL';
        OnCancelProfessionalOpinionApprovalRequestTxt: Label 'An Approval Request for Professional Opinion has been Cancelled';
        RunWorkflowOnCancelProfessionalOpinionForApprovalCode: Label 'RUNWORKFLOWONCANCELProfessionalOpinionFORAPPROVAL';
        "E-Tender Company Information***": Label 'E-TenderCompanyInformation';
        "OnSendE-TenderCompanyInformationApprovalRequestTxt": Label 'An Approval Request foE-TenderCompanyInformation has been Requested.';
        "RunWorkflowOnSendE-TenderCompanyInformationForApprovalCode": Label 'RUNWORKFLOWONSENDE-TenderCompanyInformationFORAPPROVAL';
        "OnCancelE-TenderCompanyInformationApprovalRequestTxt": Label 'An Approval Request for E-TenderCompanyInformation has been Cancelled';
        "RunWorkflowOnCancelE-TenderCompanyInformationForApprovalCode": Label 'RUNWORKFLOWONCANCELE-TenderCompanyInformationFORAPPROVAL';
        //"Contracts Header***": ;
        "OnSendContracts HeaderRequestTxt": Label 'An Approval Request for Contracts Header has been Requested.';
        "RunWorkflowOnSendContracts HeaderForApprovalCode": Label 'RUNWORKFLOWONSENDContracts HeaderFORAPPROVAL';
        "OnCancelContracts HeaderApprovalRequestTxt": Label 'An Approval Request for Contracts Header has been Cancelled';
        "RunWorkflowOnCancelContracts HeaderForApprovalCode": Label 'RUNWORKFLOWONCANCELContracts HeaderFORAPPROVAL';
        //"Market Survey***": ;
        OnSendMarketSurveyApprovalRequestTxt: Label 'An Approval Request for Market Survey has been Requested.';
        "RunWorkflowOnSendMarket SurveyForApprovalCode": Label 'RUNWORKFLOWONSENDMarket Survey FOR APPROVAL';
        "OnCancelMarket SurveyApprovalRequestTxt": Label 'An Approval Request for Market Survey has been Cancelled';
        "RunWorkflowOnCancelMarket SurveyForApprovalCode": Label 'RUNWORKFLOWONCANCELMarket SurveyFORAPPROVAL';
        //"**Tender Committee Activities***": ;
        OnSendTenderComApprovalRequestTxt: Label 'An Approval Request forTender Committee has been Requested.';
        RunWorkflowOnSendTenderComForApprovalCode: Label 'RUNWORKFLOWONSENDTender Committee FOR APPROVAL';
        OnCancelTenderComApprovalRequestTxt: Label 'An Approval Request for Tender Committee has been Cancelled';
        RunWorkflowOnCancelTenderComForApprovalCode: Label 'RUNWORKFLOWONCANCELTender CommitteeFORAPPROVAL';
        //"**Evaluation Committee Activities***": ;
        OnSendEvaluationComApprovalRequestTxt: Label 'An Approval Request forEvaluation Committee has been Requested.';
        RunWorkflowOnSendEvaluationComForApprovalCode: Label 'RUNWORKFLOWONSENDEvaluation Committee FOR APPROVAL';
        OnCancelEvaluationComApprovalRequestTxt: Label 'An Approval Request for Evaluation Committee has been Cancelled';
        RunWorkflowOnCancelEvaluationComForApprovalCode: Label 'RUNWORKFLOWONCANCELEvaluation CommitteeFORAPPROVAL';
        //"**Inspection Committee Activities***": ;
        OnSendInspectionComApprovalRequestTxt: Label 'An Approval Request forInspection Committee has been Requested.';
        RunWorkflowOnSendInspectionComForApprovalCode: Label 'RUNWORKFLOWONSENDInspection Committee FOR APPROVAL';
        OnCancelInspectionComApprovalRequestTxt: Label 'An Approval Request for Inspection Committee has been Cancelled';
        RunWorkflowOnCanceInspectionComForApprovalCode: Label 'RUNWORKFLOWONCANCELInspection CommitteeFORAPPROVAL';
        //"**Disposal Committee Activities***": ;
        OnSendDisposalComApprovalRequestTxt: Label 'An Approval Request forDisposal Committee has been Requested.';
        RunWorkflowOnSendDisposalComForApprovalCode: Label 'RUNWORKFLOWONSENDDisposal Committee FOR APPROVAL';
        OnCancelDisposalComApprovalRequestTxt: Label 'An Approval Request for Disposal Committee has been Cancelled';
        RunWorkflowOnCanceDisposalComForApprovalCode: Label 'RUNWORKFLOWONCANCELDisposal CommitteeFORAPPROVAL';
        //"***Financial Evaluation Header****": ;
        "OnSendFinancial Evaluation HeaderApprovalRequestTxt": Label 'An Approval Request for Financial Evaluation Header has been Requested.';
        "RunWorkflowOnSendFinancial Evaluation HeaderForApprovalCode": Label 'RUNWORKFLOWONSENDFinancial Evaluation Header FOR APPROVAL';
        "OnCancelFinancial Evaluation HeaderApprovalRequestTxt": Label 'An Approval Request for Financial Evaluation Header has been Cancelled';
        "RunWorkflowOnCancelFinancial Evaluation HeaderForApprovalCode": Label 'RUNWORKFLOWONCANCELFinancial Evaluation HeaderFORAPPROVAL';

    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Payments Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendPaymentForApprovalCode));
            DATABASE::"InterBank Transfers":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendInterbankForApprovalCode));
            DATABASE::"Staff Claims Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffClaimForApprovalCode));
            //Contracts Header
            DATABASE::"Contracts Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, "RunWorkflowOnSendContracts HeaderForApprovalCode"));

            DATABASE::"Staff Advance Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffAdvanceForApprovalCode));
            DATABASE::"Staff Advance Surrender Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode));
            DATABASE::"Imprest Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendImprestForApprovalCode));
            DATABASE::"Imprest Surrender Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendImprestSurrenderForApprovalCode));
            DATABASE::"HR Overtime Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendOvertimeForApprovalCode));
            DATABASE::"Store Requistion Header2":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStoreRequisitionForApprovalCode));
            //E-TenderCompanyInformation
            DATABASE::"E-Tender Company Information":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, "RunWorkflowOnSendE-TenderCompanyInformationForApprovalCode"));
            DATABASE::"G/L Budget Name":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendBudgetForApprovalCode));
            DATABASE::Workplan:
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendWorkplanForApprovalCode));
            DATABASE::"Vote Transfer":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendVoteForApprovalCode));
            //Purchase Quote Header (RFQ)
            DATABASE::"Purchase Quote Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendRFQForApprovalCode));
            DATABASE::"Perdiem Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendPerdiemForApprovalCode));
            DATABASE::"Quotation Analysis Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendBIDForApprovalCode));
            //Disposal
            DATABASE::"Disposal Plan Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendDisposalPlanForApprovalCode));
            //Disposal
            //Disposal 2
            DATABASE::"Disposal Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendDisposalForApprovalCode));
            //Disposal 2
            /*  //Inspection
            DATABASE::"Inspection Header":
              EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendInspectionDeptForApprovalCode));
            //Inspection
          */
            //Investiment
            DATABASE::"Bank Account":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendInvestimentForApprovalCode));
            //HR
            //Leave

            DATABASE::"HR Leave Application":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrLeaveForApprovalCode));
            //Employee Card
            DATABASE::"HR-Employee":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffForApprovalCode));
            //Events
            DATABASE::"HK Event Requisition":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendEventsForApprovalCode));

            DATABASE::"HR Employee Grievance":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendGrievanceForApprovalCode));
            //Overtime
            DATABASE::"Overtime Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffOvertimeForApprovalCode));
            //Complain
            DATABASE::"HK Complains":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendComplainForApprovalCode));
            //OB
            DATABASE::"Security OB":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendOBForApprovalCode));
            //Professional Opinion
            DATABASE::"Professional Opinion":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendProfessionalOpinionForApprovalCode));
            //Market Survey
            DATABASE::"Market Survey Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, "RunWorkflowOnSendMarket SurveyForApprovalCode"));

            //Tender Committee
            DATABASE::"Tender Committee Activities":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTenderComForApprovalCode));


            //Evaluation Committee
            DATABASE::"Evaluation Committee Activity":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendEvaluationComForApprovalCode));

            //Inspection Committee
            DATABASE::"Inspection Committee Activity":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendInspectionComForApprovalCode));

            //Disposal Committee
            DATABASE::"Disposal Committee Activity":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendDisposalComForApprovalCode));


            //Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, "RunWorkflowOnSendFinancial Evaluation HeaderForApprovalCode"));

            DATABASE::"Fuel Requisition":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendFuelOrderForApprovalCode));
            DATABASE::"TRansport Mechanics":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendMechanicsForApprovalCode));
            //SchoolVehicleInspection
            DATABASE::"Security V Inspection Register":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendSchoolVehicleInspectionForApprovalCode));

            DATABASE::"Repair Schedule Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendRepairsForApprovalCode));
            //Fleet order
            DATABASE::"Wshp Service Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendFleetServiceOrderForApprovalCode));
            //Leave Reinbursement
            DATABASE::"HR Leave Reimbursement":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrLeaveReinForApprovalCode));
            //Leave Reinbursement
            DATABASE::"HR Jobs":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrJobsForApprovalCode));

            DATABASE::"HR Training App Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrTrainingForApprovalCode));

            DATABASE::"HR Employee Requisitions":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrEmployeeReqForApprovalCode));

            DATABASE::"HR Employee Transfer Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrEmpTransForApprovalCode));

            DATABASE::"HR Promo. Recommend Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrPromotionForApprovalCode));

            DATABASE::"HR Transport Requisition":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrTransportForApprovalCode));

            DATABASE::"HR Asset Transfer Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendAssetTransferForApprovalCode));

            DATABASE::"HR Employee Confirmation":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrConfirmationForApprovalCode));

            //Staff loans
            //DATABASE::"prSalary Advance":
            //EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendStaffLoansForApprovalCode));

            //HR
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant; CheckApprovalsWorkflowTxt: Text): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        begin
            if not WorkflowManagement.CanExecuteWorkflow(Variant, CheckApprovalsWorkflowTxt) then
                Error(NoWorkflowEnabledErr);
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDocForApproval(var Variant: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDocApprovalRequest(var Variant: Variant)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendPaymentForApprovalCode, DATABASE::"Payments Header", OnSendPaymentApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPaymentForApprovalCode, DATABASE::"Payments Header", OnCancelPaymentApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInterbankForApprovalCode, DATABASE::"InterBank Transfers", OnSendInterbankApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelInterbankForApprovalCode, DATABASE::"InterBank Transfers", OnCancelInterbankApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffClaimForApprovalCode, DATABASE::"Staff Claims Header", OnSendStaffClaimApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffClaimForApprovalCode, DATABASE::"Staff Claims Header", OnCancelStaffClaimApprovalRequestTxt, 0, false);

        //E-TenderCompanyInformation
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnSendE-TenderCompanyInformationForApprovalCode", DATABASE::"E-Tender Company Information", "OnSendE-TenderCompanyInformationApprovalRequestTxt", 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnCancelE-TenderCompanyInformationForApprovalCode", DATABASE::"E-Tender Company Information", "OnCancelE-TenderCompanyInformationApprovalRequestTxt", 0, false);
        //Contracts Header
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnSendContracts HeaderForApprovalCode", DATABASE::"Contracts Header", "OnSendContracts HeaderRequestTxt", 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnCancelContracts HeaderForApprovalCode", DATABASE::"Contracts Header", "OnCancelContracts HeaderApprovalRequestTxt", 0, false);


        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffAdvanceForApprovalCode, DATABASE::"Staff Advance Header", OnSendStaffAdvanceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffAdvanceForApprovalCode, DATABASE::"Staff Advance Header", OnCancelStaffAdvanceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode, DATABASE::"Staff Advance Surrender Header", OnSendStaffAdvanceSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode, DATABASE::"Staff Advance Surrender Header", OnCancelStaffAdvanceSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendImprestForApprovalCode, DATABASE::"Imprest Header", OnSendImprestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImprestForApprovalCode, DATABASE::"Imprest Header", OnCancelImprestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendImprestSurrenderForApprovalCode, DATABASE::"Imprest Surrender Header", OnSendImprestSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImprestSurrenderForApprovalCode, DATABASE::"Imprest Surrender Header", OnCancelImprestSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStoreRequisitionForApprovalCode, DATABASE::"Store Requistion Header2", OnSendStoreRequisitionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStoreRequisitionForApprovalCode, DATABASE::"Store Requistion Header2", OnCancelStoreRequisitionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendOvertimeForApprovalCode, DATABASE::"HR Overtime Header", OnSendOvertimeApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelOvertimeForApprovalCode, DATABASE::"HR Overtime Header", OnCancelOvertimeApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendBudgetForApprovalCode, DATABASE::"G/L Budget Name", OnSendBudgetApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelBudgetForApprovalCode, DATABASE::"G/L Budget Name", OnCancelBudgetApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendWorkplanForApprovalCode, DATABASE::Workplan, OnSendWorkplanApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelWorkplanForApprovalCode, DATABASE::Workplan, OnCancelWorkplanApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendVoteForApprovalCode, DATABASE::"Vote Transfer", OnSendVoteApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelVoteForApprovalCode, DATABASE::"Vote Transfer", OnCancelVoteApprovalRequestTxt, 0, false);
        //Purchase Quote Header (RFQ)
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendRFQForApprovalCode, DATABASE::"Purchase Quote Header", OnSendRFQApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelRFQForApprovalCode, DATABASE::"Purchase Quote Header", OnCancelRFQApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendPerdiemForApprovalCode, DATABASE::"Perdiem Header", OnSendPerdiemApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPerdiemForApprovalCode, DATABASE::"Perdiem Header", OnCancelPerdiemApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendBIDForApprovalCode, DATABASE::"Quotation Analysis Header", OnSendBIDApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelBIDForApprovalCode, DATABASE::"Quotation Analysis Header", OnCancelBIDApprovalRequestTxt, 0, false);


        //Disposal
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendDisposalPlanForApprovalCode, DATABASE::"Disposal Plan Header", OnSendDisposalPlanApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelDisposalPlanForApprovalCode, DATABASE::"Disposal Plan Header", OnCancelDisposalPlanApprovalRequestTxt, 0, false);
        //Disposal
        //Disposal 2
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendDisposalForApprovalCode, DATABASE::"Disposal Header", OnSendDisposalApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelDisposalForApprovalCode, DATABASE::"Disposal Header", OnCancelDisposalApprovalRequestTxt, 0, false);
        /*
        //Inspection
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInspectionDeptForApprovalCode,DATABASE::"Inspection Header",OnSendInspectionDeptApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelInspectioneptForApprovalCode,DATABASE::"Inspection Header",OnCancelInspectionDeptApprovalRequestTxt,0,FALSE);
        //Inspection
        */

        //Investiment
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInvestimentForApprovalCode, DATABASE::"Bank Account", OnSendInvestimentApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelInvestimentForApprovalCode, DATABASE::"Bank Account", OnCancelInvestimentApprovalRequestTxt, 0, false);


        //HR mm
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrLeaveForApprovalCode, DATABASE::"HR Leave Application", OnSendHrLeaveApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrLeaveForApprovalCode, DATABASE::"HR Leave Application", OnCancelHrLeaveApprovalRequestTxt, 0, false);
        //Employee card
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffForApprovalCode, DATABASE::"HR-Employee", OnSendStaffApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffForApprovalCode, DATABASE::"HR-Employee", OnCancelStaffApprovalRequestTxt, 0, false);
        //Events
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendEventsForApprovalCode, DATABASE::"HK Event Requisition", OnSendEventsApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelEventsForApprovalCode, DATABASE::"HK Event Requisition", OnCancelEventsApprovalRequestTxt, 0, false);
        //Grievance
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendGrievanceForApprovalCode, DATABASE::"HR Employee Grievance", OnSendGrievanceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelGrievanceForApprovalCode, DATABASE::"HR Employee Grievance", OnCancelGrievanceApprovalRequestTxt, 0, false);
        //Overtime
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffOvertimeForApprovalCode, DATABASE::"Overtime Header", OnSendStaffOvertimeApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffOvertimeForApprovalCode, DATABASE::"Overtime Header", OnCancelStaffOvertimeApprovalRequestTxt, 0, false);
        //Complains
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendComplainForApprovalCode, DATABASE::"HK Complains", OnSendComplainApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelComplainForApprovalCode, DATABASE::"HK Complains", OnCancelComplainApprovalRequestTxt, 0, false);
        //OB
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendOBForApprovalCode, DATABASE::"Security OB", OnSendOBApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelOBForApprovalCode, DATABASE::"Security OB", OnCancelOBApprovalRequestTxt, 0, false);
        //Professional Opinion
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendProfessionalOpinionForApprovalCode, DATABASE::"Professional Opinion", OnSendProfessionalOpinionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelProfessionalOpinionForApprovalCode, DATABASE::"Professional Opinion", OnCancelProfessionalOpinionApprovalRequestTxt, 0, false);

        //market Survey
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnSendMarket SurveyForApprovalCode", DATABASE::"Market Survey Header", OnSendMarketSurveyApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnCancelMarket SurveyForApprovalCode", DATABASE::"Market Survey Header", "OnCancelMarket SurveyApprovalRequestTxt", 0, false);


        //Tender Committee
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendTenderComForApprovalCode, DATABASE::"Tender Committee Activities", OnSendTenderComApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTenderComForApprovalCode, DATABASE::"Tender Committee Activities", OnCancelTenderComApprovalRequestTxt, 0, false);

        //Evaluation Committee
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendEvaluationComForApprovalCode, DATABASE::"Evaluation Committee Activity", OnSendEvaluationComApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelEvaluationComForApprovalCode, DATABASE::"Evaluation Committee Activity", OnCancelEvaluationComApprovalRequestTxt, 0, false);

        //Inspection Committee
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInspectionComForApprovalCode, DATABASE::"Inspection Committee Activity", OnSendInspectionComApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCanceInspectionComForApprovalCode, DATABASE::"Inspection Committee Activity", OnCancelInspectionComApprovalRequestTxt, 0, false);

        //Disposal Committee
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendDisposalComForApprovalCode, DATABASE::"Disposal Committee Activity", OnSendDisposalComApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCanceDisposalComForApprovalCode, DATABASE::"Disposal Committee Activity", OnCancelDisposalComApprovalRequestTxt, 0, false);


        //Financial Evaluation Header
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnSendFinancial Evaluation HeaderForApprovalCode", DATABASE::"Financial Evaluation Header", "OnSendFinancial Evaluation HeaderApprovalRequestTxt", 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        "RunWorkflowOnCancelFinancial Evaluation HeaderForApprovalCode", DATABASE::"Financial Evaluation Header", "OnCancelFinancial Evaluation HeaderApprovalRequestTxt", 0, false);

        //fuel order
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendFuelOrderForApprovalCode, DATABASE::"Fuel Requisition", OnSendFuelOrderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelFuelOrderForApprovalCode, DATABASE::"Fuel Requisition", OnCancelFuelOrderApprovalRequestTxt, 0, false);
        //Mechanics
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendMechanicsForApprovalCode, DATABASE::"TRansport Mechanics", OnSendMechanicsApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelMechanicsForApprovalCode, DATABASE::"TRansport Mechanics", OnCancelMechanicsApprovalRequestTxt, 0, false);
        //SchoolVehicleInspection
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendSchoolVehicleInspectionForApprovalCode, DATABASE::"Security V Inspection Register", OnSendSchoolVehicleInspectionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelSchoolVehicleInspectionForApprovalCode, DATABASE::"Security V Inspection Register", OnCancelSchoolVehicleInspectionApprovalRequestTxt, 0, false);
        //Repair schedule
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendRepairsForApprovalCode, DATABASE::"Repair Schedule Header", OnSendRepairsApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelRepairsForApprovalCode, DATABASE::"Repair Schedule Header", OnCancelRepairsApprovalRequestTxt, 0, false);
        //Fleet Order
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendFleetServiceOrderForApprovalCode, DATABASE::"Wshp Service Header", OnSendFleetServiceOrderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelFleetServiceOrderForApprovalCode, DATABASE::"Wshp Service Header", OnCancelFleetServiceOrderApprovalRequestTxt, 0, false);
        //Rein
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrLeaveReinForApprovalCode, DATABASE::"HR Leave Reimbursement", OnSendHrLeaveReinbApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrLeaveReinForApprovalCode, DATABASE::"HR Leave Reimbursement", OnCancelHrLeaveReinApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrJobsForApprovalCode, DATABASE::"HR Jobs", OnSendHrJobsApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrJobsForApprovalCode, DATABASE::"HR Jobs", OnCancelHrJobsApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrTrainingForApprovalCode, DATABASE::"HR Training App Header", OnSendHrTrainingApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrTrainingForApprovalCode, DATABASE::"HR Training App Header", OnCancelHrTrainingApprovalRequestTxt, 0, false);


        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrEmployeeReqForApprovalCode, DATABASE::"HR Employee Requisitions", OnSendHrEmployeeReqApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrEmployeeReqForApprovalCode, DATABASE::"HR Employee Requisitions", OnCancelHrEmployeeReqApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrEmpTransForApprovalCode, DATABASE::"HR Employee Transfer Header", OnSendHrEmpTransApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrEmpTransForApprovalCode, DATABASE::"HR Employee Transfer Header", OnCancelHrEmpTransApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrPromotionForApprovalCode, DATABASE::"HR Promo. Recommend Header", OnSendHrPromotionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrPromotionForApprovalCode, DATABASE::"HR Promo. Recommend Header", OnCancelHrPromotionApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrTransportForApprovalCode, DATABASE::"HR Transport Requisition", OnSendHrTransportApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrTransportForApprovalCode, DATABASE::"HR Transport Requisition", OnCancelHrTransportApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendAssetTransferForApprovalCode, DATABASE::"HR Asset Transfer Header", OnSendAssetTransferApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelAssetTransferForApprovalCode, DATABASE::"HR Asset Transfer Header", OnCancelAssetTransferApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrConfirmationForApprovalCode, DATABASE::"HR Employee Confirmation", OnSendHrConfirmationApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrConfirmationForApprovalCode, DATABASE::"HR Employee Confirmation", OnCancelHrConfirmationApprovalRequestTxt, 0, false);

        /*//staff loans
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffLoansForApprovalCode,DATABASE::"prSalary Advance",OnSendStaffLoanAppApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffLoanAppForApprovalCode,DATABASE::"prSalary Advance",OnCancelStaffLoanAppApprovalRequestTxt,0,FALSE); //*/
        //HR

    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, 51533016, 'OnSendDocForApproval', '', false, false)]
    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Payments Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentForApprovalCode, Variant);
            DATABASE::"InterBank Transfers":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendInterbankForApprovalCode, Variant);
            DATABASE::"Staff Claims Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffClaimForApprovalCode, Variant);
            //E-Tender company Information
            DATABASE::"E-Tender Company Information":
                WorkflowManagement.HandleEvent("RunWorkflowOnSendE-TenderCompanyInformationForApprovalCode", Variant);
            //Contracts Header
            DATABASE::"Contracts Header":
                WorkflowManagement.HandleEvent("RunWorkflowOnSendContracts HeaderForApprovalCode", Variant);

            DATABASE::"Staff Advance Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffAdvanceForApprovalCode, Variant);
            DATABASE::"Staff Advance Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode, Variant);
            DATABASE::"Imprest Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestForApprovalCode, Variant);
            DATABASE::"Imprest Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestSurrenderForApprovalCode, Variant);
            DATABASE::"Store Requistion Header2":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStoreRequisitionForApprovalCode, Variant);
            DATABASE::"HR Overtime Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendOvertimeForApprovalCode, Variant);
            DATABASE::"G/L Budget Name":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendBudgetForApprovalCode, Variant);
            DATABASE::Workplan:
                WorkflowManagement.HandleEvent(RunWorkflowOnSendWorkplanForApprovalCode, Variant);
            DATABASE::"Vote Transfer":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendVoteForApprovalCode, Variant);
            DATABASE::"Purchase Quote Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendRFQForApprovalCode, Variant);
            DATABASE::"Perdiem Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendPerdiemForApprovalCode, Variant);
            DATABASE::"Quotation Analysis Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendBIDForApprovalCode, Variant);


            DATABASE::"Disposal Plan Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendDisposalPlanForApprovalCode, Variant);
            //Disposal
            //Disposal 2
            DATABASE::"Disposal Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendDisposalForApprovalCode, Variant);
            /*  //Inspection
            DATABASE::"Inspection Header":
            WorkflowManagement.HandleEvent(RunWorkflowOnSendInspectionDeptForApprovalCode,Variant);
            //Inspection*/

            //Investiment
            DATABASE::"Bank Account":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendInvestimentForApprovalCode, Variant);
            //HR

            DATABASE::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrLeaveForApprovalCode, Variant);

            DATABASE::"HR-Employee":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffForApprovalCode, Variant);

            DATABASE::"HK Complains":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendComplainForApprovalCode, Variant);

            DATABASE::"Security OB":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendOBForApprovalCode, Variant);
            //Professional Opinion
            DATABASE::"Professional Opinion":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendProfessionalOpinionForApprovalCode, Variant);

            //Market Survey
            DATABASE::"Market Survey Header":
                WorkflowManagement.HandleEvent("RunWorkflowOnSendMarket SurveyForApprovalCode", Variant);

            //Tender Committee
            DATABASE::"Tender Committee Activities":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTenderComForApprovalCode, Variant);

            //Evaluation Committee
            DATABASE::"Evaluation Committee Activity":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendEvaluationComForApprovalCode, Variant);

            //Inspection Committee
            DATABASE::"Inspection Committee Activity":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendInspectionComForApprovalCode, Variant);

            //Disposal Committee
            DATABASE::"Disposal Committee Activity":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendDisposalComForApprovalCode, Variant);

            //Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                WorkflowManagement.HandleEvent("RunWorkflowOnSendFinancial Evaluation HeaderForApprovalCode", Variant);


            DATABASE::"Fuel Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendFuelOrderForApprovalCode, Variant);

            DATABASE::"TRansport Mechanics":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendMechanicsForApprovalCode, Variant);


            DATABASE::"Repair Schedule Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendRepairsForApprovalCode, Variant);

            DATABASE::"Wshp Service Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendFleetServiceOrderForApprovalCode, Variant);

            DATABASE::"HK Event Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendEventsForApprovalCode, Variant);

            DATABASE::"HR Employee Grievance":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendGrievanceForApprovalCode, Variant);

            DATABASE::"Overtime Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffOvertimeForApprovalCode, Variant);

            DATABASE::"HR Leave Reimbursement":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrLeaveReinForApprovalCode, Variant);

            DATABASE::"HR Jobs":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrJobsForApprovalCode, Variant);

            DATABASE::"HR Training App Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrTrainingForApprovalCode, Variant);

            DATABASE::"HR Employee Requisitions":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrEmployeeReqForApprovalCode, Variant);

            DATABASE::"HR Employee Transfer Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrEmpTransForApprovalCode, Variant);

            DATABASE::"HR Promo. Recommend Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrPromotionForApprovalCode, Variant);

            DATABASE::"HR Transport Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrTransportForApprovalCode, Variant);

            DATABASE::"HR Asset Transfer Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendAssetTransferForApprovalCode, Variant);

            DATABASE::"HR Employee Confirmation":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrConfirmationForApprovalCode, Variant);

            //Staff Loan
            //  DATABASE::"prSalary Advance":
            //     WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffLoansForApprovalCode,Variant); //


            //HR

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, 51533016, 'OnCancelDocApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Payments Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentForApprovalCode, Variant);
            DATABASE::"InterBank Transfers":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelInterbankForApprovalCode, Variant);
            //E-TenderCompanyInformation
            DATABASE::"E-Tender Company Information":
                WorkflowManagement.HandleEvent("RunWorkflowOnCancelE-TenderCompanyInformationForApprovalCode", Variant);
            //Contracts Header
            DATABASE::"Contracts Header":
                WorkflowManagement.HandleEvent("RunWorkflowOnCancelContracts HeaderForApprovalCode", Variant);

            DATABASE::"Staff Claims Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffClaimForApprovalCode, Variant);
            DATABASE::"Staff Advance Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffAdvanceForApprovalCode, Variant);
            DATABASE::"Staff Advance Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode, Variant);
            DATABASE::"Imprest Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestForApprovalCode, Variant);
            DATABASE::"Imprest Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestSurrenderForApprovalCode, Variant);
            DATABASE::"Store Requistion Header2":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStoreRequisitionForApprovalCode, Variant);
            DATABASE::"HR Overtime Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelOvertimeForApprovalCode, Variant);
            DATABASE::"G/L Budget Name":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelBudgetForApprovalCode, Variant);
            DATABASE::Workplan:
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelWorkplanForApprovalCode, Variant);
            DATABASE::"Vote Transfer":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelVoteForApprovalCode, Variant);
            DATABASE::"Purchase Quote Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelRFQForApprovalCode, Variant);
            DATABASE::"Perdiem Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPerdiemForApprovalCode, Variant);
            DATABASE::"Quotation Analysis Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelBIDForApprovalCode, Variant);

            //Disposal
            DATABASE::"Disposal Plan Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelDisposalPlanForApprovalCode, Variant);
            DATABASE::"Disposal Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelDisposalForApprovalCode, Variant);
            //Disposal
            /*
            //Inspection
            DATABASE::"Inspection Header":
              WorkflowManagement.HandleEvent(RunWorkflowOnCancelInspectioneptForApprovalCode,Variant);
            //Inespection*/
            //Investiment
            DATABASE::"Bank Account":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelInvestimentForApprovalCode, Variant);
            //HR
            DATABASE::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrLeaveForApprovalCode, Variant);

            DATABASE::"HR-Employee":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffForApprovalCode, Variant);

            DATABASE::"HK Complains":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelComplainForApprovalCode, Variant);

            DATABASE::"Security OB":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelOBForApprovalCode, Variant);
            //Professional Opinion
            DATABASE::"Professional Opinion":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelProfessionalOpinionForApprovalCode, Variant);

            //Market Survey
            DATABASE::"Market Survey Header":
                WorkflowManagement.HandleEvent("RunWorkflowOnCancelMarket SurveyForApprovalCode", Variant);

            //Tender Committee
            DATABASE::"Tender Committee Activities":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTenderComForApprovalCode, Variant);

            //Evaluation Committee
            DATABASE::"Evaluation Committee Activity":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelEvaluationComForApprovalCode, Variant);

            //Inspection Committee
            DATABASE::"Inspection Committee Activity":
                WorkflowManagement.HandleEvent(RunWorkflowOnCanceInspectionComForApprovalCode, Variant);

            //Disposal Committee
            DATABASE::"Disposal Committee Activity":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelDisposalForApprovalCode, Variant);


            //Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                WorkflowManagement.HandleEvent("RunWorkflowOnCancelFinancial Evaluation HeaderForApprovalCode", Variant);

            DATABASE::"Fuel Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelFuelOrderForApprovalCode, Variant);

            DATABASE::"TRansport Mechanics":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelMechanicsForApprovalCode, Variant);


            DATABASE::"Repair Schedule Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelRepairsForApprovalCode, Variant);

            DATABASE::"Wshp Service Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelFleetServiceOrderForApprovalCode, Variant);

            DATABASE::"HK Event Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelEventsForApprovalCode, Variant);

            DATABASE::"HR Employee Grievance":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelGrievanceForApprovalCode, Variant);

            DATABASE::"Overtime Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffOvertimeForApprovalCode, Variant);

            DATABASE::"HR Jobs":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrJobsForApprovalCode, Variant);
            DATABASE::"HR Training App Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrTrainingForApprovalCode, Variant);

            DATABASE::"HR Employee Requisitions":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrEmployeeReqForApprovalCode, Variant);

            DATABASE::"HR Employee Transfer Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrEmpTransForApprovalCode, Variant);
            DATABASE::"HR Promo. Recommend Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrPromotionForApprovalCode, Variant);
            DATABASE::"HR Transport Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrTransportForApprovalCode, Variant);
            DATABASE::"HR Asset Transfer Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelAssetTransferForApprovalCode, Variant);
            DATABASE::"HR Employee Confirmation":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrConfirmationForApprovalCode, Variant);

            DATABASE::"HR Leave Reimbursement":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrLeaveReinForApprovalCode, Variant);

            //StaffLoan
            //  DATABASE::"prSalary Advance":
            //     WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffLoanAppForApprovalCode,Variant); //

            //HR
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    procedure ReOpen(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record "Payments Header";
        StaffClaimsHeader: Record "Staff Claims Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        OvertimeClaimHeader: Record "Purchase Header";
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        Budget: Record "G/L Budget Name";
        Workplan: Record Workplan;
        Vote: Record "Vote Transfer";
        Hrleave: Record "HR Leave Application";
        Hrjobs: Record "HR Jobs";
        HrTraining: Record "HR Training App Header";
        HrReq: Record "HR Employee Requisitions";
        HrEmpTrans: Record "HR Employee Transfer Header";
        HrPromo: Record "HR Promo. Recommend Header";
        HrTransport: Record "HR Transport Requisition";
        HrAssetTrans: Record "HR Asset Transfer Header";
        HrEmpConfirm: Record "HR Employee Confirmation";
        Invest: Record "Bank Account";
        HrLeaveRein: Record "HR Leave Reimbursement";
        Disposal: Record "Disposal Plan Header";
        DisposalHeader: Record "Disposal Header";
        StaffLoan: Record "Purchase Header";
        Inspection: Record "Purchase Header";
        Perdiem: Record "Perdiem Header";
        QuotationAHeader: Record "Quotation Analysis Header";
        HREmployee: Record "HR-Employee";
        HROvertimeHeader: Record "HR Overtime Header";
        HKComplains: Record "HK Complains";
        HKEventRequisition: Record "HK Event Requisition";
        Overtimeheader: Record "Overtime Header";
        WshpServiceHeader: Record "Wshp Service Header";
        HREmployeeGrievance: Record "HR Employee Grievance";
        Repairs: Record "Repair Schedule Header";
        SecurityOB: Record "Security OB";
        FuelRequisition: Record "Fuel Requisition";
        Transportmechanics: Record "TRansport Mechanics";
        ProfOpi: Record "Professional Opinion";
        "E-Tender": Record "E-Tender Company Information";
        "Cont Header": Record "Contracts Header";
        MSurvey: Record "Market Survey Header";
        TCOM: Record "Tender Committee Activities";
        ECOM: Record "Evaluation Committee Activity";
        ICOM: Record "Inspection Committee Activity";
        DCOM: Record "Disposal Committee Activity";
        FEH: Record "Financial Evaluation Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Payments Header":
                begin
                    RecRef.SetTable(PaymentsHeader);
                    PaymentsHeader.Validate(Status, PaymentsHeader.Status::Pending);
                    PaymentsHeader.Modify;
                    SendRejectionEmail(PaymentsHeader."No.", PaymentsHeader."Payment Narration", PaymentsHeader.Cashier);
                    Variant := PaymentsHeader;
                end;
            //E-Tender Company Information
            DATABASE::"E-Tender Company Information":
                begin
                    RecRef.SetTable("E-Tender");
                    "E-Tender".Validate(Status, "E-Tender".Status::Open);
                    "E-Tender".Modify;
                    Variant := "E-Tender";
                end;

            //Contracts Header
            DATABASE::"Contracts Header":
                begin
                    RecRef.SetTable("Cont Header");
                    "Cont Header".Validate(Status, "Cont Header"."Approval Status"::Open);
                    "Cont Header".Modify;
                    Variant := "Cont Header";
                end;

            DATABASE::"Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaimsHeader);
                    StaffClaimsHeader.Validate(Status, StaffClaimsHeader.Status::Pending);
                    StaffClaimsHeader.Modify;
                    SendRejectionEmail(StaffClaimsHeader."No.", StaffClaimsHeader.Purpose, StaffClaimsHeader.Cashier);
                    Variant := StaffClaimsHeader;
                end;
            DATABASE::"Staff Advance Header":
                begin
                    RecRef.SetTable(StaffAdvanceHeader);
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::Pending);
                    StaffAdvanceHeader.Modify;
                    SendRejectionEmail(StaffAdvanceHeader."No.", StaffAdvanceHeader.Purpose, StaffAdvanceHeader.Cashier);
                    Variant := StaffAdvanceHeader;
                end;
            DATABASE::"Staff Advance Surrender Header":
                begin
                    RecRef.SetTable(StaffAdvanceSurrenderHeader);
                    StaffAdvanceSurrenderHeader.Validate(Status, StaffAdvanceSurrenderHeader.Status::Pending);
                    StaffAdvanceSurrenderHeader.Modify;
                    SendRejectionEmail(StaffAdvanceSurrenderHeader.No, StaffAdvanceSurrenderHeader.Remarks, StaffAdvanceSurrenderHeader.Cashier);
                    Variant := StaffAdvanceSurrenderHeader;
                end;
            DATABASE::"Imprest Header":
                begin
                    RecRef.SetTable(ImprestHeader);
                    ImprestHeader.Validate(Status, ImprestHeader.Status::Open);
                    ImprestHeader.Modify;
                    //SendRejectionEmail(ImprestHeader."No.",ImprestHeader.Purpose,ImprestHeader.Cashier);
                    Variant := ImprestHeader;
                end;
            DATABASE::"Imprest Surrender Header":
                begin
                    RecRef.SetTable(ImprestSurrenderHeader);
                    ImprestSurrenderHeader.Validate(Status, ImprestSurrenderHeader.Status::Pending);
                    ImprestSurrenderHeader.Modify;
                    SendRejectionEmail(ImprestSurrenderHeader.No, ImprestSurrenderHeader.Remarks, ImprestSurrenderHeader.Cashier);
                    Variant := ImprestSurrenderHeader;
                end;
            DATABASE::"Store Requistion Header2":
                begin
                    RecRef.SetTable(StoreRequistionHeader);
                    StoreRequistionHeader.Validate(Status, StoreRequistionHeader.Status::Open);
                    StoreRequistionHeader.Modify;
                    Variant := StoreRequistionHeader;
                end;
            DATABASE::"InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);
                    InterBankTransfers.Validate(Status, InterBankTransfers.Status::Open);
                    InterBankTransfers.Modify;
                    Variant := InterBankTransfers;
                end;
            DATABASE::"HR Overtime Header":
                begin
                    RecRef.SetTable(HROvertimeHeader);
                    HROvertimeHeader.Validate(Status, HROvertimeHeader.Status::"Pending Approval");
                    HROvertimeHeader.Modify;
                    Variant := HROvertimeHeader;
                end;
            //RFQ open
            DATABASE::"Purchase Quote Header":
                begin
                    RecRef.SetTable(PurchaseQuoteHeader);
                    PurchaseQuoteHeader.Validate(Status, PurchaseQuoteHeader.Status::"Pending Approval");
                    PurchaseQuoteHeader.Modify;
                    SendRejectionEmail(PurchaseQuoteHeader."No.", PurchaseQuoteHeader."Posting Description", PurchaseQuoteHeader."Assigned User ID");
                    Variant := PurchaseQuoteHeader;
                end;
            /*
            DATABASE::"Purchase Quote Header":
              BEGIN
               RecRef.SETTABLE(PurchaseQuoteHeader);
               PurchaseQuoteHeader.VALIDATE(Status,PurchaseQuoteHeader.Status::"Pending Approval");
               PurchaseQuoteHeader.MODIFY;
               SendRejectionEmail(PurchaseQuoteHeader."No.",PurchaseQuoteHeader."Posting Description",PurchaseQuoteHeader."Assigned User ID");
               Variant := PurchaseQuoteHeader;
              END;
              */

            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SetTable(Budget);
                    //Budget.Validate(Status,Budget.Status::Open);
                    Budget.Modify;
                    Variant := Budget;
                end;

            DATABASE::Workplan:
                begin
                    RecRef.SetTable(Workplan);
                    Workplan.Validate(Status, Workplan.Status::Pending);
                    Workplan.Modify;
                    Variant := Workplan;
                end;

            DATABASE::"Vote Transfer":
                begin
                    RecRef.SetTable(Vote);
                    Vote.Validate(Status, Vote.Status::Open);
                    Vote.Modify;
                    Variant := Vote;
                end;
            DATABASE::"Perdiem Header":
                begin
                    RecRef.SetTable(Perdiem);
                    Perdiem.Validate(Status, Perdiem.Status::Pending);
                    Perdiem.Modify;
                    Perdiem.Fn_CancelBudget;
                    Variant := Perdiem;
                end;

            DATABASE::"Quotation Analysis Header":
                begin
                    RecRef.SetTable(QuotationAHeader);
                    QuotationAHeader.Validate(Status, QuotationAHeader.Status::Open);
                    QuotationAHeader.Modify;
                    Variant := QuotationAHeader;
                end;

            //Disposal
            DATABASE::"Disposal Plan Header":
                begin
                    RecRef.SetTable(Disposal);
                    Disposal.Validate(Status, Disposal.Status::Open);
                    Disposal.Modify;
                    Variant := Disposal;
                end;
            DATABASE::"Disposal Header":
                begin
                    RecRef.SetTable(DisposalHeader);
                    DisposalHeader.Validate(Status, DisposalHeader.Status::Open);
                    DisposalHeader.Modify;
                    Variant := DisposalHeader;
                end;
            //Disposal

            /*//Inspection
            DATABASE::"Inspection Header":
            BEGIN
            RecRef.SETTABLE(Inspection);
            Inspection.VALIDATE(Status,Inspection.Status::Open);
            Inspection.MODIFY;
            Variant:=Inspection;
            END;
            //Inspection*/
            //Investiment
            DATABASE::"Bank Account":
                begin
                    RecRef.SetTable(Invest);
                    //Invest.VALIDATE(Status,Invest.Status::Open);
                    Invest.Modify;
                    Variant := Invest;
                end;
            //HR

            DATABASE::"HR Leave Application":
                begin
                    RecRef.SetTable(Hrleave);
                    Hrleave.Validate(Status, Hrleave.Status::New);
                    Hrleave.Modify;
                    Variant := Hrleave;
                end;
            //Employee Card
            DATABASE::"HR-Employee":
                begin
                    RecRef.SetTable(HREmployee);
                    HREmployee.Validate(Status, HREmployee.Status::New);
                    HREmployee.Modify;
                    Variant := HREmployee;
                end;
            //Compains
            DATABASE::"HK Complains":
                begin
                    RecRef.SetTable(HKComplains);
                    HKComplains.Validate(Status, HKComplains.Status::New);
                    HKComplains.Modify;
                    Variant := HKComplains;
                end;
            // OB
            DATABASE::"Security OB":
                begin
                    RecRef.SetTable(SecurityOB);
                    SecurityOB.Validate(Status, SecurityOB.Status::New);
                    SecurityOB.Modify;
                    Variant := SecurityOB;
                end;
            // Professional Opinion
            DATABASE::"Professional Opinion":
                begin
                    RecRef.SetTable(ProfOpi);
                    ProfOpi.Validate(Status, ProfOpi.Status::Open);
                    ProfOpi.Modify;
                    Variant := ProfOpi;
                end;
            // Market Survey
            DATABASE::"Market Survey Header":
                begin
                    RecRef.SetTable(MSurvey);
                    MSurvey.Validate(Status, MSurvey.Status::Open);
                    MSurvey.Modify;
                    Variant := MSurvey;
                end;


            // Tender Commitee
            DATABASE::"Tender Committee Activities":
                begin
                    RecRef.SetTable(TCOM);
                    TCOM.Validate(Status, TCOM.Status::New);
                    TCOM.Modify;
                    Variant := TCOM;
                end;


            // Evaluation Commitee
            DATABASE::"Evaluation Committee Activity":
                begin
                    RecRef.SetTable(ECOM);
                    ECOM.Validate(Status, ECOM.Status::New);
                    ECOM.Modify;
                    Variant := ECOM;
                end;


            // Inspection Commitee
            DATABASE::"Inspection Committee Activity":
                begin
                    RecRef.SetTable(ICOM);
                    ICOM.Validate(Status, ICOM.Status::New);
                    ICOM.Modify;
                    Variant := ICOM;
                end;

            // Disposal Commitee
            DATABASE::"Disposal Committee Activity":
                begin
                    RecRef.SetTable(DCOM);
                    DCOM.Validate(Status, DCOM.Status::New);
                    DCOM.Modify;
                    Variant := DCOM;
                end;



            // Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                begin
                    RecRef.SetTable(FEH);
                    FEH.Validate(Status, FEH.Status::Open);
                    FEH.Modify;
                    Variant := FEH;
                end;

            //Fuel Order
            DATABASE::"Fuel Requisition":
                begin
                    RecRef.SetTable(FuelRequisition);
                    FuelRequisition.Validate(Status, FuelRequisition.Status::Open);
                    FuelRequisition.Modify;
                    Variant := FuelRequisition;
                end;
            //Mechanics
            DATABASE::"TRansport Mechanics":
                begin
                    RecRef.SetTable(Transportmechanics);
                    Transportmechanics.Validate(Status, Transportmechanics.Status::Open);
                    Transportmechanics.Modify;
                    Variant := Transportmechanics;
                end;
            //Repairs
            DATABASE::"Repair Schedule Header":
                begin
                    RecRef.SetTable(Repairs);
                    Repairs.Validate(Status, Repairs.Status::New);
                    Repairs.Modify;
                    Variant := Repairs;
                end;
            //Fleet Service
            DATABASE::"Wshp Service Header":
                begin
                    RecRef.SetTable(WshpServiceHeader);
                    WshpServiceHeader.Validate(Status, WshpServiceHeader.Status::Open);
                    WshpServiceHeader.Modify;
                    Variant := WshpServiceHeader;
                end;
            //Events
            DATABASE::"HK Event Requisition":
                begin
                    RecRef.SetTable(HKEventRequisition);
                    HKEventRequisition.Validate(Status, HKEventRequisition.Status::New);
                    HKEventRequisition.Modify;
                    Variant := HKEventRequisition;
                end;

            //Grievance
            DATABASE::"HR Employee Grievance":
                begin
                    RecRef.SetTable(HREmployeeGrievance);
                    HREmployeeGrievance.Validate(Status, HREmployeeGrievance.Status::New);
                    HREmployeeGrievance.Modify;
                    Variant := HREmployeeGrievance;
                end;
            //Overtime
            DATABASE::"Overtime Header":
                begin
                    RecRef.SetTable(Overtimeheader);
                    Overtimeheader.Validate(Status, Overtimeheader.Status::New);
                    Overtimeheader.Modify;
                    Variant := Overtimeheader;
                end;
            //Rein
            DATABASE::"HR Leave Reimbursement":
                begin
                    RecRef.SetTable(HrLeaveRein);
                    HrLeaveRein.Validate(Status, HrLeaveRein.Status::New);
                    HrLeaveRein.Modify;
                    Variant := HrLeaveRein;
                end;
            DATABASE::"HR Jobs":
                begin
                    RecRef.SetTable(Hrjobs);
                    Hrjobs.Validate(Status, Hrjobs.Status::New);
                    Hrjobs.Modify;
                    Variant := Hrjobs;
                end;

            DATABASE::"HR Training App Header":
                begin
                    RecRef.SetTable(HrTraining);
                    HrTraining.Validate(Status, HrTraining.Status::New);
                    HrTraining.Modify;
                    Variant := HrTraining;
                end;


            DATABASE::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(HrReq);
                    HrReq.Validate(Status, HrReq.Status::New);
                    HrReq.Modify;
                    Variant := HrReq;
                end;


            DATABASE::"HR Employee Transfer Header":
                begin
                    RecRef.SetTable(HrEmpTrans);
                    HrEmpTrans.Validate(Status, HrEmpTrans.Status::New);
                    HrEmpTrans.Modify;
                    Variant := HrEmpTrans;
                end;

            DATABASE::"HR Promo. Recommend Header":
                begin
                    RecRef.SetTable(HrPromo);
                    HrPromo.Validate(Status, HrPromo.Status::New);
                    HrPromo.Modify;
                    Variant := HrPromo;
                end;
            DATABASE::"HR Transport Requisition":
                begin
                    RecRef.SetTable(HrTransport);
                    HrTransport.Validate(Status, HrTransport.Status::New);
                    HrTransport.Modify;
                    Variant := HrTransport;
                end;

            DATABASE::"HR Asset Transfer Header":
                begin
                    RecRef.SetTable(HrAssetTrans);
                    HrAssetTrans.Validate(Status, HrAssetTrans.Status::New);
                    HrAssetTrans.Modify;
                    Variant := HrAssetTrans;
                end;

            DATABASE::"HR Employee Confirmation":

                begin
                    RecRef.SetTable(HrEmpConfirm);
                    HrEmpConfirm.Validate(Status, HrEmpConfirm.Status::New);
                    HrEmpConfirm.Modify;
                    Variant := HrEmpConfirm;
                end;
            //Staff Loan
            //  DATABASE::"prSalary Advance":
            //  BEGIN
            //     RecRef.SETTABLE(StaffLoan);
            //     StaffLoan.VALIDATE(Status,StaffLoan.Status::New);
            //     StaffLoan.MODIFY;
            //     Variant := StaffLoan;
            //    END;


            //HR
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;

    procedure Release(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record "Payments Header";
        StaffClaimsHeader: Record "Staff Claims Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        OvertimeClaimHeader: Record "Purchase Header";
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        Budget: Record "G/L Budget Name";
        Workplan: Record Workplan;
        Vote: Record "Vote Transfer";
        Hrleave: Record "HR Leave Application";
        Hrjobs: Record "HR Jobs";
        HrTraining: Record "HR Training App Header";
        HrReq: Record "HR Employee Requisitions";
        HrEmpTrans: Record "HR Employee Transfer Header";
        HrPromo: Record "HR Promo. Recommend Header";
        HrTransport: Record "HR Transport Requisition";
        HrAssetTrans: Record "HR Asset Transfer Header";
        HrEmpConfirm: Record "HR Employee Confirmation";
        Invest: Record "Bank Account";
        HrLeaveRein: Record "HR Leave Reimbursement";
        Disposal: Record "Disposal Plan Header";
        DisposalHeader: Record "Disposal Header";
        StaffLoan: Record "Purchase Header";
        Inspection: Record "Purchase Header";
        Perdiem: Record "Perdiem Header";
        QuotationAHeader: Record "Quotation Analysis Header";
        HREmployee: Record "HR-Employee";
        HROvertimeHeader: Record "HR Overtime Header";
        HKComplains: Record "HK Complains";
        HKEventRequisition: Record "HK Event Requisition";
        Overtimeheader: Record "Overtime Header";
        WshpServiceHeader: Record "Wshp Service Header";
        HREmployeeGrievance: Record "HR Employee Grievance";
        Repairs: Record "Repair Schedule Header";
        SecurityOB: Record "Security OB";
        SecurityVInspectionRegister: Record "Security V Inspection Register";
        FuelRequisition: Record "Fuel Requisition";
        Transportmechanics: Record "TRansport Mechanics";
        ProfOpi: Record "Professional Opinion";
        "E-Tender": Record "E-Tender Company Information";
        "Cont Header": Record "Contracts Header";
        MSurvey: Record "Market Survey Header";
        TCOM: Record "Tender Committee Activities";
        ECOM: Record "Evaluation Committee Activity";
        ICOM: Record "Inspection Committee Activity";
        DCOM: Record "Disposal Committee Activity";
        FEH: Record "Financial Evaluation Header";
        TCA: Page "Tender Committe Activities";
        ECA: Page "Evaluation Committe Activities";
        ICA: Page "Inspection Committee Activitie";
        DCA: Page "Disposal Committee Activities";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Payments Header":
                begin
                    RecRef.SetTable(PaymentsHeader);
                    PaymentsHeader.Validate(Status, PaymentsHeader.Status::Approved);
                    PaymentsHeader.Modify;
                    Variant := PaymentsHeader;
                end;
            DATABASE::"Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaimsHeader);
                    StaffClaimsHeader.Validate(Status, StaffClaimsHeader.Status::Approved);
                    StaffClaimsHeader.Modify;
                    Variant := StaffClaimsHeader;
                end;
            //E-Tender Company Information
            DATABASE::"E-Tender Company Information":
                begin
                    RecRef.SetTable("E-Tender");
                    "E-Tender".Validate(Status, "E-Tender".Status::Approved);
                    "E-Tender".Modify;
                    Variant := "E-Tender";
                    TCA.Notify_Participants;
                end;
            //Contracts Header
            DATABASE::"Contracts Header":
                begin
                    RecRef.SetTable("Cont Header");
                    "Cont Header".Validate(Status, "Cont Header"."Approval Status"::Approved);
                    "Cont Header".Modify;
                    Variant := "Cont Header";
                end;

            DATABASE::"Staff Advance Header":
                begin
                    RecRef.SetTable(StaffAdvanceHeader);
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::Approved);
                    StaffAdvanceHeader.Modify;
                    Variant := StaffAdvanceHeader;
                end;
            DATABASE::"Staff Advance Surrender Header":
                begin
                    RecRef.SetTable(StaffAdvanceSurrenderHeader);
                    StaffAdvanceSurrenderHeader.Validate(Status, StaffAdvanceSurrenderHeader.Status::Approved);
                    StaffAdvanceSurrenderHeader.Modify;
                    Variant := StaffAdvanceSurrenderHeader;
                end;
            DATABASE::"Imprest Header":
                begin
                    RecRef.SetTable(ImprestHeader);
                    ImprestHeader.Validate(Status, ImprestHeader.Status::Approved);
                    ImprestHeader.Modify;
                    Variant := ImprestHeader;
                end;
            DATABASE::"Imprest Surrender Header":
                begin
                    RecRef.SetTable(ImprestSurrenderHeader);
                    ImprestSurrenderHeader.Validate(Status, ImprestSurrenderHeader.Status::Approved);
                    ImprestSurrenderHeader.Modify;
                    Variant := ImprestSurrenderHeader;
                end;
            DATABASE::"Store Requistion Header2":
                begin
                    RecRef.SetTable(StoreRequistionHeader);
                    StoreRequistionHeader.Validate(Status, StoreRequistionHeader.Status::Released);
                    StoreRequistionHeader.Modify;
                    Variant := StoreRequistionHeader;
                end;
            DATABASE::"InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);
                    InterBankTransfers.Validate(Status, InterBankTransfers.Status::"Pending Approval");
                    InterBankTransfers.Modify;
                    Variant := InterBankTransfers;
                end;
            DATABASE::"HR Overtime Header":
                begin
                    RecRef.SetTable(HROvertimeHeader);
                    HROvertimeHeader.Validate(Status, HROvertimeHeader.Status::Approved);
                    HROvertimeHeader.Modify;
                    Variant := HROvertimeHeader;
                end;
            DATABASE::"Purchase Quote Header":
                begin
                    RecRef.SetTable(PurchaseQuoteHeader);
                    PurchaseQuoteHeader.Validate(Status, PurchaseQuoteHeader.Status::Released);
                    PurchaseQuoteHeader.Modify;
                    Variant := PurchaseQuoteHeader;
                end;


            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SetTable(Budget);
                    //Budget.Validate(Status,Budget.Status::Approved);
                    Budget.Modify;
                    Variant := Budget;
                end;

            DATABASE::Workplan:
                begin
                    RecRef.SetTable(Workplan);
                    Workplan.Validate(Status, Workplan.Status::Approved);
                    Workplan.Modify;
                    Variant := Workplan;
                end;

            DATABASE::"Vote Transfer":
                begin
                    RecRef.SetTable(Vote);
                    Vote.Validate(Status, Vote.Status::Approved);
                    Vote.Modify;
                    Variant := Vote;
                end;
            DATABASE::"Perdiem Header":
                begin
                    RecRef.SetTable(Perdiem);
                    Perdiem.Validate(Status, Perdiem.Status::Approved);
                    Perdiem.Modify;
                    Variant := Perdiem;
                end;
            DATABASE::"Quotation Analysis Header":
                begin
                    RecRef.SetTable(QuotationAHeader);
                    QuotationAHeader.Validate(Status, QuotationAHeader.Status::Approved);
                    QuotationAHeader.Modify;
                    Variant := QuotationAHeader;
                end;
            /*
            //Investiment
              DATABASE::"Bank Account":
               BEGIN
               RecRef.SETTABLE(Invest);
              Invest.VALIDATE(Status,Invest.Status::Approved);
              Invest.MODIFY;
              Variant:=Invest;
              END;*/
            //Disposal
            DATABASE::"Disposal Plan Header":
                begin
                    RecRef.SetTable(Disposal);
                    Disposal.Validate(Status, Disposal.Status::Approved);
                    Disposal.Modify;
                    Variant := Disposal;
                end;
            //Disposal

            //Disposal 2
            DATABASE::"Disposal Header":
                begin
                    RecRef.SetTable(DisposalHeader);
                    DisposalHeader.Validate(Status, DisposalHeader.Status::Approved);
                    DisposalHeader.Modify;
                    Variant := DisposalHeader;
                end;
            /*
            //Inspection
            DATABASE::"Inspection Header":
            BEGIN
            RecRef.SETTABLE(Inspection);
            Inspection.VALIDATE(Status,Inspection.Status::Approved);
            Inspection.MODIFY;
            Variant:=Inspection;
            END;
            //Inspection
            */


            DATABASE::"HR Leave Application":
                begin
                    RecRef.SetTable(Hrleave);
                    Hrleave.Validate(Status, Hrleave.Status::Approved);
                    Hrleave.Modify;
                    Hrleave.CreateLeaveLedgerEntries;
                    Variant := Hrleave;
                end;

            //Employee card
            DATABASE::"HR-Employee":
                begin
                    RecRef.SetTable(HREmployee);
                    HREmployee.Validate(Status, HREmployee.Status::Approved);
                    HREmployee.Modify;
                    Variant := HREmployee;
                end;
            //Compains
            DATABASE::"HK Complains":
                begin
                    RecRef.SetTable(HKComplains);
                    HKComplains.Validate(Status, HKComplains.Status::Approved);
                    HKComplains.Modify;
                    Variant := HKComplains;
                    HKComplains.NotifyHODAssistant(HKComplains.Code);
                end;
            //OB
            DATABASE::"Security OB":
                begin
                    RecRef.SetTable(SecurityOB);
                    SecurityOB.Validate(Status, SecurityOB.Status::Approved);
                    SecurityOB.Modify;
                    Variant := SecurityOB;
                end;
            //Professional Opinion
            DATABASE::"Professional Opinion":
                begin
                    RecRef.SetTable(ProfOpi);
                    ProfOpi.Validate(Status, ProfOpi.Status::Approved);
                    ProfOpi.Modify;
                    Variant := ProfOpi;
                end;

            //Market Survey
            DATABASE::"Market Survey Header":
                begin
                    RecRef.SetTable(MSurvey);
                    MSurvey.Validate(Status, MSurvey.Status::Approved);
                    MSurvey.Modify;
                    Variant := MSurvey;
                end;

            //Tender Committee
            DATABASE::"Tender Committee Activities":
                begin
                    RecRef.SetTable(TCOM);
                    TCOM.Validate(Status, TCOM.Status::Approved);
                    TCOM.Modify;
                    Variant := TCOM;
                    TCA.Notify_Participants;
                end;

            //Disposal Committee
            DATABASE::"Disposal Committee Activity":
                begin
                    RecRef.SetTable(DCOM);
                    DCOM.Validate(Status, DCOM.Status::Approved);
                    DCOM.Modify;
                    Variant := DCOM;
                    DCA.Notify_Participants;
                end;

            // Evaluation Commitee
            DATABASE::"Evaluation Committee Activity":
                begin
                    RecRef.SetTable(ECOM);
                    ECOM.Validate(Status, ECOM.Status::Approved);
                    ECOM.Modify;
                    Variant := ECOM;
                    ECA.Notify_Participants;
                end;


            // Inspection Commitee
            DATABASE::"Inspection Committee Activity":
                begin
                    RecRef.SetTable(ICOM);
                    ICOM.Validate(Status, ICOM.Status::Approved);
                    ICOM.Modify;
                    Variant := ICOM;
                    ICA.Notify_Participants;
                end;


            //Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                begin
                    RecRef.SetTable(FEH);
                    FEH.Validate(Status, FEH.Status::Approved);
                    FEH.Modify;
                    Variant := FEH;
                end;

            //fuel order
            DATABASE::"Fuel Requisition":
                begin
                    RecRef.SetTable(FuelRequisition);
                    FuelRequisition.Validate(Status, FuelRequisition.Status::Approved);
                    FuelRequisition.Modify;
                    Variant := FuelRequisition;
                end;
            //Transport Mechanics
            DATABASE::"TRansport Mechanics":
                begin
                    RecRef.SetTable(Transportmechanics);
                    Transportmechanics.Validate(Status, Transportmechanics.Status::Approved);
                    Transportmechanics.Modify;
                    Variant := Transportmechanics;
                end;
            //SecurityVInspectionRegister
            DATABASE::"Security V Inspection Register":
                begin
                    RecRef.SetTable(SecurityVInspectionRegister);
                    SecurityVInspectionRegister.Validate(Status, SecurityVInspectionRegister.Status::Approved);
                    SecurityVInspectionRegister.Modify;
                    Variant := SecurityVInspectionRegister;
                end;


            DATABASE::"Repair Schedule Header":
                begin
                    RecRef.SetTable(Repairs);
                    Repairs.Validate(Status, Repairs.Status::Approved);
                    Repairs.Modify;
                    Variant := Repairs;
                end;
            //Fleet Service
            DATABASE::"Wshp Service Header":
                begin
                    RecRef.SetTable(WshpServiceHeader);
                    WshpServiceHeader.Validate(Status, WshpServiceHeader.Status::Approved);
                    WshpServiceHeader.Modify;
                    Variant := WshpServiceHeader;
                end;
            //Events
            DATABASE::"HK Event Requisition":
                begin
                    RecRef.SetTable(HKEventRequisition);
                    HKEventRequisition.Validate(Status, HKEventRequisition.Status::Approved);
                    HKEventRequisition.Modify;
                    Variant := HKEventRequisition;
                end;

            //Grievance
            DATABASE::"HR Employee Grievance":
                begin
                    RecRef.SetTable(HREmployeeGrievance);
                    HREmployeeGrievance.Validate(Status, HREmployeeGrievance.Status::Approved);
                    HREmployeeGrievance.Modify;
                    Variant := HREmployeeGrievance;
                end;
            //Overtime
            DATABASE::"Overtime Header":
                begin
                    RecRef.SetTable(Overtimeheader);
                    Overtimeheader.Validate(Status, Overtimeheader.Status::Approved);
                    Overtimeheader.Modify;
                    Variant := Overtimeheader;
                end;
            //Rein

            DATABASE::"HR Leave Reimbursement":
                begin
                    RecRef.SetTable(HrLeaveRein);
                    HrLeaveRein.Validate(Status, HrLeaveRein.Status::Approved);
                    HrLeaveRein.Modify;
                    HrLeaveRein.CreateLeaveLedgerEntries;
                    Variant := HrLeaveRein;
                end;

            DATABASE::"HR Jobs":
                begin
                    RecRef.SetTable(Hrjobs);
                    Hrjobs.Validate(Status, Hrjobs.Status::Approved);
                    Hrjobs.Modify;
                    Variant := Hrjobs;
                end;

            DATABASE::"HR Training App Header":
                begin
                    RecRef.SetTable(HrTraining);
                    HrTraining.Validate(Status, HrTraining.Status::Approved);
                    HrTraining.Modify;
                    Variant := HrTraining;
                end;

            DATABASE::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(HrReq);
                    HrReq.Validate(Status, HrReq.Status::Approved);
                    HrReq.Modify;
                    //SendApprovalEmail(HrReq."Requisition No.",HrReq."Job ID",HrReq."Job Description");//commented because its causing use setup error
                    Variant := HrReq;
                end;

            DATABASE::"HR Employee Transfer Header":
                begin
                    RecRef.SetTable(HrEmpTrans);
                    HrEmpTrans.Validate(Status, HrEmpTrans.Status::Approved);
                    HrEmpTrans.Modify;
                    SendApprovalEmail(HrEmpTrans."Request No", HrEmpTrans."Employee No", HrEmpTrans."Employee Name");
                    Variant := HrEmpTrans;
                end;
            DATABASE::"HR Promo. Recommend Header":
                begin
                    RecRef.SetTable(HrPromo);
                    HrPromo.Validate(Status, HrPromo.Status::Approved);
                    HrPromo.Modify;
                    SendApprovalEmail(HrPromo.No, HrPromo."Employee No.", HrPromo."Employee Name");
                    Variant := HrPromo;
                end;
            DATABASE::"HR Transport Requisition":
                begin
                    RecRef.SetTable(HrTransport);
                    HrTransport.Validate(Status, HrTransport.Status::Approved);
                    HrTransport.Modify;
                    //SendApprovalEmail(HrTransport."Transport Request No",HrTransport."Employee No",HrTransport."Employee Name");
                    //SendApprovalEmail(HrTransport."Transport Request No",HrTransport."Employee No",HrTransport."User ID");
                    Variant := HrTransport;
                end;
            DATABASE::"HR Asset Transfer Header":
                begin
                    RecRef.SetTable(HrAssetTrans);
                    HrAssetTrans.Validate(Status, HrAssetTrans.Status::Approved);
                    HrAssetTrans.Modify;
                    Variant := HrAssetTrans;
                end;

            DATABASE::"HR Employee Confirmation":
                begin
                    RecRef.SetTable(HrEmpConfirm);
                    HrEmpConfirm.Validate(Status, HrEmpConfirm.Status::Approved);
                    HrEmpConfirm.Modify;
                    Variant := HrEmpConfirm;
                end;

            //Staff Loan
            //  DATABASE::"prSalary Advance":
            //  BEGIN
            //     RecRef.SETTABLE(StaffLoan);
            //     StaffLoan.VALIDATE(Status,StaffLoan.Status::Approved);
            //     SendApprovalEmail(StaffLoan."Loan No.",StaffLoan."Loan Description",StaffLoan."User ID");
            //     StaffLoan.MODIFY;
            //     Variant := StaffLoan;
            //    END;
            //HR
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;

    procedure SetStatusToPending(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record "Payments Header";
        StaffClaimsHeader: Record "Staff Claims Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        OvertimeClaimHeader: Record "Purchase Header";
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        Budget: Record "G/L Budget Name";
        Workplan: Record Workplan;
        Vote: Record "Vote Transfer";
        Hrleave: Record "HR Leave Application";
        Hrjobs: Record "HR Jobs";
        HrTraining: Record "HR Training App Header";
        HrReq: Record "HR Employee Requisitions";
        HrEmpTrans: Record "HR Employee Transfer Header";
        HrPromo: Record "HR Promo. Recommend Header";
        HrTransport: Record "HR Transport Requisition";
        HrAssetTrans: Record "HR Asset Transfer Header";
        HrEmpConfirm: Record "HR Employee Confirmation";
        Invest: Record "Bank Account";
        HrLeaveRein: Record "HR Leave Reimbursement";
        Disposal: Record "Disposal Plan Header";
        DisposalHeader: Record "Disposal Header";
        StaffLoan: Record "Purchase Header";
        Inspection: Record "Purchase Header";
        Perdiem: Record "Perdiem Header";
        QuotationAHeader: Record "Quotation Analysis Header";
        HREmployee: Record "HR-Employee";
        HROvertimeHeader: Record "HR Overtime Header";
        HKComplains: Record "HK Complains";
        HKEventRequisition: Record "HK Event Requisition";
        Overtimeheader: Record "Overtime Header";
        WshpServiceHeader: Record "Wshp Service Header";
        HREmployeeGrievance: Record "HR Employee Grievance";
        Repairs: Record "Repair Schedule Header";
        SecurityOB: Record "Security OB";
        SecurityVInspectionRegister: Record "Security V Inspection Register";
        FuelRequisition: Record "Fuel Requisition";
        Transportmechanics: Record "TRansport Mechanics";
        ProfOpi: Record "Professional Opinion";
        "E-Tender": Record "E-Tender Company Information";
        "Cont Header": Record "Contracts Header";
        MSurvey: Record "Market Survey Header";
        TCOM: Record "Tender Committee Activities";
        ECOM: Record "Evaluation Committee Activity";
        ICOM: Record "Inspection Committee Activity";
        DCOM: Record "Disposal Committee Activity";
        FEH: Record "Financial Evaluation Header";
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
            DATABASE::"Payments Header":
                begin
                    RecRef.SetTable(PaymentsHeader);
                    PaymentsHeader.Validate(Status, PaymentsHeader.Status::"Pending Approval");
                    PaymentsHeader.Modify;
                    Variant := PaymentsHeader;
                end;
            //E-Tender Company Information
            DATABASE::"E-Tender Company Information":
                begin
                    RecRef.SetTable("E-Tender");
                    "E-Tender".Validate(Status, "E-Tender".Status::Pending);
                    "E-Tender".Modify;
                    Variant := "E-Tender";
                end;

            //Contracts Header
            DATABASE::"Contracts Header":
                begin
                    RecRef.SetTable("Cont Header");
                    "Cont Header".Validate(Status, "Cont Header"."Approval Status"::Pending);
                    "Cont Header".Modify;
                    Variant := "Cont Header";
                end;

            DATABASE::"Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaimsHeader);
                    StaffClaimsHeader.Validate(Status, StaffClaimsHeader.Status::"Pending Approval");
                    StaffClaimsHeader.Modify;
                    Variant := StaffClaimsHeader;
                end;
            DATABASE::"Staff Advance Header":
                begin
                    RecRef.SetTable(StaffAdvanceHeader);
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::"Pending Approval");
                    StaffAdvanceHeader.Modify;
                    Variant := StaffAdvanceHeader;
                end;
            DATABASE::"Staff Advance Surrender Header":
                begin
                    RecRef.SetTable(StaffAdvanceSurrenderHeader);
                    StaffAdvanceSurrenderHeader.Validate(Status, StaffAdvanceSurrenderHeader.Status::"Pending Approval");
                    StaffAdvanceSurrenderHeader.Modify;
                    Variant := StaffAdvanceSurrenderHeader;
                end;
            DATABASE::"Imprest Header":
                begin
                    RecRef.SetTable(ImprestHeader);
                    ImprestHeader.Validate(Status, ImprestHeader.Status::"Pending Approval");
                    ImprestHeader.Modify;
                    Variant := ImprestHeader;
                end;
            DATABASE::"Imprest Surrender Header":
                begin
                    RecRef.SetTable(ImprestSurrenderHeader);
                    ImprestSurrenderHeader.Validate(Status, ImprestSurrenderHeader.Status::"Pending Approval");
                    ImprestSurrenderHeader.Modify;
                    Variant := ImprestSurrenderHeader;
                end;
            DATABASE::"Store Requistion Header2":
                begin
                    RecRef.SetTable(StoreRequistionHeader);
                    StoreRequistionHeader.Validate(Status, StoreRequistionHeader.Status::"Pending Approval");
                    StoreRequistionHeader.Modify;
                    Variant := StoreRequistionHeader;
                end;
            DATABASE::"InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);
                    InterBankTransfers.Validate(Status, InterBankTransfers.Status::Cancelled);
                    InterBankTransfers.Modify;
                    Variant := InterBankTransfers;
                end;
            DATABASE::"HR Overtime Header":
                begin
                    RecRef.SetTable(HROvertimeHeader);
                    HROvertimeHeader.Validate(Status, HROvertimeHeader.Status::"Pending Approval");
                    HROvertimeHeader.Modify;
                    Variant := HROvertimeHeader;
                end;
            //RFQ pending approval
            DATABASE::"Purchase Quote Header":
                begin
                    RecRef.SetTable(PurchaseQuoteHeader);
                    PurchaseQuoteHeader.Validate(Status, PurchaseQuoteHeader.Status::"Pending Approval");
                    PurchaseQuoteHeader.Modify;
                    Variant := PurchaseQuoteHeader;
                end;


            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SetTable(Budget);
                    //Budget.Validate(Status,Budget.Status::"Pending Approval");
                    Budget.Modify;
                    Variant := Budget;
                end;

            DATABASE::Workplan:
                begin
                    RecRef.SetTable(Workplan);
                    Workplan.Validate(Status, Workplan.Status::"Pending Approval");
                    Workplan.Modify;
                    Variant := Workplan;
                end;

            DATABASE::"Vote Transfer":
                begin
                    RecRef.SetTable(Vote);
                    Vote.Validate(Status, Vote.Status::"Pending Approval");
                    Vote.Modify;
                    Variant := Vote;
                end;
            DATABASE::"Perdiem Header":
                begin
                    RecRef.SetTable(Perdiem);
                    Perdiem.Validate(Status, Perdiem.Status::"Pending Approval");
                    Perdiem.Modify;
                    Variant := Perdiem;
                end;
            DATABASE::"Quotation Analysis Header":
                begin
                    RecRef.SetTable(QuotationAHeader);
                    QuotationAHeader.Validate(Status, QuotationAHeader.Status::Pending);
                    QuotationAHeader.Modify;
                    Variant := QuotationAHeader;
                end;

            ///Disposal
            DATABASE::"Disposal Plan Header":
                begin
                    RecRef.SetTable(Disposal);
                    Disposal.Validate(Status, Disposal.Status::"Pending Approval");
                    Disposal.Modify;
                    Variant := Disposal;
                end;
            //Disposal

            DATABASE::"Disposal Header":
                begin
                    RecRef.SetTable(DisposalHeader);
                    DisposalHeader.Validate(Status, DisposalHeader.Status::"Pending Approval");
                    DisposalHeader.Modify;
                    Variant := DisposalHeader;
                end;
            //Disposal 2
            /*
            ///Inspection
            DATABASE::"Inspection Header":
            BEGIN
            RecRef.SETTABLE(Inspection);
            Inspection.VALIDATE(Status,Inspection.Status::"Pending Approval");
            Inspection.MODIFY;
            Variant:=Inspection;
            END;
            //Inspection
            */
            //Investiment
            DATABASE::"Bank Account":
                begin
                    RecRef.SetTable(Invest);
                    //Invest.VALIDATE(Status,Invest.Status::"Pending Approval");
                    Invest.Modify;
                    Variant := Invest;
                end;
            //HR



            DATABASE::"HR Leave Application":
                begin
                    RecRef.SetTable(Hrleave);
                    Hrleave.Validate(Status, Hrleave.Status::"Pending Approval");
                    Hrleave.Modify;
                    Variant := Hrleave;
                end;

            //Employee card
            DATABASE::"HR-Employee":
                begin
                    RecRef.SetTable(HREmployee);
                    HREmployee.Validate(Status, HREmployee.Status::"Pending Approval");
                    HREmployee.Modify;
                    Variant := HREmployee;
                end;
            //Compains
            DATABASE::"HK Complains":
                begin
                    RecRef.SetTable(HKComplains);
                    HKComplains.Validate(Status, HKComplains.Status::"Pending Approval");
                    HKComplains.Modify;
                    Variant := HKComplains;
                end;
            //OB
            DATABASE::"Security OB":
                begin
                    RecRef.SetTable(SecurityOB);
                    SecurityOB.Validate(Status, SecurityOB.Status::"Pending Approval");
                    SecurityOB.Modify;
                    Variant := SecurityOB;
                end;
            //Professional opinion
            DATABASE::"Professional Opinion":
                begin
                    RecRef.SetTable(ProfOpi);
                    ProfOpi.Validate(Status, ProfOpi.Status::Pending);
                    ProfOpi.Modify;
                    Variant := ProfOpi;
                end;

            //Market Survey
            DATABASE::"Market Survey Header":
                begin
                    RecRef.SetTable(MSurvey);
                    MSurvey.Validate(Status, MSurvey.Status::Pending);
                    MSurvey.Modify;
                    Variant := MSurvey;
                end;


            //Tender Committee
            DATABASE::"Tender Committee Activities":
                begin
                    RecRef.SetTable(TCOM);
                    TCOM.Validate(Status, TCOM.Status::"Pending Approval");
                    TCOM.Modify;
                    Variant := TCOM;
                end;

            // Evaluation Commitee
            DATABASE::"Evaluation Committee Activity":
                begin
                    RecRef.SetTable(ECOM);
                    ECOM.Validate(Status, ECOM.Status::"Pending Approval");
                    ECOM.Modify;
                    Variant := ECOM;
                end;


            // Inspection Commitee
            DATABASE::"Inspection Committee Activity":
                begin
                    RecRef.SetTable(ICOM);
                    ICOM.Validate(Status, ICOM.Status::"Pending Approval");
                    ICOM.Modify;
                    Variant := ICOM;
                end;

            // Disposal Commitee
            DATABASE::"Disposal Committee Activity":
                begin
                    RecRef.SetTable(DCOM);
                    DCOM.Validate(Status, DCOM.Status::"Pending Approval");
                    DCOM.Modify;
                    Variant := DCOM;
                end;

            //Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                begin
                    RecRef.SetTable(FEH);
                    FEH.Validate(Status, FEH.Status::Pending);
                    FEH.Modify;
                    Variant := FEH;
                end;

            //Fuel Order
            DATABASE::"Fuel Requisition":
                begin
                    RecRef.SetTable(FuelRequisition);
                    FuelRequisition.Validate(Status, FuelRequisition.Status::"Pending Approval");
                    FuelRequisition.Modify;
                    Variant := FuelRequisition;
                end;
            //Transport Mechanics
            DATABASE::"TRansport Mechanics":
                begin
                    RecRef.SetTable(Transportmechanics);
                    Transportmechanics.Validate(Status, Transportmechanics.Status::"Pending Approval");
                    Transportmechanics.Modify;
                    Variant := Transportmechanics;
                end;
            //SecurityVInspectionRegister
            DATABASE::"Security V Inspection Register":
                begin
                    RecRef.SetTable(SecurityVInspectionRegister);
                    SecurityVInspectionRegister.Validate(Status, SecurityVInspectionRegister.Status::"Pending Approval");
                    SecurityVInspectionRegister.Modify;
                    Variant := SecurityVInspectionRegister;
                end;

            DATABASE::"Repair Schedule Header":
                begin
                    RecRef.SetTable(Repairs);
                    Repairs.Validate(Status, Repairs.Status::"Pending Approval");
                    Repairs.Modify;
                    Variant := Repairs;
                end;
            //Fleet Service
            DATABASE::"Wshp Service Header":
                begin
                    RecRef.SetTable(WshpServiceHeader);
                    WshpServiceHeader.Validate(Status, WshpServiceHeader.Status::"Pending Approval");
                    WshpServiceHeader.Modify;
                    Variant := WshpServiceHeader;
                end;
            //Events
            DATABASE::"HK Event Requisition":
                begin
                    RecRef.SetTable(HKEventRequisition);
                    HKEventRequisition.Validate(Status, HKEventRequisition.Status::"Pending Approval");
                    HKEventRequisition.Modify;
                    Variant := HKEventRequisition;
                end;

            //Grievance
            DATABASE::"HR Employee Grievance":
                begin
                    RecRef.SetTable(HREmployeeGrievance);
                    HREmployeeGrievance.Validate(Status, HREmployeeGrievance.Status::"Pending Approval");
                    HREmployeeGrievance.Modify;
                    Variant := HREmployeeGrievance;
                end;
            //Overtime
            DATABASE::"Overtime Header":
                begin
                    RecRef.SetTable(Overtimeheader);
                    Overtimeheader.Validate(Status, Overtimeheader.Status::"Pending Approval");
                    Overtimeheader.Modify;
                    Variant := Overtimeheader;
                end;
            //Rein
            DATABASE::"HR Leave Reimbursement":
                begin
                    RecRef.SetTable(HrLeaveRein);
                    HrLeaveRein.Validate(Status, HrLeaveRein.Status::"Pending Approval");
                    HrLeaveRein.Modify;
                    Variant := HrLeaveRein
                end;
            //Rein
            DATABASE::"HR Jobs":
                begin
                    RecRef.SetTable(Hrjobs);
                    Hrjobs.Validate(Status, Hrjobs.Status::"Pending Approval");
                    Hrjobs.Modify;
                    Variant := Hrjobs;
                end;

            DATABASE::"HR Training App Header":
                begin
                    RecRef.SetTable(HrTraining);
                    HrTraining.Validate(Status, HrTraining.Status::"Pending Approval");
                    HrTraining.Modify;
                    Variant := HrTraining;
                end;

            DATABASE::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(HrReq);
                    HrReq.Validate(Status, HrReq.Status::"Pending Approval");
                    HrReq.Modify;
                    Variant := HrReq;
                end;

            DATABASE::"HR Employee Transfer Header":
                begin
                    RecRef.SetTable(HrEmpTrans);
                    HrEmpTrans.Validate(Status, HrEmpTrans.Status::"Pending Approval");
                    HrEmpTrans.Modify;
                    Variant := HrEmpTrans;
                end;

            DATABASE::"HR Promo. Recommend Header":
                begin
                    RecRef.SetTable(HrPromo);
                    HrPromo.Validate(Status, HrPromo.Status::"Pending Approval");
                    HrPromo.Modify;
                    Variant := HrPromo;
                end;

            DATABASE::"HR Transport Requisition":
                begin
                    RecRef.SetTable(HrTransport);
                    HrTransport.Validate(Status, HrTransport.Status::"Pending Approval");
                    HrTransport.Modify;
                    Variant := HrTransport;
                end;

            DATABASE::"HR Asset Transfer Header":
                begin
                    RecRef.SetTable(HrAssetTrans);
                    HrAssetTrans.Validate(Status, HrAssetTrans.Status::"Pending Approval");
                    HrAssetTrans.Modify;
                    Variant := HrAssetTrans;
                end;

            DATABASE::"HR Employee Confirmation":
                begin
                    RecRef.SetTable(HrEmpConfirm);
                    HrEmpConfirm.Validate(Status, HrEmpConfirm.Status::"Pending Approval");
                    HrEmpConfirm.Modify;
                    Variant := HrEmpConfirm;
                end;
            //StaffLoan
            //  DATABASE::"prSalary Advance":
            //  BEGIN
            //     RecRef.SETTABLE(StaffLoan);
            //     StaffLoan.VALIDATE(Status,StaffLoan.Status::"Pending Approval");
            //     StaffLoan.MODIFY;
            //     Variant := StaffLoan;
            //    END;
            //HR
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;

    procedure RejectDocument(var Variant: Variant)
    var
        RecRef: RecordRef;
        PaymentsHeader: Record "Payments Header";
        StaffClaimsHeader: Record "Staff Claims Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        OvertimeClaimHeader: Record "Purchase Header";
        PurchaseQuoteHeader: Record "Purchase Quote Header";
        Budget: Record "G/L Budget Name";
        Workplan: Record Workplan;
        Vote: Record "Purchase Header";
        Hrleave: Record "HR Leave Application";
        Hrjobs: Record "HR Jobs";
        HrTraining: Record "HR Training App Header";
        HrReq: Record "HR Employee Requisitions";
        HrEmpTrans: Record "HR Employee Transfer Header";
        HrPromo: Record "HR Promo. Recommend Header";
        HrTransport: Record "HR Transport Requisition";
        HrAssetTrans: Record "HR Asset Transfer Header";
        HrEmpConfirm: Record "HR Employee Confirmation";
        Invest: Record "Bank Account";
        HrLeaveRein: Record "HR Leave Reimbursement";
        Disposal: Record "Purchase Header";
        DisposalHeader: Record "Purchase Header";
        StaffLoan: Record "Purchase Header";
        Inspection: Record "Purchase Header";
        HREmployee: Record "HR-Employee";
        HROvertimeHeader: Record "HR Overtime Header";
        HKComplains: Record "HK Complains";
        HKEventRequisition: Record "HK Event Requisition";
        Overtimeheader: Record "Overtime Header";
        Repairs: Record "Repair Schedule Header";
        SecurityOB: Record "Security OB";
        FuelRequisition: Record "Fuel Requisition";
        Transportmechanics: Record "TRansport Mechanics";
        "E-Tender": Record "E-Tender Company Information";
        "Cont Header": Record "Contracts Header";
        ProfOpi: Record "Professional Opinion";
    begin

        RecRef.GetTable(Variant);
        case RecRef.Number of
            //


            //E-Tender Company Information
            DATABASE::"E-Tender Company Information":
                begin
                    RecRef.SetTable("E-Tender");
                    "E-Tender".Validate(Status, "E-Tender".Status::Open);
                    "E-Tender".Modify;
                    Variant := "E-Tender";
                end;
            //Contracts Header
            DATABASE::"Contracts Header":
                begin
                    RecRef.SetTable("Cont Header");
                    "Cont Header".Validate(Status, "Cont Header"."Approval Status"::Open);
                    "Cont Header".Modify;
                    Variant := "Cont Header";
                end;
            //Professional Opinion
            DATABASE::"Professional Opinion":
                begin
                    RecRef.SetTable(ProfOpi);
                    ProfOpi.Validate(Status, ProfOpi.Status::Open);
                    ProfOpi.Validate("Rejected Status", ProfOpi."Rejected Status"::Rejected);
                    ProfOpi.Modify;
                    Variant := ProfOpi;
                end;
        end;
    end;

    procedure SendApprovalEmail(DocNo: Code[20]; Description: Text; User: Code[50])
    var
        SMTP: Codeunit "SMTP Mail";
        UserSetup: Record "User Setup";
        CompanyInfo: Record "Company Information";
        SecurityOB: Record "Security OB";
    begin
        // // CLEAR(SMTP);
        // // UserSetup.GET(User);
        // // CompanyInfo.GET;
        // // SMTP.CreateMessage(COMPANYNAME,CompanyInfo."E-Mail",UserSetup."E-Mail",
        // // 'Dynamics NAV Document Approval: '+DocNo,'Document '+' '+DocNo+' for '+Description+' has been approved . ' + FORMAT(TODAY)
        // // ,TRUE);
        // // SMTP.AppendBody('<br>');
        // // SMTP.Send;
    end;

    procedure SendRejectionEmail(DocNo: Code[20]; Description: Text; User: Code[50])
    var
        SMTP: Codeunit "SMTP Mail";
        UserSetup: Record "User Setup";
        CompanyInfo: Record "Company Information";
        SecurityOB: Record "Security OB";
    begin
        // // CLEAR(SMTP);
        // // UserSetup.GET(User);
        // // CompanyInfo.GET;
        // // SMTP.CreateMessage(COMPANYNAME,CompanyInfo."E-Mail",UserSetup."E-Mail",
        // // 'Dynamics NAV Document Approval: '+DocNo,'Document '+' '+DocNo+' for '+Description+' has been rejected . ' + FORMAT(TODAY)
        // // ,TRUE);
        // // SMTP.AppendBody('<br>');
        // // SMTP.Send;
    end;

    procedure PopulateApprovalEntryArgument(RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry") Found: Boolean
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Customer: Record Customer;
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        Budget: Record "G/L Budget Name";
        Vendor: Record Vendor;
        HRJobs: Record "HR Jobs";
        Hrempreq: Record "HR Employee Requisitions";
        Leave: Record "HR Leave Application";
        hrtraining: Record "HR Training Cost";
        EmpTrans: Record "HR Asset Transfer Header";
        HRInternReq: Record "prTransaction Codes";
        leavePlanner: Record "HR Leave Planner Header";
        StaffLoan: Record "HR Induction Schedule";
        TNeed: Record "HR Training App Lines";
        Disciplinary: Record "PR Email Status";
        AppraisalAppeal: Record "HR Succession Employee";
        Cust: Record Customer;
        FixedAsset: Record "Fixed Asset";
        Items: Record Item;
        LeaveReim: Record "HR Leave Reimbursement";
        HREmployees: Record "Salary Grades";
        Exitinterview: Record "HR Employee Exit Interviews";
        JBatch: Record "Gen. Journal Batch";
        HRMedicalClaims: Record "HR Employee Confirmation";
        RFQ: Record "Purchase Quote Header";
        PReq: Record "Purchase Header";
        ProfOpi: Record "Professional Opinion";
        MSurvey: Record "Market Survey Header";
        TCOM: Record "Tender Committee Activities";
        ECOM: Record "Evaluation Committee Activity";
        ICOM: Record "Inspection Committee Activity";
        DCOM: Record "Disposal Committee Activity";
        FEH: Record "Financial Evaluation Header";
        ETender: Record "E-Tender Company Information";
    begin
        Found := true;
        case RecRef.Number of

            //RFQ
            DATABASE::"Purchase Quote Header":
                begin
                    RecRef.SetTable(RFQ);
                    ApprovalEntryArgument."Document No." := RFQ."No.";
                end;

            //Professional Opinion
            DATABASE::"Professional Opinion":
                begin
                    RecRef.SetTable(ProfOpi);
                    ApprovalEntryArgument."Document No." := ProfOpi."No.";
                end;

            //E-Tender Company Information
            DATABASE::"E-Tender Company Information":
                begin
                    RecRef.SetTable(ETender);
                    ApprovalEntryArgument."Document No." := ETender.No;
                end;


            //Market Survey
            DATABASE::"Market Survey Header":
                begin
                    RecRef.SetTable(MSurvey);
                    ApprovalEntryArgument."Document No." := MSurvey.No;
                end;

            //Tender Committee
            DATABASE::"Tender Committee Activities":
                begin
                    RecRef.SetTable(TCOM);
                    ApprovalEntryArgument."Document No." := TCOM.Code;
                end;

            //Evaluation Committee
            DATABASE::"Evaluation Committee Activity":
                begin
                    RecRef.SetTable(ECOM);
                    ApprovalEntryArgument."Document No." := ECOM.Code;
                end;


            //Inspection Committee
            DATABASE::"Inspection Committee Activity":
                begin
                    RecRef.SetTable(ICOM);
                    ApprovalEntryArgument."Document No." := ICOM.Code;
                end;

            //Disposal Committee
            DATABASE::"Disposal Committee Activity":
                begin
                    RecRef.SetTable(DCOM);
                    ApprovalEntryArgument."Document No." := DCOM.Code;
                end;


            //Financial Evaluation Header
            DATABASE::"Financial Evaluation Header":
                begin
                    RecRef.SetTable(FEH);
                    ApprovalEntryArgument."Document No." := FEH.Code;
                end;

            DATABASE::"Purchase Header":
                begin
                    RecRef.SetTable(PReq);
                    ApprovalEntryArgument."Document No." := PReq."No.";
                end;

            DATABASE::"Gen. Journal Batch":
                begin
                    RecRef.SetTable(JBatch);
                    ApprovalEntryArgument."Document No." := JBatch.Name;
                end;

            DATABASE::"Gen. Journal Line":
                begin
                    RecRef.SetTable(GenJournalLine);
                    ApprovalEntryArgument."Document Type" := GenJournalLine."Document Type";
                    ApprovalEntryArgument."Document No." := GenJournalLine."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
                    ApprovalEntryArgument.Amount := GenJournalLine.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := GenJournalLine."Currency Code";
                end;


            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SetTable(Budget);
                    ApprovalEntryArgument."Document No." := Budget.Name;
                end;

            DATABASE::Item:
                begin
                    RecRef.SetTable(Items);
                    ApprovalEntryArgument."Document No." := Items."No.";
                end;

            DATABASE::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    ApprovalEntryArgument."Document No." := Vendor."No.";
                end;

            DATABASE::Customer:
                begin
                    RecRef.SetTable(Cust);
                    ApprovalEntryArgument."Document No." := Cust."No.";
                end;

            DATABASE::"HR Leave Reimbursement":
                begin
                    RecRef.SetTable(LeaveReim);
                    ApprovalEntryArgument."Document No." := LeaveReim."Application Code";
                end;
            DATABASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    ApprovalEntryArgument."Document No." := FixedAsset."No.";
                end;

            //Jobs
            DATABASE::"HR Jobs":
                begin
                    RecRef.SetTable(HRJobs);
                    ApprovalEntryArgument."Document No." := HRJobs."Job ID";
                end;
            //HR Jobs
            //HR leave Planner
            DATABASE::"HR Leave Planner Header":
                begin
                    RecRef.SetTable(leavePlanner);
                    ApprovalEntryArgument."Document No." := leavePlanner."Leave Period";
                end;
            //HR Intern Requisition
            DATABASE::"prTransaction Codes":
                begin
                    RecRef.SetTable(HRInternReq);
                    ApprovalEntryArgument."Document No." := HRInternReq."Transaction Code";
                end;
            //HR Intern Requisition

            //Employee Requisition
            DATABASE::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(Hrempreq);
                    ApprovalEntryArgument."Document No." := Hrempreq."Requisition No.";
                end;
            //Leave
            DATABASE::"HR Leave Application":
                begin
                    RecRef.SetTable(Leave);
                    ApprovalEntryArgument."Document No." := Leave."Application Code";
                end;


            //HR Medical


            DATABASE::"Salary Grades":
                begin
                    RecRef.SetTable(HREmployees);
                    ApprovalEntryArgument."Document No." := HREmployees."Salary Grade";
                end;

            DATABASE::"HR Employee Exit Interviews":
                begin
                    RecRef.SetTable(Exitinterview);
                    ApprovalEntryArgument."Document No." := Exitinterview."Exit Interview No";
                end;
            //Appraisal Appeal
            DATABASE::"HR Succession Employee":
                begin
                    RecRef.SetTable(AppraisalAppeal);
                    ApprovalEntryArgument."Document No." := AppraisalAppeal."Staff No.";
                end;




            //Disciplinary
            DATABASE::"PR Email Status":
                begin
                    RecRef.SetTable(Disciplinary);
                    ApprovalEntryArgument."Document No." := Disciplinary."Employee No";
                end;



            //Training
            DATABASE::"HR Training Cost":
                begin
                    RecRef.SetTable(hrtraining);
                    ApprovalEntryArgument."Document No." := hrtraining."Training ID";
                end;
            /*
          //Hr Transport hrtransport
            DATABASE::"HR Transport Requisition Head":
            BEGIN
               RecRef.SETTABLE(hrtransport);
               ApprovalEntryArgument."Document No.":=ReceiptsHeader."No.";
              END;
              */
            //Hr Emplpoyee Transfer EmpTrans
            DATABASE::"HR Asset Transfer Header":
                begin
                    RecRef.SetTable(EmpTrans);
                    ApprovalEntryArgument."Document No." := EmpTrans."No.";
                end;
            //end HR












            else
                Found := false;

        end;

    end;
}

