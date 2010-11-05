function initializeSliders() {
	$("#min-slider").slider({
		min: 0,
		max: 24,
		value: 0,
		slide: function(event, ui) {
			var max_value = $("#max-slider").slider('value');
			if(ui.value > max_value)
				return false;
			if(ui.value == 0)
				$("#min-value").text("<1 month");
			else
				$("#min-value").text(ui.value + " months");
		},
		change: function(event, ui) {
			// do ajax here
		}
	});
	$("#min-value").text("<1 month");
	
	$("#max-slider").slider({
		min: 1,
		max: 25,
		value: 25,
		slide: function(event, ui) {
			var min_value = $("#min-slider").slider('value');
			if(ui.value < min_value)
				return false;
			if(ui.value == 25)
				$("#max-value").text("indefinite");
			else
				$("#max-value").text(ui.value + " months");
		},
		change: function(event, ui) {
			// do ajax here
		}
	});
	$("#max-value").text("indefinite");
}

$(document).ready(function() {
	initializeSliders();
});