<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>B2B_Cama_Case_Completion_Alert</fullName>
        <description>Cama Case Completion Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Cama_Case_Completion_Notification</template>
    </alerts>
    <alerts>
        <fullName>B2B_Email_Alert_To_Agent</fullName>
        <description>Email Alert To Agent</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_Assigned_Alert_Level2</template>
    </alerts>
    <alerts>
        <fullName>B2B_Email_Alert_To_Agent_Admin</fullName>
        <description>Email Alert To Agent Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_Assigned_Alert_Level2_Admin</template>
    </alerts>
    <alerts>
        <fullName>B2B_Email_Alert_To_Agent_Service</fullName>
        <description>Email Alert To Agent Service</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_Assigned_Alert_Level2_Service</template>
    </alerts>
    <alerts>
        <fullName>B2B_Keep_Customer_Informed</fullName>
        <description>Keep Customer Informed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Silver</template>
    </alerts>
    <alerts>
        <fullName>B2B_Notify_Manager</fullName>
        <description>Notify Manager</description>
        <protected>false</protected>
        <recipients>
            <field>B2B_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_Assigned_Alert_Level3</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breach_Notification_Admin</fullName>
        <description>SLA Breach Notification Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_SLA_Breached_Notification_Admin</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breach_Notification_Service</fullName>
        <description>B2B_SLA_Breach_Notification_Service</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_SLA_Breached_Notification_Service</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breach_Warning_Agent</fullName>
        <description>SLA Breach Warning Agent</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_SLA_Alert_OneHourBefore</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breach_Warning_Manager</fullName>
        <description>SLA Breach Warning Manager</description>
        <protected>false</protected>
        <recipients>
            <field>B2B_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_SLA_Alert_15minBefore</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breached</fullName>
        <description>SLA Breached Notification</description>
        <protected>false</protected>
        <recipients>
            <field>B2B_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_SLA_Breached_Notification</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breached_Notification_2HoursBefore</fullName>
        <description>B2B_SLA_Breached_Notification_2HoursBefore</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_SLA_Breached_Notification_2HoursBefore</template>
    </alerts>
    <alerts>
        <fullName>B2B_SLA_Breached_Notification_Before_8Hours</fullName>
        <description>SLA Breached Notification Before 8Hours</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_SLA_Breached_Notification_8HoursBefore</template>
    </alerts>
    <alerts>
        <fullName>B2B_UnAssigned_Case</fullName>
        <description>UnAssigned Case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Case_NotAssigned_Alert_Level1</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Email_Alert</fullName>
        <description>Case Creation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Care_Case_2_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Milestone_Clock_Resume_Notification</fullName>
        <description>Case Milestone Clock Resume Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/Case_Milestone_Resume</template>
    </alerts>
    <alerts>
        <fullName>Keep_Your_Customer_Informed_Gold</fullName>
        <description>Keep Your Customer Informed Gold</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Gold_R1</template>
    </alerts>
    <alerts>
        <fullName>Keep_Your_Customer_Informed_Gold_R2</fullName>
        <description>Keep Your Customer Informed Gold R2</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Gold_R2</template>
    </alerts>
    <alerts>
        <fullName>Keep_Your_Customer_Informed_Platinum</fullName>
        <description>Keep Your Customer Informed Platinum</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Platinum_R1</template>
    </alerts>
    <alerts>
        <fullName>Keep_Your_Customer_Informed_Platinum_R2</fullName>
        <description>Keep Your Customer Informed Platinum R2</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Platinum_R2</template>
    </alerts>
    <alerts>
        <fullName>Keep_Your_Customer_Informed_Platinum_R3</fullName>
        <description>Keep Your Customer Informed Platinum R3</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Platinum_R3</template>
    </alerts>
    <alerts>
        <fullName>Keep_Your_Customer_Informed_Silver</fullName>
        <description>Keep Your Customer Informed Silver</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_Keep_Your_Customer_Informed_Silver</template>
    </alerts>
    <alerts>
        <fullName>LG_FollowOnInstructions</fullName>
        <description>Email follow on instructions</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LG_FollowOnInstructions</template>
    </alerts>
    <alerts>
        <fullName>SLA_Breached_Notification_After4Hours</fullName>
        <description>SLA Breached Notification After4Hours</description>
        <protected>false</protected>
        <recipients>
            <field>B2B_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply_care@unitymedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>B2B_Care/B2B_SLA_Breached_Notification_4HoursAgo</template>
    </alerts>
    <fieldUpdates>
        <fullName>Autopopulate_Case_Sla_Breached_No</fullName>
        <description>Autopopulate Case Sla Breached</description>
        <field>SLA_Breached__c</field>
        <formula>IF( SLA_Breached__c == &apos;Yes&apos;, &apos;Yes&apos;, &apos;No&apos;)</formula>
        <name>Autopopulate Case Sla Breached</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Autopopulate_Case_Sla_Breached_voilation</fullName>
        <description>Autopopulate Case Sla Breached</description>
        <field>SLA_Breached__c</field>
        <formula>&quot;Yes&quot;</formula>
        <name>Autopopulate Case Sla Breached voilation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Default_Preferred_Comm_Value</fullName>
        <field>B2B_Preferred_Communication_Channel__c</field>
        <literalValue>Email</literalValue>
        <name>Default Preferred Communication Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Pause_Time_Calculate</fullName>
        <field>B2B_Care_Case_Pause_Time__c</field>
        <formula>TEXT (ROUND(IF(  VALUE(B2B_Care_Case_Pause_Time__c )=0  , (NOW()-PRIORVALUE(StopStartDate )),  ( VALUE(B2B_Care_Case_Pause_Time__c )  +(NOW() - PRIORVALUE( StopStartDate ))) ),3) )</formula>
        <name>Pause Time Calculate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_StatusUpdate_EmailtoCase</fullName>
        <description>Update Status field when case is created via email to case functionality.</description>
        <field>Status</field>
        <literalValue>Enquiry</literalValue>
        <name>B2B_StatusUpdate_EmailtoCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Update_Assigned_Date</fullName>
        <description>Update the case assigned date so that same can be used to notify Agent&apos;s Manager if case is still not worked upon.</description>
        <field>B2B_Case_Assigned_Date__c</field>
        <formula>B2B_Case_Assigned_Date__c + 30/1440</formula>
        <name>Update Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Update_Case_Assigned_Date</fullName>
        <description>Update Case Assigned Date field once case is assigned to a user from a queue</description>
        <field>B2B_Case_Assigned_Date__c</field>
        <formula>NOW() - 30/1440</formula>
        <name>Update Case Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Update_Manager_Email</fullName>
        <description>Update manager email field</description>
        <field>B2B_Manager_Email__c</field>
        <formula>IF( BEGINS( OwnerId , &apos;005&apos;) , Owner:User.Manager.Email,  Owner:Queue.QueueEmail )</formula>
        <name>Update Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Update_Manager_FName</fullName>
        <field>B2B_Manager_FName__c</field>
        <formula>IF( BEGINS( OwnerId , &apos;005&apos;) , Owner:User.Manager.FirstName, &apos; &apos; )</formula>
        <name>Update Manager FName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>B2B_Update_Temporary_Date</fullName>
        <description>Capture Temporary Date</description>
        <field>B2B_Temporary_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Temporary Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_SLA_Pause_Date_Blank</fullName>
        <field>LG_B2B_SLA_Paused_Date__c</field>
        <name>Case SLA Pause Date Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_SLA_Resume</fullName>
        <field>IsStopped</field>
        <literalValue>0</literalValue>
        <name>Case SLA Resume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_After_SLA_Pause</fullName>
        <description>Moving SLA Status field to in progress</description>
        <field>Status</field>
        <literalValue>In progress</literalValue>
        <name>Case Status After SLA Pause</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalate_Check</fullName>
        <description>Mark Escalate Checkbox as true</description>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Escalate Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Udpate_Case_Status</fullName>
        <description>Update case status to closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Udpate Case Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Order_Comment_Pre_value</fullName>
        <field>UM_Order_Comment_Prior_value__c</field>
        <formula>PRIORVALUE( B2B_Order_Comment__c )</formula>
        <name>Update Order Comment Pre value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Case_Outbound</fullName>
        <apiVersion>41.0</apiVersion>
        <endpointUrl>https://jit-api-libertyglobal-com.upc.biz:443/NotificationCase/v1.0/pushCase</endpointUrl>
        <fields>AccountId</fields>
        <fields>B2B_Alternate_Contact_Name__c</fields>
        <fields>B2B_Alternate_Contact_Number__c</fields>
        <fields>B2B_Alternate_Email__c</fields>
        <fields>CaseNumber</fields>
        <fields>ContactId</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Description</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>LG_Billing_Account__c</fields>
        <fields>LG_Case_Reason__c</fields>
        <fields>LG_Change_Effective_Date__c</fields>
        <fields>LG_Invoice_Header__c</fields>
        <fields>LG_Service__c</fields>
        <fields>LastModifiedDate</fields>
        <fields>Origin</fields>
        <fields>Priority</fields>
        <fields>Reason</fields>
        <fields>RecordTypeId</fields>
        <fields>Status</fields>
        <fields>Type</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>lgdepuser@apiuser.com</integrationUser>
        <name>Case Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Auto Close Resolved Cases</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Change Request,Online Billing Query,Service Change Request,Technical Case,General Query,SLA Breach Case,Complaint,Planned Maintenance Case,Outage/Network Incident,Billing Query</value>
        </criteriaItems>
        <description>Workflow to close a resolved case after 7 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Udpate_Case_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>LG DEP CaseCreated</fullName>
        <actions>
            <name>Send_Mail_to_Contact_Person</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG DEP CaseUpdate</fullName>
        <actions>
            <name>Case_Outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>Case update to DEP</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>B2B Capture Case Assigned Time</fullName>
        <actions>
            <name>B2B_Update_Case_Assigned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>B2B_Update_Temporary_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Capture time when case is assgined from a queue to user</description>
        <formula>OR(  	AND(  			OR(  				RecordType.DeveloperName = &apos;LG_B2B_Care_Admin_Change_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;B2B_Care_Billing_Query_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Complaint_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Online_Billing_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_SLA_Breach_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Service_Change_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Mass_Outage_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Planned_Maintenance_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Technical_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_General_Query_Request_UM&apos;  			),  			AND(  			     LEFT(OwnerId, 3 ) = &apos;005&apos;,  				 OR( 				 ISBLANK(B2B_Case_Assigned_Date__c), 				 ISNULL(B2B_Case_Assigned_Date__c) 				 ) 			) 	),  	AND  		(  			OR (  				RecordType.DeveloperName = &apos;LG_B2B_Care_Admin_Change_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;B2B_Care_Billing_Query_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Complaint_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Online_Billing_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_SLA_Breach_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Service_Change_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Mass_Outage_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Planned_Maintenance_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_Technical_Request_UM&apos; ,  				RecordType.DeveloperName = &apos;LG_B2B_Care_General_Query_Request_UM&apos;  			),  		ISCHANGED( OwnerId ),  		LEFT(OwnerId, 3 ) = &apos;005&apos;,  		LEFT(PRIORVALUE(OwnerId), 3) = &apos;00G&apos;,         OR( 		    ISBLANK(B2B_Case_Assigned_Date__c), 			ISNULL(B2B_Case_Assigned_Date__c) 		)	 	)		 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>B2B Case Not Progressing</fullName>
        <active>true</active>
        <description>case is assigned to a agent but status kept as open, assigned or Enquiry</description>
        <formula>AND ( 
		OR( 
			AND(
				RecordType.DeveloperName = &apos;LG_B2B_Care_Technical_Request_UM&apos;,
				NOT(
					OR( ISPICKVAL(Type, &apos;Logistics&apos;) , 
						ISPICKVAL(Type, &apos;Installation&apos;) , 
						ISPICKVAL(Type, &apos;Provisioning/selfinstall&apos;)
					  )  
					)
				), 
			RecordType.DeveloperName = &apos;B2B_Care_Billing_Query_Request_UM&apos; , 
			RecordType.DeveloperName = &apos;LG_B2B_Care_Complaint_Request_UM&apos; , 
			RecordType.DeveloperName = &apos;LG_B2B_Care_Online_Billing_Request_UM&apos; , 
			RecordType.DeveloperName = &apos;LG_B2B_Care_SLA_Breach_Request_UM&apos; , 
			RecordType.DeveloperName = &apos;LG_B2B_Care_Mass_Outage_Request_UM&apos; , 
			RecordType.DeveloperName = &apos;LG_B2B_Care_Planned_Maintenance_Request_UM&apos; , 
			RecordType.DeveloperName = &apos;LG_B2B_Care_General_Query_Request_UM&apos; ) , 
		OR( ISPICKVAL(Status, &apos;Open&apos;) , 
			ISPICKVAL(Status, &apos;Assigned&apos;) , 
			ISPICKVAL(Status, &apos;Enquiry&apos;) ) , 
		BEGINS( OwnerId , &apos;005&apos;) 
	)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>B2B_Email_Alert_To_Agent</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.B2B_Case_Assigned_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>B2B_Notify_Manager</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.B2B_Temporary_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>B2B Case Not Progressing Admin</fullName>
        <active>true</active>
        <description>case is assigned to a agent but status kept as open, assigned or Enquiry</description>
        <formula>AND  (   RecordType.DeveloperName = &apos;LG_B2B_Care_Admin_Change_Request_UM&apos;  ,  OR(  ISPICKVAL(Status, &apos;Open&apos;)  ,  ISPICKVAL(Status, &apos;Assigned&apos;) )  ,  BEGINS( OwnerId , &apos;005&apos;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>B2B_Email_Alert_To_Agent_Admin</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.B2B_Temporary_Date__c</offsetFromField>
            <timeLength>20</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>B2B Case Not Progressing Service</fullName>
        <active>true</active>
        <description>case is assigned to a agent but status kept as open, assigned or Enquiry</description>
        <formula>AND ( 

OR( RecordType.DeveloperName = &apos;LG_B2B_Care_Service_Change_Request_UM&apos; ,
	AND (RecordType.DeveloperName = &apos;LG_B2B_Care_Technical_Request_UM&apos; , 
		OR( ISPICKVAL(Type, &apos;Logistics&apos;) , 
			ISPICKVAL(Type, &apos;Installation&apos;) , 
			ISPICKVAL(Type, &apos;Provisioning/selfinstall&apos;) 
		  )
		) 
	),
OR( ISPICKVAL(Status, &apos;Open&apos;) , ISPICKVAL(Status, &apos;Assigned&apos;) ) , 
BEGINS( OwnerId , &apos;005&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>B2B_Email_Alert_To_Agent_Service</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.B2B_Temporary_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>B2B OLA Monitor</fullName>
        <active>true</active>
        <description>Track Case Progress</description>
        <formula>AND  (  OR(  RecordType.DeveloperName = &apos;LG_B2B_Care_Technical_Request_UM&apos; , RecordType.DeveloperName = &apos;LG_B2B_Care_Admin_Change_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;B2B_Care_Billing_Query_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Complaint_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Online_Billing_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_SLA_Breach_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Service_Change_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Mass_Outage_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Planned_Maintenance_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_General_Query_Request_UM&apos;  )  ,  OR(  ISPICKVAL(Status, &apos;Open&apos;)  ,  ISPICKVAL(Status, &apos;Assigned&apos;)  ,  ISPICKVAL(Status, &apos;Enquiry&apos;)  )  ,  BEGINS( OwnerId , &apos;00G&apos;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>B2B_UnAssigned_Case</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.B2B_Case_UnAssigned_Level1__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>B2B Update Manager Email</fullName>
        <actions>
            <name>B2B_Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>B2B_Update_Manager_FName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Manager Email field with assigned case owners manager email id</description>
        <formula>AND  (  OR(  RecordType.DeveloperName = &apos;LG_B2B_Care_Technical_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Admin_Change_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;B2B_Care_Billing_Query_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Complaint_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Online_Billing_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_SLA_Breach_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Service_Change_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Mass_Outage_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_Planned_Maintenance_Request_UM&apos;  ,  RecordType.DeveloperName = &apos;LG_B2B_Care_General_Query_Request_UM&apos;  )  ,   OR(  ISCHANGED(OwnerId),  ISBLANK( B2B_Manager_Email__c )    )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>B2B_Cama_Case_Completion_Notification</fullName>
        <actions>
            <name>B2B_Cama_Case_Completion_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CaMa Ticket</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.B2B_Order_Status__c</field>
            <operation>startsWith</operation>
            <value>CP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.B2B_Order_Status__c</field>
            <operation>startsWith</operation>
            <value>CN</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>B2B_Email_To_Case</fullName>
        <actions>
            <name>B2B_Default_Preferred_Comm_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>B2B_StatusUpdate_EmailtoCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Technical Case,General Query</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>--None--</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Workflow to update status of Email to case as Enquiry.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalation Rule</fullName>
        <actions>
            <name>Escalate_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Change Request,Online Billing Request,Service Change Request,General Query Request,Complaint Request,Billing Query Request,SLA Breach Case</value>
        </criteriaItems>
        <description>This workflow is for marking a case as escalated if its priority is selected as Escalated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Pause Time Manual</fullName>
        <actions>
            <name>B2B_Pause_Time_Calculate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculate Case Pause time for manual resolved,on-hold cases</description>
        <formula>AND(RecordType.DeveloperName==&apos;LG_B2B_Care_Technical_Request_UM&apos; ,  OR(ISPICKVAL(PRIORVALUE(Status) ,&quot;Resolved&quot;) ,ISPICKVAL(PRIORVALUE(Status) ,&quot;On-hold - Customer&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Stopped end time</fullName>
        <active>false</active>
        <formula>AND( ISCHANGED( IsStopped ) , PRIORVALUE( IsStopped )=True )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_FollowOnInstructions</fullName>
        <actions>
            <name>LG_FollowOnInstructions</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Follow Up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Follow-On Order</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LG_SLA Paused Till</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2  AND (3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.LG_B2B_SLA_Paused_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>On-hold - Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service Change Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Technical Case</value>
        </criteriaItems>
        <description>Rule Created for Pausing the SLA for specified date/time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Milestone_Clock_Resume_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>B2B_Pause_Time_Calculate</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_SLA_Pause_Date_Blank</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_SLA_Resume</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Status_After_SLA_Pause</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LG_SLA_Resume_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update_Order_Comment_PreviousValue</fullName>
        <actions>
            <name>Update_Order_Comment_Pre_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF will update the previous value of the order comment.</description>
        <formula>ISCHANGED( B2B_Order_Comment__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>B2B_Call_Customer_To_Apologies</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Call Customer To Apologies</subject>
    </tasks>
</Workflow>
