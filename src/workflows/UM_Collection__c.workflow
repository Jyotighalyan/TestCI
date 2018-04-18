<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UM_Translate_Collection_Hold_Status</fullName>
        <field>UM_Collection_Hold_Status_Translation__c</field>
        <formula>CASE(UM_Collection_Hold_Status__c, 
     &quot;1&quot;, &quot;On Hold&quot;,
     &quot;Not Defined&quot;)</formula>
        <name>Translate Collection Hold Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Translate_Collection_Indicator</fullName>
        <field>UM_Collection_Indicator_Translation__c</field>
        <formula>CASE(UM_Collection_Indicator__c,
     &quot;0&quot;, &quot;Not in Collection&quot;,
     &quot;1&quot;, &quot;Automatically Placed into Collections&quot;,
     &quot;Not Defined&quot;)</formula>
        <name>Translate Collection Indicator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Translate_Collection_Method</fullName>
        <field>UM_Collection_Method_Translation__c</field>
        <formula>CASE(UM_Collection_Method__c,
     &quot;0&quot;, &quot;Manual&quot;,
     &quot;1&quot;, &quot;Automatic&quot;,
     &quot;Not Defined&quot;)</formula>
        <name>Translate Collection Method</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Translate_Collection_Start_Date</fullName>
        <field>UM_Collection_Start_Date_Converted__c</field>
        <formula>DATETIMEVALUE(LEFT(UM_Collection_Start_Date__c,4)+&quot;-&quot;+ 
              MID(UM_Collection_Start_Date__c,5,2)+&quot;-&quot;+ 
              MID(UM_Collection_Start_Date__c,7,2)+&quot; &quot;+ 
              MID(UM_Collection_Start_Date__c,9,2)+&quot;:&quot;+ 
              MID(UM_Collection_Start_Date__c,11,2)+&quot;:&quot;+ 
              RIGHT(UM_Collection_Start_Date__c,2))</formula>
        <name>Translate Collection Start-Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Collection_Amount_Currency</fullName>
        <field>UM_Collection_Amount_Currency__c</field>
        <formula>UM_Collection_Amount__c / 100</formula>
        <name>Update Collection Amount Currency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Update_Name_Collections</fullName>
        <field>Name</field>
        <formula>UM_Collection_ID__c</formula>
        <name>Update Name Collections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UM_FillCollectionAmountCurrency</fullName>
        <actions>
            <name>UM_Update_Collection_Amount_Currency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fill currency field related to Collection Amount</description>
        <formula>OR(ISNEW(),     ISCHANGED(UM_Collection_Amount__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslateCollectionHoldStatus</fullName>
        <actions>
            <name>UM_Translate_Collection_Hold_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Translate number value from Kenan to Readable text</description>
        <formula>OR(ISNEW(),     ISCHANGED(UM_Collection_Hold_Status__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslateCollectionIndicator</fullName>
        <actions>
            <name>UM_Translate_Collection_Indicator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Translate number value from Kenan to Readable text</description>
        <formula>OR(ISNEW(),    ISCHANGED(UM_Collection_Indicator__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslateCollectionMethod</fullName>
        <actions>
            <name>UM_Translate_Collection_Method</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Translate number value from Kenan to Readable text</description>
        <formula>OR(ISNEW(),     ISCHANGED(UM_Collection_Method__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_TranslateCollectionStartDate</fullName>
        <actions>
            <name>UM_Translate_Collection_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Translate number value from Kenan to date time in Salesforce</description>
        <formula>OR(ISNEW(),     ISCHANGED(UM_Collection_Start_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_UpdateNameCollections</fullName>
        <actions>
            <name>UM_Update_Name_Collections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(ISCHANGED(UM_Collection_ID__c),     ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
