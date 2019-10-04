import FusionComponentScriptRequest from "FusionComponentScriptRequest"; // eslint-disable-line no-unused-vars

/**
 * patientLookup is a generic implementation of a data retrieval function.
 * @param {FusionComponent} component The FusionComponent needed in order to execute the data request
 * @returns {Promise} The promise used to resolve or reject the data request response
 */
const patientLookup = component => new Promise((resolve, reject) => {
    const scriptRequest = new FusionComponentScriptRequest();
    scriptRequest.setName("Patient ID Lookup Request");
    scriptRequest.setArtifactInfo({
        artifactId: "MPagesFusionCustomComponent",
        functionName: "patientLookup"
    });

    // This MP_RETRIEVE_MOCK_DATA is a mock script that returns mock data so that the component load in an MPage view.
    // Passing in a "F" would make the script return a failure.
    // A "Z" value would make the script return no data and a Z status.
    // TODO: Replace this script name with your real script.
    scriptRequest.setProgramName("chc_hi_patient_lookup:GROUP1");
    scriptRequest.setParameterArray(
        [
            "^MINE^",
            "^1424e81d-8cea-4d6b-b140-d6630b684a58^",
            "^877307a0-b5f5-4a01-9d4b-9fead6bcf788^",
            132676.0
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

export default patientLookup;
