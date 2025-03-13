@ee
Feature: SSO
  Background:
    Given the following "accounts" exist:
      | name             | slug          | sso_organization_id                   | sso_organization_domains | sso_session_duration |
      | Keygen           | keygen-sh     |                                       |                          |                      |
      | Example          | example-com   |                                       |                          |                      |
      | Evil Corp        | ecorp-example | test_org_59f4ac10f7b6acbf3304f3fc2211 | ecorp.example            | 43200                |
      | Lumon Industries | lumon-example | test_org_669aa06c521982d5c12b3eb74bf0 | lumon.example            |                      |

  Scenario: We receive a successful callback for an existing admin
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And the first "admin" of account "ecorp-example" has the following attributes:
      """
      { "email": "elliot@ecorp.example" }
      """
    And the SSO callback code "test_123" returns the following profile:
      """
      {
        "id": "test_prof_61bbd8f6eedbaff8b040d1c98ba9",
        "organization_id": "test_org_59f4ac10f7b6acbf3304f3fc2211",
        "connection_id": "test_conn_565647f76ab997ed8a62444451c6",
        "idp_id": "test_idp_332389f4fb8a9e823cb8308a2179",
        "email": "elliot@ecorp.example",
        "first_name": "Elliot",
        "last_name": "Alderson"
      }
      """
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?code=test_123"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/ecorp-example"
    And the response headers should contain "Set-Cookie" with an encrypted cookie:
      """
      session_id=$sessions[0]; domain=keygen.sh; path=/; expires=Mon, 28 Feb 2552 12:00:00 GMT; secure; httponly; samesite=None; partitioned;
      """
    And the account "ecorp-example" should have 1 "admin"
    And the last "admin" of account "ecorp-example" should have the following attributes:
      """
      {
        "sso_profile_id": "test_prof_61bbd8f6eedbaff8b040d1c98ba9",
        "sso_connection_id": "test_conn_565647f76ab997ed8a62444451c6",
        "sso_idp_id": "test_idp_332389f4fb8a9e823cb8308a2179",
        "email": "elliot@ecorp.example",
        "first_name": "Elliot",
        "last_name": "Alderson"
      }
      """
    And the account "ecorp-example" should have 1 "session"
    And the last "session" of account "ecorp-example" should have the following attributes:
      """
      {
        "bearer_type": "User",
        "bearer_id": "$users[0]",
        "token_id": null,
        "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0",
        "ip": "127.0.0.1",
        "last_used_at": null
      }
      """
    And time is unfrozen

  Scenario: We receive a successful callback for an existing user
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And the account "ecorp-example" has 1 "user" with the following:
      """
      { "email": "elliot@ecorp.example" }
      """
    And the SSO callback code "test_123" returns the following profile:
      """
      {
        "id": "test_prof_61bbd8f6eedbaff8b040d1c98ba9",
        "organization_id": "test_org_59f4ac10f7b6acbf3304f3fc2211",
        "connection_id": "test_conn_565647f76ab997ed8a62444451c6",
        "idp_id": "test_idp_332389f4fb8a9e823cb8308a2179",
        "email": "elliot@ecorp.example",
        "first_name": "Elliot",
        "last_name": "Alderson"
      }
      """
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?code=test_123"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/ecorp-example"
    And the response headers should contain "Set-Cookie" with an encrypted cookie:
      """
      session_id=$sessions[0]; domain=keygen.sh; path=/; expires=Mon, 28 Feb 2552 12:00:00 GMT; secure; httponly; samesite=None; partitioned;
      """
    And the account "ecorp-example" should have 1 "admin"
    And the account "ecorp-example" should have 1 "user"
    And the last "user" of account "ecorp-example" should have the following attributes:
      """
      {
        "sso_profile_id": "test_prof_61bbd8f6eedbaff8b040d1c98ba9",
        "sso_connection_id": "test_conn_565647f76ab997ed8a62444451c6",
        "sso_idp_id": "test_idp_332389f4fb8a9e823cb8308a2179",
        "email": "elliot@ecorp.example",
        "first_name": "Elliot",
        "last_name": "Alderson"
      }
      """
    And the account "ecorp-example" should have 1 "session"
    And the last "session" of account "ecorp-example" should have the following attributes:
      """
      {
        "bearer_type": "User",
        "bearer_id": "$users[1]",
        "token_id": null,
        "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0",
        "ip": "127.0.0.1",
        "last_used_at": null
      }
      """
    And time is unfrozen

  Scenario: We receive a successful callback for a new user
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And the SSO callback code "test_123" returns the following profile:
      """
      {
        "id": "test_prof_b2c45c1af54f9cad85edf6104091",
        "organization_id": "test_org_669aa06c521982d5c12b3eb74bf0",
        "connection_id": "test_conn_6ca55425d9b4842cdd3ba3f1ea9c",
        "idp_id": "test_idp_34d99d8985608b3d0297183a1265",
        "email": "mark@lumon.example",
        "first_name": "Mark",
        "last_name": "Scout"
      }
      """
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?code=test_123"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/lumon-example"
    And the response headers should contain "Set-Cookie" with an encrypted cookie:
      """
      session_id=$sessions[0]; domain=keygen.sh; path=/; expires=Mon, 28 Feb 2552 08:00:00 GMT; secure; httponly; samesite=None; partitioned;
      """
    And the account "lumon-example" should have 2 "admins"
    And the last "admin" of account "lumon-example" should have the following attributes:
      """
      {
        "sso_profile_id": "test_prof_b2c45c1af54f9cad85edf6104091",
        "sso_connection_id": "test_conn_6ca55425d9b4842cdd3ba3f1ea9c",
        "sso_idp_id": "test_idp_34d99d8985608b3d0297183a1265",
        "email": "mark@lumon.example",
        "first_name": "Mark",
        "last_name": "Scout"
      }
      """
    And the account "lumon-example" should have 1 "session"
    And the last "session" of account "lumon-example" should have the following attributes:
      """
      {
        "bearer_type": "User",
        "bearer_id": "$users[1]",
        "token_id": null,
        "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0",
        "ip": "127.0.0.1",
        "last_used_at": null
      }
      """
    And time is unfrozen

  Scenario: We receive a successful callback for an outside user
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And the SSO callback code "test_123" returns the following profile:
      """
      {
        "id": "test_prof_3c21855edd1ca17939dc98e0da3e",
        "organization_id": "test_org_59f4ac10f7b6acbf3304f3fc2211",
        "connection_id": "test_conn_cf35b523d7089a392774e9c7995e",
        "idp_id": "test_idp_ad1759c92a6a9207a6a44da4aa9e",
        "email": "mr@fsociety.example",
        "first_name": "Mr",
        "last_name": "Robot"
      }
      """
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?code=test_123"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/sso/error?code=SSO_INVALID_DOMAIN"
    And the response headers should not contain "Set-Cookie"
    And the account "ecorp-example" should have 1 "admin"
    And the account "ecorp-example" should have 0 "sessions"
    And time is unfrozen

  Scenario: We receive a callback for an unrecognized organization
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And the SSO callback code "test_123" returns the following profile:
      """
      {
        "id": "test_prof_aa6fb68cd146993adf8d0bebe192",
        "organization_id": "test_org_7dcd28cc7c6e8924a43d61b9072f",
        "connection_id": "test_conn_490e20b5ef728d5da105c7491ad4",
        "idp_id": "test_idp_c1e45c0f15378390824adc56accb",
        "email": "john@example.com",
        "first_name": "John",
        "last_name": "Doe"
      }
      """
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?code=test_123"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/sso/error?code=SSO_INVALID_ACCOUNT"
    And the response headers should not contain "Set-Cookie"
    And there should be 0 "sessions"
    And time is unfrozen

  Scenario: We receive a callback with an invalid callback code
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And the SSO callback code "test_123" returns an "access_denied" error
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?code=test_123"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/sso/error?code=SSO_ACCESS_DENIED"
    And the response headers should not contain "Set-Cookie"
    And there should be 0 "sessions"
    And time is unfrozen

  Scenario: We receive a failed callback
    Given time is frozen at "2552-02-28T00:00:00.000Z"
    And I use user agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0"
    When I send a GET request to "//auth.keygen.sh/sso?error=connection_invalid"
    Then the response status should be "303"
    And the response headers should contain "Location" with "https://portal.keygen.sh/sso/error?code=SSO_CONNECTION_INVALID"
    And the response headers should not contain "Set-Cookie"
    And there should be 0 "sessions"
    And time is unfrozen
