import MPagesFusionCustomComponent from "../../../main/js/cerner/mpagedev/component/MPagesFusionCustomComponent";
/*
 * Wrap all Specs in an all encompassing describe block
 */
describe("The MPagesFusionCustomComponent Object", () => {
    /**
     * Shared Spec Elements
     * Define any variables which can be used across all tests.
     **/
    var testComp = null;

    /**
     * This beforeEach is used to define the spies which can be used across all Specs.
     * This function is guaranteed to be called before each and every spec, so all
     * spies will be recreated before each spec to prevent false positives.
     **/
    beforeEach(() => {
        /**
         * Define the spies for all of the global objects which can be instantiated.
         * Creating the spies here will ensure they are fresh for each spec
         **/

        ScriptReply = jasmine.createSpyObj("ScriptReplySpy", ["getResponse", "getStatus"]); // eslint-disable-line no-global-assign        
        CapabilityTimerSpy = jasmine.createSpyObj("CapabilityTimerSpySpy", ["capture", "addMetaData"]); // eslint-disable-line no-global-assign

        /**
         * Define the spies for all of the global functions and namespaces
         * Creating the spies here will ensure they are fresh for each spec
         */
        APPLINK = jasmine.createSpy("APPLINKSpy"); // eslint-disable-line camelcase
        CERN_EventListener = jasmine.createSpyObj("CERN_EventListenerSpy", ["addListener"]); // eslint-disable-line camelcase
        CERN_Platform = jasmine.createSpyObj("CERN_PlatformSpy", ["inMillenniumContext"]); // eslint-disable-line camelcase
        logger = jasmine.createSpyObj("loggerSpy", ["logWarning", "logError"]);
        MP_Util = jasmine.createSpyObj("MP_UtilSpy", ["GetCodeSetAsync"]); // eslint-disable-line camelcase
        /**
         * Place the spies for instantiating global objects here and define the spy object
         * returned which those objects are instantiated
         **/

        /**
         * Instantaite the object being tested here so it need not be repeated in each
         * describe block.  If a specialized instance of this object is needed in a describe
         * block it can be redefined there.
         **/

        /**
         * Create spy functionality for the instantiated object which can be used across all specs
         **/
        testComp = new MPagesFusionCustomComponent();
        testComp.addFilterMappingObject = jasmine.createSpy("addFilterMappingObject");
    });

    describe("The MPagesFusionCustomComponent constructor", () => {
        it("sets the component load timer name", () => {
            expect(testComp.setComponentLoadTimerName).toHaveBeenCalledWith("USR:MPG.MPagesFusionCustomComponent - load component");
		});
        it("sets the component render timer name", () => {
            expect(testComp.setComponentRenderTimerName).toHaveBeenCalledWith("ENG:MPG.MPagesFusionCustomComponent - render component");
        });
	});
});
