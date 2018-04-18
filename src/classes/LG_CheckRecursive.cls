public Class LG_CheckRecursive{
    private static boolean runPBDelete = true;
    public static boolean runPBOnceDelete(){
    if(runPBDelete ){
     runPBDelete =false;
     return true;
    }else{
        return runPBDelete ;
    }
    }
    private static boolean runPBInsert = true;
    public static boolean runPBOnceInsert(){
    if(runPBInsert ){
     runPBInsert =false;
     return true;
    }else{
        return runPBInsert ;
    }
    }
}