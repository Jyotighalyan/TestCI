<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LG_D2D_SentReminderMail</fullName>
        <description>LG_D2D_SentReminderMail</description>
        <protected>false</protected>
        <recipients>
            <field>LG_PrimaryContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UM_UnitymediaTemplates/UM_D2D_Email_Reminder_Template</template>
    </alerts>
    <alerts>
        <fullName>LG_OrderNotProcessedNotificationEmail</fullName>
        <description>Email to Opportunity Owner when Opportunity is in stage Not Processed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LG_OpportunityOrderStatusNotProcessed</template>
    </alerts>
    <alerts>
        <fullName>LG_Product_Basket_Rejection_Notification</fullName>
        <description>LG_Product Basket Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UM_UnitymediaTemplates/LG_Product_Basket_Rejected</template>
    </alerts>
    <alerts>
        <fullName>LG_SendOpportunityDetailsToOPT</fullName>
        <description>Send Opportunity details to OPT</description>
        <protected>false</protected>
        <recipients>
            <field>LG_OrderEmailAddressHidden__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LG_OpportunityOrderRequest</template>
    </alerts>
    <alerts>
        <fullName>LG_send_Automatic_reply</fullName>
        <description>Send Automatic reply</description>
        <protected>false</protected>
        <recipients>
            <field>LG_PrimaryContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>boudewijn.deru@7dots.eu</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Thank_You_Email</template>
    </alerts>
    <alerts>
        <fullName>UM_EmailOpportunityApproval</fullName>
        <description>Email Opportunity Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UM_UnitymediaTemplates/UM_OpportunityApprovalApproved</template>
    </alerts>
    <alerts>
        <fullName>UM_EmailOpportunityApprovalRejected</fullName>
        <description>Email Opportunity Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UM_UnitymediaTemplates/UM_OpportunityApprovalRejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Amount_Field_update</fullName>
        <description>This is to set the default value of Amount to 0.00$</description>
        <field>Amount</field>
        <formula>0</formula>
        <name>Amount Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status</fullName>
        <field>UM_Approval__c</field>
        <literalValue>In approval</literalValue>
        <name>Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Record_Type</fullName>
        <description>Change record type post approval to show button</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner_Post_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Approved Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Status</fullName>
        <field>UM_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complex_Approved_Record_type</fullName>
        <description>show button</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner_Post_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Complex Approved Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complex_Rejected_Record_Type</fullName>
        <description>hide button</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Complex Rejected Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_ApprovalPenaltyApproved</fullName>
        <field>LG_ApprovalPenaltyFeeDiscount__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Penalty Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_ApprovalPenaltyPending</fullName>
        <field>LG_ApprovalPenaltyFeeDiscount__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Penalty Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_ApprovalPenaltyRejected</fullName>
        <field>LG_ApprovalPenaltyFeeDiscount__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Penalty Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_BillingHouseNumberExtension</fullName>
        <field>LG_BillingHouseNumberExtension__c</field>
        <formula>Account.LG_VisitHouseNumberExtension__c</formula>
        <name>Billing House Number Extension</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_InstallationHouseNumberExtension</fullName>
        <field>LG_InstallationHouseNumberExtension__c</field>
        <formula>Account.LG_VisitHouseNumberExtension__c</formula>
        <name>Installation House Number Extension</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Internal_Sales_Id_On_Opp_Update</fullName>
        <field>Internal_Sales_Id__c</field>
        <formula>$User.Internal_Sales_Id__c</formula>
        <name>LG_Internal Sales Id On Opp Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingCity</fullName>
        <field>LG_BillingCity__c</field>
        <formula>Account.LG_VisitCity__c</formula>
        <name>Opportunity Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingCountry</fullName>
        <field>LG_BillingCountry__c</field>
        <literalValue>Netherlands</literalValue>
        <name>Opportunity Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingHouseNumber</fullName>
        <field>LG_BillingHouseNumber__c</field>
        <formula>Account.LG_VisitHouseNumber__c</formula>
        <name>Opportunity Billing House Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingPostalCode</fullName>
        <field>LG_BillingPostalCode__c</field>
        <formula>Account.LG_VisitPostalCode__c</formula>
        <name>Opportunity Billing Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingStreet</fullName>
        <field>LG_BillingStreet__c</field>
        <formula>Account.LG_VisitStreet__c</formula>
        <name>Opportunity Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingStreetUpdate</fullName>
        <field>LG_BillingStreet__c</field>
        <formula>Account.LG_VisitStreet__c</formula>
        <name>Opportunity Billing Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityInstallationHouseNumber</fullName>
        <field>LG_InstallationHouseNumber__c</field>
        <formula>Account.LG_VisitHouseNumber__c</formula>
        <name>Opportunity Installation House Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityInstallationPostalCode</fullName>
        <field>LG_InstallationPostalCode__c</field>
        <formula>Account.LG_VisitPostalCode__c</formula>
        <name>Opportunity Installation Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityInstallationStreet</fullName>
        <field>LG_InstallationStreet__c</field>
        <formula>Account.LG_VisitStreet__c</formula>
        <name>Opportunity Installation Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OrderEmailAddress</fullName>
        <field>LG_OrderEmailAddressHidden__c</field>
        <formula>IF( CONTAINS( LG_ProductsInBasketHidden__c , &apos;[ZZP Internet]&apos;)&amp;&amp; ISPICKVAL( Account.LG_Footprint__c , &apos;UPC&apos;), $Setup.LG_EnvironmentVariables__c.LG_OrderEmailAddressA__c,
IF (CONTAINS( LG_ProductsInBasketHidden__c , &apos;[ZZP Internet]&apos;), $Setup.LG_EnvironmentVariables__c.LG_OrderEmailAddressB__c , IF ( CONTAINS( LG_ProductsInBasketHidden__c , &apos;[MKB Internet]&apos;)&amp;&amp;CONTAINS( LG_ProductsInBasketHidden__c , &apos;[Mobile]&apos;)&amp;&amp; ISPICKVAL( Type , &apos;Existing Business&apos;),  $Setup.LG_EnvironmentVariables__c.LG_OrderEmailAddressC__c,
IF (CONTAINS( LG_ProductsInBasketHidden__c , &apos;[MKB Internet]&apos;), $Setup.LG_EnvironmentVariables__c.LG_OrderEmailAddressD__c ,null))))</formula>
        <name>Order Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_RenameOpp</fullName>
        <description>Opportunity_Name :=
Account_Name - Opportunity_Month_of_the_Created_date / Year_of_the_Created_date</description>
        <field>Name</field>
        <formula>Account.Name +&quot; - &quot;+LPAD(TEXT(MONTH(DATEVALUE(CreatedDate))),2,&apos;0&apos;)   +&quot;/&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))</formula>
        <name>RenameOpp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_ResetPenaltyApprovedBy</fullName>
        <field>LG_PenaltyApprovedBy__c</field>
        <name>Reset Penalty Approved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_RevertFinalPenalty</fullName>
        <field>LG_FinalPenalty__c</field>
        <formula>LG_CalculatedPenaltyFee__c</formula>
        <name>Revert Final Penalty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_SetPreviousStage</fullName>
        <field>LG_PreviousStage__c</field>
        <formula>TEXT(PRIORVALUE( StageName ))</formula>
        <name>Set Previous Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateOpportunityStageChangeDate</fullName>
        <description>Update the Last Stage Change Date</description>
        <field>LG_LastStageChangeDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Opportunity Stage Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateOpportunityTypeonCreate</fullName>
        <description>Set the Opportunity Type to Existing business when the Opportunity is created for a existing customer</description>
        <field>Type</field>
        <literalValue>Existing Business</literalValue>
        <name>Update Opportunity Type on Create</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Update_Oppty_SalesChannel</fullName>
        <description>It updates the field &quot;Sales Channel&quot; on the Opportunity with the value on the User&apos;s value on its field &quot;Sales Channel&quot;.</description>
        <field>LG_NEWSalesChannel__c</field>
        <formula>TEXT(Owner.LG_SalesChannel__c)</formula>
        <name>LG_Update_Oppty_SalesChannel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lost_reason_update</fullName>
        <description>Update Lost reason when quote is rejected by customer</description>
        <field>Loss_Reason__c</field>
        <literalValue>Angebot abgelehnt durch Kunde</literalValue>
        <name>Lost reason update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Probability_Update</fullName>
        <field>Probability</field>
        <formula>IF(  Probability &lt; 0.60, 0.60, Probability)</formula>
        <name>Probability Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Probability_Update2</fullName>
        <field>Probability</field>
        <formula>IF(  Probability &lt; 0.60, 0.60, Probability)</formula>
        <name>Probability Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_update_post_quote_approval</fullName>
        <description>The opportunity should not have the send quote for approval button when the quote is already approved by the customer. Hence, updating the record type to Partner when the quote is approved to enable the partner opportunity layout.</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type update post quote approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Record_type</fullName>
        <description>hide button</description>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Rejected Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Status</fullName>
        <field>UM_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_ApprovalApproved</fullName>
        <field>UM_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_ApprovalBlank</fullName>
        <field>UM_Approval__c</field>
        <name>Approval Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_ApprovalInapproval</fullName>
        <field>UM_Approval__c</field>
        <literalValue>In approval</literalValue>
        <name>Approval In approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_ApprovalRejected</fullName>
        <field>UM_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_OpportunityApproved</fullName>
        <field>UM_OpportunityApproved__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_OpportunityApprovedFalse</fullName>
        <field>UM_OpportunityApproved__c</field>
        <literalValue>0</literalValue>
        <name>Opportunity Approved False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_OpportunityStage</fullName>
        <field>StageName</field>
        <literalValue>Closed Lost</literalValue>
        <name>Opportunity Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_OpportunityStageRecall</fullName>
        <field>StageName</field>
        <literalValue>Follow-Up</literalValue>
        <name>Opportunity Stage Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateField</fullName>
        <field>Quote_Reminder_Sent__c</field>
        <literalValue>1</literalValue>
        <name>UpdateField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Date_on_Opportunity</fullName>
        <description>Field update to update closed date on opportunity</description>
        <field>Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Closed Date on Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Oppty_Stage_Flag</fullName>
        <field>LG_Opp_Stage_Check__c</field>
        <literalValue>1</literalValue>
        <name>Update Oppty Stage Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Ref</fullName>
        <field>UM_Sender_Address_Ref__c</field>
        <formula>UM_Sender_Address__c</formula>
        <name>Update Sender Ref</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>LG_InitiateCongaWorkflow</fullName>
        <apiVersion>33.0</apiVersion>
        <description>Sends message to Conga with URL stored in field to create merge document

https://workflow.appextremes.com/apps/Conga/PMWorkflow.aspx</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>LG_CreateQuoteURL__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>noreply@unitymediabusiness.de</integrationUser>
        <name>LG_InitiateCongaWorkflow</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>UM_AttachOrderConfirmationDoc</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>UM_AttachOrderConfirmationDoc__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>raghavendra_lamani@infosys.com.umprod</integrationUser>
        <name>UM_AttachOrderConfirmationDoc</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>UM_InitiateCongaWorkflow</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>um_createquoteurl__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>noreply@unitymediabusiness.de</integrationUser>
        <name>UM_InitiateCongaWorkflow</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>UM_SendOrderConfirmation</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>UM_SendOrderConfirmationEmail__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>raghavendra_lamani@infosys.com.umprod</integrationUser>
        <name>UM_SendOrderConfirmation</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Copy Sender Address</fullName>
        <actions>
            <name>Update_Sender_Ref</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.UM_Sender_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer rejecting quote</fullName>
        <actions>
            <name>Lost_reason_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>clickapprove Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_AutomaticReplyEmail</fullName>
        <actions>
            <name>LG_send_Automatic_reply</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>when ever the Opportunity stage is changed to Customer Approved, we need to send Automatic replies to email Address present in OpportunitycontactRole</description>
        <formula>ISCHANGED(StageName) &amp;&amp;  ISPICKVAL(StageName, &apos;Customer Approved&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_D2D_TriggerQuoteReminderMail</fullName>
        <actions>
            <name>LG_D2D_SentReminderMail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sent a Reminder Mail to Customer if no action is taken by him after 3 days of quotes delivered. (Flow depend on other Flow LG_D2D_CheckFlagReminderMailDelivered)</description>
        <formula>IF(ISPICKVAL(StageName , &apos;Quotation Delivered&apos;),true,false )  &amp;&amp;  IF(Quote_Reminder_Sent__c == True,true,false) &amp;&amp; IF( Owner.Profile.Name  == &apos;UM Partner Sales User&apos;,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LG_D2D_UpdateFieldToTriggerReminderMail</fullName>
        <active>true</active>
        <description>To check a flag after 3 days of quote has been sent if prospect has not responded back and also it triggers other workflow to Sent reminder Mail</description>
        <formula>IF(ISPICKVAL(StageName , &apos;Quotation Delivered&apos;),true,false ) &amp;&amp;  IF(Quote_Reminder_Sent__c == False,true,false) &amp;&amp; IF( Owner.Profile.Name  == &apos;UM Partner Sales User&apos;,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UpdateField</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>LG_Internal Sales Id On Opportunity Update</fullName>
        <actions>
            <name>LG_Internal_Sales_Id_On_Opp_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$UserRole.Name &lt;&gt;&apos;B2B BS SME Care&apos;  &amp;&amp;   $UserRole.Name &lt;&gt;&apos;B2B SME Care&apos;  &amp;&amp;  $UserRole.Name &lt;&gt;&apos;B2B Billing Operations&apos;  &amp;&amp;   LG_LeadId__c  = &apos;&apos; &amp;&amp;  $User.Internal_Sales_Id__c &lt;&gt;&apos;&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG_NewOpportunityRenaming</fullName>
        <actions>
            <name>LG_RenameOpp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Every new Opportunity has Name in this convention:
Account_Name - Opportunity_Month_of_the_Created_date / Year_of_the_Created_date</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG_OpportunitySetTypeOnInsert</fullName>
        <actions>
            <name>LG_UpdateOpportunityTypeonCreate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>When the Account Type is Customer set the Opportunity to Existing Business</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG_OpportunityStageUpdated</fullName>
        <actions>
            <name>LG_SetPreviousStage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_UpdateOpportunityStageChangeDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Rule to validate if the Stage Field is updated</description>
        <formula>IsChanged( StageName )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_OrderEmailAddress</fullName>
        <actions>
            <name>LG_OrderEmailAddress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.LG_ProductsInBasketHidden__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update email address for where OPT email should be sent</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_OrderNotProcessed</fullName>
        <actions>
            <name>LG_OrderNotProcessedNotificationEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LG_OrderStatus__c</field>
            <operation>equals</operation>
            <value>Not Processed</value>
        </criteriaItems>
        <description>Sales Reps and Team Leads will be notified when an order could not be processed in the system.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LG_QuoteDetail_CongaWorkflow</fullName>
        <actions>
            <name>LG_InitiateCongaWorkflow</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LG_AutomatedQuoteDelivery__c</field>
            <operation>equals</operation>
            <value>Quote Requested</value>
        </criteriaItems>
        <description>Conga Workflow for creating Quote Detail document and adding it into Notes&amp;Attachments of Opportunity record. Without clicking on button. For Tablet app</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LG_SendOrderRequestMail</fullName>
        <actions>
            <name>LG_SendOpportunityDetailsToOPT</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LG_NewTask</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Ready for Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LG_SalesChannel__c</field>
            <operation>notEqual</operation>
            <value>Telesales Inbound</value>
        </criteriaItems>
        <description>Sends a notification about order request (Opportunity) containing details about Opportunity and Opportunity Line Item objects.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LG_Update_Oppty_SalesChannel_with_User_SalesChannel</fullName>
        <actions>
            <name>LG_Update_Oppty_SalesChannel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>It updates the field &quot;Sales Channel&quot; on the Opportunity with the value on the User&apos;s value on its field &quot;Sales Channel&quot;.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_Update_Oppty_Stage_Check_Flag</fullName>
        <actions>
            <name>Update_Oppty_Stage_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Ready for Order</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate_First_Closed_Date</fullName>
        <actions>
            <name>Update_Closed_Date_on_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the date field, when the opportunity is closed lost or closed won at first.</description>
        <formula>AND(ISPICKVAL( StageName , &apos;Closed Lost&apos;) || ISPICKVAL( StageName , &apos;Ready for Order&apos;) || ISPICKVAL( StageName , &apos;Pre-Installation-Cancellation&apos;),ISBLANK( Closed_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quote accepted by customer</fullName>
        <actions>
            <name>Record_Type_update_post_quote_approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Offer Delivered</value>
        </criteriaItems>
        <description>Send Quote for Approval button should disabled after Quote accepted by Customer.  Hence, updating the record type to Partner when the quote is approved to enable the partner opportunity layout.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM QuoteCreation After approval</fullName>
        <actions>
            <name>UM_InitiateCongaWorkflow</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.UM_Approval__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Post Approval</value>
        </criteriaItems>
        <description>when partner opportunity is approved, automatically create quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM Update Amount field to 0%2E00%24</fullName>
        <actions>
            <name>Amount_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>.01</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM_AttachOrderConfirmationDoc</fullName>
        <actions>
            <name>UM_AttachOrderConfirmationDoc</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Ready for Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.csordtelcoa__Change_Type__c</field>
            <operation>notEqual</operation>
            <value>Terminate</value>
        </criteriaItems>
        <description>When Opportunity stage changes to Order Generated, attach order confirmation documents in attachments</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UM_SendOrderConfirmation</fullName>
        <actions>
            <name>UM_SendOrderConfirmation</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Send order confirmation email to opportunity primary contact</description>
        <formula>AND( ISPICKVAL(StageName, &apos;Ready for Order&apos;)  ,NOT(ISNULL(LG_PrimaryContact__c)),  INCLUDES(LG_PrimaryContact__r.LG_PreferredCommunication__c, &apos;Email&apos;), NOT( ISPICKVAL( csordtelcoa__Change_Type__c , &apos;Terminate&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>LG_NewTask</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Opportunity was sent to OPT</subject>
    </tasks>
</Workflow>
