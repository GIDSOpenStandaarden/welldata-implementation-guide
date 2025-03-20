### Launch mechanismen
* HTI  / Koppeltaal / SMART on FHIR
  * Is een id_token porteerbaar?
  * Id_token_hint bij het 2e keer inloggen
* Idp / SSO
  *  Zie Pod Access.

### GIDS Health Tools Interoperability
The **HTI 2.0** (Health Tools Interoperability) specification is part of the GIDS open standaarden, which defines standards for secure and efficient application interoperability within healthcare systems. The main focus of HTI 2.0 is to facilitate **secure and seamless context launches** between healthcare applications. Here is a summary of its key aspects:

 * **Cross context launches** HTI allows for launching between different types of systems.
 * **Data minimization** Launches must be limited in the information that is shared
 * **Privacy first** No personal information should be shared.

For launching between applications, the welldata project makes use of HTI 2.0. Please refer to the [HTI 2.0 spec](https://github.com/GIDSOpenStandaarden/GIDS-HTI-Protocol/blob/master/HTI_2.0.md) for details.

### Specific implementation notes:
Within welldata, the following assumptions are made on the implementation of HTI:
 * The *user reference* will be a reference to the *Web-ID* of the user.
 * The *aud* must reference the *Base URL of the receiving application*
 * The *iss* must reference the *Base URL of the launching application*
 * The *public key discovery* must work with [OpenID Connect Discovery 1.0](https://openid.net/specs/openid-connect-discovery-1_0.html), in the sens that the *aud* and *iss* must be discoverable with `.well-known/openid-configuration` with a valid `jwks_uri` endpoint.




