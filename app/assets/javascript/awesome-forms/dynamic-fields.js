// TODO: We don't wrap fields in a fields class so need to work out another way. Maybe the number of fields to hide?
function awesome_forms_remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".awesome-forms-group").hide();
}

function awesome_forms_add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id));
}