<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Flag_Update</fullName>
        <description>Update Flag</description>
        <field>LG_SendEmailCheck__c</field>
        <literalValue>0</literalValue>
        <name>Flag_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resend_flag</fullName>
        <field>LG_ReSendEmailCheck__c</field>
        <literalValue>0</literalValue>
        <name>Resend flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resend_flag_reset</fullName>
        <field>LG_ReSendEmailCheck__c</field>
        <literalValue>0</literalValue>
        <name>Resend flag reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Flag</fullName>
        <description>Update Flag</description>
        <field>LG_SendEmailCheck__c</field>
        <literalValue>0</literalValue>
        <name>Update Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Conga Solution</fullName>
        <actions>
            <name>Resend_flag_reset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Wlcome_Pack</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Check Flag</description>
        <formula>AND(OR(LG_SendEmailCheck__c = true, LG_ReSendEmailCheck__c = true) , INCLUDES(csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c, &apos;Email&apos;) , LG_Suppress_Welcome_Pack__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conga Solution Attachment</fullName>
        <actions>
            <name>Flag_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Resend_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Wlcome_Pack_attach</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(OR(LG_SendEmailCheck__c = true, LG_ReSendEmailCheck__c = true) , NOT(Includes(csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c,&apos;Email&apos;))), AND(OR(LG_SendEmailCheck__c = true, LG_ReSendEmailCheck__c = true), INCLUDES(csord__Order__r.csordtelcoa__Opportunity__r.LG_PrimaryContact__r.LG_PreferredCommunication__c, &apos;Email&apos;) , LG_Suppress_Welcome_Pack__c = true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
     <outboundMessages>
        <fullName>Send_Wlcome_Pack</fullName>
        <apiVersion>39.0</apiVersion>
        <description>Send Wlcome Pack</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>LG_SendEmail__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ankur_gupta55@infosys.com.umomcaredev</integrationUser>
        <name>Send Wlcome Pack</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Wlcome_Pack_attach</fullName>
        <apiVersion>41.0</apiVersion>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>LG_Wp_Attachment__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>preetha.n@infosys.com_umomdev</integrationUser>
        <name>Send Wlcome Pack_attach</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>
