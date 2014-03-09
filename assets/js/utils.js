function formatLatitude(lat) {
    if (isNaN(lat)) {
        return "&ndash;";
    }
    return Math.abs(lat).toFixed(1) + "\u00B0\u2009" + (lat < 0 ? "(S)" : "(N)");
}

function formatLongitude(lon) {
    if (isNaN(lon)) {
        return "&ndash;";
    }
    return Math.abs(lon).toFixed(1) + "\u00B0\u2009" + (lon < 0 ? "(W)" : "(E)");
}
