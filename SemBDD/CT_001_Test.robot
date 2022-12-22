*** Settings ***
Library             RequestsLibrary
Library             JSONLibrary
Library             json
Library             Collections
Library             FakerLibrary
Suite Setup         create session    gorest    https://gorest.co.in
Suite Teardown      Delete all sessions

*** Variables ***
${token}        Bearer 7c615336e13c4d21e315587451629e5d9bea85fd865580412d576774265edd6b
${start_name}   Charles Fink

*** Test Cases ***
Test: Post Method
    ${body}=            create dictionary       name=${start_name}    email=CharlesFink11@jourapide.com    gender=male     status=active
    ${header}=          create dictionary       Content-Type=application/json   Authorization=${token}
    ${body_json}        Json.Dumps              ${body}
    ${response_post}=   post on session         gorest   /public/v2/users    headers=${header}    data=${body_json}

    should be equal as integers                 ${response_post.status_code}        201
    ${id}=   get from dictionary                ${response_post.json()}             id
    ${name}=    get from dictionary             ${response_post.json()}             name
    should be equal as strings                  ${name}                             ${start_name}

    log to console                              ${response_post.content}

    set global variable                         ${id}
    set global variable                         ${name}
    set global variable                         ${header}
    set global variable                         ${body}

Test: Get Method
    ${response_get}=    get on session          gorest    /public/v2/users/${id}    headers=${header}
    should be equal as integers                 ${response_get.status_code}         200
    dictionary should contain item              ${response_get.json()}              name      ${name}

    log to console                              ${response_get.content}

Test: Put Method
    ${body_put}=        create dictionary       name=Anne Fink
    ${json_put}=        json.dumps              ${body_put}
    ${response_put}=    put on session          gorest    /public/v2/users/${id}    data=${json_put}    headers=${header}

    should be equal as integers                 ${response_put.status_code}         200
    dictionary should contain item              ${response_put.json()}              name      Anne Fink

    log to console                              ${response_put.content}

Test: Patch Method
    ${body_patch}=       create dictionary       gender=female
    ${json_patch}=       json.dumps              ${body_patch}
    ${response_patch}=   patch on session        gorest    /public/v2/users/${id}   data=${json_patch}    headers=${header}

    should be equal as integers                  ${response_patch.status_code}      200
    dictionary should contain item               ${response_patch.json()}           gender    female

    log to console                                ${response_patch.content}

Test: Delete Method
    ${response_delete}=  delete on session       gorest    /public/v2/users/${id}    headers=${header}
    should be equal as integers                  ${response_delete.status_code}      204

    log to console                               ${response_delete.content}