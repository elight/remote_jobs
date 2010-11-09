var searcher;

var job_searcher = function() {
	
	this.start_monitoring = function() {
		_.each(["freelancer", "employee", "hourly", "salary"], function(dom_id) {
			$('#'+dom_id).click(searcher.do_filter);
		});
	};
	
	this.collect_filters = function() {
		var post_params = {};
		
		_.each(["freelancer", "employee", "hourly", "salary"], function(param_name) {
			if ($('#'+param_name).val())
				post_params[param_name] = "1";
		});
		
		post_params["min_term"] = $("#min-slider").slider('value');
		post_params["max_term"] = $("#max-slider").slider('value');
		
		return post_params;
	};
	
	this.do_filter = function() {
		var post_params = searcher.collect_filters();
		console.log('making ajax query...');
		
		$.get("/search/filter", post_params, searcher.update_page);
	};
	
	this.do_search = function() {
		var search_query = $('#query').val();
		
		if (search_query != "") {
			post_params["search"] = search_query;
			
		}
	};
	
	this.update_page = function(data) {
		//console.log(data);
	};
	
}

$(document).ready(function() {
	searcher = new job_searcher();
	searcher.start_monitoring();
});