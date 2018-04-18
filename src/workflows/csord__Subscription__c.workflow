<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UM_SubscriptionStatusUpdate</fullName>
        <description>Update status to Externally Active for Voiceworks Subscriptions that are not needed for MACD</description>
        <field>csord__Status__c</field>
        <formula>&quot;Externally Active&quot;</formula>
        <name>Subscription Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Externally Active Subscriptions</fullName>
        <actions>
            <name>UM_SubscriptionStatusUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 4) AND 3</booleanFilter>
        <criteriaItems>
            <field>csord__Subscription__c.Name</field>
            <operation>contains</operation>
            <value>Dienste</value>
        </criteriaItems>
        <criteriaItems>
            <field>csord__Subscription__c.Name</field>
            <operation>contains</operation>
            <value>Dienstleistungen</value>
        </criteriaItems>
        <criteriaItems>
            <field>csord__Subscription__c.csord__Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>csord__Subscription__c.Name</field>
            <operation>contains</operation>
            <value>pakete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
