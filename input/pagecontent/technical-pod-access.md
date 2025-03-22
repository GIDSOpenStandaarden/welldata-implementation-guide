Pod Access is possible via the flow described [here](pod-access.html), by authenticating the application, creating an access request, approval from the user that results in the creation of an access grant, linked to the WebId of the application.
Then calling the UMA service to exchange the id token of the client application to an access token to do a call to the pod.

We already provided an implementation which make all the underlying steps transparant for the developer. This can be viewed in the [We Are Demo Backend pod endpoints](https://github.com/VITObelgium/We-Are-Demo-Back-End?tab=readme-ov-file#pod-endpoints) section.

The user needs to be redirected to the We Are AMA (https://we-are-acc.vito.be/en/access-request) and two parameters need to be provided:

```
    requestVcUrl    //id of the access request
    redirectUrl     //the redirect url after the user has provided his/her consent
```

The `redirectUrl` will make sure the user returns back from the original page after consenting. An extra parameter will be provided when returning, which will hold the access grant: `access-grant-id`. This access grant needs to be exchanged for an access token to access the pod.