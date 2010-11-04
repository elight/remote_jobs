$(document).ready(function() {
	$('form .term-slider').each(function() {
		$(this).append('<div class="slider"></div><div class="slider-value"></div>');
		$(this).find('.slider').slider();
		$(this).find('input[type="text"]').hide();
	});
});