<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Date_of_Last_Stage_Change</fullName>
        <field>UM_DateOfLastStageChange__c</field>
        <formula>TODAY()</formula>
        <name>Date of Last Stage Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Date of Last Stage Change</fullName>
        <actions>
            <name>Date_of_Last_Stage_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( UM_Stage__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
