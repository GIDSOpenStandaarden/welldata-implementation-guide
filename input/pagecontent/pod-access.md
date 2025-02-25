### Toegang op PODs tijdens het aanmelden bij de applicatie
  * Web-ID toepassing authenticeert zich met zijn Web-ID
  * Protected app: gebruiker logt in via OIDC:
    * Start OIDC flow bij ACM (voor NL?, of federated)
      * /authorize > code
      * /token > id_token (web-id-persoon), access_token
    * Start een OAuth flow WeAre, client credentials:
      * /tok en (client_id, client_secret) > access_token
    * Start access_request naar access_grant_service, issue endpoint:
      * /issue (access_request, web-id-app, url, web-id-persoon) > code
      * /credential?code=x > acces_grant (VC)
    * POD:
      * GET, PUT, POST Authorization: acces_grant
