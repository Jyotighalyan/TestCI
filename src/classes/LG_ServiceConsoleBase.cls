/**
* Custom SF Service Console
* 
* @author Petar Miletic
* @story SFOM-29
* @since  03/11/2016
*/
public abstract class LG_ServiceConsoleBase {

    public enum DisplayMode { detail, maindetail, edit, inlineEdit }
    
    private DisplayMode currentMode { get; set; }
    
    public DisplayMode getMode() {
        
        if (this.currentMode == null) {
            currentMode = DisplayMode.detail;
        }
        
        return currentMode;
    }
    
    public void setMode(DisplayMode mode) {
        
        this.currentMode = mode;
    }
    
    public Boolean getEdit() {
        return getMode() == DisplayMode.edit;
    }
    
	public String getRecordType(Case obj) {
		return obj.RecordType.Name;
	}
}