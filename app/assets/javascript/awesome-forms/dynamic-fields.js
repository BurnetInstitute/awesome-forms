$(document).on('click', 'form .awesome_forms_remove_fields', function(e) {
  $(this).prev("input[type=hidden]").val("1");
  $(this).closest("fieldset").hide();
  e.preventDefault()
});

$(document).on('click', 'form .awesome_forms_add_fields', function(e) {
  var new_id = new Date().getTime();
  var regexp = new RegExp($(this).data('id'), "g")
  $(this).before($(this).data('fields').replace(regexp, new_id))
  e.preventDefault()
});
