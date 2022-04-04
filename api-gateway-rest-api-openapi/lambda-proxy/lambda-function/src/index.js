"use strict";

console.log("Initiated Lambda Invocation ...");

// const { v4: UUID } = require("uuid");

/*** Handler (Async Handler(s) *should* return a non-awaited promise) */
module.exports.handler = async (event, context) => {
    console.debug("[Debug]", "Event", event);
    console.debug("[Debug]", "Context", context);

    console.log("[Debug] Environment Variable(s)" + ":", JSON.stringify(process.env, null, 4));

    return new Promise((resolve) => {
        resolve({
                statusCode: 200,
                body: JSON.stringify(
                    {
                        /// uid: UUID(),
                        message: "Awaiting Code Deployment"
                    },
                    null, 4
                )
            }
        );
    });
};
