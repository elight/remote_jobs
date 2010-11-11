var searcher;

var job_searcher = function() {
	
	this.setup = function() {
		searcher.handle_label_clicks();
		searcher.handle_search_form();
	};

	this.handle_label_clicks = function() {
		$('#filters label').click(searcher.check_siblings_and_toggle);
	};
	
	this.handle_search_form = function() {
		$('#query').keyup(searcher.toggle_search_form_icon);
		$('#search input[type="submit"].clear').live('click', function(event) {
			// make sure this was a click (also fires on form enter-key submission)
			if (event.clientX != 0 && event.clientY != 0) {
				$('#query').val('').keyup();
				searcher.do_filter();
			}
		});
		$('#search form').submit(function(event) {
			searcher.do_filter();
			event.preventDefault();
		});
	};
	
	this.toggle_search_form_icon = function() {
		var $input = $(this);
		var $button = $('#search input[type="submit"]');
		if ($input.val() != "")
			$button.addClass('clear');
		else
			$button.removeClass('clear');
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
		
		_.each(["design", "development", "copywriting", "management", "freelancer", "employee", "hourly", "salary"], function(param_name) {
			if ($('#'+param_name).hasClass('checked'))
				post_params[param_name] = "1";
		});
		
		var search_query = $('#query').val();
		if (search_query != "")
			post_params["search"] = search_query
			
		return post_params;
	};
	
	this.hide_jobs = function() {
		$('#jobs').children().fadeOut(400);
		$('#spinner').hide().delay(400).show();
	}
	
	this.show_jobs = function() {
		$('#spinner').hide();
		$('#jobs').children().fadeIn();
	}
	
	this.do_filter = function() {
		var post_params = searcher.collect_filters();
		searcher.hide_jobs();
		$.get("/filter", post_params, searcher.update_page);
	};
	
	this.do_search = function() {
		var search_query = $('#query').val();
		searcher.hide_jobs();
		$.get("/search?search=" + search_query, searcher.update_page);
	};
	
	this.update_page = function(data) {
		if (data.trim() == "")
			data = '<li class="no-results">Sorry, no jobs were found.</li>';
		$('#jobs').html(data);
		searcher.show_jobs();
	};
	
}

$(document).ready(function() {
	// initialize our searcher functionality object
	searcher = new job_searcher();
	searcher.setup();
});