import FusionComponentScriptRequest from "FusionComponentScriptRequest"; // eslint-disable-line no-unused-vars

/**
 * patientMedications is a generic implementation of a data retrieval function.
 * @param {FusionComponent} component The FusionComponent needed in order to execute the data request
 * @returns {Promise} The promise used to resolve or reject the data request response
 */
const patientMedications = component => new Promise((resolve, reject) => {
    const scriptRequest = new FusionComponentScriptRequest();
    scriptRequest.setName("Patient Medication Request");
    scriptRequest.setArtifactInfo({
        artifactId: "MPagesFusionCustomComponent",
        functionName: "patientMedications"
    });

    scriptRequest.setProgramName("chc_hi_patient_medications:GROUP1");
    scriptRequest.setParameterArray(
        [
            "^MINE^",
            "^1424e81d-8cea-4d6b-b140-d6630b684a58^",
            "^002c0901-e16f-464c-bfb0-44f469f5780a^"
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

export default patientMedications;
