jQuery(function($) {
	var csrf = $('#_csrf').val(),
		userList = $('#user-list');

	loadMore();

	$('#user-search').submit(function(ev) {
		ev.preventDefault();
		loadMore();
	});

	$('#user-checkall').change(function() {
		$('#user-list > tr > td > input[type=checkbox]').prop('checked', this.checked);
	});

	function loadMore() {
		var skip = parseInt($('#user-count').html()),
			limit = 20,
			q = $('#user-search-q').val(),
			filter = $('user-search-filter option:selected').val();

		var data = {
			skip: skip,
			limit: limit
		};

		if (q) {
			data.q = q;
			data.filter = filter;
		}

		$.get('/user/list', data, function(data, textStatus) {

			var baseRow = $('#user-baserow');

			//console.log('get', userList, baseRow);

			for( var i= 0, len=data.length; i<len; i++ ) {
				var row = baseRow.clone().attr('id', 'user-'+(skip++)).prop('style', false);

				updateRow(row, data[i]);

				//console.log(row);

				row.appendTo(userList);
			}

			$('#user-count').html(skip);
		});
	}

	userList.on('click', '.user-state', function() {
		var th = $(this),
			tr = th.closest('tr'),
			newState = tr.find('.user-new-state'),
			provider = tr.find('.user-provider').val(),
			state = newState.val() === 'inactive' ? 'active' : 'inactive';

		if (state === 'active' && !provider) {
			state = 'email';
		}

		newState.val(state);
		th.attr('class', 'user-state user-state-'+state);
	});

	$('#user-updateall').click(function() {
		var users = [];

		$('#user-list > tr > td > input[type=checkbox]:checked').closest('tr').each(function() {
			users.push(getRowData($(this)));
		});

		updateall(users);
	});

	$('#user-updateall-group').click(function() {
		var users = [];

		$('#user-list > tr > td > input[type=checkbox]:checked').closest('tr').each(function() {
			var row = getRowData($(this));

			delete row.newEmail;
			delete row.firstname;
			delete row.lastname;
			delete row.state;

			users.push(row);
		});

		updateall(users);
	});

	$('#user-updateall-state').click(function() {
		var users = [];

		userList.find('> tr > td > input[type=checkbox]:checked').closest('tr').each(function() {
			var row = getRowData($(this));

			delete row.newEmail;
			delete row.firstname;
			delete row.lastname;
			delete row.group;

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
			//console.log('resendall', data);
		});
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
		}, 'json');
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
		}, 'json');
	});

	$('#user-create .user-create').click(function(event) {
		var row = $('#user-create'),
			update = getRowData(row);

		update.email = update.newEmail;

		var data = {
			action: 'create',
			_csrf: csrf,
			user: update
		};

		$.post('/user/list', data, function(data, textStatus) {
			//console.log('success', data, textStatus);

			var count = parseInt($('#user-count').html()),
				baseRow = $('#user-baserow');

			var newRow = baseRow.clone().attr('id', 'user-'+count).prop('style', false);

			updateRow(newRow, data);

			//console.log(newRow);

			newRow.appendTo(userList);

			$('#user-count').html(count+1);

			row.find('input[type=text]').val('');
			row.find('select option').prop('selected', false);
			row.find('select option[value=guest]').prop('selected', true);
		}, 'json');
	});

	function getRowData(row) {
		var oEmail = row.find('.user-orig-email').val(),
			oFirstname = row.find('.user-orig-firstname').val(),
			oLastname = row.find('.user-orig-lastname').val(),
			oGroup = row.find('.user-orig-group').val(),
			oState = row.find('.user-orig-state').val(),
			email = row.find('.user-email').val(),
			firstname = row.find('.user-firstname').val(),
			lastname = row.find('.user-lastname').val(),
			group = row.find('select option:selected').val(),
			state = row.find('.user-new-state').val(),
			data = {email: oEmail};

		if (email && email !== oEmail) data.newEmail = email;
		if (firstname !== oFirstname) data.firstname = firstname;
		if (lastname !== oLastname) data.lastname = lastname;
		if (group !== oGroup) data.group = group;
		if (state !== oState) data.state = state;

		return data;
	}

	function updateRow(row, data) {
		row.find('.user-orig-email, .user-email').val(data.email);
		row.find('.user-orig-firstname, .user-firstname').val(data.name);
		row.find('.user-orig-lastname, .user-lastname').val(data.surname);
		row.find('.user-orig-group').val(data.groups);

		row.find('select option').prop('selected', false);
		row.find('select option[value="'+data.groups+'"]').prop('selected', true);
		row.find('.user-provider').val(data.provider);

		var state = data.active ? 'active' : 'inactive';

		if (data.awaitConfirm && (!data.provider || data.provider.length === 0))
			state = 'email';

		row.find('.user-orig-state, .user-new-state').val(state);
		row.find('.user-state').attr('class', 'user-state user-state-'+state);
	}
});