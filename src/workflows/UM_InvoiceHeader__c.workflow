<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UM_Update_Gross_Invoice_Amount_Currency</fullName>
        <field>UM_Invoice_Amount_Gross_Currency__c</field>
        <formula>UM_Invoice_Amount_Gross__c / 100</formula>
        <name>Update Gross Invoice Amount Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Name_Invoice_Headers</fullName>
        <field>Name</field>
        <formula>UM_InvoiceNumber__c</formula>
        <name>Update Name Invoice Headers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Net_Invoice_Amount_Currency</fullName>
        <field>UM_Invoice_Amount_Net_Currency__c</field>
        <formula>UM_Invoice_Amount_Net__c / 100</formula>
        <name>Update Net Invoice Amount Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UM_FillInvoiceAmountGrossCurrency</fullName>
        <actions>
            <name>UM_Update_Gross_Invoice_Amount_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fill currency field related to Gross Invoice Amount</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Invoice_Amount_Gross__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_FillInvoiceAmountNetCurrency</fullName>
        <actions>
            <name>UM_Update_Net_Invoice_Amount_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fill currency field related to Net Invoice Amount</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Invoice_Amount_Net__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_UpdateNameInvoiceHeaders</fullName>
        <actions>
            <name>UM_Update_Name_Invoice_Headers</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(UM_InvoiceNumber__c),    ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
