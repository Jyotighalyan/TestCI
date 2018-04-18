function getId(id) {
  return '#' + makeCssIdentifier(id);
 }


 function makeCssIdentifier(id) {
  return id.replace(/([:\/#;&%,\.\+\*~'"!\?\^\$\[\]\(\)=>\|])/g, '\\$1');
 }

var CS = CS || {};
 CS.disableAttribute = function(id) { 
	CS.binding.update(id, {active: false, lineItem: false});
}