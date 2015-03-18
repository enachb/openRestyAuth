# openRestyAuth
Sample openresty implementation on how to login, issue tokens and check authorizations

## Request a token

`
$ curl 'http://localhost:8081/login?user=oink&pw=oink'
  {"token":"1426643798:c262fd2a7540e2282df4d28c0e36194d3667a645"}
`

## Call an API method

`
$curl 'http://localhost:8081/api/vps/v1/metrics/iceBlock?token=<INSERT ISSUED TOKEN HERE>'
  [{"name":"FA92571A9247FEF1BE81C7FA0A8B9494","timestamp":"1426634102610","powerLimitW":6302.7,"loadPsuW":6302.7,"loadCacheW":-98.69999999999983,"loadTotal....
  `
