<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_start_date</fullName>
        <field>LG_MandateStartDate__c</field>
        <formula>Issue_date__c</formula>
        <name>Copy start date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Billing_Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_mandate</fullName>
        <field>UM_MandateReferenceNumber__c</field>
        <formula>Name</formula>
        <name>Update mandate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Billing_Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Copy mandate %23</fullName>
        <actions>
            <name>Update_mandate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>mandate__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM_CopyMandateRefNumber</fullName>
        <actions>
            <name>Copy_start_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_mandate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>mandate__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
