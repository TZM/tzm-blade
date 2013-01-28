blade.Runtime.loadTemplate("guide.blade", function(err, tmpl) {
    tmpl({
        'nav1': {
            'Home': '/',
            'About Us': '/about',
            'Contact': '/contact'
        }
    }, function(err, html) {
        if(err) throw err;
            console.log(html);
    });
});
