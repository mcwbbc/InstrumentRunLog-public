// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//functions

function addButtons()
{
	$("a#add").button({
		icons:{primary:"ui-icon-plusthick"},
		text: false
		});
	$("a#remove").button({
		icons:{primary:"ui-icon-minusthick"},
		text: false
		});
	$("a.edit").button({
		icons:{primary:"ui-icon-pencil"},
		text: false
	});
	$("a.view").button({
		icons:{primary:"ui-icon-search"},
		text: false
	});
	
	$('.trash').css('font-size', '.7em');
	$('.trash').button();
}

function entryFormButtons()
{
	$("#clone").button({
		icons:{primary:"ui-icon-copy"},
		text: false
	});
	$("#clone_blank").button({
		icons:{primary:"ui-icon-copy"},
		text: false
	});
	$("#add_blank").button({
		icons:{primary:"ui-icon-plusthick"},
		text: false
	});	
	$("#remove_blank").button({
		icons:{primary:"ui-icon-minusthick"},
		text: false
	});
}

function menuButtons()
{
	$(".menu_items").buttonset();
	$(".menu_admin_items").buttonset();
}

function addDataTable(sort){
	var table = $(".data_table").dataTable({
		'aaSorting': sort['aaSorting'],
		'bJQueryUI': true,
		'sDom': '<"H"Tfrl>t<"F"ip>',
		'oTableTools': {
			'sSwfPath': '/swf/copy_cvs_xls_pdf.swf',
			'aButtons': [ {
				'sExtends': 'collection',
				'sButtonText': 'Export',
				'aButtons': [{
						'sExtends': "csv",
						'mColumns': [0,1,2,3,4,5,6,7,8,9,10,11,12]
					},
					{
						'sExtends': "xls",
						'mColumns': [0,1,2,3,4,5,6,7,8,9,10,11,12]
					},
					{
						'sExtends': "pdf",
						"sPdfOrientation": "landscape",
						'mColumns': [0,1,2,3,4,5,6,7,8,9,10,12]
				}]
			}]
		}
	});
	
	$(table).on("draw", addButtons );
}

function addSampleLine(table_id, new_sample){
	
	var original_row = $(table_id +' tbody>tr:last');
	var table_row = original_row.clone(true, true);
	//get original selects into a jq object
	var original_selects = original_row.find('select');

	table_row.find('select').each(function(index, item) {
	     //set new select to value of old select
	     $(item).val( original_selects.eq(index).val() );
	});
	
	table_row.insertAfter(table_id + ' tbody>tr:last');
	if(new_sample){
		var original_name = $(table_id + ' tbody>tr:last [data-name=true]').val().match(/^\w+/);
		var count = $(".counter", table_row).attr('id');
		count ++;
		$(table_id + ' tbody>tr:last .counter').attr('id', count);
		$(table_id + ' tbody>tr:last [data-name]').val(original_name + ' ' + count);
		$(table_id + ' tbody>tr:last [loading-time]').val('');
		$(table_id + ' tbody>tr:last [digests]').val('');
		$(table_id + ' tbody>tr:last [runs]').val('');
		$(table_id + ' tbody>tr:last [gradient]').val('');
	}
	table_row.find('input[type="text"]:first').focus();
	
	calculateTotalRuntime();
}

function removeSampleLine(table_id){
	var count = $(table_id + ' tbody>tr').length;
	if(count > 2)
	{
		$(table_id + ' tbody>tr:last').remove();
	}
	calculateTotalRuntime();
}

//updates the sample category drop down menu based on instrument selection
function updateCategories(){
	var name = $('#entry_instrument option:selected').text();
	if(name === ' '){
		return false;
	}
	
	$.get('/instruments/' + name + '/categories.json', function(data) {
		
		$('.entry_sample_categories').each(function(){
			$(this).empty();
		});
		
		$.each(data, function(index, value) {
			var c_name = value.category.name
		    $('.entry_sample_categories').each(function(){
				$(this).append($("<option></option>").
		        attr("value",c_name).
		        text(c_name));
			});
		          		
		});
	});
};

//updates the total runtime and times are entered
function calculateTotalRuntime() {
	var sum = 0;
	$('.sampleRow').each(function(){
		var runs = parseFloat($(this).find('.sample #entry_samples_attributes__runs').val());
		var gradient = parseFloat($(this).find('.sample #entry_samples_attributes__gradient').val());
		var loading_time = parseFloat($(this).find('.sample #entry_samples_attributes__loading_time').val());
		if(!(isNaN(gradient) || isNaN(runs))) {
			sum += (gradient * runs) + loading_time;
		}
	});
	
	$('.blankRow').each(function(){
		var blank_runs = parseFloat($(this).find('.blank #entry_blanks_attributes__runs').val());
		var blank_gradient = parseFloat($(this).find('.blank #entry_blanks_attributes__gradient').val());
		if(!(isNaN(blank_gradient) || isNaN(blank_runs))) {
			sum += (blank_gradient * blank_runs);
		}		
	});

	$("#totalTime").text(sum);
}

function flag_entry_as_unbillable(){
	if($('#entry_unbillable').is(':checked')){
		$('.content').prepend('<div class=unbillable>Unbillable Entry</div>');
		$('.content').css('border', 'thick solid red');
		$('.content').append('<div class=unbillable>Unbillable Entry</div>');
	}
	else{
		$('.unbillable', '.content').remove();
		$('.content').css('border', 'none');
	}
}

function itemizedInvoiceButton(){
	var item = $("a#itemized_details");
	if(item.attr("status") == "closed"){
		item.button({
			icons:{primary:"ui-icon-triangle-1-n"},
			label: 'Click to reveal details',
			text: false
		});
	}
	else{
		item.button({
			icons:{primary:"ui-icon-triangle-1-s"},
			label: 'Click to hide details',
			text: false
		});
	}
}

function addFunctions2EntryForm()
{
	calculateTotalRuntime();
	
	if($('#entry_instrument').length != 0) {
		updateCategories();
	}
			
	//add sample line
	$("#add").click(function() {
		addSampleLine('#sampleTable', true);
		return false;
	});
	
	$('#add_blank').click(function(){
		addSampleLine('#blankTable', true);
		return false;
	})
	
	$("#clone").click(function() {
		addSampleLine('#sampleTable', false);
		return false;
	})
	
	$("#clone_blank").click(function() {
		addSampleLine('#blankTable', false);
		return false;
	})

	//remove sample line
	$("#remove").click(function(){
		removeSampleLine('#sampleTable');
		return false;
	});
	
	//remove sample line
	$("#remove_blank").click(function(){
		removeSampleLine('#blankTable');
		return false;
	});

	//calculate total run time as info is entered
	$('input[gradient]').keyup(function() {
		calculateTotalRuntime();
		return false;
	});

	$('input[loading-time]').keyup(function() {
		calculateTotalRuntime();
		return false;
	});
	
	//show or hide additional requirements are needed
	$('#entry_project_id').change(function() {
		var value = $('#entry_project_id option:selected').text();
		
		// -1 if not in array optional_required
		if($.inArray(value, optional_required) > -1) {
			$('#optional').slideDown();
			$('#entry_pi').focus();
		}
		else
		{
			$('#optional').slideUp();
		}
		return false;
	});
}