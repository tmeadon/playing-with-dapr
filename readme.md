call nginx from busybox:
`curl http://localhost:3500/v1.0/invoke/nginx-basic/method/index.html`

retrieve secret from busybox
`curl http://localhost:3500/v1.0/secrets/azurekeyvault/test`

set state from busybox
`curl -X POST -H "Content-Type: application/json" -d '[{ "key": "key1", "value": "value1"}]' http://localhost:3500/v1.0/state/statestore`

get state from busybox
`curl http://localhost:3500/v1.0/state/statestore/abc`

