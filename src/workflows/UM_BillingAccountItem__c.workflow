<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UM_Reset_Is_Future_Dated_Flag</fullName>
        <description>Set Is Future Dated flag to false on Billing Account Item, when Start Date is Greater than Today</description>
        <field>UM_Is_Future_Dated__c</field>
        <literalValue>0</literalValue>
        <name>UM_Reset_Is_Future_Dated_Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_ApprovalStatus_Recalled</fullName>
        <description>updates Approval Status to Recalled</description>
        <field>UM_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Update ApprovalStatus Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_ApprovalStatus_to_Approved</fullName>
        <description>updates the Approval Status to Approved</description>
        <field>UM_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update ApprovalStatus to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_ApprovalStatus_to_Pending</fullName>
        <description>updates Approval status to Pending</description>
        <field>UM_Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Update ApprovalStatus to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_ApprovalStatus_to_Rejected</fullName>
        <description>updates the Approval status to Rejected</description>
        <field>UM_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update ApprovalStatus to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_ApprovalTimestamp_Approved</fullName>
        <description>Updates current timestamp</description>
        <field>UM_Approval_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Update ApprovalTimestamp Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_ApprovalTimestamp_Recalled</fullName>
        <description>update approval timestamp</description>
        <field>UM_Approval_Timestamp__c</field>
        <formula>Now()</formula>
        <name>Update ApprovalTimestamp Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Approval_Timestamp_Rejection</fullName>
        <description>update the Approval Timestamp field</description>
        <field>UM_Approval_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Update Approval Timestamp Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UM_Update_Future_Dated_Flag</fullName>
        <active>true</active>
        <criteriaItems>
            <field>UM_BillingAccountItem__c.UM_StartDate__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>UM_BillingAccountItem__c.UM_Is_Future_Dated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Reset &quot;Is Future Dated&quot; flag on Billing Account Item when start date is current date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UM_Reset_Is_Future_Dated_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>UM_BillingAccountItem__c.UM_StartDate__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
