<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>B2B_Remove_Bankruptcy_Date</fullName>
        <description>Remove Bankruptcy Date if flag is not checked</description>
        <field>B2B_Bankruptcy_Date__c</field>
        <name>Remove Bankruptcy Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Depcs_Update</fullName>
        <field>csb2c__E_Commerce_Customer_Id__c</field>
        <formula>LG_AccountNumber__c</formula>
        <name>LG Depcs Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountAddressSearchTextUpdate</fullName>
        <field>LG_AddressSearchText__c</field>
        <formula>SUBSTITUTE (LG_VisitPostalCode__c,&quot; &quot;,&quot;&quot;) + SUBSTITUTE (LG_VisitHouseNumber__c,&quot; &quot;,&quot;&quot;) + SUBSTITUTE (LG_VisitHouseNumberExtension__c,&quot; &quot;,&quot;&quot;)</formula>
        <name>Account Address Search Text Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountBillingCityUpdate</fullName>
        <field>BillingCity</field>
        <formula>LG_VisitCity__c</formula>
        <name>Account Billing City Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountBillingCountryUpdate</fullName>
        <field>BillingCountry</field>
        <formula>Text (LG_VisitCountry__c)</formula>
        <name>Account Billing Country Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountBillingPostalCodeUpdate</fullName>
        <field>BillingPostalCode</field>
        <formula>LG_VisitPostalCode__c</formula>
        <name>Account Billing Postal Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountBillingStreetUpdate</fullName>
        <field>BillingStreet</field>
        <formula>LG_VisitStreet__c + &quot; &quot; + LG_VisitHouseNumber__c + &quot; &quot; +  LG_VisitHouseNumberExtension__c</formula>
        <name>Account Billing Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountExternal_ID_Update</fullName>
        <field>LG_ExternalID__c</field>
        <formula>LG_ChamberOfCommerceNumber__c</formula>
        <name>Account External ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountShippingCityUpdate</fullName>
        <field>ShippingCity</field>
        <formula>LG_VisitCity__c</formula>
        <name>Account Shipping City Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountShippingCountryUpdate</fullName>
        <field>ShippingCountry</field>
        <formula>Text (LG_VisitCountry__c)</formula>
        <name>Account Shipping Country Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountShippingPostalCodeUpdate</fullName>
        <field>ShippingPostalCode</field>
        <formula>LG_VisitPostalCode__c</formula>
        <name>Account Shipping Postal Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_AccountShippingStreetUpdate</fullName>
        <field>ShippingStreet</field>
        <formula>LG_VisitStreet__c + &quot; &quot; +  LG_VisitHouseNumber__c + &quot; &quot; +  LG_VisitHouseNumberExtension__c</formula>
        <name>Account Shipping Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_Depcs_Update</fullName>
        <field>csb2c__E_Commerce_Customer_Id__c</field>
        <formula>LG_AccountNumber__c</formula>
        <name>LG Depcs Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>LG_UpdateAddressValidatedChecktofalse</fullName>
        <field>LG_AddressValidated__c</field>
        <literalValue>0</literalValue>
        <name>Update Address Validated Check to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateBillingCity</fullName>
        <field>BillingCity</field>
        <formula>LG_PostalCity__c</formula>
        <name>Update Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateBillingCountry</fullName>
        <field>BillingCountry</field>
        <formula>TEXT(LG_PostalCountry__c)</formula>
        <name>Update Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LG_UpdateBillingStreet</fullName>
        <description>Update the Billing Street with Street / House Number / House Number Ext</description>
        <field>BillingStreet</field>
        <formula>LG_PostalStreet__c  &amp; &quot; &quot; &amp;  LG_VisitHouseNumber__c &amp; &quot; &quot; &amp;  LG_VisitHouseNumberExtension__c</formula>
        <name>Update Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BillingPostalCode</fullName>
        <field>BillingPostalCode</field>
        <formula>LG_PostalPostalCode__c</formula>
        <name>Update Billing Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>B2B_Bankruptcy_Flag_Check</fullName>
        <actions>
            <name>B2B_Remove_Bankruptcy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Remove Bankruptcy Date if Bankruptcy Flag is not set.</description>
        <formula>AND ( NOT(B2B_Bankruptcy_Warning__c), NOT(      OR(        ISBLANK( B2B_Bankruptcy_Date__c ),        ISNULL(B2B_Bankruptcy_Date__c)         )     ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG Depcs Update</fullName>
        <actions>
            <name>LG_Depcs_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountNumber</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG_AccountAddressUpdate</fullName>
        <actions>
            <name>LG_AccountAddressSearchTextUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountBillingCityUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountBillingCountryUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountBillingPostalCodeUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountBillingStreetUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountShippingCityUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountShippingCountryUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountShippingPostalCodeUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_AccountShippingStreetUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Account Standard Address fields</description>
        <formula>NOT($Setup.No_Workflow__c.Flag__c) &amp;&amp; NOT( ISPICKVAL(LG_VisitCountry__c, &apos;&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_AccountExternalID</fullName>
        <actions>
            <name>LG_AccountExternal_ID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.LG_ChamberOfCommerceNumber__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LG_ExternalID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update External ID field value with Chamber of Commerce Number field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LG Depcs Update</fullName>
        <actions>
            <name>LG_Depcs_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountNumber</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LG_AddressValidationCheck</fullName>
        <actions>
            <name>LG_UpdateAddressValidatedCheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT($Setup.No_Workflow__c.Flag__c) &amp;&amp; LG_VisitAddressID__c != &apos;&apos; &amp;&amp; (IsChanged(LG_VisitAddressID__c) &amp;&amp; (IsChanged( LG_VisitHouseNumber__c ) || IsChanged( LG_VisitCity__c ) || IsChanged( LG_VisitHouseNumberExtension__c ) || IsChanged( LG_VisitPostalCode__c ) || IsChanged( LG_VisitStreet__c) || IsChanged( LG_VisitAddressID__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_AddressValidationChecktoFalse</fullName>
        <actions>
            <name>LG_UpdateAddressIDtoBlank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_UpdateAddressValidatedChecktofalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT($Setup.No_Workflow__c.Flag__c) &amp;&amp; (LG_VisitAddressID__c = &apos;&apos; || (!IsChanged(LG_VisitAddressID__c) &amp;&amp; (IsChanged( LG_VisitHouseNumber__c ) || IsChanged( LG_VisitCity__c ) || IsChanged( LG_VisitHouseNumberExtension__c ) || IsChanged( LG_VisitPostalCode__c ) || IsChanged( LG_VisitStreet__c ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LG_UpdateBillingAddressIfPostalAddressChanges</fullName>
        <actions>
            <name>LG_UpdateBillingCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_UpdateBillingCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LG_UpdateBillingStreet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BillingPostalCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Vanilla Billing Address when Postal Address is updated</description>
        <formula>NOT($Setup.No_Workflow__c.Flag__c) &amp;&amp;  (ISCHANGED(LG_PostalStreet__c) || ISCHANGED(LG_PostalPostalCode__c)  ||  ISCHANGED(LG_PostalHouseNumberExtension__c)  || ISCHANGED(LG_PostalCity__c) ||ISCHANGED(LG_PostalHouseNumber__c) || ISCHANGED(LG_PostalCountry__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>LG_AccountCompetitorIs90daysBeforeEndDate</fullName>
        <assignedTo>noreply@unitymediabusiness.de</assignedTo>
        <assignedToType>user</assignedToType>
        <description>*** ACCOUNT COMPETITOR IS 90 DAYS BEFORE END DATE*** 
Take an Action!</description>
        <dueDateOffset>10</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Account Competitor Is 90 Days Before End Date</subject>
    </tasks>
    <tasks>
        <fullName>LG_AccountMobileCompetitorIs90DaysBeforeEndDate</fullName>
        <assignedTo>noreply@unitymediabusiness.de</assignedTo>
        <assignedToType>user</assignedToType>
        <description>*** ACCOUNT MOBILE COMPETITOR IS 90 DAYS BEFORE END DATE*** 
Take an Action!</description>
        <dueDateOffset>10</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Account Mobile Competitor Is 90 Days Before End Date</subject>
    </tasks>
</Workflow>
