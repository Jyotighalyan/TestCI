<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Address_Area_Update</fullName>
        <field>Address_Area__c</field>
        <formula>$Label.UM_Unitymedia_BW_GmbH_Address</formula>
        <name>Address Area Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address_area_field_update_1</fullName>
        <field>Address_Area__c</field>
        <formula>$Label.UM_Unitymedia_NRW_GmbH_Address</formula>
        <name>Address area field update 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address_area_field_update_2</fullName>
        <field>Address_Area__c</field>
        <formula>$Label.UM_Unitymedia_Hessen_GmbH_Co_KG_Address</formula>
        <name>Address area field update 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UM_AddressAreaUpdateAddress1</fullName>
        <actions>
            <name>Address_Area_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.CompanyName</field>
            <operation>equals</operation>
            <value>Unitymedia BW GmbH</value>
        </criteriaItems>
        <description>Address area needs to be updated according to company name of user</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_AddressAreaUpdateAddress2</fullName>
        <actions>
            <name>Address_area_field_update_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.CompanyName</field>
            <operation>equals</operation>
            <value>Unitymedia NRW GmbH</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_AddressAreaUpdateAddress3</fullName>
        <actions>
            <name>Address_area_field_update_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.CompanyName</field>
            <operation>equals</operation>
            <value>Unitymedia Hessen GmbH &amp; Co. KG</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
