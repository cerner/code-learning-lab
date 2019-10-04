import { FusionComponent } from "FusionComponent";
import MP_Util from "MP_Util"; // eslint-disable-line camelcase
import { EVENTS } from "./constants/MPagesFusionCustomComponentConstants";
import MPagesFusionCustomComponentBody
    from "./controls/MPagesFusionCustomComponentBody";
import getData from "./data-retrieval";
import patientAllergies from "./data-retrieval/patientAllergies";

const STATUS_TYPES = FusionComponent.STATUS_TYPES;
// TODO: Change the NAMESPACE as per the component.
const NAMESPACE = "mpages-fcc";

/**
 * Definition of the MPagesFusionCustomComponent class.
 * @class MPagesFusionCustomComponent
 */
export default class MPagesFusionCustomComponent extends FusionComponent {
    constructor() {
        super(NAMESPACE);
        this.setComponentLoadTimerName("USR:MPG.MPagesFusionCustomComponent - load component");
        this.setComponentRenderTimerName("ENG:MPG.MPagesFusionCustomComponent - render component");
        this.setIncludeLineNumber(true);
        this._state = {};
    }

    /**
     * @inheritDoc
     */
    initialProps() {
        // TODO: Determine which sections of the component you need, consult the documentation to update this accordingly
        return {
            componentMenu: [
                // TODO: Provide component menu options, if any (otherwise delete)
                {
                    display: "Menu Option Example",
                    isSelected: false,
                    fire: EVENTS.MENU.MENU_SELECTION
                }
            ],
            bodyContent: new MPagesFusionCustomComponentBody()
        };
    }

    /**
     * @inheritDoc
     */
    afterCreate() {
        /* TODO: Determine if you would to wire events between different sections of your component and add it here otherwise delete this function */
        // Example handler for the menu item
        this.on(EVENTS.MENU.MENU_SELECTION, (source, menuItem, isSelected) => {
            alert(`Menu Item is selected: ${isSelected}`); // eslint-disable-line no-alert
        });

        return this;
    }

    /**
     * @inheritDoc
     */
    preProcessing() {
        super.preProcessing();
        /*
        * const currentPreferences = this.getPreferencesObj();
        * // `preferences` has the current preferences set for the component, empty initially, unless set using:
        *
        * this.setPreferencesObj(currentPreferences);
        * this.savePreferences(true);
        * */
    }

    /*
     * This is an example function used in conjunction with the loadFilterMappings function.  It
     * is used to set specific Bedrock settings for a component.  This function should be removed
     * before your component is released.
     * @returns {undefined} This function does not return a value
     */
    setFilterOptions(options) {
        this._state.options = options;
        return this;
    }

    /**
     * This function is used to load the filters that are associated to this component.  Each filter mapping
     * is associated to one specific component setting.  The filter mapping lets the MPages architecture know
     * which functions to call for each filter.
     * @returns {undefined} This function does not return a value
     */
    loadFilterMappings() {
        // Example - Please remove prior to release
        // The addFilterMappingObject function takes two arguments.  The first is the name of the filter that is being mapped.
        // This name should be unique to the collection of filters.  The second argument is a simple object that contains
        // three fields; the function to call when applying the setting, the type of data that the filter is and finally the
        // field in the filter object where this data can be found.
        // TODO: Change this to reflect the appropriate filter_mean of Options in your Custom Component Bedrock csv

        this.addFilterMappingObject("FUSION_CUSTOM_COMP_OBJ_1", {
            setFunction: this.setFilterOptions,
            type: "STRING",
            field: "FREETEXT_DESC"
        });
    }

    /* Main rendering functions */

    /**
     * This is the MPagesFusionCustomComponent implementation of the retrieveComponentData function.
     * It creates the necessary parameter array for the data acquisition script call and the associated Request object.
     * This function will be called from the MPages architecture when it is ready for the component to render its content.
     * @returns {undefined} This function does not return a value
     */
    retrieveComponentData() {
        patientAllergies(this)
            .then((reply) => {
                if (reply.getStatus() === "S") {
                    this.setStatus(STATUS_TYPES.SUCCESS);
                    this.renderComponent(reply.getResponse());
                } else {
                    this.setStatus(STATUS_TYPES.NO_DATA);
                    this.finalizeComponent();
                }
            })
            .catch((reply) => {
                this.setStatus(STATUS_TYPES.ERROR);
                this.finalizeComponent();
            });
    }

    /**
     * This is the MPagesFusionCustomComponent implementation of the renderComponent function.  It takes the information retrieved
     * from the script call and renders the component's visuals.
     * @param {ScriptReply} reply The ScriptReply object returned from the call to either FusionComponentScriptRequest or ScriptRequest
     * @returns {undefined} This function does not return a value
     */
    renderComponent(reply) {
        //console.log("reply");
        //console.log(reply);
        // TODO: Set necessary props on the parts of your component.
        this.getBodyContent().setProp("data", reply);

        // Finalize with the result count by passing the count value to the finalizeComponent */
        this.finalizeComponent(reply.ALLERGY_CNT);
    }
}

/**
 * This piece of code is crucial in order to Load your component in an MPage view.
 * The MPage view architecture has a list of filter mean obtained from
 * the MPage created in Bedrock ViewBuilder wizard.
 */
// TODO: Change this to reflect your custom component's filter mean
MP_Util.setObjectDefinitionMapping("FUSION_CUSTOM_COMP_1", MPagesFusionCustomComponent);
