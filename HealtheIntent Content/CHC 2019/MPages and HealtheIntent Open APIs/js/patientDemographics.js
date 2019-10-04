import FusionComponentScriptRequest from "FusionComponentScriptRequest"; // eslint-disable-line no-unused-vars

/**
 * patientDemographics is a generic implementation of a data retrieval function.
 * @param {FusionComponent} component The FusionComponent needed in order to execute the data request
 * @returns {Promise} The promise used to resolve or reject the data request response
 */
const patientDemographics = component => new Promise((resolve, reject) => {
    const scriptRequest = new FusionComponentScriptRequest();
    scriptRequest.setName("Patient Demographics Lookup");
    scriptRequest.setArtifactInfo({
        artifactId: "MPagesFusionCustomComponent",
        functionName: "patientDemographics"
    });

    scriptRequest.setProgramName("chc_hi_patient_demographics:GROUP1");
    scriptRequest.setParameterArray(
        [
            "^MINE^",
            "^1424e81d-8cea-4d6b-b140-d6630b684a58^",
            "^0004200f-9353-40e8-b953-291263369db1^"
        ]
    );
    scriptRequest.setResponseHandler((reply) => {
        if (reply.getStatus() !== "F") {
            resolve(reply);
        } else {
            reject(reply);
        }
    });
    scriptRequest.setComponent(component);
    scriptRequest.performRequest();
});

export default patientDemographics;
