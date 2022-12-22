*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         json
Suite Setup     Create Session  typicode  https://jsonplaceholder.typicode.com
Suite Teardown  Delete all sessions


*** Test Cases ***
requests: Should have a name and belong to a company with a slogan
  ${resp}=        get on session            typicode              /users/1
  Should Be Equal As Integers               ${resp.status_code}   200
  ${name}=        Get From Dictionary       ${resp.json()}        name
  Should Be Equal As Strings                ${name}               Leanne Graham
  ${co}=          Get From Dictionary       ${resp.json()}        company
  ${co_slogan}=   Get From Dictionary       ${co}                 catchPhrase

  Should Be Equal As Strings  ${co_slogan}  Multi-layered client-server neural-net
  ${json}=        Dumps                     ${resp.json()}        indent=${4}
  Log to Console  ${json}