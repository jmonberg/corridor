function setPic() {	
document.getElementById("rollingpic").src = imageurls[current_pic][0];
document.getElementById("image_link").href = imageurls[current_pic][1];
document.getElementById("rollingpic").alt = imageurls[current_pic][2];
document.getElementById("currentingallery").innerHTML = [current_pic+1];
}
function nextPic() {
if (current_pic != imageurls.length-1)
  {
  current_pic++;
  setPic(); 
  }
}
function prevPic() {
if (current_pic != 0)
  {
current_pic--;
  setPic();
  }
}
window.onload = setPic;