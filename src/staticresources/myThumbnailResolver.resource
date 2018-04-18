var ccd = CS.App.getController('configuration').delegate;
ccd.hooks.lookupThumbnailResolver = thumbnailResolver;

function thumbnailResolver(sobject, fileSystemRoot) {
	var thumbnailResourceName = sobject.Resource_Name__c;
	var thumbnailImageName = sobject.Image_Name__c;
	var html = '';
	if (thumbnailResourceName && thumbnailImageName) {
		var src = 'file://' + fileSystemRoot + '/' + thumbnailResourceName + '/' + thumbnailImageName + '.png';
		html += '<img src="' + src + '"/>';
		html += '<span class="originalImage"><img src="' + src + '"/></span>';
	}
	return html;
}