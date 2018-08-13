<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Updating_Salutation_field</fullName>
        <field>SalutationTranslation__c</field>
        <formula>IF(ISPICKVAL(Salutation,&quot;Mr.&quot;),&quot;Herr&quot;,&quot;Frau&quot;)</formula>
        <name>Updating Salutation field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Bounced_Category_Update</fullName>
        <field>B2B_Bounced_Category_pklst__c</field>
        <name>Contact Bounced Category Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contact Hard Bounce Category</fullName>
        <actions>
            <name>Contact_Bounced_Category_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created for modifying the hard bounce field on contact</description>
        <formula>AND( ISCHANGED( Email ) , ISPICKVAL( B2B_Bounced_Category_pklst__c , &apos;Hard Bounce&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM Auto populating Salutation field</fullName>
        <actions>
            <name>Updating_Salutation_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Salutation</field>
            <operation>notEqual</operation>
        </criteriaItems>
=======
        <fullName>Set_Join_Date</fullName>
        <field>Join_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Join Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Join Date</fullName>
        <actions>
            <name>Set_Join_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(PRIORVALUE(Record_Type_Name__c) = &quot;Guest&quot;,Record_Type_Name__c = &quot;Member&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
