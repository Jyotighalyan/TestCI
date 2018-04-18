<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Case_Comment_Outbound</fullName>
        <apiVersion>41.0</apiVersion>
        <endpointUrl>https://jit-api-libertyglobal-com.upc.biz:443/NotificationCaseComments/v1.0/pushCaseComments</endpointUrl>
        <fields>CommentBody</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>LastModifiedDate</fields>
        <fields>ParentId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>lgdepuser@apiuser.com</integrationUser>
        <name>Case Comment Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>caseComment_outbound</fullName>
        <apiVersion>41.0</apiVersion>
        <endpointUrl>http://test.com</endpointUrl>
        <fields>CommentBody</fields>
        <fields>Id</fields>
        <fields>ParentId</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ankita_kumari06@infosys.comumscbaudev</integrationUser>
        <name>caseComment_outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>%28Case Comment%29 When CaseComment is Created Or Updated</fullName>
        <active>false</active>
        <formula>ISCHANGED( CommentBody )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG DEP CaseComment Update</fullName>
        <actions>
            <name>Case_Comment_Outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CaseComment.CreatedById</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
