<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LG_Approval_Alert</fullName>
        <description>LG Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UM_UnitymediaTemplates/LG_Duplicate_Account_Approved_Notification_To_Partner</template>
    </alerts>
    <alerts>
        <fullName>LG_Rejection_alert</fullName>
        <description>LG_Rejection alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UM_UnitymediaTemplates/LG_Duplicate_Account_Rejection_Notification_To_PAM</template>
    </alerts>
    <alerts>
        <fullName>sendemailto_owner</fullName>
        <description>if lead owner changed send email to owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_send_to_the_lead_owner_with_all_the_lead_changes</template>
    </alerts>
    <fieldUpdates>
        <fullName>Autopopulate_PartnerAccount_Lead</fullName>
        <field>Partner_Account_PPW__c</field>
        <formula>Owner:User.Contact.Account.Name</formula>
        <name>Autopopulate_PartnerAccount_Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Internal_Sales_Id_On_Lead_Update</fullName>
        <field>Internal_Sales_Id__c</field>
        <formula>$User.Internal_Sales_Id__c</formula>
        <name>LG_Internal Sales Id On Lead Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_LeadAddressSearchTextUpdate</fullName>
        <field>LG_AddressSearchText__c</field>
        <formula>SUBSTITUTE (LG_VisitPostalCode__c,&quot; &quot;,&quot;&quot;) + SUBSTITUTE (LG_VisitHouseNumber__c,&quot; &quot;,&quot;&quot;) + SUBSTITUTE (LG_VisitHouseNumberExtension__c,&quot; &quot;,&quot;&quot;)</formula>
        <name>Lead Address Search Text Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_LeadCityUpdate</fullName>
        <field>City</field>
        <formula>LG_VisitCity__c</formula>
        <name>Lead City Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_LeadCountryUpdate</fullName>
        <field>Country</field>
        <formula>Text(LG_VisitCountry__c)</formula>
        <name>Lead Country Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_LeadPostalCodeUpdate</fullName>
        <field>PostalCode</field>
        <formula>LG_VisitPostalCode__c</formula>
        <name>Lead Postal Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_LeadStreetUpdate</fullName>
        <field>Street</field>
        <formula>LG_VisitStreet__c +&quot; &quot;+ LG_VisitHouseNumber__c  + &quot; &quot; + LG_VisitHouseNumberExtension__c</formula>
        <name>Lead Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_LedExternalIDUpdate</fullName>
        <field>LG_ExternalID__c</field>
        <formula>LG_ChamberOfCommerceNumber__c</formula>
        <name>Lead External ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_OpportunityBillingStreet</fullName>
        <field>LG_VisitStreet__c</field>
        <formula>LG_VisitStreet__c</formula>
        <name>Opportunity Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Record_Sent_For_Approval</fullName>
        <field>Sent_For_Approval__c</field>
        <literalValue>1</literalValue>
        <name>LG Record Sent For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Uncheck_Sent_For_Approval</fullName>
        <field>Sent_For_Approval__c</field>
        <literalValue>0</literalValue>
        <name>LG Uncheck Sent For Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateAddressIDtoBlank</fullName>
        <field>LG_VisitAddressID__c</field>
        <name>Update Address ID to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateAddressValidatedCheck</fullName>
        <field>LG_AddressValidated__c</field>
        <literalValue>1</literalValue>
        <name>Update Address Validated Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateAddressValidatedCheckFalse</fullName>
        <field>LG_AddressValidated__c</field>
        <literalValue>0</literalValue>
        <name>Update Address Validated Check to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Update_Duplication_Approved_Check_box</fullName>
        <field>Lead_Account_Duplication_Approved__c</field>
        <literalValue>1</literalValue>
        <name>LG_Update Duplication Approved Check box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Update_Lead_not_to_be_converted_check</fullName>
        <field>Not_To_Be_Converted__c</field>
        <literalValue>1</literalValue>
        <name>LG_Update Lead not to be converted check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_pCityIsvCity</fullName>
        <field>LG_PostalCity__c</field>
        <formula>LG_VisitCity__c</formula>
        <name>pCityIsvCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_pHousNumberExtIsvHousNumberExt</fullName>
        <field>LG_PostalHouseNumberExtension__c</field>
        <formula>LG_VisitHouseNumberExtension__c</formula>
        <name>pHousNumberExtIsvHousNumberExt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_pHousNumberIsvHousNumber</fullName>
        <field>LG_PostalHouseNumber__c</field>
        <formula>LG_VisitHouseNumber__c</formula>
        <name>pHousNumberIsvHousNumber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_pStreetIsvStreet</fullName>
        <field>LG_PostalStreet__c</field>
        <formula>LG_VisitStreet__c</formula>
        <name>pStreetIsvStreet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Duplicate_Account_Uncheck</fullName>
        <field>Duplicate_account__c</field>
        <literalValue>0</literalValue>
        <name>Lead_Duplicate_Account_Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_AssignedLeadNotContacted</fullName>
        <description>Checks the checkbox assigned lead not contacted</description>
        <field>UM_AssignedLeadNotContacted__c</field>
        <literalValue>1</literalValue>
        <name>UM_AssignedLeadNotContacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_LeadAssignQueue</fullName>
        <field>OwnerId</field>
        <lookupValue>UM_LeadQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UM_LeadAssignQueue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_LeadId</fullName>
        <field>UM_LeadId__c</field>
        <formula>Id</formula>
        <name>UM_LeadId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_LeadOwnerChange</fullName>
        <field>UM_OwnerChanges__c</field>
        <formula>UM_OwnerChanges__c + 1</formula>
        <name>UM_LeadOwnerChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UM_LeadUnassignedOrContacted</fullName>
        <description>Unchecks a checkbox when a lead is contacted or unassigned</description>
        <field>UM_AssignedLeadNotContacted__c</field>
        <literalValue>0</literalValue>
        <name>UM_LeadUnassignedOrContacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LG_AddressValidationCheck</fullName>
        <actions>
            <name>LG_UpdateAddressValidatedCheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>LG_VisitAddressID__c != &apos;&apos; &amp;&amp; (IsChanged(LG_VisitAddressID__c) &amp;&amp; (IsChanged( LG_VisitHouseNumber__c ) || IsChanged( LG_VisitCity__c ) || IsChanged( LG_VisitHouseNumberExtension__c ) || IsChanged( LG_VisitPostalCode__c ) || IsChanged( LG_VisitStreet__c) || IsChanged( LG_VisitAddressID__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_AddressValidationChecktoFalse</fullName>
        <actions>
            <name>LG_UpdateAddressIDtoBlank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_UpdateAddressValidatedCheckFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>LG_VisitAddressID__c = &apos;&apos; || (!IsChanged(LG_VisitAddressID__c) &amp;&amp; (IsChanged( LG_VisitHouseNumber__c ) || IsChanged( LG_VisitCity__c ) || IsChanged( LG_VisitHouseNumberExtension__c ) || IsChanged( LG_VisitPostalCode__c ) || IsChanged( LG_VisitStreet__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_Internal Sales Id Update</fullName>
        <actions>
            <name>LG_Internal_Sales_Id_On_Lead_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$UserRole.Name &lt;&gt;&apos;B2B BS SME Care&apos; &amp;&amp;  $UserRole.Name &lt;&gt;&apos;B2B SME Care&apos; &amp;&amp;  $UserRole.Name &lt;&gt;&apos;B2B Billing Operations&apos; &amp;&amp;  $User.Internal_Sales_Id__c &lt;&gt;&apos;&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG_LeadAddressUpdate</fullName>
        <actions>
            <name>LG_LeadAddressSearchTextUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_LeadCityUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_LeadCountryUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_LeadPostalCodeUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_LeadStreetUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LG_VisitCountry__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Lead Standard Address fields</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_LeadExternalID</fullName>
        <actions>
            <name>LG_LedExternalIDUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update External ID field value with Chamber of Commerce Number field</description>
        <formula>Text(LeadSource) != &apos;Web&apos; &amp;&amp;   LG_ChamberOfCommerceNumber__c!= LG_ExternalID__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send email to Owner</fullName>
        <actions>
            <name>sendemailto_owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Is owner changed notify the owner</description>
        <formula>OR( ISCHANGED(OwnerId ), ISCHANGED( LG_Segment__c ), ISCHANGED(Phone), ISCHANGED(FirstName), ISCHANGED(LastName), ISCHANGED(Email), ISCHANGED(UM_DetailedIndustryClassification__c), ISCHANGED(UM_IndustryClassification__c),  ISCHANGED(UM_Legal_Name__c), ISCHANGED(Rating), ISCHANGED(LG_LegalEntityType__c), ISCHANGED(LG_ContractualOrganization__c), ISCHANGED(LG_DeliveryMethod__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_LeadAssignQueue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.UM_AssignedLeadNotContacted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Return a lead to the Queue after X amount of days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UM_LeadAssignQueue</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>UM_LeadContacted</fullName>
        <actions>
            <name>UM_LeadUnassignedOrContacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WR That unchecks a checkbox when a lead is &quot;Contacted&quot; or Unassigned</description>
        <formula>NOT(ISPICKVAL(Status  , &apos;Not Contacted&apos;))  || NOT(ISBLANK(Owner:Queue.Id ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_LeadCountOwnerChange</fullName>
        <actions>
            <name>UM_LeadOwnerChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WR that adds a number for each owner change of a lead</description>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_LeadId</fullName>
        <actions>
            <name>UM_LeadId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the ID of the lead in a text field to be used for lead field mapping</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UM_LeadNotContacted</fullName>
        <actions>
            <name>UM_AssignedLeadNotContacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets a checkbox as long as a lead is assigned to an owner and is not contacted</description>
        <formula>ISCHANGED(  OwnerId  )  &amp;&amp;   ISPICKVAL( Status , &apos;Not Contacted&apos;) &amp;&amp;   ISBLANK(Owner:Queue.Id )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>LG_LeadCompetitorIs90DaysBeforeEndDate</fullName>
        <assignedTo>noreply@unitymediabusiness.de</assignedTo>
        <assignedToType>user</assignedToType>
        <description>*** LEAD COMPETITOR IS 90 DAYS BEFORE END DATE*** 
Take an Action!</description>
        <dueDateOffset>10</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Lead Competitor Is 90 Days Before End Date</subject>
    </tasks>
    <tasks>
        <fullName>LG_LeadMobileCompetitorIs90DaysBeforeEndDate</fullName>
        <assignedTo>noreply@unitymediabusiness.de</assignedTo>
        <assignedToType>user</assignedToType>
        <description>*** LEAD MOBILE COMPETITOR IS 90 DAYS BEFORE END DATE*** 
Take an Action!</description>
        <dueDateOffset>10</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Lead Mobile Competitor Is 90 Days Before End Date</subject>
    </tasks>
</Workflow>
