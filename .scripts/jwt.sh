#!/bin/bash

jq -sR 'split(".")[0,1] | gsub("-";"+") | gsub("_";"/") | @base64d | fromjson
    | if has("exp")       then .exp       |= todate else . end
    | if has("iat")       then .iat       |= todate else . end
    | if has("nbf")       then .nbf       |= todate else . end
    | if has("auth_time") then .auth_time |= todate else . end' "$@"

