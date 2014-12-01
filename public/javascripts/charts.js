// charts.js
// library of JS functions for chart reports

function instrument_hours_all()
{
	$.getJSON('chart_data/instrument_hours.json', function(json){
		create_canvasXpress_graph("hours", "Instrument Usage by Time", "Pie", json, "1x1")
	}); //getJSON
}

function instrument_hours_two_years()
{
	$.getJSON('chart_data/instrument_hours_year_by_year.json', function(json){
		create_canvasXpress_graph("year_by_year", "Instrument Usage Year by Year", "Pie", json , "1X2")
	})
} //instrument_hours_two_years

function instrument_usage_last_year()
{
	$.getJSON('chart_data/instrument_usage_past_year.json', function(json){
		create_canvasXpress_graph("Usage", "Instrument Timeline", "Line", json)
	})
}

function instrument_usage_and_maintenance_last_year()
{
	$.getJSON('chart_data/usage_and_maintenance.json', function(json){
		var line = [];
		var bar = [];
		$.each(json["vars"], function(index, item){
			var pattern = /_maintenance$/i
			if(pattern.test(item)){
				bar.push(item);
			}
			else
			{
				line.push(item)
			}
		});
		
		create_canvasXpress_graph("Usage", "Instrument Timeline", "StackedLine", json, {"xAxis": bar, "xAxis2": line});
	})
}

function user_totals_last_year()
{
	$.getJSON('chart_data/user_totals.json', function(json){
		create_canvasXpress_graph("Usage", "User Entries Past Year", "Bar", json);
	});
}

function create_canvasXpress_graph(id, title, type, json, options)
{
	$.ajaxSetup({
		cache: false
	});
	
	$('#chart_area').html('<canvas id=' + id + 
						' width=600 height=600></canvas>');
						
	var conf;
	var data;
	if(type == 'Line')
	{
		$('#' + id).attr('width', 800);
		conf = line_chart_conf(json["smps"], title);
		data = { "y": json };
	}
	else if(type == "Pie")
	{
		conf = pie_chart_conf(json["smps"], title, options);
		data = { "y": json };
		
	}
	else if(type == "StackedLine")
	{
		$('#' + id).attr('width', 800);
		conf = stacked_line_chart_conf(json["smps"], title);
		data = { "y": json, "a": options };
	}
	else if(type == "Bar")
	{
		$('#' + id).attr('width', 800);
		conf = bar_chart_conf(json["smps"], title);
		data = {"y": json};
	}

	new CanvasXpress(id,
		data,
		conf
	); //CanvasXpress
	//$("#"+id).html(JSON.stringify(data) + ',' + JSON.stringify(conf));
} //create_canvasXpress_graph

function pie_chart_conf(xAxis, title, layout)
{
	return ({
		"graphType": 'Pie',
		"title": title,
		"layout": layout,
		"xAxis": xAxis,
		"showPieGrid": false
	});
}

function bar_chart_conf(yAxis, title)
{
	return ({
		"graphType": 'Bar',
		"title": title,
		"showSampleNames": false,
		"yAxis": yAxis,
		"graphOrientation": "vertical"
	});
}

function stacked_line_chart_conf(xAxis, title)
{
	return ({
		"graphType": 'StackedLine',
		"title": title,
		"xAxis": xAxis,
		"graphOrientation": "vertical"
	});
}

function line_chart_conf(xAxis, title)
{
	return ({
		"graphType": 'Line',
		"title": title,
		"xAxis": xAxis,
		"graphOrientation": "vertical",
	});
}
