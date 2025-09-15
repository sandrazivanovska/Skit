Feature: List Specialties API (GET /specialties)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: List specialties successfully returns 200 when specialties exist
    Given path 'specialties'
    When method GET
    Then status 200
    * assert response.length > 0
    * assert response[0].id != null
    * assert response[0].name != null

  Scenario: List specialties returns 404 when list is empty
    # First, delete all existing specialties to create empty state
    Given path 'specialties'
    When method GET
    
    # If specialties exist, delete them all
    * if (responseStatus == 200) eval
    """
    var ids = response.map(function(s){ return s.id; });
    ids.forEach(function(id){
      karate.log('Deleting specialty:', id);
      karate.call({
        method: 'DELETE',
        url: baseUrl + '/specialties/' + id,
        headers: { Authorization: headers.Authorization }
      });
    });
    """
    
    # Verify empty list returns 404
    Given path 'specialties'
    When method GET
    Then status 404

  Scenario: List specialties with invalid authentication returns 401
    Given path 'specialties'
    * header Authorization = 'Basic invalid_credentials'
    When method GET
    Then status 401

  Scenario: List specialties without authentication returns 401
    Given path 'specialties'
    * header Authorization = null
    When method GET
    Then status 401

  Scenario: List specialties with malformed URL returns 404
    Given path 'specialties/invalid'
    When method GET
    Then status 404

  Scenario: List specialties with trailing slash returns 200
    Given path 'specialties/'
    When method GET
    Then status 200
