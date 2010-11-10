var searcher;

var job_searcher = function() {
	
	this.setup = function() {
		// setup our DOM events
		searcher.setup_sliders();
		searcher.handle_label_clicks();
	};
	
	this.setup_sliders = function() {
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
				searcher.do_filter();
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
				searcher.do_filter();
			}
		});
		$("#max-value").text("indefinite");
	};

	this.handle_label_clicks = function() {
		$('#freelancer, #employee, #hourly, #salary').click(searcher.check_siblings_and_toggle);
	};

	this.toggle_label = function($label) {
		$label.toggleClass('checked');
		searcher.do_filter();
	};

	this.check_siblings_and_toggle = function() {
		var $label = $(this);

		// if I'm unchecked, just check me
		if (!$label.hasClass('checked')) {

			searcher.toggle_label($label);

		} else { // make sure at least one other sibling is checked

			var checked_siblings = $label.siblings('.checked');
			if (checked_siblings.length > 0) {
				searcher.toggle_label($label);
			}

		}
	};
	
	this.collect_filters = function() {
		var post_params = {};
		
		_.each(["freelancer", "employee", "hourly", "salary"], function(param_name) {
			if ($('#'+param_name).hasClass('checked'))
				post_params[param_name] = "1";
		});
		
		post_params["min_term"] = $("#min-slider").slider('value');
		post_params["max_term"] = $("#max-slider").slider('value');
		
		return post_params;
	};
	
	this.hide_jobs = function() {
		$('#jobs').fadeOut(400);
		$('#spinner').hide().delay(400).show();
	}
	
	this.show_jobs = function() {
		$('#spinner').hide();
		$('#jobs').fadeIn();
	}
	
	this.do_filter = function() {
		var post_params = searcher.collect_filters();
		searcher.hide_jobs();
		$.get("/filter", post_params, searcher.update_page);
	};
	
	this.do_search = function() {
		var search_query = $('#query').val();
		if (search_query != "")
			post_params["search"] = search_query;
	};
	
	this.update_page = function(data) {
		if (data.trim() == "")
			data = '<li class="no-results">Sorry, no jobs matched your filter.</li>';
		$('#jobs').html(data);
		searcher.show_jobs();
	};
	
}

$(document).ready(function() {
	// initialize our searcher functionality object
	searcher = new job_searcher();
	searcher.setup();
});