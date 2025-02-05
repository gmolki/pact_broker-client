### A pact between Pact Broker Client and PactFlow

#### Requests from Pact Broker Client to PactFlow

* [A request for the index resource](#a_request_for_the_index_resource)

* [A request for the index resource](#a_request_for_the_index_resource_given_the_pb:publish-provider-contract_relation_exists_in_the_index_resource) given the pb:publish-provider-contract relation exists in the index resource

* [A request to create a provider contract](#a_request_to_create_a_provider_contract)

* [A request to create a provider contract](#a_request_to_create_a_provider_contract_given_there_is_a_pf:ui_href_in_the_response) given there is a pf:ui href in the response

* [A request to create a webhook for a team](#a_request_to_create_a_webhook_for_a_team_given_a_team_with_UUID_2abbc12a-427d-432a-a521-c870af1739d9_exists) given a team with UUID 2abbc12a-427d-432a-a521-c870af1739d9 exists

* [A request to publish a provider contract](#a_request_to_publish_a_provider_contract)

#### Interactions

<a name="a_request_for_the_index_resource"></a>
Upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "get",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
PactFlow will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pb:webhooks": {
        "href": "http://localhost:1235/HAL-REL-PLACEHOLDER-PB-WEBHOOKS"
      },
      "pb:pacticipants": {
        "href": "http://localhost:1235/HAL-REL-PLACEHOLDER-PB-PACTICIPANTS"
      },
      "pb:pacticipant": {
        "href": "http://localhost:1235/HAL-REL-PLACEHOLDER-PB-PACTICIPANT-{pacticipant}"
      }
    }
  }
}
```
<a name="a_request_for_the_index_resource_given_the_pb:publish-provider-contract_relation_exists_in_the_index_resource"></a>
Given **the pb:publish-provider-contract relation exists in the index resource**, upon receiving **a request for the index resource** from Pact Broker Client, with
```json
{
  "method": "GET",
  "path": "/",
  "headers": {
    "Accept": "application/hal+json"
  }
}
```
PactFlow will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pf:publish-provider-contract": {
        "href": "http://localhost:1235/HAL-REL-PLACEHOLDER-PF-PUBLISH-PROVIDER-CONTRACT-{provider}"
      }
    }
  }
}
```
<a name="a_request_to_create_a_provider_contract"></a>
Upon receiving **a request to create a provider contract** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/contracts/provider/Bar/version/1",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "content": "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
    "contractType": "oas",
    "contentType": "application/yaml",
    "verificationResults": {
      "success": true,
      "content": "c29tZSByZXN1bHRz",
      "contentType": "text/plain",
      "format": "text",
      "verifier": "my custom tool",
      "verifierVersion": "1.0"
    }
  }
}
```
PactFlow will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  }
}
```
<a name="a_request_to_create_a_provider_contract_given_there_is_a_pf:ui_href_in_the_response"></a>
Given **there is a pf:ui href in the response**, upon receiving **a request to create a provider contract** from Pact Broker Client, with
```json
{
  "method": "put",
  "path": "/contracts/provider/Bar/version/1",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "content": "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
    "contractType": "oas",
    "contentType": "application/yaml",
    "verificationResults": {
      "success": true,
      "content": "c29tZSByZXN1bHRz",
      "contentType": "text/plain",
      "format": "text",
      "verifier": "my custom tool",
      "verifierVersion": "1.0"
    }
  }
}
```
PactFlow will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "_links": {
      "pf:ui": {
        "href": "some-url"
      }
    }
  }
}
```
<a name="a_request_to_create_a_webhook_for_a_team_given_a_team_with_UUID_2abbc12a-427d-432a-a521-c870af1739d9_exists"></a>
Given **a team with UUID 2abbc12a-427d-432a-a521-c870af1739d9 exists**, upon receiving **a request to create a webhook for a team** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/HAL-REL-PLACEHOLDER-PB-WEBHOOKS",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "description": "a webhook",
    "events": [
      {
        "name": "contract_content_changed"
      }
    ],
    "request": {
      "url": "https://webhook",
      "method": "POST",
      "headers": {
        "Foo": "bar",
        "Bar": "foo"
      },
      "body": {
        "some": "body"
      }
    },
    "teamUuid": "2abbc12a-427d-432a-a521-c870af1739d9"
  }
}
```
PactFlow will respond with:
```json
{
  "status": 201,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "description": "a webhook",
    "teamUuid": "2abbc12a-427d-432a-a521-c870af1739d9",
    "_links": {
      "self": {
        "href": "http://localhost:1234/some-url",
        "title": "A title"
      }
    }
  }
}
```
<a name="a_request_to_publish_a_provider_contract"></a>
Upon receiving **a request to publish a provider contract** from Pact Broker Client, with
```json
{
  "method": "post",
  "path": "/HAL-REL-PLACEHOLDER-PF-PUBLISH-PROVIDER-CONTRACT-Bar",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/hal+json"
  },
  "body": {
    "pacticipantVersionNumber": "1",
    "tags": [
      "dev"
    ],
    "branch": "main",
    "buildUrl": "http://build",
    "contract": {
      "content": "LS0tCnNvbWU6IGNvbnRyYWN0Cg==",
      "contentType": "application/yaml",
      "specification": "oas",
      "selfVerificationResults": {
        "success": true,
        "content": "c29tZSByZXN1bHRz",
        "contentType": "text/plain",
        "format": "text",
        "verifier": "my custom tool",
        "verifierVersion": "1.0"
      }
    }
  }
}
```
PactFlow will respond with:
```json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/hal+json;charset=utf-8"
  },
  "body": {
    "notices": [
      {
        "text": "some notice",
        "type": "info"
      }
    ],
    "_embedded": {
      "version": {
        "number": "1"
      }
    },
    "_links": {
      "pb:pacticipant-version-tags": [
        {
        }
      ],
      "pb:branch-version": {
      }
    }
  }
}
```
