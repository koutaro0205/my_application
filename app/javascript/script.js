import jquery from "jquery"
window.$ = jquery
// $(".image__field").bind("change", function() {
//   var size_in_megabytes = this.files[0].size/1024/1024;
//   if (size_in_megabytes > 5) {
//     alert("Maximum file size is 5MB. Please choose a smaller file.");
//     $(".image__field").val("");
//   }
// });

$(function () {
  $('#openModal').click(function(){
      $('#modalArea').fadeIn();
  });
  $('#closeModal , #modalBg').click(function(){
    $('#modalArea').fadeOut();
  });
});