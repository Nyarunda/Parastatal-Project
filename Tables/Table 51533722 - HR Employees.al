table 51533722 "HR Employees"
{
    Caption = 'HR Employees';
    DataCaptionFields = "No.", "Full Name", "Job Title";
    //DrillDownPageID = "HR Employee List Active";
    //LookupPageID = "HR Employee List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = true;
            NotBlank = true;

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                    HrSetup.Get;
                    NoSeriesMgt.TestManual(HrSetup."Employee Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin

                fn_FullName;
            end;
        }
        field(3; "Middle Name"; Text[50])
        {

            trigger OnValidate()
            begin
                fn_FullName;
            end;
        }
        field(4; "Last Name"; Text[50])
        {

            trigger OnValidate()
            var
                Reason: Text[30];
            begin
                fn_FullName;
            end;
        }
        field(5; Initials; Text[15])
        {
        }
        field(7; "Full Name"; Text[80])
        {
        }
        field(8; "Postal Address"; Text[80])
        {
        }
        field(9; "Residential Address"; Text[50])
        {
        }
        field(10; City; Text[30])
        {
        }
        field(11; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.Reset;
                PostCode.SetRange(PostCode.Code, "Post Code");
                if PostCode.Find('-') then begin
                    City := PostCode.City;
                end;
            end;
        }
        field(12; County; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(13; "Home Phone Number"; Text[30])
        {
        }
        field(14; "Cellular Phone Number"; Text[30])
        {
        }
        field(15; "Work Phone Number"; Text[30])
        {
        }
        field(16; "Ext."; Text[7])
        {
        }
        field(17; "E-Mail"; Text[80])
        {
            ExtendedDatatype = EMail;
        }
        field(19; Picture; BLOB)
        {
            SubType = Bitmap;
        }
        field(21; "ID Number"; Text[30])
        {
        }
        field(22; "Union Code"; Code[10])
        {
            Description = '1';
            TableRelation = Union;
        }
        field(23; "UIF Number"; Text[30])
        {
        }
        field(24; Gender; Option)
        {
            OptionMembers = " ",Male,Female;
        }
        field(25; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            TableRelation = "Employee Statistics Group";
        }
        field(31; Status; Enum "Employees Status")
        {
            trigger OnValidate()
            begin
                "Status Change Date" := Today;
            end;
        }
        field(35; "Location/Division Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                /**
                if SalCard.Get("No.") then begin
                    SalCard."Location/Division" := "Location/Division Code";
                    SalCard.Modify;
                end; **/
            end;
        }
        field(36; "Department Code"; Code[20])
        {

            trigger OnValidate()
            begin
                /**
                if SalCard.Get("No.") then begin
                    SalCard.Department := "Department Code";
                    SalCard.Modify;
                end; **/
            end;
        }
        field(37; Office; Code[20])
        {
            Description = 'Dimension 2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));
        }
        field(38; "Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(39; Comment; Boolean)
        {
            Editable = false;
        }
        field(40; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(42; "Department Filter 1"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(43; "Office Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(47; "Employee No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(49; "Fax Number"; Text[30])
        {
        }
        field(50; "Company E-Mail"; Text[80])
        {
        }
        field(51; Title; Option)
        {
            OptionCaption = ',MR,MRS,MISS,MS,ENG.,DR,CC,Prof,CPA(K)';
            OptionMembers = ,MR,MRS,MISS,MS,"ENG.",DR,CC,PROF,"CPA(K)";
        }
        field(52; "Salespers./Purch. Code"; Code[10])
        {
        }
        field(53; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(54; "Known As"; Text[30])
        {
        }
        field(55; Position; Text[30])
        {

            trigger OnValidate()
            begin
                /*
                    IF ((Position <> xRec.Position) AND (xRec.Position <> '')) THEN BEGIN
                      Jobs.RESET;
                      Jobs.SETRANGE(Jobs."Job ID",Position);
                      IF Jobs.FIND('-') THEN BEGIN
                          Payroll.RESET;
                          Payroll.SETRANGE(Payroll.Code,"No.");
                          IF Payroll.FIND('-') THEN BEGIN
                              Payroll."Salary Scheme Category":=Jobs.Category;
                              Payroll."Salary Steps":=Jobs.Grade;
                              Payroll.VALIDATE(Payroll."Salary Steps");
                              Payroll.MODIFY;
                          END
                      END



                        {
                      CareerEvent.SetMessage('Job Title Changed');
                     CareerEvent.RUNMODAL;
                     OK:= CareerEvent.ReturnResult;
                      IF OK THEN BEGIN
                         CareerHistory.INIT;
                         IF NOT CareerHistory.FIND('-') THEN
                          CareerHistory."Line No.":=1
                        ELSE BEGIN
                          CareerHistory.FIND('+');
                          CareerHistory."Line No.":=CareerHistory."Line No."+1;
                        END;

                         CareerHistory."Employee No.":= "No.";
                         CareerHistory."Date Of Event":= WORKDATE;
                         CareerHistory."Career Event":= 'Job Title Changed';
                         CareerHistory."Job Title":= "Position Title";
                         CareerHistory."Employee First Name":= "Known As";
                         CareerHistory."Employee Last Name":= "Last Name";
                         CareerHistory.INSERT;
                      END;
                      }

                  END;
               */

            end;
        }
        field(57; "Full / Part Time"; Option)
        {
            OptionMembers = "Full Time"," Part Time",Contract;
        }
        field(58; "Contract Type"; Enum "Contract Type")
        {
            Caption = 'Contract Status';
            trigger OnValidate()
            begin
                /**
                SalCard.Reset;
                SalCard.SetRange(SalCard."Employee Code", "No.");
                if SalCard.Find('-') then begin
                    if "Contract Type" = "Contract Type"::Attachment then begin
                        SalCard."Basic Pay" := 10000;
                        SalCard.Modify;
                    end
                end; **/
            end;
        }
        field(59; "Contract End Date"; Date)
        {
        }
        field(60; "Notice Period"; Date)
        {
        }
        field(61; "Union Member?"; Boolean)
        {
        }
        field(62; "Shift Worker?"; Boolean)
        {
        }
        field(63; "Contracted Hours"; Decimal)
        {
        }
        field(64; "Pay Period"; Option)
        {
            OptionMembers = Weekly,"2 Weekly","4 Weekly",Monthly," ";
        }
        field(65; "Pay Per Period"; Decimal)
        {
        }
        field(66; "Cost Code"; Code[20])
        {
        }
        field(68; "Secondment Institution"; Text[30])
        {
        }
        field(69; "UIF Contributor?"; Boolean)
        {
        }
        field(73; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(74; "Ethnic Origin"; Option)
        {
            OptionMembers = African,Indian,White,Coloured;
        }
        field(75; "First Language (R/W/S)"; Code[10])
        {
        }
        field(76; "Driving Licence"; Code[10])
        {
        }
        field(77; "Vehicle Registration Number"; Code[10])
        {
        }
        field(78; Disabled; Option)
        {
            OptionMembers = No,Yes," ";

            trigger OnValidate()
            begin

                if Disabled = Disabled::No then
                    "Retirement date" := CalcDate('65Y', "Date Of Birth")
                else
                    if Disabled = Disabled::Yes then
                        "Retirement date" := CalcDate('70Y', "Date Of Birth");

                fnCalcRetDate
            end;
        }
        field(79; "Health Assesment?"; Boolean)
        {
        }
        field(80; "Health Assesment Date"; Date)
        {
        }
        field(81; "Date Of Birth"; Date)
        {

            trigger OnValidate()
            begin
                /*
                IF Disabled=Disabled::No THEN
                "Retirement date":=CALCDATE('65Y',"Date Of Birth")
                ELSE IF Disabled=Disabled::Yes THEN
                "Retirement date":=CALCDATE('70Y',"Date Of Birth");
                
                fnCalcRetDate
                */


                Age := '';
                //Recalculate Important Dates
                if ("Date Of Birth" <> 0D) then begin
                    Age := Dates.DetermineAge("Date Of Birth", Today);
                end;

            end;
        }
        field(82; Age; Text[80])
        {
        }
        field(83; "Date Of Join"; Date)
        {
        }
        field(84; "Length Of Service"; Text[80])
        {
        }
        field(85; "End Of Probation Date"; Date)
        {
        }
        field(86; "Pension Scheme Join"; Date)
        {
        }
        field(87; "Time Pension Scheme"; Text[50])
        {
        }
        field(88; "Medical Scheme Join"; Date)
        {
        }
        field(89; "Time Medical Scheme"; Text[50])
        {
            //This property is currently not supported
            //TestTableRelation = true;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = true;
        }
        field(90; "Date Of Leaving"; Date)
        {
        }
        field(91; Paterson; Code[10])
        {
        }
        field(92; Peromnes; Code[10])
        {
        }
        field(93; Hay; Code[10])
        {
        }
        field(94; Castellion; Code[10])
        {
        }
        field(95; "Per Annum"; Decimal)
        {
        }
        field(96; "Allow Overtime"; Option)
        {
            OptionMembers = Yes,No," ";
        }
        field(97; "Medical Scheme No."; Text[30])
        {

            trigger OnValidate()
            begin
                //MedicalAidBenefit.SETRANGE("Employee No.","No.");
            end;
        }
        field(98; "Medical Scheme Head Member"; Text[40])
        {

            trigger OnValidate()
            begin
                //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //   OK := MedicalAidBenefit.FIND('+');
                //  IF OK THEN BEGIN
                //  REPEAT
                //   MedicalAidBenefit."Medical Aid Head Member":= "Medical Aid Head Member";
                //    MedicalAidBenefit.MODIFY;
                //  UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(99; "Number Of Dependants"; Integer)
        {

            trigger OnValidate()
            begin
                // MedicalAidBenefit.SETRANGE("Employee No.","No.");
                // OK := MedicalAidBenefit.FIND('+');
                // IF OK THEN BEGIN
                //REPEAT
                //  MedicalAidBenefit."Number Of Dependants":= "Number Of Dependants";
                //  MedicalAidBenefit.MODIFY;
                //UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(100; "Medical Scheme Name"; Text[50])
        {

            trigger OnValidate()
            begin
                //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //OK := MedicalAidBenefit.FIND('+');
                //IF OK THEN BEGIN
                // REPEAT
                // MedicalAidBenefit."Medical Aid Name":= "Medical Aid Name";
                //  MedicalAidBenefit.MODIFY;
                // UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(101; "Amount Paid By Employee"; Decimal)
        {

            trigger OnValidate()
            begin
                //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //  OK := MedicalAidBenefit.FIND('+');
                //   IF OK THEN BEGIN
                //     REPEAT
                //      MedicalAidBenefit."Amount Paid By Employee":= "Amount Paid By Employee";
                //       MedicalAidBenefit.MODIFY;
                //     UNTIL MedicalAidBenefit.NEXT = 0;
                //    END;
            end;
        }
        field(102; "Amount Paid By Company"; Decimal)
        {

            trigger OnValidate()
            begin
                //  MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //   OK := MedicalAidBenefit.FIND('+');
                //  IF OK THEN BEGIN
                // REPEAT
                //      MedicalAidBenefit."Amount Paid By Company":= "Amount Paid By Company";
                //      MedicalAidBenefit.MODIFY;
                // UNTIL MedicalAidBenefit.NEXT = 0;
                //   END;
            end;
        }
        field(103; "Receiving Car Allowance ?"; Boolean)
        {
        }
        field(104; "Second Language (R/W/S)"; Code[10])
        {
        }
        field(105; "Additional Language"; Code[10])
        {
        }
        field(106; "Cell Phone Reimbursement?"; Boolean)
        {
        }
        field(107; "Amount Reimbursed"; Decimal)
        {
        }
        field(108; "UIF Country"; Code[10])
        {
            TableRelation = "Country/Region".Code;
        }
        field(109; "Direct/Indirect"; Option)
        {
            OptionMembers = Direct,Indirect;
        }
        field(110; "Primary Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(111; Level; Option)
        {
            OptionMembers = " ","Level 1","Level 2","Level 3","Level 4","Level 5","Level 6","Level 7";
        }
        field(112; "Termination Category"; Option)
        {
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Death,Other;

            trigger OnValidate()
            var
                "Lrec Resource": Record Resource;
                OK: Boolean;
            begin
            end;
        }
        field(113; "Job Specification"; Code[30])
        {
            Description = 'To put description on Job title field';
            TableRelation = "HR Jobs"."Job ID";

            trigger OnValidate()
            begin
                objJobs.Reset;
                objJobs.SetRange(objJobs."Job ID", "Job Specification");
                if objJobs.Find('-') then begin
                    "Job Title" := objJobs."Job Description";
                end;
            end;
        }
        field(114; DateOfBirth; Date)
        {

            trigger OnValidate()
            begin
                //calculate age 02-05-1988
                yTODAY := Date2DMY(Today, 3); //2014

                yDOB := Date2DMY("Date Of Birth", 3);
                dDOB := Date2DMY("Date Of Birth", 1);
                mDOB := Date2DMY("Date Of Birth", 2);

                AppAge := yTODAY - yDOB;
                HREmp.Find('-');

                if HREmp.Disabled = HREmp.Disabled::No then begin

                    //calculate how many years remaining for this employee to retire : ret yr is 65
                    noYrsToRetirement := 60 - AppAge;

                    //add noYrsToRetirement to current year to get retirement year da
                    RetirementYear := yTODAY + noYrsToRetirement;
                    //ERROR(FORMAT(RetirementYear));
                    RetirementDate := DMY2Date(dDOB, mDOB, RetirementYear);
                    "Retirement date" := RetirementDate;
                end else
                    //IF HREmp.Disabled= HREmp.Disabled::Yes THEN
                    //calculate how many years remaining for this employee to retire : ret yr is 60
                    noYrsToRetirement := 70 - AppAge;

                //add noYrsToRetirement to current year to get retirement year da
                RetirementYear := yTODAY + noYrsToRetirement;
                //ERROR(FORMAT(RetirementYear));
                RetirementDate := DMY2Date(dDOB, mDOB, RetirementYear);
                "Retirement date" := RetirementDate;
                //END;
                //END;

                if Disabled = Disabled::No then
                    "Retirement date" := CalcDate('65Y', "Date Of Birth")
                else
                    if Disabled = Disabled::Yes then
                        "Retirement date" := CalcDate('70Y', "Date Of Birth");
                fnCalcRetDate();
            end;
        }
        field(115; DateEngaged; Text[8])
        {
        }
        field(116; "Postal Address2"; Text[30])
        {
        }
        field(117; "Postal Address3"; Text[20])
        {
        }
        field(118; "Residential Address2"; Text[30])
        {
        }
        field(119; "Residential Address3"; Text[20])
        {
        }
        field(120; "Post Code2"; Code[20])
        {
            TableRelation = "Post Code";
        }
        field(121; Citizenship; Code[10])
        {
            TableRelation = "Country/Region".Code;
        }
        field(122; "Name Of Manager"; Text[45])
        {
        }
        field(123; "User ID"; Code[30])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = true;

            trigger OnLookup()
            begin
                //UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("User ID");

                if "User ID" = '' then exit;

                HREmp.Reset;
                if HREmp.Get("User ID") then begin
                    EmpFullName := HREmp."First Name" + SPACER + HREmp."Middle Name" + SPACER + HREmp."Last Name";
                    Error('UserID [%1] has already been assigned to another Employee [%2]', "User ID", EmpFullName);
                end;
            end;
        }
        field(124; "Disabling Details"; Text[50])
        {
        }
        field(125; "Disability Grade"; Text[20])
        {
        }
        field(126; "Passport Number"; Text[25])
        {
        }
        field(127; "2nd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(128; "3rd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(129; PensionJoin; Text[8])
        {
        }
        field(130; DateLeaving; Text[30])
        {
        }
        field(131; Region; Code[20])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = CONST(Region));
        }
        field(132; "Manager Emp No"; Code[30])
        {
        }
        field(133; Temp; Text[20])
        {
        }
        field(134; "Employee Qty"; Integer)
        {
            CalcFormula = Count("HR Employees");
            FieldClass = FlowField;
        }
        field(135; "Employee Act. Qty"; Integer)
        {
            CalcFormula = Count("HR Employees");
            FieldClass = FlowField;
        }
        field(136; "Employee Arc. Qty"; Integer)
        {
            CalcFormula = Count("HR Employees");
            FieldClass = FlowField;
        }
        field(137; "Contract Location"; Text[20])
        {
            Description = 'Location where contract was closed';
        }
        field(138; "First Language Read"; Boolean)
        {
        }
        field(139; "First Language Write"; Boolean)
        {
        }
        field(140; "First Language Speak"; Boolean)
        {
        }
        field(141; "Second Language Read"; Boolean)
        {
        }
        field(142; "Second Language Write"; Boolean)
        {
        }
        field(143; "Second Language Speak"; Boolean)
        {
        }
        field(144; "Custom Grading"; Code[20])
        {
        }
        field(145; "PIN No."; Code[20])
        {
        }
        field(146; "NSSF No."; Code[20])
        {
        }
        field(147; "NHIF No."; Code[20])
        {
        }
        field(148; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity";
        }
        field(149; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            TableRelation = "Grounds for Termination";
        }
        field(150; "Sacco Staff No"; Code[20])
        {
        }
        field(151; "Period Filter"; Date)
        {
        }
        field(152; "HELB No"; Text[10])
        {
        }
        field(153; "Co-Operative No"; Text[30])
        {
        }
        field(154; "Wedding Anniversary"; Date)
        {
        }
        field(156; "Competency Area"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(157; "Cost Center Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard));

            trigger OnValidate()
            begin

                //if SalCard.Get("No.") then begin
                //  SalCard."Cost Centre" := "Cost Center Code";
                //SalCard.Modify;
                //end;
            end;
        }
        field(158; "Position To Succeed"; Code[20])
        {
        }
        field(159; "Succesion Date"; Date)
        {
        }
        field(160; "Send Alert to"; Code[20])
        {
        }
        field(161; Ethnicity; Code[20])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER(Ethnicity));
        }
        field(162; Religion; Code[20])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER(Religion));
        }
        field(163; "Job Title"; Text[100])
        {
        }
        field(164; "Post Office No"; Text[20])
        {
        }
        field(165; "Posting Group"; Code[20])
        {
            NotBlank = false;
            //TableRelation = "prEmployee Posting Group".Code;
        }
        field(166; "Payroll Posting Group"; Code[20])
        {
        }
        field(167; "Served Notice Period"; Boolean)
        {
        }
        field(168; "Exit Interview Date"; Date)
        {
        }
        field(169; "Exit Interview Done by"; Code[20])
        {
            TableRelation = "HR Employees"."No.";
        }
        field(170; "Allow Re-Employment In Future"; Boolean)
        {
        }
        field(171; "Medical Scheme Name #2"; Text[50])
        {

            trigger OnValidate()
            begin
                //MedicalAidBenefit.SETRANGE("Employee No.","No.");
                //OK := MedicalAidBenefit.FIND('+');
                //IF OK THEN BEGIN
                // REPEAT
                // MedicalAidBenefit."Medical Aid Name":= "Medical Aid Name";
                //  MedicalAidBenefit.MODIFY;
                // UNTIL MedicalAidBenefit.NEXT = 0;
                // END;
            end;
        }
        field(172; "Resignation Date"; Date)
        {
        }
        field(173; "Suspension Date"; Date)
        {
        }
        field(174; "Demised Date"; Date)
        {
        }
        field(175; "Retirement date"; Date)
        {

            trigger OnValidate()
            begin
                //calculate age 02-05-1988
                yTODAY := Date2DMY(Today, 3); //2014

                yDOB := Date2DMY("Date Of Birth", 3);
                dDOB := Date2DMY("Date Of Birth", 1);
                mDOB := Date2DMY("Date Of Birth", 2);

                AppAge := yTODAY - yDOB;
                HREmp.Find('-');
                if HREmp.Disabled = HREmp.Disabled::No then begin
                    //calculate how many years remaining for this employee to retire : ret yr is 60
                    noYrsToRetirement := 60 - AppAge;

                    //add noYrsToRetirement to current year to get retirement year da
                    RetirementYear := yTODAY + noYrsToRetirement;
                    //ERROR(FORMAT(RetirementYear));
                    RetirementDate := DMY2Date(dDOB, mDOB, RetirementYear);
                    "Retirement date" := RetirementDate;
                end else
                    if HREmp.Disabled = HREmp.Disabled::Yes then
                        //calculate how many years remaining for this employee to retire : ret yr is 60
                        noYrsToRetirement := 70 - AppAge;

                //add noYrsToRetirement to current year to get retirement year da
                RetirementYear := yTODAY + noYrsToRetirement;
                //ERROR(FORMAT(RetirementYear));
                RetirementDate := DMY2Date(dDOB, mDOB, RetirementYear);
                "Retirement date" := RetirementDate;
                //END;
                //END;
            end;
        }
        field(176; "Retrenchment date"; Date)
        {
        }
        field(177; Campus; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('CAMPUS'));
        }
        field(178; Permanent; Boolean)
        {
        }
        field(179; "Library Category"; Option)
        {
            OptionMembers = "ADMIN STAFF","TEACHING STAFF",DIRECTORS;
        }
        field(180; Category; Code[20])
        {
        }
        field(181; "Payroll Departments"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(188; "Salary Grade"; Code[15])
        {
            //TableRelation = "Payment Terms".Field1396040;

            trigger OnValidate()
            begin
                if not Confirm('Changing the Grade will affect the Basic Salary', false) then
                    Error('You have opted to abort the process');


                "Salary Notch/Step" := '';

                /** if SalCard.Get("No.") then begin
                     SalCard."Salary Grade" := "Salary Grade";
                     SalCard.Modify;
                 end; **/


                /*
                IF SalGrade.GET("Salary Grade") THEN BEGIN
                    IF SalGrade."Salary Amount"<>0 THEN BEGIN
                       IF SalCard.GET("No.") THEN BEGIN
                          SalCard."Basic Pay":=SalGrade."Salary Amount";
                          SalCard.MODIFY;
                       END;
                    END;
                END;
                */

            end;
        }
        field(189; "Company Type"; Option)
        {
            OptionCaption = 'Others,USAID';
            OptionMembers = Others,USAID;
        }
        field(190; "Main Bank"; Code[20])
        {
            //TableRelation = "prBank Structure"."Bank Code";
        }
        field(191; "Branch Bank"; Code[20])
        {
            //TableRelation = "prBank Structure"."Branch Code";
        }
        field(192; "Lock Bank Details"; Boolean)
        {
        }
        field(193; "Bank Account Number"; Code[20])
        {
        }
        field(195; "Payroll Code"; Code[20])
        {
        }
        field(196; "Holiday Days Entitlement"; Decimal)
        {
        }
        field(197; "Holiday Days Used"; Decimal)
        {
        }
        field(198; "Payment Mode"; Option)
        {
            Description = 'Bank Transfer,Cheque,Cash,SACCO';
            OptionMembers = " ","Bank Transfer",Cheque,Cash,FOSA;
        }
        field(199; "Hourly Rate"; Decimal)
        {
        }
        field(200; "Daily Rate"; Decimal)
        {
        }
        field(300; "Social Security No."; Code[20])
        {
        }
        field(301; "Pension House"; Code[20])
        {
            //TableRelation = "prInstitutional Membership"."Institution No" WHERE("Group No" = CONST('PENSION'));
        }
        field(302; "Salary Notch/Step"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                IF SalCard.GET("No.") THEN BEGIN
                IF SalGrade.GET("Salary Grade") THEN
                SalaryGrades."Pays NHF":=SalGrade."Pays NHF";
                SalCard."Salary Notch":="Salary Notch/Step";
                
                SalNotch.RESET;
                SalNotch.SETRANGE(SalNotch."Salary Grade","Salary Grade");
                SalNotch.SETRANGE(SalNotch."Salary Notch","Salary Notch/Step");
                IF SalNotch.FIND('-') THEN BEGIN
                IF SalNotch."Salary Amount"<>0 THEN BEGIN
                IF SalCard.GET("No.") THEN BEGIN
                SalCard."Basic Pay":=SalNotch."Salary Amount";
                END;
                END;
                END;
                
                SalCard.MODIFY;
                END ELSE BEGIN
                SalCard.INIT;
                SalCard."Employee Code":="No.";
                SalCard."Pays PAYE":=TRUE;
                SalCard."Location/Division":="Location/Division Code";
                SalCard.Department:="Department Code";
                SalCard."Cost Centre":="Cost Center Code";
                SalCard."Salary Grade":="Salary Grade";
                SalCard."Salary Notch":="Salary Notch/Step";
                IF SalGrade.GET("Salary Grade") THEN
                SalaryGrades."Pays NHF":=SalGrade."Pays NHF";
                
                SalNotch.RESET;
                SalNotch.SETRANGE(SalNotch."Salary Grade","Salary Grade");
                SalNotch.SETRANGE(SalNotch."Salary Notch","Salary Notch/Step");
                IF SalNotch.FIND('-') THEN BEGIN
                IF SalNotch."Salary Amount"<>0 THEN BEGIN
                SalCard."Basic Pay":=SalNotch."Salary Amount";
                END;
                END;
                SalCard.INSERT;
                
                END;
                
                
                objPayrollPeriod.RESET;
                objPayrollPeriod.SETRANGE(objPayrollPeriod.Closed,FALSE);
                IF objPayrollPeriod.FIND('-') THEN BEGIN
                NotchTrans.RESET;
                NotchTrans.SETRANGE(NotchTrans."Salary Grade","Salary Grade");
                NotchTrans.SETRANGE(NotchTrans."Salary Step/Notch","Salary Notch/Step");
                IF NotchTrans.FIND('-') THEN BEGIN
                REPEAT
                EmpTrans.RESET;
                EmpTrans.SETCURRENTKEY(EmpTrans."Employee Code",EmpTrans."Transaction Code");
                EmpTrans.SETRANGE(EmpTrans."Employee Code","No.");
                EmpTrans.SETRANGE(EmpTrans."Transaction Code",NotchTrans."Transaction Code");
                EmpTrans.SETRANGE(EmpTrans."Payroll Period",objPayrollPeriod."Date Opened");
                IF EmpTrans.FIND('-') THEN BEGIN
                EmpTrans.Amount:=NotchTrans.Amount;
                EmpTrans.MODIFY;
                END ELSE BEGIN
                EmpTransR.INIT;
                EmpTransR."Employee Code":="No.";
                EmpTransR."Transaction Code":=NotchTrans."Transaction Code";
                EmpTransR."Period Month":=objPayrollPeriod."Period Month";
                EmpTransR."Period Year":=objPayrollPeriod."Period Year";
                EmpTransR."Payroll Period":=objPayrollPeriod."Date Opened";
                EmpTransR."Transaction Name":=NotchTrans."Transaction Name";
                EmpTransR.Amount:=NotchTrans.Amount;
                EmpTransR.INSERT;
                
                END;
                
                
                UNTIL NotchTrans.NEXT = 0;
                END;
                
                END;
                */

            end;
        }
        field(303; "Status Change Date"; Date)
        {
        }
        field(304; "Previous Month Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(305; "Current Month Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(306; "Prev. Basic Pay"; Decimal)
        {
            FieldClass = Normal;
        }
        field(307; "Curr. Basic Pay"; Decimal)
        {
            FieldClass = Normal;
        }
        field(308; "Prev. Gross Pay"; Decimal)
        {
            FieldClass = Normal;
        }
        field(309; "Curr. Gross Pay"; Decimal)
        {
            FieldClass = Normal;
        }
        field(310; "Gross Income Variation"; Decimal)
        {
            FieldClass = Normal;
        }
        field(311; "Basic Pay"; Decimal)
        {
            Editable = true;
        }
        field(312; "Net Pay"; Decimal)
        {
        }
        field(313; "Transaction Amount"; Decimal)
        {
        }
        field(314; "Transaction Code Filter"; Text[10])
        {
            FieldClass = FlowFilter;
            //TableRelation = "Bank Bal. Alert Buffer"."Line No.";
        }
        field(317; "Account Type"; Option)
        {
            OptionCaption = ' ,Savings,Current';
            OptionMembers = " ",Savings,Current;
        }
        field(318; "Location/Division Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('LOC/DIV'));
        }
        field(319; "Department Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(320; "Cost Centre Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('COSTCENTRE'));
        }
        field(323; "Payroll Type"; Option)
        {
            Description = 'General,Consultants,Seconded Staff';
            OptionCaption = 'General,Consultants,Seconded Staff';
            OptionMembers = General,Consultants,"Seconded Staff";
        }
        field(324; "Employee Classification"; Code[20])
        {
            Description = 'Service';
            //TableRelation = "Employee Class".Code;
        }
        field(328; "Department Name"; Text[40])
        {
        }
        field(2004; "Total Leave Taken"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Leave Entry Type" = CONST(Negative),
                                                                             Closed = CONST(false),
                                                                             "Leave Type" = CONST('ANNUAL')));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Leave Balance" := "Total (Leave Days)" + "Total Leave Taken";
            end;
        }
        field(2006; "Total (Leave Days)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(2007; "Cash - Leave Earned"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(2008; "Reimbursed Leave Days"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Leave Entry Type" = CONST(Reimbursement),
                                                                             "Leave Type" = FIELD("Leave Type Filter"),
                                                                             Closed = CONST(false)));
            DecimalPlaces = 2 : 2;
            Enabled = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                Validate("Allocated Leave Days");
                "Total (Leave Days)" := "Allocated Leave Days" + "Reimbursed Leave Days";
            end;
        }
        field(2009; "Cash per Leave Day"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(2023; "Allocated Leave Days"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Leave Entry Type" = CONST(Positive),
                                                                             Closed = CONST(false)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin

                "Total (Leave Days)" := "Allocated Leave Days" + "Reimbursed Leave Days";
                "Leave Balance" := "Total (Leave Days)" + "Total Leave Taken";

                /*
                CALCFIELDS("Total Leave Taken");
                "Total (Leave Days)" := "Allocated Leave Days" + "Reimbursed Leave Days";
                //SUM UP LEAVE LEDGER ENTRIES
                "Leave Balance" := "Total (Leave Days)" - "Total Leave Taken";
                //TotalDaysVal := Rec."Total Leave Taken";
                */

            end;
        }
        field(2024; "End of Contract Date"; Date)
        {
        }
        field(2040; "Leave Period Filter"; Code[20])
        {
        }
        field(3899; "Mutliple Bank A/Cs"; Boolean)
        {
        }
        field(3900; "No. Of Bank A/Cs"; Integer)
        {
            //CalcFormula = Count("HR Employee Bank Accounts" WHERE("Bank  Code" = FILTER(<> ''),
            //"Branch Code" = FILTER(<> ''),
            //"A/C  Number" = FILTER(<> ''),
            //"Employee Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(3971; "Annual Leave Account"; Decimal)
        {
        }
        field(3972; "Compassionate Leave Acc."; Decimal)
        {
        }
        field(3973; "Maternity Leave Acc."; Decimal)
        {
        }
        field(3974; "Paternity Leave Acc."; Decimal)
        {
        }
        field(3975; "Sick Leave Acc."; Decimal)
        {
        }
        field(3976; "Study Leave Acc"; Decimal)
        {
        }
        field(3977; "Appraisal Method"; Option)
        {
            OptionCaption = ' ,Normal Appraisal,360 Appraisal';
            OptionMembers = " ","Normal Appraisal","360 Appraisal";
        }
        field(3988; "Leave Type"; Code[20])
        {
            //TableRelation = "HR Applicant Profile"."Job Application No.";
        }
        field(3989; "Job Group"; Code[10])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Job Group"));

            trigger OnValidate()
            begin
                /*
                  EmpSalaryScale.RESET;
                  EmpSalaryScale.SETRANGE(EmpSalaryScale."Job Group","Job Group");
                  IF EmpSalaryScale.FIND('-') THEN
                  BEGIN
                  SalCard.RESET;
                  SalCard.SETRANGE(SalCard."Employee Code","No.");
                  IF SalCard.FIND('-') THEN
                    BEGIN
                    SalCard."Basic Pay":=EmpSalaryScale."Basic Pay 1 - Minimum";
                      SalCard.MODIFY ;
                 //   MESSAGE(FORMAT(SalCard."Basic Pay"))
                    END
                  END;


              //Get Open PR Period
              objPayrollPeriod.RESET;
              objPayrollPeriod.SETRANGE(objPayrollPeriod.Closed,FALSE);
              IF objPayrollPeriod.FIND('-') THEN
              BEGIN
                  IF CONFIRM(Text0005,FALSE,"No.",UPPERCASE("Full Name")) = FALSE THEN
                  BEGIN
                      ERROR('Process Aborted');
                  END ELSE
                  BEGIN
                      PRAllowances.RESET;
                      PRAllowances.SETRANGE(PRAllowances.County,"Global Dimension 2 Code");
                      PRAllowances.SETRANGE(PRAllowances."Job Group","Job Group");
                      IF PRAllowances.FIND('-') THEN
                      BEGIN
                          REPEAT
                              PREmpTrans.RESET;
                              PREmpTrans.SETRANGE(PREmpTrans."Employee Code","No.");
                              PREmpTrans.SETRANGE(PREmpTrans."Transaction Code",PRAllowances."Transaction Code");
                              PREmpTrans.SETRANGE(PREmpTrans."Payroll Period",objPayrollPeriod."Date Opened");
                              IF PREmpTrans.FIND('-') THEN
                              BEGIN
                                  PREmpTrans.Amount:=PRAllowances.Amount;
                                  PREmpTrans.MODIFY;
                              END;
                          UNTIL PRAllowances.NEXT =0;
                          MESSAGE('Process Complete');
                      END ELSE
                      BEGIN
                          ERROR(Text0006,"Global Dimension 2 Code","Job Group");
                      END;
                  END;
              END ELSE
              BEGIN
                  ERROR('Create a payroll period');
              END;
                */

            end;
        }
        field(39003900; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(39003901; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                /*
           //Get Open PR Period
           objPayrollPeriod.RESET;
           objPayrollPeriod.SETRANGE(objPayrollPeriod.Closed,FALSE);
           IF objPayrollPeriod.FIND('-') THEN
           BEGIN
               IF CONFIRM(Text0005,FALSE,"No.",UPPERCASE("Full Name")) = FALSE THEN
               BEGIN
                   ERROR('Process Aborted');
               END ELSE
               BEGIN
                   PRAllowances.RESET;
                   PRAllowances.SETRANGE(PRAllowances.County,"Global Dimension 2 Code");
                   PRAllowances.SETRANGE(PRAllowances."Job Group","Job Group");
                   IF PRAllowances.FIND('-') THEN
                   BEGIN
                       REPEAT
                           PREmpTrans.RESET;
                           PREmpTrans.SETRANGE(PREmpTrans."Employee Code","No.");
                           PREmpTrans.SETRANGE(PREmpTrans."Transaction Code",PRAllowances."Transaction Code");
                           PREmpTrans.SETRANGE(PREmpTrans."Payroll Period",objPayrollPeriod."Date Opened");
                           IF PREmpTrans.FIND('-') THEN
                           BEGIN
                               PREmpTrans.Amount:=PRAllowances.Amount;
                               PREmpTrans.MODIFY;
                           END;
                       UNTIL PRAllowances.NEXT =0;
                       MESSAGE('Process Complete');
                   END ELSE
                   BEGIN
                       ERROR(Text0006,"Global Dimension 2 Code","Job Group");
                   END;
               END;
           END ELSE
           BEGIN
               ERROR('Create a payroll period');
           END;

              */

            end;
        }
        field(39003902; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(39003903; HR; Boolean)
        {
        }
        field(39003904; "Date Of Joining the Company"; Date)
        {

            trigger OnValidate()
            begin
                "End Of Probation Date" := CalcDate('6M', "Date Of Joining the Company");
            end;
        }
        field(39003905; "Date Of Leaving the Company"; Date)
        {
        }
        field(39003906; "Termination Grounds"; Option)
        {
            OptionCaption = ' ,Resignation,Non-Renewal Of Contract,Dismissal,Retirement,Death,Other';
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Death,Other;
        }
        field(39003907; "Cell Phone Number"; Text[20])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(39003908; Grade; Code[20])
        {
            // TableRelation = "prSalary Scale".Grade;
        }
        field(39003909; "Employee UserID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(39003910; "Leave Balance"; Decimal)
        {
        }
        field(39003911; "Leave Status"; Option)
        {
            OptionCaption = ' ,On Leave,Resumed';
            OptionMembers = " ","On Leave",Resumed;
        }
        field(39003912; "Pension Scheme Join Date"; Date)
        {
        }
        field(39003913; "Medical Scheme Join Date"; Date)
        {
        }
        field(39003914; "Leave Type Filter"; Code[20])
        {
            TableRelation = "HR Leave Types";
        }
        field(39003915; "Acrued Leave Days"; Decimal)
        {
        }
        field(39003916; Supervisor; Boolean)
        {
        }
        field(39003917; Signature; BLOB)
        {
            SubType = Bitmap;
        }
        field(39003918; "Grant/Compliance Officer"; Boolean)
        {
        }
        field(39003919; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('PRODUCT'));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(39003920; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Fourth global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(39003921; Dim3; Text[40])
        {
        }
        field(39003922; Dim4; Text[50])
        {
        }
        field(39003923; IsPayrollPeriodCreator; Boolean)
        {
        }
        field(39003924; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Description = 'Stores the reference of the 5th global dimension in the database Station';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(39003925; "Institutional Base"; Decimal)
        {
        }
        field(39003926; "Extend Probation"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Extend Probation" = true then
                    "End Of Probation Date" := CalcDate('1Y', "Date Of Joining the Company")
                else
                    "End Of Probation Date" := CalcDate('6M', "Date Of Joining the Company");
            end;
        }
        field(39003927; "New Basic Pay"; Decimal)
        {
        }
        field(39003928; "Incremental Month"; Integer)
        {
        }
        field(39003929; "Incremental Month Description"; Text[30])
        {
        }
        field(39003930; "Deactivate Retirement alert"; Boolean)
        {
        }
        field(39003931; "Home County"; Code[20])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = CONST(County));

            trigger OnValidate()
            begin
                /**
                HRLookupValues.Reset;
                HRLookupValues.SetRange(HRLookupValues.Code, "Home County");
                if HRLookupValues.Find('-') then
                    "County Name" := HRLookupValues.Description;
                **/
            end;
        }
        field(39003932; "Education Level"; Option)
        {
            OptionMembers = " ",Diploma,Degree,Masters;

            trigger OnValidate()
            begin
                /*
                 SalCard.RESET;
                 SalCard.SETRANGE(SalCard."Employee Code","No.");
                 IF SalCard.FIND('-') THEN
                 BEGIN
                    IF ("Contract Type"="Contract Type"::Intern) AND ("Education Level"="Education Level"::Diploma) THEN
                    BEGIN
                       SalCard."Basic Pay":=20000;
                    END
                    ELSE IF ("Contract Type"="Contract Type"::Intern) AND ("Education Level"="Education Level"::Degree) THEN
                      BEGIN
                       SalCard."Basic Pay":=25000;
                     END ELSE
                     IF ("Contract Type"="Contract Type"::Intern) AND ("Education Level"="Education Level"::Masters) THEN
                     BEGIN
                       SalCard."Basic Pay":=30000;
                     END ;
                       MESSAGE(FORMAT(SalCard."Basic Pay"));

                   SalCard.MODIFY;
                   MESSAGE('SUCCESSFULLY UPDATED THE BASIC PAY',SalCard."Employee Code")

                 END
                */

            end;
        }
        field(39003933; "Acting Job Title"; Code[20])
        {
            TableRelation = "HR Jobs";
        }
        field(39003934; "Acting Job Group"; Code[10])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Job Group"));
        }
        field(39003935; "County Name"; Text[20])
        {
        }
        field(39003936; "Total Hours Worked"; Decimal)
        {
            //CalcFormula = Sum("HR Transport Allocation Matrix".Field50007 WHERE("Enrty No" = FIELD("No."),
            // Field50004 = FIELD("Date Filter")));
            //FieldClass = FlowField;
        }
        field(39003937; "Total Hours Not Worked"; Decimal)
        {
        }
        field(39003938; "Total Expected Hours Per Month"; Decimal)
        {
            FieldClass = Normal;
        }
        field(39003939; "Job Grade Range"; Code[10])
        {
            //TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Job Group Range"));
        }
        field(39003940; "Supervisor Code"; Code[10])
        {
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmp.Reset;
                HREmp.SetRange(HREmp."No.", "Supervisor Code");
                if HREmp.Find('-') then begin
                    "Supervisor Name" := HREmp."Full Name";
                    "Supervisor Email" := HREmp."Company E-Mail";
                end
            end;
        }
        field(39003941; "Supervisor Name"; Text[50])
        {
        }
        field(39003942; "Based On Hours worked"; Option)
        {
            OptionCaption = ' ,BasedOnWorkedHrs';
            OptionMembers = " ",BasedOnWorkedHrs;
        }
        field(39003943; Tribe; Code[10])
        {
        }
        field(39003944; "Employee Type"; Option)
        {
            OptionCaption = 'Primary Employee,Secondary Employee';
            OptionMembers = Primary,Secondary;
        }
        field(39003945; "Contract Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                //IF("Contract Type"= "Contract Type"::Contract) OR  ( "Contract Type"= "Contract Type"::Intern) THEN
                "Contract End Date" := CalcDate(Format("Contract Duration"), "Date Of Joining the Company")
            end;
        }
        field(39003946; "Is Board member"; Boolean)
        {
        }
        field(39003947; "Residential status"; Option)
        {
            OptionMembers = Resident,"Non-Resident";
        }
        field(39003948; "Supervisor Email"; Text[23])
        {
        }
        field(39003949; Muster; Option)
        {
            OptionMembers = Yes,No;
        }
        field(39003950; "Employee Category"; Option)
        {
            OptionCaption = ' ,Deployed';
            OptionMembers = " ",Deployed;
        }
        field(39003951; "Training Points"; Decimal)
        {
        }
        field(39003952; Lecturer; Boolean)
        {
        }
        field(39003953; "PWD No."; Code[10])
        {
        }
        field(39003954; "Staff Category"; Option)
        {
            OptionMembers = Lower,Middle,Senior,Supervisory;
        }
        field(39003955; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Employee';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order ",Employee;
        }
        field(39003956; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                if "Incoming Document Entry No." = xRec."Incoming Document Entry No." then
                    exit;
                if "Incoming Document Entry No." = 0 then
                    IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                /**else
                    IncomingDocument.SetEmployeeDoc(Rec); **/
            end;
        }
        field(39003957; "Date Of Current Appointment"; Date)
        {
        }
        field(39003958; "Approval Status"; Option)
        {
            OptionMembers = Open,Pending,Approved;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "First Name")
        {
        }
        key(Key3; "Last Name")
        {
        }
        key(Key4; "ID Number")
        {
        }
        key(Key5; "Known As")
        {
        }
        key(Key6; "User ID")
        {
        }
        key(Key7; "Cost Code")
        {
        }
        key(Key8; "Date Of Join", "Date Of Leaving")
        {
        }
        key(Key9; "Termination Category")
        {
        }
        key(Key10; "Department Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Initials, "First Name", "Middle Name", "Last Name")
        {
        }
    }

    trigger OnDelete()
    begin
        Error('You are not allowed to delete any Employee record')
    end;

    trigger OnInsert()
    begin
        /*
        IF "No." = '' THEN BEGIN
          HrSetup.RESET;
          HrSetup.GET;
          HrSetup.TESTFIELD(HrSetup."Employee Nos.");
          NoSeriesMgt.InitSeries(HrSetup."Employee Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
        */

    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Res: Record Resource;
        PostCode: Record "Post Code";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        OK: Boolean;
        User: Record "User Setup";
        ERROR1: Label 'Employee Career History Starting Information already exist.';
        MSG1: Label 'Employee Career History Starting Information successfully created.';
        ReasonDiaglog: Dialog;
        EmpQualification: Record "Employee Qualification";
        PayStartDate: Date;
        PayPeriodText: Text[30];
        ToD: Date;
        CurrentMonth: Date;
        HrSetup: Record "HR Setup";
        //SalCard: Record "prSalary Card";
        //objPayrollPeriod: Record "prPayroll Periods";
        //EmpTrans: Record "prEmployee Transactions";
        //EmpTransR: Record "prEmployee Transactions";
        UserMgt: Codeunit "User Management";
        DimVal: Record "Dimension Value";
        objJobs: Record "HR Jobs";
        HREmp: Record "HR Employees";
        EmpFullName: Text;
        SPACER: Label ' ';
        yDOB: Integer;
        yTODAY: Integer;
        noYrsToRetirement: Integer;
        RetirementYear: Integer;
        AppAge: Integer;
        RetirementYear2: Text;
        Dates: Codeunit "HR Dates";
        Dimn: Record "Dimension Value";
        RetirementDate: Date;
        dDOB: Integer;
        mDOB: Integer;
        DaystoRetirement: Text;
        //HRAllowances: Record "HR Allowance Table";
        //EmpSalaryScale: Record "HR Allowance Table";
        Text0005: Label 'If you modify this field you will modify PAYROLL TRANSACTION for the current Period for this [ STAFF NO :: %1 - %2 ] \\PROCEED?';
        //PRAllowances: Record "PR Employees Salary Scale";
        //PREmpTrans: Record "prEmployee Transactions";
        //Text0006: Label 'No Rates have been defined for [ COUNTY %1 - JOB GROUP %2 ]';
        //PREmpTrans_2: Record "prEmployee Transactions";
        //HRLookupValues: Record "HR Lookup Values";

        EventSubscriber: Codeunit EventSubscriber;

    procedure AssistEdit(OldEmployee: Record "HR Employees"): Boolean
    begin
    end;

    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("Known As" + ' ' + "Last Name")
        else
            exit("Known As" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    procedure CurrentPayDetails()
    begin
    end;

    procedure UpdtResUsersetp(var HREmpl: Record "HR Employees")
    var
        Res: Record Resource;
        Usersetup: Record "User Setup";
    begin
        /*
        ContMgtSetup.GET;
        IF ContMgtSetup."Customer Integration" =
           ContMgtSetup."Customer Integration"::"No Integration"
        THEN
          EXIT;
        */
        /*
        Res.SETCURRENTKEY("No.");
        Res.SETRANGE("No.",HREmpl."Resource No.");
        IF Res.FIND('-') THEN BEGIN
          Res."Global Dimension 1 Code" := HREmpl."Department Code";
          Res."Global Dimension 2 Code" := HREmpl.Office;
          Res.MODIFY;
        END;
        
        IF Usersetup.GET(HREmpl."User ID") THEN BEGIN
          Usersetup.Department := HREmpl."Department Code";
          Usersetup.Office := HREmpl.Office;
          Usersetup.MODIFY;
        END;
        */

    end;

    procedure SetEmployeeHistory()
    begin
    end;

    procedure GetPayPeriod()
    begin
    end;

    local procedure fn_FullName()
    begin
        "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
    end;

    local procedure fnCalcRetDate()
    var
        HRSetup: Record "HR Setup";
    begin
        HRSetup.Get;
        if Disabled = Disabled::No then
            "Retirement date" := CalcDate(Format(HRSetup."Retirement Age") + 'Y', "Date Of Birth")
        else
            if Disabled = Disabled::Yes then
                "Retirement date" := CalcDate(Format(HRSetup."Retirement Age Disabled") + 'Y', "Date Of Birth");
    end;
}

