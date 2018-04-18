@isTest
public class LG_Care_MultiLineUtilClass_Test{

 static testMethod void SendString(){

string strTest='UnityMedia is my World and I work in it as a developer'+'/r'+
    'It is working really well ';
Integer maxChar=15;

LG_Care_MultiLineUtilClass.parseString(strTest,maxChar);

}

}