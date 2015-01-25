function clearBox() {
	document.getElementById('user_session_login').setAttribute("class", "touched");
	if (document.getElementById('user_session_login').value == "Login") {
		document.getElementById('user_session_login').value = "";
	}
}
function fillBox() {
	if (document.getElementById('user_session_login').value == "") {
		document.getElementById('user_session_login').value = "Login";
		document.getElementById('user_session_login').setAttribute("class", "untouched");
	}
}

function clearPassword() {
	document.getElementById('user_session_password').type = "password";
	document.getElementById('user_session_password').setAttribute("class", "touched");
	if (document.getElementById('user_session_password').value == "Password") {
		document.getElementById('user_session_password').value = "";
	}
}
function fillPassword() {
	if (document.getElementById('user_session_password').value == "") {
		document.getElementById('user_session_password').type = "text";
		document.getElementById('user_session_password').value = "Password";
		document.getElementById('user_session_password').setAttribute("class", "untouched");
	}
}

window.onload = function() {
	document.getElementById('user_session_login').onfocus = clearBox;
	document.getElementById('user_session_login').onblur = fillBox;
	document.getElementById('user_session_password').onblur = fillPassword;
	document.getElementById('user_session_password').onfocus = clearPassword;
	
	document.getElementById('user_session_login').setAttribute("class", "untouched");
	document.getElementById('user_session_password').setAttribute("class", "untouched");
	
	document.getElementById('user_session_login').value = "Login";
	document.getElementById('user_session_password').value = "Password";
	document.getElementById('user_session_password').type = "text";
}