// NOTE: All functions which are considered helpers should be able to be utilized across multiple
// files.  If you find that a helper is so very specific to one consumer, migrate that helper to that
// consumer source file as it gains no benefits from being placed in a helper file. For the example the below
// function can be used across different controls displaying date.

/**
 * Creates the proper display for a given ISO8601 date string.
 * @param {string} iso8601Date The ISO8601 string representation of the date we are trying to format
 * @returns {string} A formatted string based on the aforementioned logic.
 */
const formatDateDisplay = (iso8601Date) => {
    if (!iso8601Date) {
        return "--";
    }
    const date = new Date();
    date.setISO8601(iso8601Date);

    // Default functionality is to just return the properly formatted date string
    return `${date.format("mediumdate4yr2")} ${date.format("shortTime")}`;
};

export default formatDateDisplay;
