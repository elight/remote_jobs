function handle_custom_checkboxes() {
	$('label.clickable').click(function() {
		$(this).toggleClass('checked');
		var $checkbox = $(this).siblings('checkbox');
		$checkbox.attr('checked', !$checkbox.attr('checked'));
	});
}

function handle_selected_radio_buttons() {
	$('input:radio').click(function() {
		$(this).parents('ol:eq(0)').find('label.selected').removeClass('selected');
		$(this).parent().addClass('selected');
	});
	$('input:radio:checked').parent().addClass('selected');
}

function setup_input_masking() {
	$('.phone-mask').mask('999-999-9999',{placeholder:" "});
	$('.cc-number').mask('9999999999999999',{placeholder:" "});
	$('.cc-cvv').mask('9999',{placeholder:" "});
}

$(document).ready(function() {
	handle_custom_checkboxes();
	handle_selected_radio_buttons();
	setup_input_masking();
});