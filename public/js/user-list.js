jQuery(function($) {
	var socket = new eio.Socket();
	socket.on('open', function() {
		console.log('open');
	});
	socket.on('message', function(data) {
		console.log('message', data);
	});
	socket.on('close', function() {
		console.log('close');

		setTimeout(function() {
			socket.open();
		}, 5000);
	});

	var csrf = $('#_csrf').val(),
		userList = $('#user-list'),
		sort = $('#user-sort'),
		order = $('#user-sort-order'),
		count = parseInt($('#user-count').html()),
		total = parseInt($('#user-total').html()),
		searchQ = $('#user-search-q'),
		searchF = $('#user-search-filter'),
		unsynced = $('#user-unsynced'),
		noprovider = $('#user-noprovider');

	var q = searchQ.val(),
		f = searchF.find('option:selected').val();

	var updateTime = 10000,
		updateId,
		loading = false;

	loadMore(true);
	//resetAutoUpdate();

	$('#user-search').submit(function(ev) {
		ev.preventDefault();
		q = searchQ.val();
		f = searchF.find('option:selected').val();
		loadMore(true);
	});

	$('#user-upload').submit(function(ev) {
		ev.preventDefault();
		var formData = new FormData(this)
		console.log('upload', this, formData, formData.file);

		var progress = $('#user-upload-progress');

		formData.action = 'upload'

		jqXHR = $.ajax({
			url: '/user/list?action=upload&_csrf='+csrf,
			type: 'POST',
			data: formData,
			cache: false,
			contentType: false,
			processData: false,
			xhr: function() {
				var xhr = $.ajaxSettings.xhr();
				if (xhr.upload) {
					xhr.upload.addEventListener('progress', function(ev) {
						if (ev.lengthComputable) {
							progress.attr({value:ev.loaded,max:ev.total});
						}
					});
				}
				return xhr;
			}
		}).done(function(data, textStatus, jqXHR) {
			console.log('done', data, textStatus);
		});
	});

	$('#user-checkall').change(function() {
		$('#user-list > tr > td > input[type=checkbox]').prop('checked', this.checked);
	});

	var sorter = $('#user-table > thead > tr').on('click', 'th.sort', function() {
		var th = $(this),
			all = sorter.find('th.sort'),
			type = this.id.replace('head-', '');

		// Cycle through ascending, descending, and no sort.
		if (th.hasClass('sort-asc')) {
			all.removeClass('sort-asc sort-desc');
			th.addClass('sort-desc');
			sort.html(type);
			order.html('desc');
		}
		else if (th.hasClass('sort-desc')) {
			all.removeClass('sort-asc sort-desc');
			sort.html('');
			order.html('');
		}
		else {
			all.removeClass('sort-asc sort-desc');
			th.addClass('sort-asc');
			sort.html(type);
			order.html('asc');
		}

		loadMore(true);
	});

	function clear() {
		count = 0;
		userList.find('> .user').remove();
	}

	function loadMore(reset) {
		if (loading) return;

		if (reset) count = 0;

		if (count > 0 && count === total) return;

		loading = true;

		var skip = count,
			limit = 10,
			s = sort.html(),
			o = order.html();

		var data = {
			skip: skip,
			limit: limit
		};

		if (q) {
			data.q = q;
			data.filter = f;
		}

		if (s) {
			data.sort = s;
			data.order = o;
		}

		$.get('/user/list', data, function(data, textStatus) {
			if (data._csrf) csrf = data._csrf;
			if (reset) userList.find('> .user').remove();

			var baseRow = $('#user-baserow'),
				users = data.users || [],
				c = data.count || 0;

			for( var i= 0, len=users.length; i<len; i++ ) {
				var row = baseRow.clone().attr('id', 'user-'+(skip++)).show();

				updateRow(row, users[i]);
				row.appendTo(userList);
			}

			total = c;
			count = skip;
			//resetAutoUpdate();
			unsynced.hide();

			if (count === total) {
				$('#user-loadmorerow').hide();
			}
			else {
				$('#user-loadmorerow').show();
			}

			loading = false;
		}).fail(handleError);
	}

	function resetAutoUpdate() {
		if (updateId) {
			window.clearInterval(updateId);
		}

		updateId = window.setInterval(autoUpdate, updateTime);
	}

	function autoUpdate() {
		var data = {count:true};

		if (q) {
			data.q = q;
			data.filter = f;
		}

		$.get('/user/list', data, function(data, textStatus) {
			if (data._csrf) csrf = data._csrf;
			var t = total;

			if (t !== data.count) {
				total = data.count;

				if (sort.html() || data.count < t) {
					unsynced.show();
				}
				else if (t === count) {
					loadMore();
				}
			}
		}).fail(handleError);
	}

	$('#user-sync').click(function() {
		loadMore(true);
	});

	$('#user-loadmore').click(function() {
		loadMore();
	});

	$('button.close').click(function() {
		$(this).closest('tr').hide();
	});

	userList.on('click', '.user-state', function() {
		var th = $(this),
			tr = th.closest('tr'),
			newState = tr.find('.user-new-state'),
			provider = tr.find('.user-provider').val(),
			state = newState.val();

		if (state === 'active') {
			state = 'inactive';
		}
		else if (state === 'inactive') {
			state = 'active';

			if (!provider) {
				noprovider.show();

				var scroll = noprovider.offset().top - 50;

				if ($(document).scrollTop() > scroll) {
					$('html, body').animate({scrollTop:scroll}, 250);
				}
				return;
			}
		}

		var data = {
			action: 'state',
			_csrf: csrf,
			state: state,
			email: tr.find('.user-orig-email').val()
		};

		$.post('/user/list', data, function(data, textStatus) {
			if (state === 'email') state = 'email-recent';

			newState.val(state);
			th.attr('class', 'user-state user-state-'+state);
		}).fail(handleError);
	});

	$('#user-updateall').click(function() {
		var users = [];

		$('#user-list > tr > td > input[type=checkbox]:checked').closest('tr').each(function() {
			users.push(getRowData($(this)));
		});

		updateall(users);
	});

	$('#user-updateall-groups').click(function() {
		var users = [];

		$('#user-list > tr > td > input[type=checkbox]:checked').closest('tr').each(function() {
			var row = getRowData($(this));

			delete row.newEmail;
			delete row.name;
			delete row.surname;
			delete row.state;

			users.push(row);
		});

		updateall(users);
	});

	$('#user-resendall').click(function() {
		var emails = [];

		userList.find('> tr > td > input[type=checkbox]:checked').closest('tr').each(function() {
			emails.push($(this).find('.user-orig-email').val());
		});

		var data = {
			action: 'resendall',
			_csrf: csrf,
			emails: emails
		};

		$.post('/user/list', data, function(data, textStatus) {
			noprovider.hide();

			var row;

			for (var i= 0, len=emails.length; i<len; i++) {
				var row = userList.find('.user-orig-email[value="'+emails[i]+'"]').closest('tr'),
					provider = row.find('.user-provider').val(),
					state = row.find('.user-orig-state').val();

				if (state === 'email' || (state === 'inactive' && !provider)) {
					state = 'email-recent';

					row.find('.user-orig-state, .user-new-state').val(state);
					row.find('.user-state').attr('class', 'user-state user-state-'+state);
				}
			}
		}).fail(handleError);
	});

	function updateall(users) {
		var data = {
			action: 'updateall',
			_csrf: csrf,
			users: users
		};

		$.post('/user/list', data, function(data, textStatus) {
			//console.log('success', data);

			for( var i= 0, len=data.length; i<len; i++ ) {
				var row = userList.find('.user-orig-email[value="'+data[i].origEmail+'"]').closest('tr');

				updateRow(row, data[i]);
			}
		}, 'json').fail(handleError);
	}

	userList.on('click', '.user-update', function(event) {
		//console.log('user-update', this, event);
		event.preventDefault();
		var row = $(this).closest('tr'),
			update = getRowData(row);

		var data = {
			action: 'update',
			_csrf: csrf,
			user: update
		};

		$.post('/user/list', data, function(data, textStatus) {
			//console.log('success', data, textStatus);

			updateRow(row, data);
		}, 'json').fail(handleError);
	});

	$('#user-create').click(function(event) {
		var row = $('#user-createrow'),
			update = getRowData(row);

		update.email = update.newEmail;

		var data = {
			action: 'create',
			_csrf: csrf,
			user: update
		};

		$.post('/user/list', data, function(data, textStatus) {
			//console.log('success', data, textStatus);

			var baseRow = $('#user-baserow');

			var newRow = baseRow.clone().attr('id', 'user-'+count++).show();

			updateRow(newRow, data);

			//console.log(newRow);

			newRow.appendTo(userList);

			row.find('input[type=text]').val('');
			row.find('select option').prop('selected', false);
			row.find('select option[value=guest]').prop('selected', true);

			count++;
			total++;
		}, 'json').fail(handleError);
	});

	function getRowData(row) {
		var oEmail = row.find('.user-orig-email').val(),
			oName = row.find('.user-orig-name').val(),
			oSurname = row.find('.user-orig-surname').val(),
			oGroups = row.find('.user-orig-groups').val(),
			oState = row.find('.user-orig-state').val(),
			email = row.find('.user-email').val(),
			name = row.find('.user-name').val(),
			surname = row.find('.user-surname').val(),
			groups = row.find('select option:selected').val(),
			state = row.find('.user-new-state').val(),
			data = {email: oEmail};

		if (email && email !== oEmail) data.newEmail = email;
		if (name !== oName) data.name = name;
		if (surname !== oSurname) data.surname = surname;
		if (groups !== oGroups) data.groups = groups;
		if (state !== oState) data.state = state;

		return data;
	}

	function updateRow(row, data) {
		row.find('.user-orig-email, .user-email').val(data.email);
		row.find('.user-orig-name, .user-name').val(data.name);
		row.find('.user-orig-surname, .user-surname').val(data.surname);
		row.find('.user-orig-groups').val(data.groups);

		row.find('select option').prop('selected', false);
		row.find('select option[value="'+data.groups+'"]').prop('selected', true);
		row.find('.user-provider').val(data.provider);

		var state = data.active ? 'active' : 'inactive';

		if (data.awaitConfirm && (!data.provider || data.provider.length === 0))
			state = 'email';

		row.find('.user-orig-state, .user-new-state').val(state);
		row.find('.user-state').attr('class', 'user-state user-state-'+state);
	}

	function handleError(jqXHR, textStatus, errorThrown) {
		var box = $('#user-errormsg');

		var err = jqXHR;

		var msg = err.status +' '+ err.statusText;
		if (err.responseText) msg += ': ' + err.responseText;

		box.find('span').text(msg);
		box.show();

		var scroll = box.offset().top - 50;

		if ($(document).scrollTop() > scroll) {
			$('html, body').animate({scrollTop:scroll}, 250);
		}
	}
});