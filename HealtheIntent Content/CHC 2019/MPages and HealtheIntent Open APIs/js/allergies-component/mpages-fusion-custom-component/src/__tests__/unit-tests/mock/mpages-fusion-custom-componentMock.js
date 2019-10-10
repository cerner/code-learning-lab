/* eslint-disable no-unused-vars */
const m_localeObjectName = "en_US";// eslint-disable-line mp-camelcase
/**
 * Global variables and Objects
 * Define any global vairables and objects which are accessed globally
 */
const criterion = {/* eslint-disable mp-camelcase */
    person_id: 123.0,
    provider_id: 456.0,
    ppr_cd: 789.0,
    encntr_id: 789.0,
    executable: "test.exe"
};

var i18n = {  // eslint-disable-line no-var
    discernabu: {}
};

/* eslint-enable no-unused-vars */
var CERN_BrowserDevInd = 0;
var EventListener = {
    EVENT_ORDER_ACTION: "EVENT_ORDER_ACTION"
};

/**
 * Prototyped Objects
 * Define the objects which are being used as a prototype as well as the functions of the prototype
 */
var FusionComponent = {
    FusionComponent: function () {
    }
};
FusionComponent.FusionComponent.prototype = jasmine.createSpyObj("FusionComponent.prototypeSpy",
    [
        "constructor",
        "setComponentLoadTimerName",
        "setComponentRenderTimerName",
        "setIncludeLineNumber",
        "refreshComponent",
        "getBodyContent"
    ]
);
FusionComponent.FusionComponent.STATUS_TYPES = {
    SUCCESS: "SUCCESS",
    NO_DATA: "NO_DATA",
    ERROR: "ERROR"
};

/**
 * Global Functions and Namespaces
 * Define any functions or namespace functions which are available globally and are called from within the artifact
 */
var APPLINK;
var logger;
var CERN_EventListener;
var CERN_Platform;
var MP_Util = jasmine.createSpyObj("MP_UtilSpy", ["setObjectDefinitionMapping"]);
var FusionComponentScriptRequest = function () {};
var FusionComponentScriptRequestSpy;
var ComponentScriptRequest = function () {
};
var ComponentScriptRequestSpy;
var ScriptRequest = function () {
};
var ScriptRequestSpy;
var ScriptReply;
var RTMSTimer = function () {
};
var RTMSTimerSpy;
var promiseSpy;
var ErrorModal = function () {
};
var ErrorModalSpy;
var MP_ModalDialog;
var InfoButton;
var CapabilityTimer = function () {
};
var CapabilityTimerSpy;

Date.prototype.setISO8601 = function (string) { // eslint-disable-line no-extend-native
    var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
        "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\\.([0-9]+))?)?" +
        "Z?)?)?)?";
    var d = string.match(new RegExp(regexp));

    var date = new Date(d[1], 0, 1);

    // set the times
    if (d[7]) {
        date.setUTCHours(d[7]);
    }
    else {
        date.setUTCHours(0);
    }
    if (d[8]) {
        date.setUTCMinutes(d[8]);
    }
    else {
        date.setUTCMinutes(0);
    }
    if (d[10]) {
        date.setUTCSeconds(d[10]);
    }
    else {
        date.setUTCSeconds(0);
    }
    if (d[12]) {
        date.setUTCMilliseconds(Number("0." + d[12]) * 1000);
    }
    else {
        date.setUTCMilliseconds(0);
    }

    // set year before month/date
    if (d[1]) {
        date.setUTCFullYear(d[1]);
    }

    // set date before month
    if (d[5]) {
        date.setUTCDate(d[5]);
    }
    if (d[3]) {
        date.setUTCMonth(d[3] - 1);
    }

    this.setTime(date.getTime());
};

// Provide a very basic implementation for Date.format so we can verify the correct values were used
Date.prototype.format = function (mask) { // eslint-disable-line no-extend-native
    if (mask === "mediumdate4yr2") {
        return this.getFullYear() + "-" + (this.getMonth() + 1) + "-" + this.getDate();
    }
    else {
        return (this.getHours() + 1) + ":" + (this.getMinutes() + 1);
    }
};
