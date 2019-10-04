import { composite, UIComponent } from "MPageFusion";
import { EVENTS } from "../constants/MPagesFusionCustomComponentConstants";

const {
    detailPanel: {
        DetailPanel,
        DetailPanelTitle,
        DetailPanelData
    }
} = composite;

/**
 * This is an example function used to create a small portion of the overall detail
 * panel configuration.  It shows how you can isolate logic into small functions to make
 * code easier to test and also consume.
 * @param {object} resultObj The result object we will use to create the 'Value' section
 * of our example detail panel.
 * @returns {object} The detail panel data section configuration for the 'Value' section
 * of the detail panel
 */
const createActivityDetailsSection = (resultObj) => {
    return [
        {
            id: "activityDetailSection",
            rows: [
                [
                    {
                        label: "Allergy Status",
                        text: resultObj.STATUS,
                        span: 6
                    }
                ]
            ]
        }
    ];
};

/**
 * The MPagesFusionCustomComponentDetailPanel class.
 * @class MPagesFusionCustomComponentDetailPanel
 */

export default class MPagesFusionCustomComponentDetailPanel extends UIComponent {
    /**
     * @inheritDoc
     */
    initialProps() {
        return {
            result: null,
            unloadRequestEventName: EVENTS.DETAIL_PANEL.UNLOAD,
        };
    }

    /**
     * @inheritDoc
     */
    propChangeHandlers() {
        return {
            result: (resultObj) => {
                const panel = this.getChild("detailPanel");
                const title = panel.getChild("titleContent");
                const body = panel.getChild("bodyContent");
                title.setProp("title", "Activity Details");
                if (resultObj) {
                    body.setProp("sections", createActivityDetailsSection(resultObj));
                }
            }
        };
    }

    /**
     * @inheritDoc
     */
    createChildren() {
        return [
            {
                detailPanel: new DetailPanel({
                    titleContent: new DetailPanelTitle(),
                    bodyContent: new DetailPanelData()
                })
            }
        ];
    }

    /**
     * @inheritDoc
     */
    view() {
        return this.renderChildren();
    }
}
