function handleCustomCheckboxes() {
	$('label.clickable').click(function() {
		$(this).toggleClass('checked');
		var $checkbox = $(this).siblings('checkbox');
		$checkbox.attr('checked', !$checkbox.attr('checked'));
	});
}

$(document).ready(function() {
	handleCustomCheckboxes();
});