<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UM_Translate_Payment_Method</fullName>
        <field>UM_Payment_Method_Translation__c</field>
        <formula>CASE(UM_Payment_Method__c,
     &quot;1&quot;, &quot;Check&quot;,
     &quot;3&quot;, &quot;Direct Debit&quot;,
     &quot;4&quot;, &quot;Debit Card&quot;,
     &quot;Not Defined&quot;)</formula>
        <name>Translate Payment Method</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Translate_Transaction_Date</fullName>
        <field>UM_Transaction_Date_Converted__c</field>
        <formula>DATETIMEVALUE(LEFT(UM_Transaction_Date__c,4)+&quot;-&quot;+
              MID(UM_Transaction_Date__c,5,2)+&quot;-&quot;+
              MID(UM_Transaction_Date__c,7,2)+&quot; &quot;+
              MID(UM_Transaction_Date__c,9,2)+&quot;:&quot;+
              MID(UM_Transaction_Date__c,11,2)+&quot;:&quot;+
              RIGHT(UM_Transaction_Date__c,2))</formula>
        <name>Translate Transaction Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Translate_Transaction_Status</fullName>
        <field>UM_Transaction_Status_Translation__c</field>
        <formula>CASE(UM_Transaction_Status__c,
     &quot;0&quot;, &quot;Waiting&quot;,
     &quot;1&quot;, &quot;Hold&quot;,
     &quot;2&quot;, &quot;Sent&quot;,
     &quot;3&quot;, &quot;Accepted&quot;,
     &quot;4&quot;, &quot;Rejected&quot;,
     &quot;5&quot;, &quot;Payment Reversal&quot;,
     &quot;6&quot;, &quot;Canceled&quot;,
     &quot;7&quot;, &quot;Deleted&quot;,
     &quot;8&quot;, &quot;Posted&quot;,
     &quot;9&quot;, &quot;Disconnected Account Record&quot;,
     &quot;Not Defined&quot;)</formula>
        <name>Translate Transaction Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Name_Payments</fullName>
        <field>Name</field>
        <formula>UM_Transaction_ID__c</formula>
        <name>Update Name Payments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Overpayments_Currency</fullName>
        <field>UM_Overpayments_Currency__c</field>
        <formula>UM_Overpayments__c / 100</formula>
        <name>Update Overpayments Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Transaction_Amount_Currency</fullName>
        <field>UM_Transaction_Amount_Currency__c</field>
        <formula>UM_Transaction_Amount__c / 100</formula>
        <name>Update Transaction Amount Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UM_FillOverpaymentsCurrency</fullName>
        <actions>
            <name>UM_Update_Overpayments_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fill currency field related to Overpayments</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Overpayments__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_FillTransactionAmountCurrency</fullName>
        <actions>
            <name>UM_Update_Transaction_Amount_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fill currency field related to Transaction Amount</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Transaction_Amount__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslatePaymentMethod</fullName>
        <actions>
            <name>UM_Translate_Payment_Method</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Translate number value from Kenan to Readable text</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Payment_Method__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslateTransactionDate</fullName>
        <actions>
            <name>UM_Translate_Transaction_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Translate number value from Kenan to date time in Salesforce</description>
        <formula>AND(OR(ISNEW(),    ISCHANGED(UM_Transaction_Date__c)), NOT(ISBLANK(UM_Transaction_Date__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslateTransactionStatus</fullName>
        <actions>
            <name>UM_Translate_Transaction_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Translate number value from Kenan to Readable text</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Transaction_Status__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_UpdateNamePayments</fullName>
        <actions>
            <name>UM_Update_Name_Payments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(UM_Transaction_ID__c),     ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
