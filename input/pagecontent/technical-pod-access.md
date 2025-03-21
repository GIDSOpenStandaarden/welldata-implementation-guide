Pod Access is possible via the flow described [here](pod-access.html), by authenticating the application, creating an access request, approval from the user that results in the creation of an access grant, linked to the WebId of the application.
Then calling the UMA service to exchange the id token of the client application to an access token to do a call to the pod.

We already provided an implementation which make all the underlying steps transparant for the developer. This can be viewed in the [We Are Demo Backend pod endpoints](https://github.com/VITObelgium/We-Are-Demo-Back-End?tab=readme-ov-file#pod-endpoints) section.
