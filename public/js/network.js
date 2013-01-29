function sortByKey(key){
  return function(a,b){
          if (a[key] < b[key])
             return -1;
         if (a[key] > b[key])
            return 1;
         return 0;
  }
}

function buildChapters() {

	$.ajax({
		url: 'http://chapters.zmgc.net',
		dataType: 'json',
		cache: true,
		ifModified: true,
		success: function(data){   // "Type","Name","Link","Contact","Location","Icon"
			var countries = [];
			data.rows.forEach(function(row){
				if (row[0] == 'Country') {
					countries.push({
						link:row[2],
						contact:row[3],
						country: row[4]
					});
				}
				else if (row[0] == 'Region') {
					//console.log(row);
				}
			});

			//alphabetically
			countries.sort(sortByKey('country'));

			//console.log(countries);

			var strHtml;
			var strClass;
			var intIndex;
			var arrHtml = [];
			arrHtml[0] = [];
			arrHtml[1] = [];
			arrHtml[2] = [];
			arrHtml[3] = [];
			var intCountryCount = 0;
			var intCurrentColumn = 0;
			var intMaxCountriesPerColumn = 14;

			countries.forEach(function(row){

				//console.log(row);

				if (intCountryCount == intMaxCountriesPerColumn) {
					intCountryCount = 0;
					intCurrentColumn++;
				}

				strClass = row.country;
				strClass = strClass.toLowerCase();
				strClass = strClass.replace(/ /g, "");

				strHtml = "";
				strHtml += "<li>";
				strHtml += "<a href=\"" + row.link + "\" class=\"chapters c_" + strClass + "\">";
				strHtml += "<span class=\"flag-margin\">";
				strHtml += row.country;
				strHtml += "</span>";
				strHtml += "</a>";
				strHtml += "</li>";

				arrHtml[intCurrentColumn].push(strHtml);

				intCountryCount++;
			});

			//console.log(arrHtml);

			for (intIndex = 0; intIndex <= 3; intIndex++) {
				$(arrHtml[intIndex].join('')).appendTo("ul.chapters-col-" + intIndex);
			}

			//adding link
			countryTemplate = function (country){
				s = '<a title="'+country.country+'" class="chapters_link" href="'
				+country.link+'" target="_blank">'
				+'<div class="chapters c_'+country.country.toLowerCase()+'">'
				+'<span class="flag-margin">'+country.country+'</span></div></a>'
				return s;
			}

		}
	});
}

buildChapters();
