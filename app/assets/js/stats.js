$(function() {// Stats setup
	var stats = new Stats();
	stats.setMode(0);
	stats.domElement.style.position = 'absolute';
	stats.domElement.style.left = '0px';
	stats.domElement.style.right = '0px';
	document.body.appendChild(stats.domElement);
});