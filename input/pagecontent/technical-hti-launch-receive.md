### Verifying the signature.

The public keys should be retrieved by the following procedure:

* Fetch the `<iss>/.well-known/openid-configuration` as JSON
* Look for the `jwks_uri` value
* Fetch the JWKS object from the `jwks_uri`
* Decode and parse the header of the JWT and extract the `kid` header.
* Locate the right public key in the JWKS object.
* Use the matching public key to verify the JWT.

Example code:

```javascript
const iss = atob(jwt.split('.')[0])
const open_id_config = await fetch(`${iss}/..well-known/openid-configuration`).then(data => data.json())
const own_url = 'https//module.example.com'
const issuer = open_id_config['issuer']
const jwks_uri = open_id_config['jwks_uri']
const JWKS = jose.createRemoteJWKSet(new URL(jwks_uri))

const {payload, protectedHeader} = await jose.jwtVerify(jwt, JWKS, {
  issuer: ussuer,
  audience: own_url,
})
```

### Other important checks

In addition to verifying the signature, the JWT payload contains fields that are important to validate.

| JWT claim (attribute) | Details                                                                                                                                  | Implementation                                    |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| exp (expiration time) | After this time, the JWT is no longer valid                                                                                              | Is often done automatically by JWT libraries      |
| iat (issued at)       | Issue date, it must not be in the future                                                                                                 | Is often done automatically by JWT libraries      |
| jti (JWT ID)          | Unique identifier for this JWT. The jti values used must be tracked. If a jti value has already been consumed, the JWT must be rejected. | Should most likely be implemented in custom logic |
