<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>UM_Send_email_to_finance_group_to_hold_collections</fullName>
        <ccEmails>intekhab.alam2@cognizant.com</ccEmails>
        <description>Send email to finance group to hold collections</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/UM_Collections_Hold</template>
    </alerts>
    <alerts>
        <fullName>UM_Send_email_to_finance_group_to_put_in_collections</fullName>
        <ccEmails>intekhab.alam2@cognizant.com</ccEmails>
        <description>Send email to finance group to put in collections</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/UM_Put_in_Collections</template>
    </alerts>
    <fieldUpdates>
        <fullName>UM_Clear_Collection_Reason_Change_Date</fullName>
        <field>UM_Collection_Reason_Change_Date__c</field>
        <name>Clear Collection Reason Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_Fill_Collection_Reason_Change_Date</fullName>
        <field>UM_Collection_Reason_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Fill Collection Reason Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>csconta__Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_of_BA</fullName>
        <field>csconta__Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update Status of BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Status of BA as Active from New</fullName>
        <actions>
            <name>Update_Status_of_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>csconta__Billing_Account__c.LG_ExternalId__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>csconta__Billing_Account__c.csconta__Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Change status of BA as Active as Active when first underline service is synched with billing and activated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change status of BA as Inactive</fullName>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>csconta__Billing_Account__c.Deactivation_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>csconta__Billing_Account__c.Kenan_billing_status__c</field>
            <operation>equals</operation>
            <value>-2</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM_ClearCollectionReasonChangeDate</fullName>
        <actions>
            <name>UM_Clear_Collection_Reason_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clear currency field related to Collection Amount</description>
        <formula>AND(ISCHANGED(UM_Collection_Hold_Reason__c),     ISPICKVAL(UM_Collection_Hold_Reason__c, &quot;&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_SendEmailHoldCollections</fullName>
        <actions>
            <name>UM_Send_email_to_finance_group_to_hold_collections</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>csconta__Billing_Account__c.Picklist_request__c</field>
            <operation>equals</operation>
            <value>Collection freeze</value>
        </criteriaItems>
        <description>Send email to finance group to hold collections</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM_SendEmailPutInCollections</fullName>
        <actions>
            <name>UM_Send_email_to_finance_group_to_put_in_collections</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to finance group to put in collections</description>
        <formula>AND(ISCHANGED( Picklist_request__c ),     ISPICKVAL(Picklist_request__c , &quot;Collection re-continue&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_UpdateCollectionReasonChangeDate</fullName>
        <actions>
            <name>UM_Fill_Collection_Reason_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(UM_Collection_Hold_Reason__c),     NOT(ISPICKVAL(UM_Collection_Hold_Reason__c, &quot;&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
