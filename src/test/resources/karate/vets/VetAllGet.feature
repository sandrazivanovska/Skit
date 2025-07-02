Feature: List Vets API (GET /vets)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: List vets successfully returns 200 when vets exist
    Given path 'vets'
    When method GET
    Then status 200
    * assert response.length > 0

  Scenario: Delete all vets and verify empty list returns 404
    # 1) Fetch all existing vets
    Given path 'vets'
    When method GET

    # 2) If any vets exist (status 200), delete them all
    * if (responseStatus == 200) eval
    """
    var ids = response.map(function(v){ return v.id; });
    ids.forEach(function(id){
      karate.log('Deleting vet:', id);
      karate.call({
        method: 'DELETE',
        url: baseUrl + '/vets/' + id,
        headers: { Authorization: headers.Authorization }
      });
    });
    """

    # 3) Verify no vets remain
    Given path 'vets'
    When method GET
    Then status 404
