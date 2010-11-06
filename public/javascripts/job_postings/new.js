$(document).ready(function() {
	$('form .term-slider').each(function() {
		$(this).append('<div class="slider"></div><div class="slider-value">6 months</div>');
		$(this).find('.slider').slider({
			min: 0,
			max: 25,
			value: 6,
			slide: function(event, ui) {
				if(ui.value == 0)
					$(".slider-value").text("<1 month");
				else if(ui.value == 1)
					$(".slider-value").text("1 month");
				else if(ui.value == 25)
					$(".slider-value").text("indefinite");
				else
					$(".slider-value").text(ui.value + " months");
				$('#job_posting_contract_term_length').val(ui.value);
			}
		});
		$(this).find('input[type="text"]').val('6').hide();
	});
	
	// won't work without JS so we hide with CSS by default to degrade gracefully
	// TODO $('#posting-preview').show();
});