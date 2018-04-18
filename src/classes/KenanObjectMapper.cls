/**
* TODO: ApexDoc.
*/
public interface KenanObjectMapper {

	Map<String,Object> getEnumeratedValues(KenanObject kObject);

	KenanObject getDisplayValues(Map<String, Object> objectMap);
}