function baixarApk(){
	
	var link = document.createElement('a');
	link.download = 'Oku Sanga';
	link.href = 'apk/Oku Sanga.apk';
	document.appendChild(link);
	mostrar(link);
	link.click();
	document.removeChild(link);
	delete link;
	
}

function mostrar(msg){
alert(msg);
}